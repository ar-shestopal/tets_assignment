Rails.application.routes.draw do

  namespace :api do
    api_version(module:   'V1',
                header:   { name: 'Accept', value: 'application/mytest; version=1' },
                defaults: { format: :json },
                default:  true) do

      resources :users
      resources :articles
      resources :comments
    end
  end
end
