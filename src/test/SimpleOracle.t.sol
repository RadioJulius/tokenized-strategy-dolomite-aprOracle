pragma solidity ^0.8.18;

import "forge-std/console2.sol";
import {Setup} from "./utils/Setup.sol";
import {Test} from "forge-std/Test.sol";

import {StrategyAprOracle} from "../periphery/StrategyAprOracle.sol";
import {DummyStrategy} from "../DummyStrategy.sol";

contract SimpleOracleTest is Test {
    StrategyAprOracle public oracle;
    DummyStrategy public strategy;
    address public asset = 0x6969696969696969696969696969696969696969;
    address public dToken = 0xAa97D791Afc02AF30cf0B046172bb05b3c306517;

    function setUp() public {
        strategy = new DummyStrategy(asset, dToken, "wBera");
        oracle = new StrategyAprOracle();
    }

    function testSimpleOracleCheck(uint256 _delta) public {
        // Check set up
        // TODO: Add checks for the setup

        uint256 currentApr = oracle.aprAfterDebtChange(address(strategy), 0);

        // Should be greater than 0 but likely less than 100%
        assertGt(currentApr, 0, "ZERO");
        assertLt(currentApr, 1e18, "+100%");

        console2.log("currentAPR: ", currentApr);
    }

    function testSimpleOracleCheckWithDeltaPositive(int256 _delta) public {
        _delta = bound(_delta, 1e21, 1e24);
        uint256 currentApr = oracle.aprAfterDebtChange(address(strategy), 0);

        console2.log("currentAPR With No Delta: ", currentApr);

        uint256 newApr = oracle.aprAfterDebtChange(address(strategy), _delta);

        console2.log("newAPR: ", newApr);
        console2.log("delta value: ", _delta);

        assertLt(newApr, currentApr);

    }

    function testSimpleOracleCheckWithDeltaNegative(int256 _delta) public {
        _delta = bound(_delta, -1e24, -1e21);
        uint256 currentApr = oracle.aprAfterDebtChange(address(strategy), 0);

        console2.log("currentAPR With No Delta: ", currentApr);

        uint256 newApr = oracle.aprAfterDebtChange(address(strategy), _delta);

        console2.log("newAPR: ", newApr);
        console2.log("delta value: ", _delta);

        assertGt(newApr, currentApr);

    }
}
