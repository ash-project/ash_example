defmodule Helpdesk.Tickets.Pages.Home do
  use AshBrowser.LiveView,
    api: Helpdesk.Tickets.Api,
    page: :home

  def render(assigns) do
    ~L"""
    <h1> Home page </h1>
    <h2> Hello <%= @actor.first_name %> </h2>
    <%= ash_component(@socket, @dashboard, @api) %>
    """
  end

  def subscribe(socket) do
    HelpdeskWeb.Endpoint.subscribe("ticket:assigned_to:#{socket.assigns.actor.id}")

    :ok
  end
end
