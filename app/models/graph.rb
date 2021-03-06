class Graph

  def self.get_disk_series(longterm_stats)
    attributes = [['Disk.reads', /Disk\..*\.reads/], ['Disk.writes', /Disk\..*\.writes/]]
    disk_hash = {}

    last_longterm = nil
    longterm_stats.each do |longterm|
      unless last_longterm.nil?
        attributes.each do |attribute|
          keys = longterm.select {|key, value| key. =~ attribute[1]}.keys
          keys.each do |key|
            disk = key.split('.')[1]

            if disk_hash[disk].nil?
              disk_hash[disk] = Hash[attributes.collect {|attribute| [attribute[0], []]}]
            end
            disk_rate = Longterm.calculate_disk_rate(longterm, last_longterm, key)
            disk_hash[disk][attribute[0]] << [longterm['timestamp'].to_i * 1000, disk_rate]

          end
        end
      end
      last_longterm = longterm
    end

    disk_hash
  end


  def self.get_load_graph_series(longterm_stats)
    Graph.get_graph_series(longterm_stats, 'Load')
  end

  def self.get_memory_used_graph_series(longterm_stats)
    Graph.get_graph_series(longterm_stats, 'Memory.real.used')
  end

  def self.get_memory_cache_graph_series(longterm_stats)
    Graph.get_graph_series(longterm_stats, 'Memory.real.cache')
  end

  def self.get_memory_buffers_graph_series(longterm_stats)
    Graph.get_graph_series(longterm_stats, 'Memory.real.buffers')
  end

  def self.get_network_graph_series(longterm_stats)
    Graph.get_graph_series(longterm_stats, 'Network.Interface.total.Bps')
  end

  def self.get_network_series(longterm_stats)
    attributes = [['Network.rx_Bps', /Network\.Interface\..*\.rx_bytes/], ['Network.tx_Bps', /Network\.Interface\..*\.tx_bytes/]]
    interface_hash = {}

    last_longterm = nil
    longterm_stats.each do |longterm|
      unless last_longterm.nil?
        attributes.each do |attribute|
          keys = longterm.select {|key, value| key. =~ attribute[1]}.keys
          keys.each do |key|
            interface = key.split('.')[2]

            if interface_hash[interface].nil?
              interface_hash[interface] = Hash[attributes.collect {|attribute| [attribute[0], []]}]
            end
            network_rate = Longterm.calculate_network_rate(longterm, last_longterm, key)
            interface_hash[interface][attribute[0]].push [longterm['timestamp'].to_i * 1000, network_rate]
          end
        end
      end
      last_longterm = longterm
    end

    interface_hash
  end

  def self.get_overview_series(longterm_stats)
    attributes = %w(CPU.total.usage Disk.total.reads_ps Disk.total.writes_ps Load Memory.real.used Memory.real.cache Memory.real.buffers Memory.swap.used Network.Interface.total.rx_Bps Network.Interface.total.tx_Bps)

    attributes_hash = Hash[attributes.collect {|attribute| [attribute, []]}]

    longterm_stats.each do |longterm| 
      attributes.each do |attribute|
        #if attribute == "Disk.reads" && !last_longterm.nil?
        #  disk_rate = Longterm.calculate_disk_read_rate(longterm, last_longterm)
        #  if !disk_rate.nil?
        #    attributes_hash[attribute] << [longterm["timestamp"].to_i * 1000, disk_rate]
        #  end
        #elsif attribute == "Disk.writes" && !last_longterm.nil?
        #  disk_rate = Longterm.calculate_disk_write_rate(longterm, last_longterm)
        #  if !disk_rate.nil?
        #    attributes_hash[attribute] << [longterm["timestamp"].to_i * 1000, disk_rate]
        #  end
        #else
          attributes_hash[attribute] << [longterm['timestamp'].to_i * 1000, longterm[attribute]]
        #end
      end
    end
    return attributes_hash
  end

  def self.get_graph_series(longterm_stats, attribute)
    longterm_stats.map {|longterm| [longterm['timestamp'].to_i * 1000, longterm[attribute]]}
  end

end