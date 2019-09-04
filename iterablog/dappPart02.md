# TL;DR: Smart Contracts für Eilige (Teil 3) - Unsere Dapp startet eine Transaktion

In [Teil 1](https://www.iteratec.de/tech-blog/artikel/news/tldr-smart-contracts-fuer-eilige-teil-1-1/) haben wir mit möglichst einfachen Mitteln den Smart Contract ["Weisenheimer"](https://github.com/owidder/iteraBlog/blob/master/weisenheimer/contract/Weisenheimer.sol) in [Rinkeby](https://www.rinkeby.io/), einem Ethereum Test Network, [deployt](https://rinkeby.etherscan.io/address/0x245eDE9dac68B84f329e21024E0083ce432700f9#code):

    contract Weisenheimer {

	    event NewHashValue(string, address, uint);

	    function logHashValue(string hashValue) public {    
		    emit NewHashValue(hashValue, msg.sender, block.timestamp);
	    }
    }

So richtig smart ist "Weisenheimer" nicht. Er kann nichts weiter als einen String (`hashValue`) in einem Contract-Event zu speichern. Damit ist dieser String für immer und ewig in die Blockchain eingebrannt.

## Schlaumeier
"Weisenheimer" heißt Weisenheimer, weil er für Schlaumeier gedacht ist: Sobald sie eine schlaue Idee haben, dann schreiben sie sie auf

<!--stackedit_data:
eyJoaXN0b3J5IjpbNTcyMzU1MTg4LDExMTYwOTg2NDcsMjM3MT
M5NzE1LDE0NjE1MTAyMDUsMTMzNjE4ODg4MCwtMzk1NzIzNzgy
XX0=
-->