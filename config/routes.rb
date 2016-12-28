Rails.application.routes.draw do
  get '/sponsors', to: 'sponsors#similar'
  root 'sponsors#index'

  get '*path' => redirect('/')
end
