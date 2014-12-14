/**
 * SessionController
 *
 * @description :: Server-side logic for managing sessions
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

var bcrypt = require('bcryptjs');

module.exports = {
	'new': function(req,res) {

		res.view('static/index');
	},

	'create': function(req, res, next) {

		if(!req.param('username') || !req.param('password')) {
			var usernameAndPasswordRequiredError = [{name: 'usernameAndPasswordRequired', message: "Username and password required."}]

			req.session.flash = {
				err: usernameAndPasswordRequiredError
			}

			res.redirect('/session/new');
			return;
		}

		User.findOneByUsername(req.param('username'), function foundUser(err, user) {
			if(err) return next(err);

			if(!user) {
				var userDoesntExist = [{name: 'userDoesntExist', message: "The username " + req.param('username') + " wasn't found."}]

				req.session.flash = {
					err: userDoesntExist
				}

				res.redirect('/session/new');
				return;
			}

			bcrypt.compare(req.param('password'), user.encryptedPassword, function(err, valid){
				if(err) return next(err);

				if(!valid) {
					var usernameAndPasswordDontMatch = [{name: 'usernameAndPasswordDontMatch', message: 'Invalid username and password combination'}]

					req.session.flash = {
						err: usernameAndPasswordDontMatch
					}

					res.redirect('/session/new');
					return;
				}

				req.session.authenticated = true;
				req.session.User = user;

				user.online = true;
				user.save(function(err, user) {

					//If the user is an admin, redirect to the user admin page. Otherwise,
					//redirect to their profile page.
					if(req.session.User.admin){

						res.redirect('/user');
						return;
					}

					res.redirect('/user/profile/' + user.id);
				});
			});
		});
	},

	'destroy': function(req, res, next) {
	 	User.findOne(req.session.User.id, function foundUser(err, user){
			var userId = req.session.User.id;

			User.update(userId, {
				online: false
			}, function(err) {
				if(err) return next(err);

				req.session.destroy();

				res.redirect('/session/new');
			});
		});
	}
};
