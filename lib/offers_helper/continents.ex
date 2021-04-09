defmodule OffersHelper.Continents do
  @moduledoc """
  Defines continent by coordinates
  Continents data taken from https://stackoverflow.com/a/25075832
  """

  @lat_NA [90, 90, 78.13, 57.5, 15, 15, 1.25, 1.25, 51, 60, 60]
  @lon_NA [-168.75, -10, -10, -37.5, -30, -75, -82.5, -105, -180, -180, -168.75]
  @lat_NA2 [51, 51, 60]
  @lon_NA2 [166.6, 180, 180]

  @lat_SA [1.25, 1.25, 15, 15, -60, -60]
  @lon_SA [-105, -82.5, -75, -30, -30, -105]
  @lat_Europe [
    90,
    90,
    42.5,
    42.5,
    40.79,
    41,
    40.55,
    40.40,
    40.05,
    39.17,
    35.46,
    33,
    38,
    35.42,
    28.25,
    15,
    57.5,
    78.13
  ]
  @lon_Europe [
    -10,
    77.5,
    48.8,
    30,
    28.81,
    29,
    27.31,
    26.75,
    26.36,
    25.19,
    27.91,
    27.5,
    10,
    -10,
    -13,
    -30,
    -37.5,
    -10
  ]

  @lat_Africa [15, 28.25, 35.42, 38, 33, 31.74, 29.54, 27.78, 11.3, 12.5, -60, -60]
  @lon_Africa [-30, -13, -10, 10, 27.5, 34.58, 34.92, 34.46, 44.3, 52, 75, -30]

  @lat_Australia [-11.88, -10.27, -10, -30, -52.5, -31.88]
  @lon_Australia [110, 140, 145, 161.25, 142.5, 110]

  @lat_Asia [
    90,
    42.5,
    42.5,
    40.79,
    41,
    40.55,
    40.4,
    40.05,
    39.17,
    35.46,
    33,
    31.74,
    29.54,
    27.78,
    11.3,
    12.5,
    -60,
    -60,
    -31.88,
    -11.88,
    -10.27,
    33.13,
    51,
    60,
    90
  ]
  @lon_Asia [
    77.5,
    48.8,
    30,
    28.81,
    29,
    27.31,
    26.75,
    26.36,
    25.19,
    27.91,
    27.5,
    34.58,
    34.92,
    34.46,
    44.3,
    52,
    75,
    110,
    110,
    110,
    140,
    140,
    166.6,
    180,
    180
  ]
  @lat_Asia2 [90, 90, 60, 60]
  @lon_Asia2 [-180, -168.75, -168.75, -180]
  @lat_Antarctica [-60, -60, -90, -90]
  @lon_Antarctica [-180, 180, 180, -180]

  @continents_coords %{
    "North America" => [Enum.zip(@lat_NA, @lon_NA), Enum.zip(@lat_NA2, @lon_NA2)],
    "South America" => [Enum.zip(@lat_SA, @lon_SA)],
    "Europe" => [Enum.zip(@lat_Europe, @lon_Europe)],
    "Africa" => [Enum.zip(@lat_Africa, @lon_Africa)],
    "Australia" => [Enum.zip(@lat_Australia, @lon_Australia)],
    "Asia" => [Enum.zip(@lat_Asia, @lon_Asia), Enum.zip(@lat_Asia2, @lon_Asia2)],
    "Antarctica" => [Enum.zip(@lat_Antarctica, @lon_Antarctica)]
  }

  def get_continent_by_coords(latitude, longitude) do
    point = %Geo.Point{coordinates: {latitude, longitude}}

    Enum.reduce_while(@continents_coords, "Unknown continent", fn {name, coords}, acc ->
      if Topo.contains?(%Geo.Polygon{coordinates: coords}, point), do: {:halt, name}, else: {:cont, acc}
    end)
  end
end
