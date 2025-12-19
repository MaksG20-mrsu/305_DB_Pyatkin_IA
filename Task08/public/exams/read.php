<?php
require_once __DIR__ . '/../../src/db.php';
$pdo = require __DIR__ . '/../../src/db.php';

$studentId = $_GET['student_id'] ?? null;
if (!$studentId) die('Нет student_id');

$stmt = $pdo->prepare("SELECT full_name FROM students WHERE id = ?");
$stmt->execute([$studentId]);
$student = $stmt->fetch();

if (!$student) {
    die('Студент не найден');
}

$stmt2 = $pdo->prepare("
    SELECT e.id, d.name, e.exam_date, e.grade
    FROM exam_results e
    JOIN disciplines d ON e.discipline_id = d.id
    WHERE e.student_id = ?
    ORDER BY e.exam_date
");
$stmt2->execute([$studentId]);
$exams = $stmt2->fetchAll();
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Экзамены студента</title>
</head>
<body>
    <h2>Экзамены: <?= htmlspecialchars($student['full_name']) ?></h2>
    <table border="1" style="margin: 1rem 0;">
        <tr>
            <th>Дисциплина</th>
            <th>Дата</th>
            <th>Оценка</th>
            <th>Действия</th>
        </tr>
        <?php foreach ($exams as $e): ?>
            <tr>
                <td><?= htmlspecialchars($e['name']) ?></td>
                <td><?= $e['exam_date'] ?></td>
                <td><?= $e['grade'] ?></td>
                <td>
                    <a href="update.php?id=<?= $e['id'] ?>&student_id=<?= $studentId ?>">Редактировать</a> |
                    <a href="delete.php?id=<?= $e['id'] ?>&student_id=<?= $studentId ?>" onclick="return confirm('Удалить экзамен?')">Удалить</a>
                </td>
            </tr>
        <?php endforeach; ?>
    </table>
    <p>
        <a href="create.php?student_id=<?= $studentId ?>">Добавить экзамен</a> |
        <a href="../students/read.php">← Назад</a>
    </p>
</body>
</html>