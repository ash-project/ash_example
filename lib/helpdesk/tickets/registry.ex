defmodule Helpdesk.Tickets.Registry do
  use Ash.Registry,
    extensions: [Ash.Registry.ResourceValidations]

  entries do
    entry Helpdesk.Tickets.Customer
    entry Helpdesk.Tickets.Representative
    entry Helpdesk.Tickets.Ticket
  end
end
