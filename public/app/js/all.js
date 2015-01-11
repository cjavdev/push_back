"use strict";
var dependencies = ['ionic', 'push.controllers', 'push.services', 'push.filters'];
window.PB = angular.module('push', dependencies).run(function($ionicPlatform) {
  openFB.init({appId: '1389364367952791'});
  $ionicPlatform.ready(function() {
    if (window.cordova && window.cordova.plugins.Keyboard) {
      cordova.plugins.Keyboard.hideKeyboardAccessoryBar(true);
    }
    if (window.StatusBar) {
      StatusBar.styleDefault();
    }
  });
}).constant('loc', {apiBase: 'http://www.pushbit.io'});

"use strict";
angular.module('push.controllers', []);
angular.module('push.services', []);
angular.module('push.filters', []);
PB.config(function($stateProvider, $urlRouterProvider, $httpProvider, $windowProvider) {
  $httpProvider.interceptors.push(function($q, EventBus) {
    return {'responseError': function(rejection) {
        if (rejection.status === 403) {
          EventBus.trigger('loginRequired', rejection);
        }
        return $q.reject(rejection);
      }};
  });
  var $window = $windowProvider.$get();
  $httpProvider.defaults.headers.common['AuthToken-X'] = $window.localStorage.authToken;
  $stateProvider.state('workout', {
    url: "/workout/:id",
    templateUrl: "templates/workout.html"
  }).state('tab', {
    url: "/tab",
    abstract: true,
    templateUrl: "templates/tabs.html"
  }).state('tab.workouts', {
    url: '/workouts',
    views: {'tab-workouts': {
        templateUrl: 'templates/tab-workouts.html',
        controller: 'WorkoutsCtrl'
      }}
  }).state('tab.friends', {
    url: '/friends',
    views: {'tab-friends': {
        templateUrl: 'templates/tab-friends.html',
        controller: 'FriendsCtrl'
      }}
  }).state('tab.account', {
    url: '/account',
    views: {'tab-account': {
        templateUrl: 'templates/tab-account.html',
        controller: 'AccountCtrl'
      }}
  });
  $urlRouterProvider.otherwise('/tab/workouts');
});

"use strict";
angular.module('push.controllers').controller('BaseCtrl', function($scope, $ionicModal) {
  $ionicModal.fromTemplateUrl('templates/login.html', function(modal) {
    $scope.loginModal = modal;
  }, {
    scope: $scope,
    animation: 'slide-in-up'
  });
  $scope.$on('$destroy', function() {
    $scope.loginModal.remove();
  });
});

"use strict";
angular.module('push.filters').filter('reverse', function() {
  return function(items) {
    return items.slice().reverse();
  };
}).filter('challengable2', function(Friendship) {
  var friendsIds = Friendship.allFbids();
  return function(items) {
    function alreadyFriends(id) {
      return _.contains(friendsIds, id);
    }
    return _.filter(items, function(item) {
      return !alreadyFriends(item.get('fbid'));
    });
  };
}).filter('orderByFriendReps', function() {
  return function(friendships) {
    return _.sortBy(friendships, function(f) {
      return f.friend.totalReps();
    });
  };
});

"use strict";
angular.module('push.services').service('Contacts', function($q) {
  var formatContact = function(contact) {
    var primaryPhoneNumber = '';
    if (contact.phoneNumbers[0]) {
      primaryPhoneNumber = contact.phoneNumbers[0].value;
    }
    return {
      "displayName": contact.name.formatted || contact.name.givenName + " " + contact.name.familyName || "Mystery Person",
      "emails": contact.emails || [],
      "phones": contact.phoneNumbers || [],
      "primaryPhoneNumber": primaryPhoneNumber,
      "photos": contact.photos || []
    };
  };
  function pickContact() {
    var dfd = $q.defer();
    if (navigator && navigator.contacts) {
      navigator.contacts.pickContact(function(contact) {
        dfd.resolve(formatContact(contact));
      });
    } else {
      dfd.reject("Bummer. No contacts in desktop browser");
    }
    return dfd.promise;
  }
  return {pickContact: pickContact};
});

"use strict";
angular.module('push.services').factory('Model', function($http, $q, $window, loc) {
  return function(options) {
    var path = options.path;
    var url = loc.apiBase + path;
    var Model = function Model(attrs) {
      this.setup.apply(this, arguments);
      attrs = attrs || {};
      this.attributes = {};
      this.set(this.parse(attrs));
      this.initialize.apply(this, arguments);
    };
    ($traceurRuntime.createClass)(Model, {
      get id() {
        return this.attributes.id;
      },
      initialize: function() {},
      setup: function() {},
      set: function(attrs) {
        for (var attr in attrs) {
          this.attributes[attr] = attrs[attr];
        }
        return this;
      },
      get: function(key) {
        return this.attributes[key];
      },
      parse: function(response) {
        return response;
      },
      save: function() {
        if (this.id) {
          console.log('updating!', this.attributes);
          return this.update();
        } else {
          console.log('creating!', this.attributes);
          return this.create();
        }
      },
      update: function() {
        var $__0 = this;
        var dfd = $q.defer();
        $http.put(this.url(), this.attributes).then((function(response) {
          $__0.set($__0.parse(response.data));
          dfd.resolve($__0);
        }), (function(response) {
          console.log('Update failed');
          dfd.reject($__0);
        }));
        return dfd.promise;
      },
      create: function() {
        var $__0 = this;
        var dfd = $q.defer();
        $http.post(this.url(), this.attributes).then((function(response) {
          $__0.set($__0.parse(response.data));
          dfd.resolve($__0);
        }), (function(response) {
          console.log('Create failed');
          dfd.reject($__0);
        }));
        return dfd.promise;
      },
      url: function() {
        if (this.id) {
          return url + '/' + this.id;
        } else {
          return url;
        }
      }
    }, {});
    Model.url = (function() {
      return url;
    });
    var _all = [];
    function readAllLocal() {
      if ($window.localStorage[path]) {
        var attrs = JSON.parse($window.localStorage[path]);
        _all = _.map(attrs, (function(attr) {
          return new Model(attr);
        }));
      }
    }
    function writeAllLocal(attrs) {
      $window.localStorage[path] = JSON.stringify(attrs);
    }
    Model.ids = function() {
      return _.map(_all, (function(model) {
        return model.id;
      }));
    };
    Model.all = function() {
      readAllLocal();
      var ids = Model.ids();
      $http.get(url, {cache: true}).then((function(response) {
        writeAllLocal(response.data);
        _.each(response.data, (function(data) {
          if (!_.any(_all, (function(m) {
            return m.id === data.id;
          }))) {
            _all.push(new Model(data));
          }
        }));
      }));
      return _all;
    };
    Model.create = function(attributes) {
      var model = new Model(attributes);
      _all.push(model);
      return model.save();
    };
    return Model;
  };
});

"use strict";
angular.module('push.services').factory('EventBus', function() {
  var events = {};
  return {
    on: function(eventName, callback) {
      console.log('ListeningTo: ', eventName);
      events[eventName] = (events[eventName] || []);
      events[eventName].push(callback);
    },
    trigger: function(eventName) {
      console.log('Triggering: ', eventName);
      events[eventName] = (events[eventName] || []);
      var args = [].slice.call(arguments, 1);
      for (var $__0 = events[eventName][$traceurRuntime.toProperty(Symbol.iterator)](),
          $__1; !($__1 = $__0.next()).done; ) {
        var callback = $__1.value;
        {
          callback(args);
        }
      }
    }
  };
});

"use strict";
angular.module('push.services').factory('User', function($q, $http, $window, EventBus, loc) {
  function updateHeaders(params) {
    $window.localStorage.authToken = params.session_token;
    $http.defaults.headers.common['AuthToken-X'] = params.session_token;
  }
  function saveUser(params) {
    $window.localStorage.currentUser = JSON.stringify(params);
  }
  function currentUser() {
    return JSON.parse($window.localStorage.currentUser);
  }
  function pushbitLogin(loginParams) {
    var dfd = $q.defer();
    $http.post(loc.apiBase + '/session', loginParams).then(function(response) {
      updateHeaders(response.data);
      saveUser(response.data);
      dfd.resolve(response.data);
      EventBus.trigger('loginCompleted');
      EventBus.trigger('authChange');
    });
    return dfd.promise;
  }
  function getFBAuthParams(authResponse) {
    var dfd = $q.defer();
    openFB.api({
      path: '/v1.0/me',
      success: function(response) {
        response.authResponse = authResponse;
        pushbitLogin(response).then(function(user) {
          dfd.resolve(user);
        });
      },
      error: function() {
        dfd.reject();
      }
    });
    return dfd.promise;
  }
  function fbLogin() {
    var dfd = $q.defer();
    openFB.login(function(response) {
      if (response.status === "connected") {
        getFBAuthParams(response.authResponse).then(function(user) {
          dfd.resolve(user);
        });
      } else {
        dfd.reject(response.status);
      }
    }, {scope: 'email,user_friends,public_profile'});
    return dfd.promise;
  }
  function fbLogout() {
    var dfd = $q.defer();
    openFB.logout(function() {
      EventBus.trigger('loginRequired');
      EventBus.trigger('authChange');
      dfd.resolve();
    });
    return dfd.promise;
  }
  return {
    login: function() {
      return fbLogin();
    },
    logout: function() {
      $window.localStorage.clear();
      return fbLogout();
    },
    currentUser: currentUser
  };
});

"use strict";
angular.module('push.controllers').controller('LoginCtrl', function($scope, $state, User, EventBus) {
  $scope.message = '';
  $scope.login = function() {
    User.login();
  };
  EventBus.on('loginRequired', function(e, rejection) {
    $scope.loginModal.show();
  });
  EventBus.on('loginCompleted', function() {
    $scope.loginModal.hide();
  });
  EventBus.on('loginFailed', function(e, status) {
    $scope.message = "Login Failed";
  });
  EventBus.on('logoutCompleted', function() {
    $state.go('tab.dash', {}, {
      reload: true,
      inherit: false
    });
  });
});

"use strict";
angular.module('push.controllers').controller('AccountCtrl', function($scope, User) {
  $scope.logout = (function() {
    User.logout();
  });
});

"use strict";
angular.module('push.services').factory('Friend', function(Model) {
  var Friend = Model({path: '/friends'});
  Friend.prototype.name = function() {
    if (this.get('name')) {
      return this.get('name');
    }
    return this.get('f_name') + ' ' + this.get('l_name');
  };
  Friend.prototype.face = function() {
    return "https://graph.facebook.com/" + this.get('fbid') + "/picture?type=square";
  };
  Friend.prototype.sevenDayCount = function() {
    return this.get('seven_day_count');
  };
  Friend.fromFb = function(data) {
    var friend = new Friend({
      fbid: data.id,
      name: data.name
    });
    return friend;
  };
  return Friend;
}).factory('Friendship', function($http, Model, Friend, loc) {
  var Friendship = Model({path: '/friendships'});
  Friendship.prototype.parse = function(attrs) {
    if (attrs.friend) {
      this.friend = new Friend(attrs.friend);
      delete attrs.friend;
    }
    return attrs;
  };
  Friendship.prototype.name = function() {
    return this.friend.name();
  };
  Friendship.allFbids = function() {
    return _.map(Friendship.all(), (function(r) {
      return r.friend.get('fbid');
    }));
  };
  return Friendship;
});

"use strict";
angular.module('push.services').factory('FriendRequest', function($http, Model) {
  var FriendRequest = Model({path: '/friend_requests'});
  FriendRequest.prototype.accept = function() {
    var acceptUrl = this.url() + '/accept';
    console.log('sending accept request to: ', acceptUrl);
    return $http.post(acceptUrl);
  };
  FriendRequest.createForContact = function(contact) {
    var fbid = contact.get('fbid');
    var request = new FriendRequest({fbid: fbid});
    return request.save();
  };
  return FriendRequest;
}).factory('SentFriendRequest', function(Model) {
  var SentFriendRequest = Model({path: '/friend_requests?type=sent'});
  SentFriendRequest.allFbids = function() {
    return _.map(SentFriendRequest.all(), (function(r) {
      return r.get('recipient').fbid;
    }));
  };
  return SentFriendRequest;
});

"use strict";
angular.module('push.controllers').controller('FriendsCtrl', function($scope, $ionicModal, Friendship, FriendRequest, SentFriendRequest) {
  $scope.friendships = Friendship.all();
  $scope.requests = FriendRequest.all();
  $scope.anyChallengers = function() {
    return $scope.requests.length > 0;
  };
  $ionicModal.fromTemplateUrl('templates/friendships.html', function(modal) {
    $scope.friendshipsModal = modal;
  }, {
    scope: $scope,
    animation: 'slide-in-up'
  });
  $scope.showFriendships = function() {
    $scope.friendshipsModal.show();
  };
  $scope.done = function() {
    $scope.friendshipsModal.hide();
  };
  $scope.accept = function(request) {
    request.accept().then((function() {
      Friend.all();
    }));
  };
  SentFriendRequest.all();
});

"use strict";
angular.module('push.controllers').controller('FriendshipsCtrl', function($scope, $ionicPopup, EventBus, Friend, Friendship, Invitation, FriendRequest, SentFriendRequest) {
  $scope.friend = {email: ''};
  $scope.contacts = [];
  var pendingRequestIds = SentFriendRequest.allFbids();
  $scope.pending = function(id) {
    return _.contains(pendingRequestIds, id);
  };
  var friendsIds = Friendship.allFbids();
  function alreadyFriends(id) {
    return _.contains(friendsIds, id);
  }
  $scope.challengeable = function(id) {
    return !$scope.pending(id) && !alreadyFriends(id);
  };
  openFB.api({
    path: '/v2.2/me/friends',
    success: function(response) {
      console.log('getting fb friends: ', response.data);
      $scope.contacts = _.map(response.data, (function(f) {
        return Friend.fromFb(f);
      }));
    },
    error: function(response) {
      console.log('err getting FB friends!', response);
      if (response.code === 190) {
        EventBus.trigger('loginRequired');
      }
    }
  });
  $scope.challengeContact = function(contact) {
    pendingRequestIds.push(contact.id);
    FriendRequest.createForContact(contact);
  };
  $scope.inviteFriend = function(email) {
    console.log('inviting', email);
    Invitation.create({email: email}).then(function() {
      $scope.friend.email = '';
      var alertPopup = $ionicPopup.alert({
        title: "Success",
        template: email + " Invited."
      });
    });
  };
});

"use strict";
angular.module('push.services').factory('Invitation', function(Model) {
  var Invitation = Model({path: '/friend_invitations'});
  return Invitation;
});

"use strict";
angular.module('push.services').factory('Workout', function($http, $q, Model, WorkoutSet, loc) {
  var Workout = Model({path: '/workouts'});
  Workout.prototype.setup = function() {
    this.workout_sets = [];
  };
  Workout.prototype.parse = function(response) {
    if (response.workout_sets) {
      console.log('response has workout_sets');
      this.workout_sets = _.map(response.workout_sets, (function(s) {
        return new WorkoutSet(s);
      }));
      delete response.workout_sets;
    }
    return response;
  };
  Workout.prototype.totalReps = function() {
    var reps = 0;
    for (var $__0 = this.workout_sets[$traceurRuntime.toProperty(Symbol.iterator)](),
        $__1; !($__1 = $__0.next()).done; ) {
      var set = $__1.value;
      {
        reps += set.get('reps');
      }
    }
    return reps;
  };
  Workout.prototype.completedAt = function() {
    if (!this.get('completed_date')) {
      return 'Incomplete';
    }
    return this.get('completed_date');
  };
  return Workout;
});

"use strict";
angular.module('push.services').factory('WorkoutSet', function(Model, loc) {
  var WorkoutSet = Model({path: '/workout_sets'});
  WorkoutSet.prototype.url = function() {
    if (!this.id) {
      return loc.apiBase + '/workouts/' + this.get('workout_id') + '/workout_sets';
    }
    return loc.apiBase + '/workout_sets' + this.id;
  };
  return WorkoutSet;
});

"use strict";
angular.module('push.controllers').controller('WorkoutCtrl', function($scope, $state, $stateParams, $timeout, EventBus, Workout, WorkoutSet) {
  $scope.sets = [];
  $scope.reps = 0;
  $scope.workout = null;
  function getWorkout(id) {
    console.log('Getting Workout');
    Workout.get(id);
  }
  $scope.createWorkout = function() {
    console.log('Creating Workout');
    Workout.create().then(function(workout) {
      $scope.workout = workout;
      console.log('workout created', workout);
    }, function() {
      console.log('uhoh workout not created', arguments);
    });
  };
  function setupWorkout() {
    if ($stateParams.id === "new") {
      $scope.createWorkout();
    } else {
      getWorkout($stateParams.id);
    }
  }
  $scope.$on('$stateChangeSuccess', function() {
    setupWorkout();
  });
  EventBus.on('authChange', setupWorkout);
  $scope.pulse = false;
  $scope.push = function() {
    $scope.reps++;
    $scope.pulse = true;
    $timeout((function() {
      $scope.pulse = false;
    }), 1000);
  };
  $scope.completeSet = function() {
    var set = new WorkoutSet({
      reps: $scope.reps,
      workout_id: $scope.workout.get('id')
    });
    $scope.sets.push(set.attributes);
    $scope.workout.workout_sets.push(set);
    set.save().then((function(response) {
      $scope.reps = 0;
      console.log('workout.workout_sets: ', $scope.workout.workout_sets);
    }));
  };
  $scope.completeWorkout = function() {
    if ($scope.reps > 0) {
      var set = new WorkoutSet({
        reps: $scope.reps,
        workout_id: $scope.workout.get('id')
      });
      $scope.sets.push(set);
      $scope.workout.workout_sets.push(set);
      $scope.reps = 0;
      set.save();
    }
    $scope.workout.set({completed_date: new Date()});
    $scope.workout.save().then((function() {
      $scope.sets = [];
      $scope.reps = 0;
      $scope.workout = null;
      $state.go('tab.workouts', {}, {
        reload: true,
        inherit: false
      });
    }));
  };
});

"use strict";
angular.module('push.controllers').controller('WorkoutsCtrl', function($scope, $location, EventBus, Workout) {
  $scope.workouts = [];
  function setupWorkouts() {
    console.log('setting up workouts');
    $scope.workouts = Workout.all();
  }
  setupWorkouts();
  $scope.startNewWorkout = function() {
    $location.url('/workout/new');
  };
  EventBus.on('loginCompleted', setupWorkouts);
});

//# sourceMappingURL=all.js.map