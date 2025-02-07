defmodule MyUmbrellaWeb.ControllerTest do
  use MyUmbrella.ConnCase, async: true

  alias MyUmbrella.Coordinates

  alias MyUmbrellaWeb.Controller

  describe "determining if an umbrella is required today" do
    test "given it IS raining before end-of-day; then an umbrella IS needed", %{conn: conn} do
      london = Coordinates.new(51.5098, -0.118)
      current_date_time_utc = DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "Etc/UTC")
      conn = Plug.Conn.assign(conn, :current_date_time_utc, current_date_time_utc)

      conn = Controller.show(conn, to_params(london))

      assert {200, _headers, body} = Plug.Test.sent_resp(conn)
      assert body =~ "Yes"
    end

    test "given it IS NOT raining before end-of-day; then an umbrella IS NOT needed", %{
      conn: conn
    } do
      orlando = Coordinates.new(28.5383, -81.3792)
      current_date_time_utc = DateTime.new!(~D[2000-01-01], ~T[21:30:00Z], "Etc/UTC")
      conn = Plug.Conn.assign(conn, :current_date_time_utc, current_date_time_utc)

      conn = Controller.show(conn, to_params(orlando))

      assert {200, _headers, body} = Plug.Test.sent_resp(conn)
      assert body =~ "No"
    end
  end

  defp to_params({lat, lon}) do
    %{"lat" => to_string(lat), "lon" => to_string(lon)}
  end
end
