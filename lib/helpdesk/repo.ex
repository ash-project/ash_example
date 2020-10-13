defmodule Helpdesk.Repo do
  use Ecto.Repo,
    otp_app: :helpdesk,
    adapter: Ecto.Adapters.Postgres
end
