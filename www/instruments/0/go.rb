instrument = 0
(0..128).each do |note|
  `wget https://free-midi.googlecode.com/git/channel/0/instrument/0/#{note}.js?_callback=soundfont_0_#{instrument}_#{note}`
end
