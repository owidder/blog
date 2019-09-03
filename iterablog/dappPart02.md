# TL;DR: Smart Contracts für Eilige (Teil 3) - Unsere Dapp startet eine Transaktion

In [Teil 1](https://www.iteratec.de/tech-blog/artikel/news/tldr-smart-contracts-fuer-eilige-teil-1-1/) haben wir mit möglichst einfachen Mitteln den Smart Contract ["Weisenheimer"](https://github.com/owidder/iteraBlog/blob/master/weisenheimer/contract/Weisenheimer.sol) in [Rinkeby](https://www.rinkeby.io/), einem Ethereum Test Network, deployt:

    contract Weisenheimer {

	    event NewHashValue(string, address, uint);

	    function logHashValue(string hashValue) public {    
		    emit NewHashValue(hashValue, msg.sender, block.timestamp);
	    }
    }

"Weisenheimer" kann nichts weiter, als einen String (`hashValue`) in einem Contract-Event zu speichern. Aber damit ist dieser String für immer und ewig in die Blockchain eingebrannt.

## Schlaumeier
"Weisenheimer" heißt Weisenheimer (Schlaumeier), weil 
<!--stackedit_data:
eyJoaXN0b3J5IjpbODM2NzQwNTczLDE0NjE1MTAyMDUsMTMzNj
E4ODg4MCwtMzk1NzIzNzgyXX0=
-->