defmodule HelpdeskWeb.Plugs.FakeUser do
  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    user =
      with headers when headers != [] <- Plug.Conn.get_req_header(conn, "user-id"),
           {:ok, user} <- Helpdesk.Accounts.Api.get(Helpdesk.Accounts.User, hd(headers)) do
        user
      else
        _ ->
          nil
      end

    conn =
      conn
      |> Plug.Conn.assign(:actor, user)
      |> Absinthe.Plug.put_options(context: %{actor: user})

    if user do
      Plug.Conn.put_session(conn, "user_id", user.id)
    else
      conn
    end
  end

  def refetch_user(%{"user_id" => user_id}) when is_binary(user_id) do
    Helpdesk.Accounts.Api.get!(Helpdesk.Accounts.User, user_id)
  end

  def refetch_user(_), do: nil
end
