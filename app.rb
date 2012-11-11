require 'rubygems'

require 'bundler/setup'

require 'pp'
require 'pakyow'

require 'rdiscount'

module PakyowApplication
  class Application < Pakyow::Application
    core do

      # a simple route definition
      get('/') {
        # logic goes here
      }

      # defines a function named say_hello
      # functs can be used for routes or as hooks
      fn(:say_hello) {
        puts 'hello'
      }

      # create a route for the path "/hello" and map it
      # to the say_hello function
      get('hello', fn(:say_hello))

      # here say_hello is used as before hook
      get('whoami', before: fn(:say_hello)) {
        puts 'my name is pakyow'
      }

      # create a group named hello with a single before hook
      group(:hello, before: fn(:say_hello)) {
        # routes defined here will have the say_hello
        # before hook applied automatically
      }

      # create a namespace named hello
      namespace('hello', :hello) {
        # routes defined here will be prefixed with "/hello"
        # hooks can also be defined on namespaces
      }

      # defines a template for creating restful routes (only implements index and show)
      template(:restful) {
        get '/', :index, fn(:index)

        # special case for show (view path is overridden)
        if show_fns = fn(:show)
          show_fns = [show_fns] unless show_fns.is_a?(Array)
          get '/:id', :show, show_fns.unshift(
            lambda {
              presenter.view_path = File.join(self.path, 'show') if Configuration::Base.app.presenter
            }
          )
        end
      }

      # expands the restful template for posts
      expand(:restful, :posts, '/posts') {
        action(:index) {
          # normally this would contain logic for a list of posts, but in
          # this example it doesn't matter
        }

        action(:show) {
          # normally this would contain logic for showing a post, but in
          # this example it doesn't matter
        }
      }


      # Presenter/Core API
      ###

      get('presenter') {
        # check the initial view path
        pp presenter.view_path

        # check the initial root path
        pp presenter.root_path

        # change the view path
        presenter.view_path = '/presenter/foo'

        # change just the root view
        presenter.root_path = 'another_root.html'

        # or, set the view explicitly
        # (at_path returns the compiled view for a path)
        presenter.view = View.at_path('presenter/foo')

        # any view can be compiled at any path
        # (this sets the view back to what it was initially)
        presenter.view = View.new('pakyow.html', true).compile('/presenter')
      }


      # View Scopes/Manipulation
      ###

      get('scopes') {
        view.scope(:post).remove
      }

      get('scopes/with') {
        # creates a context for the scope post
        view.scope(:post).with { |view|
          view.attributes.style = 'background:gray'
        }
      }

      get('scopes/for') {
        # yields a view/datum pair for each post scope
        view.scope(:post).for(Post.all) { |view, post|
          pp view
          pp post
        }
      }

      get('scopes/match') {
        # manipulates the view structure to match the data
        # the result will be three post scopes, since our data contains three posts
        view.scope(:post).match(Post.all)
      }

      get('scopes/repeat') {
        # manipulates the view structure to match the data and
        # yields each view/datum pair
        view.scope(:post).repeat(Post.all) { |view, post|
          pp view
          pp post
        }
      }

      get('scopes/bind') {
        # binds data to a scope
        # no view manipulation is performed
        view.scope(:post).bind(Post.all)
      }

      get('scopes/apply') {
        # matches the view structure to the data then binds
        view.scope(:post).apply(Post.all)
      }
    end


    presenter do
      # converts markdown views into html
      parser(:md) { |content|
        RDiscount.new(content).to_html
      }

      # defines bindings for post scope
      scope(:post) {
        # reusable function to convert markdown data into html
        fn(:md) { |data|
          RDiscount.new(data).to_html
        }

        # maps the binding for body to the md function
        binding(:body, fn(:md))

        # creates a binding that sets content and href on the node
        binding(:link) {
          {
            content: bindable[:title],

            # the restful route for posts#show is available here
            # through the posts group created when expanding the
            # restful route template for posts
            href: router.group(:posts).populate(:show, bindable)
          }
        }
      }
    end
  end
end

