
gid = (name)-> document.getElementById(name)
window.app = angular.module("mandala-app", [])

app.directive 'imageonload', ->
  restrict: 'A',
  link: (scope, element, attrs) ->
    element.bind 'load', -> scope.$apply(attrs.imageonload)
window.synth = {}
window.main = ($scope) ->
  setAnimationState = (image, state) ->
     $scope.imgMandala().style.webkitAnimationPlayState = image.style.mozAnimationPlayState = image.style.oAnimationPlayState = image.style.animationPlayState = state

  setAnimation = (image, actualAnimation) ->
     $scope.imgMandala().style.webkitAnimation = image.style.mozAnimation = image.style.oAnimation = image.style.animation = actualAnimation

  $scope.instruments =
    "Acoustic Piano": 0,
    "Xylophone": 13

  $scope.instrumentCode = $scope.instruments["Acoustic Piano"]
  $scope.sc = sc
  $scope.books = [[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27], [1,2,3,4,5,6,7,8,9]]
  $scope.fromRPM = -> (60.0 / $scope.accelerator )
  $scope.mandalaIndex = 0
  $scope.booksIndex = 0
  $scope.mandalaSrc = -> "/img/mandalas/escaneadas/1/500x500/0#{$scope.books[$scope.booksIndex][$scope.mandalaIndex]}b.png"
  $scope.imgMandala =  ->
    document.querySelector("img.mandala")
  $scope.mandalaRefresh = ->
    $scope.currentMandala = $scope.mandalaSrc()



  $scope.nextMandala = -> 
    $scope.mandalaIndex++ if $scope.mandalaIndex < $scope.books[$scope.booksIndex].length
    $scope.mandalaRefresh()
  $scope.previousMandala = -> 
    $scope.mandalaIndex-- if $scope.mandalaIndex > 0
    $scope.mandalaRefresh()


  $scope.velocimeter = -> "#{$scope.accelerator} RPM"
  $scope.accelerate = ->
    setAnimation($scope.currentMandala, "") if $scope.currentMandala isnt null

    newAnimation = ->
      actualAnimation = "rotation #{ $scope.fromRPM()}s infinite linear"
      setAnimation($scope.currentMandala, actualAnimation)
    setTimeout(newAnimation, 200)

    if not $scope.turn_on_motor
      $scope.turn_on_motor = true

  $scope.showOriginal = (element) ->
    if not $scope.turn_on_motor
      $scope.currentMandala = $scope.currentMandala.replace("b.png", ".png")
  $scope.showInCircle = (element) ->
    if not $scope.turn_on_motor
      $scope.currentMandala = $scope.currentMandala.replace(".png", "b.png").replace("bb.png", "b.png")

  $scope.switch_on_off = ->
    if $scope.turn_on_motor
      state = "running"
    else
      state = "paused"

    setAnimationState($scope.currentMandala, state)

  $scope.turn_on_motor = false
  $scope.accelerator = 0
  $scope.mute = true
  #$scope.switch_mute = ->
    #if $scope.mute then synth.pause() else synth.play()

  $scope.colorThief = new ColorThief()
  $scope.play = (note) ->
    T.soundfont.setInstrument($scope.instrumentCode)
    T.soundfont.play(note)
  $scope.stop = (note) ->
    T.soundfont.stop(note)
  $scope.showCurrentMandalaPalette = () ->
    img = $scope.imgMandala()
    return unless img?

    joshnstonMap = [   # note: RGB -> #https://github.com/mudcube/MIDI.js/blob/master/js/MusicTheory/Synesthesia.js#L245
      [ 255, 255,   0 ],# C
      [  50,   0, 255 ],# C#
      [ 255, 150,   0 ],# D
      [   0, 210, 180 ] # D#
      [ 255,   0,   0 ],# E
      [ 130, 255,   0 ],# F
      [ 150,   0, 200 ],# F#
      [ 255, 195,   0 ],# G
      [  30, 130, 255 ],# G#
      [ 255, 100,   0 ],# A
      [   0, 200,   0 ],# A#
      [ 225,   0, 225 ]]# B
    findBetterNoteFor = (color) ->
      betterNote = null
      diff = {}
      note=1

      for rgb in joshnstonMap
        rgb = joshnstonMap[note-1]
        diff[note] = Math.abs(rgb[0] - color[0]) + Math.abs(rgb[1] - color[1]) + Math.abs(rgb[2] - color[2])
        if betterNote is null or diff[note] <  diff[betterNote]
          betterNote = note
        note  += 1

      return betterNote

    noteC =65.406 #middle C
    baseNote = sc.Scale.chromatic().degreeToFreq(sc.Range(12), noteC)
    baseColor = $scope.colorThief.getColor(img)
    noteForBaseColor = $scope.sc.cpsmidi(baseNote[findBetterNoteFor(baseColor)])
    pianoNotes = sc.Scale.chromatic().degreeToFreq(sc.Range(12 * 5), noteC) #ForBaseColor)

    numberOfScales = 5

    freqFor = (color) ->
      predominantColor = color[0]
      if predominantColor < color[1]
        predominantColor = color[1]
      if predominantColor < color[2]
        predominantColor = color[2]
      multiplier =  parseInt( predominantColor / 255 * numberOfScales)
      betterNote = findBetterNoteFor(color)
#      console.log("predominantColor:: #{predominantColor}","betterNote: #{betterNote} for color: #{color}, multiplier: #{multiplier}, pianoNotes Length: #{pianoNotes.length} [#{ (betterNote-1) * multiplier}]")
      pianoNotes[(betterNote-1) * multiplier] || pianoNotes[betterNote] || 440

    colorsPallete = []
    findWithFreq = (freq) ->
      for mandala in colorsPallete
        if mandala.freq == freq
          return true
      return false
    for color in $scope.colorThief.getPalette(img,13)
      freq = freqFor(color)
      note = parseInt($scope.sc.cpsmidi(freq))
      freq = Math.round(freq * 100) / 100
      if not findWithFreq(freq)
        colorsPallete.push color: color, note: note, freq: freq

    $scope.currentMandalaPalette = colorsPallete.sort (a,b) -> if a.note > b.note then 1 else -1

  $scope.mandalaRefresh()
