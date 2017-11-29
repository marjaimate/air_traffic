defmodule AirTrafficWeb.AirportsController do
  use AirTrafficWeb, :controller

  alias AirElixir.ControlTower
  alias AirElixir.TowerSupervisor
  alias AirElixir.Plane

  def index(conn, _params) do
    conn
    |> assign(:airports, get_airports)
    |> render("index.html")
  end

  def open_new(conn, %{"airport" => name, "landing_strips" => landing_strips} = params) do
    airport = String.to_atom(name)
    TowerSupervisor.start_control_tower(airport, landing_strips)

    conn |> redirect(to: "/airports")
  end

  def send_planes(conn, %{"number_of_planes" => number_of_planes} = params) do
    airports = get_airports |> Enum.map(fn {n, _} -> n end)

    1..(String.to_integer(number_of_planes))
      |> Enum.map(fn _ -> Plane.start_link(Enum.random(airports)) end)
      |> Enum.map(fn {:ok, pid} -> pid end)
      |> land_planes

    conn
    |> send_resp(201, "")
  end

  ### Private ###
  defp get_airports do
    Supervisor.which_children(TowerSupervisor)
      |> Enum.map(fn {_, pid, _, _ } -> pid end)
      |> Enum.map(&( { :proplists.get_value(:registered_name, Process.info(&1)), ControlTower.status(&1) } ))
  end


  ## Land planes
  defp land_planes([]), do: :ok
  defp land_planes([plane | rest]) do
    permission = Plane.permission_to_land(plane)
    planes = attempt_to_land_plane(permission, plane, rest)
    land_planes(planes)
  end

  # IF we got the go ahead -> land the plane and carry on with the rest of the planes
  defp attempt_to_land_plane(:got_permission, plane, rest) do
    Plane.land(plane)
    rest
  end
  # IF we can't land -> put the plane at the back of the queue
  defp attempt_to_land_plane(:cannot_land, plane, rest) do
    rest ++ [plane]
  end
end
