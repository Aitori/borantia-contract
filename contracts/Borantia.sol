// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Borantia is Initializable, Ownable, Pausable, ERC1155 {
    struct BorantiaInputData {
        string title;
        string organization;
        string description;
        string imageUrl;
        uint256 eventDate;
    }

    struct BorantiaMetadata {
        string title;
        string organization;
        string description;
        string imageUrl;
        uint256 eventDate;
        address creator;
    }

    mapping(uint256 => address[]) public tokenIdToVolunteers;

    mapping(uint256 => BorantiaMetadata) public tokenIdToMetadata;

    uint256 public latestUnusedTokenId;

    constructor() ERC1155("metadata/{id}.json") {
        latestUnusedTokenId = 1;
    }

    function setURI(string memory _uri) public onlyOwner whenNotPaused {
        _setURI(_uri);
    }

    function setLatestUnusedTokenId(uint256 _latestUnusedTokenId)
        public
        onlyOwner
        whenPaused
    {
        latestUnusedTokenId = _latestUnusedTokenId;
    }

    function registerBorantia(
        address creator,
        BorantiaInputData memory metadata
    ) public whenNotPaused {
        _register(creator, metadata);
    }

    function _register(address creator, BorantiaInputData memory metadata)
        internal
    {
        BorantiaMetadata memory pm;
        pm.creator = creator;
        pm.title = metadata.title;
        pm.description = metadata.description;
        pm.imageUrl = metadata.imageUrl;
        pm.eventDate = metadata.eventDate;
        pm.organization = metadata.organization;

        tokenIdToMetadata[latestUnusedTokenId] = pm;
        latestUnusedTokenId++;
    }

    function claimBorantia(uint256 id, address claimee, uint256 h) public whenNotPaused {
        _claim(id, claimee, h);
    }

    function _claim(uint256 id, address dst, uint256 h) internal {
        address[] memory allowlistedAddresses = tokenIdToVolunteers[id];

        bool addressIsAllowlisted = false;
        for (uint256 i = 0; i < allowlistedAddresses.length; i++) {
            if (dst == allowlistedAddresses[i]) {
                addressIsAllowlisted = true;
            }
        }
        require(addressIsAllowlisted, "address isn't allowed");

        require(balanceOf(dst, id) == 0, "address has too many tokens");

        _mint(dst, id, 1, "");
        _mintWorkHours(h, dst);
    }

    function _mintWorkHours(uint256 h, address dst) internal {
        _mint(dst, 0, h, "");
    }

    function addVolunteers(uint256 id, address[] memory addresses)
        public
        whenNotPaused
    {
        tokenIdToVolunteers[id] = addresses;
    }

    function getVolunteerList(uint256 tokenId)
        public
        view
        returns (address[] memory)
    {
        return tokenIdToVolunteers[tokenId];
    }

    function getMetadata(uint256 tokenId)
        public
        view
        returns (BorantiaMetadata memory)
    {
        return tokenIdToMetadata[tokenId];
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function convertStringArraytoByte32(string[] memory inputArray)
        internal
        pure
        returns (bytes32)
    {
        bytes memory packedBytes;
        for (uint256 i = 0; i < inputArray.length; i++) {
            packedBytes = abi.encodePacked(
                packedBytes,
                keccak256(bytes(inputArray[i]))
            );
        }
        return keccak256(packedBytes);
    }

    function compareStringsbyBytes(string memory s1, string memory s2)
        private
        pure
        returns (bool)
    {
        return
            keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2));
    }
}
