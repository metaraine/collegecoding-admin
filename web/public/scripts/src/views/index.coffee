client.views.index = Backbone.View.extend(

  initialize: ()->
    this.bind 'render', ()->
      r = new Raphael('sessions-per-day')

      sessionsPerWeekChart = r.linechart(10, 10, 700, 120, 
        this.model.get('perDayXY7DaySum').x
        [this.model.get('perDayXY7DaySum').y, [0,30]] # extra y-series to force y-axis to start at 0
        axis: '0 0 1 1'
        axisystep: 3
        colors: ['#2F69BF', 'transparent']
      )

      for item in sessionsPerWeekChart.axis[0].text.items
        item.attr('text', moment(parseInt(item.attr('text'))).format('M/DD'))

  build: () ->
    ['#page-index', [
      ['.container-narrow', [
        new client.partials.Header(),
        ['#sessions-per-day']
        ['.row-fluid.marketing', [

          ['.span12', [
            ['#sessions-per-day2']
          ]]
        ]]

        ['.row-fluid.marketing', [

          ['.span4 aside', [
          ]]

          ['.span8', [
          ]]

        ]]

        new client.partials.Footer()
      ]]
    ]]
  )