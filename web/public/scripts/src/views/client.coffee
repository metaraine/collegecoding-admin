client.views.client = Backbone.View.extend

  events:
    'click #add-session':               'showAddSession'
    'click #add-session-form .add':     'addSession'
    'click #add-session-form .cancel':  'cancelAddSession'
    'click #add-payment':               'showAddPayment'
    'click #add-payment-form .add':     'addPayment'
    'click #add-payment-form .cancel':  'cancelAddPayment'

  initialize: () ->
    that = this
    this.on('render', (el) ->
      $("[contenteditable]", el).on('input', _.debounce(() -> 
        url = '/client/{0}'.supplant([that.model.get('name')])
        $.post(url, RJS.keyValue($(this).data('name'), $(this).html()))
      , 1000))
    )

  showAddSession: (e) ->
    e.preventDefault()
    $('#add-session').hide()
    $('#add-session-form').fadeIn()

  addSession: (e) ->
    e.preventDefault()
    url = '/client/{0}/session'.supplant([this.model.get('name')])
    $.post(url, $('#add-session-form').serializeObject(),
      $('#add-session-form').hide()
      $('#add-session').fadeIn()
      location.reload()
    )

  cancelAddSession: (e) ->
    e.preventDefault()
    $('#add-session-form').hide()
    $('#add-session').fadeIn()

  showAddPayment: (e) ->
    e.preventDefault()
    $('#add-payment').hide()
    $('#add-payment-form').fadeIn()

  addPayment: (e) ->
    e.preventDefault()
    url = '/client/{0}/payment'.supplant([this.model.get('name')])
    $.post(url, $('#add-payment-form').serializeObject(),
      $('#add-payment-form').hide()
      $('#add-payment').fadeIn()
      location.reload()
    )

  cancelAddPayment: (e) ->
    e.preventDefault()
    $('#add-payment-form').hide()
    $('#add-payment').fadeIn()

  # Creates a read-only row in the client information table
  buildRow: (label, name) ->
    ['tr', [
      ['td', label]
      ['td', this.model.get(name)]
    ]]

  # Creates a contenteditable row in the client information table
  buildEditableRow: (label, name) ->
    ['tr', [
      ['td', label]
      ['td div', { 'data-name': name, contenteditable: true, html: true }, this.model.get(name)]
    ]]

  build: () ->
    ['#page-client', [
      ['.container-narrow', [
        new client.partials.Header(),
        ['h1', { 'data-name': 'name', contenteditable: true }, this.model.get('name')]
        ['.row-fluid.marketing', [

          ['.span6', [
            ['table.def-list', [
              ['tr', [
                ['td', 'First Contact']
                ['td', moment(this.model.get('firstContact')).format('MMMM Do, YYYY')]
              ]]
              this.buildEditableRow('Client Type', 'clientType')
              this.buildEditableRow('Platform', 'platform')
              this.buildEditableRow('Email', 'email')
              this.buildEditableRow('Timezone', 'timezone')
              this.buildEditableRow('City', 'city')
              this.buildEditableRow('State', 'state')
              this.buildEditableRow('Phone', 'phone')
              this.buildEditableRow('School', 'school')
              this.buildEditableRow('Program', 'schoolProgram')
              this.buildEditableRow('Class', 'schoolClass')
              this.buildEditableRow('Referrer', 'referrer')
              this.buildEditableRow('Notes', 'notes')
            ]]
          ]]

          ['.span6', [
            ['h4', 'Balance']
            ['table.def-list', 
              this.buildBalance()
            ]

            ['h4', 'Sessions']
            ['table.def-list', this.model.get('sessions').map(this.buildSession)]
            ['a#add-session', { href: '#' }, 'Add']
            ['form#add-session-form.form-inline.hide', [
              ['input.input-mini', { name: 'date', type: 'text', value: moment().format('M/D/YY') }]
              ['input.input-mini', { name: 'duration', type: 'text', value: 1 }]
              ['button.add.btn', 'Add']
              ['button.cancel.btn.btn-link', 'Cancel']
            ]]

            ['h4', 'Payments']
            ['table.def-list', 
              this.model.get('payments').map this.buildPayment
            ]
            ['a#add-payment', { href: '#' }, 'Add']
            ['form#add-payment-form.form-inline.hide', [
              ['input.input-mini', { name: 'date', type: 'text', value: moment().format('M/D/YY') }]
              ['input.input-mini', { name: 'amount', type: 'text', value: 1 }]
              ['button.add.btn', 'Add']
              ['button.cancel.btn.btn-link', 'Cancel']
            ]]
          ]]
        ]]

        new client.partials.Footer()
      ]]
    ]]

  buildSession: (session) ->
    ['tr', [
      ['td', moment(session.date).format('M/D/YY')]
      ['td', session.duration]
      ['td', session.notes]
    ]]

  buildPayment: (payment) ->
    ['tr', [
      ['td', moment(payment.date).format('M/D/YY')]
      ['td', payment.amount]
    ]]

  buildBalance: () ->
    paymentHours = this.model.get('payments').pluck('amount')
    sessionHours = this.model.get('sessions').pluck('duration').map (x) -> -x
    _.reduce(paymentHours.concat(sessionHours), ((x,y) -> x+y), 0)
