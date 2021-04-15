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
      {:error, error} -> send_params_error(conn, error)
    end
  end

  defp parse_params(%{"latitude" => latitude, "longitude" => longitude, "radius" => radius}) do
    with {number_latitude, _rest} <- Float.parse(latitude),
         {number_longitude, _rest} <- Float.parse(longitude),
         {number_radius, _rest} <- Float.parse(radius),
         :ok <- check_latitude(number_latitude),
         :ok <- check_longitude(number_longitude) do
      {:ok, %{latitude: number_latitude, longitude: number_longitude, radius: number_radius}}
    else
      {:error, _error} = error -> error
      _error -> {:error, :wrong_params}
    end
  end

  defp parse_params(_params), do: {:error, :wrong_params}

  @min_latitude -90
  @max_latitude 90
  defp check_latitude(latitude) when latitude >= @min_latitude and latitude <= @max_latitude, do: :ok
  defp check_latitude(_latitude), do: {:error, :wrong_latitude}

  @min_longitude -180
  @max_longitude 180
  defp check_longitude(longitude) when longitude >= @min_longitude and longitude <= @max_longitude, do: :ok
  defp check_longitude(_longitude), do: {:error, :wrong_longitude}

  defp send_success(conn, response) do
    send_resp(conn, 200, Poison.encode!(response))
  end

  defp send_params_error(conn, error) do
    send_resp(conn, 422, Poison.encode!(%{error: string_error(error)}))
  end

  defp string_error(:wrong_params), do: "Expected params: latitude (number), longitude (number), radius (number)"
  defp string_error(:wrong_latitude), do: "Latitude must be between #{@min_latitude} and #{@max_latitude}"
  defp string_error(:wrong_longitude), do: "Longitude must be between #{@min_longitude} and #{@max_longitude}"

  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
