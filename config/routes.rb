Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root to: "home#index"
   resources :users, only: [] do
		
	end
	
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
