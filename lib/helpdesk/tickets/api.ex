defmodule Helpdesk.Tickets.Api do
  use Ash.Api,
    extensions: [
      AshJsonApi.Api,
      AshGraphql.Api
    ]

  alias Helpdesk.Tickets.{Customer, Representative, Ticket}

  graphql do
    authorize? true
  end

  resources do
    resource(Customer)
    resource(Representative)
    resource(Ticket)
  end
end
