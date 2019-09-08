# TL;DR: Smart Contracts für Eilige (Teil 3) - Unsere Dapp startet eine Transaktion

In [Teil 1](https://www.iteratec.de/tech-blog/artikel/news/tldr-smart-contracts-fuer-eilige-teil-1-1/) haben wir mit möglichst einfachen Mitteln den Smart Contract ["Weisenheimer"](https://github.com/owidder/iteraBlog/blob/master/weisenheimer/contract/Weisenheimer.sol) in [Rinkeby](https://www.rinkeby.io/), einem Ethereum Test Network, [deployt](https://rinkeby.etherscan.io/address/0x245eDE9dac68B84f329e21024E0083ce432700f9#code):

    contract Weisenheimer {

	    event NewHashValue(string, address, uint);

	    function logHashValue(string hashValue) public {    
		    emit NewHashValue(hashValue, msg.sender, block.timestamp);
	    }
    }

So richtig smart ist "Weisenheimer" nicht. Er kann nichts weiter als einen String (`hashValue`) in einem Contract-Event zu speichern. 
Aber immerhin. 
Damit ist dieser String für immer und ewig in die Blockchain eingebrannt.

## Was für Schlaumeier
Weisenheimer heißt "Weisenheimer", weil er für [Schlaumeier](https://dict.leo.org/german-english/weisenheimer) gedacht ist: Denn wer eine schlaue Idee hat, schreibt sie auf, [hasht](https://emn178.github.io/online-tools/sha256.html) sie und speichert den Hash-Wert über den Weisenheimer-Contract in der Blockchain. 
Dann kann man auch in vielen Jahren noch beweisen, dass man das heute schon wusste.

## Lesen des Contracts
In [Teil 2](https://www.iteratec.de/tech-blog/artikel/tldr-smart-contracts-fuer-eilige-teil-2-blockchain-tutorial-1/) haben wir eine kleine [Web-App](https://owidder.github.io/weisenheimer/teil2/) erstellt, die mit ein klein wenig [JavaScript-Code](https://github.com/owidder/weisenheimer/blob/master/teil2/index.html) alle Events aus dem Contract ausliest und die darin enthaltenen Hash-Werte zusammen mit Nummer und Timestamp des Blockes der Blockchain, in dem sich der Event befindet, anzeigt.
(Die App funktioniert nur, wenn das unten beschrieben [Plug-in Metamask](https://metamask.io/) installiert ist)

## Jetzt wird's ernst
Das war bis jetzt doch alles nur Pillepalle. 
Jetzt wollen wir mal in die Blockchain schreiben. 
Das machen wir, indem wir die schreibende Transaktion `logHashValue` des Weisenheimer-Contracts aufrufen.

## Umsonst ist der Tod
Eine schreibende Transaktion kostet Krypto-Geld. Zum Glück gibt es im Test-Network Rinkeby die [Ether](https://www.coindesk.com/price/ethereum) geschenkt.  Wie in [Teil 1](https://www.iteratec.de/tech-blog/artikel/tldr-smart-contracts-fuer-eilige-teil-1-blockchain-tutorial/) besorgen wir uns das mit den folgenden Schritten:

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
6. Und nach kurzer Zeit sehen wir auch schon `funded`. Das Geld ist da!
<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20190907-05/iterablog/images/faucet4.png"/>

## Auf geht's
So, genug Krypto-Geld haben wir jetzt, um unsere Transaktion bezahlen zu können. Dann mal los.
Hier [der Code der erweiterten Web-App](https://github.com/owidder/weisenheimer/blob/master/teil3/index.html), mit der die schreibende Contract-Methode `logHashValue` aufgerufen wird:
```
<!DOCTYPE html>  
<html lang="en">  
<head>  
    <meta charset="UTF-8">  
  
    <title>Weisenheimer</title>  
  
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">  
  
    <script src="https://cdn.jsdelivr.net/gh/owidder/super-simple-utils@v0.12/build/static/js/showDataAsTable.min.js"></script>  
    <script src="https://cdn.jsdelivr.net/gh/owidder/super-simple-utils@v0.12/build/static/js/hash.min.js"></script>  
    <script src="https://cdn.jsdelivr.net/gh/ethereum/web3.js@1.0.0-beta.35/dist/web3.min.js"></script>  
    <script src="./showPastEvents.js"></script>  
</head>  
  
<style>  
    .input {  
        display: flex;  
        justify-content: flex-start;  
        align-items: flex-end;  
    }  
  
    .input textarea {  
        width: 70%;  
        height: 10em;  
        padding: 1em;  
        background-color: #F7F7F0;  
        margin: 1em;  
    }  
  
    .input button {  
        margin: 1em;  
    }  
</style>  
<body>  
  
<div class="input">  
    <textarea class="materialize-textarea" placeholder="Insert text, then press button to hash and log into smart contract"></textarea>  
    <button onclick="hashAndLog()" class="waves-effect waves-light btn">Hash and log</button>  
</div>  
<div class="table"></div>  
  
<script>  
    (function () {  
  
        const abi = [{"constant":false,"inputs":[{"name":"hashValue","type":"string"}],"name":"logHashValue","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"address"},{"indexed":false,"name":"","type":"uint256"}],"name":"NewHashValue","type":"event"}];  
  
        if (window.ethereum) {  
            ethereum.enable().then(() => {  
                const web3 = new Web3(ethereum);  
                const contract = new web3.eth.Contract(abi, "0x245eDE9dac68B84f329e21024E0083ce432700f9");  
                showPastEvents(contract, "div.table");  
  
                window.hashAndLog = () => {  
                    const textarea = document.querySelector(".input textarea");  
                    const textToHashAndLog = textarea.value;  
                    hashSHA256(textToHashAndLog).then(hashedText => {  
                        web3.eth.getAccounts((err, accountList) => {  
                            contract.methods.logHashValue(hashedText).send({from: accountList[0]})  
                                .on("confirmation", (confirmationNumber, receipt) => {  
                                    console.log(`conformation number: ${confirmationNumber}`);  
                                    console.log(receipt);  
                                    showPastEvents(contract, "div.table");  
                                })  
                                .on("error", error => {  
                                    console.error(error)  
                                })  
                        })  
                    })  
                }  
            })  
        } else {  
            window.alert("No injected ethereum object found");  
        }  
    })()  
</script>  
</body>  
</html>
```
[Ruft man die App auf](https://owidder.github.io/weisenheimer/teil3/), stellt sie sich folgendermaßen dar:
<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20190907-08/iterablog/images/weisenheimerAppTeil3.png"/>
In der TextArea kann man einen beliebigen Text eingeben. Über den `HASH AND LOG`-Button wird der Text gehasht und der Hash-Wert wird an die `logHashValue`-Methode des Contracts gesendet.
Sobald die Transaktion bestätigt ist, wird der neue Hash-Wert mit Blocknummer, Adresse des Senders und Zeitstempel in der Tabelle angezeigt.

## Show me the code
Wir geben jetzt erst einmal was in der TextArea ein und betätigend den `HASH AND LOG`-Button:

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20190908-01/iterablog/images/lotto.png"/>
(Im Jahr 2030 werde ich mit Hilfe der Blockchain endlich beweisen können, dass ich hellseherische Kräfte habe)

Und jetzt wollen wir die JavaScript-Function im Einzelnen durchgehen

## ABI
```
const abi = [{"constant":false,"inputs":[{"name":"hashValue","type":"string"}],"name":"logHashValue","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"address"},{"indexed":false,"name":"","type":"uint256"}],"name":"NewHashValue","type":"event"}];
```
Das ist das [Application Binary Interface (ABI)](https://ethereum.stackexchange.com/questions/234/what-is-an-abi-and-why-is-it-needed-to-interact-with-contracts) des Weisenheimer-Contracts. Man benötigt es, um mit dem Contract interagieren zu können. Sieht nicht schön aus. Aber zum Glück müssen wir es es nicht selber schreiben. Man kann es sich aus dem [deployten Contract](https://rinkeby.etherscan.io/address/0x245eDE9dac68B84f329e21024E0083ce432700f9#code) kopieren.
<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20190907-06/iterablog/images/abi.png"/>

## Ohne Ethereum-Object geht nix
```
if (window.ethereum) {  
	...
} else {  
    window.alert("No injected ethereum object found");  
}
```
Wenn das [Plug-in Metamask](https://metamask.io/) installiert ist, existiert das `ethereum`-Object. Das brauchen wir. Ansonsten können wir nicht weiter machen.

## Erst um Erlaubnis bitten
```
ethereum.enable().then(() => {  
	...
})
```

Mit `ethereun.enable()` öffnet Metamask einen Dialog, mit wir [um Erlaubnis bitten](https://medium.com/metamask/https-medium-com-metamask-breaking-change-injecting-web3-7722797916a8), dass wir Informationen aus dem Benutzer-Account auslesen dürfen (z.B. die ID des Accounts).
<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20190907-07/iterablog/images/connect.png"/>
`enable` gibt ein [JavaScript-Promise](https://developers.google.com/web/fundamentals/primers/promises) zurück, das resolved, wenn der Benutzer `connect` betätigt (ansonsten war's das).

## Contract-Proxy
```
const web3 = new Web3(ethereum);  
const contract = new web3.eth.Contract(abi, "0x245eDE9dac68B84f329e21024E0083ce432700f9");
```

Sobald zugestimmt wurde, besorgen ein `web3`-Object. [Web3](https://github.com/ethereum/web3.js/) ist die offizielle JavaScript-API von Ethereum.
Damit können wir uns dann über `web.eth.contract(abi, contractId)` ein Proxy-Object, über das wir den Contract erreichen können.

## Events lesen und anzeigen
```
showPastEvents(contract, "div.table");
```

Hinter `showPastEvents(contractProxy, cssSelector)` verbirgt sich der Code aus [Teil 2](https://www.iteratec.de/tech-blog/artikel/tldr-smart-contracts-fuer-eilige-teil-2-blockchain-tutorial-1/) zum Auslesen und anzeigen der Events. Wer Interesse hat, kann ihn [hier](https://github.com/owidder/weisenheimer/blob/master/teil3/showPastEvents.js) sehen. 

## Hashen
```
window.hashAndLog = () => {  
    const textarea = document.querySelector(".input textarea");  
    const textToHashAndLog = textarea.value;  
    hashSHA256(textToHashAndLog).then(hashedText => {  
	    ...
    })  
}
```

`hashAndLog` wird aufgerufen, wenn der `HASH AND LOG`-Button geklickt wird (siehe `<button onclick="hashAndLog()" ...`)
Der Text wird aus der TextArea ausgelesen und gehasht (den Code zum Hashen kann man [hier](https://github.com/owidder/super-simple-utils/blob/master/src/hash/hash.ts) sehen).

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20190908-02/iterablog/images/variables.png"/>


## Account ID
```
web3.eth.getAccounts((err, accountList) => {  
	...
})
```
Nun holen wir uns über die das `web3`-Object die ID des Accounts (darum mussten wir ja oben um Genehmigung gebeten). 
Über das Metamask kann man viele Accounts verwalten. 
<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20190907-09/iterablog/images/accounts.png"/>

`getAccounts` gibt ein Array mit einem einzigen String zurück: Der ID des aktuell ausgewählten Accounts.

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20190908-03/iterablog/images/accountList.png"/>

## Aufruf des Contracts
```
contract.methods.logHashValue(hashedText).send({from: accountList[0]})
```

Endlich!!! Jetzt haben wir den Hash-Wert (`hashedText`) und die Account-ID (`accountList[0]`). Damit können wir über das Proxy-Object (`contract`) die Methode `logHashValue` aufrufen.

Da das Geld Krypto-Geld kostet, meldet sich gleich Metamask:

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20190907-10/iterablog/images/confirmTransaction.png"/>

## Bestätigungen
Sobald es die Transaktion in einen Block der Blockchain geschafft hat, gibt es die erste Confirmation. Darüber freut sich dann auch Metamask:
<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20190907-11/iterablog/images/confirmationMessage.png"/>

`send()` gibt ein sogenanntes [`PromiEvent`](https://web3js.readthedocs.io/en/v1.2.0/callbacks-promises-events.html#promievent) zurück (das ist kein berühmtes Event, sondern irgendwas zwischen Promise und Event). 
Über das `PromiEvent` kann man sich dann informieren lassen, sobald eine Bestätigung eingegangen ist.
```
.on("confirmation", (confirmationNumber, receipt) => {  
    console.log(`conformation number: ${confirmationNumber}`);  
    console.log(receipt);  
    showPastEvents(contract, "div.table");  
})
```
Wir loggen die Nummer der Bestätigung (`confirmationNumber`) und die Quittung aus (`receipt`). Über `showPastEvents`zeigen wir wieder alle Events (inklusive der enthaltenen Hash-Werte) an. Unser Hash-Wert sollte jetzt ganz oben zu sehen sein.
<!--stackedit_data:
eyJoaXN0b3J5IjpbMjAyNDY2ODE1OCw5NDU4MTYzNDMsLTExMz
Q3Njc3NDUsLTIwNzA2NzgwNjAsLTEyMjEwNDUyNDAsLTYyMjc0
NDU1MSw1MDU4NjQyMTksMTg4NjQzMjI1Myw0ODQyMTU1OTgsLT
IwODA2MDYxMjcsLTEyNDA4MzQzNzAsLTE1NDY0NTkwOTQsMTUz
NDI3OTg0NCw0NTkxMDkyNiwxNTU1MjU2MDMsNTMyMDgyNjUwLD
MxODk3OTQ4NCwtMzM0NDM4MTUyLDgzNDkwMTgwOSwyMjgxMDc3
NTddfQ==
-->