defmodule OffersHelper do
  @professions "../technical-test-professions.csv"
               |> Path.expand(__DIR__)
               |> File.stream!()
               |> CSV.decode!(headers: true)
               |> Enum.to_list()
               |> Enum.map(fn %{"id" => id, "category_name" => name} -> {id, name} end)
               |> Enum.into(%{})

  @jobs "../technical-test-jobs.csv"
        |> Path.expand(__DIR__)
        |> File.stream!()
        |> CSV.decode!(headers: true)
        |> Enum.to_list()

  def get_job_offers(%{latitude: latitude, longitude: longitude, radius: radius}) do
    @jobs
    |> Enum.reduce([], fn job, acc ->
      job_latitude = parse_coord(job["office_latitude"])
      job_longitude = parse_coord(job["office_longitude"])

      case calculate_distance(latitude, longitude, job_latitude, job_longitude) do
        {:ok, distance} ->
          if distance <= radius * 1000 do
            category = @professions[job["profession_id"]]

            new_job =
              job
              |> Map.delete("profession_id")
              |> Map.put("distance", distance / 1000)
              |> Map.put("category", category)

            [new_job | acc]
          else
            acc
          end

        _ ->
          acc
      end
    end)
    |> Enum.sort_by(fn job -> job["distance"] end)
  end

  defp parse_coord(string_coord) do
    case Float.parse(string_coord) do
      {coord, _} -> coord
      _ -> nil
    end
  end

  defp calculate_distance(latitude1, longitude1, latitude2, longitude2)
       when is_number(latitude1) and is_number(latitude2) and is_number(longitude1) and
              is_number(longitude2) do
    {:ok, Geocalc.distance_between([latitude1, longitude1], [latitude2, longitude2])}
  end

  defp calculate_distance(_latitude1, _longitude1, _latitude2, _longitude2),
    do: {:error, :wrong_coords}
end
