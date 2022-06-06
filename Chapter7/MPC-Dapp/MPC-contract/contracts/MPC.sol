pragma solidity >=0.4.24 <0.7.0;

contract MPC {
  address payable public sender;
  address payable public recipient;

  constructor(address payable reciever) public payable {
    sender = msg.sender;
    recipient = reciever;
  }

  // 이에 앞서 오프체인에서 쓰레기를 줍고, 그에 대한 microPayment를 여러 개 제공해준 상태이다.
  // 다시말해 claimPayment를 실행하는 사람(참여자)는 이미 주관자의 서명이 된 signedMessage를 가지고있는 상태이다.
  function claimPayment(uint256 amount, bytes memory signedMessage) public {
    require(msg.sender == recipient);
    require(isValidSignature(amount, signedMessage));
    // 컨트랙트 주소에 할당되어있는 deposit value가 요구되는 금액보다 커야한다.
    require(address(this).balance > amount);
    recipient.transfer(amount);
    // 남은 balance를 sender에게 보내고 컨트랙트는 자체폐기한다.
    selfdestruct(sender);
  }

  // 사인된 tx가 유효한지 검사하는 함수
  // 개인키로 서명되어있는 메시지가 인자값으로 전달됨
  function isValidSignature(uint256 amount, bytes memory signedMessage)
    internal
    view
    returns (bool)
  {
    // 1. 여기서 "this"는 컨트랙트 자체를 가리키는데, this의 어떤부분이 hash인자로 들어가는 것인가?
    // (address, abi, byteCode 등 이 컨트랙트를 나타내는 여러 요소 중 어떤것이 들어가는것인지)
    // 또한 그 값을 왜 인자로 같이 넣어서 해싱을 하는 것인가?
    bytes32 message = prefixed(keccak256(abi.encodePacked(this, amount)));
    return recoverSigner(message, signedMessage) == sender;
  }

  function prefixed(bytes32 hash) internal pure returns (bytes32) {
    return keccak256(abi.encodePacked("/x19Ethereum Signed Message:/32", hash));
  }

  // ecrecover == signdeMessage에서 추출한 v, r, s와 해싱된 message를 인자로 받아서 sender의 주소를 추출하는 함수(?)
  function recoverSigner(bytes32 message, bytes memory signedMessage)
    internal
    pure
    returns (address)
  {
    (uint8 v, bytes32 r, bytes32 s) = splitSignature(signedMessage);
    return ecrecover(message, v, r, s);
  }

  function splitSignature(bytes memory signedMessage)
    internal
    pure
    returns (
      uint8 v,
      bytes32 r,
      bytes32 s
    )
  {
    assembly {
      // mload는 주어진 숫자의 위치부터 32byte를 읽어오는 함수
      // add는 주어진 두 값을 더하는 함수
      // 2. add(signedMessage, 32)는 sig값의 길이에 32를 더하고 그 위치에 있는 32byte를 가져오는 것인가?
      // 그렇다면 signedMessage는 숫자인가?
      r := mload(add(signedMessage, 32))
      s := mload(add(signedMessage, 64))
      v := byte(0, mload(add(signedMessage, 96)))
    }
    // 3. 위에서 v는 byte로 변환한 값으로 선언하였는데, 어떻게 return할 때는 uint8 값으로 return될 수 있는지
    return (v, r, s);
  }
}
