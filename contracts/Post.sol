// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract posts {

    address public owner;
    uint256 private counter;

    constructor() {
        counter = 0;
        owner = msg.sender;
     }

    struct post {
        address poster;
        uint256 id;
        string postTxt;
        string postImg;
        address[] Vote;
    }

    event postCreated (
        address poster,
        uint256 id,
        string postTxt,
        string postImg
    );

    mapping(uint256 => post) posts;

    function addpost(
        string memory postTxt,
        string memory postImg
        ) public payable {
            require(msg.value == (1 ether), "Please submit 1 Matic");
            post storage newpost = posts[counter];
            newpost.postTxt = postTxt;
            newpost.postImg = postImg;
            newpost.poster = msg.sender;
            newpost.id = counter;
            emit postCreated(
                msg.sender, 
                counter, 
                postTxt, 
                postImg
            );
            counter++;

            payable(owner).transfer(msg.value);
    }

    function getpost(uint256 id) public view returns (string memory, string memory, address){
        require(id < counter, "No such post");

        post storage t = posts[id];
        return (t.postTxt, t.postImg, t.poster);
    }
}