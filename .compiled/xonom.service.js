angular.module('xonom', []).service('$xonom', function($http) {
 var make = function (name){
          return function(){
            var args, callback;
            args = [].slice.call(arguments);
            callback = args.pop();
            $http.post(name, args).success(function(data){
              return callback(null, data.result);
            }).error(function(err){
              return callback(err);
            });
          };
        };
 return {
   app : {
     test : make('app/test')},
   doc : {
     commands : make('doc/commands')}} 
});