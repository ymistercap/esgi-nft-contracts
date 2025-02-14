// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ESGINFT} from "../src/ESGINFT.sol";

contract DeployESGINFT is Script {
    function run() external returns (ESGINFT){
        vm.startBroadcast();
        ESGINFT nftContract = new ESGINFT();
        vm.stopBroadcast();
        return nftContract;
    }
}
