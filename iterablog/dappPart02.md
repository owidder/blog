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
Weisenheimer heißt "Weisenheimer", weil er für [Schlaumeier](https://dict.leo.org/german-english/weisenheimer) gedacht ist: Wer eine schlaue Idee hat, schreibt sie auf, [hasht](https://emn178.github.io/online-tools/sha256.html) sie und speichert den Hash-Wert über den Weisenheimer-Contract in der Blockchain. Dann kann man auch in vielen Jahren noch beweisen, dass man das heute schon wusste.

## Lesen des Contracts
In [Teil 2](https://www.iteratec.de/tech-blog/artikel/tldr-smart-contracts-fuer-eilige-teil-2-blockchain-tutorial-1/) haben wir eine kleine [Web-App](https://owidder.github.io/weisenheimer/teil2/) erstellt, die mit ein klein wenig [JavaScript-Code](https://github.com/owidder/weisenheimer/blob/master/teil2/index.html) alle Events aus dem Contract ausliest und die darin enthaltenen Hash-Werte zusammen mit Nummer und Timestamp des Blockes der Blockchain, in dem sich der Event befindet, anzeigt.

## Jetzt wird's ernst
Aber das war doch alles Pillepalle. Jetzt wollen wir mal in die Blockchain schreiben. Und zwar indem wir die schreibende Transaktion `logHashValue` aufrufen.

## Umsonst ist der Tod...
... aber eine schreibende Transaktion kostet Krypto-Geld. Zum Glück gibt es im Test-Network Rinkeby die Ether geschenkt.  Wie in [Teil 1](https://www.iteratec.de/tech-blog/artikel/tldr-smart-contracts-fuer-eilige-teil-1-blockchain-tutorial/) besorgen wir uns das mit den folgenden Schritten:

 1. Falls nicht schon geschehen installieren wir uns das Browser-Plugin-Wallet [Metamask](https://metamask.io/).
 2. Beim ersten Öffnen wird automatisch ein Wallet inklusive Seed Phrase generiert:
<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20190907-01/iterablog/images/metamask-init-seed.png"/>
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTQ4NjUxNTk5NCw2MjIyOTAxOTYsLTE1Mj
Y0MTk2NzUsLTEzMjYxNTcwNjgsMTA2ODAzNDgyLDc2NTE1MjA3
MywtNTExMDU3NTg0LC0xMzMwNDc3MDkyLDExMTYwOTg2NDcsMj
M3MTM5NzE1LDE0NjE1MTAyMDUsMTMzNjE4ODg4MCwtMzk1NzIz
NzgyXX0=
-->