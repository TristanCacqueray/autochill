// output/Control.Semigroupoid/index.js
var semigroupoidFn = {
  compose: function(f) {
    return function(g) {
      return function(x) {
        return f(g(x));
      };
    };
  }
};

// output/Control.Category/index.js
var identity = function(dict) {
  return dict.identity;
};
var categoryFn = {
  identity: function(x) {
    return x;
  },
  Semigroupoid0: function() {
    return semigroupoidFn;
  }
};

// output/Data.Boolean/index.js
var otherwise = true;

// output/Data.Function/index.js
var flip = function(f) {
  return function(b) {
    return function(a) {
      return f(a)(b);
    };
  };
};
var $$const = function(a) {
  return function(v) {
    return a;
  };
};

// output/Data.Unit/foreign.js
var unit = void 0;

// output/Data.Functor/index.js
var map = function(dict) {
  return dict.map;
};
var $$void = function(dictFunctor) {
  return map(dictFunctor)($$const(unit));
};

// output/Data.Semigroup/index.js
var append = function(dict) {
  return dict.append;
};

// output/Control.Apply/index.js
var identity2 = /* @__PURE__ */ identity(categoryFn);
var apply = function(dict) {
  return dict.apply;
};
var applySecond = function(dictApply) {
  var apply1 = apply(dictApply);
  var map4 = map(dictApply.Functor0());
  return function(a) {
    return function(b) {
      return apply1(map4($$const(identity2))(a))(b);
    };
  };
};

// output/Control.Applicative/index.js
var pure = function(dict) {
  return dict.pure;
};
var unless = function(dictApplicative) {
  var pure1 = pure(dictApplicative);
  return function(v) {
    return function(v1) {
      if (!v) {
        return v1;
      }
      ;
      if (v) {
        return pure1(unit);
      }
      ;
      throw new Error("Failed pattern match at Control.Applicative (line 68, column 1 - line 68, column 65): " + [v.constructor.name, v1.constructor.name]);
    };
  };
};
var liftA1 = function(dictApplicative) {
  var apply3 = apply(dictApplicative.Apply0());
  var pure1 = pure(dictApplicative);
  return function(f) {
    return function(a) {
      return apply3(pure1(f))(a);
    };
  };
};

// output/Data.Bounded/foreign.js
var topInt = 2147483647;
var bottomInt = -2147483648;
var topChar = String.fromCharCode(65535);
var bottomChar = String.fromCharCode(0);
var topNumber = Number.POSITIVE_INFINITY;
var bottomNumber = Number.NEGATIVE_INFINITY;

// output/Data.Ord/foreign.js
var unsafeCompareImpl = function(lt) {
  return function(eq2) {
    return function(gt) {
      return function(x) {
        return function(y) {
          return x < y ? lt : x === y ? eq2 : gt;
        };
      };
    };
  };
};
var ordIntImpl = unsafeCompareImpl;
var ordNumberImpl = unsafeCompareImpl;

// output/Data.Eq/foreign.js
var refEq = function(r1) {
  return function(r2) {
    return r1 === r2;
  };
};
var eqIntImpl = refEq;
var eqNumberImpl = refEq;

// output/Data.Eq/index.js
var eqNumber = {
  eq: eqNumberImpl
};
var eqInt = {
  eq: eqIntImpl
};

// output/Data.Ordering/index.js
var LT = /* @__PURE__ */ function() {
  function LT2() {
  }
  ;
  LT2.value = new LT2();
  return LT2;
}();
var GT = /* @__PURE__ */ function() {
  function GT2() {
  }
  ;
  GT2.value = new GT2();
  return GT2;
}();
var EQ = /* @__PURE__ */ function() {
  function EQ2() {
  }
  ;
  EQ2.value = new EQ2();
  return EQ2;
}();

// output/Data.Ord/index.js
var ordNumber = /* @__PURE__ */ function() {
  return {
    compare: ordNumberImpl(LT.value)(EQ.value)(GT.value),
    Eq0: function() {
      return eqNumber;
    }
  };
}();
var ordInt = /* @__PURE__ */ function() {
  return {
    compare: ordIntImpl(LT.value)(EQ.value)(GT.value),
    Eq0: function() {
      return eqInt;
    }
  };
}();
var compare = function(dict) {
  return dict.compare;
};
var max = function(dictOrd) {
  var compare3 = compare(dictOrd);
  return function(x) {
    return function(y) {
      var v = compare3(x)(y);
      if (v instanceof LT) {
        return y;
      }
      ;
      if (v instanceof EQ) {
        return x;
      }
      ;
      if (v instanceof GT) {
        return x;
      }
      ;
      throw new Error("Failed pattern match at Data.Ord (line 181, column 3 - line 184, column 12): " + [v.constructor.name]);
    };
  };
};

// output/Data.Bounded/index.js
var top = function(dict) {
  return dict.top;
};
var boundedInt = {
  top: topInt,
  bottom: bottomInt,
  Ord0: function() {
    return ordInt;
  }
};
var bottom = function(dict) {
  return dict.bottom;
};

// output/Data.Show/foreign.js
var showIntImpl = function(n) {
  return n.toString();
};
var showNumberImpl = function(n) {
  var str = n.toString();
  return isNaN(str + ".0") ? str : str + ".0";
};

// output/Data.Show/index.js
var showNumber = {
  show: showNumberImpl
};
var showInt = {
  show: showIntImpl
};
var show = function(dict) {
  return dict.show;
};

// output/Data.Maybe/index.js
var identity3 = /* @__PURE__ */ identity(categoryFn);
var Nothing = /* @__PURE__ */ function() {
  function Nothing2() {
  }
  ;
  Nothing2.value = new Nothing2();
  return Nothing2;
}();
var Just = /* @__PURE__ */ function() {
  function Just2(value0) {
    this.value0 = value0;
  }
  ;
  Just2.create = function(value0) {
    return new Just2(value0);
  };
  return Just2;
}();
var showMaybe = function(dictShow) {
  var show9 = show(dictShow);
  return {
    show: function(v) {
      if (v instanceof Just) {
        return "(Just " + (show9(v.value0) + ")");
      }
      ;
      if (v instanceof Nothing) {
        return "Nothing";
      }
      ;
      throw new Error("Failed pattern match at Data.Maybe (line 223, column 1 - line 225, column 28): " + [v.constructor.name]);
    }
  };
};
var maybe = function(v) {
  return function(v1) {
    return function(v2) {
      if (v2 instanceof Nothing) {
        return v;
      }
      ;
      if (v2 instanceof Just) {
        return v1(v2.value0);
      }
      ;
      throw new Error("Failed pattern match at Data.Maybe (line 237, column 1 - line 237, column 51): " + [v.constructor.name, v1.constructor.name, v2.constructor.name]);
    };
  };
};
var fromMaybe = function(a) {
  return maybe(a)(identity3);
};

// output/Effect.Ref/foreign.js
var _new = function(val) {
  return function() {
    return { value: val };
  };
};
var read = function(ref2) {
  return function() {
    return ref2.value;
  };
};
var write = function(val) {
  return function(ref2) {
    return function() {
      ref2.value = val;
    };
  };
};

// output/Effect/foreign.js
var pureE = function(a) {
  return function() {
    return a;
  };
};
var bindE = function(a) {
  return function(f) {
    return function() {
      return f(a())();
    };
  };
};

// output/Control.Bind/index.js
var bind = function(dict) {
  return dict.bind;
};

// output/Control.Monad/index.js
var ap = function(dictMonad) {
  var bind2 = bind(dictMonad.Bind1());
  var pure2 = pure(dictMonad.Applicative0());
  return function(f) {
    return function(a) {
      return bind2(f)(function(f$prime) {
        return bind2(a)(function(a$prime) {
          return pure2(f$prime(a$prime));
        });
      });
    };
  };
};

// output/Data.Monoid/index.js
var mempty = function(dict) {
  return dict.mempty;
};

// output/Effect/index.js
var $runtime_lazy = function(name2, moduleName, init3) {
  var state2 = 0;
  var val;
  return function(lineNumber) {
    if (state2 === 2)
      return val;
    if (state2 === 1)
      throw new ReferenceError(name2 + " was needed before it finished initializing (module " + moduleName + ", line " + lineNumber + ")", moduleName, lineNumber);
    state2 = 1;
    val = init3();
    state2 = 2;
    return val;
  };
};
var monadEffect = {
  Applicative0: function() {
    return applicativeEffect;
  },
  Bind1: function() {
    return bindEffect;
  }
};
var bindEffect = {
  bind: bindE,
  Apply0: function() {
    return $lazy_applyEffect(0);
  }
};
var applicativeEffect = {
  pure: pureE,
  Apply0: function() {
    return $lazy_applyEffect(0);
  }
};
var $lazy_functorEffect = /* @__PURE__ */ $runtime_lazy("functorEffect", "Effect", function() {
  return {
    map: liftA1(applicativeEffect)
  };
});
var $lazy_applyEffect = /* @__PURE__ */ $runtime_lazy("applyEffect", "Effect", function() {
  return {
    apply: ap(monadEffect),
    Functor0: function() {
      return $lazy_functorEffect(0);
    }
  };
});
var functorEffect = /* @__PURE__ */ $lazy_functorEffect(20);

// output/Effect.Ref/index.js
var $$new = _new;

// output/AutoChill.Env/index.js
var createEnv = function(debug) {
  return function __do() {
    var timerMain = $$new(Nothing.value)();
    var timerDbus = $$new(Nothing.value)();
    var idleTimeRef = $$new(0)();
    var cancellable = $$new(Nothing.value)();
    return {
      timerMain,
      timerDbus,
      idleTimeRef,
      cancellable,
      snoozeDelay: 5e3 * function() {
        if (debug) {
          return 1;
        }
        ;
        return 60;
      }() | 0,
      debug
    };
  };
};

// output/AutoChill.Curve/index.js
var max2 = /* @__PURE__ */ max(ordNumber);
var chillTemperature = function(cutoff) {
  return function(slope) {
    return function(time) {
      var x = max2(0)(time - cutoff);
      var y = 1 - x * x * slope;
      var temp = max2(0)(y);
      return temp;
    };
  };
};

// output/GLib.Variant/foreign.js
import GLib from "gi://GLib";
var Variant = GLib.Variant;
var new_double = (v) => () => Variant.new_double(v);
var new_uint32 = (v) => () => Variant.new_uint32(v);
var get_uint64 = (v) => () => v.get_uint64();
var get_child_value = (v) => (index) => () => v.get_child_value(index);

// output/Gio.DBusCallFlags/foreign.js
import Gio from "gi://Gio";
var DBusCallFlags = Gio.DBusCallFlags;
var none = DBusCallFlags.NONE;

// output/Gio.DBusConnection/foreign.js
import Gio2 from "gi://Gio";
var DBus = Gio2.DBus;
var DBusConnection = Gio2.DBusConnection;
var session = DBus.session;
var system = DBus.system;
var call_impl = (conn2) => (bus_name) => (object_path) => (interface_name) => (method_name) => (parameters) => (reply_type) => (flags) => (timeout_msec) => (cancellable) => (cbM) => () => {
  const cb = cbM ? (_obj, res) => cbM(res)() : null;
  conn2.call(
    bus_name,
    object_path,
    interface_name,
    method_name,
    parameters,
    reply_type,
    flags,
    timeout_msec,
    cancellable,
    cb
  );
};
var call_finish = (conn2) => (res) => () => conn2.call_finish(res);

// output/Data.Nullable/foreign.js
var nullImpl = null;
function notNull(x) {
  return x;
}

// output/Data.Nullable/index.js
var toNullable = /* @__PURE__ */ maybe(nullImpl)(notNull);

// output/Gio.DBusConnection/index.js
var call = function(conn2) {
  return function(bus_name) {
    return function(object_path) {
      return function(interface_name) {
        return function(method_name) {
          return function(parameters) {
            return function(reply_type) {
              return function(flags) {
                return function(timeout_msec) {
                  return function(cancellable) {
                    return function(cb) {
                      return call_impl(conn2)(toNullable(bus_name))(object_path)(interface_name)(method_name)(toNullable(parameters))(toNullable(reply_type))(flags)(timeout_msec)(toNullable(cancellable))(toNullable(cb));
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
  };
};

// output/AutoChill.DBus/index.js
var simpleCall = function(cancellable) {
  return function($$interface) {
    return function(path2) {
      return function(method) {
        return function(writeCb) {
          var cb = function(res) {
            return function __do() {
              var xs = call_finish(session)(res)();
              var x = get_child_value(xs)(0)();
              return writeCb(x)();
            };
          };
          return call(session)(new Just($$interface))(path2)($$interface)(method)(Nothing.value)(Nothing.value)(none)(200)(new Just(cancellable))(new Just(cb));
        };
      };
    };
  };
};
var getIdleTime = function(c) {
  return function(ref2) {
    var writeCb = function(variant) {
      return function __do() {
        var value = get_uint64(variant)();
        return write(value)(ref2)();
      };
    };
    return simpleCall(c)("org.gnome.Mutter.IdleMonitor")("/org/gnome/Mutter/IdleMonitor/Core")("GetIdletime")(writeCb);
  };
};

// output/Data.Int/foreign.js
var fromNumberImpl = function(just) {
  return function(nothing) {
    return function(n) {
      return (n | 0) === n ? just(n) : nothing;
    };
  };
};
var toNumber = function(n) {
  return n;
};
var fromStringAsImpl = function(just) {
  return function(nothing) {
    return function(radix) {
      var digits;
      if (radix < 11) {
        digits = "[0-" + (radix - 1).toString() + "]";
      } else if (radix === 11) {
        digits = "[0-9a]";
      } else {
        digits = "[0-9a-" + String.fromCharCode(86 + radix) + "]";
      }
      var pattern = new RegExp("^[\\+\\-]?" + digits + "+$", "i");
      return function(s) {
        if (pattern.test(s)) {
          var i = parseInt(s, radix);
          return (i | 0) === i ? just(i) : nothing;
        } else {
          return nothing;
        }
      };
    };
  };
};

// output/Data.Number/foreign.js
var isFiniteImpl = isFinite;
var round = Math.round;

// output/Data.Int/index.js
var top2 = /* @__PURE__ */ top(boundedInt);
var bottom2 = /* @__PURE__ */ bottom(boundedInt);
var fromStringAs = /* @__PURE__ */ function() {
  return fromStringAsImpl(Just.create)(Nothing.value);
}();
var fromString = /* @__PURE__ */ fromStringAs(10);
var fromNumber = /* @__PURE__ */ function() {
  return fromNumberImpl(Just.create)(Nothing.value);
}();
var unsafeClamp = function(x) {
  if (!isFiniteImpl(x)) {
    return 0;
  }
  ;
  if (x >= toNumber(top2)) {
    return top2;
  }
  ;
  if (x <= toNumber(bottom2)) {
    return bottom2;
  }
  ;
  if (otherwise) {
    return fromMaybe(0)(fromNumber(x));
  }
  ;
  throw new Error("Failed pattern match at Data.Int (line 72, column 1 - line 72, column 29): " + [x.constructor.name]);
};
var round2 = function($37) {
  return unsafeClamp(round($37));
};

// output/GJS/foreign.js
var argv = ARGV;
var log2 = (msg) => () => console.log(msg);
var warn = (msg) => () => console.warn(msg);

// output/Data.Tuple/index.js
var Tuple = /* @__PURE__ */ function() {
  function Tuple2(value0, value1) {
    this.value0 = value0;
    this.value1 = value1;
  }
  ;
  Tuple2.create = function(value0) {
    return function(value1) {
      return new Tuple2(value0, value1);
    };
  };
  return Tuple2;
}();

// output/GJS/index.js
var printerr2 = warn;
var print = log2;

// output/GLib/foreign.js
import GLib2 from "gi://GLib";
var timeoutAdd = (interval) => (cb) => () => GLib2.timeout_add(GLib2.PRIORITY_DEFAULT, interval, cb);
var sourceRemove = (source) => () => GLib2.source_remove(source);

// output/GLib.DateTime/foreign.js
import GLib3 from "gi://GLib";
var new_now_utc = () => GLib3.DateTime.new_now_utc();
var to_unix = (dt) => dt.to_unix();

// output/GLib.DateTime/index.js
var getUnix = /* @__PURE__ */ map(functorEffect)(to_unix)(new_now_utc);

// output/Gio.Cancellable/foreign.js
import Gio3 from "gi://Gio";
var new_ = () => Gio3.Cancellable.new();
var cancel = (cancellable) => () => cancellable.cancel();

// output/Gio.Cancellable/index.js
var $$new2 = new_;

// output/Gio.Settings/foreign.js
import Gio4 from "gi://Gio";
var new_2 = (name2) => () => Gio4.Settings.new(name2);
var new_full = (schema) => () => Gio4.Settings.new_full(schema, null, null);
var set_value = (instance) => (key) => (value) => () => instance.set_value(key, value);
var get_int = (instance) => (key) => () => instance.get_int(key);
var set_int = (instance) => (key) => (value) => () => instance.set_int(key, value);
var get_double2 = (instance) => (key) => () => instance.get_double(key);
var set_double = (instance) => (key) => (value) => () => instance.set_double(key, value);

// output/Gio.Settings/index.js
var $$new3 = new_2;

// output/AutoChill.Worker/index.js
var map2 = /* @__PURE__ */ map(functorEffect);
var show2 = /* @__PURE__ */ show(showNumber);
var show1 = /* @__PURE__ */ show(showInt);
var unless2 = /* @__PURE__ */ unless(applicativeEffect);
var stopChillWorker = function(env) {
  var sourceRemoveM = function(ref2) {
    return function __do() {
      var timerM = read(ref2)();
      (function() {
        if (timerM instanceof Just) {
          return sourceRemove(timerM.value0)();
        }
        ;
        if (timerM instanceof Nothing) {
          return log2("Oops, empty timer")();
        }
        ;
        throw new Error("Failed pattern match at AutoChill.Worker (line 45, column 5 - line 47, column 45): " + [timerM.constructor.name]);
      })();
      return write(Nothing.value)(ref2)();
    };
  };
  return function __do() {
    var cancellableM = read(env.cancellable)();
    (function() {
      if (cancellableM instanceof Just) {
        cancel(cancellableM.value0)();
        return write(Nothing.value)(env.cancellable)();
      }
      ;
      if (cancellableM instanceof Nothing) {
        return log2("Oops, empty cancellable")();
      }
      ;
      throw new Error("Failed pattern match at AutoChill.Worker (line 35, column 3 - line 39, column 49): " + [cancellableM.constructor.name]);
    })();
    sourceRemoveM(env.timerMain)();
    return sourceRemoveM(env.timerDbus)();
  };
};
var startIdleWorker = function(env) {
  var go = function(cancellable) {
    return function __do() {
      getIdleTime(cancellable)(env.idleTimeRef)();
      return true;
    };
  };
  return function __do() {
    var timerDbusM = read(env.timerDbus)();
    (function() {
      if (timerDbusM instanceof Just) {
        log2("Idle worker already running!")();
        return sourceRemove(timerDbusM.value0)();
      }
      ;
      if (timerDbusM instanceof Nothing) {
        return unit;
      }
      ;
      throw new Error("Failed pattern match at AutoChill.Worker (line 53, column 3 - line 57, column 25): " + [timerDbusM.constructor.name]);
    })();
    var cancellable = $$new2();
    write(new Just(cancellable))(env.cancellable)();
    var timer = timeoutAdd(5e3)(go(cancellable))();
    return write(new Just(timer))(env.timerDbus)();
  };
};
var setColor = function(colorSettings) {
  return function(value) {
    return function __do() {
      var v = new_uint32(value)();
      set_value(colorSettings)("night-light-temperature")(v)();
      return unit;
    };
  };
};
var enableNightLight = function(colorSettings) {
  return function __do() {
    var v = new_double(0)();
    set_value(colorSettings)("night-light-schedule-from")(v)();
    var v$prime = new_double(24)();
    var _$prime = set_value(colorSettings)("night-light-schedule-to")(v$prime)();
    return log2("Activating night light")();
  };
};
var autoChillWorker = function(settings) {
  return function(env) {
    return function(show_dialog) {
      var minute_sec = function() {
        if (env.debug) {
          return 1;
        }
        ;
        return 60;
      }();
      var minute_msec = minute_sec * 1e3 | 0;
      var maxIdleTime = 10 * minute_msec | 0;
      var go = function(startTime) {
        return function(lastTimeRef) {
          var getSetting = function(name2) {
            return map2(toNumber)(get_int(settings.settings)(name2));
          };
          var getCurveSetting = function(name2) {
            return get_double2(settings.settings)(name2);
          };
          return function __do() {
            var now = getUnix();
            var durationSeconds = getSetting("duration")();
            var startTemp = getSetting("work-temp")();
            var endTemp = getSetting("chill-temp")();
            var slope = getCurveSetting("slope")();
            var cutoff = getCurveSetting("cutoff")();
            var idleTime = read(env.idleTimeRef)();
            var lastTime = read(lastTimeRef)();
            var idle = idleTime > maxIdleTime;
            var elapsed = toNumber(now - startTime | 0);
            var duration = durationSeconds * toNumber(minute_sec);
            var elapsedNorm = elapsed / duration;
            var newTempNorm = chillTemperature(cutoff)(slope)(elapsedNorm);
            var newTemp = endTemp + (startTemp - endTemp) * newTempNorm;
            var asleep = (now - lastTime | 0) > 600;
            var shouldStop = elapsed >= duration || (idle || asleep);
            log2("AutoChill running for " + (show2(elapsed) + (" sec ( remaining: " + (show2(duration - elapsed) + ") ")) + (" idle: " + show1(idleTime) + (" temp: " + show2(newTemp) + (function() {
              if (idle) {
                return " idle";
              }
              ;
              return "";
            }() + function() {
              if (asleep) {
                return " asleep";
              }
              ;
              return "";
            }())))))();
            if (shouldStop) {
              stopChillWorker(env)();
              show_dialog();
              return false;
            }
            ;
            unless2(env.debug)(setColor(settings.colorSettings)(round2(newTemp)))();
            write(now)(lastTimeRef)();
            return true;
          };
        };
      };
      return function __do() {
        log2("Ah darn, here we go again")();
        unless2(env.debug)(enableNightLight(settings.colorSettings))();
        startIdleWorker(env)();
        var startTime = getUnix();
        var lastTimeRef = $$new(startTime)();
        write(0)(env.idleTimeRef)();
        var timer = timeoutAdd(1e3)(go(startTime)(lastTimeRef))();
        return write(new Just(timer))(env.timerMain)();
      };
    };
  };
};

// output/Clutter.Actor/foreign.js
var unsafe_add_child = (actor) => (child) => () => actor.add_child(child);
var unsafe_set_position = (actor) => (x) => (y) => () => actor.set_position(x, y);
var unsafe_set_reactive = (actor) => (b) => () => actor.set_reactive(b);
var unsafe_destroy = (actor) => () => actor.destroy();
var unsafe_show = (actor) => () => actor.show();
var unsafe_hide = (actor) => () => actor.hide();
var unsafe_onButtonPressEvent = (actor) => (cb) => () => actor.connect("button-press-event", (actor2, event) => cb(actor2)(event)());
var unsafe_set_layout_manager = (actor) => (lm) => () => actor.set_layout_manager(lm);

// output/Clutter.Actor/index.js
var show3 = function() {
  return unsafe_show;
};
var set_reactive = function() {
  return unsafe_set_reactive;
};
var set_position = function() {
  return unsafe_set_position;
};
var set_layout_manager = function() {
  return function() {
    return unsafe_set_layout_manager;
  };
};
var onButtonPressEvent = function() {
  return unsafe_onButtonPressEvent;
};
var hide = function() {
  return unsafe_hide;
};
var destroy = function() {
  return unsafe_destroy;
};
var add_child = function() {
  return function() {
    return unsafe_add_child;
  };
};

// output/Clutter.BoxLayout/foreign.js
import Clutter from "gi://Clutter";
var new_3 = () => Clutter.BoxLayout.new();
var set_orientation = (box) => (o) => () => box.set_orientation(o);

// output/Clutter.BoxLayout/index.js
var $$new4 = new_3;

// output/Gnome.UI.Main/foreign.js
import * as Main from "resource:///org/gnome/shell/ui/main.js";
var notify2 = (msg) => (details) => () => Main.notify(msg, details);
var defaultParams = {};
var unsafe_addTopChrome = (actor) => () => Main.layoutManager.addTopChrome(actor, defaultParams);
var unsafe_removeChrome = (actor) => () => Main.layoutManager.removeChrome(actor);

// output/Gnome.UI.Main/index.js
var removeChrome = function() {
  return unsafe_removeChrome;
};
var addTopChrome = function() {
  return unsafe_addTopChrome;
};

// output/St/foreign.js
import St from "gi://St";
var unsafe_add_style_class_name = (widget) => (name2) => () => widget.add_style_class_name(name2);
var unsafe_set_style = (widget) => (style) => () => widget.set_style(style);

// output/St/index.js
var set_style = function() {
  return function(widget) {
    return function(styleM) {
      return unsafe_set_style(widget)(toNullable(styleM));
    };
  };
};
var add_style_class_name = function() {
  return unsafe_add_style_class_name;
};

// output/St.Bin/foreign.js
import St2 from "gi://St";
var new_4 = () => St2.Bin.new();
var unsafe_set_child = (bin) => (child) => () => bin.set_child(child);

// output/St.Bin/index.js
var set_child = function() {
  return unsafe_set_child;
};
var $$new5 = new_4;

// output/St.BoxLayout/foreign.js
import St3 from "gi://St";
var new_5 = () => St3.BoxLayout.new();

// output/St.BoxLayout/index.js
var $$new6 = new_5;

// output/St.Button/foreign.js
import St4 from "gi://St";
var new_with_label = (label) => () => St4.Button.new_with_label(label);

// output/St.Label/foreign.js
import St5 from "gi://St";
var new_7 = (txt) => () => St5.Label.new(txt);

// output/St.Label/index.js
var $$new7 = new_7;

// output/AutoChill.UIClutter/index.js
var show4 = /* @__PURE__ */ show3();
var set_reactive2 = /* @__PURE__ */ set_reactive();
var add_style_class_name2 = /* @__PURE__ */ add_style_class_name();
var set_style2 = /* @__PURE__ */ set_style();
var show12 = /* @__PURE__ */ show(showInt);
var $$void2 = /* @__PURE__ */ $$void(functorEffect);
var hide2 = /* @__PURE__ */ hide();
var set_position2 = /* @__PURE__ */ set_position();
var set_layout_manager2 = /* @__PURE__ */ set_layout_manager()();
var add_child2 = /* @__PURE__ */ add_child()();
var onButtonPressEvent2 = /* @__PURE__ */ onButtonPressEvent();
var set_child2 = /* @__PURE__ */ set_child();
var solarColor = "background-color: #fdf6e3; color: #586e75;";
var showWidget = function(bin) {
  return show4(bin);
};
var remove = /* @__PURE__ */ removeChrome();
var button = function(label) {
  return function __do() {
    var but = new_with_label(label)();
    set_reactive2(but)(true)();
    add_style_class_name2(but)("button")();
    set_style2(but)(new Just(solarColor))();
    return but;
  };
};
var mkWidget = function(settings) {
  return function(env) {
    var snooze = function(bin) {
      return function __do() {
        log2("Snoozing for " + show12(env.snoozeDelay))();
        return $$void2(timeoutAdd(env.snoozeDelay)(function __do2() {
          show4(bin)();
          return false;
        }))();
      };
    };
    var onClick = function(bin) {
      return function(action) {
        return function(_actor) {
          return function(_ev) {
            return function __do() {
              hide2(bin)();
              action(bin)();
              return true;
            };
          };
        };
      };
    };
    return function __do() {
      var bin = $$new5();
      set_position2(bin)(10)(100)();
      set_style2(bin)(new Just(solarColor + "padding: 5px; margin: 5px; border: 1px;"))();
      var box = $$new6();
      var lm = $$new4();
      set_orientation(lm)(1)();
      set_layout_manager2(box)(lm)();
      var label = $$new7("Time for a break?")();
      add_child2(box)(label)();
      var actionBox = $$new6();
      var lm$prime = $$new4();
      set_orientation(lm$prime)(0)();
      set_layout_manager2(actionBox)(lm$prime)();
      add_child2(box)(actionBox)();
      var chillButton = button("I feel chilled")();
      add_child2(actionBox)(chillButton)();
      $$void2(onButtonPressEvent2(chillButton)(onClick(bin)($$const(autoChillWorker(settings)(env)(show4(bin))))))();
      var snoozeButton = button("Snooze")();
      add_child2(actionBox)(snoozeButton)();
      $$void2(onButtonPressEvent2(snoozeButton)(onClick(bin)(snooze)))();
      set_child2(bin)(box)();
      hide2(bin)();
      return bin;
    };
  };
};
var add2 = /* @__PURE__ */ addTopChrome();

// output/Gio.ThemedIcon/foreign.js
import Gio5 from "gi://Gio";
var new_8 = (name2) => () => Gio5.ThemedIcon.new(name2);

// output/Gio.ThemedIcon/index.js
var $$new8 = new_8;

// output/Gnome.UI.Main.Panel/foreign.js
import * as Main2 from "resource:///org/gnome/shell/ui/main.js";
var addToStatusArea = (role) => (indicator) => () => Main2.panel.addToStatusArea(role, indicator);

// output/Gnome.UI.PanelMenu/foreign.js
import * as PanelMenu from "resource:///org/gnome/shell/ui/panelMenu.js";
import * as BoxPointer from "resource:///org/gnome/shell/ui/boxpointer.js";
var newButton = (alignment) => (name2) => (dontCreateMenu) => () => new PanelMenu.Button(alignment, name2, dontCreateMenu);
var addMenuItem = (button2) => (item) => () => button2.menu.addMenuItem(item);

// output/Gnome.UI.PopupMenu/foreign.js
import * as PopupMenu from "resource:///org/gnome/shell/ui/popupMenu.js";
var newItem = (name2) => () => new PopupMenu.PopupMenuItem(name2);
var connectActivate = (item) => (cb) => () => item.connect("activate", cb);

// output/St.Icon/foreign.js
import St6 from "gi://St";
var new_9 = () => St6.Icon.new();
var set_gicon = (icon) => (gicon) => () => icon.set_gicon(gicon);

// output/St.Icon/index.js
var $$new9 = new_9;

// output/AutoChill.PanelMenu/index.js
var add_style_class_name3 = /* @__PURE__ */ add_style_class_name();
var add_child3 = /* @__PURE__ */ add_child()();
var $$delete = /* @__PURE__ */ destroy();
var create = function(ui) {
  return function(settings) {
    return function(env) {
      var onClick = function __do() {
        log2("Restart")();
        stopChillWorker(env)();
        return autoChillWorker(settings)(env)(showWidget(ui))();
      };
      return function __do() {
        var button2 = newButton(0)("AutoChill")(false)();
        var gicon = $$new8("weather-snow-symbolic")();
        var icon = $$new9();
        add_style_class_name3(icon)("system-status-icon")();
        set_gicon(icon)(gicon)();
        add_child3(button2)(icon)();
        var menuItem = newItem("")();
        connectActivate(menuItem)(onClick)();
        var label = $$new7("Restart")();
        add_child3(menuItem)(label)();
        addMenuItem(button2)(menuItem)();
        addToStatusArea("autochill")(button2)();
        return button2;
      };
    };
  };
};

// output/Cairo/foreign.js
var moveTo = (cr) => (x) => (y) => () => cr.moveTo(x, y);
var setSourceRGB = (cr) => (r) => (g) => (b) => () => cr.setSourceRGB(r, g, b);
var showText = (cr) => (txt) => () => cr.showText(txt);
var lineTo = (cr) => (x) => (y) => () => cr.lineTo(x, y);
var stroke = (cr) => () => cr.stroke();

// output/Data.Foldable/index.js
var foldr = function(dict) {
  return dict.foldr;
};
var traverse_ = function(dictApplicative) {
  var applySecond2 = applySecond(dictApplicative.Apply0());
  var pure2 = pure(dictApplicative);
  return function(dictFoldable) {
    var foldr2 = foldr(dictFoldable);
    return function(f) {
      return foldr2(function($454) {
        return applySecond2(f($454));
      })(pure2(unit));
    };
  };
};
var foldl = function(dict) {
  return dict.foldl;
};

// output/Data.Traversable/foreign.js
var traverseArrayImpl = function() {
  function array1(a) {
    return [a];
  }
  function array2(a) {
    return function(b) {
      return [a, b];
    };
  }
  function array3(a) {
    return function(b) {
      return function(c) {
        return [a, b, c];
      };
    };
  }
  function concat2(xs) {
    return function(ys) {
      return xs.concat(ys);
    };
  }
  return function(apply3) {
    return function(map4) {
      return function(pure2) {
        return function(f) {
          return function(array) {
            function go(bot, top3) {
              switch (top3 - bot) {
                case 0:
                  return pure2([]);
                case 1:
                  return map4(array1)(f(array[bot]));
                case 2:
                  return apply3(map4(array2)(f(array[bot])))(f(array[bot + 1]));
                case 3:
                  return apply3(apply3(map4(array3)(f(array[bot])))(f(array[bot + 1])))(f(array[bot + 2]));
                default:
                  var pivot = bot + Math.floor((top3 - bot) / 4) * 2;
                  return apply3(map4(concat2)(go(bot, pivot)))(go(pivot, top3));
              }
            }
            return go(0, array.length);
          };
        };
      };
    };
  };
}();

// output/Data.List.Types/index.js
var Nil = /* @__PURE__ */ function() {
  function Nil2() {
  }
  ;
  Nil2.value = new Nil2();
  return Nil2;
}();
var Cons = /* @__PURE__ */ function() {
  function Cons2(value0, value1) {
    this.value0 = value0;
    this.value1 = value1;
  }
  ;
  Cons2.create = function(value0) {
    return function(value1) {
      return new Cons2(value0, value1);
    };
  };
  return Cons2;
}();
var listMap = function(f) {
  var chunkedRevMap = function($copy_v) {
    return function($copy_v1) {
      var $tco_var_v = $copy_v;
      var $tco_done = false;
      var $tco_result;
      function $tco_loop(v, v1) {
        if (v1 instanceof Cons && (v1.value1 instanceof Cons && v1.value1.value1 instanceof Cons)) {
          $tco_var_v = new Cons(v1, v);
          $copy_v1 = v1.value1.value1.value1;
          return;
        }
        ;
        var unrolledMap = function(v2) {
          if (v2 instanceof Cons && (v2.value1 instanceof Cons && v2.value1.value1 instanceof Nil)) {
            return new Cons(f(v2.value0), new Cons(f(v2.value1.value0), Nil.value));
          }
          ;
          if (v2 instanceof Cons && v2.value1 instanceof Nil) {
            return new Cons(f(v2.value0), Nil.value);
          }
          ;
          return Nil.value;
        };
        var reverseUnrolledMap = function($copy_v2) {
          return function($copy_v3) {
            var $tco_var_v2 = $copy_v2;
            var $tco_done1 = false;
            var $tco_result2;
            function $tco_loop2(v2, v3) {
              if (v2 instanceof Cons && (v2.value0 instanceof Cons && (v2.value0.value1 instanceof Cons && v2.value0.value1.value1 instanceof Cons))) {
                $tco_var_v2 = v2.value1;
                $copy_v3 = new Cons(f(v2.value0.value0), new Cons(f(v2.value0.value1.value0), new Cons(f(v2.value0.value1.value1.value0), v3)));
                return;
              }
              ;
              $tco_done1 = true;
              return v3;
            }
            ;
            while (!$tco_done1) {
              $tco_result2 = $tco_loop2($tco_var_v2, $copy_v3);
            }
            ;
            return $tco_result2;
          };
        };
        $tco_done = true;
        return reverseUnrolledMap(v)(unrolledMap(v1));
      }
      ;
      while (!$tco_done) {
        $tco_result = $tco_loop($tco_var_v, $copy_v1);
      }
      ;
      return $tco_result;
    };
  };
  return chunkedRevMap(Nil.value);
};
var functorList = {
  map: listMap
};
var foldableList = {
  foldr: function(f) {
    return function(b) {
      var rev = function() {
        var go = function($copy_v) {
          return function($copy_v1) {
            var $tco_var_v = $copy_v;
            var $tco_done = false;
            var $tco_result;
            function $tco_loop(v, v1) {
              if (v1 instanceof Nil) {
                $tco_done = true;
                return v;
              }
              ;
              if (v1 instanceof Cons) {
                $tco_var_v = new Cons(v1.value0, v);
                $copy_v1 = v1.value1;
                return;
              }
              ;
              throw new Error("Failed pattern match at Data.List.Types (line 107, column 7 - line 107, column 23): " + [v.constructor.name, v1.constructor.name]);
            }
            ;
            while (!$tco_done) {
              $tco_result = $tco_loop($tco_var_v, $copy_v1);
            }
            ;
            return $tco_result;
          };
        };
        return go(Nil.value);
      }();
      var $284 = foldl(foldableList)(flip(f))(b);
      return function($285) {
        return $284(rev($285));
      };
    };
  },
  foldl: function(f) {
    var go = function($copy_b) {
      return function($copy_v) {
        var $tco_var_b = $copy_b;
        var $tco_done1 = false;
        var $tco_result;
        function $tco_loop(b, v) {
          if (v instanceof Nil) {
            $tco_done1 = true;
            return b;
          }
          ;
          if (v instanceof Cons) {
            $tco_var_b = f(b)(v.value0);
            $copy_v = v.value1;
            return;
          }
          ;
          throw new Error("Failed pattern match at Data.List.Types (line 111, column 12 - line 113, column 30): " + [v.constructor.name]);
        }
        ;
        while (!$tco_done1) {
          $tco_result = $tco_loop($tco_var_b, $copy_v);
        }
        ;
        return $tco_result;
      };
    };
    return go;
  },
  foldMap: function(dictMonoid) {
    var append22 = append(dictMonoid.Semigroup0());
    var mempty2 = mempty(dictMonoid);
    return function(f) {
      return foldl(foldableList)(function(acc) {
        var $286 = append22(acc);
        return function($287) {
          return $286(f($287));
        };
      })(mempty2);
    };
  }
};

// output/Data.List/index.js
var singleton3 = function(a) {
  return new Cons(a, Nil.value);
};
var range2 = function(start) {
  return function(end) {
    if (start === end) {
      return singleton3(start);
    }
    ;
    if (otherwise) {
      var go = function($copy_s) {
        return function($copy_e) {
          return function($copy_step) {
            return function($copy_rest) {
              var $tco_var_s = $copy_s;
              var $tco_var_e = $copy_e;
              var $tco_var_step = $copy_step;
              var $tco_done = false;
              var $tco_result;
              function $tco_loop(s, e, step, rest) {
                if (s === e) {
                  $tco_done = true;
                  return new Cons(s, rest);
                }
                ;
                if (otherwise) {
                  $tco_var_s = s + step | 0;
                  $tco_var_e = e;
                  $tco_var_step = step;
                  $copy_rest = new Cons(s, rest);
                  return;
                }
                ;
                throw new Error("Failed pattern match at Data.List (line 148, column 3 - line 149, column 65): " + [s.constructor.name, e.constructor.name, step.constructor.name, rest.constructor.name]);
              }
              ;
              while (!$tco_done) {
                $tco_result = $tco_loop($tco_var_s, $tco_var_e, $tco_var_step, $copy_rest);
              }
              ;
              return $tco_result;
            };
          };
        };
      };
      return go(end)(start)(function() {
        var $325 = start > end;
        if ($325) {
          return 1;
        }
        ;
        return -1 | 0;
      }())(Nil.value);
    }
    ;
    throw new Error("Failed pattern match at Data.List (line 144, column 1 - line 144, column 32): " + [start.constructor.name, end.constructor.name]);
  };
};

// output/GObject/foreign.js
import GObject from "gi://GObject";
var unsafe_signal_connect_closure = (obj) => (name2) => (cb) => () => GObject.signal_connect_closure(obj, name2, cb, true);

// output/GObject/index.js
var signal_connect_closure = function() {
  return unsafe_signal_connect_closure;
};

// output/Gtk4/foreign.js
import Gtk4 from "gi://Gtk?version=4.0";
var unsafe_show2 = (widget) => () => widget.show();
var unsafe_hide2 = (widget) => () => widget.hide();
var unsafe_set_size_request = (widget) => (height) => (width) => () => widget.set_size_request(height, width);
var unsafe_queue_draw = (widget) => () => widget.queue_draw();

// output/Gtk4/index.js
var show5 = function() {
  return unsafe_show2;
};
var set_size_request = function() {
  return unsafe_set_size_request;
};
var queue_draw = function() {
  return unsafe_queue_draw;
};
var hide3 = function() {
  return unsafe_hide2;
};

// output/Gtk4.Box/foreign.js
import Gtk42 from "gi://Gtk?version=4.0";
var new_10 = (orientation) => (spacing) => () => Gtk42.Box.new(orientation, spacing);
var unsafe_append = (box) => (widget) => () => box.append(widget);

// output/Gtk4.Box/index.js
var $$new10 = new_10;
var append2 = function() {
  return unsafe_append;
};

// output/Gtk4.Button/foreign.js
import Gtk43 from "gi://Gtk?version=4.0";
var new_with_label2 = (txt) => () => Gtk43.Button.new_with_label(txt);

// output/Gtk4.DrawingArea/foreign.js
import Gtk44 from "gi://Gtk?version=4.0";
var new_12 = () => Gtk44.DrawingArea.new();
var set_draw_func = (da) => (cb) => () => da.set_draw_func((_, cr) => cb(cr)());

// output/Gtk4.DrawingArea/index.js
var $$new11 = new_12;

// output/Gtk4.Entry/foreign.js
import Gtk45 from "gi://Gtk?version=4.0";
var new_13 = () => Gtk45.Entry.new();
var get_buffer = (entry) => () => entry.get_buffer();

// output/Gtk4.Entry/index.js
var $$new12 = new_13;

// output/Gtk4.EntryBuffer/foreign.js
var get_text = (eb) => () => eb.get_text();
var set_text2 = (eb) => (txt) => () => eb.set_text(txt, txt.length);

// output/Gtk4.Label/foreign.js
import Gtk46 from "gi://Gtk?version=4.0";
var new_14 = (txt) => () => Gtk46.Label.new(txt);

// output/Gtk4.Label/index.js
var $$new13 = new_14;

// output/Gtk4.Orientation/index.js
var horizontal = 0;

// output/Gtk4.Range/foreign.js
import Gtk47 from "gi://Gtk?version=4.0";
var unsafe_get_value = (r) => () => r.get_value();
var unsafe_set_value = (r) => (v) => () => r.set_value(v);

// output/Gtk4.Range/index.js
var set_value2 = function() {
  return unsafe_set_value;
};
var get_value = function() {
  return unsafe_get_value;
};

// output/Gtk4.Scale/foreign.js
import Gtk48 from "gi://Gtk?version=4.0";
var new_with_range = (orientation) => (min3) => (max4) => (step) => () => Gtk48.Scale.new_with_range(orientation, min3, max4, step);
var set_draw_value = (scale) => (draw_value) => () => scale.set_draw_value(draw_value);

// output/AutoChill.PrefsWidget/index.js
var traverse_2 = /* @__PURE__ */ traverse_(applicativeEffect)(foldableList);
var map3 = /* @__PURE__ */ map(functorList);
var set_size_request2 = /* @__PURE__ */ set_size_request();
var show6 = /* @__PURE__ */ show(showInt);
var signal_connect_closure2 = /* @__PURE__ */ signal_connect_closure();
var map1 = /* @__PURE__ */ map(functorEffect);
var $$void3 = /* @__PURE__ */ $$void(functorEffect);
var append1 = /* @__PURE__ */ append2();
var get_value2 = /* @__PURE__ */ get_value();
var queue_draw2 = /* @__PURE__ */ queue_draw();
var show13 = /* @__PURE__ */ show(showNumber);
var set_value3 = /* @__PURE__ */ set_value2();
var show22 = /* @__PURE__ */ show(/* @__PURE__ */ showMaybe(showInt));
var graphY = 500;
var graphX = 500;
var drawCurve = function(cutoffRef) {
  return function(slopeRef) {
    return function(cr) {
      var segment = function(cutoff) {
        return function(slope) {
          return function(maxX) {
            return function(maxY) {
              return function(x) {
                var xn = x / maxX;
                var yn = chillTemperature(cutoff)(slope)(xn);
                var maxY$prime = maxY - 20 * 2;
                var y$prime = 20 + (1 - yn) * maxY$prime;
                var maxX$prime = maxX - 20 * 2;
                var x$prime = 20 + xn * maxX$prime;
                return lineTo(cr)(x$prime)(y$prime);
              };
            };
          };
        };
      };
      var legendY = function(maxX) {
        return function(maxY) {
          var yAxis = 20 + 5;
          return function __do() {
            moveTo(cr)(yAxis)(yAxis + 6)();
            return showText(cr)("Temperature")();
          };
        };
      };
      var legendX = function(maxX) {
        return function(maxY) {
          var xAxis = maxY - 20 / 2.5;
          return function __do() {
            moveTo(cr)(20 / 2)(xAxis)();
            showText(cr)("Work start")();
            moveTo(cr)(maxX / 2)(xAxis)();
            showText(cr)("->")();
            moveTo(cr)(maxX - 35)(xAxis)();
            return showText(cr)("Break")();
          };
        };
      };
      var legend = function(maxX) {
        return function(maxY) {
          return function __do() {
            legendX(maxX)(maxY)();
            return legendY(maxX)(maxY)();
          };
        };
      };
      var graph = function(x) {
        return function(y) {
          return function __do() {
            var cutoff = read(cutoffRef)();
            var slope = read(slopeRef)();
            moveTo(cr)(20)(20)();
            setSourceRGB(cr)(0)(0)(0)();
            traverse_2(segment(cutoff)(slope)(x)(y))(map3(toNumber)(range2(0)(round2(x))))();
            return stroke(cr)();
          };
        };
      };
      var box = function(maxX) {
        return function(maxY) {
          var maxY$prime = maxY - 20;
          var maxX$prime = maxX - 20;
          return function __do() {
            moveTo(cr)(20)(20)();
            setSourceRGB(cr)(0.8)(0.8)(0.8)();
            lineTo(cr)(maxX$prime)(20)();
            lineTo(cr)(maxX$prime)(maxY$prime)();
            lineTo(cr)(20)(maxY$prime)();
            lineTo(cr)(20)(20)();
            return stroke(cr)();
          };
        };
      };
      return function __do() {
        box(graphX)(graphY)();
        graph(graphX)(graphY)();
        return legend(graphX)(graphY)();
      };
    };
  };
};
var mkPrefWidget = function(settings) {
  var temp = function(labelText) {
    return function(name2) {
      return function __do() {
        var label = $$new13(labelText + ":")();
        set_size_request2(label)(200)(50)();
        var entry = $$new12();
        var eb = get_buffer(entry)();
        var val = get_int(settings)(name2)();
        set_text2(eb)(show6(val))();
        var box = $$new10(0)(5)();
        var tryButton = new_with_label2("Try")();
        signal_connect_closure2(tryButton)("clicked")(function __do2() {
          var vM = map1(fromString)(get_text(eb))();
          if (vM instanceof Just) {
            var colorSettings = $$new3("org.gnome.settings-daemon.plugins.color")();
            var v$prime = new_uint32(vM.value0)();
            return $$void3(set_value(colorSettings)("night-light-temperature")(v$prime))();
          }
          ;
          if (vM instanceof Nothing) {
            return log2("Invalid value")();
          }
          ;
          throw new Error("Failed pattern match at AutoChill.PrefsWidget (line 179, column 13 - line 184, column 49): " + [vM.constructor.name]);
        })();
        append1(box)(label)();
        append1(box)(entry)();
        append1(box)(tryButton)();
        return new Tuple(box, eb);
      };
    };
  };
  var settingRef = function(name2) {
    return function __do() {
      var value = get_double2(settings)(name2)();
      var ref2 = $$new(value)();
      return new Tuple(ref2, value);
    };
  };
  var range3 = function(labelText) {
    return function(min3) {
      return function(max4) {
        return function(step) {
          return function __do() {
            var label = $$new13(labelText + ":")();
            set_size_request2(label)(200)(50)();
            var scale = new_with_range(horizontal)(min3)(max4)(step)();
            set_size_request2(scale)(300)(50)();
            set_draw_value(scale)(true)();
            var box = $$new10(0)(5)();
            append1(box)(label)();
            append1(box)(scale)();
            return new Tuple(box, scale);
          };
        };
      };
    };
  };
  var onDrawingSettingChange = function(ref2) {
    return function(widget) {
      return function(drawing) {
        return function __do() {
          var value = get_value2(widget)();
          write(value)(ref2)();
          return queue_draw2(drawing)();
        };
      };
    };
  };
  var onChange = function(scale) {
    return function __do() {
      log2("onChange called!")();
      var v = map1(toNumber)(get_int(settings)("duration"))();
      log2("to: " + show13(v))();
      set_value3(scale)(v)();
      return queue_draw2(scale)();
    };
  };
  var onApply = function(scale) {
    return function(work) {
      return function(chill) {
        return function(cutoff) {
          return function(slope) {
            return function __do() {
              log2("onApply called")();
              var duration = get_value2(scale)();
              var cutoffV = get_value2(cutoff)();
              var slopeV = get_value2(slope)();
              var workValueM = map1(fromString)(get_text(work))();
              var chillValueM = map1(fromString)(get_text(chill))();
              $$void3(set_int(settings)("duration")(round2(duration)))();
              $$void3(set_double(settings)("cutoff")(cutoffV))();
              $$void3(set_double(settings)("slope")(slopeV))();
              (function() {
                if (workValueM instanceof Just) {
                  return $$void3(set_int(settings)("work-temp")(workValueM.value0))();
                }
                ;
                if (workValueM instanceof Nothing) {
                  return log2("Bad work value")();
                }
                ;
                throw new Error("Failed pattern match at AutoChill.PrefsWidget (line 201, column 5 - line 203, column 42): " + [workValueM.constructor.name]);
              })();
              (function() {
                if (chillValueM instanceof Just) {
                  return $$void3(set_int(settings)("chill-temp")(chillValueM.value0))();
                }
                ;
                if (chillValueM instanceof Nothing) {
                  return log2("Bad chill value")();
                }
                ;
                throw new Error("Failed pattern match at AutoChill.PrefsWidget (line 204, column 5 - line 206, column 43): " + [chillValueM.constructor.name]);
              })();
              return log2("applied " + (show13(duration) + (" " + (show22(workValueM) + (" " + show22(chillValueM))))))();
            };
          };
        };
      };
    };
  };
  return function __do() {
    var v = range3("Work duration (in minutes)")(20)(120)(5)();
    var v1 = temp("Work temperature")("work-temp")();
    var v2 = temp("Chill temperature")("chill-temp")();
    var v3 = range3("Cutoff")(0.1)(0.9)(0.1)();
    var v4 = range3("Slope")(1)(100)(0.1)();
    signal_connect_closure2(settings)("changed::duration")(onChange(v.value1))();
    var val = get_int(settings)("duration")();
    set_value3(v.value1)(toNumber(val))();
    var v5 = settingRef("cutoff")();
    set_value3(v3.value1)(v5.value1)();
    var v6 = settingRef("slope")();
    set_value3(v4.value1)(v6.value1)();
    var drawing = $$new11();
    set_draw_func(drawing)(drawCurve(v5.value0)(v6.value0))();
    set_size_request2(drawing)(round2(graphX))(round2(graphY))();
    signal_connect_closure2(v3.value1)("value-changed")(onDrawingSettingChange(v5.value0)(v3.value1)(drawing))();
    signal_connect_closure2(v4.value1)("value-changed")(onDrawingSettingChange(v6.value0)(v4.value1)(drawing))();
    var apply3 = new_with_label2("Apply")();
    signal_connect_closure2(apply3)("clicked")(onApply(v.value1)(v1.value1)(v2.value1)(v3.value1)(v4.value1))();
    var box = $$new10(1)(5)();
    append1(box)(v.value0)();
    append1(box)(v1.value0)();
    append1(box)(v2.value0)();
    append1(box)(v3.value0)();
    append1(box)(v4.value0)();
    append1(box)(apply3)();
    append1(box)(drawing)();
    return box;
  };
};

// output/ExtensionUtils/foreign.js
import * as ExtensionUtils from "resource:///org/gnome/shell/misc/extensionUtils.js";
var getPath = (ext) => (name2) => () => ext.dir.get_child(name2).get_path();

// output/Gio.SettingsSchemaSource/foreign.js
import Gio6 from "gi://Gio";
var new_from_directory = (path2) => (trusted) => () => Gio6.SettingsSchemaSource.new_from_directory(path2, null, trusted);
var lookup = (s) => (name2) => (recursive) => () => s.lookup(name2, recursive);

// output/AutoChill.Settings/index.js
var getSettingsFromPath = function(path2) {
  return function __do() {
    var schemaSource = new_from_directory(path2)(false)();
    var schema = lookup(schemaSource)("org.gnome.shell.extensions.autochill")(false)();
    return new_full(schema)();
  };
};
var getSettings = function(me) {
  return function __do() {
    var path2 = getPath(me)("schemas")();
    return getSettingsFromPath(path2)();
  };
};
var getColorSettings = /* @__PURE__ */ $$new3("org.gnome.settings-daemon.plugins.color");

// output/Gtk4.Window/foreign.js
import Gtk49 from "gi://Gtk?version=4.0";
var new_15 = () => Gtk49.Window.new();
var unsafe_set_title = (win) => (title) => () => win.set_title(title);
var unsafe_set_decorated = (win) => (b) => () => win.set_decorated(b);
var unsafe_set_child2 = (win) => (child) => () => win.set_child(child);

// output/Gtk4.Window/index.js
var set_title = function() {
  return unsafe_set_title;
};
var set_decorated = function() {
  return unsafe_set_decorated;
};
var set_child3 = function() {
  return unsafe_set_child2;
};
var $$new14 = new_15;

// output/AutoChill.UIGtk4/index.js
var show7 = /* @__PURE__ */ show5();
var hide4 = /* @__PURE__ */ hide3();
var $$void4 = /* @__PURE__ */ $$void(functorEffect);
var set_title2 = /* @__PURE__ */ set_title();
var set_decorated2 = /* @__PURE__ */ set_decorated();
var append3 = /* @__PURE__ */ append2();
var signal_connect_closure3 = /* @__PURE__ */ signal_connect_closure();
var set_child4 = /* @__PURE__ */ set_child3();
var showWidget2 = function(win) {
  return show7(win);
};
var mkWidget2 = function(settings) {
  return function(env) {
    var onSnooze = function(win) {
      return function __do() {
        hide4(win)();
        return $$void4(timeoutAdd(env.snoozeDelay)(function __do2() {
          showWidget2(win)();
          return false;
        }))();
      };
    };
    var onChilled = function(win) {
      return function __do() {
        hide4(win)();
        autoChillWorker(settings)(env)(show7(win))();
        return unit;
      };
    };
    return function __do() {
      var win = $$new14();
      set_title2(win)("AutoChill")();
      set_decorated2(win)(false)();
      var box = $$new10(1)(5)();
      var label = $$new13("Time for a break?")();
      append3(box)(label)();
      var actionBox = $$new10(0)(5)();
      var chillButton = new_with_label2("I feel chilled")();
      var snoozeButton = new_with_label2("Snooze!")();
      $$void4(signal_connect_closure3(chillButton)("clicked")(onChilled(win)))();
      $$void4(signal_connect_closure3(snoozeButton)("clicked")(onSnooze(win)))();
      append3(actionBox)(chillButton)();
      append3(actionBox)(snoozeButton)();
      append3(box)(actionBox)();
      set_child4(win)(box)();
      show7(win)();
      hide4(win)();
      return win;
    };
  };
};

// output/GLib.MainLoop/foreign.js
import GLib4 from "gi://GLib";
var new_16 = () => GLib4.MainLoop.new(null, false);
var run = (loop) => () => loop.run();
var quit = (loop) => () => loop.quit();

// output/Effect.Aff/foreign.js
var Aff = function() {
  var EMPTY = {};
  var PURE = "Pure";
  var THROW = "Throw";
  var CATCH = "Catch";
  var SYNC = "Sync";
  var ASYNC = "Async";
  var BIND = "Bind";
  var BRACKET = "Bracket";
  var FORK = "Fork";
  var SEQ = "Sequential";
  var MAP = "Map";
  var APPLY = "Apply";
  var ALT = "Alt";
  var CONS = "Cons";
  var RESUME = "Resume";
  var RELEASE = "Release";
  var FINALIZER = "Finalizer";
  var FINALIZED = "Finalized";
  var FORKED = "Forked";
  var FIBER = "Fiber";
  var THUNK = "Thunk";
  function Aff2(tag, _1, _2, _3) {
    this.tag = tag;
    this._1 = _1;
    this._2 = _2;
    this._3 = _3;
  }
  function AffCtr(tag) {
    var fn = function(_1, _2, _3) {
      return new Aff2(tag, _1, _2, _3);
    };
    fn.tag = tag;
    return fn;
  }
  function nonCanceler(error2) {
    return new Aff2(PURE, void 0);
  }
  function runEff(eff) {
    try {
      eff();
    } catch (error2) {
      setTimeout(function() {
        throw error2;
      }, 0);
    }
  }
  function runSync(left, right, eff) {
    try {
      return right(eff());
    } catch (error2) {
      return left(error2);
    }
  }
  function runAsync(left, eff, k) {
    try {
      return eff(k)();
    } catch (error2) {
      k(left(error2))();
      return nonCanceler;
    }
  }
  var Scheduler = function() {
    var limit = 1024;
    var size = 0;
    var ix = 0;
    var queue = new Array(limit);
    var draining = false;
    function drain() {
      var thunk;
      draining = true;
      while (size !== 0) {
        size--;
        thunk = queue[ix];
        queue[ix] = void 0;
        ix = (ix + 1) % limit;
        thunk();
      }
      draining = false;
    }
    return {
      isDraining: function() {
        return draining;
      },
      enqueue: function(cb) {
        var i, tmp;
        if (size === limit) {
          tmp = draining;
          drain();
          draining = tmp;
        }
        queue[(ix + size) % limit] = cb;
        size++;
        if (!draining) {
          drain();
        }
      }
    };
  }();
  function Supervisor(util) {
    var fibers = {};
    var fiberId = 0;
    var count = 0;
    return {
      register: function(fiber) {
        var fid = fiberId++;
        fiber.onComplete({
          rethrow: true,
          handler: function(result) {
            return function() {
              count--;
              delete fibers[fid];
            };
          }
        })();
        fibers[fid] = fiber;
        count++;
      },
      isEmpty: function() {
        return count === 0;
      },
      killAll: function(killError, cb) {
        return function() {
          if (count === 0) {
            return cb();
          }
          var killCount = 0;
          var kills = {};
          function kill(fid) {
            kills[fid] = fibers[fid].kill(killError, function(result) {
              return function() {
                delete kills[fid];
                killCount--;
                if (util.isLeft(result) && util.fromLeft(result)) {
                  setTimeout(function() {
                    throw util.fromLeft(result);
                  }, 0);
                }
                if (killCount === 0) {
                  cb();
                }
              };
            })();
          }
          for (var k in fibers) {
            if (fibers.hasOwnProperty(k)) {
              killCount++;
              kill(k);
            }
          }
          fibers = {};
          fiberId = 0;
          count = 0;
          return function(error2) {
            return new Aff2(SYNC, function() {
              for (var k2 in kills) {
                if (kills.hasOwnProperty(k2)) {
                  kills[k2]();
                }
              }
            });
          };
        };
      }
    };
  }
  var SUSPENDED = 0;
  var CONTINUE = 1;
  var STEP_BIND = 2;
  var STEP_RESULT = 3;
  var PENDING = 4;
  var RETURN = 5;
  var COMPLETED = 6;
  function Fiber(util, supervisor, aff) {
    var runTick = 0;
    var status = SUSPENDED;
    var step = aff;
    var fail = null;
    var interrupt = null;
    var bhead = null;
    var btail = null;
    var attempts = null;
    var bracketCount = 0;
    var joinId = 0;
    var joins = null;
    var rethrow = true;
    function run4(localRunTick) {
      var tmp, result, attempt;
      while (true) {
        tmp = null;
        result = null;
        attempt = null;
        switch (status) {
          case STEP_BIND:
            status = CONTINUE;
            try {
              step = bhead(step);
              if (btail === null) {
                bhead = null;
              } else {
                bhead = btail._1;
                btail = btail._2;
              }
            } catch (e) {
              status = RETURN;
              fail = util.left(e);
              step = null;
            }
            break;
          case STEP_RESULT:
            if (util.isLeft(step)) {
              status = RETURN;
              fail = step;
              step = null;
            } else if (bhead === null) {
              status = RETURN;
            } else {
              status = STEP_BIND;
              step = util.fromRight(step);
            }
            break;
          case CONTINUE:
            switch (step.tag) {
              case BIND:
                if (bhead) {
                  btail = new Aff2(CONS, bhead, btail);
                }
                bhead = step._2;
                status = CONTINUE;
                step = step._1;
                break;
              case PURE:
                if (bhead === null) {
                  status = RETURN;
                  step = util.right(step._1);
                } else {
                  status = STEP_BIND;
                  step = step._1;
                }
                break;
              case SYNC:
                status = STEP_RESULT;
                step = runSync(util.left, util.right, step._1);
                break;
              case ASYNC:
                status = PENDING;
                step = runAsync(util.left, step._1, function(result2) {
                  return function() {
                    if (runTick !== localRunTick) {
                      return;
                    }
                    runTick++;
                    Scheduler.enqueue(function() {
                      if (runTick !== localRunTick + 1) {
                        return;
                      }
                      status = STEP_RESULT;
                      step = result2;
                      run4(runTick);
                    });
                  };
                });
                return;
              case THROW:
                status = RETURN;
                fail = util.left(step._1);
                step = null;
                break;
              case CATCH:
                if (bhead === null) {
                  attempts = new Aff2(CONS, step, attempts, interrupt);
                } else {
                  attempts = new Aff2(CONS, step, new Aff2(CONS, new Aff2(RESUME, bhead, btail), attempts, interrupt), interrupt);
                }
                bhead = null;
                btail = null;
                status = CONTINUE;
                step = step._1;
                break;
              case BRACKET:
                bracketCount++;
                if (bhead === null) {
                  attempts = new Aff2(CONS, step, attempts, interrupt);
                } else {
                  attempts = new Aff2(CONS, step, new Aff2(CONS, new Aff2(RESUME, bhead, btail), attempts, interrupt), interrupt);
                }
                bhead = null;
                btail = null;
                status = CONTINUE;
                step = step._1;
                break;
              case FORK:
                status = STEP_RESULT;
                tmp = Fiber(util, supervisor, step._2);
                if (supervisor) {
                  supervisor.register(tmp);
                }
                if (step._1) {
                  tmp.run();
                }
                step = util.right(tmp);
                break;
              case SEQ:
                status = CONTINUE;
                step = sequential2(util, supervisor, step._1);
                break;
            }
            break;
          case RETURN:
            bhead = null;
            btail = null;
            if (attempts === null) {
              status = COMPLETED;
              step = interrupt || fail || step;
            } else {
              tmp = attempts._3;
              attempt = attempts._1;
              attempts = attempts._2;
              switch (attempt.tag) {
                case CATCH:
                  if (interrupt && interrupt !== tmp && bracketCount === 0) {
                    status = RETURN;
                  } else if (fail) {
                    status = CONTINUE;
                    step = attempt._2(util.fromLeft(fail));
                    fail = null;
                  }
                  break;
                case RESUME:
                  if (interrupt && interrupt !== tmp && bracketCount === 0 || fail) {
                    status = RETURN;
                  } else {
                    bhead = attempt._1;
                    btail = attempt._2;
                    status = STEP_BIND;
                    step = util.fromRight(step);
                  }
                  break;
                case BRACKET:
                  bracketCount--;
                  if (fail === null) {
                    result = util.fromRight(step);
                    attempts = new Aff2(CONS, new Aff2(RELEASE, attempt._2, result), attempts, tmp);
                    if (interrupt === tmp || bracketCount > 0) {
                      status = CONTINUE;
                      step = attempt._3(result);
                    }
                  }
                  break;
                case RELEASE:
                  attempts = new Aff2(CONS, new Aff2(FINALIZED, step, fail), attempts, interrupt);
                  status = CONTINUE;
                  if (interrupt && interrupt !== tmp && bracketCount === 0) {
                    step = attempt._1.killed(util.fromLeft(interrupt))(attempt._2);
                  } else if (fail) {
                    step = attempt._1.failed(util.fromLeft(fail))(attempt._2);
                  } else {
                    step = attempt._1.completed(util.fromRight(step))(attempt._2);
                  }
                  fail = null;
                  bracketCount++;
                  break;
                case FINALIZER:
                  bracketCount++;
                  attempts = new Aff2(CONS, new Aff2(FINALIZED, step, fail), attempts, interrupt);
                  status = CONTINUE;
                  step = attempt._1;
                  break;
                case FINALIZED:
                  bracketCount--;
                  status = RETURN;
                  step = attempt._1;
                  fail = attempt._2;
                  break;
              }
            }
            break;
          case COMPLETED:
            for (var k in joins) {
              if (joins.hasOwnProperty(k)) {
                rethrow = rethrow && joins[k].rethrow;
                runEff(joins[k].handler(step));
              }
            }
            joins = null;
            if (interrupt && fail) {
              setTimeout(function() {
                throw util.fromLeft(fail);
              }, 0);
            } else if (util.isLeft(step) && rethrow) {
              setTimeout(function() {
                if (rethrow) {
                  throw util.fromLeft(step);
                }
              }, 0);
            }
            return;
          case SUSPENDED:
            status = CONTINUE;
            break;
          case PENDING:
            return;
        }
      }
    }
    function onComplete(join3) {
      return function() {
        if (status === COMPLETED) {
          rethrow = rethrow && join3.rethrow;
          join3.handler(step)();
          return function() {
          };
        }
        var jid = joinId++;
        joins = joins || {};
        joins[jid] = join3;
        return function() {
          if (joins !== null) {
            delete joins[jid];
          }
        };
      };
    }
    function kill(error2, cb) {
      return function() {
        if (status === COMPLETED) {
          cb(util.right(void 0))();
          return function() {
          };
        }
        var canceler = onComplete({
          rethrow: false,
          handler: function() {
            return cb(util.right(void 0));
          }
        })();
        switch (status) {
          case SUSPENDED:
            interrupt = util.left(error2);
            status = COMPLETED;
            step = interrupt;
            run4(runTick);
            break;
          case PENDING:
            if (interrupt === null) {
              interrupt = util.left(error2);
            }
            if (bracketCount === 0) {
              if (status === PENDING) {
                attempts = new Aff2(CONS, new Aff2(FINALIZER, step(error2)), attempts, interrupt);
              }
              status = RETURN;
              step = null;
              fail = null;
              run4(++runTick);
            }
            break;
          default:
            if (interrupt === null) {
              interrupt = util.left(error2);
            }
            if (bracketCount === 0) {
              status = RETURN;
              step = null;
              fail = null;
            }
        }
        return canceler;
      };
    }
    function join2(cb) {
      return function() {
        var canceler = onComplete({
          rethrow: false,
          handler: cb
        })();
        if (status === SUSPENDED) {
          run4(runTick);
        }
        return canceler;
      };
    }
    return {
      kill,
      join: join2,
      onComplete,
      isSuspended: function() {
        return status === SUSPENDED;
      },
      run: function() {
        if (status === SUSPENDED) {
          if (!Scheduler.isDraining()) {
            Scheduler.enqueue(function() {
              run4(runTick);
            });
          } else {
            run4(runTick);
          }
        }
      }
    };
  }
  function runPar(util, supervisor, par, cb) {
    var fiberId = 0;
    var fibers = {};
    var killId = 0;
    var kills = {};
    var early = new Error("[ParAff] Early exit");
    var interrupt = null;
    var root = EMPTY;
    function kill(error2, par2, cb2) {
      var step = par2;
      var head = null;
      var tail = null;
      var count = 0;
      var kills2 = {};
      var tmp, kid;
      loop:
        while (true) {
          tmp = null;
          switch (step.tag) {
            case FORKED:
              if (step._3 === EMPTY) {
                tmp = fibers[step._1];
                kills2[count++] = tmp.kill(error2, function(result) {
                  return function() {
                    count--;
                    if (count === 0) {
                      cb2(result)();
                    }
                  };
                });
              }
              if (head === null) {
                break loop;
              }
              step = head._2;
              if (tail === null) {
                head = null;
              } else {
                head = tail._1;
                tail = tail._2;
              }
              break;
            case MAP:
              step = step._2;
              break;
            case APPLY:
            case ALT:
              if (head) {
                tail = new Aff2(CONS, head, tail);
              }
              head = step;
              step = step._1;
              break;
          }
        }
      if (count === 0) {
        cb2(util.right(void 0))();
      } else {
        kid = 0;
        tmp = count;
        for (; kid < tmp; kid++) {
          kills2[kid] = kills2[kid]();
        }
      }
      return kills2;
    }
    function join2(result, head, tail) {
      var fail, step, lhs, rhs, tmp, kid;
      if (util.isLeft(result)) {
        fail = result;
        step = null;
      } else {
        step = result;
        fail = null;
      }
      loop:
        while (true) {
          lhs = null;
          rhs = null;
          tmp = null;
          kid = null;
          if (interrupt !== null) {
            return;
          }
          if (head === null) {
            cb(fail || step)();
            return;
          }
          if (head._3 !== EMPTY) {
            return;
          }
          switch (head.tag) {
            case MAP:
              if (fail === null) {
                head._3 = util.right(head._1(util.fromRight(step)));
                step = head._3;
              } else {
                head._3 = fail;
              }
              break;
            case APPLY:
              lhs = head._1._3;
              rhs = head._2._3;
              if (fail) {
                head._3 = fail;
                tmp = true;
                kid = killId++;
                kills[kid] = kill(early, fail === lhs ? head._2 : head._1, function() {
                  return function() {
                    delete kills[kid];
                    if (tmp) {
                      tmp = false;
                    } else if (tail === null) {
                      join2(fail, null, null);
                    } else {
                      join2(fail, tail._1, tail._2);
                    }
                  };
                });
                if (tmp) {
                  tmp = false;
                  return;
                }
              } else if (lhs === EMPTY || rhs === EMPTY) {
                return;
              } else {
                step = util.right(util.fromRight(lhs)(util.fromRight(rhs)));
                head._3 = step;
              }
              break;
            case ALT:
              lhs = head._1._3;
              rhs = head._2._3;
              if (lhs === EMPTY && util.isLeft(rhs) || rhs === EMPTY && util.isLeft(lhs)) {
                return;
              }
              if (lhs !== EMPTY && util.isLeft(lhs) && rhs !== EMPTY && util.isLeft(rhs)) {
                fail = step === lhs ? rhs : lhs;
                step = null;
                head._3 = fail;
              } else {
                head._3 = step;
                tmp = true;
                kid = killId++;
                kills[kid] = kill(early, step === lhs ? head._2 : head._1, function() {
                  return function() {
                    delete kills[kid];
                    if (tmp) {
                      tmp = false;
                    } else if (tail === null) {
                      join2(step, null, null);
                    } else {
                      join2(step, tail._1, tail._2);
                    }
                  };
                });
                if (tmp) {
                  tmp = false;
                  return;
                }
              }
              break;
          }
          if (tail === null) {
            head = null;
          } else {
            head = tail._1;
            tail = tail._2;
          }
        }
    }
    function resolve(fiber) {
      return function(result) {
        return function() {
          delete fibers[fiber._1];
          fiber._3 = result;
          join2(result, fiber._2._1, fiber._2._2);
        };
      };
    }
    function run4() {
      var status = CONTINUE;
      var step = par;
      var head = null;
      var tail = null;
      var tmp, fid;
      loop:
        while (true) {
          tmp = null;
          fid = null;
          switch (status) {
            case CONTINUE:
              switch (step.tag) {
                case MAP:
                  if (head) {
                    tail = new Aff2(CONS, head, tail);
                  }
                  head = new Aff2(MAP, step._1, EMPTY, EMPTY);
                  step = step._2;
                  break;
                case APPLY:
                  if (head) {
                    tail = new Aff2(CONS, head, tail);
                  }
                  head = new Aff2(APPLY, EMPTY, step._2, EMPTY);
                  step = step._1;
                  break;
                case ALT:
                  if (head) {
                    tail = new Aff2(CONS, head, tail);
                  }
                  head = new Aff2(ALT, EMPTY, step._2, EMPTY);
                  step = step._1;
                  break;
                default:
                  fid = fiberId++;
                  status = RETURN;
                  tmp = step;
                  step = new Aff2(FORKED, fid, new Aff2(CONS, head, tail), EMPTY);
                  tmp = Fiber(util, supervisor, tmp);
                  tmp.onComplete({
                    rethrow: false,
                    handler: resolve(step)
                  })();
                  fibers[fid] = tmp;
                  if (supervisor) {
                    supervisor.register(tmp);
                  }
              }
              break;
            case RETURN:
              if (head === null) {
                break loop;
              }
              if (head._1 === EMPTY) {
                head._1 = step;
                status = CONTINUE;
                step = head._2;
                head._2 = EMPTY;
              } else {
                head._2 = step;
                step = head;
                if (tail === null) {
                  head = null;
                } else {
                  head = tail._1;
                  tail = tail._2;
                }
              }
          }
        }
      root = step;
      for (fid = 0; fid < fiberId; fid++) {
        fibers[fid].run();
      }
    }
    function cancel2(error2, cb2) {
      interrupt = util.left(error2);
      var innerKills;
      for (var kid in kills) {
        if (kills.hasOwnProperty(kid)) {
          innerKills = kills[kid];
          for (kid in innerKills) {
            if (innerKills.hasOwnProperty(kid)) {
              innerKills[kid]();
            }
          }
        }
      }
      kills = null;
      var newKills = kill(error2, root, cb2);
      return function(killError) {
        return new Aff2(ASYNC, function(killCb) {
          return function() {
            for (var kid2 in newKills) {
              if (newKills.hasOwnProperty(kid2)) {
                newKills[kid2]();
              }
            }
            return nonCanceler;
          };
        });
      };
    }
    run4();
    return function(killError) {
      return new Aff2(ASYNC, function(killCb) {
        return function() {
          return cancel2(killError, killCb);
        };
      });
    };
  }
  function sequential2(util, supervisor, par) {
    return new Aff2(ASYNC, function(cb) {
      return function() {
        return runPar(util, supervisor, par, cb);
      };
    });
  }
  Aff2.EMPTY = EMPTY;
  Aff2.Pure = AffCtr(PURE);
  Aff2.Throw = AffCtr(THROW);
  Aff2.Catch = AffCtr(CATCH);
  Aff2.Sync = AffCtr(SYNC);
  Aff2.Async = AffCtr(ASYNC);
  Aff2.Bind = AffCtr(BIND);
  Aff2.Bracket = AffCtr(BRACKET);
  Aff2.Fork = AffCtr(FORK);
  Aff2.Seq = AffCtr(SEQ);
  Aff2.ParMap = AffCtr(MAP);
  Aff2.ParApply = AffCtr(APPLY);
  Aff2.ParAlt = AffCtr(ALT);
  Aff2.Fiber = Fiber;
  Aff2.Supervisor = Supervisor;
  Aff2.Scheduler = Scheduler;
  Aff2.nonCanceler = nonCanceler;
  return Aff2;
}();
var _pure = Aff.Pure;
var _throwError = Aff.Throw;
var _liftEffect = Aff.Sync;
var makeAff = Aff.Async;
var _delay = function() {
  function setDelay(n, k) {
    if (n === 0 && typeof setImmediate !== "undefined") {
      return setImmediate(k);
    } else {
      return setTimeout(k, n);
    }
  }
  function clearDelay(n, t) {
    if (n === 0 && typeof clearImmediate !== "undefined") {
      return clearImmediate(t);
    } else {
      return clearTimeout(t);
    }
  }
  return function(right, ms) {
    return Aff.Async(function(cb) {
      return function() {
        var timer = setDelay(ms, cb(right()));
        return function() {
          return Aff.Sync(function() {
            return right(clearDelay(ms, timer));
          });
        };
      };
    });
  };
}();
var _sequential = Aff.Seq;

// output/Gio.Async/foreign.js
import GLib5 from "gi://GLib";

// output/GLib.MainLoop/index.js
var $$new15 = new_16;

// output/Gtk4.Application/foreign.js
import Gtk410 from "gi://Gtk?version=4.0";
import Gio7 from "gi://Gio";
var new_17 = (name2) => () => Gtk410.Application.new(name2, Gio7.ApplicationFlags.FLAGS_NONE);
var run3 = (app) => () => app.run([]);

// output/Gtk4.Application/index.js
var $$new16 = new_17;

// output/AutoChill/index.js
var signal_connect_closure4 = /* @__PURE__ */ signal_connect_closure();
var set_title3 = /* @__PURE__ */ set_title();
var set_child5 = /* @__PURE__ */ set_child3();
var show8 = /* @__PURE__ */ show5();
var log3 = function(msg) {
  return log2("autochill: " + msg);
};
var gtkApp = function(appName) {
  return function(activate) {
    return function __do() {
      var settings = getSettingsFromPath("./autochill@tristancacqueray.github.io/schemas")();
      var colorSettings = getColorSettings();
      var loop = $$new15();
      var app = $$new16(appName)();
      signal_connect_closure4(app)("activate")(activate(loop)({
        settings,
        colorSettings
      }))();
      run3(app)();
      run(loop)();
      return print("Done.")();
    };
  };
};
var mainPrefs = /* @__PURE__ */ function() {
  var activate = function(loop) {
    return function(settings) {
      return function __do() {
        var win = $$new14();
        signal_connect_closure4(win)("close-request")(quit(loop))();
        set_title3(win)("AutoChill Prefs")();
        var prefWidget = mkPrefWidget(settings.settings)();
        set_child5(win)(prefWidget)();
        return show8(win)();
      };
    };
  };
  return gtkApp("autochill.prefs")(activate);
}();
var standalone = function(debug) {
  var activate = function(_loop) {
    return function(settings) {
      return function __do() {
        var env = createEnv(debug)();
        var widget = mkWidget2(settings)(env)();
        if (env.debug) {
          return showWidget2(widget)();
        }
        ;
        return autoChillWorker(settings)(env)(showWidget2(widget))();
      };
    };
  };
  return gtkApp("autochille.standalone")(activate);
};
var main = /* @__PURE__ */ function() {
  var usage = printerr2("autochill - [--run|--prefs|--help]");
  if (argv.length === 0) {
    return log2("loading autochill");
  }
  ;
  if (argv.length === 1 && argv[0] === "--help") {
    return usage;
  }
  ;
  if (argv.length === 1 && argv[0] === "--run") {
    return standalone(false);
  }
  ;
  if (argv.length === 1 && argv[0] === "--run-debug") {
    return standalone(true);
  }
  ;
  if (argv.length === 1 && argv[0] === "--prefs") {
    return mainPrefs;
  }
  ;
  return usage;
}();
var extension = /* @__PURE__ */ function() {
  var extension_init = function(me) {
    return function __do() {
      log3("init called")();
      var settings = getSettings(me)();
      var colorSettings = getColorSettings();
      return {
        settings,
        colorSettings
      };
    };
  };
  var extension_enable = function(settings) {
    return function __do() {
      log3("enable called")();
      var env = createEnv(false)();
      var bin = mkWidget(settings)(env)();
      var button2 = create(bin)(settings)(env)();
      add2(bin)();
      autoChillWorker(settings)(env)(showWidget(bin))();
      notify2("AutoChill engaged")("")();
      return {
        env,
        bin,
        button: button2
      };
    };
  };
  var extension_disable = function(uiEnv) {
    return function __do() {
      log3("disable called")();
      $$delete(uiEnv.button)();
      remove(uiEnv.bin)();
      return stopChillWorker(uiEnv.env)();
    };
  };
  return {
    extension_enable,
    extension_disable,
    extension_init
  };
}();
export {
  extension,
  gtkApp,
  log3 as log,
  main,
  mainPrefs,
  standalone
};

// necessary footer to transform a spago build into a valid gnome extension
let AutoChillEnv = null;
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';
let AutoChillSettings = null;
export default class AutoChill extends Extension {
  constructor(metadata) {
    super(metadata);
    AutoChillSettings = extension.extension_init(metadata)();
  }
  enable() { AutoChillEnv = extension.extension_enable(AutoChillSettings)(); }
  disable() { extension.extension_disable(AutoChillEnv)(); }
}
