solid = require("../src/solid") 

solid ->
  "/"       : -> "<b>hello world!</b>"
  "/jquery" : @jquery
  "/user"   :
              "/:id" :
                       "/"         : @render (req) ->
                                       @p "Hi, #{req.params.id}!"
                       "/requests" : (req) ->
                                      "<p>Hi, #{req.params.id}. You have no requests. Ha!</p>"
  "/thing" : @render ->
              @doctype 5
              @html ->
                @head ->
                  @title 'Thing'
                @body ->
                  @p "HULK THING!"