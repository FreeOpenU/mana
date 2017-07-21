pragma solidity ^0.4.11;

import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./ContinuousCrowdsale.sol";

contract MANAContinuousCrowdsale is ContinuousCrowdsale, Ownable {

    uint256 public constant INFLATION = 8;

    bool public started = false;

    event RateChange(uint256 amount);

    function MANAContinuousCrowdsale(
        uint256 _rate,
        address _wallet,
        MintableToken _token
    ) ContinuousCrowdsale(_rate, _wallet, _token) {
    }

    modifier whenStarted() {
        require(started);
        _;
    }

    function start() onlyOwner {
        require(!started);

        // initialize issuance
        uint256 finalSupply = token.totalSupply();
        uint256 annualIssuance = finalSupply.mul(INFLATION).div(100);
        issuance = annualIssuance.mul(BUCKET_SIZE).div(1 years);

        started = true;
    }

    function buyTokens(address beneficiary) whenStarted public payable {
        super.buyTokens(beneficiary);
    }

    function setWallet(address _wallet) onlyOwner {
        require(_wallet != 0x0);
        wallet = _wallet;
    }

    function setRate(uint256 _rate) onlyOwner {
        rate = _rate;
        RateChange(_rate);
    }
}
