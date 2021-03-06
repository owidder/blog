# TL;DR: Smart Contracts für Eilige (Teil 2) - Meine erste DApp

Wir erinnern uns: In  [Teil 1](https://www.iteratec.de/tech-blog/artikel/news/tldr-smart-contracts-fuer-eilige-teil-1-1/) haben einen (mehr oder weniger) smarten Contract namens ["Weisenheimer"](https://github.com/owidder/iteraBlog/blob/master/weisenheimer/contract/Weisenheimer.sol) in die [Ethereum](https://www.ethereum.org/) Test-Blockchain ["Rinkeby"](https://www.rinkeby.io/#stats) hochgeladen:

    pragma solidity ^0.4.19;
    contract Weisenheimer {

	    event NewHashValue(string, address, uint);

	    function logHashValue(string hashValue) public {    
		    emit NewHashValue(hashValue, msg.sender, block.timestamp);
	    }
    }

Der Contract hat nur eine Methode: `logHashValue`. 

Man kann sie mit einem beliebigen String aufrufen. `logHashValue` speichert dann einen Event mit Namen`NewHashValue` in der Blockchain. Der Event enthält:  
* Den übergebenen String
* Die Account-Adresse des Senders des Strings
* Den Zeitstempel des Blocks, in dem der Event in der Blockchain gespeichert ist
## "Das weiß ich doch schon lange"
Gedacht ist `logHashValue` speziell für Strings, die einen [kryptographischen Hashwert](https://simple.wikipedia.org/wiki/Cryptographic_hash_function) (z.B. [SHA](https://en.wikipedia.org/wiki/SHA-2)) enthalten. Dieser Hashwert liegt dann in der Blockchain und kann jederzeit und von jeder und jedem ausgelesen werden.

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

(Am Ende dieses Beitrags haben Sie ihre eigene DApp im Internet, mit der Sie Freunde und Bekannte mächtig beeindrucken können)
## Frontend für Eilige
In der ersten Version soll das Frontend allerdings lediglich die Inhalte der `NewHashValue`-Events, die der Contract in der Blockchain ablegt, in einer Tabelle anzeigen. 

Und wie immer haben wir es eilig. (Wer weiß denn schon, wie lange dieser ganze Blockchain-Hype noch anhält?)

Deswegen besteht Frontend aus nur einem einzigen HTML-File:
```
<!DOCTYPE html>  
<html lang="en">  
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
            ethereum.enable().then(function () {  
                const web3 = new Web3(ethereum);  
                const contract = new web3.eth.Contract(abi, "0x245eDE9dac68B84f329e21024E0083ce432700f9");  
                contract.getPastEvents("NewHashValue", {fromBlock: 0, toBlock: 'latest'}, function (error, events) {  
                    console.log(events);  
                    const data = events.map(function (event) {  
                        return {  
                            blockNumber: event.blockNumber,  
                            senderAddress: event.returnValues[1],  
                            timestamp: new Date(event.returnValues[2] * 1000).toDateString(),  
                            hashValue: event.returnValues[0],  
                        }  
                    });  
  
                    window.showDataAsTable("body", data);  
                });  
            })  
        } else {  
            window.alert("No injected ethereum object found");  
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
* [showDataAsTable](https://github.com/owidder/super-simple-utils/blob/master/src/table/showDataAsTable.ts) verwenden wir, um uns die Daten der Events tabellarisch darstellen zu lassen 
* [web3.js](https://github.com/ethereum/web3.js/) ist die offizielle JavaScript-Library von Ethereum zum Aufrufen von Smart-Contracts
## ... und schon kann's losgehen
Um mit einem Smart Contract kommunizieren zu können, benötigt man sein sogenanntes [Application Binary Interface (ABI)](https://ethereum.stackexchange.com/questions/234/what-is-an-abi-and-why-is-it-needed-to-interact-with-contracts). Das ist eine JSON-Beschreibung (also eigentlich gar nicht richtig binary) seiner Schnittstelle.
## Und wo bekommt man ein ABI?
Sollten Sie beim ersten Teil schon mitgemacht haben, dann sollten Sie jetzt Ihren Contract auf [Etherscan](https://rinkeby.etherscan.io/) aufrufen. Dazu benötigen Sie die Adresse des Contract. Die können Sie dann im Suchfeld oben rechts eingeben:

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181104-12/iterablog/images/etherscan-search.png"/>

Ansonsten können Sie auch gerne meinen Contract mit der Adresse `0x245eDE9dac68B84f329e21024E0083ce432700f9` nehmen:
https://rinkeby.etherscan.io/address/0x245eDE9dac68B84f329e21024E0083ce432700f9

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181103-02/iterablog/images/etherscan-contract-3.png"/>

Im [Tab-Reiter "Code"](https://rinkeby.etherscan.io/address/0x245eDE9dac68B84f329e21024E0083ce432700f9#code) sehen wir die ABI des Contracts:

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181103-03/iterablog/images/contract-abi.png"/>

Die kopieren wie uns raus und legen sie in einer Konstanten ab:
```
const abi = [{"constant":false,"inputs":[{"name":"hashValue","type":"string"}],"name":"logHashValue","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"address"},{"indexed":false,"name":"","type":"uint256"}],"name":"NewHashValue","type":"event"}];
```
## Ein Hoch auf den Fuchs
Jetzt wollen wir alle `NewHashValue`-Events des Contracts auslesen. 

Dafür müssen wir uns zum Glück nicht mühsam mit einem Knoten des Rinkeby-Netzwerks verbinden. Wir machen das ganz einfach über das [Metmask-Wallet-Plugin](https://metamask.io/), das wir uns in [Teil 1](https://www.iteratec.de/tech-blog/artikel/news/tldr-smart-contracts-fuer-eilige-teil-1-1/) installiert haben. 

Sie erinnern sich an den Fuchs?

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181103-04/iterablog/images/metamask-fox.png" width="20%"/>

Wenn das Metamask-Plugin aktiv ist (sie sollten den Fuchs neben der Adressleiste des Browsers sehen), bekommt jede Website ein Object mit Namen `ethereum` injected. Wir prüfen also zunächst, ob dieses `ethereum`-Object vorhanden ist. Falls nicht, können wir leider nichts tun:
``` 
if (window.ethereum) {
...
} else {  
    window.alert("No injected ethereum object found");  
}
```
**Achtung**: Sollten Sie das Metamask-Plugin schon länger installiert haben, müssen Sie es gegebenenfalls aktualisieren. Hier hat sich in letzter Zeit einiges geändert.

An dem `ethereum`-Object müssen wir zunächst die `enable()`-Methode aufrufen. 
```
ethereum.enable()
```
Dieser Aufruf wird von Metamask nach einer [Änderung der Security-Policy](https://medium.com/metamask/https-medium-com-metamask-breaking-change-injecting-web3-7722797916a8) verlangt. An dieser Stelle kann sich ein Metamask-Dialog öffnen, in dem der Benutzer um Erlaubnis gefragt wird (ist bei mir bis jetzt aber noch nie passiert). 

`enable()` ist asynchron und gibt ein [JavaScript-Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) zurück. Wir übergeben also der `then()`-Methode des Promise eine Callback-Function, die aufgerufen wird sobald das Promise [resolved](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/resolve) (d.h. die `enable()`-Methode ist erfolgreich beendet):
```
ethereum.enable().then(function () {
...
})
```
Sehen wir uns jetzt diese Callback-Function an:
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
Will man sich über JavaScript mit einem Ethereum-Contract unterhalten, geht eigenlicht nichts an [Web3](https://github.com/ethereum/web3.js/) vorbei. Es ist die offizielle JavaScript-API der [Ethereum-Foundation](https://www.ethereum.org/foundation).
Darum nutzen auch wir sie und erzeugen uns nun ein `web3`-Object:
```
const web3 = new Web3(ethereum);
``` 
Über `web3` bekommen wir wiederum ein Proxy-Object für unseren Contract. Dafür müssen wir ABI und Adresse des Contracts übergeben (die Adresse müssen Sie ggf. gegen die Adresse ihres Contracts austauschen):
```
const contract = new web3.eth.Contract(abi, "0x245eDE9dac68B84f329e21024E0083ce432700f9");
```

Mit diesem Proxy-Object können wir nun endlich unseren Contract aufrufen, um alle Events vom Typ `NewHashValue` zu bekommen. 

Auch Dieser Aufruf ist asynchron. Anders als bei `ethereum.enable()` bekommen wir aber kein Promise zurück. Statt dessen müssen wir eine Callback-Function gleich mit übergeben: 
```
contract.getPastEvents("NewHashValue", {fromBlock: 0, toBlock: 'latest'}, function (error, events) {
...
})
```
Sobald die Events zum Browser übertragen worden sind, wird diese Callback-Function aufgerufen.
## Ein Event von innen
In der Callback-Function geben wir als erstes die Events auf der Console aus:
```
console.log(events);
``` 
Dann wollen wir uns mal einen davon ansehen (in der Developer-Console):

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181103-06/iterablog/images/event.png"/>

 * Die Nummer des Blocks liegt im Attribut `blockNumber`
 * Der Hashwert selbst liegt in `returnValues[0]`
 * Die Account-Adresse des Senders des Hashwertes liegt in `returnValues[1]`
 * Der Zeitstempel (Sekunden seit 01.01.1970) des Blocks liegt in `returnValues[2]`

Jetzt müssen wir uns nur noch die Events in Objekte mit den Attributen `blockNumber`, `hashValue`, `senderAddress` und `timestamp` umwandeln und diese per  [`showDataAsTable()`](https://github.com/owidder/super-simple-utils/blob/master/src/table/showDataAsTable.ts) anzeigen lassen:
```
const data = events.map(function (event) {  
    return {  
        blockNumber: event.blockNumber,  
        senderAddress: event.returnValues[1],  
        timestamp: new Date(event.returnValues[2] * 1000).toDateString(),  
        hashValue: event.returnValues[0],  
    }  
});  
  
window.showDataAsTable("body", data);
```
## Wow!!!
Sieht dann so aus (Wie man sieht hat da jemand den Contract ohne echte Hashwerte aufgerufen):

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181103-08/iterablog/images/weisenheimer-02.png"/>

Naja. Schön geht anders. Tut aber.

Ansehen können Sie sich das ganze hier: [https://owidder.github.io/weisenheimer/](https://owidder.github.io/weisenheimer/)

Funktioniert aber nur, wenn Sie das [Metamask-Plugin](https://metamask.io/) installiert haben. Denn wie oben beschrieben läuft die Kommunikation mit dem Contract über dieses Plugin.

Und da sich der Contract im [Rinkeby Testnetzwerk]((https://www.rinkeby.io/#stats)) befindet, müssen Sie auch noch sicherstellen, dass Rinkeby in dem Plugin ausgewählt ist:

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181105-01/iterablog/images/metameask-rinkeby.png" width="50%"/>

## Die eigene DApp
Wollen Sie Ihre Bekannten mit einer eigene DApp beeindrucken? 

Nichts leichter als das. Contract und Frontend haben wir ja jetzt. Bleibt nur noch die Frage, wie wir das Frontend im Internet veröffentlichen. 

Und wie immer haben wir es eilig.
## Github Pages
Am Schnellsten und auch noch kostenlos geht das mit [GitHub Pages](https://pages.github.com/).

Dazu brauchen wir nur 6 Schritte
## 1. Anmelden
Melden Sie sich bei [GitHub](https://github.com/) an, falls Sie dort noch kein Konto haben:

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181104-01/iterablog/images/sign-up-github.png"/>

## 2. Repository erstellen
Wenn Sie angemeldet sind, können Sie über den "New Repository"-Button

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181104-02/iterablog/images/new-repo.png"/>

ein [neues Repository erstellen](https://github.com/new) (z.B. mit dem Namen "weisenheimer"):

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181104-01/iterablog/images/create-repo.png"/>

**Achtung**: Wichtig ist, dass der Haken bei "Initialize this repository with a README" gesetzt ist.

## 3. Branch erstellen
Sobald das Repository erstellt ist, können Sie über das Dropdown-Menü "Branch: Master"

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181104-11/iterablog/images/branch-dropdown.png"/>
 
 einen neuen Branch mit Namen "gh-pages" erstellen:

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181104-03/iterablog/images/create-branch.png"/>

**Achtung**: Der Name ist wichtig und muss genau so lauten.

## 4. Default-Branch setzen
Über den Tab-Reiter "Settings" und die Auswahl "Branches" auf der linken Seite 

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181104-04/iterablog/images/set-default-branch.png"/>

können Sie den Default-Branch auf den neuen Branch "gh-pages" setzen:

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181104-05/iterablog/images/set-default-branch-2.png"/>

Selbstverständlich [wissen wir, was wir tun](https://de.wikipedia.org/wiki/%E2%80%A6_denn_sie_wissen_nicht,_was_sie_tun):

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181104-06/iterablog/images/i-understand.png" width="50%"/>


## 5. HTML-File erstellen
So nun, müssen wir nur noch das HTML-File von oben erstellen. 
Dazu gehen wieder zurück zu dem Tab-Reiter "Code" und klicken auf den "Create new file"-Button:

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181104-08/iterablog/images/create-new-file-button.png"/>

In die große Textarea kopieren Sie den HTML-Code von oben (Sie können ihn sich von [hier](https://raw.githubusercontent.com/owidder/iteraBlog/gh-pages/html/weisenheimer.html) kopieren. Dabei müssen Sie ggf. die Adresse des Contracts in Zeile 24 anpassen.)

Als Name geben Sie "index.html" ein:

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181104-08/iterablog/images/create-file.png"/>

Ganz unten klicken Sie den "Commit new file"-Button

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181104-08/iterablog/images/commit-new-file.png"/>

**Achtung**: Die Checkbox "Commit directly to the `gh-pages` branch" muss ausgewählt sein.

## 6. Fertig
Das war's eigentlich schon. Jetzt müssen Sie nur noch einmal im Tab-Reiter "Settings" nach unten scrollen bis zum Abschnitt "GitHub-Pages"

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181104-08/iterablog/images/gh-pages.png"/>

Wenn Sie jetzt auf den Link in dem blauen Kasten klicken, sehen Sie ihre Dapp:

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181104-09/iterablog/images/part2-final.png"/>

Sie funktioniert allerdings nur, wenn Sie das [Metamask-Plugin](https://metamask.io/) installiert haben und im Plugin das Rinkeby-Testnetzwerk ausgewählt ist:

<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181104-10/iterablog/images/metamask-rinkeby-02.png"/>

## Tschüüüs
Vielen Dank und bis zum nächsten Mal. Dann werden wir die Dapp weiter ausbauen, so dass wir unsere klugen Ideen eintippen können und auf Knopfdruck die `logHashValue()`-Methode unseres Contracts aufgerufen wird.



<!--stackedit_data:
eyJoaXN0b3J5IjpbMTQ5MTg3NTY1OCwtMTUzODc2NTkyNSwtMT
gxMDU0MTc5Myw1MDIxMDkxMDAsLTEzMjAwOTA4MzgsLTQwODUz
NzA3Nyw1NTg1MzUyLC0xMjM0MzkwNDA2LC0xMDE5NTc4MDMwLD
gzMTkyNTczMSw3MTgxODUwNjgsLTY5MDA5NjE4NiwtMTM5MzQ0
OTE3OSwtMTIzNDMzMzY5MSwtMjA4MTk2OTU3MCwtMzQwMjAwOD
AsLTcwNDQ1MzE3OSwxNDY2NTg2NDU4LC0xMzI0MDYyMDE1LC0x
NDEwMzU1MDM4XX0=
-->