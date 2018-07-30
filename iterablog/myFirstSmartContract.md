
# TL;DR: Smart Contracts für Faulpelze

Wenn [Blockchains](https://www.theguardian.com/commentisfree/2018/feb/06/blockchain-explained-by-crypto-expert-f-onthemoon) eine Art von [verteilten Datenbanken](https://www.iteratec.de/tech-blog/artikel/news/wie-funktioniert-eigentlich-die-blockchain/) sind, dann sind [Smart Contracts](https://www.iteratec.de/tech-blog/artikel/news/wie-funktioniert-eigentlich-die-blockchain-teil-2-smart-contracts-die-businesslogik-von-blockchai/) ihre Stored Procedures. Sie bieten Funktionen an, die man aufrufen kann und die Daten in der Blockchain ablegen können.

Und glaubt man den Expertinnen (oder meinem [Kollegen](https://www.iteratec.de/tech-blog/artikel/news/wie-funktioniert-eigentlich-die-blockchain-teil-4-die-blockchain-im-einsatz-1/)), dann könnten Smart Contracts  [Märkte verändern](http://www.zhiguohe.com/uploads/1/0/6/9/106923057/bdsc.pdf).

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
 Was liegt also näher, als alle klugen Gedanken einfach in der Blockchain zu veröffentlichen? Dann sind Zeitpunkt und Inhalt unwiderruflich festgehalten.
 Und da Speicher in der Blockchain etwas kostet, hashen ([SHA512](https://abunchofutils.com/u/computing/sha512-hash-calculator/)) wir vorher und legen nur den Hashwert ab.

## Pacta sunt servanda
Unser Smart Contract soll so einfach wie nur möglich sein. Wir beschränken uns auf eine einzige Funktion:

 - `logHashValue(string hashValue)` :  Veröffentlicht in der Blockchain einen Hashwert.

Das ist alles. Mehr brauchen wir nicht.

Jetzt noch ein Name für unseren Contract: [Weisenheimer](https://www.urbandictionary.com/define.php?term=weisenheimer)
und hier [ist er auch schon](https://github.com/owidder/iteraBlog/blob/master/weisenheimer/contract/Weisenheimer.sol):

    pragma solidity ^0.4.19;
    contract Weisenheimer {

	    event NewHashValue(string, address, uint);

	    function logHashValue(string hashValue) public {    
		    emit NewHashValue(hashValue, msg.sender, block.timestamp);
	    }
    }

Zugegeben. So richtig smart sieht der nicht aus. Erfüllt aber seinen Zweck:

Die Programmiersprache nennt sich [*Solidity*](https://github.com/ethereum/solidity) und ist speziell für Smart Contracts gedacht.  
Die Funktion *logHashValue* erzeugt einen Logeintrag mit den Hashwert, der Adresse des Accounts, von dem die Funktion aufgerufen wurde und der Zeitstempel des Blogs, in die Transaktion des Aufrufes ein für alle Mal in der Blockchain festgehalten wird.
Die Funktion ist *public* ohne Einschränkung, d.h. sie darf von jedem Ethereum Account aufgerufen werden.

## Wallets
Um unseren Smart Contract *Weisenheimer* in der Ethereum Blockchain zu deployen, brauchen wir einen Account und *Ether*, die Währung bei Ethereum. 

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
Da gibt es einmal das *Main Net*. Da spielen die Big Girls'n'Boys. Da kosten Ether echtes Geld, [und zwar gar nicht mal so wenig](https://coinmarketcap.com/currencies/ethereum/). Das wollen wir nicht.

Zum Glück gibt es noch einige Test-Networks. Da gibt es Ether für lau (free lunch). Das wollen wir!
Für unser kleines Beispiel nehmen wir das [Rinkeby Test-Network](https://www.rinkeby.io).
Dazu wählen wir in Metamask das Rinkeby-Network aus:

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180728-03/iterablog/images/metamask-rinkeby.png" alt="Rinkeby auswählen" width="300px"/>

Metamask hat uns auch schon freundlicherweise einen Account angelegt. Solange wir aber keine Transaktion mit diesem Account durchgeführt haben, ist der in dem Network nicht bekannt.

## Wenn ich einmal reich wär
Mit 0 Ether (ETH) ist unser Account leider ziemlich arm :(

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180728-04/iterablog/images/0-eth.png" alt="Rinkeby auswählen"/>

Aber im Gegensatz zum Main Net bekommen wir auf Rinkeby die Ether geschenkt. Bzw. fast. Ein klein wenig müssen wir schon tun.

## Geld zapfen
Wir gehen zur offiziellen [Faucet von Rinkeby](https://faucet.rinkeby.io/):

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-01/iterablog/images/faucet.png" alt="Rinkeby Faucet"/>

Dort bekommen wir Ether geschenkt. Dafür müssen wir die Adresse unseres Accounts auf Twitter, Google+ oder Facebook posten und die URL des Posts in das Eingabefeld kopieren. 

Dann können wir uns entscheiden, wieviel Ether wir wollen. Je nachdem können wir dann auch erst in 8 Stunden, einem oder drei Tagen wieder im Ether betteln.

Die Adresse unseres Accounts können wir uns aus unserem Metamask-Wallet kopieren (3 Punkte neben dem Account-Namen *Account 1*):

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-02/iterablog/images/copy-address.png" alt="Rinkeby Faucet"/>

(Übrigens: Den Namen ihres Account können Sie auch ändern. Klicken Sie dafür einfach auf *edit* direkt über dem Namen)

Jetzt müssen Sie sich entscheiden, auf welchem Social Network Sie die Adresse posten wollen. Sie können dafür auch einen eigen Account anlegen. Nicht dass Sie [reihenweise Follower verlieren](http://s3.media.squarespace.com/production/2129687/19317774/.a/6a00d8341d3df553ef016763cc8111970b-pi).

Ich nehme dafür in der Regel meinen Google+-Account. Den nutze ich sonst kaum. Die paar Follower, wundern sich zwar jedes Mal ("Steuerst Du ein Botnet?"), aber damit muss ich leben.

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-03/iterablog/images/googleplus.png" alt="Rinkeby Faucet"/>

Jetzt den Link des Posts in das Eingabefeld des Faucets kopieren. Heute lassen wir es mal krachen und nehmen gleich die vollen 18,75 Ether.

 <img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-03/iterablog/images/faucet2.png" alt="Rinkeby Faucet"/>

Und siehe da. Wir sind reich.

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-04/iterablog/images/1875.png" alt="Wir sind reich"/>

Freuen Sie sich aber nicht zu früh. Die 8273,06 Dollar gelten nur für das Main-Net. Für Runkeby müssen sie davon 8273,06 Dollar abziehen.

## Submission accomplished
So jetzt kann es losgehen. Wir können jetzt unseren Contract in der Blockchain deployen. Dazu gehen wir zu der Online-Ethereum-IDE [*remix*](https://remix.ethereum.org).

Mit dem kleinen Plus-Zeichen oben links können wir eine neue Datei anlegen. Wir nennen sie *Weisenheimer*.

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-05/iterablog/images/new-file.png" alt="Neue Datei"/>

Jetzt öffnet sich ein neuer Tab, in den wir den Code des Contracts kopieren können.

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-06/iterablog/images/new-tab.png" alt="Neuer Tab"/>

Im *Compile*-Tab auf der rechten Seite können wir den Code schon einmal compilieren.

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-07/iterablog/images/compile.png" alt="Compile"/>

Bei den 2 Warnings wenden wir einen alten Developer-Trick an: Wir ignorieren sie.

Im Run-Tab daneben, wählen wir nun *Injected Web3* als *Environment* aus.

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-08/iterablog/images/environment.png" alt="Environment"/>

Das bedeutet, dass ein Objekt namens *Web3*, das von aussen in die Web-Seite injiziert wurde. In unserem Fall von dem Browser-Plug-in *Metamask*. *Web3* ist eine sehr populäre JavaScript-Library zum Aufrufen von Ethereum-Contracts. 

Damit können wir die Transaktion zum Deployment des Contracts über *Metamask* ausführen.

Wenn Sie bei angemeldet sind (ansonsten sollten Sie das jetzt tun), sollten Sie nun den in Metamask ausgewählten Account sehen.

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-09/iterablog/images/injected-web3.png" alt="Injected Web"/>

Jetzt wird's ernst. Über den ![enter image description here](https://raw.githubusercontent.com/owidder/blog/ib-20180729-10/iterablog/images/deploy.png) Button können Sie nun das Deployment des Contracts starten.

Jetzt kommt es darauf an, welchen Browser Sie verwenden:

 - Im Chrome öffnet sich auf der linken Seite ein Metamask-Fenster, in dem Sie die Transaktion bestätigen können.
 - Im Firefox kann es sein (so war es bei mir), dass sich auf der linken Seite ein leeres Fenster öffnet. Das können Sie wieder schließen. Über das Fuchs-Icon (dort sollte nun eine kleine 1 erscheinen ![enter image description here](https://raw.githubusercontent.com/owidder/blog/ib-20180729-11/iterablog/images/fox1.png)) sollten Sie das Fenster zum Bestätigen der Transaktion sehen können.

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-12/iterablog/images/confirm-transaction02.png" alt="Confirm Transaction"/>

Jetzt nur noch *Submit* und das war's.

In der Konsole (Mitte, unten) sehen Sie nach ein paar Sekunden (wenn die Transaktion es in die Blockchain geschafft hat) einen Link zu der Transaktion.

 <img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-12/iterablog/images/etherscan-link.png" alt="Transaction Link"/>

Der Link führt zu [*Etherscan*](https://rinkeby.etherscan.io/), eine Art Ethereum-Browser für Transaktionen, Contracts, etc. (Main-Net und Test-Networks). Dort sehen wir die [Transaktion unseres Deployments](https://rinkeby.etherscan.io/tx/0xa333ed34de134d66f64fbeb3ed70d24c5e88d3e105454de35ec61c712f683d05).

 <img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-12/iterablog/images/etherscan-transaction.png" alt="Transaction"/>

Dort finden wir auch den Link zu unserem Contract:

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-13/iterablog/images/contract-link.png" alt="Contract Link"/>

Er führt uns zu der [Etherscan-Seite des Contracts](https://rinkeby.etherscan.io/address/0x245ede9dac68b84f329e21024e0083ce432700f9).

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-13/iterablog/images/etherscan-contract.png" alt="Contract Site"/>

Nun sollen ja andere unseren Contract aufrufen. Aber woher sollen sie wissen, was der Contract. Wir können ja viel erzählen.

## Show me the code
Dafür kann man in Etherscan den Code zu einem Contract hinterlegen. Etherscan verifiziert, dass dies wirklich korrekt ist.

Im Tab *Code* gibt es den Link *Verify And Publish*.

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-13/iterablog/images/verify-n-publish.png" alt="Verify And Publish"/>

Dort müssen wir folgendes eintragen:

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180729-13/iterablog/images/verify-form.png" alt="Compiler Version"/>

 - Adresse des Contract (ist schon vorausgefüllt)
 - Name des Contract
 - Compiler-Version: Kann man in *remix* im *Settings*-Tab auf der rechten Seite sehen
<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180730-01/iterablog/images/compiler-version.png" alt="Verify Form"/>
 - Zum Schluss müssen wir noch angeben, ob der Compiler mit Optimierung lief. Auch das sieht man im Settings-Tab. War ausgeschaltet (hätten wir vielleicht mal einschalten sollen - nächstes Mal)
<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180730-02/iterablog/images/settings.png" alt="Settings"/>

Jetzt nur noch ganz runter scrollen, versichern dass man kein Roboter ist (wer kann das schon mit Sicherheit von sich sagen?) und den großen blauen Knopf drücken.

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180730-03/iterablog/images/verify-button.png" alt="Verify Button"/>

Nun kann das ein klein wenig dauern, aber dann gibt es eine Bestätigung.

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180730-03/iterablog/images/verify-result.png" alt="Verify Result"/>

Und wenn man jetzt wieder neu auf die [Seite des Contracts](https://rinkeby.etherscan.io/address/0x245ede9dac68b84f329e21024e0083ce432700f9#code) geht, sieht man einen schönen grünen Haken im Code-Tab.

<img src="https://raw.githubusercontent.com/owidder/blog/ib-20180730-03/iterablog/images/green-check.png" alt="Green Check"/>


<!--stackedit_data:
eyJoaXN0b3J5IjpbMTEzMjc3Nzc3NiwtMzYxOTE1NTA1LC03Mj
gzNzg3MTksLTEyNDEyNzk4NTgsLTExNTEzOTQ4OCwtMTk4NjI0
ODExMCwtODc1ODE5OTg0LDEzMjEzNzc1MTQsNTQ2NTI3NzI4LD
QxMDE4ODkzMiwtOTk5MTIwOTQ4LDg3ODU1MzU1LDEwMzM3MzQ3
MzUsODc0MDU5OTIyLDE0MDQxOTkxOCwxNjQ3NDUyNjY4LDExND
Q1NDc5NjYsLTE3NzIxMDAyNDQsLTIwMzcwNDEyNjMsMTM2NDEy
NTFdfQ==
-->