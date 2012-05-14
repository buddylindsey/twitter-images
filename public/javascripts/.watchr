watch("coffee/(.*).coffee") do |f|
  puts "Compiling #{f[0]}"
  `coffee -o ./ -c #{f[0]}`
end
