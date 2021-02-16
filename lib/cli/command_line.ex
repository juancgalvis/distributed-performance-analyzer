defmodule Cli.CommandLine do
  @moduledoc false
  def main(args) do
    options = []
    {opts, _, _} = OptionParser.parse(args, options)
    IO.inspect opts, label: "Command Line Arguments"
    Perf.Execution.launch_execution()
    Process.monitor(Process.whereis(Perf.MetricsAnalyzer))
    receive do
      {:DOWN, _ref, :process, _pid, :normal} -> IO.puts "Finishing...";
    end
  end
end
