// Generated by CoffeeScript 1.6.3
(function() {
  window.mandalas = {
    initialize: function() {
      console.log("initialize binding events...");
      return this.bindEvents();
    },
    bindEvents: function() {
      document.addEventListener('deviceready', this.onDeviceReady, false);
      return console.log("events binded!");
    },
    onDeviceReady: function() {
      return console.log("Ok! device ready!");
    }
  };

  window.app = angular.module("mandala-app", []);

  window.main = function($scope) {
    var livro, setAnimation, setAnimationState, _i, _j, _len, _len1, _ref, _ref1;
    setAnimationState = function(image, state) {
      if (image !== null) {
        return image.style.webkitAnimationPlayState = image.style.mozAnimationPlayState = image.style.oAnimationPlayState = image.style.animationPlayState = state;
      }
    };
    setAnimation = function(image, actualAnimation) {
      if (image !== null) {
        return image.style.webkitAnimation = image.style.mozAnimation = image.style.oAnimation = image.style.animation = actualAnimation;
      }
    };
    $scope.livros_a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25];
    $scope.livros_b = [1, 2, 3, 4, 5, 6, 7, 8, 9];
    $scope.fromRPM = function() {
      return 60.0 / $scope.accelerator;
    };
    $scope.mandalas = [];
    _ref = $scope.livros_a;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      livro = _ref[_i];
      $scope.mandalas.push("mandalas/1/500x500/0" + livro + "b.png");
    }
    _ref1 = $scope.livros_b;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      livro = _ref1[_j];
      $scope.mandalas.push("mandalas/2/500x500/0" + livro + "b.png");
    }
    $scope.img_mandalas = function() {
      var mandala, _k, _len2, _ref2, _results;
      _ref2 = $scope.mandalas;
      _results = [];
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        mandala = _ref2[_k];
        _results.push(document.querySelector("img[src='" + mandala + "']"));
      }
      return _results;
    };
    $scope.velocimeter = function() {
      return "" + $scope.accelerator + " RPM";
    };
    $scope.accelerate = function() {
      var mandala, newAnimation, newFrequency, _k, _len2, _ref2;
      newFrequency = {
        freq: parseInt($scope.accelerator)
      };
      console.log("new Frequency: " + newFrequency);
      $scope.synth.set(newFrequency);
      $scope.synth.play();
      _ref2 = $scope.img_mandalas();
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        mandala = _ref2[_k];
        if (mandala !== null) {
          setAnimation(mandala, "");
        }
      }
      newAnimation = function() {
        var actualAnimation, _l, _len3, _ref3, _results;
        actualAnimation = "rotation " + ($scope.fromRPM()) + "s infinite linear";
        _ref3 = $scope.img_mandalas();
        _results = [];
        for (_l = 0, _len3 = _ref3.length; _l < _len3; _l++) {
          mandala = _ref3[_l];
          _results.push(setAnimation(mandala, actualAnimation));
        }
        return _results;
      };
      setTimeout(newAnimation, 200);
      if (!$scope.turn_on_motor) {
        return $scope.turn_on_motor = true;
      }
    };
    $scope.showOriginal = function(element) {
      return element.mandala = element.mandala.replace("b.png", ".png");
    };
    $scope.showInCircle = function(element) {
      return element.mandala = element.mandala.replace(".png", "b.png");
    };
    $scope.switch_on_off = function() {
      var image, state, _k, _len2, _ref2, _results;
      if ($scope.turn_on_motor) {
        state = "running";
        $scope.synth.play();
      } else {
        state = "paused";
        $scope.synth.pause();
      }
      _ref2 = $scope.img_mandalas();
      _results = [];
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        image = _ref2[_k];
        _results.push(setAnimationState(image, state));
      }
      return _results;
    };
    $scope.turn_on_motor = false;
    $scope.accelerator = 0;
    return $scope.synth = T("sin");
  };

}).call(this);
