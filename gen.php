<?php
$lines = file('src.sh');
#del comment
foreach ($lines as $line){
    substr($line,0,4)==='make' and $line = substr_replace($line,' -j8 ',4,0);
    $line[0]==='#' or $newlines[]=trim($line);
}
echo implode(' &&  ',$newlines);
