namespace :parcel do

  desc 'Start a deployment, make sure server(s) ready.'
  task :starting do
  end

  desc 'Started'
  task :started do
  end

  desc 'Update server(s) by setting up a new release.'
  task :updating do
  end

  desc 'Updated'
  task :updated do
  end

end

desc 'Build a new package.'
task :parcel do
  %w{ starting started
      updating updated
    }.each do |task|
    invoke "parcel:#{task}"
  end
end
task default: :parcel