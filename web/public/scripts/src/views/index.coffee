client.views.index = Backbone.View.extend(

  initialize: ()->
    this.bind 'render', ()->
      r = new Raphael('sessions-per-day')

      r.linechart(0, 0, 450, 100, 
        this.model.get('sessionsPerDay').x, 
        [this.model.get('sessionsPerDay').y]
      )

  build: () ->
    ['#page-index', [
      ['.container-narrow', [
        new client.partials.Header(),
        ['.row-fluid.marketing', [

          ['.span4 aside#active-clients.client-list', [
            ['h4', 'Active Clients']
            ['ul', this.model.get('activeClients').map (client) ->
              ['li a', { href: '/client/' + client.name }, client.name]
            ]
          ]]

          ['.span8', [
            ['#sessions-per-day']
            ['#sessions-per-day2']
          ]]
        ]]

        ['.row-fluid.marketing', [

          ['.span4 aside#leads.client-list', [
            ['h4', 'Leads']
            ['ul', this.model.get('leads').map (client) ->
              ['li a', { href: '/client/' + client.name }, client.name]
            ]
          ]]

          ['.span8', [
            'Health Indicator Charts'
          ]]

        ]]

        new client.partials.Footer()
      ]]
    ]]
  )