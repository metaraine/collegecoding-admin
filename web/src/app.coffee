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
    "Name": String
    "Type": String
    "First Contact": Date
    "Last Contact": Date
    "Balance": Number
    "Auto Action": String
    "Platform": String
    "TZone": String
    "Source": String
    "City": String
    "State": String
    "Phone": String
    "School": String
    "Program": String
    "Class": String
    "Notes": String
Client = mongoose.model 'Client', clientSchema

# controller
app.get '/', (req, res) ->
  Client
    .find(Type: "Current Client")
    .sort('Name')
    .exec (err, clients) ->
      render req, res, 
        title: 'CC Admin'
        seed:
          view: 'index'
          data:
            clients: clients

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