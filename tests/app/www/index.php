<?php

$name = 'you';

if (isset($_GET['name'])) {
    $name = $_GET['name'];
}

?>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <title>FPM test</title>
</head>
<body>
<h1>FPM test </h1>

<p>Hello <?php echo $name; ?></p>

<p>Say hello to <a href="index.php?name=Bob">Bob</a>.</p>

</body>
</html>
