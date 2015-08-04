angular
 .module(\app)
 .service \scroll, ->
    to: (id) !->
        parent = $(\.scroll)
        #parent.scroll-top 0
        parent.animate do 
             * scroll-top: $(\# + id).offset!.top + parent.scroll-top!
             * 1000
          
        