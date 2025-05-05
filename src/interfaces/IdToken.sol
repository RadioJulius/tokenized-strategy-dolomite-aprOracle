// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.18;

interface IdToken {
    function marketId() external view returns (uint256);
    function asset() external view returns (address);
    function DOLOMITE_MARGIN() external view returns (address);
}
