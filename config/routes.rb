Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  scope constraints: lambda { |req| req.format == :json } do
    post 'urls', to: 'links#create'
    get ':code', to: 'links#show'
    get ':code/stats', to: 'links#stats'
  end
end
