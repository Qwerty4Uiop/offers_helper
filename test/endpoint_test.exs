defmodule OffersHelper.EndpointTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts OffersHelper.Endpoint.init([])

  test "returns offers according to parameters" do
    conn = conn(:get, "/offers?latitude=45.247989&longitude=-0.628185&radius=1")
    conn = OffersHelper.Endpoint.call(conn, @opts)

    assert conn.status == 200

    assert [
             %{
               "category" => "Tech",
               "contract_type" => "APPRENTICESHIP",
               "distance" => 0.16,
               "name" => "Alternance - Management projets SI - H/F",
               "office_latitude" => "45.247987",
               "office_longitude" => "-0.626174"
             }
           ] = Poison.decode!(conn.resp_body)
  end

  test "returns an error if params are incorrect" do
    conn = conn(:get, "/offers?longitude=-0.628185&radius=1")
    conn = OffersHelper.Endpoint.call(conn, @opts)

    assert conn.status == 422

    assert %{"error" => "Expected params: latitude (number), longitude (number), radius (number)"} =
             Poison.decode!(conn.resp_body)
  end
end
