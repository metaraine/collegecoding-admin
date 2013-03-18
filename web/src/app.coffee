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
clientSchema = mongoose.Schema
    #"_id": new ObjectID("513e3b3091b3b925b386821d"),
    name: String
    clientType: String
    firstContact: Date
    lastContact: Date
    balance: Number
    autoAction: String
    platform: String
    timezone: String
    referrer: String
    city: String
    state: String
    phone: String
    school: String
    schoolProgram: String
    schoolClass: String
    notes: String
    notes2: String
    rate: String
    sessions: [
      date: Date
      duration: Number
    ],
    payments: [
      date: Date
      amount: Number
    ]
Client = mongoose.model 'Client', clientSchema

# controller
app.get '/', (req, res) ->
  Client
    .find(
      $or: [
        {clientType: "Current Client"},
        {clientType: "Lead"}
      ]
    )
    .sort('name')
    .exec (err, clients) ->
      render req, res, 
        title: 'CC Admin'
        seed:
          view: 'index'
          data: 
            # test RJS.findByProperty on the server-side
            activeClients: clients.filter (client) -> client.clientType == 'Current Client'
            leads:         clients.filter (client) -> client.clientType == 'Lead'

app.get '/client/:name', (req, res) ->
  Client
    .findOne(name: new RegExp('.*' + req.params.name + '.*', 'i'))
    .exec (err, client) ->
      render req, res, 
        title: req.params.name
        seed:
          view: 'client'
          data: client


app.get '/:page', (req, res) ->
  render req, res, 
    title: 'CC Admin'
    seed:
      view: req.params.page

# start
app.listen process.env.PORT, ->
  console.log 'Listening on port ' + process.env.PORT

# export globals
exports.app = app