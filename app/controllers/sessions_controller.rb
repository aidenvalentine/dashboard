class SessionsController < ApplicationController
# layout false

def new
end

def create
  @auth = request.env['omniauth.auth']['credentials']
  Token.create(
      access_token: @auth['token'],
      refresh_token: @auth['refresh_token'],
      expires_at: Time.at(@auth['expires_at']).to_datetime)

  user = User.authenticate(params[:email], params[:password])
  if user
    session[:user_id] = user.id
    redirect_to users_url, :notice => "Logged in!"
  else
    flash.now.alert = "Invalid email or password"
    render "new"
  end
end

def destroy
  session[:user_id] = nil
  redirect_to root_url, :notice => "Logged out!"
end
end