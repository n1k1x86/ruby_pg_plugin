# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :pskb_obj_type, only: [:index, :new, :show, :update, :edit, :destroy, :create]

  resources :pskb_negotiation_stat, only: [:index, :new, :show, :update, :edit, :destroy, :create]
end

