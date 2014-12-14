//Ensures the user can only see a profile if its their own or if they are an admin.
module.exports = function(req, res, ok) {
  var sessionUserMatch = req.session.User.id == req.param('id');
  var isAdmin = req.session.User.admin;

  if(!(sessionUserMatch || isAdmin)) {
    var noAccessError = [{name : 'noAccess', message: 'You must be an admin to view this page.'}]

    req.session.flash = {
      err: noAccessError
    }

    res.redirect('/session/new');
    return;
  }

  ok();
};
