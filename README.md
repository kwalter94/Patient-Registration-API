# Patient-Registration-API
API for Patient registration system. 
To import seed data into project
Add this line to your gemfile :

gem ‘yaml_db’
Run bundler :

bundle
To dump your data :

bundle exec rake db:data:dump
To load your data :
bundle exec rake db:data:load
You can specify the environment using RAILS_ENV variable. The following example dumps data from the development database and pushes it to the production db :

RAILS_ENV=development bundle exec rake db:data:dump
RAILS_ENV=production bundle exec rake db:data:load
As a side note, I found this gem to be particularily handy when I have to transfer data from my localhost ( for example ) to a heroku instance. Assuming that you have dumped your database, properly added db/data.yml to the repository, and updated your heroku app with your latest code version, all you have to do is to run the following command :

heroku run bundle exec rake db:data:load
Please note that this method doesn’t reset your data but rather merges your actual database with data.yml content. Be careful not to import it more than once !
