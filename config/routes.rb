Rails.application.routes.draw do
  root to: "home#index"

  get "/:user_name" => "repos#show"

  namespace :api do
    namespace :v1 do
      get "/:user_name" => "api_repos#show"
      get "/:user_name/:repo_name" => "api_repos#repo_image"
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
