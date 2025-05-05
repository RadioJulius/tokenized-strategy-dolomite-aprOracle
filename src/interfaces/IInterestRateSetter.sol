pragma solidity ^0.8.18;

interface IInterestRateSetter {
    function getInterestRate(
        address token,
        uint256 borrowWei,
        uint256 supplyWei
    ) external view returns (uint256);
}