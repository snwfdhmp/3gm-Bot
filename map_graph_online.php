<html>
<head>
	<title>Graph</title>
	<style type='text/css'>
	/*#preload-01 { background: url(img/BASE.png) no-repeat -9999px -9999px; }
	#preload-02 { background: url(img/VIDE.png) no-repeat -9999px -9999px; }
	#preload-03 { background: url(img/PA.png) no-repeat -9999px -9999px; }*/
		body {
			text-align:center;
		}
		.vide {
			/*background-image: url(img/VIDE.png);*/
			background-color: rgb(107,83,49);
		}
		.base {
			/*background-image: url(img/BASE.png);*/
			background-color: rgb(253,255,222);
		}
		div {
			display: inline-block;
		}
		td {
		    width:auto;
		    height:auto;
		}
		table {
			border-collapse: collapse;
			width:600px;
			height:600px;
			background-color: rgb(107,83,49);
		}
		#tableContainer {
			padding: 10px;
			background-color: rgb(107,83,49);
			border-radius:5px;
		}
		#infos {
			position: absolute;
			display:hidden;
			background-color:rgb(21,21,21);
			border-radius: 5px;
		}
		#infosList {
			list-style-type: none;
			padding-left: 30px;
			padding-right: 30px;
			padding-top:0px;
			padding-bottom: 0px;
			text-align: center;
			margin-top:2px;
			margin-bottom:2px;
			color:white;
		}
		#pseudo{
			color:rgb(230,222,160);
			display:inline-block;
		}
		#coor {
			color:rgb(207,195,133);
		}
		#points {
			display:inline-block;
			color:rgb(207,195,133);
		}
		#nomBase {
			font-size : 12px;
		}
		#ally {
			font-size:12;
			color:rgb(147,125,73);
		}
		#typeBase {
			border: 5px dotted blue;
		}
		#typePA {
			border: 5px dotted blue;
		}
	</style>
</head>
<body onload="afficherBases()">
	<script type = "text/javascript">
		// FONCTION NEEDED
	function systemString (my_string) {
		my_string = String(my_string);
		var new_string = "";
		var pattern_accent = new Array("é", "è", "ê", "ë", "ç", "à", "â", "ä", "î", "ï", "ù", "ô", "ó", "ö");
		var pattern_replace_accent = new Array("e", "e", "e", "e", "c", "a", "a", "a", "i", "i", "u", "o", "o", "o");
		if (my_string && my_string!= "") {
			new_string = preg_replace (pattern_accent, pattern_replace_accent, my_string);
		}
		new_string = new_string.replace(/ /g,'_');
		new_string = new_string.replace(/'/g,'_');
		new_string = new_string.toLowerCase();
		return new_string;
}
	</script>
<?php
$pathToFile = $_GET["path"];
file_put_contents("cooGraphDown.txt", fopen($pathToFile, 'r'));
$handle=@fopen("cooGraphDown.txt", "r"); //lecture du fichier
$i = 0;
if($handle) { //si le fichier existe
	while(($buffer=fgets($handle)) != false) { //lecture fichier ligne par ligne
		list($pseudo[$i], $x[$i], $y[$i], $points[$i], $nomBase[$i], $typeBase[$i], $alliance[$i]) = str_replace("\n", "", split("#", $buffer));
		//pseudo#x#y#points#nomDeBase#type#alliance
		$i++;
	}
	$bases_fichier = $i;
}
else {
	echo "Erreur lors de l'ouverture du fichier";
}
//GRAPH
//1. Dessiner le tableau
echo "<div id='tableContainer'><table><tr>";
$i = 100;
$j = 100;
while ($j <= 300) {
	echo "<td id='x".$i."y".$j."' class='vide'>";
	echo "</td>";
	$i++;
	if ($i>300) {
		$i = 100;
		$j++;
		echo "</tr><tr>";
	}
}
echo "</table></div>";
echo "<script type='text/javascript'>\nfunction afficherBases1() {\n";
$i = 0;
$n = 1;
foreach ($x as $xi => $xf) {
	echo "var cell".($xi-($n-1)*60)." = document.getElementById('x".$xf."y".$y[$xi]."');\n";
	echo "cell".($xi-($n-1)*60).".className = 'base';\n";
	echo "cell".($xi-($n-1)*60).".onmouseover = function(){afficherInfos('".$pseudo[$xi]."','".$xf."','".$y[$xi]."','".$points[$xi]."','".$nomBase[$xi]."','".$typeBase[$xi]."','".$alliance[$xi]."');}\n";
	$i++;
	if ($i > 60) {
		$n++;
		echo"}\n</script>\n<script type='text/javascript'>\nfunction afficherBases".$n."() {";
		$i=0;
	}
}
echo "}\n</script>";
?>
<script type="text/javascript">
	function afficherBases() {
		afficherBases1();
		afficherBases2();
		afficherBases3();
		afficherBases4();
		afficherBases5();
		afficherBases6();
		afficherBases7();
		afficherBases8();
		afficherBases9();
		afficherBases10();	
	var i;
	var tds = document.getElementsByTagName("td")
	for(i=0; i<tds.length;++i) {
		tds[i].onmouseover = afficherInfos(this)
	}
	}
</script>
<script type="text/javascript">
	//pseudo#x#y#	
	function afficherInfos(p, x, y, points, nom, type, ally) {
		var infos = document.getElementById("infos")
		if (type == 0) {
			nom += " (BASE)"
		}
		if (type == 1) {
			nom += " (PA)"
		}
		if (type == 2) {
			nom += " (INACTIF)"
		}
		if(ally == "Ennemi Intérieur") {
			ally = "Ennemi Int&eacute;rieur"
		}
		document.getElementById("pseudo").innerHTML = p;
		document.getElementById("coor").innerHTML = "["+x+";"+y+"]";
		document.getElementById("points").innerHTML = "("+points+")";
		document.getElementById("nomBase").innerHTML = nom;
		document.getElementById("ally").innerHTML = ally;
		var e = window.event;
		var posX = e.clientX;
		var posY = e.clientY;
		infos.style.display = "inline";
		infos.style.top = posY-10;
		infos.style.left = posX+10;
	}
</script>
<div id="infos">
	<ul id="infosList">
		<li id="pseudo"></li>
		<li id="points"></li>
		<li id="nomBase"></li>
		<li id="ally"></li>
		<li id="coor"></li>
	</ul>
</div>
</body>