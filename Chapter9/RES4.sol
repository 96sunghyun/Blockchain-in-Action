//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "./node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract RES4 is ERC721 {
  struct Asset {
    uint256 assetId;
    uint256 price;
  }

  uint256 public assetsCount;
  mapping(uint256 => Asset) private assetMap;
  address public supervisor;
  mapping(uint256 => address) private assetOwner;
  mapping(address => uint256) private ownedAssetsCount;
  mapping(uint256 => address) public assetApprovals;

  constructor() {
    supervisor = msg.sender;
  }

  // 이미 상속받은 컨트랙트들에 존재하는 이벤트임.
  // 현재 컴파일러 버전에서는 상속받은 것에 대한 중복을 허용하지 않는듯 보인다.
  //   event Transfer(
  //     address indexed from,
  //     address indexed to,
  //     uint256 indexed tokenId
  //   );
  //   event Approval(
  //     address indexed owner,
  //     address indexed approved,
  //     uint256 indexed tokenId
  //   );

  function balanceOf() public view returns (uint256) {
    require(
      msg.sender != address(0),
      "ERC721: balance query for the zero address"
    );

    return ownedAssetsCount[msg.sender];
  }
}
