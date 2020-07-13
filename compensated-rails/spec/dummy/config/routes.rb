Rails.application.routes.draw do
  mount Compensated::Rails::Engine => '/compensated-rails'
end
