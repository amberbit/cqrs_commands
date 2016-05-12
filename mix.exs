defmodule Cqrs.Commands.Mixfile do
  use Mix.Project

  def project do
    [app: :cqrs_commands,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     consolidate_protocols: Mix.env != :test,
   ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :exconstructor],
     mod: {Cqrs.Commands, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:exconstructor, "~> 1.0.2"},
      {:vex, github: "hubertlepicki/vex"},
      {:uuid, "~> 1.1"},
    ]
  end
end
