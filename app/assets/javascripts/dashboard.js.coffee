$ ->
  $('div[data-percent]').easyPieChart
    scaleColor: false
    lineWidth: 15
    size: 200
    trackColor: '#ACAC9D'
  $('div.widget div.content div.pie-chart:not(.host-cpu)').hide()
  $('#widget-container').isotope
    itemSelector: '.widget'
    layoutMode: 'fitRows'
    getSortData: 
      cpu: ( $elem )->  
        found_percent = $elem.find('.host-cpu ').attr('data-percent')
        if typeof found_percent == "undefined"
          found_percent = 9999
        return found_percent
      memory: ( $elem )-> 
        found_percent = $elem.find('.host-memory').attr('data-percent')
        if typeof found_percent == "undefined"
          found_percent = 9999
        return found_percent
    sortBy: 'cpu'
    