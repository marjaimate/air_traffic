defmodule AirTrafficWeb.PlaneChannel do
  use Phoenix.Channel

  def join("planes:messages", _message, socket) do
    {:ok, socket}
  end

  def handle_out(event, payload, socket) do
    push socket, event, payload
    {:noreply, socket}
  end
end
