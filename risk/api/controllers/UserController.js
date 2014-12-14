/**
 * UserController
 *
 * @description :: Server-side logic for managing users
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	//Displays the crete new user account view
	'new': function(req, res) {
		res.view();
	},

	//creates a new user and displays the user created view
	create: function(req, res, next) {
		User.create(req.params.all(), function userCreated(err, user) {
			if(err) {
				req.session.flash = {
					err: err
				}
				//If there's an error, redirect to the create new user view
				return res.redirect('/user/new');
			}

			//Log user in after successful creation
			req.session.authenticated = true;

			req.session.User = user;

			user.online = true;

			//user.save(function(err, user) {
			//		if(err) return next(err);

			//If an account is successfully created, call the created function
			res.redirect('/user/profile/' + user.id);
			//});
		});
	},

	//Displays the created view with relevant user information
	created: function (req, res, next){
		User.findOne(req.param('id'), function foundUser(err, user) {

			if(err) return next(err);
			if(!user) return next();

			res.view({
				user: user
			});
		});
	},

	profile: function (req, res, next){
		User.findOne(req.param('id'), function foundUser(err, user) {
			if(err) return next(err);
			if(!user) return next();
			res.view({
				user: user
			});
		});
	},

	delete: function (req, res, next){

		User.findOne(req.param('id'), function foundUser(err, user) {
			if(err) return next(err);
			if(!user) return next("User doesn't exist.");

			User.destroy(req.param('id'), function userDestroyed(err){
				if(err) return next(err);
			});

			res.redirect('/user');
		});
	},

	//Gets a list of all the users
	index: function (req, res, next){
		User.find(function foundUsers(err, users) {
			if(err) return next(err);

			res.view({
				users: users
			});
		});
	},

	subscribe: function(req, res) {
		User.find(function foundUsers(err, users){
			if(err) next(err);
			//subscribe this socket to the User model classroom
			User.subscribe(req.socket);
			//subscribe this socket to the User instance rooms
			User.subscribe(req.socket, users);
		});
	}
};
