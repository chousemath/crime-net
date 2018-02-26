var App = {
  web3Provider: null,
  contracts: {},
  CaseContract: null,
  Case: null,

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
    // Check if there is an injected web3 instance
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
    } else {
      // No injected web3 instance detected...
      // Fall back on Ganache
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);
    return App.initContract();
  },

  initContract: function() {
    $.getJSON('./contracts/Case.json', function(data) {
      // Get contract artifact file
      // Artifacts are information about our contract such as its
      // deployed address and Application Binary Interface (ABI).
      // The ABI is a JavaScript object defining how to interact
      // with the contract including its variables, functions and their parameters
      var CaseArtifact = data;
      CaseContract = web3.eth.contract(data);
      Case = CaseContract.at(0x855d1c79ad3fb086d516554dc7187e3fdfc1c79a);
      console.log(CaseContract);
      // Instantiate contract artifact with truffle-contract
      // This keeps information about the contract in sync with migrations,
      // so you don't need to change the contract's deployed address manually.
      // This creates an instance of our contract we can interact with
      App.contracts.Case = TruffleContract(CaseArtifact);
      // Set the provider for our contract
      App.contracts.Case.setProvider(App.web3Provider);
    });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '#create-case', App.handleCreateCase);
  },

  handleCreateCase: function(event) {
    event.preventDefault();
    var caseInstance;
    web3.eth.createCase(function(error, accounts) {
      if (error) { console.log(error); }
      var account = accounts[0];
      App.contracts.Case.deployed().then(function(instance) {
        caseInstance = instance;
        // Execute adopt as a TRANSACTION by sending account
        var title = 'test title';
        var description = 'test description';
        return caseInstance.createCase(title, description, description, { from: account });
      }).then(function(result) {
        console.log(result);
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }

};

$(function() {

  $(document).ready(function() {
    App.init();
  });
});



