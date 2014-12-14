//Checks if user is an admin.

module.exports = function(req, res, ok) {

  if(req.session.User && req.session.User.admin) {
    return ok();
  } else {
    var NonAdminError = [{name: 'NonAdminError', message: 'You must be an admin to access this page.'}]

    req.session.flash = {
      err: NonAdminError
    }

    res.redirect('/session/new');
    return;
  }
};
