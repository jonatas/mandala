Dir["*"].each do |dir|
  if dir.to_i > 0
    first_number = 0
    Dir["#{dir}/*.jpg"].collect do |file|
      next if file =~ /capa|fundo/
      photo_number = file.split("/").last.split(".").first.to_i
      [ photo_number,  file]
    end.compact.sort_by{|e|e[0]}.each do |photo_number, file|
      if first_number == 0
        first_number = photo_number
      end
      if first_number > 1
        photo_number -= first_number - 1

        puts "mv #{file} #{dir}/#{photo_number}.jpg"
      end
    end
  end
end
