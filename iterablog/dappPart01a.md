# TL;DR: Smart Contracts für Eilige (Teil 2) - Meine erste DApp

Wir erinnern uns: In  [Teil 1](https://www.iteratec.de/tech-blog/artikel/news/tldr-smart-contracts-fuer-eilige-teil-1-1/) haben einen (vielleicht nicht ganz soooooo) smarten Contract namens ["Weisenheimer"](https://github.com/owidder/iteraBlog/blob/master/weisenheimer/contract/Weisenheimer.sol) in die [Ethereum](https://www.ethereum.org/) Test-Blockchain ["Rinkeby"](https://www.rinkeby.io/#stats) hochgeladen:

    pragma solidity ^0.4.19;
    contract Weisenheimer {

	    event NewHashValue(string, address, uint);

	    function logHashValue(string hashValue) public {    
		    emit NewHashValue(hashValue, msg.sender, block.timestamp);
	    }
    }

Der Contract hat nur eine Methode: `logHashValue`. 
Man kann sie mit einem beliebigen String aufrufen. `logHashValue` erzeugt dann einen Event (`NewHashValue`). Dieser enthält:  
* Den übergebenen String
* Die Account-Adresse des Senders des Strings
* Den Zeitstempel des Blocks, in dem der Event in der Blockchain gespeichert ist.
## Hash mich
Gedacht ist `logHashValue` speziell für Strings, die einen [kryptographischen Hashwert](https://simple.wikipedia.org/wiki/Cryptographic_hash_function) (z.B. [SHA](https://en.wikipedia.org/wiki/SHA-2)) enthalten. Dieser Hashwert liegt dann in der Blockchain und kann jederzeit und von jeder und jedem ausgelesen werden. 

Als notirischer Schlaumeier kann man sich das nun zunutze machen.
## "Das weiß ich doch schon lange"
Sollten Sie wieder mal eine kluge Idee haben, dann [hashen Sie diese doch einfach](https://abunchofutils.com/u/computing/sha512-hash-calculator/) und rufen mit dem Hashwert die `logHashValue`-Methode des  Weisenheimer-Contract auf. 
Sollte dann später jemand mit der gleichen Idee kommen, können Sie beweisen, dass Sie das schon lange wussten. 

Denn der Hashwert inklusive Zeitstempel sind in der Blockchain auf immer und ewig (oder zumindest so lange es die Blockchain gibt) hinterlegt.
## DApp
In [Teil 1](https://www.iteratec.de/tech-blog/artikel/news/tldr-smart-contracts-fuer-eilige-teil-1-1/) war es jedoch noch nicht möglich, die abgelegten Hashwerte auch wieder auszulesen.
Dafür wollen wir jetzt eine sogenannte decentralized App oder ["DApp"](https://www.stateofthedapps.com/) (wie die coolen Kids dazu sagen) für den Contract erstellen.
## Hä?
Ich weiß nicht, ob es eine offizielle Definition einer DApp gibt. Aber dies hier ist die einfachste Definition, die ich kenne ist:

[DApp = Frontend + Smart Contract](https://ethereum.stackexchange.com/questions/383/what-is-a-dapp)

Den Smart Contract haben wir schon. Fehlt uns also nur noch ein Frontend.
## Frontend für Eilige
In der ersten Version soll das Frontend lediglich die Inhalte der `NewHashValue`-Events, die der Contract produziert, in einer Tabelle anzeigen. 
Und wie immer haben wir es eilig. Wer weiß denn schon, wie lange dieser ganze Blockchain-Hype noch anhält? 
Deswegen besteht Frontend aus nur einem einzigen HTML-File:
```
<html>  
<head>  
    <meta charset="UTF-8">  
  
    <title>Weisenheimer</title>  
  
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">  
  
    <script src="https://cdn.jsdelivr.net/gh/owidder/super-simple-utils@v0.4/build/static/js/showDataAsTable.min.js"></script>  
    <script src="https://cdn.jsdelivr.net/gh/ethereum/web3.js@1.0.0-beta.35/dist/web3.min.js"></script>  
  
</head>  
<body>  
  
<script>  
    (function () {  
  
        const abi = [{"constant":false,"inputs":[{"name":"hashValue","type":"string"}],"name":"logHashValue","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"address"},{"indexed":false,"name":"","type":"uint256"}],"name":"NewHashValue","type":"event"}];  
  
        if (window.ethereum) {  
            const web3 = new Web3(ethereum);  
            ethereum.enable().then(function () {  
                const contract = new web3.eth.Contract(abi, "0x245eDE9dac68B84f329e21024E0083ce432700f9");  
                contract.getPastEvents("NewHashValue", {fromBlock: 0, toBlock: 'latest'}, function (error, events) {  
                    console.log(events);  
                    const data = events.map(function (event) {  
                        return {  
                            sender: event.returnValues[1],  
                            blockno: event.blockNumber,  
                            timestamp: new Date(event.returnValues[2] * 1000).toDateString(),  
                            hashvalue: event.returnValues[0],  
                        }  
                    });  
  
                    window.showDataAsTable("body", data);  
                });  
            })  
        } else {  
            return Promise.reject("No injected eteherum object found");  
        }  
    })()  
</script>  
</body>  
</html>
```
Das wollen wir uns nun im Einzelnen ansehen.
## Zuerst ein wenig Styling ...
Im Head holen wir uns das Stylesheet von [Materialize](https://materializecss.com/), weil's damit einfach schöner aussieht:
```
<link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
```
## ... dann noch ein paar Bibliotheken ...
```
<script src="https://cdn.jsdelivr.net/gh/owidder/super-simple-utils@v0.4/build/static/js/showDataAsTable.min.js"></script>
<script src="https://cdn.jsdelivr.net/gh/ethereum/web3.js@1.0.0-beta.35/dist/web3.min.js"></script>  
```
* [showDataAsTable.js](https://github.com/owidder/super-simple-utils/blob/master/src/table/showDataAsTable.ts) verwenden wir, um uns die Daten der Events tabellarisch darstellen zu lassen 
* [web3.js](https://github.com/ethereum/web3.js/) ist die offizielle JavaScript-Library von Ethereum zum Aufrufen von Smart-Contracts
## ... und schon kann's losgehen
Um mit einem Smart Contract kommunizieren zu können, benötigt man sein sogenanntes Application Binary Interface (ABI). Das ist eine JSON-Beschreibung (also eigentlich gar nicht richtig binary) seiner Schnittstelle.
## Und wo bekommt man ein ABI?
Wie wir uns ja sicher noch aus [Teil 1](https://www.iteratec.de/tech-blog/artikel/news/tldr-smart-contracts-fuer-eilige-teil-1-1/) erinnern, ist unser Contract unter der Adresse `0x245eDE9dac68B84f329e21024E0083ce432700f9` zu finden.
Dort finden wir ihn auch auf [Etherscan](https://rinkeby.etherscan.io/address/0x245eDE9dac68B84f329e21024E0083ce432700f9):

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181103-02/iterablog/images/etherscan-contract-3.png"/>

Und wenn wir dort auf den 2. Tab ("Code") klicken, sehen wir die ABI des Contracts:

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181103-03/iterablog/images/contract-abi.png"/>

Die kopieren wie uns raus und legen sie in einer Konstanten ab:
```
const abi = [{"constant":false,"inputs":[{"name":"hashValue","type":"string"}],"name":"logHashValue","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"address"},{"indexed":false,"name":"","type":"uint256"}],"name":"NewHashValue","type":"event"}];
```
## Ein Hoch auf den Fuchs
Jetzt wollen wir alle `NewHashValue`-Events vom Contract auslesen. 
Dafür müssen wir uns zum Glück nicht mühsam mit einem Knoten des Rinkeby-Netzwerks verbinden. Wir machen das ganz einfach über das [Metmask-Wallet-Plugin](https://metamask.io/) des Browsers, das wir uns in [Teil 1](https://www.iteratec.de/tech-blog/artikel/news/tldr-smart-contracts-fuer-eilige-teil-1-1/) installiert haben. Sie erinnern sich an den Fuchs?

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181103-04/iterablog/images/metamask-fox.png" width="30%"/>

Wenn das Metamask-Plugin aktiv ist, bekommt jede Website ein Object mit Namen `ethereum` injected:
``` 
if (window.ethereum) {
...
} else {  
    return Promise.reject("No injected eteherum object found");  
}
```
(Sollten Sie das Plugin schon länger installiert haben, müssen Sie es gegebenenfalls aktualisieren. Hier hat sich in letzter Zeit einiges geändert)
An  `ethereum` müssen wir zunächst die `enable()`-Methode aufrufen. 
```
ethereum.enable()
```
An dieser Stelle kann sich ein Metamask-Dialog öffnen, in dem der Benutzer um Erlaubnis gefragt wird (ist bei mir bis jetzt aber noch nie passiert). Deshalb ist `enable()` auch asynchron und gibt ein [JavaScript-Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) zurück. 
An dem Promise rufen wir wiederum die `then()`-Methode auf, der wir eine Callback-Function übergeben:
```
ethereum.enable().then(function () {
...
})
```
 Sobald das Promise [resolved](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/resolve), wird also der folgende Code in der Function ausgeführt:
 ```
 const web3 = new Web3(ethereum);  
const contract = new web3.eth.Contract(abi, "0x245eDE9dac68B84f329e21024E0083ce432700f9");  
contract.getPastEvents("NewHashValue", {fromBlock: 0, toBlock: 'latest'}, function (error, events) {  
    console.log(events);  
    const data = events.map(function (event) {  
        return {  
            sender: event.returnValues[1],  
            blockno: event.blockNumber,  
            timestamp: new Date(event.returnValues[2] * 1000).toDateString(),  
            hashvalue: event.returnValues[0],  
        }  
    });  
  
    window.showDataAsTable("body", data);
   });
 ```
## Nix geht ohne Web3
Will man sich über JavaScript mit einem Ethereum-Contract unterhalten, geht eigenlicht nichts an [Web3](https://github.com/ethereum/web3.js/) vorbei. Es ist die offizielle JavaScript-API von der [Ethereum-Foundation](https://www.ethereum.org/foundation).
Darum nutzen auch wir sie und erzeugen uns nun ein `web3`-Object:
```
const web3 = new Web3(ethereum);
``` 
Über `web3` bekommen wir wiederum ein Proxy-Object für unseren Contract. Dafür müssen wir ABI und Adresse des Contracts übergeben:
```
const contract = new web3.eth.Contract(abi, "0x245eDE9dac68B84f329e21024E0083ce432700f9");
```
Mit diesem Proxy-Object können wir nun endlich unseren Contract aufrufen, um alle Events vom Typ `NewHashValue` zu bekommen. Dieser Aufruf ist asynchron. Anders als bei `ethereum.enable()` bekommen wir aber kein Promise zurück. Statt dessen müssen wir ein  Callback-Function gleich mit übergeben: 
```
contract.getPastEvents("NewHashValue", {fromBlock: 0, toBlock: 'latest'}, function (error, events) {
...
})
```
Sobald die Events da sind, wird diese Function aufgerufen.
## Ein Event von innen
In der Callback-Function geben wir als erstes die Events auf der Console aus:
```
console.log(events);
``` 
Dann wollen wir uns mal einen davon ansehen (in der Developer-Console):

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181103-06/iterablog/images/event.png"/>

 * Die Nummer des Blocks liegt im Attribute `blockNumber`
 * Der Hashwert selbst liegt in `returnValues[0]`
 * Die Account-Adresse des Senders des Hashwertes liegt in `returnValues[1]`
 * Der Zeitstempel (Sekunden seit 01.01.1970) des Blocks liegt in `returnValues[2]`
Damit müssen wir uns nur noch die Events in Objekte mit den Attributen `blockNumber`, `hashValue`, `senderAddress` und `timestamp` umwandeln und diese per  `showDataA`

Da der Aufruf über das Metamask-Plugin erfolgt, müssen wir jetzt noch sicherstellen, dass das in dem Plugin das Rinkeby-Netzwerk ausgewählt ist:

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181103-05/iterablog/images/metameask-rinkeby.png" width="50%"/>


<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE5NjY5NzUzMTMsLTEzMjQwNjIwMTUsLT
E0MTAzNTUwMzgsMTI1NzIyODE5NiwtMTE0ODk4ODY3XX0=
-->