  namespace :parcel do

  desc 'Start a deployment, make sure server(s) ready.'
  task :starting do
  end

  #desc 'Started'
  task :started do
  end

  #desc 'Update server(s) by setting up a new release.'
  task :updating do
  end

  #desc 'Updated'
  task :updated do
  end

  task :compiling do
  end

  task :compiled do
  end

  task :testing do
  end

  task :tested do
  end

  #desc 'Building package'
  task :packaging do
  end

  #desc 'Build finished'
  task :packaged do
  end

  #desc 'Build finished'
  task :finishing do
  end

  #desc 'Build finished'
  task :finished do
  end
end

desc 'Build a new package.'
task :parcel do
  %w{ starting started
      updating updated
      compiling compiled
      testing tested
      packaging packaged
      finishing finished
    }.each do |task|
    invoke "parcel:#{task}"
  end
end
task default: :parcel