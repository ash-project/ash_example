defmodule Helpdesk.Tickets.Components.Dashboard do
  use AshBrowser.LiveComponent

  def render(assigns) do
    ~L"""
    <%= ash_component(@socket, @me, @api) %>
    <%= ash_component(@socket, @assigned_tickets, @api) %>
    """
  end
end
