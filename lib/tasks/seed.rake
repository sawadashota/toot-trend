namespace :seed do
  desc 'Seed data'

  task admin: :environment do
    # p ENV['email']
    # p ENV['password']
    admin = Admin.new({ email: ENV['email'], password: ENV['password'] })
    admin.save
  end
end
