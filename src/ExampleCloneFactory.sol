// SPDX-License-Identifier: BSD
pragma solidity ^0.8.4;

import {ExampleClone} from "./ExampleClone.sol";
import {ClonesWithImmutableArgs} from "./ClonesWithImmutableArgs.sol";

contract ExampleCloneFactory {
    using ClonesWithImmutableArgs for address;

    ExampleClone public implementation;

    constructor(ExampleClone implementation_) {
        implementation = implementation_;
    }

    function createClone(
        address param1,
        uint256 param2,
        uint88 param3,
        bool param4
    )
        external
        returns (ExampleClone clone)
    {
        bytes memory data = abi.encodePacked(param1, param2, param3, param4);
        clone = ExampleClone(address(implementation).clone(data));
    }

    function createDeterministicClone(
        address param1,
        uint256 param2,
        uint88 param3,
        bool param4,
        bytes32 salt
    )
       
        external
       
        returns (ExampleClone clone)
   
    {
        bytes memory data = abi.encodePacked(param1, param2, param3, param4);
        clone =
            ExampleClone(address(implementation).cloneDeterministic(salt, data));
    }

    function predictDeterministicCloneAddress(
        address param1,
        uint256 param2,
        uint88 param3,
        bool param4,
        bytes32 salt
    )
       
        external
       
        view
       
        returns (address, bool)
   
    {
        bytes memory data = abi.encodePacked(param1, param2, param3, param4);
        return address(implementation).predictDeterministicAddress(salt, data);
    }
}