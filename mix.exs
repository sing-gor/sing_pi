defmodule SingPi.MixProject do
  use Mix.Project

  @app :sing_pi
  @version "0.1.0"
  @target System.get_env("MIX_TARGET") || "host"  # 添加这行
  
  @all_targets [
    :rpi,
    :rpi0,
    :rpi0_2,  # 添加这一行
    :rpi2,
    :rpi3,
    :rpi3a,
    :rpi4,
    :rpi5,
    :bbb,
    :osd32mp1,
    :x86_64,
    :grisp2,
    :mangopi_mq_pro
  ]
  
  # 添加这行
  @target_non_host @all_targets

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.18",
      archives: [nerves_bootstrap: "~> 1.13"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,  # 添加这行
      target: @target,       # 添加这行
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {SingPi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.10", runtime: false},
      {:shoehorn, "~> 0.9.1"},
      {:ring_logger, "~> 0.11.0"},
      {:toolshed, "~> 0.4.0"},

      # Dependencies for all targets except host
      {:nerves_runtime, "~> 0.13.0", targets: @target_non_host},  # 修改这行
      {:nerves_pack, "~> 0.7.1", targets: @all_targets},

      # Dependencies for specific targets
      # NOTE: It's generally low risk and recommended to follow minor version
      # bumps to Nerves systems. Since these include Linux kernel and Erlang
      # version updates, please review their release notes in case
      # changes to your application are needed.
      {:nerves_system_rpi, "~> 1.24", runtime: false, targets: :rpi},
      {:nerves_system_rpi0, "~> 1.24", runtime: false, targets: :rpi0},
      {:nerves_system_rpi0_2, "~> 1.31", runtime: false, targets: :rpi0_2},  # 添加这一行
      {:nerves_system_rpi2, "~> 1.24", runtime: false, targets: :rpi2},
      {:nerves_system_rpi3, "~> 1.24", runtime: false, targets: :rpi3},
      {:nerves_system_rpi3a, "~> 1.24", runtime: false, targets: :rpi3a},
      {:nerves_system_rpi4, "~> 1.24", runtime: false, targets: :rpi4},
      {:nerves_system_rpi5, "~> 0.2", runtime: false, targets: :rpi5},
      {:nerves_system_bbb, "~> 2.19", runtime: false, targets: :bbb},
      {:nerves_system_osd32mp1, "~> 0.15", runtime: false, targets: :osd32mp1},
      {:nerves_system_x86_64, "~> 1.24", runtime: false, targets: :x86_64},
      {:nerves_system_grisp2, "~> 0.8", runtime: false, targets: :grisp2},
      {:nerves_system_mangopi_mq_pro, "~> 0.6", runtime: false, targets: :mangopi_mq_pro},
      # 在 deps 函数中移除这一行：
      # {:dotenvy, "~> 1.0.0"},
    ]
  end

  def release do
    [
      overwrite: true,
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]],
      rootfs_overlay: "rootfs_overlay"  # 添加这行
    ]
  end
end
