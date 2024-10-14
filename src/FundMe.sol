// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract FundMe {
    address public immutable i_owner;
    uint256 public constant MINIMUM_ETH = 1 ether;

    constructor() {
        i_owner = msg.sender;
    }

    struct InfoPay {
        uint256 amount;
        address sendor;
        uint256 timestamp;
    }

    InfoPay[] public infopay;

    mapping(address => uint256[]) balances;

    // отправлять деньги на смарт контракт
    function fund() public payable {
        require(msg.value >= MINIMUM_ETH, "didnt send enough money");

        InfoPay memory newPay = InfoPay(msg.value, msg.sender, block.timestamp);

        infopay.push(newPay);
        balances[msg.sender].push(msg.value);
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function getFund(address _addr, uint256 _index) public view returns (uint256) {
        return balances[_addr][_index];
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getDataInfopay(uint8 index) public view returns (InfoPay memory) {
        return infopay[index];
    }

    // Вывод денег владельцу контракта
    function withdraw() public {
        // require(msg.sender == i_owner);
        // require(address(this).balance > 0);
        // address payable _to = payable(i_owner);
        // uint256 ball = address(this).balance;
        // // _to.transfer(ball);
        // // bool sent_ = _to.send(ball);
        // (bool sent,) = _to.call{value: ball}("");
        // require(sent, "Failed to send Ether");

        require(msg.sender == i_owner, "Only the owner can withdraw");
        uint256 balance = 1 ether;

        require(balance > 0, "No Ether to withdraw");

        
        (bool sent,) = payable(msg.sender).call{value: balance}(""); // Отправляем весь баланс
        require(sent, "Failed to send Ether");
    }
}
   