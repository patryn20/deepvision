$ ->
  $("[data-flot-height]").each ->
    $(this).css("height", $(this).attr("data-flot-height"))

  base_options = 
    series:
      stacked: true
      lines:
        fill: true
    xaxis:
      mode: "time"
    yaxis:
      min: 0

  cpu_options = $.extend(true, {}, base_options)
  cpu_options.yaxis.tickFormatter = (val, axis) ->
          return val.toFixed(axis.tickDecimals) + "%"
  # intiate the CPU series
  $("#cpu-flot").plot [{data: gon.cpu_series}],cpu_options

  memory_options = $.extend(true, {}, base_options)
  memory_options.yaxis.tickFormatter = (val, axis) ->
          return val.toFixed(axis.tickDecimals) + " bytes"
  $("#memory-flot").plot [
      {label: "Used", data: gon.memory_used_series}
      {label: "Cache", data: gon.memory_cache_series}
      {label: "Buffers", data: gon.memory_buffers_series}
      {label: "Swap", data: gon.memory_swap_series}
    ], memory_options

  $("#load-flot").plot [{data: gon.load_series}], base_options

  network_options = $.extend(true, {}, base_options)
  network_options.yaxis.tickFormatter = (val, axis) ->
          return val.toFixed(axis.tickDecimals) + " bps"
  $("#network-flot").plot [
      {label: "Out", data: gon.network_out_series}
      {label: "In", data: gon.network_in_series}
    ], network_options

  $("#disk-flot").plot [
      {label: "Reads/Second", data: gon.disk_reads_series}
      {label: "Writes/Second", data: gon.disk_writes_series}
    ], base_options