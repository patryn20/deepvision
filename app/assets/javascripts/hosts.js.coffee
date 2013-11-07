$ ->
  # bind date range
  $("#date_range").change ->
    window.location = window.location + "?r=" + $(this).val()

  # initialize flots
  $("[data-flot-height]").each ->
    $(this).css("height", $(this).attr("data-flot-height"))

  base_options = 
    series:
      stacked: true
      lines:
        fill: true
    xaxis:
      mode: "time"
      tickLength: 0
      ticks: 6
    yaxis:
      min: 0
    legend: {}

  cpu_options = $.extend(true, {}, base_options)
  cpu_options.yaxis.tickFormatter = (val, axis) ->
          return val.toFixed(axis.tickDecimals) + "%"
  # intiate the CPU series
  $("#cpu-flot").plot [{data: gon.cpu_series}],cpu_options

  memory_options = $.extend(true, {}, base_options)
  memory_options.yaxis.tickFormatter = (val, axis) ->
          return val.toFixed(axis.tickDecimals) + " bytes"
  memory_options.legend.container = $('#memory-flot-legend')
  memory_options.legend.noColumns = 4
  $("#memory-flot").plot [
      {label: "Used", data: gon.memory_used_series}
      {label: "Cache", data: gon.memory_cache_series}
      {label: "Buffers", data: gon.memory_buffers_series}
      {label: "Swap", data: gon.memory_swap_series}
    ], memory_options

  load_options = $.extend(true, {}, base_options)
  load_options.xaxis.ticks = 4
  $("#load-flot").plot [{data: gon.load_series}], load_options

  network_options = $.extend(true, {}, base_options)
  network_options.yaxis.tickFormatter = (val, axis) ->
          return val.toFixed(axis.tickDecimals) + " bps"
  network_options.legend.container = $('#network-flot-legend')
  network_options.legend.noColumns = 2
  network_options.xaxis.ticks = 4
  $("#network-flot").plot [
      {label: "Out", data: gon.network_out_series}
      {label: "In", data: gon.network_in_series}
    ], network_options


  disk_options = $.extend(true, {}, base_options)
  disk_options.legend.container = $('#disk-flot-legend')
  disk_options.legend.noColumns = 2
  disk_options.xaxis.ticks = 4
  $("#disk-flot").plot [
      {label: "Reads/Second", data: gon.disk_reads_series}
      {label: "Writes/Second", data: gon.disk_writes_series}
    ], disk_options

  for net_interface of gon.network_interfaces
    net_interface = gon.network_interfaces[net_interface]
    interface_options = $.extend(true, {}, base_options)
    interface_options.legend.container = $("#" + net_interface + "-flot-legend")
    interface_options.legend.noColumns = 2
    $("#" + net_interface + "-flot").plot [
        {label: "Inbound", data: gon.network_series[net_interface]["Network.rx_Bps"]}
        {label: "Outbound", data: gon.network_series[net_interface]["Network.tx_Bps"]}
      ], interface_options

  for disk of gon.dev_disks
    disk = gon.dev_disks[disk]
    disk_options = $.extend(true, {}, base_options)
    disk_options.legend.container = $("#" + disk.replace(/\//g, '') + "-flot-legend")
    disk_options.legend.noColumns = 2
    $("#" + disk.replace(/\//g, '') + "-flot").plot [
        {label: "Writes", data: gon.dev_disk_series[disk]["Disk.writes"]}
        {label: "Reads", data: gon.dev_disk_series[disk]["Disk.reads"]}
      ], disk_options
