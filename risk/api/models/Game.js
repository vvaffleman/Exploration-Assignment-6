/**
* Game.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  schema: true,

  attributes: {
    host: {
      type: 'string',
      required: true
    },

    name: {
      type: 'string',
      unique: true,
      required: true
    },

    numberOfPlayers: {
      type: 'integer',
      required: true
    },

    inProgress: {
      type: 'boolean',
      defaultsTo: 'false'
    },

    toJSON: function() {
      var obj = this.toObject();

      return obj;
    }
  }
};
