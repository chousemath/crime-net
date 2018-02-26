requirejs(["js/config"], function(config) {
  console.log(config.firebase);
  firebase.initializeApp(config.firebase);
});