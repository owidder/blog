
# TL;DR: Smart Contracts für Faulpelze

Wenn [Blockchains](https://www.theguardian.com/commentisfree/2018/feb/06/blockchain-explained-by-crypto-expert-f-onthemoon) eine Art von [verteilten Datenbanken](https://www.iteratec.de/tech-blog/artikel/news/wie-funktioniert-eigentlich-die-blockchain/) sind, dann sind [Smart Contracts](https://www.iteratec.de/tech-blog/artikel/news/wie-funktioniert-eigentlich-die-blockchain-teil-2-smart-contracts-die-businesslogik-von-blockchai/) ihre Stored Procedures. Sie bieten Funktionen an, die man aufrufen kann und die Daten in der Blockchain ablegen können.

Und glaubt man den Experten (oder meinem [Kollegen](https://www.iteratec.de/tech-blog/artikel/news/wie-funktioniert-eigentlich-die-blockchain-teil-4-die-blockchain-im-einsatz-1/)), dann könnten Smart Contracts  [Märkte verändern](http://www.zhiguohe.com/uploads/1/0/6/9/106923057/bdsc.pdf).

## Es nützt also nix...
... wir müssen selber einen Smart Contract erstellen. Erst dann können wir auch [mit den wirklich coolen Kids mitreden](https://cointrends.top/news/view/the-new-erc223-token-standard). Aber da wir auch besseres zu tun haben, wollen wir es uns so einfach wie möglich machen und nur online Tools verwenden.

## Unsere eigene Währung...
... wollen wir aber nicht. Auf [Ethereum](https://www.ethereum.org/) - die älteste und größte der Blockchains, die Smart Contracts anbieten - gibt es jede Menge Contracts, die ihren eigenen Coin implementieren. Dafür gibt es auch extra Standards ([ERC20](https://en.wikipedia.org/wiki/ERC20) bzw. [ERC223](https://cointrends.top/news/view/the-new-erc223-token-standard)). Und so ein ERC20-Contract [muss gar nicht mal so groß sein](https://github.com/bitfwdcommunity/Issue-your-own-ERC20-token/blob/master/contracts/erc20_tutorial.sol).
Wir aber wollen es aber noch viel einfacher.

## "Das habe ich doch schon vor 10 Jahren gesagt!"
Kennen Sie das? Sie sagen irgend etwas richtig kluges und keiner weiß das zu würdigen. Jahre später kommt irgendwer daher, sagt das gleiche und wird umjubelt.
Wir wäre es, wenn Sie jetzt beweisen könnten, dass Sie das schon vor Jahren gesagt haben?
Aber wie? 
Sie könnten natürlich alle Ihre klugen Äußerungen schon mal vorsorglich im Web veröffentlich und dann später über [archive.org](https://archive.org/) beweisen, wie klug Sie schon vor Jahren waren.
Aber sind wir mal ehrlich. Finden unsere genialen Ideen keine Resonanz, sind meistens die Ideen schuld. 
Also vielleicht doch nicht alles schon mal prophylaktisch veröffentlichen.
 
 ## Marmor, Stein und Eisen bricht, aber eine Blockchain nicht
 Was liegt also näher, als alle klugen Gedanken einfach in die Blockchain zu schreiben. Dann sind Zeitpunkt und Inhalt unwiderruflich festgehalten.
 Und da Speicher in der Blockchain etwas kostet, hashen ([SHA512](https://abunchofutils.com/u/computing/sha512-hash-calculator/)) wir vorher und legen nur den Hashwert ab.

## Pacta sunt servanda
Unser Smart Contract soll so einfach wie nur möglich sein. Wir beschränken uns auf eine einzige Funktion:

 - `logHashValue(string hashValue) public returns(bool)` :  Veröffentlicht in der Blockchain einen Hashwert ().

Ist das alles? 
Ja, es ist. Denn alle Informationen, wie 
- welcher Account hat den Hashwert veröffentlicht?
- wann w


## Wallets
Um unseren Smart Contract in der Ethereum Blockchain zu deployen, brauchen wir einen Account und *Ether*, die Währung bei Ethereum. 

*There is no free lunch*

Jede Transaktion bei Ethereum - und das Deployen eines Contracts ist auch eine Transaktion - kostet Ether. Und Ether kosten normalerweise [echtes Geld](https://www.coindesk.com/ethereum-price/) (aber seien Sie beruhigt, für unser kleines Beispiel brauchen Sie kein Geld auszugeben).

Das Verwalten von Accounts und Starten von Transaktionen geht am Einfachsten über ein *Wallet*.

Wir verwenden dafür das Browser-Plug-in [Metamask](https://metamask.io/).
Die Installation erfolgt über den [Chrome Web Store](https://chrome.google.com/webstore/search/metamask) oder über [Firefox Add-ons](https://addons.mozilla.org/firefox/search/?q=metamask).
Nach dem Starten (kleiner Fuchs neben dem Address Bar <img src="https://raw.githubusercontent.com/owidder/blog/ib-20180728-02/iterablog/images/fuchs.png" height="25px"/>) muss man zunächst mal ein Wallet erzeugen:

<img src="https://raw.githubusercontent.com/owidder/blog/ib20180728-01/iterablog/images/metamask-sign-in.png" alt="Wallet erzeugen" width="300px"/>

Danach sehen Sie 12 Worte, die sogenannten *Mnenomics*. Das ist der Schlüssel zum Königreich ihres Wallets. Sollten Sie also vorhaben, echte Ether für echtes Geld zu kaufen (wie gesagt: für unser kleines Beispiel brauchen Sie das nicht), dann sollten Sie diese 12 Worte **seeeeeeehr** sicher aufbewahren.

## And there is a free lunch!!!
Als nächstes müssen wir uns entscheiden, auf welchem Ethereum Network wir unseren Contract deployen wollen. 
Da gibt es einmal das *Main Net*. Da spielen die Big Girls'n'Boys. Da kosten Ether echtes Geld. Das wollen wir nicht.
Zum Glück gibt es noch einige Test-Networks. Da gibt es Ether für lau (free lunch). Das wollen wir!
Für unser kleines Beispiel nehmen wir das [Rinkeby Test-Network](https://www.rinkeby.io).
Dazu wählen wir in Metamask das Rinkeby-Network aus:

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180728-03/iterablog/images/metamask-rinkeby.png" alt="Rinkeby auswählen" width="300px"/>

Metamask hat uns auch schon freundlicherweise einen Account angelegt. Solange wir aber keine Transaktion mit diesem Account durchgeführt haben, ist der in dem Network nicht bekannt.

## Wenn ich einmal reich wär
Unser Account ist leider ziemlich arm :(

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180728-04/iterablog/images/0-eth.png" alt="Rinkeby auswählen" width="300px"/>

Aber im Gegensatz zum Main Net bekommen wir auf Rinkeby die Ether geschenkt. Bzw. fast. Ein wenig müssen wir schon tun.
<!--stackedit_data:
eyJoaXN0b3J5IjpbMjA5NTk3NTQ3MSwtNzg1NzAyOTg2LDMxMz
gyNDQ2OSwxMDYxNzM2OTQxLC05NDQyMTQ4ODQsNzYyNzEwMzE4
LDEwNDM1MjI3MDIsLTE2NTIyOTU1MjMsLTIwMzMyNjgxODcsOD
Y5MTczNDEyLDE1MDk5MTc3MTYsMTA5MTk5MzQzMCwtMTM1MzMx
OTYyNywxNzMyNjg2MDEwLC01MTQ4MzcxMTEsLTE0ODc0MTkyMT
MsLTE2MTE0NTQ4MzYsOTY1Njg5ODA1LDQ5MDcwNzE2MiwtODU1
NDg4MzhdfQ==
-->