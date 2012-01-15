solid = require("../src/solid") 

solid {port: 9001, cwd: __dirname}, ->
  "/"          : -> "<b>hello world!</b>"
  "/home"      : "/"     # URL rewriting/redirects
  "/jquery.js" : @jquery # Remember that you still have to include a <script src="/jquery.js"></script> in your HTML
  "/user"      :
                 "/:id":
                         "/"         : @render (req) ->
                                         @p "Hi, #{req.params.id}!"
                         "/requests" : (req) ->
                                        "<p>Hi, #{req.params.id}. You have no requests. Ha!</p>"
  "/thing"    : @render ->
                  @doctype 5
                  @html ->
                    @head ->
                      @title 'Thing'
                    @body ->
                      @p "HULK THING!"