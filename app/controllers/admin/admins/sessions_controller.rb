class Admin::Admins::SessionsController < Devise::SessionsController
  include AdminLoginMethods
end