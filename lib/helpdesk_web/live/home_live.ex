defmodule HelpdeskWeb.HomeLive do
  use HelpdeskWeb, :live_view
  use Phoenix.HTML

  alias Helpdesk.Tickets
  import AshPhoenix.LiveView

  @impl true
  def mount(params, session, socket) do
    socket =
      assign_new(socket, :actor, fn ->
        HelpdeskWeb.Plugs.FakeUser.refetch_user(session)
      end)

    socket =
      case socket.assigns.actor do
        nil ->
          socket
          |> keep_live(
            :me,
            fn socket ->
              nil
            end
          )

        actor ->
          socket
          |> keep_live(
            :me,
            fn socket ->
              Tickets.Representative
              |> Ash.Query.load(:open_ticket_count)
              |> Tickets.Api.read_one!(action: :me, actor: actor)
            end,
            refetch_interval: :timer.minutes(5),
            subscribe: [
              "ticket:assigned_to:#{actor.id}"
            ]
          )
          |> keep_live(
            :tickets,
            fn socket, page_opts ->
              Tickets.Ticket
              |> Tickets.Api.read!(
                action: :assigned,
                actor: actor,
                page: page_opts || page_from_params(params["page"], 5, true)
              )
            end,
            api: Tickets.Api,
            results: :keep,
            refetch_interval: :timer.minutes(1),
            subscribe: [
              "user:updated:#{actor.id}",
              "ticket:updated:#{actor.id}"
            ]
          )
      end

    {:ok, socket}
  end

  @impl true
  def handle_params(_, _, socket), do: {:noreply, socket}

  @impl true
  def handle_event("nav", %{"page" => target}, socket) do
    socket = change_page(socket, :tickets, target)

    socket =
      socket
      |> push_patch(
        to: Routes.live_path(socket, __MODULE__, page: page_params(socket.assigns.tickets))
      )

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{topic: topic, payload: %Ash.Notifier.Notification{}}, socket) do
    {:noreply, handle_live(socket, topic, [:me, :tickets])}
  end

  def handle_info({:refetch, assign, opts}, socket) do
    {:noreply, handle_live(socket, :refetch, assign, opts)}
  end
end
