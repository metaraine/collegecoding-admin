client.views.index = Backbone.View.extend(
  build: () ->
    ['#page-index', [
      ['.container-narrow', [
        ['.masthead', [
          ['h3 a.muted', {href: '/'}, 'College Coding']
        ]]
        ['hr']
        ['.row-fluid.marketing', [

          ['.span4 aside#active-clients.client-list', [
            ['h4', 'Active Clients']
            ['ul', this.model.get('activeClients').map (client) ->
              ['li a', { href: '/client/' + client.name }, client.name]
            ]
          ]]

          ['.span8', [
            'Health Indicator Charts'
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

        new client.partials.footer()
      ]]
    ]]
  )