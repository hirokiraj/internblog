# Wstęp i setup
Od admina dostajemy info że serwer jest gotowy. Dostajemy też adres i dostęp po ssh:

```zsh
ssh internblog@internblog.binar.app
https://internblog.binar.app/
```

Dodajemy potrzebne nam biblioteki

```rb
# Gemfile

gem 'capistrano-rails'
gem 'capistrano-rvm'

group :production do
  gem 'unicorn-rails'
end
```

Instalujemy je i przeprowadzamy instalację Capistrano

```zsh
bundle install
cap install
```

# Konfiguracja Capistrano

W pliku `Capfile` wybieramy insteresujące nas moduły i wtyczki

```rb
# Capfile
require "capistrano/setup"
require "capistrano/deploy"

require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require "capistrano/rvm"
require "capistrano/bundler"
require "capistrano/rails/assets"
require "capistrano/rails/migrations"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
```

Przeprowadzamy ogólną konfigurację deploymentu

```rb
# config/deploy.rb

set :repo_url,     'git@github.com:hirokiraj/internblog.git'
set :stages,       %w(production)

# Files that are not stored in repository. You need to manually create them on server.
set :linked_files, %w(config/database.yml config/unicorn.rb)
# Add folders that you want to link. These folders will not be overwritten after the deploy
# because they won't be present in repository.
# For example if you have the uploads folder and you don't want to lose files
# every time you deploy, add this folder here (public/uploads)
set :linked_dirs,  %w(log vendor/bundle tmp/sockets tmp/pids tmp/cache)

set :keep_releases, 5
set :normalize_asset_timestamps, %(public/images public/javascripts public/stylesheets)
```

Konfigurujemy konkretną jedną instancję serwerową pod nazwą `production`

```rb
# config/deploy/production.rb

role :app,        %w(internblog.binar.app)
role :web,        %w(internblog.binar.app)
role :db,         %w(internblog.binar.app)
set :application, 'internblog'

server 'internblog.binar.app', user: fetch(:application), roles: %w(web app db), primary: true

set :rails_env,   'production'
set :branch,      'master' # select which branch should be deployed
set :deploy_to,   "/home/#{fetch(:application)}/www/"

set :rvm_ruby_version, '2.6.3@internblog'	# put Ruby version and gemset name here
# set :rvm_type, :system	# uncomment if you need to choose RVM installation manually
# set :rvm_map_bins, %w(rake gem bundle ruby rails)	# uncomment if you need to specify which commands should be prefixed with RVM

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 10 do
      execute 'sudo systemctl restart $USER-unicorn.service'
    end
  end

  after :publishing, :restart
end
```

# Konfiguracja na serwerze

Logujemy się na serwer po ssh i edytujemy zmienne środowiskowe

```zsh
ssh internblog@internblog.binar.app
vim app.env
```

Dodajemy tam nasz `master.key`

```rb
RAILS_MASTER_KEY="hjfgdjhkfdgh773hdhf"
```

Zapisujemy zmiany i odłączamy się od serwera

```zsh
:wq
exit
```

# Pierwszy deployment

Komitujemy, pushujemy

```zsh
git add .
git commit -am '[add] capistrano config, unicorn for production'
git push origin master
```

Wydajemy polecenie startujące deployment

```zsh
cap production deploy
```
