angular
 .module(\app)
 .service \scroll, (observ)->
    observ (notify)->
        const el = $ window
        const notify-top = ->
              notify do 
                 * \change
                 * el.scroll-top!
        el.scroll notify-top
        notify-top!
        to: (id) !->
            parent = $(\.scroll)
            #parent.scroll-top 0
            parent.animate do 
                 * scroll-top: $(\# + id).offset!.top + parent.scroll-top!
                 * 1000
          
        