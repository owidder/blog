# TL;DR: Smart Contracts für Eilige (Teil 3) - Unsere Dapp startet eine Transaktion

In [Teil 1](https://www.iteratec.de/tech-blog/artikel/news/tldr-smart-contracts-fuer-eilige-teil-1-1/) haben wir mit möglichst einfachen Mitteln den Smart Contract ["Weisenheimer"](https://github.com/owidder/iteraBlog/blob/master/weisenheimer/contract/Weisenheimer.sol) in [Rinkeby](https://www.rinkeby.io/), einem Ethereum Test Network, [deployt](https://rinkeby.etherscan.io/address/0x245eDE9dac68B84f329e21024E0083ce432700f9#code):

    contract Weisenheimer {

	    event NewHashValue(string, address, uint);

	    function logHashValue(string hashValue) public {    
		    emit NewHashValue(hashValue, msg.sender, block.timestamp);
	    }
    }

So richtig smart ist "Weisenheimer" nicht. Er kann nichts weiter als einen String (`hashValue`) in einem Contract-Event zu speichern. Damit ist dieser String für immer und ewig in die Blockchain eingebrannt.

## Was für Schlaumeier
Weisenheimer heißt "Weisenheimer", weil er für [Schlaumeier](https://dict.leo.org/german-english/weisenheimer) gedacht ist: Wer eine schlaue Idee hat, schreibt sie auf, hasht sie und speichert den Hash-Wert über den Weisenheimer-Contract in der Blockchain. Dann kann man auch in vielen Jahren noch beweisen, dass man das heute schon wusste.

## Lesen des Contracts
In [Teil 2](https://www.iteratec.de/tech-blog/artikel/tldr-smart-contracts-fuer-eilige-teil-2-blockchain-tutorial-1/) haben wir eine kleine Web-Site erstellt, die mit ein klein wenig JavaScript-Code alle Event aus dem Contract ausliest und die darin enthaltenen Hash-Werte zusammen mit Nummer und Timestamp des Blockes der Blockchain, in dem sich der Event befindet, anzeigt.

<!--stackedit_data:
eyJoaXN0b3J5IjpbNzY1MTUyMDczLC01MTEwNTc1ODQsLTEzMz
A0NzcwOTIsMTExNjA5ODY0NywyMzcxMzk3MTUsMTQ2MTUxMDIw
NSwxMzM2MTg4ODgwLC0zOTU3MjM3ODJdfQ==
-->