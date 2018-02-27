pragma solidity ^0.4.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Case.sol";

contract TestCase {
    Case c = Case(DeployedAddresses.Case());

    function testUserCanCreateCase() public {
        string memory title = "Test Case";
        string memory description = "Test Description";
        address returnedAddress;
        bytes32 returnedTitle;
        bytes32 returnedDescription;
        (returnedAddress, returnedTitle, returnedDescription) = c.createCase(title, description);
        Assert.equal(returnedAddress, this, "Creator's address should be recorded");
        Assert.equal(bytes32ToString(returnedTitle), title, "Title should be recorded");
        Assert.equal(bytes32ToString(returnedDescription), description, "Description should be recorded");
        Assert.equal(c.numberOfCases(), 1, "Number of cases should be incremented by 1");
    }

    function testUserCanUpdateCase() public {
        bytes32[10] memory imageArray = [
            stringToBytes32("https://pbs.twimg.com/profile_images/926010203723534337/31F_Bkyq_400x400.jpg"),
            stringToBytes32("https://pbs.twimg.com/profile_images/926010203723534337/31F_Bkyq_400x400.jpg"),
            stringToBytes32("https://pbs.twimg.com/profile_images/926010203723534337/31F_Bkyq_400x400.jpg"),
            stringToBytes32("https://pbs.twimg.com/profile_images/926010203723534337/31F_Bkyq_400x400.jpg"),
            stringToBytes32("https://pbs.twimg.com/profile_images/926010203723534337/31F_Bkyq_400x400.jpg"),
            stringToBytes32("https://pbs.twimg.com/profile_images/926010203723534337/31F_Bkyq_400x400.jpg"),
            stringToBytes32("https://pbs.twimg.com/profile_images/926010203723534337/31F_Bkyq_400x400.jpg"),
            stringToBytes32("https://pbs.twimg.com/profile_images/926010203723534337/31F_Bkyq_400x400.jpg"),
            stringToBytes32("https://pbs.twimg.com/profile_images/926010203723534337/31F_Bkyq_400x400.jpg"),
            stringToBytes32("https://pbs.twimg.com/profile_images/926010203723534337/31F_Bkyq_400x400.jpg")
        ];
        Assert.equal(c.updateCase(imageArray), true, "Successfully updating a case should return true");
    }

    function stringToBytes32(string memory source) private pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {return 0x0;}
        assembly {
            result := mload(add(source, 32))
        }
    }

    function bytes32ToString(bytes32 x) public pure returns (string) {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }
}