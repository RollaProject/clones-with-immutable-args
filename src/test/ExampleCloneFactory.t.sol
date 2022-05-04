// SPDX-License-Identifier: BSD
pragma solidity ^0.8.4;

/* solhint-disable func-name-mixedcase */

import "forge-std/Test.sol";

import {ExampleClone} from "../ExampleClone.sol";
import {ExampleCloneFactory} from "../ExampleCloneFactory.sol";
import {ClonesWithImmutableArgs} from "../ClonesWithImmutableArgs.sol";

contract ExampleCloneFactoryTest is Test {
    ExampleCloneFactory internal factory;

    function setUp() public {
        ExampleClone implementation = new ExampleClone();
        factory = new ExampleCloneFactory(implementation);
    }

    /// -----------------------------------------------------------------------
    /// Gas benchmarking
    /// -----------------------------------------------------------------------

    function testGas_clone(
        address param1,
        uint256 param2,
        uint88 param3,
        bool param4
    ) public {
        factory.createClone(param1, param2, param3, param4);
    }

    /// -----------------------------------------------------------------------
    /// Correctness tests
    /// -----------------------------------------------------------------------

    function testCan_clone(
        address param1,
        uint256 param2,
        uint88 param3,
        bool param4
    ) public {
        ExampleClone clone = factory.createClone(
            param1,
            param2,
            param3,
            param4
        );
        assertEq(clone.param1(), param1);
        assertEq(clone.param2(), param2);
        assertEq(clone.param3(), param3);
        assertEq(clone.param4(), param4);
    }

    function testCan_deterministicClone(
        address param1,
        uint256 param2,
        uint88 param3,
        bool param4,
        bytes32 salt
    )
        public
    {
        ExampleClone clone =
            factory.createDeterministicClone(param1, param2, param3, param4, salt);
        assertEq(clone.param1(), param1);
        assertEq(clone.param2(), param2);
        assertEq(clone.param3(), param3);
        assertEq(clone.param4(), param4);
    }

    function testCan_predictDeterministicCloneAddress(
        address param1,
        uint256 param2,
        uint88 param3,
        bool param4,
        bytes32 salt
    )
        public
    {
        (address predictedAddress, bool exists) = factory
            .predictDeterministicCloneAddress(
            param1, param2, param3, param4, salt
        );

        assertTrue(!exists);

        ExampleClone clone =
            factory.createDeterministicClone(param1, param2, param3, param4, salt);
        assertEq(address(clone), predictedAddress);

        (predictedAddress, exists) = factory.predictDeterministicCloneAddress(
            param1, param2, param3, param4, salt
        );
        assertEq(address(clone), predictedAddress);
        assertTrue(exists);
    }

    function testCannot_createDeterministicCloneWithSameParamsAndSalt(
        address param1,
        uint256 param2,
        uint88 param3,
        bool param4,
        bytes32 salt
    )
        public
    {
        ExampleClone clone =
            factory.createDeterministicClone(param1, param2, param3, param4, salt);

        vm.expectRevert(ClonesWithImmutableArgs.CreateFail.selector);

        clone =
            factory.createDeterministicClone(param1, param2, param3, param4, salt);
    }

    function testCan_createDeterministicCloneWithSameParamsAndDifferentSalt(
        address param1,
        uint256 param2,
        uint88 param3,
        bool param4,
        bytes32 salt1,
        bytes32 salt2
    )
        public
    {
        vm.assume(salt1 != salt2);

        ExampleClone clone =
            factory.createDeterministicClone(param1, param2, param3, param4, salt1);

        clone =
            factory.createDeterministicClone(param1, param2, param3, param4, salt2);
    }
}
