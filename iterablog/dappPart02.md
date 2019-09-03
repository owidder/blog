# TL;DR: Smart Contracts für Eilige (Teil 3) - Unsere Dapp startet eine Transaktion

In [Teil 1](https://www.iteratec.de/tech-blog/artikel/news/tldr-smart-contracts-fuer-eilige-teil-1-1/) haben wir mit möglichst einfachen Mitteln den Smart Contract ["Weisenheimer"](https://github.com/owidder/iteraBlog/blob/master/weisenheimer/contract/Weisenheimer.sol) in Rinkeby, einem Ethereum Test Network, deployt:

    pragma solidity ^0.4.19;
    contract Weisenheimer {

	    event NewHashValue(string, address, uint);

	    function logHashValue(string hashValue) public {    
		    emit NewHashValue(hashValue, msg.sender, block.timestamp);
	    }
    }

<!--stackedit_data:
eyJoaXN0b3J5IjpbMTQyOTU1NjI1NSwxNDYxNTEwMjA1LDEzMz
YxODg4ODAsLTM5NTcyMzc4Ml19
-->