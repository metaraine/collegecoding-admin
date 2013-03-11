client.views.index = Backbone.View.extend(
  build: () ->
    ['#page-index', [
      ['.container-narrow', [
        ['.masthead', [
          ['h3 a.muted', {href: '/'}, 'Project Name']
        ]]
        ['hr']
        ['.jumbotron', [
          ['h1', 'This project is going to be so awesome!']
          ['p.lead', 'Cras justo odio, dapibus ac facilisis in, egestas eget quam. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.']
        ]]
        ['hr']
        ['.row-fluid.marketing', [
          ['.span6', [
            ['h4', 'Clients']
            ['ul', this.model.get('clients').map (client) ->
              ['li', client.Name]
            ]
          ]]
          ['.span6', [
          ]]
        ]]
        ['hr']
        ['.footer', [
          ['p', { html: true }, '&copy; Project Name']
        ]]
      ]]
    ]]
  )