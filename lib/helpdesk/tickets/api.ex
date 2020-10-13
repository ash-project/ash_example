defmodule Helpdesk.Tickets.Api do
  # in lib/helpdesk/api.ex
  use Ash.Api,
    extensions: [
      AshJsonApi.Api,
      AshGraphql.Api,
      AshBrowser.Api
    ]

  alias Helpdesk.Tickets.{Customer, Representative, Ticket}

  browser do
    refetch_actor({HelpdeskWeb.FakeUser, :refetch_user, []})

    pages do
      page :home, "/", Helpdesk.Tickets.Views.Home do
        component(:user_banner, {Representative, :me})
        component(:assigned_tickets_list, {Ticket, :assigned_tickets})
      end
    end
  end

  resources do
    resource(Customer)
    resource(Representative)
    resource(Ticket)
  end
end
