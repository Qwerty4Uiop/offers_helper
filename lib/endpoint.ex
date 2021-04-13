defmodule OffersHelper.Endpoint do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  get "/offers" do
    with {:ok, parsed_params} <- parse_params(conn.query_params) do
      send_success(conn, OffersHelper.get_job_offers(parsed_params))
    else
      {:error, :wrong_params} -> send_params_error(conn)
    end
  end

  defp parse_params(%{"latitude" => latitude, "longitude" => longitude, "radius" => radius}) do
    with {number_latitude, _rest} <- Float.parse(latitude),
         {number_longitude, _rest} <- Float.parse(longitude),
         {number_radius, _rest} <- Float.parse(radius) do
      {:ok, %{latitude: number_latitude, longitude: number_longitude, radius: number_radius}}
    else
      _error -> {:error, :wrong_params}
    end
  end

  defp parse_params(_params), do: {:error, :wrong_params}

  defp send_success(conn, response) do
    send_resp(conn, 200, Poison.encode!(response))
  end

  defp send_params_error(conn) do
    send_resp(
      conn,
      422,
      Poison.encode!(%{
        error: "Expected params: latitude (number), longitude (number), radius (number)"
      })
    )
  end

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
