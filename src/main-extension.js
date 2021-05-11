// necessary footer to transform a spago build into a valid gnome extension
const env = PS["AutoChill"].create();
function init() { PS["AutoChill"].init(env)(); }
function enable() { PS["AutoChill"].enable(env)(); }
function disable() { PS["AutoChill"].disable(env)(); }
