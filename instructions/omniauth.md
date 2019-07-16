##Omniauth na przykładzie integracji facebooka z devisem

##### Konfigurujemy aplikację developerską facebooka
```
https://developers.facebook.com/apps/
```

##### Instalujemy omniautha
```ruby
gem 'omniauth-facebook'
```

```shell
$ bundle install
```

##### Dodajemy atrybuty do naszego modelu User
```shell
$ rails g migration AddOmniauthToUsers \
  provider:string uid:string
$ rake db:migrate
```

##### Dodajemy id i secret aplikacji facebooka do credentiali

```shell
$ EDITOR=vim rails credentials:edit
```

```yml
# credentials.yml

...
facebook:
  app_id: '269032377022559'
  app_secret: '1cc482f8a26eb2a979769c76f0529b8a'
...
```

##### Inicjalizujemy moduł omniautha dla devise w połączeniu z naszą aplikacją FB

```ruby
# config/initializers/devise.rb

...
config.omniauth :facebook,
  Rails.application.credentials[:facebook][:app_id],
  Rails.application.credentials[:facebook][:app_secret],
  callback_url:
    "http://localhost:3000/users/auth/facebook/callback"
...
```

##### Konfigurujemy moduł omniautha w dyrektywie devise w modelu

```ruby
# user.rb

devise ...,
  :omniauthable, omniauth_providers: [:facebook]
```

##### Dodajemy ścieżki omniautha

```ruby
# routes.rb

devise_for :users, :controllers => {
  omniauth_callbacks: 'users/omniauth_callbacks'
}
```

##### Dodajemy link do logowania przez FB w naszym navbarze

```shell
$ rake routes
```

```ruby
# layouts/partials/_navbar.erb

...
<%= link_to 'Log in with Facebook',
 user_facebook_omniauth_authorize_path %>
...
```

##### Dodajemy metodę autoryzacyjną do modelu

```ruby
# user.rb

...
def self.from_omniauth(auth)
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
  end
end
...
```

##### Piszemy kontroler który zostanie wywyołany po przekierowaniu z FB

```ruby
# users/omniauth_callbacks_controller.rb

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(
        :notice,
        :success,
        kind: 'Facebook'
      ) if is_navigational_format?
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path, alert: Facebook login failed'
  end
end
```
