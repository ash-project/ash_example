defmodule Helpdesk.Schema do
  use Absinthe.Schema

  use AshGraphql, api: Helpdesk.Tickets.Api
  use AshGraphql, api: Helpdesk.Accounts.Api

  query do
  end

  mutation do
  end
end
