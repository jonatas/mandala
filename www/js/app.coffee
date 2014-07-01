window.mandalas =
  initialize: -> @bindEvents()
  bindEvents: ->
    document.addEventListener('deviceready', this.onDeviceReady, false)
  onDeviceReady: ->
    window.app = angular.module("mandala-app", [])
    window.main = ($scope) ->
      setAnimationState = (image, state) ->
        image.style.webkitAnimationPlayState =
          image.style.mozAnimationPlayState =
            image.style.oAnimationPlayState =
              image.style.animationPlayState = state

      setAnimation = (image, actualAnimation) ->
        image.style.webkitAnimation =
          image.style.mozAnimation =
            image.style.oAnimation =
              image.style.animation = actualAnimation


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
        for mandala in $scope.img_mandalas()
          setAnimation(mandala, "")

        newAnimation = ->
          actualAnimation = "rotation #{ $scope.fromRPM()}s infinite linear"
          for mandala in $scope.img_mandalas()
            setAnimation(mandala, actualAnimation)
        setTimeout(newAnimation, 200)

        if not $scope.turn_on_motor
          $scope.turn_on_motor = true


      $scope.switch_on_off = ->
        if $scope.turn_on_motor
          state = "running"
        else
          state = "paused"

        for image in $scope.img_mandalas()
          setAnimationState(image, state)

      $scope.turn_on_motor = false
      $scope.accelerator = 0
