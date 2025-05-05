pragma solidity ^0.8.18;

import "./Types.sol";

interface IMargin {
    function getMarketInterestSetter(uint256 marketId) external view returns (address);
    function getMarketSupplyInterestRateApr(uint256 marketId) external view returns (uint256); //denomintated 1e18
    function getMarketTotalWei(uint256 marketId) external view returns (Types.TotalWei memory);
    function getMarketEarningsRateOverride(uint256 marketId) external view returns (uint256);
    function getEarningsRate() external view returns (uint256);
}
