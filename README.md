## Touch ID Plugin for Apache Cordova / Adobe Phonegap

Cordova Plugin to leverage the iOS local authentication framework to allow in-app user authentication using Touch ID.

**Important:** You must target a real device when building. If you target the simulator, the build will fail.

## 1 step install

#### Latest version from GitHub

```
cordova plugin add https://github.com/HestorLtd/com.hestor.touchid.git
or
phonegap plugin add https://github.com/HestorLtd/com.hestor.touchid.git
```

## Usage

You **do not** need to reference any JavaScript, the Cordova plugin architecture will add a touchid object to your root automatically when you build.

Ensure you use the plugin after your deviceready event has been fired.

### Authenticate

Pass the following arguments to the `authenticate()` function, to prompt the user to authenticate via TouchID:

1. Success callback (called on successful authentication)
2. Failure callback (called on error or if authentication fails)
3. Localised text explaining why the app needs authentication*
4. Password to use for Enter Password Prompt (you may use NULL or ' ' to ignore the password prompt

```
touchid.authenticate(successCallback, failureCallback, text, password);

touchid.authenticate(
	function(a){
		alert('success: '+a);
	},
	function(b){
		alert('no success: '+b);
	},
	'Authentication Required',
	'password123'
);
```

*NOTE: The localised text you present to the user should provide a clear reason for why you are requesting they authenticate themselves, and what action you will be taking based on that authentication.

### Check support

Although the `authenticate()` function will return an error if the user is unable to authenticate via Touch ID, you may wish to check support without prompting the user to authenticate. This can be done by passing following arguments to the `checkSupport()` function:

1. Success callback (called if authentication is possible)
2. Not supported callback (called if policy can not be evaluated, with error message)

```
touchid.checkSupport(successCallback, notSupportedCallback);

touchid.checkSupport(
	function(a){
		alert('supported: '+a);
	},
	function(b){
		alert('not supported: '+b);
	}
);
```

## Platforms

iOS 8+

## License

[MIT License](http://mit-license.org)
