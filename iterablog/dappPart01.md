---


---

<h1 id="tldr-smart-contracts-für-eilige-teil-2---meine-erste-dapp">TL;DR: Smart Contracts für Eilige (Teil 2) - Meine erste DApp</h1>
<p>Wir erinnern uns: In  <a href="https://www.iteratec.de/tech-blog/artikel/news/tldr-smart-contracts-fuer-eilige-teil-1-1/">Teil 1</a> haben einen (vielleicht nicht ganz soooooo) smarten Contract namens <a href="https://github.com/owidder/iteraBlog/blob/master/weisenheimer/contract/Weisenheimer.sol">“Weisenheimer”</a></p>
<pre><code>pragma solidity ^0.4.19;
contract Weisenheimer {

    event NewHashValue(string, address, uint);

    function logHashValue(string hashValue) public {    
	    emit NewHashValue(hashValue, msg.sender, block.timestamp);
    }
}
</code></pre>
<p>in die <a href="https://www.ethereum.org/">Ethereum</a> Test-Blockchain <a href="https://www.rinkeby.io/#stats">“Rinkeby”</a> hochgeladen.</p>
<p>Der Contract hat nur eine Methode: <code>logHashValue</code>.<br>
Man kann sie mit einem beliebigen String aufrufen. <code>logHashValue</code> erzeugt dann einen Event (<code>NewHashValue</code>). Dieser enthält:</p>
<ul>
<li>Den übergebenen String</li>
<li>Die Account-Adresse des Aufrufers</li>
<li>Den Zeitstempel des Blocks, in dem der Event in der Blockchain gespeichert ist.</li>
</ul>
<h2 id="hash-mich">Hash mich</h2>
<p>Gedacht ist <code>logHashValue</code> speziell für Strings, die einen <a href="https://simple.wikipedia.org/wiki/Cryptographic_hash_function">kryptographischen Hashwert</a> (z.B. <a href="https://en.wikipedia.org/wiki/SHA-2">SHA</a>) enthalten. Denn mit dem Event liegt dieser Hashwert nun in der Blockchain und kann jederzeit und von jeder und jedem ausgelesen werden.</p>
<h2 id="das-weiß-ich-doch-schon-lange">“Das weiß ich doch schon lange”</h2>
<p>Sollten Sie z.B. mal eine kluge Idee haben, dann <a href="https://abunchofutils.com/u/computing/sha512-hash-calculator/">hashen Sie diese doch einfach</a> und rufen mit dem Hashwert die <code>logHashValue</code>-Methode des  Weisenheimer-Contract auf.<br>
Sollte dann später jemand mit der gleichen Idee kommen, können Sie beweisen, dass Sie das schon lange wussten.<br>
Denn der Hashwert inklusive Zeitstempel sind in der Blockchain auf immer und ewig (oder zumindest so lange es die Blockchain gibt) hinterlegt.</p>
<h2 id="dapp">DApp</h2>
<p>In <a href="https://www.iteratec.de/tech-blog/artikel/news/tldr-smart-contracts-fuer-eilige-teil-1-1/">Teil 1</a> war es jedoch noch nicht möglich, die abgelegten Hashwerte auch wieder auszulesen.<br>
Dafür wollen wir jetzt eine sogenannte decentralized App oder <a href="https://www.stateofthedapps.com/">“DApp”</a> (wie die coolen Kids dazu sagen) für den Contract erstellen.</p>
<h2 id="hä">Hä?</h2>
<p>Ich weiß nicht, ob es eine offizielle Definition einer DApp gibt. Aber dies hier ist die einfachste Definition, die ich kenne ist:<br>
<a href="https://ethereum.stackexchange.com/questions/383/what-is-a-dapp">DApp = Frontend + Smart Contract</a><br>
Den Smart Contract haben wir schon. Fehlt uns also nur noch ein Frontend.</p>
<h2 id="frontend-für-eilige">Frontend für Eilige</h2>
<p>In der ersten Version soll das Frontend lediglich die Inhalte der <code>NewHashValue</code>-Events, die der Contract produziert, in einer Tabelle anzeigen.<br>
Und wie immer haben wir es eilig. Wer weiß denn schon, wie lange dieser ganze Blockchain-Hype noch anhält?<br>
Deswegen besteht Frontend aus nur einem einzigen HTML-File:</p>
<pre><code>&lt;!DOCTYPE html&gt;  
&lt;html lang="en"&gt;  
&lt;head&gt;  
    &lt;meta charset="UTF-8"&gt;  
  
    &lt;title&gt;Weisenheimer&lt;/title&gt;  
  
    &lt;link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css"&gt;  
  
    &lt;script src="https://cdn.jsdelivr.net/gh/owidder/super-simple-utils@v0.4/build/static/js/showDataAsTable.min.js"&gt;&lt;/script&gt;  
    &lt;script src="https://cdn.jsdelivr.net/gh/ethereum/web3.js@1.0.0-beta.35/dist/web3.min.js"&gt;&lt;/script&gt;  
  
&lt;/head&gt;  
&lt;body&gt;  
  
&lt;script&gt;  
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
&lt;/script&gt;  
&lt;/body&gt;  
&lt;/html&gt;
</code></pre>
<p>Das wollen wir uns nun im Einzelnen ansehen.</p>
<h2 id="zuerst-ein-wenig-styling-...">Zuerst ein wenig Styling …</h2>
<p>Im Head holen wir uns das Stylesheet von <a href="https://materializecss.com/">Materialize</a>, weil’s damit einfach schöner aussieht:</p>
<pre><code>&lt;link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css"&gt;
</code></pre>
<h2 id="dann-noch-ein-paar-bibliotheken-...">… dann noch ein paar Bibliotheken …</h2>
<pre><code>&lt;script src="https://cdn.jsdelivr.net/gh/owidder/super-simple-utils@v0.4/build/static/js/showDataAsTable.min.js"&gt;&lt;/script&gt;
&lt;script src="https://cdn.jsdelivr.net/gh/ethereum/web3.js@1.0.0-beta.35/dist/web3.min.js"&gt;&lt;/script&gt;  
</code></pre>
<ul>
<li><a href="https://github.com/owidder/super-simple-utils/blob/master/src/table/showDataAsTable.ts">showDataAsTable.js</a> verwenden wir, um uns die Daten der Events tabellarisch darstellen zu lassen</li>
<li><a href="https://github.com/ethereum/web3.js/">web3.js</a> ist die offizielle JavaScript-Library von Ethereum zum Aufrufen von Smart-Contracts</li>
</ul>
<h2 id="und-schon-kanns-losgehen">… und schon kann’s losgehen</h2>
<p>Um mit einem Smart Contract kommunizieren zu können, benötigt man sein sogenanntes Application Binary Interface (ABI). Das ist eine JSON-Beschreibung (also eigentlich gar nicht richtig binary) seiner Schnittstelle.</p>
<h2 id="und-wo-bekommt-man-ein-abi">Und wo bekommt man ein ABI?</h2>
<p>Wie wir uns ja sicher noch aus <a href="https://www.iteratec.de/tech-blog/artikel/news/tldr-smart-contracts-fuer-eilige-teil-1-1/">Teil 1</a> erinnern, ist unser Contract unter der Adresse <code>0x245eDE9dac68B84f329e21024E0083ce432700f9</code> zu finden.<br>
Dort finden wir ihn auch auf <a href="https://rinkeby.etherscan.io/address/0x245eDE9dac68B84f329e21024E0083ce432700f9">Etherscan</a>:</p>
<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181103-02/iterablog/images/etherscan-contract-3.png">
<p>Und wenn wir dort auf den 2. Tab (“Code”) klicken, sehen wir die ABI des Contracts:</p>
<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181103-03/iterablog/images/contract-abi.png">
<p>Die kopieren wie uns raus und legen sie in einer Konstanten ab:</p>
<pre><code>const abi = [{"constant":false,"inputs":[{"name":"hashValue","type":"string"}],"name":"logHashValue","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"address"},{"indexed":false,"name":"","type":"uint256"}],"name":"NewHashValue","type":"event"}];
</code></pre>
<h2 id="ein-hoch-auf-den-fuchs">Ein Hoch auf den Fuchs</h2>
<p>Jetzt wollen wir alle <code>NewHashValue</code>-Events vom Contract auslesen.<br>
Dafür müssen wir uns zum Glück nicht mühsam mit einem Knoten des Rinkeby-Netzwerks verbinden. Wir machen das ganz einfach über das <a href="https://metamask.io/">Metmask-Wallet-Plugin</a> des Browsers, das wir uns in <a href="https://www.iteratec.de/tech-blog/artikel/news/tldr-smart-contracts-fuer-eilige-teil-1-1/">Teil 1</a> installiert haben. Sie erinnern sich an den Fuchs?</p>
<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181103-04/iterablog/images/metamask-fox.png" width="30%">
<p>Wenn das Metamask-Plugin aktiv ist, bekommt jede Website ein Object mit Namen <code>ethereum</code> injected:</p>
<pre><code>if (window.ethereum) {
...
} else {  
    return Promise.reject("No injected eteherum object found");  
}
</code></pre>
<p>(Sollten Sie das Plugin schon länger installiert haben, müssen Sie es gegebenenfalls aktualisieren. Hier hat sich in letzter Zeit einiges geändert)<br>
An  <code>ethereum</code> müssen wir zunächst die <code>enable()</code>-Methode aufrufen.</p>
<pre><code>ethereum.enable()
</code></pre>
<p>An dieser Stelle kann sich ein Metamask-Dialog öffnen, in dem der Benutzer um Erlaubnis gefragt wird (ist bei mir bis jetzt aber noch nie passiert). Deshalb ist <code>enable()</code> auch asynchron und gibt ein <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise">JavaScript-Promise</a> zurück.<br>
An dem Promise rufen wir wiederum die <code>then()</code>-Methode auf, der wir eine Callback-Function übergeben:</p>
<pre><code>ethereum.enable().then(function () {
...
})
</code></pre>
<p>Sobald das Promise <a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/resolve">resolved</a>, wird also der folgende Code in der Function ausgeführt:</p>
<pre><code>const web3 = new Web3(ethereum);  
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
</code></pre>
<h2 id="nix-geht-ohne-web3">Nix geht ohne Web3</h2>
<p>Will man sich über JavaScript mit einem Ethereum-Contract unterhalten, geht eigenlicht nichts an <a href="https://github.com/ethereum/web3.js/">Web3</a> vorbei. Es ist die offizielle JavaScript-API von der <a href="https://www.ethereum.org/foundation">Ethereum-Foundation</a>.<br>
Darum nutzen auch wir sie und erzeugen uns nun ein <code>web3</code>-Object:</p>
<pre><code>const web3 = new Web3(ethereum);
</code></pre>
<p>Über <code>web3</code> bekommen wir wiederum ein Proxy-Object für unseren Contract. Dafür müssen wir ABI und Adresse des Contracts übergeben:</p>
<pre><code>const contract = new web3.eth.Contract(abi, "0x245eDE9dac68B84f329e21024E0083ce432700f9");
</code></pre>
<p>Mit diesem Proxy-Object können wir nun endlich unseren Contract aufrufen. Da der Aufruf über das Metamask-Plugin erfolgt, müssen wir jetzt noch sicherstellen, dass das in dem Plugin das Rinkeby-Netzwerk ausgewählt ist:</p>
<img src="https://cdn.jsdelivr.net/gh/owidder/blog@ib-20181103-05/iterablog/images/metameask-rinkeby.png" width="75%">
<pre><code>contract.getPastEvents("NewHashValue", {fromBlock: 0, toBlock: 'latest'}, function (error, events) {
...
})
</code></pre>

