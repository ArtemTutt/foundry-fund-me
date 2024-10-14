// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Test, console} from "../../lib/forge-std/src/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {FundFundMe} from "../../script/Interactions.s.sol";

contract FundMeTestIntegration is Test {
    FundMe fundme;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 2 ether;

    function setUp() external {
        fundme = new FundMe();
        vm.deal(USER, 5e18); // устанавливаем баланс для пользователя
        vm.deal(fundme.i_owner(), 6e18);
    }

    function testUserCanFund() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundme));

        // address funder = fundme.getFund(USER.address, 0);
    }
}