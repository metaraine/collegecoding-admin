// Generated by CoffeeScript 1.4.0

/*
Serializes the view data for bootstrapping and renders with the 'layout' view.
Sends the raw JSON if 'format=json'.
*/


(function() {

  exports.render = function(req, res, viewData) {
    if (req.query.format === 'json') {
      return res.send(viewData);
    } else {
      viewData.seed = JSON.stringify(viewData.seed);
      return res.render('layout', viewData);
    }
  };

}).call(this);
