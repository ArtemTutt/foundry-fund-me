// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// создаем интеграционный тест
// созданеи сценария на fund and withdraw

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
    uint constant SEND_VALUE = 2 ether;
    function fundFundMe(address mostRecentDeployed) public {
        FundMe(payable(mostRecentDeployed)).fund{value: SEND_VALUE}();
        console.log("Funded FundME with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        vm.startBroadcast();
        fundFundMe(mostRecentDeployed);
        vm.stopBroadcast();
    }


}


contract InteractionsWithdrawFundMe is Script {

}