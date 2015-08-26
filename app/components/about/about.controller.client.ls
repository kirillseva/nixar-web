angular
  .module \app
  .controller do
      * \about
      * ($scope, $xonom, scroll, $location)->
           $scope.persons = 
             * image: 'https://s3.amazonaws.com/uifaces/faces/twitter/jsa/128.jpg'
               name: 'Andrey'
               desc: 'Full stack developer'
             * image: 'https://s3.amazonaws.com/uifaces/faces/twitter/tomaslau/128.jpg'
               name: 'Vladimir'
               desc: 'Frontend developer'