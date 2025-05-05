// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.8.18;

import {AprOracleBase} from "@periphery/AprOracle/AprOracleBase.sol";
import {IStrategyInterface} from "../interfaces/IStrategyInterface.sol";
import {IInterestRateSetter} from "../interfaces/IInterestRateSetter.sol";
import {IMargin} from "../interfaces/IMargin.sol";
import {IdToken} from "../interfaces/IdToken.sol";
import {Types} from "../interfaces/Types.sol";

contract StrategyAprOracle is AprOracleBase {
    constructor() AprOracleBase("Strategy Apr Oracle Example", msg.sender) {}

    /**
     * @notice Will return the expected Apr of a strategy post a debt change.
     * @dev _delta is a signed integer so that it can also represent a debt
     * decrease.
     *
     * This should return the annual expected return at the current timestamp
     * represented as 1e18.
     *
     *      ie. 10% == 1e17
     *
     * _delta will be == 0 to get the current apr.
     *
     * This will potentially be called during non-view functions so gas
     * efficiency should be taken into account.
     *
     * @param _strategy The token to get the apr for.
     * @param _delta The difference in debt.
     * @return . The expected apr for the strategy represented as 1e18.
     */
    function aprAfterDebtChange(address _strategy, int256 _delta) external view override returns (uint256) {
        address dToken = IStrategyInterface(_strategy).dToken();
        address asset = IdToken(dToken).asset();
        uint256 marketId = IdToken(dToken).marketId();
        address margin = IdToken(dToken).DOLOMITE_MARGIN();

        if (_delta == 0) {
            return (IMargin(margin).getMarketSupplyInterestRateApr(marketId));
        } else {
            address interestRateSetter = IMargin(margin).getMarketInterestSetter(marketId);
            Types.TotalWei memory _wei = IMargin(margin).getMarketTotalWei(marketId);
            uint256 borrowed = uint256(_wei.borrow);
            uint256 supplied = uint256(_wei.supply);
            if (_delta > 0) {
                supplied += uint256(_delta);
            } else {
                supplied -= uint256(_delta * -1);
            }
            
            uint256 interestRate = IInterestRateSetter(interestRateSetter).getInterestRate(asset, borrowed, supplied); // borrow APR Per Second
            interestRate *= 31536000; // seconds in a year
            uint256 earningsRate = IMargin(margin).getMarketEarningsRateOverride(marketId);
            if (earningsRate == 0) {
                earningsRate = IMargin(margin).getEarningsRate();
            }

            interestRate = (interestRate * earningsRate * borrowed) / (supplied * 1e18); //borrowInterest * earningsRate for suppliers * ratio of borrow to supplies
            return interestRate;
        }
    }
}
