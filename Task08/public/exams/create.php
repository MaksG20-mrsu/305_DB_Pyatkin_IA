<?php
require_once __DIR__ . '/../../src/db.php';
$pdo = require __DIR__ . '/../../src/db.php';

$studentId = $_GET['student_id'] ?? $_POST['student_id'] ?? null;
if (!$studentId) die('Нет student_id');

$stmt = $pdo->prepare("
    SELECT g.program, g.graduation_year
    FROM students s
    JOIN groups g ON s.group_id = g.id
    WHERE s.id = ?
");
$stmt->execute([$studentId]);
$studentInfo = $stmt->fetch();

if (!$studentInfo) {
    die('Студент не найден');
}

$program = $studentInfo['program'];
$gradYear = $studentInfo['graduation_year'];

if ($_POST) {
    $stmt3 = $pdo->prepare("SELECT id FROM disciplines WHERE name = ? AND program = ?");
    $stmt3->execute([$_POST['discipline'], $program]);
    $disc = $stmt3->fetch();

    if (!$disc) die('Дисциплина не найдена');

    $stmt4 = $pdo->prepare("
        INSERT INTO exam_results (student_id, discipline_id, exam_date, grade)
        VALUES (?, ?, ?, ?)
    ");
    $stmt4->execute([
        $studentId,
        $disc['id'],
        $_POST['exam_date'],
        $_POST['grade']
    ]);

    header("Location: read.php?student_id=$studentId");
    exit;
}

$stmt2 = $pdo->prepare("SELECT name, course FROM disciplines WHERE program = ? ORDER BY course, name");
$stmt2->execute([$program]);
$disciplines = $stmt2->fetchAll();
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Добавить экзамен</title>
</head>
<body>
    <h2>Добавить экзамен для студента</h2>
    <form method="POST">
        <input type="hidden" name="student_id" value="<?= $studentId ?>">
        <p>
            <label>Дата сдачи:<br>
                <input type="date" name="exam_date" required>
            </label>
        </p>
        <p>
            <label>Дисциплина:<br>
                <select name="discipline" required>
                    <?php foreach ($disciplines as $d): ?>
                        <option value="<?= htmlspecialchars($d['name']) ?>">
                            <?= htmlspecialchars($d['name']) ?> (курс <?= $d['course'] ?>)
                        </option>
                    <?php endforeach; ?>
                </select>
            </label>
        </p>
        <p>
            <label>Оценка:<br>
                <select name="grade" required>
                    <option value="2">2 (неудовлетворительно)</option>
                    <option value="3">3 (удовлетворительно)</option>
                    <option value="4">4 (хорошо)</option>
                    <option value="5">5 (отлично)</option>
                </select>
            </label>
        </p>
        <button type="submit">Сохранить</button>
        <a href="read.php?student_id=<?= $studentId ?>">Отмена</a>
    </form>
</body>
</html>