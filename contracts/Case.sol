pragma solidity ^0.4.17;

contract Case {
    struct CaseStruct {
        address author;
        bytes32 title;
        bytes32 description;
        // this is actually an array of 5 IPFS hashes corresponding to 5 images
        // the reason why it is spread accross 10 elements is because the
        // IPFS hash is too long to fit into one bytes32 and must be split up
        bytes32[10] images;
    }

    // a user can only have one active Case at a time
    // that address is the address of the user
    mapping(address => CaseStruct) public cases;
    CaseStruct[] public caseArray;
    // create a new case for reporters to report on
    function createCase(
        string dataTitle,
        string dataDescription,
        bytes32[10] dataImages
    ) public returns (address, bytes32, bytes32, bytes32[10])
    {
        // title and description are required
        require(bytes(dataTitle).length != 0 && bytes(dataDescription).length != 0);
        cases[msg.sender].author = msg.sender;
        cases[msg.sender].title = stringToBytes32(dataTitle);
        cases[msg.sender].description = stringToBytes32(dataDescription);
        for (uint i = 0; i < 10; i++) {
            cases[msg.sender].images[i] = dataImages[i];
        }
        caseArray.push(cases[msg.sender]);
        return (
            cases[msg.sender].author,
            cases[msg.sender].title,
            cases[msg.sender].description,
            cases[msg.sender].images
        );
    }

    function updateCase(bytes32[10] dataImages) public returns (bool) {
        for (uint i = 0; i < 10; i++) {
            cases[msg.sender].images[i] = dataImages[i];
        }
        return true;
    }

    function numberOfCases() public view returns (uint) {
        return caseArray.length;
    }

    function stringToBytes32(string memory source) private pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {return 0x0;}
        assembly {
            result := mload(add(source, 32))
        }
    }
}