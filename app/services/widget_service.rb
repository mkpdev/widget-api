require 'rest-client'

class WidgetService
  def initialize
    @client_id = '277ef29692f9a70d511415dc60592daf4cf2c6f6552d3e1b769924b2f2e2e6fe'
    @client_secret = 'd6106f26e8ff5b749a606a1fba557f44eb3dca8f48596847770beb9b643ea352'
  end

  def list(user = nil)
    if user
      headers = { Authorization: "Bearer #{user.access_token}", content_type: :json }
      url = 'https://showoff-rails-react-production.herokuapp.com/api/v1/widgets'
    else
      headers = { content_type: :json }
      params = "client_id=#{@client_id}&client_secret=#{@client_secret}"
      url = "https://showoff-rails-react-production.herokuapp.com/api/v1/widgets/visible?#{params}"
    end
    resp = RestClient.get(url, headers)
    if resp.code == 200
      parsed_body(resp)['widgets']
    else
      ''
    end
  end

  def create_user(user)
    url = 'https://showoff-rails-react-production.herokuapp.com/api/v1/users'
    user[:date_of_birth] = DateTime.parse(user[:date_of_birth]).to_i
    data = { client_id: @client_id, client_secret: @client_secret, user: user }
    resp = RestClient.post(url, data.to_json, { content_type: :json, accept: :json })
    return unless resp.code == 200

    data = parsed_body(resp)
    access_token = data['token']['access_token']
    refresh_token = data['token']['refresh_token']
    User.create!(email: data['user']['email'], remote_id: data['user']['id'], access_token: access_token, refresh_token: refresh_token)
  end

  def update_user(user, params)
    url = 'https://showoff-rails-react-production.herokuapp.com/api/v1/users/me'
    params[:date_of_birth] = DateTime.parse(params[:date_of_birth]).to_i if params[:date_of_birth]
    data = { 
      user: params
    }
    RestClient.put(url, data.to_json, { Authorization: "Bearer #{user.access_token}", content_type: :json, accept: :json })
  end

  def reset_password(email)
    url = 'https://showoff-rails-react-production.herokuapp.com/api/v1/users/reset_password'
    data = { user: { email: email }, client_id: @client_id, client_secret: @client_secret }
    RestClient.post(url, data.to_json, { content_type: :json, accept: :json })
  end

  def login_user(params)
    url = 'https://showoff-rails-react-production.herokuapp.com/oauth/token'
    data = {
      grant_type: 'password',
      client_id: @client_id,
      client_secret: @client_secret,
      username: params[:username],
      password: params[:password]
    }

    resp = RestClient.post(url, data.to_json, { content_type: :json, accept: :json })
    return unless resp.code == 200

    data = parsed_body(resp)
    access_token = data['token']['access_token']
    refresh_token = data['token']['refresh_token']
    user = User.find_by_email(params[:username])
    if user
      user.update(access_token: access_token, refresh_token: refresh_token)
    else
      user = get_user_by_token(access_token)
      user = User.create!(email: user['email'], remote_id: user['id'], access_token: access_token, refresh_token: refresh_token)
    end
    user
  end

  def get_user_by_token(token)
    url = 'https://showoff-rails-react-production.herokuapp.com/api/v1/users/me'
    resp = RestClient.get(url, { Authorization: "Bearer #{token}", content_type: :json })
    parsed_body(resp)['user']
  end

  def get_user_by_id(user, id)
    url = "https://showoff-rails-react-production.herokuapp.com/api/v1/users/#{id}"
    resp = RestClient.get(url, { Authorization: "Bearer #{user.access_token}", content_type: :json })
    parsed_body(resp)['user']
  end

  def logout_user(user)
    url = 'https://showoff-rails-react-production.herokuapp.com/oauth/revoke'
    data = { token: user.access_token }
    resp = RestClient.post(url, data.to_json, { Authorization: "Bearer #{user.access_token}", content_type: :json, accept: :json })
    return unless resp.code == 200
    user.update(access_token: nil)
  end

  def create_widget(user, params)
    url = 'https://showoff-rails-react-production.herokuapp.com/api/v1/widgets'
    data = { widget: { name: params[:name], description: params[:description], kind: params[:public] == 'on' ? 'visible' : 'hidden' } }
    resp = RestClient.post(url, data.to_json, { Authorization: "Bearer #{user.access_token}", content_type: :json, accept: :json })
  end

  def update_widget(user, params)
    url = "https://showoff-rails-react-production.herokuapp.com/api/v1/widgets/#{params[:id]}"
    data = { name: params[:name], description: params[:description], kind: params[:public] == 'on' ? 'visible' : 'hidden' }
    RestClient.put(url, data.to_json, { Authorization: "Bearer #{user.access_token}", content_type: :json, accept: :json })
  end

  def get_widget(user, id)
    url = "https://showoff-rails-react-production.herokuapp.com/api/v1/widgets/#{id}"
    resp = RestClient.get(url, { Authorization: "Bearer #{user.access_token}", content_type: :json })
    return unless resp.code == 200

    parsed_body(resp)['widget']
  end

  def get_widgets_by_term(term, user = nil)
    params = "client_id=#{@client_id}&client_secret=#{@client_secret}&term=#{term}"
    if user
      url = "https://showoff-rails-react-production.herokuapp.com/api/v1/users/me/widgets?"
      headers = { Authorization: "Bearer #{user.access_token}", content_type: :json }
    else
      url = "https://showoff-rails-react-production.herokuapp.com/api/v1/widgets/visible?"
      headers = { content_type: :json }
    end
    resp = RestClient.get("#{url}#{params}", { content_type: :json })
    return unless resp.code == 200

    parsed_body(resp)['widgets']
  end

  private

  def parsed_body(resp)
    JSON.parse(resp.body)['data']
  end
end
