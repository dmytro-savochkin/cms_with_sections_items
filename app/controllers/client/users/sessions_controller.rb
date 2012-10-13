class Client::Users::SessionsController < Devise::SessionsController
  include ClientLoginMethods
end