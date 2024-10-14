// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test, console} from "../../lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundme;

    address USER = makeAddr("user");

    function setUp() external {
        fundme = new FundMe();
        vm.deal(USER, 5e18); // устанавливаем баланс для пользователя
        vm.deal(fundme.i_owner(), 6e18);
    }

    function testMinimumEth() public view {
        assertEq(fundme.MINIMUM_ETH(), 1 ether);
        console.log(fundme.MINIMUM_ETH());
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundme.i_owner(), address(this));
        console.log("This is owner", fundme.i_owner());
        console.log("This is msg.sender", address(this));
    }

    function testFundFailWithoutEnoughEth() public {
        vm.expectRevert(); // ожидаем ошибку, транзакция должна быть откачена

        // uint256 amount = 1 ether;
        fundme.fund();
    }

    function testFundSuccessTransaction() public {
        uint256 amount = 2 ether;

        fundme.fund{value: amount}();
    }

    function testGetBalanceContract() public {
        uint256 amount = 2 ether;
        fundme.fund{value: amount}();

        assertEq(fundme.getBalance(), 2e18);

        // vm.prank(USER); // the next tx will be sent by my user
    }

    function testFundSuccessFromAnotherUserTransaction() public {
        vm.prank(USER);
        uint256 amount = 2 ether;

        fundme.fund{value: amount}();

        assertEq(fundme.getFund(USER, 0), 2e18);
    }

    function testGetInfoInfomay() public {
        vm.prank(USER);
        uint256 amount = 2 ether;

        fundme.fund{value: amount}();

        fundme.getDataInfopay(0);
    }

    modifier funded() {
        vm.prank(USER);
        fundme.fund{value: 2e18}();
        _;
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(USER);
        fundme.withdraw();
    }

    // мы можем использовать vm.txGasPrice(newGasPrice);  Мы можем использовать это для получения точной информации
    // об использовании газа для транзакции.

    function testWithdrawOwnerContract() public funded{
        // vm.startPrank(USER);
        // fundme.fund{value: 2e18}();
        // vm.stopPrank();

        // // Arrange
        // uint256 startingOwnerBalance = fundme.i_owner().balance;
        // uint256 startingFundMeBalance = address(fundme).balance;

        // console.log(startingOwnerBalance);
        // console.log(startingFundMeBalance);

        // // Act
        // vm.startPrank(address(this));
        // fundme.withdraw();
        // vm.stopPrank();

        // // // Assert
        // uint256 endingOwnerBalance = fundme.i_owner().balance;
        // uint256 endingFundMeBalance = address(fundme).balance;

        // assertEq(endingFundMeBalance, 0);
        // assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);
        // vm.startPrank(USER);
        // fundme.fund{value: 20e18}(); // Отправка 20 ETH
        // vm.stopPrank();

        // Arrange
        uint256 startingOwnerBalance = fundme.i_owner().balance;
        uint256 startingFundMeBalance = address(fundme).balance;

        console.log(fundme.i_owner());
        console.log(startingFundMeBalance);

        // Убедитесь, что мы вызываем withdraw() от владельца
        vm.startPrank(fundme.i_owner());
        fundme.withdraw();
        vm.stopPrank();

        // Assert
        uint256 endingOwnerBalance = fundme.i_owner().balance;
        uint256 endingFundMeBalance = address(fundme).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);
    }
}
