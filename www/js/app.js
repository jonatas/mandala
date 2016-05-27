(function() {
  var gid;

  gid = function(name) {
    return document.getElementById(name);
  };

  window.app = angular.module("mandala-app", []);

  app.directive('imageonload', function() {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        return element.bind('load', function() {
          return scope.$apply(attrs.imageonload);
        });
      }
    };
  });

  window.synth = {};

  window.main = function($scope) {
    var setAnimation, setAnimationState;
    setAnimationState = function(image, state) {
      return $scope.imgMandala().style.webkitAnimationPlayState = image.style.mozAnimationPlayState = image.style.oAnimationPlayState = image.style.animationPlayState = state;
    };
    setAnimation = function(image, actualAnimation) {
      return $scope.imgMandala().style.webkitAnimation = image.style.mozAnimation = image.style.oAnimation = image.style.animation = actualAnimation;
    };
    $scope.instruments = {
      "Acoustic Piano": 0,
      "Xylophone": 13
    };
    $scope.instrumentCode = $scope.instruments["Acoustic Piano"];
    $scope.sc = sc;
    $scope.books = [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27], [1, 2, 3, 4, 5, 6, 7, 8, 9]];
    $scope.fromRPM = function() {
      return 60.0 / $scope.accelerator;
    };
    $scope.mandalaIndex = 0;
    $scope.booksIndex = 0;
    $scope.mandalaSrc = function() {
      return "/img/mandalas/escaneadas/1/500x500/0" + $scope.books[$scope.booksIndex][$scope.mandalaIndex] + "b.png";
    };
    $scope.imgMandala = function() {
      return document.querySelector("img.mandala");
    };
    $scope.mandalaRefresh = function() {
      return $scope.currentMandala = $scope.mandalaSrc();
    };
    $scope.nextMandala = function() {
      if ($scope.mandalaIndex < $scope.books[$scope.booksIndex].length) {
        $scope.mandalaIndex++;
      }
      return $scope.mandalaRefresh();
    };
    $scope.previousMandala = function() {
      if ($scope.mandalaIndex > 0) {
        $scope.mandalaIndex--;
      }
      return $scope.mandalaRefresh();
    };
    $scope.velocimeter = function() {
      return $scope.accelerator + " RPM";
    };
    $scope.accelerate = function() {
      var newAnimation;
      if ($scope.currentMandala !== null) {
        setAnimation($scope.currentMandala, "");
      }
      newAnimation = function() {
        var actualAnimation;
        actualAnimation = "rotation " + ($scope.fromRPM()) + "s infinite linear";
        return setAnimation($scope.currentMandala, actualAnimation);
      };
      setTimeout(newAnimation, 200);
      if (!$scope.turn_on_motor) {
        return $scope.turn_on_motor = true;
      }
    };
    $scope.showOriginal = function(element) {
      if (!$scope.turn_on_motor) {
        return $scope.currentMandala = $scope.currentMandala.replace("b.png", ".png");
      }
    };
    $scope.showInCircle = function(element) {
      if (!$scope.turn_on_motor) {
        return $scope.currentMandala = $scope.currentMandala.replace(".png", "b.png").replace("bb.png", "b.png");
      }
    };
    $scope.switch_on_off = function() {
      var state;
      if ($scope.turn_on_motor) {
        state = "running";
      } else {
        state = "paused";
      }
      return setAnimationState($scope.currentMandala, state);
    };
    $scope.turn_on_motor = false;
    $scope.accelerator = 0;
    $scope.mute = true;
    $scope.colorThief = new ColorThief();
    $scope.play = function(note) {
      T.soundfont.setInstrument($scope.instrumentCode);
      return T.soundfont.play(note);
    };
    $scope.stop = function(note) {
      return T.soundfont.stop(note);
    };
    $scope.showCurrentMandalaPalette = function() {
      var baseColor, baseNote, color, colorsPallete, findBetterNoteFor, findWithFreq, freq, freqFor, i, img, joshnstonMap, len, note, noteC, noteForBaseColor, numberOfScales, pianoNotes, ref;
      img = $scope.imgMandala();
      if (img == null) {
        return;
      }
      joshnstonMap = [[255, 255, 0], [50, 0, 255], [255, 150, 0], [0, 210, 180], [255, 0, 0], [130, 255, 0], [150, 0, 200], [255, 195, 0], [30, 130, 255], [255, 100, 0], [0, 200, 0], [225, 0, 225]];
      findBetterNoteFor = function(color) {
        var betterNote, diff, i, len, note, rgb;
        betterNote = null;
        diff = {};
        note = 1;
        for (i = 0, len = joshnstonMap.length; i < len; i++) {
          rgb = joshnstonMap[i];
          rgb = joshnstonMap[note - 1];
          diff[note] = Math.abs(rgb[0] - color[0]) + Math.abs(rgb[1] - color[1]) + Math.abs(rgb[2] - color[2]);
          if (betterNote === null || diff[note] < diff[betterNote]) {
            betterNote = note;
          }
          note += 1;
        }
        return betterNote;
      };
      noteC = 65.406;
      baseNote = sc.Scale.chromatic().degreeToFreq(sc.Range(12), noteC);
      baseColor = $scope.colorThief.getColor(img);
      noteForBaseColor = $scope.sc.cpsmidi(baseNote[findBetterNoteFor(baseColor)]);
      pianoNotes = sc.Scale.chromatic().degreeToFreq(sc.Range(12 * 5), noteC);
      numberOfScales = 5;
      freqFor = function(color) {
        var betterNote, multiplier, predominantColor;
        predominantColor = color[0];
        if (predominantColor < color[1]) {
          predominantColor = color[1];
        }
        if (predominantColor < color[2]) {
          predominantColor = color[2];
        }
        multiplier = parseInt(predominantColor / 255 * numberOfScales);
        betterNote = findBetterNoteFor(color);
        return pianoNotes[(betterNote - 1) * multiplier] || pianoNotes[betterNote] || 440;
      };
      colorsPallete = [];
      findWithFreq = function(freq) {
        var i, len, mandala;
        for (i = 0, len = colorsPallete.length; i < len; i++) {
          mandala = colorsPallete[i];
          if (mandala.freq === freq) {
            return true;
          }
        }
        return false;
      };
      ref = $scope.colorThief.getPalette(img, 13);
      for (i = 0, len = ref.length; i < len; i++) {
        color = ref[i];
        freq = freqFor(color);
        note = parseInt($scope.sc.cpsmidi(freq));
        freq = Math.round(freq * 100) / 100;
        if (!findWithFreq(freq)) {
          colorsPallete.push({
            color: color,
            note: note,
            freq: freq
          });
        }
      }
      return $scope.currentMandalaPalette = colorsPallete.sort(function(a, b) {
        if (a.note > b.note) {
          return 1;
        } else {
          return -1;
        }
      });
    };
    return $scope.mandalaRefresh();
  };

}).call(this);
