// SPDX-License-Identifier: BSD
pragma solidity ^0.8.4;

import {Clone} from "./Clone.sol";

contract ExampleClone is Clone {
    function param1() public pure returns (address) {
        return _getArgAddress(0);
    }

    function param2() public pure returns (uint256) {
        return _getArgUint256(20);
    }

    function param3() public pure returns (uint88) {
        return _getArgUint88(52);
    }

    function param4() public pure returns (bool) {
        return _getArgBool(63);
    }
}
