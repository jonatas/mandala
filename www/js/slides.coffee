---
---

window.app = angular.module("mandala-app", []).
  config(($interpolateProvider) -> $interpolateProvider.startSymbol('[[').endSymbol(']]')).
  controller "Slides", ($scope) ->
    console.log "slides controller", this

    $scope.mandalas =[]
    $scope.livros = Livros
    for dir, livro of $scope.livros
      livro.mandalas = []
      livro.capa = 'mandalas/'+dir+'/capa.jpg'
      while livro.mandalas.length < livro.coloridas
        number = livro.mandalas.length + 1
        src = "mandalas/#{dir}/#{number}.jpg"
        livro.mandalas.push src: src, number: number
        $scope.mandalas.push(src)

    console.log $scope.livros, $scope.mandalas
    
    $scope.imgMandala = (mandala) ->
      document.querySelector("img[src='#{mandala}']")
    
    $scope.imgMandalas = ->
      $scope.imgMandala(mandala) for mandala in $scope.mandalas

