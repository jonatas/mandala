instrument = "celesta"
if instrument is "piano"
  freq = 440.0
  
  a = T("sin", freq)
  b = T("sin", freq * 2, 0.5)
  c = T("sin", freq * 4, 0.25)
  d = T("sin", freq * 5, 0.125)
  
  frequencyBase = 440
  frequencyPerStep = 440 / 12
  freqs = {}
  freqs[b] = 2
  freqs[c] = 4
  freqs[d] = 5
  window.adsr = T("adsr", "24db", 5, 1000, 0.0, 2500)
  window.synth = T("*", T("+", a, b, c, d), adsr)
  window.synth.touchDown = (newFrequency) ->
    for _synth in [a,b,c,d,synth]
      multiplier = freqs[_synth] || 1
      _synth.set(freq: newFrequency * multiplier)

    synth.args[1].bang()
    this.play()
  window.synth.touchUp = (fre) ->
    synth.args[1].keyoff()

else if instrument is "celesta"
  freq = 440.0
  op1 = T("oscx", T("phasor", 200), 0.01).set({fb:0.1})
  phasor2 = T("phasor", freq)
  op2 = T("*", T("oscx", T("+", phasor2, op1), 0.4), T("adsr", "32db", 0, 450, 0.4, 500))
  op3 = T("oscx", T("phasor", freq * 14), 0.1)
  phasor4 = T("phasor", freq * 2)
  op4 = T("*", T("oscx", T("+", phasor4, op3), 1.0), T("adsr", "24db", 0, 250, 0.1, 500))
  window.synth = T("+", op2, op4)
  window.synth.touchDown = (newFrequency) ->
    this.pause()
    phasor2.set(freq: newFrequency)
    phasor4.set(freq: newFrequency * 2)
    op2.args[1].bang()
    op4.args[1].bang()
    this.play()

  window.synth.touchUp = (fre) ->
    op2.args[1].keyoff()
    op4.args[1].keyoff()


gid = (name)-> document.getElementById(name)
window.mandalas =
  initialize: ->
    console.log("initialize binding events...")
    @bindEvents()
  bindEvents: ->
    document.addEventListener('deviceready', this.onDeviceReady, false)
    console.log("events binded!")
  onDeviceReady: ->
    console.log("Ok! device ready!" )

window.app = angular.module("mandala-app", ['angular-gestures'])
window.main = ($scope) ->

  setAnimationState = (image, state) ->
    if image isnt null
      image.style.webkitAnimationPlayState = image.style.mozAnimationPlayState = image.style.oAnimationPlayState = image.style.animationPlayState = state

  setAnimation = (image, actualAnimation) ->
    if image isnt null
      image.style.webkitAnimation = image.style.mozAnimation = image.style.oAnimation = image.style.animation = actualAnimation

  $scope.livros_a = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]
  $scope.livros_b = [1,2,3,4,5,6,7,8,9]
  $scope.fromRPM = -> (60.0 / $scope.accelerator )
  $scope.mandalas =[]
  for livro in $scope.livros_a
    $scope.mandalas.push("mandalas/1/500x500/0#{livro}b.png")
  for livro in $scope.livros_b
    $scope.mandalas.push("mandalas/2/500x500/0#{livro}b.png")

  $scope.imgMandala = (mandala) ->
    document.querySelector("img[src='#{mandala}']")

  $scope.imgMandalas = ->
    $scope.imgMandala(mandala) for mandala in $scope.mandalas


  $scope.velocimeter = -> "#{$scope.accelerator} RPM"
  $scope.accelerate = ->
    for mandala in $scope.imgMandalas()
      setAnimation(mandala, "") if mandala isnt null

    newAnimation = ->
      actualAnimation = "rotation #{ $scope.fromRPM()}s infinite linear"
      for mandala in $scope.imgMandalas()
        setAnimation(mandala, actualAnimation)
    setTimeout(newAnimation, 200)

    if not $scope.turn_on_motor
      $scope.turn_on_motor = true


  $scope.showOriginal = (element) ->
    if not $scope.turn_on_motor
      if $scope.currentMandala is null or $scope.currentMandala isnt element.mandala
        $scope.currentMandala = element.mandala
        $scope.showCurrentMandalaPalette()
        element.mandala = element.mandala.replace("b.png", ".png")
  $scope.showInCircle = (element) ->
    if not $scope.turn_on_motor
      element.mandala = element.mandala.replace(".png", "b.png")

  $scope.switch_on_off = ->
    if $scope.turn_on_motor
      state = "running"
    else
      state = "paused"


    for image in $scope.imgMandalas()
      setAnimationState(image, state)

  $scope.turn_on_motor = false
  $scope.accelerator = 0
  $scope.mute = true
  $scope.switch_mute = ->
    if $scope.mute then synth.pause() else synth.play()

  $scope.colorThief = new ColorThief()
  $scope.play = (color) ->
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
    betterNote = null
    diff = {}
    note=1
    noteC = 65.406
    pianoNotes = sc.Scale.chromatic().degreeToFreq(sc.Range(12 * 5), noteC)
    console.log(pianoNotes)
    for rgb in joshnstonMap
      rgb = joshnstonMap[note-1]
      diff[note] = Math.abs(rgb[0] - color[0]) + Math.abs(rgb[1] - color[1]) + Math.abs(rgb[2] - color[2])
      if betterNote is null or diff[note] <  diff[betterNote]
        betterNote = note
      note  += 1

    console.log(color, "currentNote:", betterNote, diff, " diff: ", diff[betterNote])
    max = (array) ->
      n = null
      for m in array
        if n is null or m > n
          n = m
      n

    predominantColor = max(color)
    console.log("predominantColor", predominantColor)
    multiplier = Math.round((predominantColor / 255) * 5)

    n = diff[betterNote] / 5 #5 scales
    console.log("scale up", n)

    newFrequency =  pianoNotes[(betterNote-1) * multiplier]
    console.log("newFrequency",newFrequency ,  "note", pianoNotes[(betterNote-1) * multiplier], "multiplier", multiplier)

    synth.touchDown(newFrequency)
  $scope.touchUp = () ->
    synth.touchUp()
  $scope.showCurrentMandalaPalette = () ->
    img = $scope.imgMandala($scope.currentMandala)
    return if img is null
    $scope.currentMandalaPalette = $scope.colorThief.getPalette(img,13)



     

