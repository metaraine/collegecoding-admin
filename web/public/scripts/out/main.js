// Generated by CoffeeScript 1.4.0
(function() {
  var attachGlobalEvents;

  RJS.installPrototypes();

  if (typeof client === void 0) {
    console.error("Expected the client namespace to be defined. This should be boostrapped from the server.");
  }

  client.views = {};

  client.partials = {};

  /*
  Returns a function that, given some data, returns a new instance of the specified Backbone View constuctor with the data as its model.
  Useful for mapping array data to fully-qualified backbone views:
  e.g.
  */


  client.viewCreator = function(View) {
    return function(data) {
      return View["new"]({
        model: new Backbone.Model(data)
      });
    };
  };

  attachGlobalEvents = function() {
    var i, searchBuffer, startCapturing, _i;
    startCapturing = false;
    searchBuffer = '';
    $('[contenteditable],input,textarea').focus(function() {
      return window.isEditing = true;
    }).blur(function() {
      return window.isEditing = false;
    }).keyup(function(e) {
      if (e.keyCode === 27) {
        return $(e.target).blur();
      }
    });
    for (i = _i = 1; _i <= 6; i = ++_i) {
      $('.rich').on('keydown', null, 'alt+meta+' + i, (function(i) {
        return function() {
          var selNode;
          selNode = $(window.getSelection().baseNode);
          if (selNode.parent("h1,h2,h3,h4,h5").length) {
            selNode.unwrap();
          }
          return selNode.wrap("<h" + i + ">");
        };
      })(i));
    }
    $('.rich').on('keydown', null, 'alt+meta+0', function() {
      var selNode;
      selNode = $(window.getSelection().baseNode);
      if (selNode.parent("h1,h2,h3,h4,h5").length) {
        return selNode.unwrap();
      }
    });
    return $(document).bind('keypress', function(e) {
      var char;
      char = String.fromCharCode(e.keyCode);
      if (!window.isEditing && char === '/') {
        if (startCapturing && searchBuffer === '') {
          return location.href = '/';
        } else {
          searchBuffer = '';
          startCapturing = true;
          return $('#client-search').modal().on('hide', function() {
            return $('#client-search .search-box').blur();
          }).on('shown', function() {
            startCapturing = false;
            return $('#client-search .search-box').focus().val(searchBuffer).keydown(function(e) {
              var name;
              if (e.keyCode === 13) {
                name = $('#client-search .search-box').val();
                return location.href = name ? '/client/' + name : '/';
              }
            });
          });
        }
      } else if (startCapturing) {
        return searchBuffer += char;
      }
    });
  };

  $(function() {
    var view;
    if (!(client.view in client.views)) {
      console.error("Invalid view: '{0}'. This value must exactly match the name of a view function stored on client.views.".supplant([client.view]));
    }
    view = new client.views[client.view]({
      model: new Backbone.Model(client.data)
    });
    Creatable.render(view);
    return attachGlobalEvents();
  });

}).call(this);
