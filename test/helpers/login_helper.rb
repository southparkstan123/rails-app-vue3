module LoginHelper
  def token(user)
    username = user.username

    password = case username
    when 'admin'
      'testing1234'
    when 'testuser'
      'testing1234'
    else
      user.password
    end

    post '/api/v1/user/login', params: { 
      username: username, 
      password: password
    }, as: :json
    
    return response.parsed_body['token']
  end

  def register(user)
    post '/api/v1/user/register', 
      params: user, as: :json
  end

  def login(user)
    post '/api/v1/user/login', 
      params: user, as: :json
  end
end