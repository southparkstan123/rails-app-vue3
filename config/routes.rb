Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      get 'greeting', to: 'message#greeting'
      namespace 'user' do
        post '/register', to: 'user#create'
        post '/login', to: 'user#login'
        get '/auto_login', to: 'user#auto_login'
      end

      namespace 'book' do
        get '/list', to: 'book#list'
        get '/:id', to: 'book#show'
        post '/', to: 'book#create'
        patch '/:id', to: 'book#update'
        delete '/:id', to: 'book#delete'
      end

      namespace 'author' do
        get '/list', to: 'author#list'
        get '/:id', to: 'author#show'
        post '/', to: 'author#create'
        patch '/:id', to: 'author#update'
        delete '/:id', to: 'author#delete'
      end

      namespace 'publisher' do
        get '/list', to: 'publisher#list'
        get '/:id', to: 'publisher#show'
        post '/', to: 'publisher#create'
        patch '/:id', to: 'publisher#update'
        delete '/:id', to: 'publisher#delete'
      end

    end
  end
  root to: 'home#index'
  get '/*path', to: 'home#index'
end
