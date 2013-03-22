# includes
express =     require('express')
mongoose =    require('mongoose')
rjs =         require('rjs').installPrototypes()
config =      require('./config').config
render =      require('./controller-helper.js').render

# create app and set middleware
app = express()
app.set 'view engine', 'jade'
app.set 'views', __dirname + '/views'
app.use express.logger('dev')
app.use express.bodyParser()
app.use express.cookieParser()
app.use express.session(secret: config.sessionSecret)
app.use express.static(__dirname + '/public')

mongoose.connect('mongodb://localhost/ccadmin')
db = mongoose.connection
db.on 'error', console.error.bind(console, 'connection error:')
db.once 'open', () ->
  console.log('Successfully connected to db')

# model
model = 
  client: mongoose.model 'Client', mongoose.Schema
    _id: mongoose.Schema.ObjectId,
    name: String
    clientType: String
    created: Date
    firstContact: Date
    balance: Number
    platform: String
    timezone: String
    referrer: String
    city: String
    state: String
    email: String
    phone: String
    school: String
    schoolProgram: String
    schoolClass: String
    notes: String
    rate: String
    payments: [
      _id: mongoose.Schema.ObjectId
      amount: Number
      rate: Number
      date: Date
      notes: String
    ]
    sessions: [
      _id: mongoose.Schema.ObjectId
      duration: Number
      rate: Number
      date: Date
      notes: String
    ]

  session: mongoose.model 'Session', mongoose.Schema
    _id: mongoose.Schema.ObjectId,
    duration: Number
    name: String
    rate: Number
    date: Date
    notes: String

  payment: mongoose.model 'Payment', mongoose.Schema
    _id: mongoose.Schema.ObjectId,
    amount: Number
    name: String
    rate: Number
    date: Date
    notes: String

# controllers
app.get '/', (req, res) ->
  model.client
    .find(
      $or: [
        {clientType: "Current Client"},
        {clientType: "Lead"}
      ]
    )
    .sort('name')
    .exec (err, clients) ->
      model.session
        .find(date: { $gte: new Date(Date.now() - 3 * 30 * 24 * 60 * 60 * 1000) })
        .sort('date')
        .exec (err, sessions) ->

          # get sessions per day time series
          dateValueSeries = rjs.orderedGroup(sessions, 'date').map((dateGroup)->
            date: new Date(dateGroup.key).getTime()
            value: dateGroup.items.length
          )
          dates = dateValueSeries.pluck('date')
          values = dateValueSeries.pluck('value')

          render req, res, 
            title: 'College Coding Admin'
            seed:
              view: 'index'
              data: 
                # test RJS.findByProperty on the server-side
                activeClients: clients.filter (client) -> client.clientType == 'Current Client'
                leads:         clients.filter (client) -> client.clientType == 'Lead'
                sessionsPerDay:
                  x: dates
                  y: values

app.get '/client/:name', (req, res) ->
  model.client.findOne(name: new RegExp('.*' + req.params.name + '.*', 'i')).exec (err, client) ->
    if not client
      render req, res, 
        title: 'New Client: ' + req.params.name
        seed:
          view: 'newclient'
          data: 
            name: req.params.name
    else
      model.session.find(name: client.name).sort('date').exec (err, sessions) ->
        model.payment.find({name: client.name}).sort('date').exec (err, payments) ->
          client.sessions = sessions
          client.payments = payments
          render req, res, 
            title: req.params.name
            seed:
              view: 'client'
              data: client

app.post '/client/:name', (req, res) ->
  model.client
    .update(
      {name: new RegExp('.*' + req.params.name + '.*', 'i')},
      req.body
    )
    .exec (err, numberAffected, raw) ->
      res.send()

app.post '/db/:collection', (req, res) ->
  doc = new model[req.params.collection](req.body)
  doc.save ()->
    res.send()

app.post '/client/:name/session', (req, res) ->
  model.client.findOne(name: new RegExp('.*' + req.params.name + '.*', 'i')).exec (err, client) ->
    session = new model.session(req.body);
    session.name = client.name;
    session.save ()->
      res.send()

app.post '/client/:name/payment', (req, res) ->
  model.client.findOne(name: new RegExp('.*' + req.params.name + '.*', 'i')).exec (err, client) ->
    payment = new model.payment(req.body);
    payment.name = client.name;
    payment.save ()->
      res.send()

# start
app.listen process.env.PORT, ->
  console.log 'Listening on port ' + process.env.PORT

# export globals
exports.app = app