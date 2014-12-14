/**
* User.js
*
* @description :: TODO: You might write a short summary of how this model works and what it represents here.
* @docs        :: http://sailsjs.org/#!documentation/models
*/

module.exports = {

  schema: true,

  attributes: {
    firstName: {
      type: 'string',
      required: true
    },

    lastName: {
      type: 'string',
      required: true
    },

    username: {
      type: 'string',
      required: true,
      unique: true
    },
    //set default to true to make admin user
    admin: {
      type: 'boolean',
      defaultsTo: false
    },

    online: {
      type: 'boolean',
      defaultsTo: false
    },

    encryptedPassword: {
      type: 'string',
    },

    gid: {
      type: 'integer',
      defaultsTo: 0
    },

    toJSON: function() {
      var obj = this.toObject();
      delete obj.password;
      delete obj.confirmation;
      delete obj.encryptedPassword;
      delete obj._csrf;

      return obj;
    }
  },
  //Will be implemented when checkbox is added to edit page.
  beforeValidation: function (values, next) {
    if(typeof values.admin !== 'undefined') {
      if(values.admin == 'unchecked') {
        values.admin = false;
      } else if (values.admin[1] === 'on') {
        values.admin = true;
      }
    }

    next();
  },

  beforeCreate: function (values, next) {
    if(!values.password || values.password != values.confirmation) {
      return next({err: ["Passwords do not match."]});
    }

    require("bcryptjs").hash(values.password, 10, function encryptPassword(err, encryptedPassword) {
      if(err) return next(err);

      values.encryptedPassword = encryptedPassword;
      next();
    });
  }
};
