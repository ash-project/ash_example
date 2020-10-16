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
    refetch_actor({HelpdeskWeb.Plugs.FakeUser, :refetch_user, []})

    components do
      component :dashboard, Helpdesk.Tickets.Components.Dashboard do
        resource_component :assigned_tickets, Ticket, :assigned
        resource_component :me, Representative, :me
      end
    end

    pages do
      page :home, "/", Helpdesk.Tickets.Pages.Home do
        api_component(:dashboard, __MODULE__, :dashboard)
      end
    end
  end

  graphql do
    authorize? true
  end

  resources do
    resource(Customer)
    resource(Representative)
    resource(Ticket)
  end
end
