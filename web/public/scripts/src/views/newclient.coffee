client.views.newclient = Backbone.View.extend

  events:
    'click #create': 'create'

  initialize: ()->
    that = this
    $(document).on 'keypress', (e)->
      if e.keyCode is 13
        that.create()

  create: ()->
    $.post '/db/clients', {
      name:         this.model.get 'name'
      clientType:   'lead'
      leadStatus:   'hot'
      referrer:     'Google'
      created:      new Date()
      firstContact: new Date()
    }, ()->
      location.reload()

  build: ()->
    ['#page-newclient', [
      ['.container-narrow', [
        new client.partials.Header()
        ['.text-center', [
          ['h1', { 'data-name': 'name' }, this.model.get('name')]
          ['p', "This client does not yet exist. Would you like to create #{this.model.get('name')}?"]
          ['button#create.btn.btn-primary.btn-large', 'Create']
        ]]
        new client.partials.Footer()
      ]]
    ]]
