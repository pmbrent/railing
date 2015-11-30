# MVC Server Framework
## Using Ruby & WEBrick, inspired by Rails
Welcome to my open-source simple server, leveraging the convenience of WEBrick and ERB without all the extraneous structure of Rails. The goal of this project was to be lightweight and easy to use; I hope it's useful to you!

To boot up the server, just run 'ruby bin/server.rb' in your starting directory.

Remember that if you change any files, you'll need to restart the server; you can interrupt with Ctrl+C.

Controllers need to inherit from ControllerBase and define the methods (views) you'll need to manipulate your models remotely.

Make use of ERB to transport values into your views from the controller.

You can define routes using router.draw and regular expressions, e.g.

```ruby
router = Router.new
router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
end
```

Params in the query will be interpreted as key-value pairs accessible from the Controllers.

From there, the sky is the limit! Get creative with your views and have fun.
