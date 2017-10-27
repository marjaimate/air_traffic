defmodule AirTrafficWeb.PageController do
  use AirTrafficWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
