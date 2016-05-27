
window.app = angular.module("mandala-app", []).
  config(($interpolateProvider) -> $interpolateProvider.startSymbol('[[').endSymbol(']]')).
  controller "Slides", ($scope) ->
    $scope.mandalas = Mandalas
    $scope.livros = Livros
    $scope.total = Estatisticas.total
    
    $scope.imgMandala = (mandala) ->
      document.querySelector("img[src='#{mandala}']")
    
    $scope.imgMandalas = ->
      $scope.imgMandala(mandala) for mandala in $scope.mandalas

    mostrar = (aonde, oque, x,y) ->
      nv.addGraph ->
        chart = nv.models.pieChart().
          width($(window).width() / 1.5).height($(window).height()-100).
          x((d) -> d[x]).
          y((d) -> d[y]).showLabels(true)

        d3.select(aonde).datum(oque).call(chart)
        chart

    mostrar "#mandalas_por_pessoa", Estatisticas.mandalas_por.pessoa(), "pessoa","mandalas"
    mostrar "#mandalas_por_livro", Estatisticas.mandalas_por.livro(), "livro","mandalas"
    mostrar "#livros_por_cidade", Estatisticas.mandalas_por.cidade(), "cidade","livros"
    mostrar "#livros_por_estado", Estatisticas.mandalas_por.estado(), "estado","livros"


