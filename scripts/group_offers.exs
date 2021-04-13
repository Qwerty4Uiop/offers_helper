defmodule OffersGrouper do
  alias OffersHelper.Continents

  def group_offers do
    professions =
      "../technical-test-professions.csv"
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> CSV.decode!(headers: true)
      |> Enum.to_list()
      |> Enum.map(fn %{"id" => id, "category_name" => name} -> {id, name} end)
      |> Enum.into(%{})

    "../technical-test-jobs.csv"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Enum.reduce(%{}, fn job, acc ->
      category = professions[job["profession_id"]] || "Unknown category"
      job_latitude = parse_coord(job["office_latitude"])
      job_longitude = parse_coord(job["office_longitude"])
      continent = Continents.get_continent_by_coords(job_latitude, job_longitude)

      acc
      |> Map.update("total", 1, fn x -> x + 1 end)
      |> Map.update(continent, %{category => 1}, fn map -> Map.update(map, category, 1, fn x -> x + 1 end) end)
    end)
    |> IO.inspect()
  end

  defp parse_coord(string_coord) do
    case Float.parse(string_coord) do
      {coord, _} -> coord
      _ -> nil
    end
  end
end

OffersGrouper.group_offers()