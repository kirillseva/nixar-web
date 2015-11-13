#document.write('<script src="//' + (location.hostname || \localhost) + ':35729/livereload.js?snipver=1"></script>')

angular.module do
    * \app
    * * \ui.router
      * \xonom
      * \ngMaterial
      * \ngSanitize
      * \bgDirectives
      * \ngSocial
      ...

angular
  .module \app
  .config ($location-provider, $md-theming-provider)->
     $locationProvider.html5Mode(true)
     $mdThemingProvider.definePalette do 
       *  \amazingPaletteName
       *  '50': 'ffebee'
          '100': 'ffcdd2'
          '200': 'ef9a9a'
          '300': 'e57373'
          '400': 'ef5350'
          '500': 'f44336'
          '600': 'e53935'
          '700': 'd32f2f'
          '800': 'c62828'
          '900': 'b71c1c'
          'A100': 'ff8a80'
          'A200': 'ff5252'
          'A400': 'ff1744'
          'A700': 'd50000'
          'contrastDefaultColor': 'light'  
          'contrastDarkColors': 
             * '50'
             * '100' 
             * '200'
             * '300'
             * '400'
             * 'A100'
          'contrastLightColors': undefined
     $mdThemingProvider.theme('default')
       .primaryPalette('amazingPaletteName')

    
