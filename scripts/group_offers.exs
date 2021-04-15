defmodule OffersGrouper do
  alias OffersHelper.Continents
  alias TableRex.Table

  @unknown_category_name "Unknown category"
  def group_offers do
    professions = OffersHelper.get_professions()

    OffersHelper.get_all_jobs()
    |> Enum.reduce(%{}, fn job, acc ->
      category = professions[job["profession_id"]] || @unknown_category_name
      job_latitude = parse_coord(job["office_latitude"])
      job_longitude = parse_coord(job["office_longitude"])
      continent = Continents.get_continent_by_coords(job_latitude, job_longitude)

      acc
      |> Map.update("Total", %{category => 1, "Total" => 1}, fn map -> increment_counters(map, category) end)
      |> Map.update(continent, %{category => 1, "Total" => 1}, fn map -> increment_counters(map, category) end)
    end)
    |> to_table(professions)
    |> IO.puts()
  end

  defp increment_counters(map, category) do
    map
    |> Map.update(category, 1, &(&1 + 1))
    |> Map.update("Total", 1, &(&1 + 1))
  end

  defp to_table(grouped_offers, professions) do
    professions_names = ["Total"] ++ Enum.uniq(Map.values(professions)) ++ [@unknown_category_name]
    headers = [nil | Enum.map(professions_names, &String.upcase/1)]
    total_row = ["TOTAL" | Enum.map(professions_names, fn name -> grouped_offers["Total"][name] || 0 end)]

    rest_rows =
      grouped_offers
      |> Map.delete("Total")
      |> Enum.map(fn {group_name, jobs_by_category} ->
        [String.upcase(group_name) | Enum.map(professions_names, fn name -> jobs_by_category[name] || 0 end)]
      end)

    [total_row | rest_rows]
    |> Table.new(headers)
    |> Table.put_column_meta(1..Enum.count(professions_names), align: :center)
    |> Table.render!()
  end

  defp parse_coord(string_coord) do
    case Float.parse(string_coord) do
      {coord, _} -> coord
      _ -> nil
    end
  end
end

OffersGrouper.group_offers()