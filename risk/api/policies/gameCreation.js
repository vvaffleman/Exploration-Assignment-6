module.exports = function(req, res, ok) {
  var userGameId = req.session.User.gid;
  
  if(userGameId != 0) {
    var multipleJoinError = [{name : 'noJoin', message: 'You already joined a game.'}]

    req.session.flash = {
      err: multipleJoinError
    }

    res.redirect('/game');
    return;
  }

  ok();
};
