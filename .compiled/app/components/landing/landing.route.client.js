// Generated by LiveScript 1.3.1
angular.module('app').config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider){
  $urlRouterProvider.otherwise('/');
  return $stateProvider.state('landing', {
    url: '/',
    parent: 'root',
    views: {
      'content': {
        templateUrl: 'landing',
        controller: 'landing'
      }
    }
  });
}]);