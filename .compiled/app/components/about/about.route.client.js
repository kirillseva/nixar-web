// Generated by LiveScript 1.3.1
angular.module('app').config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider){
  return $stateProvider.state('about', {
    url: 'about',
    parent: 'root',
    views: {
      'content': {
        templateUrl: 'about',
        controller: 'about'
      }
    }
  });
}]);