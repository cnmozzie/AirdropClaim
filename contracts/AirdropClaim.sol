// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Ownable.sol";
import "./IBEP20.sol";


contract AirdropClaim is Ownable {

    mapping (bytes32 => bool) public hashBlacklist;

    address public airdropTokenAddress;

    uint public claimId = 0;
    event Claimed(uint claimId_, address add_, uint amount_);

    constructor(address airdropToken_) {
        require(airdropToken_ != address(0));
        airdropTokenAddress = airdropToken_;
    }

    receive () external payable {}
    fallback () external payable {}

    /*
     * @dev Pull out all balance of token or BNB in this contract. When tokenAddress_ is 0x0, will transfer all BNB to the admin owner.
     */
    function pullFunds(address tokenAddress_) onlyOwner public {
        if (tokenAddress_ == address(0)) {
            _msgSender().transfer(address(this).balance);
        } else {
            IBEP20 token = IBEP20(tokenAddress_);
            token.transfer(_msgSender(), token.balanceOf(address(this)));
        }
    }

    function setAirdropTokenAddress(address airdropToken_) onlyOwner public {
        require(airdropToken_ != address(0));
        airdropTokenAddress = airdropToken_;
    }

    function claim(uint amount, uint expiredAt, uint8 v, bytes32 r, bytes32 s) public returns (bool) {
        require(block.timestamp <= expiredAt, "Claim was expired.");
        require(amount > 0, "You want pull the coins, not put in.");
        require(airdropTokenAddress != address(0), "The token of airdrop is null");

        bytes32 h = keccak256(abi.encodePacked(amount, msg.sender, expiredAt));
        bool isClaimed = hashBlacklist[h];
        require(isClaimed == false, "You had claimed out.");

        bytes32 prefixedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", h));
        address addr = ecrecover(prefixedHash, v, r, s);
        require(addr == owner(), "Your message is not signed by admin.");

        IBEP20 token = IBEP20(airdropTokenAddress);
        require(token.transfer(msg.sender, amount), "Token transfer failed");

        hashBlacklist[h] = true;
        emit Claimed(claimId++, msg.sender, amount);

        return true;
    }
}
