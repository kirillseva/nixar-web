// Generated by LiveScript 1.3.1
angular.module('app').config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider){
  return $stateProvider.state('doc', {
    url: '/doc',
    parent: 'root',
    views: {
      'content': {
        templateUrl: 'doc',
        controller: 'doc'
      }
    }
  });
}]);