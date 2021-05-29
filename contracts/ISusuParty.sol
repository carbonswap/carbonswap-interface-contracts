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

import "./openzeppelin/ERC20.sol";
import "./openzeppelin/AccessControl.sol";

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

abstract contract SusuParty is ERC20("Susu Party", "xSUSU"), AccessControl {
    bytes32 public constant GOVERNANCE_ROLE = keccak256("GOVERNANCE_ROLE");
    bytes32 public constant QUEUE_ROLE = keccak256("QUEUE_ROLE");

    IERC20 public susu;

    uint256 public queueOn;

    event Joined(address from, address beneficiary, uint256 amount);
    event Left(address from, address beneficiary, uint256 amount);

    /// @dev if queue is on only QUEUE_ROLE addresses can deposit
    function setQueuing(bool _on) external virtual;

    // Enter the bar. Pay some Susus. Earn some shares.
    // Locks susu and mints xSUSU
    function enter(uint256 _amount, address _beneficiary) public virtual;

    // Leave the party. Claim back your Susus.
    // Unlocks the staked + gained susu and burns xSUSU
    function leave(uint256 _share, address _beneficiary) public virtual;

    // Returns your SUSU share based on the xSUSU amount
    function checkShare(uint256 _share)
        public
        view
        virtual
        returns (uint256 amount);
}
