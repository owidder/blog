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
(Die App funktioniert nur, wenn der Browser [Web3 enabled](https://forum.livepeer.org/t/how-to-enable-web3-in-your-browser/179) ist. Z.B. über das unten beschrieben Plug-in Metamask)

## Jetzt wird's ernst
Aber das war doch alles Pillepalle. Jetzt wollen wir mal in die Blockchain schreiben. Und zwar indem wir die schreibende Transaktion `logHashValue` aufrufen.

## Umsonst ist der Tod...
... aber eine schreibende Transaktion kostet Krypto-Geld. Zum Glück gibt es im Test-Network Rinkeby die [Ether](https://www.coindesk.com/price/ethereum) geschenkt.  Wie in [Teil 1](https://www.iteratec.de/tech-blog/artikel/tldr-smart-contracts-fuer-eilige-teil-1-blockchain-tutorial/) besorgen wir uns das mit den folgenden Schritten:

 1. Falls nicht schon geschehen installieren wir uns das Browser-Plugin-Wallet [Metamask](https://metamask.io/).
 2. Beim ersten Öffnen wird automatisch ein Wallet inklusive Seed Phrase generiert:
<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20190907-01/iterablog/images/metamask-init-seed.png"/>
Die Seed Phrase besteht aus 12 Worten und ist der Masterkey zum Wallet. Wer ihn hat, hat volle Kontrolle über alle Accounts, die vom Wallet verwaltet werden.
Und wer ihn verliert, hat alle Ether, die sich im Wallet befinden, verloren. 
Also gut darauf aufpassen (zumindest wenn man mit dem Wallet mehr als Rinkeby-Spiel-Ether verwaltet)!
3. In Metamask sieht man oben unter dem Account-Namen (hier einfach nur `Account 1`) die Account-ID. Die kopiert man sich in die Zwischenablage:
<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20190907-02/iterablog/images/metamask-account-id.png"/>
4. Und [tweetet](https://twitter.com/gap_listens/status/1170290940440977413) sie:
<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20190907-03/iterablog/images/tweet.png"/>
Gerne auch mit einem erklärenden Text. Hauptsache der Tweet enthält die Account-ID.
5. Die URL kopiert man sich und auf geht's zum [Rinkeby-Faucet](https://faucet.rinkeby.io/). Dort werden Ether verschenkt.
<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20190907-04/iterablog/images/faucet3.png"/>
Einfach die URL des Tweets in das Eingabefeld kopieren und auswählen, wieviel Ether es denn sein dürfen (wir nehmen uns natürlich gleich die vollen 18,75. Warum nicht?)
Und nach kurzer Zeit sehen wir auch schon `funded`. Das Geld ist da!
<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20190907-05/iterablog/images/faucet4.png"/>

## Auf geht's

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTIyMzY5MzAxMiw2NzcxMjU3NDIsMjEwMj
c2OTQ5NSwtMTc2MzM1OTMwMCwtMTA1ODA1ODMzMSw5NTMwNzU1
MDMsNzQ0NTk5MTksLTQ4NjUxNTk5NCw2MjIyOTAxOTYsLTE1Mj
Y0MTk2NzUsLTEzMjYxNTcwNjgsMTA2ODAzNDgyLDc2NTE1MjA3
MywtNTExMDU3NTg0LC0xMzMwNDc3MDkyLDExMTYwOTg2NDcsMj
M3MTM5NzE1LDE0NjE1MTAyMDUsMTMzNjE4ODg4MCwtMzk1NzIz
NzgyXX0=
-->