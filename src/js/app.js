$.getJSON('./js/config.json', function(config) {
  console.log(config);
  firebase.initializeApp(config);
  // Initialize Cloud Firestore through Firebase
  var db = firebase.firestore();
});
