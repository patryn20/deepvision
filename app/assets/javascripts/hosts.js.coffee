$ ->
  $("[data-flot-height]").each ->
    $(this).css("height", $(this).attr("data-flot-height"))
  $("[data-flot-series]").each ->
    series = $.parseJSON($(this).attr("data-flot-series"))
    $(this).plot [{data: series}],
      xaxis:
        mode: "time"
      yaxis:
        tickFormatter: (val, axis) ->
          return val.toFixed(axis.tickDecimals) + "%"
        