client.views.client = Backbone.View.extend(

  initialize: () ->
    this.on('render', (el) ->
      $("[contenteditable]", el).on('input', _.debounce(() -> 
        $.post(location.href, RJS.keyValue($(this).data('name'), $(this).html()))
      , 1000))
    )

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
        ['.masthead', [
          ['h3 a.muted', {href: '/'}, 'College Coding']
        ]]
        ['hr']
        ['h1', { 'data-name': 'name', contenteditable: true }, this.model.get('name')]
        ['.row-fluid.marketing', [

          ['.span6', [
            ['table.def-list', [
              ['tr', [
                ['td', 'First Contact']
                ['td', moment(this.model.get('firstContact')).format('MMMM Do, YYYY')]
              ]]
              this.buildEditableRow('Client Type', 'clientType')
              this.buildEditableRow('Balance', 'balance')
              this.buildEditableRow('Platform', 'platform')
              this.buildEditableRow('Timezone', 'timezone')
              this.buildEditableRow('Referrer', 'referrer')
              this.buildEditableRow('City', 'city')
              this.buildEditableRow('State', 'state')
              this.buildEditableRow('Phone', 'phone')
              this.buildEditableRow('School', 'school')
              this.buildEditableRow('Program', 'program')
              this.buildEditableRow('Class', 'class')
              this.buildEditableRow('Notes', 'notes')
              this.buildEditableRow('Notes2', 'notes2')
            ]]
          ]]

          ['.span6', [
            ['h4', 'Balance']
            ['table.def-list', 
              this.buildBalance()
            ]

            ['h4', 'Past Sessions']
            ['table.def-list', 
              this.model.get('sessions').map this.buildSession
            ]

            ['h4', 'Payments']
            ['table.def-list', 
              this.model.get('payments').map this.buildPayment
            ]
          ]]
        ]]

        new client.partials.footer()
      ]]
    ]]

  buildSession: (session) ->
    ['tr', [
      ['td', moment(session.date).format('M/D/YY')]
      ['td', "#{session.duration} hr"]
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
)
