// Generated by CoffeeScript 1.4.0
(function() {
  var Client, app, clientSchema, config, db, express, mongoose, render, rjs;

  express = require('express');

  mongoose = require('mongoose');

  rjs = require('rjs').installPrototypes();

  config = require('./config').config;

  render = require('./controller-helper.js').render;

  app = express();

  app.set('view engine', 'jade');

  app.set('views', __dirname + '/views');

  app.use(express.logger('dev'));

  app.use(express.bodyParser());

  app.use(express.cookieParser());

  app.use(express.session({
    secret: config.sessionSecret
  }));

  app.use(express["static"](__dirname + '/public'));

  mongoose.connect('mongodb://localhost/ccadmin');

  db = mongoose.connection;

  db.on('error', console.error.bind(console, 'connection error:'));

  db.once('open', function() {
    return console.log('Successfully connected to db');
  });

  clientSchema = mongoose.Schema({
    name: String,
    clientType: String,
    firstContact: Date,
    lastContact: Date,
    balance: Number,
    autoAction: String,
    platform: String,
    timezone: String,
    referrer: String,
    city: String,
    state: String,
    phone: String,
    school: String,
    schoolProgram: String,
    schoolClass: String,
    notes: String,
    notes2: String,
    rate: String,
    sessions: [
      {
        date: Date,
        duration: Number
      }
    ],
    payments: [
      {
        date: Date,
        amount: Number
      }
    ]
  });

  Client = mongoose.model('Client', clientSchema);

  app.get('/', function(req, res) {
    return Client.find({
      $or: [
        {
          clientType: "Current Client"
        }, {
          clientType: "Lead"
        }
      ]
    }).sort('name').exec(function(err, clients) {
      if (err) {
        return res.send(500, err);
      } else {
        return render(req, res, {
          title: 'CC Admin',
          seed: {
            view: 'index',
            data: {
              activeClients: clients.filter(function(client) {
                return client.clientType === 'Current Client';
              }),
              leads: clients.filter(function(client) {
                return client.clientType === 'Lead';
              })
            }
          }
        });
      }
    });
  });

  app.get('/client/:name', function(req, res) {
    return Client.findOne({
      name: new RegExp('.*' + req.params.name + '.*', 'i')
    }).exec(function(err, client) {
      if (err) {
        return res.send(500, err);
      } else {
        return render(req, res, {
          title: req.params.name,
          seed: {
            view: 'client',
            data: client
          }
        });
      }
    });
  });

  app.post('/client/:name', function(req, res) {
    return Client.update({
      name: new RegExp('.*' + req.params.name + '.*', 'i')
    }, req.body).exec(function(err, numberAffected, raw) {
      if (err) {
        return res.send(500, err);
      } else {
        return res.send();
      }
    });
  });

  app.get('/:page', function(req, res) {
    return render(req, res, {
      title: 'CC Admin',
      seed: {
        view: req.params.page
      }
    });
  });

  app.listen(process.env.PORT, function() {
    return console.log('Listening on port ' + process.env.PORT);
  });

  exports.app = app;

}).call(this);
