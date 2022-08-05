// SPDX-License-Identifier: MIT
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";
import '@chainlink/contracts/src/v0.8/ChainlinkClient.sol';
import '@chainlink/contracts/src/v0.8/ConfirmedOwner.sol';
pragma solidity ^0.8.7;

error Project_NotEnoughEthEntered();

contract Project is KeeperCompatibleInterface{
    struct Projectstruct {
        address user;
        uint256 id;
        uint timeStamp;
        string projectName;
        string coinMarketCapLink;
    }
    address public owner;
    uint immutable monthValue;
    uint immutable yearValue;
    uint monthCounter=0;
    uint yearCounter=0;
    uint constant monthSeconds=2628288;
    uint constant yearSeconds=31539456;
    uint monthPop=0;
    uint yearPop=0;

    Projectstruct[] monthProjects;
    Projectstruct[] yearProjects;

    constructor(uint mV,uint yV) {
        owner = msg.sender;
        monthValue=mV;
        yearValue=yV;
     }

    event projectAdded (
        address user,
        string projectName,
        string coinMarketCapLink
    );


    function addProject(
        string memory projectName,
        string memory coinMarketCapLink,
        string memory timePeriod
        ) public payable {
            if(timePeriod==month){
                if(msg.value<monthValue)
                    revert Project_NotEnoughEthEntered();
                Projectstruct memory prjt=Projectstruct(msg.sender,monthCounter++,block.timestamp,projectName,coinMarketCapLink);
                monthProjects.push(prjt);
            }
            else{
                if(msg.value<yearValue)
                    revert Project_NotEnoughEthEntered();
                Projectstruct memory prjt=Projectstruct(msg.sender,yearCounter++,block.timestamp,projectName,coinMarketCapLink);
                yearProjects.push(prjt);                
            }
            emit projectAdded(
                msg.sender, 
                projectName, 
                coinMarketCapLink
            );
            payable(owner).transfer(msg.value);
    }

    function checkUpkeep(bytes calldata /* checkData */) external view override returns (bool upkeepNeeded, bytes memory /* performData */) {
        bool monthupkeep=(block.timestamp-monthProjects[monthPop].timeStamp)>monthSeconds;
        bool yearUpkeep=(block.timestamp-yearProjects[yearPop].timeStamp)>yearSeconds;
        upkeepNeeded=monthupkeep||yearUpkeep;
    }

    function performUpkeep(bytes calldata /* performData */) external override {
        if(block.timestamp-monthProjects[monthPop].timeStamp){
            monthPop++;
        }
        else{
            yearPop++;
        }
    }
}