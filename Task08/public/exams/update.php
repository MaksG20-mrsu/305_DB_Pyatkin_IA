<?php
require_once __DIR__ . '/../../src/db.php';
$pdo = require __DIR__ . '/../../src/db.php';

$id = $_GET['id'] ?? null;
$studentId = $_GET['student_id'] ?? $_POST['student_id'] ?? null;
if (!$id || !$studentId) {
    die('Нет id или student_id');
}

if ($_POST) {
    $stmt1 = $pdo->prepare("
        SELECT g.program 
        FROM students s 
        JOIN groups g ON s.group_id = g.id 
        WHERE s.id = ?
    ");
    $stmt1->execute([$studentId]);
    $programRow = $stmt1->fetch();
    if (!$programRow) die('Студент не найден');
    $program = $programRow['program'];

    $stmt2 = $pdo->prepare("SELECT id FROM disciplines WHERE name = ? AND program = ?");
    $stmt2->execute([$_POST['discipline'], $program]);
    $disc = $stmt2->fetch();

    if (!$disc) {
        die('Дисциплина не найдена');
    }

    $stmt3 = $pdo->prepare("
        UPDATE exam_results 
        SET discipline_id = ?, exam_date = ?, grade = ?
        WHERE id = ?
    ");
    $stmt3->execute([
        $disc['id'],
        $_POST['exam_date'],
        $_POST['grade'],
        $id
    ]);

    header("Location: read.php?student_id=$studentId");
    exit;
}

$stmt4 = $pdo->prepare("
    SELECT e.exam_date, e.grade, d.name AS discipline_name
    FROM exam_results e
    JOIN disciplines d ON e.discipline_id = d.id
    WHERE e.id = ?
");
$stmt4->execute([$id]);
$exam = $stmt4->fetch();

if (!$exam) {
    die('Экзамен не найден');
}

$stmt5 = $pdo->prepare("
    SELECT g.program 
    FROM students s 
    JOIN groups g ON s.group_id = g.id 
    WHERE s.id = ?
");
$stmt5->execute([$studentId]);
$programRow = $stmt5->fetch();
if (!$programRow) die('Студент не найден');
$program = $programRow['program'];

$stmt6 = $pdo->prepare("
    SELECT name FROM disciplines WHERE program = ? ORDER BY course, name
");
$stmt6->execute([$program]);
$disciplines = $stmt6->fetchAll();
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Редактировать экзамен</title>
</head>
<body>
    <h2>Редактировать экзамен</h2>
    <form method="POST">
        <input type="hidden" name="student_id" value="<?= htmlspecialchars($studentId) ?>">
        <p>
            <label>Дата сдачи:<br>
                <input type="date" name="exam_date" value="<?= htmlspecialchars($exam['exam_date']) ?>" required>
            </label>
        </p>
        <p>
            <label>Дисциплина:<br>
                <select name="discipline" required>
                    <?php foreach ($disciplines as $d): ?>
                        <option value="<?= htmlspecialchars($d['name']) ?>" 
                            <?= $d['name'] === $exam['discipline_name'] ? 'selected' : '' ?>>
                            <?= htmlspecialchars($d['name']) ?>
                        </option>
                    <?php endforeach; ?>
                </select>
            </label>
        </p>
        <p>
            <label>Оценка:<br>
                <select name="grade" required>
                    <?php for ($g = 2; $g <= 5; $g++): ?>
                        <option value="<?= $g ?>" <?= $g == $exam['grade'] ? 'selected' : '' ?>><?= $g ?></option>
                    <?php endfor; ?>
                </select>
            </label>
        </p>
        <button type="submit">Сохранить</button>
        <a href="read.php?student_id=<?= htmlspecialchars($studentId) ?>">Отмена</a>
    </form>
</body>
</html>