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

import "./openzeppelin/Ownable.sol";

abstract contract MasterChef is Ownable {
    // Info of each user
    struct UserInfo {
        uint256 amount;
        int256 rewardDebt;
    }

    // Info of each pool.
    struct PoolInfo {
        address lpToken;
        address rewarder;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accRewardPerShare;
    }

    address public susu;

    // Dev address.
    address public devaddr;
    // vesting address
    address public vestingContract;
    // The block number when SUSU mining starts
    uint256 public startBlock;
    // Block number when early SUSU period ends
    uint256 public earlyEndBlock;
    // Tokens for early susu makers
    uint256 public rewardEarlyPerBlock;
    // SUSU tokens per block.
    uint256 public rewardPerBlock;
    // Inflation in perpetuity
    uint256 public rewardLatePerBlock;
    // Supply to reach for SUSU distribution
    uint256 public targetSupply;
    // Block number when normal SUSU distribution period ended
    uint256 public targetReachedAtBlock;
    // Counter to keep track of mints
    uint256 public targetCounter;
    // Total allocation poitns. Must be the sum of all allocation points in all pools.
    uint256 public totalAllocPoint;

    // Info of each pool.
    PoolInfo[] public poolInfo;

    // indicator if a pool is added or not
    mapping(address => bool) public added;
    // Info of each user that stakes LP tokens.
    mapping(uint256 => mapping(address => UserInfo)) public userInfo;

    event Deposit(
        address indexed user,
        uint256 indexed pid,
        uint256 amount,
        address indexed to
    );
    event Withdraw(
        address indexed user,
        uint256 indexed pid,
        uint256 amount,
        address indexed to
    );
    event EmergencyWithdraw(
        address indexed user,
        uint256 indexed pid,
        uint256 amount,
        address indexed to
    );
    event Harvest(
        address indexed user,
        uint256 indexed pid,
        uint256 amount,
        address indexed to
    );
    event PoolAddition(
        uint256 indexed pid,
        uint256 allocPoint,
        address indexed lpToken,
        address indexed rewarder
    );
    event PoolChange(
        uint256 indexed pid,
        uint256 allocPoint,
        address indexed rewarder,
        bool overwrite
    );
    event PoolUpdate(
        uint256 indexed pid,
        uint256 lastRewardBlock,
        uint256 lpSupply,
        uint256 accRewardPerShare
    );

    function poolLength() external view virtual returns (uint256);

    // Return reward multiplier over the given _from to _to block.
    function getRewardForPeriod(uint256 _fromBlock, uint256 _toBlock)
        public
        view
        virtual
        returns (uint256);

    // View function to see pending SUSUs
    function pendingRewards(uint256 pid, address _user)
        external
        view
        virtual
        returns (uint256);

    // Update reward vairables for all pools. Be careful of gas spending!
    function massUpdateAllPools() external virtual;

    /// @notice Update reward variables for all pools. Be careful of gas spending!
    /// @param pids Pool IDs of all to be updated. Make sure to update all active pools.
    function massUpdatePools(uint256[] calldata pids) external virtual;

    // Update reward variables of the given pool to be up-to-date.
    function updatePool(uint256 pid) public virtual;

    // Deposit LP tokens to MasterChef for SUSU allocation.
    function deposit(
        uint256 pid,
        uint256 amount,
        address to
    ) external virtual;

    // Withdraw LP tokens from MasterChef.
    function withdraw(
        uint256 pid,
        uint256 amount,
        address to
    ) external virtual;

    /// @notice Harvest proceeds for transaction sender to `to`.
    /// @param pid The index of the pool. See `poolInfo`.
    /// @param to Receiver of SUSHI rewards.
    /// @return success Returns bool indicating success of rewarder delegate call.
    function harvest(uint256 pid, address to) external virtual returns (bool);

    /// @dev safety checks need to be made by the vesting contract which calls
    /// this function
    function harvestWithVesting(uint256 pid, address from)
        external
        virtual
        returns (bool);

    // Withdraw without caring about rewards. EMERGENCY ONLY.
    function emergencyWithdraw(uint256 pid, address to) external virtual;
}
