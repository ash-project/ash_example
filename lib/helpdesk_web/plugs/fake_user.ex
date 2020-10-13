defmodule HelpDesk.Plugs.FakeUser do
  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    user =
      with headers when headers != [] <- Plug.Conn.get_req_header(conn, "user-id"),
           {:ok, user} <- HelpDesk.Accounts.Api.get(HelpDesk.Accounts.User, hd(headers)) do
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
      put_session(conn, "user_id", user.id)
    else
      conn
    end
  end
end
