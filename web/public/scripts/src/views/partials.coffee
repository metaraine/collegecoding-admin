client.partials.Footer = Backbone.View.extend
  build: () ->
    ['fragment', [
      ['hr']
      ['footer', [
      ]]

      ['#client-search.modal.hide.fade', { role: 'dialog'}, [
        ['.modal-header', [
          ['h3', 'Find a client']
        ]]
        ['.modal-body', [
          ['p input.search-box', { type: 'textbox', placeholder: 'Enter client\'s name' }]
        ]]
        ['.modal-footer', [
          ['button.btn', {'data-dismiss': 'modal'}, 'Close']
          ['button.btn.btn-primary', 'Search']
        ]]
      ]]
    ]]

client.partials.Header = Backbone.View.extend
  build: ()->
    ['header', [
      ['.masthead', [
        ['h3 a.muted', {href: '/'}, 'College Coding Admin']
      ]]
      ['hr']
    ]]
