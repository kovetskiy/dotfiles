<?php

header('Content-Type: text/plain; charset=utf-8');

$directory = '/tmp/once';
$identifier = basename($_SERVER['QUERY_STRING']);

if (!trim($identifier)) {
    exit('wtf');
}

$path = $directory . '/' . $identifier;

if (!file_exists($path)) {
    exit('not found');
}

$contents = file_get_contents($path);

unlink($path);

echo $contents;
