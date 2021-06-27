defmodule Password.MixProject do
  use Mix.Project

  def project do
    [
      app: :struttura_password,
      version: "0.1.1",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      description: "sugar for password checking, hashing, and validating",
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:argon2_elixir, "~> 2.3"},
      {:ecto_sql, "~> 3.5"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:faker, "~> 0.16.0", only: :test}
    ]
  end

  defp package do
    [
      files: ~w(lib mix.exs README.md LICENSE),
      maintainers: ["Brandon Bassett"],
      licenses: ["Apache 2.0"],
      links: %{
        "Github" => "http://github.com/struttura/password"
      }
    ]
  end
end
