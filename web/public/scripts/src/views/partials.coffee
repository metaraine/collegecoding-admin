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

$ ()->
  # keep track of keys pressed after '/' to capture user input before search box gains focus
  startCapturing = false
  searchBuffer = '' 

  $(document).bind 'keypress', (e)->
    char = String.fromCharCode e.keyCode

    if char is '/'

      # if we're already capturing input and the search buffer is empty, it means the user
      # entered '/' twice in a row, which is a shortcut to go to the home page
      if startCapturing and searchBuffer is ''
        location.href = '/'

      # otherwise
      else
        searchBuffer = ''
        startCapturing = true

        $('#client-search')
          .modal()
          .on 'shown', () ->
            startCapturing = false
            $('#client-search .search-box')
              .focus()
              .val(searchBuffer)
              .keydown (e)->
                if e.keyCode is 13
                  name = $('#client-search .search-box').val()
                  location.href = if name then '/client/' + name else '/'

    # if capturing is enabled, record the user key so we can insert it into the search box once it is ready
    else if startCapturing
      searchBuffer += char
