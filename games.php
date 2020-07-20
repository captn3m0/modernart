<?php
$A = ['E','D','C','B','A'];
$AA = ['Krypto', 'KarlGitter', 'ChristinP', 'Yoko', 'LiteMetal'];

define('NL2', "\n\n");

foreach(glob("games/*.json") as $json) {
  $data = json_decode(file_get_contents($json), true);
  ob_start();
  $firstPlayer = array_map(function($e) use ($data){
    return $e['e'];
  }, $data['first_player']);

  // How many counts for the first Round
  $playerCount = count($data['visible_count_per_round_per_artist_per_player'][0]);

  $lastPlayer = array_map(function($e) use ($data){
    return $e['e'];
  }, $data['first_player']);

  $AwardPlayedInRound = array_map(function($e) use ($data){
    return intval(substr($e['e'],-1)) - 1;
  }, $data['AwardPlayedInRound']);

  $AwardedArtistIndex = array_map(function ($e) use ($AA,$data) {
    return array_search($e['e'], $AA);
  }, $data['AwardedArtist']);

// For each of the rounds
for ($i=0; $i < 4; $i++) {
  $round = $i+1;
  echo <<<EOT

### Round ($round)

EOT;
  for ($p=0; $p<$playerCount;$p++) {
    $pp = $p+1;
    echo "Player " . $pp . " : ";
    for($a=0; $a<5; $a++) {
      $cc = $data['visible_count_per_round_per_artist_per_player'][$i][$p][$a];
      for($c=0;$c<$cc;$c++)
        echo $A[$a];
    }
    echo NL2;
  }
  $first = array_search(3, $data['ranking_score_per_artist_per_round'][$i]);
  $second = array_search(2, $data['ranking_score_per_artist_per_round'][$i]);
  $third = array_search(1, $data['ranking_score_per_artist_per_round'][$i]);

  $ranks = ['','','','',''];
  $ranks[$first] = ' (FIRST=3)';
  $ranks[$second] = ' (SECOND=2)';
  $ranks[$third] = ' (THIRD=1)';

  for($a=0;$a<5;$a++) {
    if ($data['CardsForArtist'][$i][$a] > 0)
      echo "Count(" . $A[$a].'='.$AA[$a] . ") = " . $data['CardsForArtist'][$i][$a] . $ranks[$a] . PHP_EOL. PHP_EOL;
  }

  // Awards
  $awards = [];
  for($a=0;$a<5;$a++) {
    if ($data['AwardGiven'] and $AwardPlayedInRound[$a] == $i) {
      $awards [] = $A[$a] . ">" . $AA[$AwardedArtistIndex[$a]];
    }
  }
  if (count($awards) > 0)
    echo "Awards: " . implode(", ", $awards) .PHP_EOL;
  echo "\n**Artist Scores**:".NL2;
  for($a=0;$a<5;$a++) {
    echo $AA[$a] .":".$data['ArtistScore'][$i][$a] .NL2;
  }

  echo "\n**Player Scores**" . NL2;
  for ($p=0; $p<$playerCount;$p++) {
    $pp = $p+1;
    echo "Player " . $pp . " : " . $data['RoundScore'][$i][$p] . NL2;
  }
}
echo "\n\n## Final Scores".NL2;
for ($p=0; $p<$playerCount;$p++) {
  $pp = $p+1;
  echo "Player " . $pp . " : " . $data['Score'][$p] . NL2;
}
?>

### Info

A=LiteMetal (17)
B=Yoko (18)
C=ChristinP (19)
D=KarlGitter (20)
E=Krypto (21)

Since this is a <?=$playerCount?>-player game, the maximum number of visible cards for any artist is <?=$data['MaxVisibleCards']?>
Scores for unranked artists are 0 for that round.

The syntax for awards is AwardTokenArtist > Awarded Artist (ie, the Award card for `AwardTokenArtist` was played, and the award was given to the `Awarded Artist`).
<?php

$out1 = ob_get_contents();

$output = "games/" . basename($json, '.json') . ".md";
file_put_contents($output, $out1);

echo "Writing to $output\n";

}