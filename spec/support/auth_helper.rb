module AuthHelper
  def login_by role
    http_authorization(credentials(role))
  end

private

  def http_authorization credentials
    request.env['HTTP_AUTHORIZATION'] = 
      ActionController::HttpAuthentication::Basic.encode_credentials(credentials[:email], credentials[:password])
  end

  def credentials role
    case role
    when :admin
      { email: 'admin@test.com', password: 'password' }
    when :regular_user
      { email: 'user@test.com',  password: 'password' }
    end
  end
end
