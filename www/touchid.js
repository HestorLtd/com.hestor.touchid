
var exec = require("cordova/exec");

var TouchID = function () {
    this.name = "TouchID";
};

TouchID.prototype.authenticate = function (successCallback, errorCallback, text, password) {
    if (!text) {
        text = "Please authenticate via TouchID to proceed";
    }
	if (!password) {
		password = "";
	}
    exec(successCallback, errorCallback, "TouchID", "authenticate", [text,password]);
};

TouchID.prototype.checkSupport = function (successCallback, errorCallback) {
    exec(successCallback, errorCallback, "TouchID", "checkSupport");
};

module.exports = new TouchID();
