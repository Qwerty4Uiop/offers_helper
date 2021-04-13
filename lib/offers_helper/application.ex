defmodule OffersHelper.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: OffersHelper.Endpoint,
        options: [port: Application.get_env(:offers_helper, :port)]
      )
    ]

    opts = [strategy: :one_for_one, name: OffersHelper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
