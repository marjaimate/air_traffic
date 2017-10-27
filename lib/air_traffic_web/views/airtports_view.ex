defmodule AirTrafficWeb.AirportsView do
  use AirTrafficWeb, :view

  def get_csrf_token(_conn) do
    Plug.CSRFProtection.get_csrf_token()
  end
end
