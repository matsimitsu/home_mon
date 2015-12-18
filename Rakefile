task :deploy do
  wanted_files = %w( automate/ components/ config/ core/ helpers/ public/ scripts/ .ruby-version app.rb Gemfile Gemfile.lock Procfile Rakefile )

  `rm -rf deploy.tar.gz`
  `tar -zcf deploy.tar.gz #{wanted_files.join(' ')}`
  `scp deploy.tar.gz pi@pi:deploy.tar.gz`
  `ssh pi@pi <<ENDSSH
    tar xf deploy.tar.gz -C ~/app/homemon/
    rm -rf deploy.tar.gz
    cd ~/app/homemon && bundle install
    sudo service web restart
  `
  `rm -rf deploy.tar.gz`
end
