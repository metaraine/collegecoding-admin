RJS.installPrototypes()

# assert the top-level namespace and add client-side namespaces
if typeof client is undefined
  console.error "Expected the client namespace to be defined. This should be boostrapped from the server."
client.views = {}
client.partials = {}

###
Returns a function that, given some data, returns a new instance of the specified Backbone View constuctor with the data as its model.
Useful for mapping array data to fully-qualified backbone views:
e.g.
###
client.viewCreator = (View) ->
  (data) ->
    View["new"] model: new Backbone.Model(data)

attachGlobalEvents = ->
  # keep track of keys pressed after '/' to capture user input before search box gains focus
  startCapturing = false
  searchBuffer = '' 

  # global focus tracking to enable/disable global search with '/'
  $('[contenteditable],input,textarea')
    .focus(-> window.isEditing = true)
    .blur(-> window.isEditing = false)
    .keyup (e)->
      if e.keyCode is 27 # escape key
        $(e.target).blur()

  # global search with '/'
  $(document).bind 'keypress', (e)->
    char = String.fromCharCode e.keyCode

    if not window.isEditing and char is '/'

      # if we're already capturing input and the search buffer is empty, it means the user
      # entered '/' twice in a row, which is a shortcut to go to the home page
      if startCapturing and searchBuffer is ''
        location.href = '/'

      # otherwise reset the buffer and begin capturing input until the dialog pops up
      else
        searchBuffer = ''
        startCapturing = true

        $('#client-search')
          .modal()
          .on 'hide', ->
            $('#client-search .search-box').blur()
          .on 'shown', ->
            startCapturing = false
            $('#client-search .search-box')
              .focus()
              .val(searchBuffer)
              .keydown (e)->
                if e.keyCode is 13 # enter key
                  name = $('#client-search .search-box').val()
                  location.href = if name then '/client/' + name else '/'

    # if capturing is enabled, record the user key so we can insert it into the search box once it is ready
    else if startCapturing
      searchBuffer += char

$ ->
  
  # make sure the bootstrapped view matches a client-side Backbone View defined in client.views
  if client.view not of client.views
    console.error "Invalid view: '{0}'. This value must exactly match the name of a view function stored on client.views.".supplant([client.view])
  
  # instantiate the appropriate view, passing the bootstrapped data as the model
  view = new client.views[client.view](model: new Backbone.Model(client.data))
  
  # render the view
  Creatable.render view

  attachGlobalEvents();

