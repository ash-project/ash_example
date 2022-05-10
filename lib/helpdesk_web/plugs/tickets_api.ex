defmodule HelpdeskWeb.Plugs.TicketsApi do
  use AshJsonApi.Api.Router, api: Helpdesk.Tickets.Api, registry: Helpdesk.Tickets.Registry
end
