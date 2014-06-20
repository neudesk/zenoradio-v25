set :deploy_to, '/var/www/gui-production'
set :branch, 'new_layout'
set :stage, :production
server '162.243.120.14', user: 'root', roles: %w{web app}
