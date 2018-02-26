App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    $.getJSON('./js/config.json', function(config) {
      console.log(config);
      firebase.initializeApp(config);
      // Initialize Cloud Firestore through Firebase
      var db = firebase.firestore();
    });

    return App.initWeb3();
  },

  initWeb3: function() {
    // Is there an injected web3 instance?
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      // If no injected web3 instance is detected, fall back to Ganache
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('Case.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var CaseArtifact = data;
      App.contracts.Case = TruffleContract(CaseArtifact);
    
      // Set the provider for our contract
      App.contracts.Case.setProvider(App.web3Provider);
      console.log('app', App.contracts.Case);
      App.test();
    });
    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-adopt', App.handleAdopt);
  },

  test: function(adopters, account) {
    var caseInstance;

    App.contracts.Case.deployed().then(function(instance) {
      caseInstance = instance;
      console.log('number:', caseInstance.numberOfCases().then(function(x) {
        console.log('x', x);
      }));
    })
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
