pragma solidity ^0.8.18;

interface Types{
    struct TotalWei {
        uint128 borrow;
        uint128 supply;
    }
    
    // Individual token amount for an account
    struct Wei {
        bool sign; // true if positive
        uint256 value;
    }
}