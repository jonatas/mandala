
window.synth = T("sin")
#synth.play()
window.mandalas =
  initialize: ->
    console.log("initialize binding events...")
    @bindEvents()
  bindEvents: ->
    document.addEventListener('deviceready', this.onDeviceReady, false)
    console.log("events binded!")
  onDeviceReady: ->
    console.log("Ok! device ready!" )

window.app = angular.module("mandala-app", [])
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

  $scope.img_mandalas = ->
    document.querySelector("img[src='#{mandala}']") for mandala in $scope.mandalas


  $scope.velocimeter = -> "#{$scope.accelerator} RPM"
  $scope.accelerate = ->
    synth.pause()
    newFrequency = {freq: parseInt($scope.accelerator)}
    console.log("new Frequency: "+newFrequency)
    synth.set(newFrequency)
    synth.play()if $scope.mute isnt true
    for mandala in $scope.img_mandalas()
      setAnimation(mandala, "") if mandala isnt null

    newAnimation = ->
      actualAnimation = "rotation #{ $scope.fromRPM()}s infinite linear"
      for mandala in $scope.img_mandalas()
        setAnimation(mandala, actualAnimation)
    setTimeout(newAnimation, 200)

    if not $scope.turn_on_motor
      $scope.turn_on_motor = true


  $scope.showOriginal = (element) ->
    if not $scope.turn_on_motor
      element.mandala = element.mandala.replace("b.png", ".png")
  $scope.showInCircle = (element) ->
    if not $scope.turn_on_motor
      element.mandala = element.mandala.replace(".png", "b.png")

  $scope.switch_on_off = ->
    if $scope.turn_on_motor
      state = "running"
      synth.play() if $scope.mute isnt true
    else
      state = "paused"
      synth.pause() if $scope.mute isnt true


    for image in $scope.img_mandalas()
      setAnimationState(image, state)

  $scope.turn_on_motor = false
  $scope.accelerator = 0
  $scope.mute = true
  $scope.switch_mute = ->
    if $scope.mute then synth.pause() else synth.play()


