require("../lib/solid") ->
  "/" : -> "<b>hello world!</b>"
  "/user" :
    "/:id" :
      "/" : @render (req) ->
        @p "Hi, #{req.params.id}"
      "/requests" : (req) ->
        "<p>Hi, #{req.params.id}. You have no requests. Ha!</p>"
  "/thing" : @render ->
    @doctype 5
    @html ->
      @head ""
      @body ->
        @p "HULK THING!"