DROP TABLE IF EXISTS work_records;
DROP TABLE IF EXISTS appointment_services;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS schedules;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS employees;

CREATE TABLE employees (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    position TEXT NOT NULL,
    hire_date TEXT NOT NULL CHECK(hire_date = strftime('%Y-%m-%d', hire_date)),
    dismissal_date TEXT CHECK(dismissal_date = strftime('%Y-%m-%d', dismissal_date)),
    salary_percentage REAL NOT NULL CHECK(salary_percentage BETWEEN 0 AND 100),
    status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('active', 'fired')),
    phone TEXT,
    email TEXT
);

CREATE TABLE services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    duration_minutes INTEGER NOT NULL CHECK(duration_minutes > 0),
    price REAL NOT NULL CHECK(price >= 0)
);

CREATE TABLE schedules (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    day_of_week INTEGER NOT NULL CHECK(day_of_week BETWEEN 1 AND 7),
    start_time TEXT NOT NULL CHECK(start_time = strftime('%H:%M', start_time)),
    end_time TEXT NOT NULL CHECK(end_time = strftime('%H:%M', end_time)),
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
);

CREATE TABLE appointments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    client_name TEXT NOT NULL,
    client_phone TEXT,
    appointment_date TEXT NOT NULL CHECK(appointment_date = strftime('%Y-%m-%d', appointment_date)),
    appointment_time TEXT NOT NULL CHECK(appointment_time = strftime('%H:%M', appointment_time)),
    status TEXT NOT NULL DEFAULT 'scheduled' CHECK(status IN ('scheduled', 'completed', 'cancelled')),
    total_price REAL NOT NULL DEFAULT 0 CHECK(total_price >= 0),
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE NO ACTION
);

CREATE TABLE appointment_services (
    appointment_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    PRIMARY KEY (appointment_id, service_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT
);

CREATE TABLE work_records (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    appointment_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    work_date TEXT NOT NULL CHECK(work_date = strftime('%Y-%m-%d', work_date)),
    work_time TEXT NOT NULL CHECK(work_time = strftime('%H:%M', work_time)),
    revenue REAL NOT NULL CHECK(revenue >= 0),
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE NO ACTION,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE NO ACTION,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT
);

CREATE INDEX idx_employees_status ON employees(status);
CREATE INDEX idx_employees_name ON employees(name);
CREATE INDEX idx_employees_hire_dismiss ON employees(hire_date, dismissal_date);

CREATE INDEX idx_services_name ON services(name);

CREATE INDEX idx_schedules_employee_id ON schedules(employee_id);

CREATE INDEX idx_appointments_employee_id ON appointments(employee_id);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_status ON appointments(status);

CREATE INDEX idx_work_records_employee_id ON work_records(employee_id);
CREATE INDEX idx_work_records_date ON work_records(work_date);


INSERT INTO employees (id, name, position, hire_date, dismissal_date, salary_percentage, status, phone, email) VALUES
(1, 'Иванов Сергей Петрович', 'Мастер', '2023-03-15', NULL, 28.0, 'active', '+7-901-111-22-33', 'ivanov@carservice.ru'),
(2, 'Петрова Ольга Владимировна', 'Мастер', '2024-01-20', NULL, 32.5, 'active', '+7-902-222-33-44', 'petrova@carservice.ru'),
(3, 'Сидоров Алексей Николаевич', 'Мастер', '2022-11-10', '2024-06-30', 30.0, 'fired', '+7-903-333-44-55', 'sidorov@carservice.ru'),
(4, 'Козлова Мария Ивановна', 'Мастер', '2023-08-05', NULL, 26.5, 'active', '+7-904-444-55-66', 'kozlova@carservice.ru'),
(5, 'Васильев Дмитрий Алексеевич', 'Мастер', '2024-05-12', NULL, 29.0, 'active', '+7-905-555-66-77', 'vasilev@carservice.ru');

INSERT INTO services (id, name, duration_minutes, price) VALUES
(1, 'Замена масла ДВС', 45, 2000.00),
(2, 'Замена тормозных дисков', 90, 7500.00),
(3, 'Компьютерная диагностика', 60, 3000.00),
(4, 'Замена воздушного фильтра', 25, 1500.00),
(5, 'Балансировка колес', 40, 2000.00),
(6, 'Регулировка света фар', 35, 2500.00),
(7, 'Замена амортизаторов', 150, 12000.00),
(8, 'Замена генератора', 75, 5000.00),
(9, 'Промывка инжектора', 50, 3500.00),
(10, 'Замена ремня ГРМ', 120, 9000.00);

INSERT INTO schedules (employee_id, day_of_week, start_time, end_time) VALUES
(1, 1, '09:00', '18:00'),
(1, 2, '09:00', '18:00'),
(1, 3, '09:00', '18:00'),
(1, 4, '09:00', '18:00'),
(1, 5, '09:00', '17:00'),
(2, 2, '10:00', '19:00'),
(2, 3, '10:00', '19:00'),
(2, 4, '10:00', '19:00'),
(2, 5, '10:00', '19:00'),
(2, 6, '10:00', '16:00'),
(4, 1, '08:30', '17:30'),
(4, 2, '08:30', '17:30'),
(4, 3, '08:30', '17:30'),
(4, 4, '08:30', '17:30'),
(4, 5, '08:30', '17:30'),
(5, 1, '11:00', '20:00'),
(5, 2, '11:00', '20:00'),
(5, 3, '11:00', '20:00'),
(5, 4, '11:00', '20:00'),
(5, 5, '11:00', '20:00'),
(5, 6, '11:00', '18:00');

INSERT INTO appointments (id, employee_id, client_name, client_phone, appointment_date, appointment_time, status, total_price) VALUES
(1, 1, 'Новиков Павел Сергеевич', '+7-911-987-65-43', '2024-11-15', '10:00', 'completed', 11500.00),
(2, 1, 'Смирнова Анастасия Игоревна', '+7-912-876-54-32', '2024-11-15', '15:30', 'completed', 2000.00),
(3, 2, 'Кузнецов Андрей Викторович', '+7-913-765-43-21', '2024-11-16', '11:00', 'completed', 9000.00),
(4, 2, 'Орлова Елена Дмитриевна', '+7-914-654-32-10', '2024-11-18', '14:00', 'scheduled', 3500.00),
(5, 4, 'Лебедев Иван Петрович', '+7-915-543-21-09', '2024-11-19', '09:30', 'completed', 4000.00),
(6, 5, 'Соколова Вероника Андреевна', '+7-916-432-10-98', '2024-11-20', '12:00', 'scheduled', 12000.00),
(7, 1, 'Мельников Артём Олегович', '+7-917-321-09-87', '2024-11-22', '10:30', 'scheduled', 7500.00),
(8, 2, 'Зайцева Татьяна Владимировна', '+7-918-210-98-76', '2024-11-25', '16:00', 'scheduled', 3000.00);

INSERT INTO appointment_services (appointment_id, service_id) VALUES
(1, 2),
(1, 4),
(2, 1),
(3, 10),
(4, 9),
(5, 3),
(5, 6),
(6, 7),
(7, 2),
(8, 3);

INSERT INTO work_records (id, appointment_id, employee_id, service_id, work_date, work_time, revenue) VALUES
(1, 1, 1, 2, '2024-11-15', '10:00', 7500.00),
(2, 1, 1, 4, '2024-11-15', '11:45', 1500.00),
(3, 2, 1, 1, '2024-11-15', '15:30', 2000.00),
(4, 3, 2, 10, '2024-11-16', '11:00', 9000.00),
(5, 5, 4, 3, '2024-11-19', '09:30', 3000.00),
(6, 5, 4, 6, '2024-11-19', '10:45', 2500.00),
(7, 5, 4, 5, '2024-11-19', '11:30', 1500.00);