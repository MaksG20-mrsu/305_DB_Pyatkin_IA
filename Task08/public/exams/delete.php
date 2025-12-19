<?php
require_once __DIR__ . '/../../src/db.php';
$pdo = require __DIR__ . '/../../src/db.php';

$id = $_GET['id'] ?? null;
$studentId = $_GET['student_id'] ?? null;

if ($id) {
    $pdo->prepare("DELETE FROM exam_results WHERE id = ?")->execute([$id]);
}

if ($studentId) {
    header("Location: read.php?student_id=$studentId");
} else {
    header("Location: ../students/read.php");
}
exit;