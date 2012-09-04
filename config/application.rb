require 'rubygems'
require 'bundler/setup'

require 'pp'
require 'pakyow'

module PakyowApplication
  class Application < Pakyow::Application
    configure(:development) do
    end

    # routes
    core do
      # View Scopes
      ###
      
      get 'scopes' do
        data = []
        3.times { |i|
          data << {:title => "foo #{i}"}
        }

        # NEW VIEW METHODS
        ###

        # View#with
        # presenter.view.scope(:post)[0].with {|view|
        #   pp view
        # }

        # Views#with
        # presenter.view.scope(:post).with {|view|
        #   pp view
        # }

        # View#for
        # presenter.view.scope(:post)[0].for(data) {|view,datum|
        #   pp view
        #   pp datum
        # }

        # Views#for
        # presenter.view.scope(:post).for(data) {|view,datum|
        #   pp view
        #   pp datum
        # }

        # View#mold
        # presenter.view.scope(:post)[0].mold(data)

        # Views#mold
        # presenter.view.scope(:post).mold(data)

        # View#repeat
        # presenter.view.scope(:post)[0].repeat(data) {|view,datum|
        #   pp view
        #   pp datum
        # }

        # Views#repeat
        # presenter.view.scope(:post).repeat(data) {|view,datum|
        #   pp view
        #   pp datum
        # }

        # View#bind
        # presenter.view.scope(:post)[0].bind(data[0])

        # Views#bind
        # presenter.view.scope(:post).bind(data)

        # View#apply
        # presenter.view.scope(:post)[0].apply(data)

        # Views#apply
        # presenter.view.scope(:post).apply(data)
      end
    end
  end
end
