class Graph

  def self.get_cpu_graph_series(longterm_stats)
    Graph.get_graph_series(longterm_stats, "CPU.total.usage")
  end

  def self.get_load_graph_series(longterm_stats)
    Graph.get_graph_series(longterm_stats, "Load")
  end

  def self.get_graph_series(longterm_stats, attribute)
    longterm_stats.map {|longterm| [longterm["timestamp"].to_i * 1000, longterm[attribute]]}
  end

end