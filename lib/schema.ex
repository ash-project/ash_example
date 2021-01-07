defmodule Helpdesk.Schema do
  use Absinthe.Schema

  use AshGraphql, apis: [Helpdesk.Tickets.Api, Helpdesk.Accounts.Api]

  query do
  end

  mutation do
  end
end
