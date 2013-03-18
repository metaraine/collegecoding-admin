client.partials.footer = Backbone.View.extend(
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
)

$(() ->
  $(document).bind('keydown', '/', () ->
    $('#client-search')
      .modal()
      .on 'shown', () ->
        $('#client-search .search-box').focus().keydown (e)->
          if e.keyCode == 13
            name = $('#client-search .search-box').val()
            location.href = if name then '/client/' + name else '/'
  )
)