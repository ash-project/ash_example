defmodule Helpdesk.Tickets.Components.Ticket.Assigned do
  use AshBrowser.LiveComponent

  def render(assigns) do
    ~L"""
    <%= for ticket <- @data do %>
      Ticket: <%= ticket.subject %>
      <br>
    <% end %>
    """
  end
end
