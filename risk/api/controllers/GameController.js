/**
 * GameController
 *
 * @description :: Server-side logic for managing games
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

module.exports = {
	'new': function(req, res) {
		res.view();
	},

	index: function (req, res, next){
		Game.find(function foundGames(err, games) {
			if(err) return next(err);
			req.session.User.gid = 0;
			res.view({
				games: games
			});
		});
	},

	create: function(req, res, next) {
		Game.create(req.params.all(), function gameCreated(err, game) {
			if(err) {
				req.session.flash = {
					err: err
				}
				//If there's an error, redirect to the new game view
				return res.redirect('/game/new');
			}

			req.session.User.gid = game.id;

			res.redirect('/game');
		});

	},

	delete: function (req, res, next){
		Game.findOne(req.param('id'), function foundGames(err, game) {
			if(err) return next(err);
			if(!game) return next("User doesn't exist.");

			Game.destroy(req.param('id'), function gameDestroyed(err){
				if(err) return next(err);
			});
		
			req.session.User.gid = 0;

			res.redirect('/game');
		});
	},

	join: function (req, res, next){
		Game.findOne(req.param('id'), function foundGames(err, game){
			if(err) return next(err);
			if(!game) return next("Game doesn't exist.");

			req.session.User.gid = req.param('id');

			Game.update(req.param('id'), function gameUpdated(err){
				if(err) return next(err);

				game.numberOfPlayers += 1;
			});

			console.log("gid: " + req.session.User.gid + " players: " + game.numberOfPlayers)
			res.redirect('/game');
		});

	}
}
