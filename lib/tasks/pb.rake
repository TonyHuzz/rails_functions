namespace :pb do
  desc "Echo Hello"
  task echoHello: :environment do
    puts "Hello"
  end

  desc "Echo World"
  task echoWorld: :environment do
    puts "World"
  end

end
