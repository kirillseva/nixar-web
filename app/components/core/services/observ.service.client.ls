angular
  .module \app
  .service do
     * \observ
     * (safe-apply)->
         (func)->
             const observers = []
             const notify = (name, obj)->
                 const notifyone = (item)->
                    safe-apply ->
                     item.1 obj
                 observers.filter(-> it.0 is name).for-each notifyone
             const scope = 
                func notify
             scope.on = (name, callback)->
                 observers.push [name, callback]
             scope.off = (callback)->
                const remove = (item)->
                  const index =
                    observers.index-of item
                  observers.splice index, 1
                observers.filter(-> it.1 is callback).for-each remove
             scope
        
         