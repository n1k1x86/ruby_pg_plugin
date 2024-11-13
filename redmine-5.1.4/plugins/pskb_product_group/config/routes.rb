# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :pskb_product_groups, only: [:index, :new, :show, :destroy, :create, :update, :edit]
  resources :pskb_product_groups_issues, only: [:index, :new, :show, :destroy, :create, :update, :edit]
end
