namespace :db do
  desc "Drop, re-create and populate sample data"
  task :bootstrap => [:reset,
                      :seed,
                      :sample_data]

  desc "Load the sample data from db/sample_data.rb"
  task :sample_data => :environment do
    sample_file = File.join(Rails.root, 'db', 'sample_data.rb')
    load(sample_file) if File.exist?(sample_file)
  end
end
