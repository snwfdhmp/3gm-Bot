<html>
<head>
	<title>Graph</title>
	<style type='text/css'>
	#preload-01 { background: url(img/BASE.png) no-repeat -9999px -9999px; }
	#preload-02 { background: url(img/VIDE.png) no-repeat -9999px -9999px; }
	#preload-03 { background: url(img/PA.png) no-repeat -9999px -9999px; }
		.vide {
			/*background-image: url(img/VIDE.png);*/
			background-color: black;
		}
		.base {
			/*background-image: url(img/BASE.png);*/
			background-color: white: ;
		}
		div {
			width: 3px;
			height: 3px;
			display: inline-block;
		}
	</style>
</head>
<body>
<?php
$handle=@fopen("coographfile.txt", "r"); //lecture du fichier
$i = 0;
if($handle) { //si le fichier existe
	while(($buffer=fgets($handle)) != false) { //lecture fichier ligne par ligne
		list($pseudo[$i], $x[$i], $y[$i]) = split("#", $buffer);
		$i++;
	}
	$bases_fichier = $i;
}
else {
	echo "Erreur lors de l'ouverture du fichier";
}
//GRAPH
$xi = 100;
$yi = 100;
$bases_graph = 0;
$vide_graph = 0;
$fin = 0;	
while ($fin == 0) {
	if (array_search($xi, $x) == array_search($yi, $y) && array_search($xi, $x)) {
		echo "<div class='base' id='x".$xi."y".$yi."'></div>";
		$bases_graph++;
	}
	else {
		echo "<div class='vide' id='x".$xi."y".$yi."'></div>";
		$vide_graph++;
	}
	$xi++;
	if ($xi >300) {
		echo "<br>";
		$xi = 100;
		$yi++;
	}
	if ($yi > 300) {
		$fin = 1;
	}
}
if ($bases_graph == $bases_fichier) {
	echo "0.";
}
if ($bases_graph < $bases_fichier) {
	echo $bases_graph."<.".$bases_fichier;
}
if ($bases_graph > $bases_fichier) {
	echo $bases_graph.">.".$bases_fichier;
}
$total_bases = $vide_graph+$bases_graph;
echo "end with ".$total_bases." bases.";
?>
</body>