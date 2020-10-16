defmodule Helpdesk.Tickets.Components.Representative.Me do
  use AshBrowser.LiveComponent

  def render(assigns) do
    ~L"""
    Hello <%= @data.first_name %> <%= @data.last_name %>, you have <%= @data.open_ticket_count %> tickets open.
    """
  end
end
