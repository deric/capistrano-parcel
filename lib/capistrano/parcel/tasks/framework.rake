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

  desc 'Build depencencies'
  task :building do
  end

  desc 'Build finished'
  task :built do
  end


end

desc 'Build a new package.'
task :parcel do
  %w{ starting started
      updating updated
      building built
    }.each do |task|
    invoke "parcel:#{task}"
  end
end
task default: :parcel