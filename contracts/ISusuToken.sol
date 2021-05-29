// SPDX-License-Identifier: GPL-3.0-or-later

/*
Carbonswap
Copyright (C) 2021 Carbonswap

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.6;

pragma experimental ABIEncoderV2;

import "./openzeppelin/AccessControl.sol";

abstract contract SusuToken is AccessControl {
    bytes32 public constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    /// @dev EIP-20 token name for this token
    string public constant name = "Susu Token";

    /// @dev EIP-20 token symbol for this token
    string public constant symbol = "SUSU";

    /// @dev EIP-20 token decimals for this token
    uint8 public constant decimals = 18;

    /// @dev maximum hard cap, cannot mint more
    uint256 public constant cap = 300000000 ether;

    /// @dev Total number of tokens in circulation
    uint256 public totalSupply;

    /// @dev Allowance amounts on behalf of others
    mapping(address => mapping(address => uint96)) internal allowances;

    /// @dev Official record of token balances for each account
    mapping(address => uint96) internal balances;

    /// @dev A record of states for signing / validating signatures
    mapping(address => uint256) public nonces;

    /// @dev The standard EIP-20 transfer event
    event Transfer(address indexed from, address indexed to, uint256 amount);

    /// @dev The standard EIP-20 approval event
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    /**
     * @dev Get the number of tokens `spender` is approved to spend on behalf of `account`
     * @param account The address of the account holding the funds
     * @param spender The address of the account spending the funds
     * @return The number of tokens approved
     */
    function allowance(address account, address spender)
        external
        view
        virtual
        returns (uint256);

    /**
     * @dev Approve `spender` to transfer up to `amount` from `src`
     * @dev This will overwrite the approval amount for `spender`
     *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
     * @param spender The address of the account which may transfer tokens
     * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
     * @return Whether or not the approval succeeded
     */
    function approve(address spender, uint256 rawAmount)
        external
        virtual
        returns (bool);

    /**
     * @dev Get the number of tokens held by the `account`
     * @param account The address of the account to get the balance of
     * @return The number of tokens held
     */
    function balanceOf(address account) external view virtual returns (uint256);

    /**
     * @dev Transfer `amount` tokens from `_msgSender()` to `dst`
     * @param dst The address of the destination account
     * @param rawAmount The number of tokens to transfer
     * @return Whether or not the transfer succeeded
     */
    function transfer(address dst, uint256 rawAmount)
        external
        virtual
        returns (bool);

    /**
     * @dev Transfer `amount` tokens from `src` to `dst`
     * @param src The address of the source account
     * @param dst The address of the destination account
     * @param rawAmount The number of tokens to transfer
     * @return Whether or not the transfer succeeded
     */
    function transferFrom(
        address src,
        address dst,
        uint256 rawAmount
    ) external virtual returns (bool);

    /**
     * @dev Triggers an approval from owner to spends
     * @param owner The address to approve from
     * @param spender The address to be approved
     * @param rawAmount The number of tokens that are approved (2^256-1 means infinite)
     * @param deadline The time at which to expire the signature
     * @param v The recovery byte of the signature
     * @param r Half of the ECDSA signature pair
     * @param s Half of the ECDSA signature pair
     */
    function permit(
        address owner,
        address spender,
        uint256 rawAmount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external virtual;

    function mint(address account, uint256 rawAmount) external virtual;

    function burn(uint256 rawAmount) external virtual returns (bool);

    function burnFrom(address src, uint256 rawAmount)
        external
        virtual
        returns (bool);
}
