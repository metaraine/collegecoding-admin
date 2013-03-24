# includes
express =     require('express')
mongoose =    require('mongoose')
rjs =         require('rjs').installPrototypes()
async =       require('async')
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
  clients: mongoose.model 'Client', mongoose.Schema
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

  sessions: mongoose.model 'Session', mongoose.Schema
    _id: mongoose.Schema.ObjectId,
    duration: Number
    name: String
    rate: Number
    date: Date
    notes: String

  payments: mongoose.model 'Payment', mongoose.Schema
    _id: mongoose.Schema.ObjectId,
    amount: Number
    name: String
    rate: Number
    date: Date
    notes: String

rollingSum = (xySeries, n)->
  (xySeries[i-n..i].reduce((x,y)->x+y) for i in [n..xySeries.length])

# controllers
app.get '/', (req, res) ->
  async.parallel {
    clients: (callback)->
      model.clients
        .find({clientType: 'client', clientStatus: 'active'}) # how to do a join?
        .sort('name')
        .exec callback
    sessions3Months: (callback)->
      model.sessions
        .find(date: { $gte: new Date(Date.now() - 3 * 30 * 24 * 60 * 60 * 1000) })
        .sort('date')
        .exec callback
  }, (err, results)->

    # get sessions per day time series
    perDaySeries = rjs.orderedGroup(results.sessions3Months, 'date').map (dateGroup)->
      date: new Date(dateGroup.key).getTime()
      value: dateGroup.items.length
    perDayXY =
      x: perDaySeries.pluck('date')
      y: perDaySeries.pluck('value')

    # get rolling 7-day sum
    perDayXY7DaySum =
      x: perDayXY.x[6..]
      y: rollingSum(perDayXY.y, 7)

    render req, res, 
      title: 'College Coding Admin'
      seed:
        view: 'index'
        data: 
          # test RJS.findByProperty on the server-side
          perDayXY: perDayXY
          perDayXY7DaySum: perDayXY7DaySum

app.get '/client/:name', (req, res) ->
  model.clients.findOne(name: new RegExp('.*' + req.params.name + '.*', 'i')).exec (err, client)->
    if not client
      render req, res, 
        title: 'New Client: ' + req.params.name
        seed:
          view: 'newclient'
          data: 
            name: req.params.name
    else
      async.parallel {
        sessions: (callback)->
          model.sessions.find(name: client.name).sort('date').exec(callback)
        payments: (callback)->
          model.payments.find(name: client.name).sort('date').exec(callback)
      }, (err, results)->
          client.sessions = results.sessions
          client.payments = results.payments
          render req, res, 
            title: client.name
            seed:
              view: 'client'
              data: client

app.post '/client/:name', (req, res) ->
  model.clients
    .update(
      {name: new RegExp('.*' + req.params.name + '.*', 'i')},
      req.body
    )
    .exec (err, numberAffected, raw) ->
      res.send()

app.post '/db/:collection', (req, res) ->
  if req.params.collection not of model
    res.send 500, req.params.collection + ' is not a valid collection'
  else
    doc = new model[req.params.collection](req.body)
    doc.save ()->
      res.send()

# start
app.listen process.env.PORT, ->
  console.log 'Listening on port ' + process.env.PORT

# export globals
exports.app = app