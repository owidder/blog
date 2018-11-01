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
Man kann sie mit einem beliebigen String aufrufen. <code>logHashValue</code> erzeugt dann einen Event. Dieser enthält:</p>
<ul>
<li>Den übergebenen String</li>
<li>Die Account-Adresse des Aufrufers</li>
<li>Den Zeitstempel des Blocks, in dem der Event in der Blockchain gespeichert ist.</li>
</ul>
<h2 id="hash-mich">Hash mich</h2>
<p>Gedacht ist <code>logHashValue</code> speziell für Strings, die einen <a href="https://simple.wikipedia.org/wiki/Cryptographic_hash_function">kryptographischen Hashwert</a> (z.B. <a href="https://en.wikipedia.org/wiki/SHA-2">SHA</a>) enthalten. Denn mit dem Event liegt dieser Hashwert nun in der Blockchain und kann jederzeit und von jeder und jedem ausgelesen werden.</p>
<h2 id="das-weiß-ich-doch-schon-lange">“Das weiß ich doch schon lange”</h2>
<p>Sollten Sie z.B. mal eine kluge Idee haben, dann <a href="https://abunchofutils.com/u/computing/sha512-hash-calculator/">hashen Sie diese doch einfach</a> und rufen mit dem Hashwert die <code>logHashValue</code>-Methode des  Weisenheimer-Contract auf.<br>
Sollte dann später jemand mit der gleichen Idee kommen, können Sie beweisen, dass das ein alter Hut ist.<br>
Denn der Hashwert inklusive Zeitstempel sind in der Blockchain auf immer und ewig (oder zumindest so lange die Blockchain existiert) hinterlegt.</p>
<h2 id="dapp">DApp</h2>
<p>In <a href="https://www.iteratec.de/tech-blog/artikel/news/tldr-smart-contracts-fuer-eilige-teil-1-1/">Teil 1</a><br>
Jetzt wollen wir eine sogenannte decentralized App oder <a href="https://www.stateofthedapps.com/">“DApp”</a> (wie die coolen Kids dazu sagen) für den Contract erstellen.</p>
<h2 id="hä">Hä?</h2>
<p>Ich weiß nicht, ob es eine offizielle Definition einer DApp gibt. Aber dies hier ist die einfachste Definition, die ich kenne ist:<br>
<a href="https://ethereum.stackexchange.com/questions/383/what-is-a-dapp">DApp = Frontend + Smart Contract</a><br>
Den Smart Contract haben wir schon. Fehlt uns also nur noch ein Frontend.</p>
<h2 id="frontend-für-eilige">Frontend für Eilige</h2>
<p>In der ersten Version soll das Frontend lediglich die <code>NewHashValue</code>-Events, die der Contract produziert, in einer Tabelle anzeigen.<br>
Und wie immer haben wir es eilig. Wer weiß denn schon, wie lange dieser ganze Blockchain-Hype anhält?<br>
Deswegen besteht Frontend aus nur einem einzigen HTML-File:</p>
<pre><code>&lt;!DOCTYPE html&gt;  
&lt;html lang="en"&gt;  
&lt;head&gt;  
    &lt;meta charset="UTF-8"&gt;  
  
    &lt;title&gt;Weisenheimer&lt;/title&gt;  
  
    &lt;link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css"&gt;  
    &lt;script src="https://cdn.jsdelivr.net/gh/ethereum/web3.js@1.0.0-beta.35/dist/web3.min.js"&gt;&lt;/script&gt;  
    &lt;script src="https://cdnjs.cloudflare.com/ajax/libs/d3/5.7.0/d3.min.js"&gt;&lt;/script&gt;  
  
    &lt;style&gt;  
        table {width: 100%;}  
        td.hash {width: 40%;}  
        td.sender {width: 30%;}  
        td {word-break: break-word;}  
    &lt;/style&gt;  
&lt;/head&gt;  
&lt;body&gt;  
  
&lt;div id="container"&gt;&lt;/div&gt;  
  
&lt;script&gt;  
    (function () {  
  
        const abi = [{"constant":false,"inputs":[{"name":"hashValue","type":"string"}],"name":"logHashValue","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"","type":"string"},{"indexed":false,"name":"","type":"address"},{"indexed":false,"name":"","type":"uint256"}],"name":"NewHashValue","type":"event"}];  
  
        if (window.ethereum) {  
            const web3 = new Web3(ethereum);  
            ethereum.enable().then(function () {  
                const contract = new web3.eth.Contract(abi, "0x245eDE9dac68B84f329e21024E0083ce432700f9");  
                contract.getPastEvents("NewHashValue", {fromBlock: 0, toBlock: 'latest'}, function (error, events) {  
                    console.log(events);  
  
                    const trhead = d3.select("#container")  
                        .append("table").attr("class", "responsive-table")  
                        .append("thead")  
                        .append("tr");  
  
                    trhead.selectAll("th")  
                        .data(["Hash", "Sender", "Block no.", "Timestamp"])  
                        .enter()  
                        .append("th")  
                        .text(d =&gt; d);  
  
                    const tbody = d3.select("table").append("tbody");  
  
                    const trbody = tbody.selectAll("tr")  
                        .data(events)  
                        .enter()  
                        .append("tr");  
  
                    trbody.append("td").attr("class", "hash").text(d =&gt; d.returnValues["0"]);  
                    trbody.append("td").attr("class", "sender").text(d =&gt; d.returnValues["1"]);  
                    trbody.append("td").text(d =&gt; d.blockNumber);  
                    trbody.append("td").text(d =&gt; d.returnValues["2"]);  
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
<p>Das wollen wir nun im Einzelnen durchgehen.</p>
<h2 id="headhead">&lt;head&gt;&lt;/head&gt;</h2>
<pre><code>&lt;link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css"&gt;
&lt;script src="https://cdn.jsdelivr.net/gh/ethereum/web3.js@1.0.0-beta.35/dist/web3.min.js"&gt;&lt;/script&gt;  
&lt;script src="https://cdnjs.cloudflare.com/ajax/libs/d3/5.7.0/d3.min.js"&gt;&lt;/script&gt;
</code></pre>
<p>Wir verwenden:</p>
<ul>
<li><a href="https://materializecss.com/">Materialize</a>, weil’s dann einfach schöner aussieht</li>
<li><a href="https://github.com/ethereum/web3.js/">web3.js</a> ist die offizielle JavaScript-Library von Ethereum, mit der man Smart-Contracts aufrufen kann</li>
<li>Mit <a href="https://d3js.org/">d3.js</a> erstellen wir unsere Tabelle</li>
</ul>
<pre><code>&lt;style&gt;  
    table {width: 100%;}  
    td.hash {width: 40%;}  
    td.sender {width: 30%;}  
    td {word-break: break-word;}  
&lt;/style&gt;
</code></pre>
<p>Nur ein paar CSS-Styles für die Tabelle.</p>

