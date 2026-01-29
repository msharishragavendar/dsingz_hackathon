create database dsingz;
use dsingz;

CREATE TABLE `attendance_records` (
  `uuid` char(36) NOT NULL,
  `employee_id` char(36) NOT NULL,
  `date` date NOT NULL,
  `check_in_time` datetime DEFAULT NULL,
  `check_out_time` datetime DEFAULT NULL,
  `status` enum('present','absent','late','leave','first_half_leave','second_half_leave','work_from_home') NOT NULL DEFAULT 'present',
  `leave_deducted` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `categories` (
  `uuid` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `designation` (
  `uuid` char(36) NOT NULL,
  `designation` varchar(255) NOT NULL,
  `employee_id` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE `employees` (
  `uuid` char(36) NOT NULL,
  `employee_id` varchar(255) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `official_email` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `google2fa_secret` varchar(255) DEFAULT NULL,
  `is_mfa_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `contact_no` varchar(255) DEFAULT NULL,
  `personal_email` varchar(255) DEFAULT NULL,
  `pan_number` varchar(255) DEFAULT NULL,
  `date_of_joining` date DEFAULT NULL,
  `original_dob` date DEFAULT NULL,
  `certificate_dob` date DEFAULT NULL,
  `blood_group` varchar(255) DEFAULT NULL,
  `communication_address` varchar(255) DEFAULT NULL,
  `permanent_address` varchar(255) DEFAULT NULL,
  `emergency_contact_name` varchar(255) DEFAULT NULL,
  `emergency_contact_number` varchar(255) DEFAULT NULL,
  `reporting_manager` varchar(255) DEFAULT NULL,
  `laptop` enum('official','personal') DEFAULT NULL,
  `laptop_id` varchar(255) DEFAULT NULL,
  `ram` varchar(255) DEFAULT NULL,
  `processor` varchar(255) DEFAULT NULL,
  `disk_size` varchar(255) DEFAULT NULL,
  `laptop_handover` enum('yes','no') DEFAULT NULL,
  `system_role` enum('admin','user') DEFAULT NULL,
  `job_role` char(36) DEFAULT NULL,
  `date_of_relieving` date DEFAULT NULL,
  `face_embedding` text DEFAULT NULL,
  `it_starting_date` date DEFAULT NULL,
  `slack_id` varchar(255) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expires` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE `employees_skills` (
  `uuid` char(36) NOT NULL,
  `employee_id` char(36) NOT NULL,
  `technology_ids` char(36) NOT NULL,
  `level` enum('beginner','intermediate','expert','trainee') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE `employee_designation` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `employee_skill_technologies` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `employee_skill_id` char(36) NOT NULL,
  `technology_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `holidays` (
  `uuid` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `interns` (
  `uuid` char(36) NOT NULL,
  `intern_id` varchar(255) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `face_embedding` text DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `personal_email` varchar(255) DEFAULT NULL,
  `contact_no` varchar(255) DEFAULT NULL,
  `role` char(36) DEFAULT NULL,
  `status` enum('active','completed') NOT NULL DEFAULT 'active',
  `password` varchar(255) DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expires` timestamp NULL DEFAULT NULL,
  `university_name` varchar(255) DEFAULT NULL,
  `department` varchar(255) DEFAULT NULL,
  `year` varchar(255) DEFAULT NULL,
  `duration_of_internship` varchar(50) DEFAULT NULL,
  `date_of_joining` date DEFAULT NULL,
  `date_of_relieving` date DEFAULT NULL,
  `pan_number` varchar(255) DEFAULT NULL,
  `intern_type` enum('intern','trainee') DEFAULT NULL,
  `emergency_contact_name` varchar(255) DEFAULT NULL,
  `emergency_contact_number` varchar(255) DEFAULT NULL,
  `original_dob` date DEFAULT NULL,
  `certificate_dob` date DEFAULT NULL,
  `blood_group` varchar(255) DEFAULT NULL,
  `communication_address` text DEFAULT NULL,
  `permanent_address` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE `interns_skills` (
  `uuid` char(36) NOT NULL,
  `intern_id` char(36) NOT NULL,
  `technology_ids` char(36) NOT NULL,
  `level` enum('beginner','intermediate','expert','trainee') NOT NULL DEFAULT 'beginner',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `intern_attendance_records` (
  `uuid` char(36) NOT NULL,
  `intern_id` char(36) NOT NULL,
  `date` date NOT NULL,
  `check_in_time` datetime DEFAULT NULL,
  `check_out_time` datetime DEFAULT NULL,
  `status` enum('present','absent','late','leave','first_half_leave','second_half_leave','work_from_home') NOT NULL DEFAULT 'present',
  `leave_deducted` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `intern_leaves` (
  `uuid` char(36) NOT NULL,
  `intern_id` char(36) NOT NULL,
  `request_type` enum('leave','work_from_home') DEFAULT NULL,
  `type` enum('sick','planned','first_half','second_half') DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `days` int(11) NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `reason` text DEFAULT NULL,
  `revocation_reason` text DEFAULT NULL,
  `approved_by` char(36) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `intern_projects` (
  `uuid` char(36) NOT NULL,
  `intern_uuid` char(36) NOT NULL,
  `project_uuid` char(36) NOT NULL,
  `project_features` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `leaves` (
  `uuid` char(36) NOT NULL,
  `employee_id` char(36) NOT NULL,
  `request_type` enum('leave','work_from_home') NOT NULL DEFAULT 'leave',
  `type` enum('sick','planned','first_half','second_half') DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `days` int(11) NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `reason` text DEFAULT NULL,
  `revocation_reason` text DEFAULT NULL,
  `approved_by` char(36) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE `notice_boards` (
  `uuid` char(36) NOT NULL,
  `description` text NOT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE `password_resets` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` char(36) NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



CREATE TABLE `projects` (
  `uuid` char(36) NOT NULL,
  `employee_id` char(36) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `market` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `project_status` enum('In-Progress','Completed') DEFAULT NULL,
  `billing_or_buffer` enum('billable','buffer') DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `project_url` varchar(255) DEFAULT NULL,
  `tech_stats` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`tech_stats`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `technologies` (
  `uuid` char(36) NOT NULL,
  `technology_name` varchar(255) NOT NULL,
  `category_id` char(36) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `categories` (`uuid`, `name`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
('cat-001', 'Programming Languages', 'Languages used for software development', '2024-01-15 10:00:00', '2024-01-15 10:00:00', NULL),
('cat-002', 'Web Frameworks', 'Frameworks for web application development', '2024-01-15 10:05:00', '2024-01-15 10:05:00', NULL),
('cat-003', 'Databases', 'Database management systems and tools', '2024-01-15 10:10:00', '2024-01-15 10:10:00', NULL),
('cat-004', 'DevOps Tools', 'Tools for deployment and infrastructure', '2024-01-15 10:15:00', '2024-01-15 10:15:00', NULL),
('cat-005', 'Mobile Development', 'Mobile app development technologies', '2024-01-15 10:20:00', '2024-01-15 10:20:00', NULL),
('cat-006', 'Cloud Platforms', 'Cloud computing platforms and services', '2024-01-15 10:25:00', '2024-01-15 10:25:00', NULL),
('cat-007', 'Frontend Libraries', 'JavaScript libraries for frontend development', '2024-01-15 10:30:00', '2024-01-15 10:30:00', NULL),
('cat-008', 'Backend Frameworks', 'Server-side application frameworks', '2024-01-15 10:35:00', '2024-01-15 10:35:00', NULL),
('cat-009', 'Testing Tools', 'Software testing and quality assurance tools', '2024-01-15 10:40:00', '2024-01-15 10:40:00', NULL),
('cat-010', 'Version Control', 'Version control systems and tools', '2024-01-15 10:45:00', '2024-01-15 10:45:00', NULL);

-- ============================================
-- TECHNOLOGIES TABLE (10 records)
-- ============================================
INSERT INTO `technologies` (`uuid`, `technology_name`, `category_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
('tech-001', 'Python', 'cat-001', '2024-01-15 11:00:00', '2024-01-15 11:00:00', NULL),
('tech-002', 'React.js', 'cat-007', '2024-01-15 11:05:00', '2024-01-15 11:05:00', NULL),
('tech-003', 'MySQL', 'cat-003', '2024-01-15 11:10:00', '2024-01-15 11:10:00', NULL),
('tech-004', 'Docker', 'cat-004', '2024-01-15 11:15:00', '2024-01-15 11:15:00', NULL),
('tech-005', 'Node.js', 'cat-008', '2024-01-15 11:20:00', '2024-01-15 11:20:00', NULL),
('tech-006', 'AWS', 'cat-006', '2024-01-15 11:25:00', '2024-01-15 11:25:00', NULL),
('tech-007', 'Laravel', 'cat-002', '2024-01-15 11:30:00', '2024-01-15 11:30:00', NULL),
('tech-008', 'Flutter', 'cat-005', '2024-01-15 11:35:00', '2024-01-15 11:35:00', NULL),
('tech-009', 'Jest', 'cat-009', '2024-01-15 11:40:00', '2024-01-15 11:40:00', NULL),
('tech-010', 'Git', 'cat-010', '2024-01-15 11:45:00', '2024-01-15 11:45:00', NULL);

-- ============================================
-- DESIGNATION TABLE (10 records)
-- ============================================
INSERT INTO `designation` (`uuid`, `designation`, `employee_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
('desig-001', 'Senior Software Engineer', 'emp-001', '2024-01-15 12:00:00', '2024-01-15 12:00:00', NULL),
('desig-002', 'Full Stack Developer', 'emp-002', '2024-01-15 12:05:00', '2024-01-15 12:05:00', NULL),
('desig-003', 'Frontend Developer', 'emp-003', '2024-01-15 12:10:00', '2024-01-15 12:10:00', NULL),
('desig-004', 'Backend Developer', 'emp-004', '2024-01-15 12:15:00', '2024-01-15 12:15:00', NULL),
('desig-005', 'DevOps Engineer', 'emp-005', '2024-01-15 12:20:00', '2024-01-15 12:20:00', NULL),
('desig-006', 'UI/UX Designer', 'emp-006', '2024-01-15 12:25:00', '2024-01-15 12:25:00', NULL),
('desig-007', 'Project Manager', 'emp-007', '2024-01-15 12:30:00', '2024-01-15 12:30:00', NULL),
('desig-008', 'Quality Assurance Engineer', 'emp-008', '2024-01-15 12:35:00', '2024-01-15 12:35:00', NULL),
('desig-009', 'Data Scientist', 'emp-009', '2024-01-15 12:40:00', '2024-01-15 12:40:00', NULL),
('desig-010', 'Mobile Developer', 'emp-010', '2024-01-15 12:45:00', '2024-01-15 12:45:00', NULL);

-- ============================================
-- EMPLOYEES TABLE (10 records)
-- ============================================
INSERT INTO `employees` (`uuid`, `employee_id`, `profile_image`, `first_name`, `last_name`, `official_email`, `password`, `google2fa_secret`, `is_mfa_enabled`, `contact_no`, `personal_email`, `pan_number`, `date_of_joining`, `original_dob`, `certificate_dob`, `blood_group`, `communication_address`, `permanent_address`, `emergency_contact_name`, `emergency_contact_number`, `reporting_manager`, `laptop`, `laptop_id`, `ram`, `processor`, `disk_size`, `laptop_handover`, `system_role`, `job_role`, `date_of_relieving`, `face_embedding`, `it_starting_date`, `slack_id`, `remember_token`, `reset_token`, `reset_token_expires`, `created_at`, `updated_at`, `deleted_at`) VALUES
('emp-001', 'EMP001', 'profile1.jpg', 'Rajesh', 'Kumar', 'rajesh.kumar@company.com', '$2y$10$abcdef1234567890', 'JBSWY3DPEHPK3PXP', 1, '+91-9876543210', 'rajesh.k@gmail.com', 'ABCDE1234F', '2022-01-10', '1990-05-15', '1990-05-15', 'O+', '123 MG Road, Chennai', '456 Anna Nagar, Chennai', 'Priya Kumar', '+91-9876543211', 'emp-007', 'official', 'LAP001', '16GB', 'Intel i7', '512GB SSD', 'yes', 'user', 'desig-001', NULL, 'face_data_001', '2022-01-10', 'U01234ABC', 'token001', NULL, NULL, '2024-01-15 13:00:00', '2024-01-15 13:00:00', NULL),
('emp-002', 'EMP002', 'profile2.jpg', 'Anitha', 'Ramesh', 'anitha.ramesh@company.com', '$2y$10$bcdefg2345678901', 'KCTXY4EQFIQM4QYQ', 0, '+91-9876543220', 'anitha.r@gmail.com', 'BCDEF2345G', '2022-03-15', '1992-08-20', '1992-08-20', 'A+', '789 T Nagar, Chennai', '321 Adyar, Chennai', 'Ramesh Kumar', '+91-9876543221', 'emp-007', 'official', 'LAP002', '8GB', 'Intel i5', '256GB SSD', 'yes', 'user', 'desig-002', NULL, 'face_data_002', '2022-03-15', 'U01234BCD', 'token002', NULL, NULL, '2024-01-15 13:05:00', '2024-01-15 13:05:00', NULL),
('emp-003', 'EMP003', 'profile3.jpg', 'Vijay', 'Krishnan', 'vijay.krishnan@company.com', '$2y$10$cdefgh3456789012', 'LDUYZ5FRGKRN5RZR', 1, '+91-9876543230', 'vijay.k@gmail.com', 'CDEFG3456H', '2022-05-20', '1988-11-30', '1988-11-30', 'B+', '456 Velachery, Chennai', '789 Tambaram, Chennai', 'Lakshmi Vijay', '+91-9876543231', 'emp-007', 'official', 'LAP003', '16GB', 'Intel i7', '512GB SSD', 'yes', 'user', 'desig-003', NULL, 'face_data_003', '2022-05-20', 'U01234CDE', 'token003', NULL, NULL, '2024-01-15 13:10:00', '2024-01-15 13:10:00', NULL),
('emp-004', 'EMP004', 'profile4.jpg', 'Meera', 'Subramanian', 'meera.subramanian@company.com', '$2y$10$defghi4567890123', 'MEVZA6GSHLOS6SAS', 0, '+91-9876543240', 'meera.s@gmail.com', 'DEFGH4567I', '2022-07-01', '1995-02-14', '1995-02-14', 'AB+', '654 Porur, Chennai', '987 Perungudi, Chennai', 'Subramanian Iyer', '+91-9876543241', 'emp-007', 'official', 'LAP004', '8GB', 'Intel i5', '256GB SSD', 'yes', 'user', 'desig-004', NULL, 'face_data_004', '2022-07-01', 'U01234DEF', 'token004', NULL, NULL, '2024-01-15 13:15:00', '2024-01-15 13:15:00', NULL),
('emp-005', 'EMP005', 'profile5.jpg', 'Karthik', 'Selvam', 'karthik.selvam@company.com', '$2y$10$efghij5678901234', 'NFWAB7HTIMPT7TBT', 1, '+91-9876543250', 'karthik.s@gmail.com', 'EFGHI5678J', '2023-01-15', '1991-07-25', '1991-07-25', 'O-', '321 Guindy, Chennai', '654 Nanganallur, Chennai', 'Selvam Kumar', '+91-9876543251', 'emp-007', 'official', 'LAP005', '16GB', 'Intel i7', '1TB SSD', 'yes', 'user', 'desig-005', NULL, 'face_data_005', '2023-01-15', 'U01234EFG', 'token005', NULL, NULL, '2024-01-15 13:20:00', '2024-01-15 13:20:00', NULL),
('emp-006', 'EMP006', 'profile6.jpg', 'Divya', 'Natarajan', 'divya.natarajan@company.com', '$2y$10$fghijk6789012345', 'OGXBC8IUJNQU8UCU', 0, '+91-9876543260', 'divya.n@gmail.com', 'FGHIJ6789K', '2023-03-10', '1993-04-18', '1993-04-18', 'A-', '987 Pallavaram, Chennai', '123 Chrompet, Chennai', 'Natarajan Raju', '+91-9876543261', 'emp-007', 'personal', 'LAP006', '8GB', 'AMD Ryzen 5', '512GB SSD', 'no', 'user', 'desig-006', NULL, 'face_data_006', '2023-03-10', 'U01234FGH', 'token006', NULL, NULL, '2024-01-15 13:25:00', '2024-01-15 13:25:00', NULL),
('emp-007', 'EMP007', 'profile7.jpg', 'Arjun', 'Madhavan', 'arjun.madhavan@company.com', '$2y$10$ghijkl7890123456', 'PHYCD9JVKORV9VDV', 1, '+91-9876543270', 'arjun.m@gmail.com', 'GHIJK7890L', '2021-06-01', '1985-09-22', '1985-09-22', 'B-', '456 Sholinganallur, Chennai', '789 OMR, Chennai', 'Madhavan Pillai', '+91-9876543271', 'emp-007', 'official', 'LAP007', '32GB', 'Intel i9', '1TB SSD', 'yes', 'admin', 'desig-007', NULL, 'face_data_007', '2021-06-01', 'U01234GHI', 'token007', NULL, NULL, '2024-01-15 13:30:00', '2024-01-15 13:30:00', NULL),
('emp-008', 'EMP008', 'profile8.jpg', 'Priya', 'Venkatesh', 'priya.venkatesh@company.com', '$2y$10$hijklm8901234567', 'QIZDE0KWLPSW0WEW', 0, '+91-9876543280', 'priya.v@gmail.com', 'HIJKL8901M', '2023-08-20', '1994-12-05', '1994-12-05', 'AB-', '789 Saidapet, Chennai', '321 Mylapore, Chennai', 'Venkatesh Iyer', '+91-9876543281', 'emp-007', 'official', 'LAP008', '16GB', 'Intel i7', '512GB SSD', 'yes', 'user', 'desig-008', NULL, 'face_data_008', '2023-08-20', 'U01234HIJ', 'token008', NULL, NULL, '2024-01-15 13:35:00', '2024-01-15 13:35:00', NULL),
('emp-009', 'EMP009', 'profile9.jpg', 'Suresh', 'Balaji', 'suresh.balaji@company.com', '$2y$10$ijklmn9012345678', 'RJAEF1LXMQTX1XFX', 1, '+91-9876543290', 'suresh.b@gmail.com', 'IJKLM9012N', '2023-11-01', '1989-03-10', '1989-03-10', 'O+', '654 Kodambakkam, Chennai', '987 Nungambakkam, Chennai', 'Balaji Sundaram', '+91-9876543291', 'emp-007', 'official', 'LAP009', '16GB', 'Intel i7', '512GB SSD', 'yes', 'user', 'desig-009', NULL, 'face_data_009', '2023-11-01', 'U01234IJK', 'token009', NULL, NULL, '2024-01-15 13:40:00', '2024-01-15 13:40:00', NULL),
('emp-010', 'EMP010', 'profile10.jpg', 'Lavanya', 'Raman', 'lavanya.raman@company.com', '$2y$10$jklmno0123456789', 'SKBFG2MYNRUY2YGY', 0, '+91-9876543300', 'lavanya.r@gmail.com', 'JKLMN0123O', '2024-01-05', '1996-06-28', '1996-06-28', 'A+', '321 Egmore, Chennai', '654 Kilpauk, Chennai', 'Raman Kumar', '+91-9876543301', 'emp-007', 'official', 'LAP010', '8GB', 'Intel i5', '256GB SSD', 'yes', 'user', 'desig-010', NULL, 'face_data_010', '2024-01-05', 'U01234JKL', 'token010', NULL, NULL, '2024-01-15 13:45:00', '2024-01-15 13:45:00', NULL);

-- ============================================
-- EMPLOYEES_SKILLS TABLE (10 records)
-- ============================================
INSERT INTO `employees_skills` (`uuid`, `employee_id`, `technology_ids`, `level`, `created_at`, `updated_at`) VALUES
('empskill-001', 'emp-001', 'tech-001', 'expert', '2024-01-15 14:00:00', '2024-01-15 14:00:00'),
('empskill-002', 'emp-002', 'tech-002', 'intermediate', '2024-01-15 14:05:00', '2024-01-15 14:05:00'),
('empskill-003', 'emp-003', 'tech-002', 'expert', '2024-01-15 14:10:00', '2024-01-15 14:10:00'),
('empskill-004', 'emp-004', 'tech-005', 'expert', '2024-01-15 14:15:00', '2024-01-15 14:15:00'),
('empskill-005', 'emp-005', 'tech-004', 'intermediate', '2024-01-15 14:20:00', '2024-01-15 14:20:00'),
('empskill-006', 'emp-006', 'tech-002', 'beginner', '2024-01-15 14:25:00', '2024-01-15 14:25:00'),
('empskill-007', 'emp-007', 'tech-007', 'expert', '2024-01-15 14:30:00', '2024-01-15 14:30:00'),
('empskill-008', 'emp-008', 'tech-009', 'intermediate', '2024-01-15 14:35:00', '2024-01-15 14:35:00'),
('empskill-009', 'emp-009', 'tech-001', 'expert', '2024-01-15 14:40:00', '2024-01-15 14:40:00'),
('empskill-010', 'emp-010', 'tech-008', 'intermediate', '2024-01-15 14:45:00', '2024-01-15 14:45:00');

-- ============================================
-- EMPLOYEE_SKILL_TECHNOLOGIES TABLE (10 records)
-- ============================================
INSERT INTO `employee_skill_technologies` (`id`, `employee_skill_id`, `technology_id`, `created_at`, `updated_at`) VALUES
(1, 'empskill-001', 'tech-001', '2024-01-15 15:00:00', '2024-01-15 15:00:00'),
(2, 'empskill-002', 'tech-002', '2024-01-15 15:05:00', '2024-01-15 15:05:00'),
(3, 'empskill-003', 'tech-002', '2024-01-15 15:10:00', '2024-01-15 15:10:00'),
(4, 'empskill-004', 'tech-005', '2024-01-15 15:15:00', '2024-01-15 15:15:00'),
(5, 'empskill-005', 'tech-004', '2024-01-15 15:20:00', '2024-01-15 15:20:00'),
(6, 'empskill-006', 'tech-002', '2024-01-15 15:25:00', '2024-01-15 15:25:00'),
(7, 'empskill-007', 'tech-007', '2024-01-15 15:30:00', '2024-01-15 15:30:00'),
(8, 'empskill-008', 'tech-009', '2024-01-15 15:35:00', '2024-01-15 15:35:00'),
(9, 'empskill-009', 'tech-001', '2024-01-15 15:40:00', '2024-01-15 15:40:00'),
(10, 'empskill-010', 'tech-008', '2024-01-15 15:45:00', '2024-01-15 15:45:00');

-- ============================================
-- PROJECTS TABLE (10 records)
-- ============================================
INSERT INTO `projects` (`uuid`, `employee_id`, `name`, `market`, `description`, `project_status`, `billing_or_buffer`, `logo`, `project_url`, `tech_stats`, `created_at`, `updated_at`, `deleted_at`) VALUES
('proj-001', 'emp-001', 'E-Commerce Platform', 'USA', 'Full-featured online shopping platform with payment integration', 'In-Progress', 'billable', 'ecommerce_logo.png', 'https://ecommerce-demo.com', '{"frontend": "React", "backend": "Node.js", "database": "MySQL"}', '2024-01-15 16:00:00', '2024-01-15 16:00:00', NULL),
('proj-002', 'emp-002', 'Healthcare Management System', 'India', 'Hospital management and patient tracking system', 'In-Progress', 'billable', 'healthcare_logo.png', 'https://healthcare-demo.com', '{"frontend": "Angular", "backend": "Laravel", "database": "PostgreSQL"}', '2024-01-15 16:05:00', '2024-01-15 16:05:00', NULL),
('proj-003', 'emp-003', 'Real Estate Portal', 'UK', 'Property listing and booking platform', 'Completed', 'billable', 'realestate_logo.png', 'https://realestate-demo.com', '{"frontend": "Vue.js", "backend": "Django", "database": "MongoDB"}', '2024-01-15 16:10:00', '2024-01-15 16:10:00', NULL),
('proj-004', 'emp-004', 'Inventory Management', 'Australia', 'Warehouse and inventory tracking system', 'In-Progress', 'billable', 'inventory_logo.png', 'https://inventory-demo.com', '{"frontend": "React", "backend": "Express", "database": "MySQL"}', '2024-01-15 16:15:00', '2024-01-15 16:15:00', NULL),
('proj-005', 'emp-005', 'Learning Management System', 'Canada', 'Online education and course management platform', 'In-Progress', 'buffer', 'lms_logo.png', 'https://lms-demo.com', '{"frontend": "React", "backend": "Node.js", "database": "MongoDB"}', '2024-01-15 16:20:00', '2024-01-15 16:20:00', NULL),
('proj-006', 'emp-006', 'Banking Application', 'Singapore', 'Mobile banking and transaction management', 'Completed', 'billable', 'banking_logo.png', 'https://banking-demo.com', '{"frontend": "Flutter", "backend": "Spring Boot", "database": "Oracle"}', '2024-01-15 16:25:00', '2024-01-15 16:25:00', NULL),
('proj-007', 'emp-007', 'Travel Booking System', 'UAE', 'Flight, hotel, and tour package booking platform', 'In-Progress', 'billable', 'travel_logo.png', 'https://travel-demo.com', '{"frontend": "React", "backend": "Laravel", "database": "MySQL"}', '2024-01-15 16:30:00', '2024-01-15 16:30:00', NULL),
('proj-008', 'emp-008', 'Restaurant Management', 'India', 'POS and order management for restaurants', 'In-Progress', 'buffer', 'restaurant_logo.png', 'https://restaurant-demo.com', '{"frontend": "Angular", "backend": "Node.js", "database": "PostgreSQL"}', '2024-01-15 16:35:00', '2024-01-15 16:35:00', NULL),
('proj-009', 'emp-009', 'Social Media Analytics', 'USA', 'Social media monitoring and analytics dashboard', 'Completed', 'billable', 'analytics_logo.png', 'https://analytics-demo.com', '{"frontend": "React", "backend": "Python", "database": "MongoDB"}', '2024-01-15 16:40:00', '2024-01-15 16:40:00', NULL),
('proj-010', 'emp-010', 'Fitness Tracking App', 'Germany', 'Mobile app for fitness tracking and health monitoring', 'In-Progress', 'billable', 'fitness_logo.png', 'https://fitness-demo.com', '{"frontend": "Flutter", "backend": "Node.js", "database": "Firebase"}', '2024-01-15 16:45:00', '2024-01-15 16:45:00', NULL);

-- ============================================
-- ATTENDANCE_RECORDS TABLE (10 records)
-- ============================================
INSERT INTO `attendance_records` (`uuid`, `employee_id`, `date`, `check_in_time`, `check_out_time`, `status`, `leave_deducted`, `created_at`, `updated_at`, `deleted_at`) VALUES
('attend-001', 'emp-001', '2026-01-20', '2026-01-20 09:00:00', '2026-01-20 18:30:00', 'present', 0, '2026-01-20 09:00:00', '2026-01-20 18:30:00', NULL),
('attend-002', 'emp-002', '2026-01-20', '2026-01-20 09:15:00', '2026-01-20 18:45:00', 'late', 0, '2026-01-20 09:15:00', '2026-01-20 18:45:00', NULL),
('attend-003', 'emp-003', '2026-01-20', '2026-01-20 09:05:00', '2026-01-20 18:20:00', 'present', 0, '2026-01-20 09:05:00', '2026-01-20 18:20:00', NULL),
('attend-004', 'emp-004', '2026-01-21', '2026-01-21 09:00:00', '2026-01-21 18:00:00', 'present', 0, '2026-01-21 09:00:00', '2026-01-21 18:00:00', NULL),
('attend-005', 'emp-005', '2026-01-21', null , null, 'absent', 0, '2026-01-21 09:00:00', '2026-01-21 18:15:00', NULL),
('attend-006', 'emp-006', '2026-01-21', '2026-01-21 09:10:00', '2026-01-21 13:00:00', 'first_half_leave', 1, '2026-01-21 09:10:00', '2026-01-21 13:00:00', NULL),
('attend-007', 'emp-007', '2026-01-22', '2026-01-22 09:00:00', '2026-01-22 18:30:00', 'present', 0, '2026-01-22 09:00:00', '2026-01-22 18:30:00', NULL),
('attend-008', 'emp-008', '2026-01-22', '2026-01-22 14:00:00', '2026-01-22 18:00:00', 'second_half_leave', 1, '2026-01-22 14:00:00', '2026-01-22 18:00:00', NULL),
('attend-009', 'emp-009', '2026-01-23', '2026-01-23 09:20:00', '2026-01-23 18:40:00', 'late', 0, '2026-01-23 09:20:00', '2026-01-23 18:40:00', NULL),
('attend-010', 'emp-010', '2026-01-23', '2026-01-23 09:00:00', '2026-01-23 18:00:00', 'present', 0, '2026-01-23 09:00:00', '2026-01-23 18:00:00', NULL);

-- ============================================
-- LEAVES TABLE (10 records)
-- ============================================
INSERT INTO `leaves` (`uuid`, `employee_id`, `request_type`, `type`, `start_date`, `end_date`, `days`, `status`, `reason`, `revocation_reason`, `approved_by`, `approved_at`, `created_at`, `updated_at`, `deleted_at`) VALUES
('leave-001', 'emp-001', 'leave', 'sick', '2026-01-25', '2026-01-25', 1, 'approved', 'Fever and cold', '', 'emp-007', '2026-01-24 14:00:00', '2026-01-24 12:00:00', '2026-01-24 14:00:00', NULL),
('leave-002', 'emp-002', 'work_from_home', 'planned', '2026-01-26', '2026-01-26', 1, 'approved', 'Internet installation at home', '', 'emp-007', '2026-01-24 15:00:00', '2026-01-24 13:00:00', '2026-01-24 15:00:00', NULL),
('leave-003', 'emp-003', 'leave', 'planned', '2026-02-01', '2026-02-03', 3, 'pending', 'Family function', '', 'emp-007', NULL, '2026-01-24 10:00:00', '2026-01-24 10:00:00', NULL),
('leave-004', 'emp-004', 'leave', 'sick', '2026-01-28', '2026-01-28', 1, 'rejected', 'Headache', 'Project deadline approaching', 'emp-007', '2026-01-27 11:00:00', '2026-01-27 09:00:00', '2026-01-27 11:00:00', NULL),
('leave-005', 'emp-005', 'leave', 'first_half', '2026-01-29', '2026-01-29', 1, 'approved', 'Doctor appointment', '', 'emp-007', '2026-01-28 16:00:00', '2026-01-28 14:00:00', '2026-01-28 16:00:00', NULL),
('leave-006', 'emp-006', 'leave', 'second_half', '2026-01-30', '2026-01-30', 1, 'approved', 'Personal work', '', 'emp-007', '2026-01-29 10:00:00', '2026-01-29 09:00:00', '2026-01-29 10:00:00', NULL),
('leave-007', 'emp-008', 'leave', 'planned', '2026-02-10', '2026-02-14', 5, 'approved', 'Vacation to Goa', '', 'emp-007', '2026-01-20 12:00:00', '2026-01-18 10:00:00', '2026-01-20 12:00:00', NULL),
('leave-008', 'emp-009', 'work_from_home', 'planned', '2026-02-05', '2026-02-05', 1, 'pending', 'Home maintenance work', '', 'emp-007', NULL, '2026-01-26 11:00:00', '2026-01-26 11:00:00', NULL),
('leave-009', 'emp-010', 'leave', 'sick', '2026-01-27', '2026-01-28', 2, 'approved', 'Viral infection', '', 'emp-007', '2026-01-26 15:00:00', '2026-01-26 13:00:00', '2026-01-26 15:00:00', NULL),
('leave-010', 'emp-001', 'leave', 'planned', '2026-03-15', '2026-03-20', 6, 'pending', 'Family trip to Kerala', '', 'emp-007', NULL, '2026-01-25 10:00:00', '2026-01-25 10:00:00', NULL);

-- ============================================
-- HOLIDAYS TABLE (10 records)
-- ============================================
INSERT INTO `holidays` (`uuid`, `name`, `date`, `description`, `created_at`, `updated_at`) VALUES
('holiday-001', 'Republic Day', '2026-01-26', 'National holiday celebrating the constitution of India', '2026-01-01 10:00:00', '2026-01-01 10:00:00'),
('holiday-002', 'Holi', '2026-03-14', 'Festival of colors', '2026-01-01 10:05:00', '2026-01-01 10:05:00'),
('holiday-003', 'Good Friday', '2026-04-03', 'Christian religious holiday', '2026-01-01 10:10:00', '2026-01-01 10:10:00'),
('holiday-004', 'May Day', '2026-05-01', 'International Workers Day', '2026-01-01 10:15:00', '2026-01-01 10:15:00'),
('holiday-005', 'Independence Day', '2026-08-15', 'National holiday celebrating independence', '2026-01-01 10:20:00', '2026-01-01 10:20:00'),
('holiday-006', 'Gandhi Jayanti', '2026-10-02', 'Birthday of Mahatma Gandhi', '2026-01-01 10:25:00', '2026-01-01 10:25:00'),
('holiday-007', 'Diwali', '2026-11-09', 'Festival of lights', '2026-01-01 10:30:00', '2026-01-01 10:30:00'),
('holiday-008', 'Christmas', '2026-12-25', 'Christian holiday celebrating birth of Jesus', '2026-01-01 10:35:00', '2026-01-01 10:35:00'),
('holiday-009', 'Pongal', '2026-01-15', 'Tamil harvest festival', '2026-01-01 10:40:00', '2026-01-01 10:40:00'),
('holiday-010', 'Dussehra', '2026-10-13', 'Hindu festival celebrating victory of good over evil', '2026-01-01 10:45:00', '2026-01-01 10:45:00');

-- ============================================
-- INTERNS TABLE (10 records)
-- ============================================
INSERT INTO `interns` (`uuid`, `intern_id`, `profile_image`, `face_embedding`, `first_name`, `last_name`, `personal_email`, `contact_no`, `role`, `status`, `password`, `reset_token`, `reset_token_expires`, `university_name`, `department`, `year`, `duration_of_internship`, `date_of_joining`, `date_of_relieving`, `pan_number`, `intern_type`, `emergency_contact_name`, `emergency_contact_number`, `original_dob`, `certificate_dob`, `blood_group`, `communication_address`, `permanent_address`, `created_at`, `updated_at`, `deleted_at`) VALUES
('intern-001', 'INT001', 'intern1.jpg', 'intern_face_001', 'Arun', 'Prakash', 'arun.prakash@student.edu', '+91-9123456781', 'desig-003', 'active', '$2y$10$intern001', '', NULL, 'Anna University', 'Computer Science', '3rd Year', '6 months', '2025-07-01', '2025-12-31', 'PQRST1234U', 'intern', 'Prakash Kumar', '+91-9123456782', '2003-03-15', '2003-03-15', 'O+', '123 College Road, Chennai', '456 Main Street, Trichy', '2025-07-01 09:00:00', '2025-07-01 09:00:00', NULL),
('intern-002', 'INT002', 'intern2.jpg', 'intern_face_002', 'Sneha', 'Ganesh', 'sneha.ganesh@student.edu', '+91-9123456783', 'desig-002', 'active', '$2y$10$intern002', '', NULL, 'SRM University', 'Information Technology', '2nd Year', '3 months', '2025-06-01', '2025-08-31', 'QRSTU2345V', 'intern', 'Ganesh Raman', '+91-9123456784', '2004-07-20', '2004-07-20', 'A+', '789 IT Park, Chennai', '321 Gandhi Road, Madurai', '2025-06-01 09:00:00', '2025-06-01 09:00:00', NULL),
('intern-003', 'INT003', 'intern3.jpg', 'intern_face_003', 'Karthick', 'Raja', 'karthick.raja@student.edu', '+91-9123456785', 'desig-004', 'completed', '$2y$10$intern003', '', NULL, 'VIT University', 'Computer Science', 'Final Year', '6 months', '2025-01-01', '2025-06-30', 'RSTUV3456W', 'trainee', 'Raja Mohan', '+91-9123456786', '2002-11-10', '2002-11-10', 'B+', '654 Tech Park, Vellore', '987 Temple Street, Salem', '2025-01-01 09:00:00', '2025-06-30 18:00:00', NULL),
('intern-004', 'INT004', 'intern4.jpg', 'intern_face_004', 'Nithya', 'Lakshmi', 'nithya.lakshmi@student.edu', '+91-9123456787', 'desig-006', 'active', '$2y$10$intern004', '', NULL, 'PSG Tech', 'Electronics', '3rd Year', '4 months', '2025-05-15', '2025-09-15', 'STUVW4567X', 'intern', 'Lakshmi Narayanan', '+91-9123456788', '2003-05-25', '2003-05-25', 'AB+', '321 College Street, Coimbatore', '654 Market Road, Erode', '2025-05-15 09:00:00', '2025-05-15 09:00:00', NULL),
('intern-005', 'INT005', 'intern5.jpg', 'intern_face_005', 'Vignesh', 'Kumar', 'vignesh.kumar@student.edu', '+91-9123456789', 'desig-010', 'active', '$2y$10$intern005', '', NULL, 'NIT Trichy', 'Computer Science', 'Final Year', '6 months', '2025-06-15', '2025-12-15', 'TUVWX5678Y', 'trainee', 'Kumar Samy', '+91-9123456790', '2002-09-18', '2002-09-18', 'O-', '789 Campus Road, Trichy', '123 Station Road, Thanjavur', '2025-06-15 09:00:00', '2025-06-15 09:00:00', NULL),
('intern-006', 'INT006', 'intern6.jpg', 'intern_face_006', 'Deepika', 'Ramesh', 'deepika.ramesh@student.edu', '+91-9123456791', 'desig-008', 'active', '$2y$10$intern006', '', NULL, 'MIT Chennai', 'Information Technology', '2nd Year', '3 months', '2025-07-10', '2025-10-10', 'UVWXY6789Z', 'intern', 'Ramesh Babu', '+91-9123456792', '2004-12-05', '2004-12-05', 'A-', '456 Anna Salai, Chennai', '789 Bus Stand, Kanchipuram', '2025-07-10 09:00:00', '2025-07-10 09:00:00', NULL),
('intern-007', 'INT007', 'intern7.jpg', 'intern_face_007', 'Harish', 'Venkat', 'harish.venkat@student.edu', '+91-9123456793', 'desig-003', 'completed', '$2y$10$intern007', '', NULL, 'Amrita University', 'Computer Science', 'Final Year', '6 months', '2024-12-01', '2025-05-31', 'VWXYZ7890A', 'intern', 'Venkat Subramaniam', '+91-9123456794', '2002-04-22', '2002-04-22', 'B-', '321 University Road, Coimbatore', '654 Church Street, Pollachi', '2024-12-01 09:00:00', '2025-05-31 18:00:00', NULL),
('intern-008', 'INT008', 'intern8.jpg', 'intern_face_008', 'Mythili', 'Sundar', 'mythili.sundar@student.edu', '+91-9123456795', 'desig-002', 'active', '$2y$10$intern008', '', NULL, 'SSN College', 'Computer Science', '3rd Year', '5 months', '2025-06-20', '2025-11-20', 'WXYZA8901B', 'trainee', 'Sundar Rajan', '+91-9123456796', '2003-08-30', '2003-08-30', 'AB-', '987 Kamaraj Nagar, Chennai', '321 Bazaar Street, Vellore', '2025-06-20 09:00:00', '2025-06-20 09:00:00', NULL),
('intern-009', 'INT009', 'intern9.jpg', 'intern_face_009', 'Naveen', 'Krishnan', 'naveen.krishnan@student.edu', '+91-9123456797', 'desig-004', 'active', '$2y$10$intern009', '', NULL, 'CEG Anna University', 'Electronics', 'Final Year', '6 months', '2025-07-05', '2026-01-05', 'XYZAB9012C', 'intern', 'Krishnan Iyer', '+91-9123456798', '2002-06-12', '2002-06-12', 'O+', '654 Guindy, Chennai', '987 Railway Station, Chengalpattu', '2025-07-05 09:00:00', '2025-07-05 09:00:00', NULL),
('intern-010', 'INT010', 'intern10.jpg', 'intern_face_010', 'Pavithra', 'Mohan', 'pavithra.mohan@student.edu', '+91-9123456799', 'desig-003', 'active', '$2y$10$intern010', '', NULL, 'Loyola College', 'Computer Applications', '3rd Year', '4 months', '2025-06-25', '2025-10-25', 'YZABC0123D', 'intern', 'Mohan Das', '+91-9123456800', '2003-10-08', '2003-10-08', 'A+', '123 Nungambakkam, Chennai', '456 Beach Road, Pondicherry', '2025-06-25 09:00:00', '2025-06-25 09:00:00', NULL);

-- ============================================
-- INTERNS_SKILLS TABLE (10 records)
-- ============================================
INSERT INTO `interns_skills` (`uuid`, `intern_id`, `technology_ids`, `level`, `created_at`, `updated_at`) VALUES
('intskill-001', 'intern-001', 'tech-002', 'beginner', '2025-07-01 10:00:00', '2025-07-01 10:00:00'),
('intskill-002', 'intern-002', 'tech-005', 'trainee', '2025-06-01 10:00:00', '2025-06-01 10:00:00'),
('intskill-003', 'intern-003', 'tech-001', 'intermediate', '2025-01-01 10:00:00', '2025-01-01 10:00:00'),
('intskill-004', 'intern-004', 'tech-002', 'beginner', '2025-05-15 10:00:00', '2025-05-15 10:00:00'),
('intskill-005', 'intern-005', 'tech-008', 'intermediate', '2025-06-15 10:00:00', '2025-06-15 10:00:00'),
('intskill-006', 'intern-006', 'tech-009', 'beginner', '2025-07-10 10:00:00', '2025-07-10 10:00:00'),
('intskill-007', 'intern-007', 'tech-002', 'intermediate', '2024-12-01 10:00:00', '2024-12-01 10:00:00'),
('intskill-008', 'intern-008', 'tech-007', 'trainee', '2025-06-20 10:00:00', '2025-06-20 10:00:00'),
('intskill-009', 'intern-009', 'tech-003', 'beginner', '2025-07-05 10:00:00', '2025-07-05 10:00:00'),
('intskill-010', 'intern-010', 'tech-002', 'beginner', '2025-06-25 10:00:00', '2025-06-25 10:00:00');

-- ============================================
-- INTERN_ATTENDANCE_RECORDS TABLE (10 records)
-- ============================================
INSERT INTO `intern_attendance_records` (`uuid`, `intern_id`, `date`, `check_in_time`, `check_out_time`, `status`, `leave_deducted`, `created_at`, `updated_at`, `deleted_at`) VALUES
('intattend-001', 'intern-001', '2026-01-20', '2026-01-20 09:30:00', '2026-01-20 17:30:00', 'present', 0, '2026-01-20 09:30:00', '2026-01-20 17:30:00', NULL),
('intattend-002', 'intern-002', '2026-01-20', '2026-01-20 09:45:00', '2026-01-20 17:45:00', 'late', 0, '2026-01-20 09:45:00', '2026-01-20 17:45:00', NULL),
('intattend-003', 'intern-003', '2026-01-20', '2026-01-20 09:30:00', '2026-01-20 17:30:00', 'present', 0, '2026-01-20 09:30:00', '2026-01-20 17:30:00', NULL),
('intattend-004', 'intern-004', '2026-01-21', '2026-01-21 09:30:00', '2026-01-21 17:30:00', 'present', 0, '2026-01-21 09:30:00', '2026-01-21 17:30:00', NULL),
('intattend-005', 'intern-005', '2026-01-21', '2026-01-21 09:30:00', '2026-01-21 17:30:00', 'work_from_home', 0, '2026-01-21 09:30:00', '2026-01-21 17:30:00', NULL),
('intattend-006', 'intern-006', '2026-01-21', '2026-01-21 09:30:00', '2026-01-21 13:00:00', 'first_half_leave', 1, '2026-01-21 09:30:00', '2026-01-21 13:00:00', NULL),
('intattend-007', 'intern-007', '2026-01-22', '2026-01-22 09:30:00', '2026-01-22 17:30:00', 'present', 0, '2026-01-22 09:30:00', '2026-01-22 17:30:00', NULL),
('intattend-008', 'intern-008', '2026-01-22', '2026-01-22 14:00:00', '2026-01-22 17:30:00', 'second_half_leave', 1, '2026-01-22 14:00:00', '2026-01-22 17:30:00', NULL),
('intattend-009', 'intern-009', '2026-01-23', '2026-01-23 09:50:00', '2026-01-23 17:50:00', 'late', 0, '2026-01-23 09:50:00', '2026-01-23 17:50:00', NULL),
('intattend-010', 'intern-010', '2026-01-23', '2026-01-23 09:30:00', '2026-01-23 17:30:00', 'present', 0, '2026-01-23 09:30:00', '2026-01-23 17:30:00', NULL);

-- ============================================
-- INTERN_LEAVES TABLE (10 records)
-- ============================================
INSERT INTO `intern_leaves` (`uuid`, `intern_id`, `request_type`, `type`, `start_date`, `end_date`, `days`, `status`, `reason`, `revocation_reason`, `approved_by`, `approved_at`, `created_at`, `updated_at`, `deleted_at`) VALUES
('intleave-001', 'intern-001', 'leave', 'sick', '2026-01-24', '2026-01-24', 1, 'approved', 'Stomach upset', '', 'emp-007', '2026-01-23 14:00:00', '2026-01-23 12:00:00', '2026-01-23 14:00:00', NULL),
('intleave-002', 'intern-002', 'work_from_home', 'planned', '2026-01-25', '2026-01-25', 1, 'approved', 'Family function at home', '', 'emp-007', '2026-01-24 10:00:00', '2026-01-24 09:00:00', '2026-01-24 10:00:00', NULL),
('intleave-003', 'intern-004', 'leave', 'planned', '2026-02-02', '2026-02-02', 1, 'pending', 'University exam', '', 'emp-007', NULL, '2026-01-25 11:00:00', '2026-01-25 11:00:00', NULL),
('intleave-004', 'intern-005', 'leave', 'sick', '2026-01-27', '2026-01-27', 1, 'approved', 'Fever', '', 'emp-007', '2026-01-26 16:00:00', '2026-01-26 14:00:00', '2026-01-26 16:00:00', NULL),
('intleave-005', 'intern-006', 'leave', 'first_half', '2026-01-28', '2026-01-28', 1, 'approved', 'College assignment submission', '', 'emp-007', '2026-01-27 10:00:00', '2026-01-27 09:00:00', '2026-01-27 10:00:00', NULL),
('intleave-006', 'intern-008', 'leave', 'second_half', '2026-01-29', '2026-01-29', 1, 'pending', 'Library visit for project', '', 'emp-007', NULL, '2026-01-28 11:00:00', '2026-01-28 11:00:00', NULL),
('intleave-007', 'intern-009', 'leave', 'planned', '2026-02-05', '2026-02-06', 2, 'approved', 'College cultural event', '', 'emp-007', '2026-01-22 15:00:00', '2026-01-22 13:00:00', '2026-01-22 15:00:00', NULL),
('intleave-008', 'intern-010', 'work_from_home', 'planned', '2026-02-03', '2026-02-03', 1, 'approved', 'Internet service upgrade', '', 'emp-007', '2026-01-25 12:00:00', '2026-01-25 10:00:00', '2026-01-25 12:00:00', NULL),
('intleave-009', 'intern-001', 'leave', 'sick', '2026-02-10', '2026-02-11', 2, 'pending', 'Medical checkup', '', 'emp-007', NULL, '2026-01-26 09:00:00', '2026-01-26 09:00:00', NULL),
('intleave-010', 'intern-005', 'leave', 'planned', '2026-02-15', '2026-02-15', 1, 'rejected', 'Personal work', 'Critical project deadline', 'emp-007', '2026-01-27 14:00:00', '2026-01-27 10:00:00', '2026-01-27 14:00:00', NULL);

-- ============================================
-- INTERN_PROJECTS TABLE (10 records)
-- ============================================
INSERT INTO `intern_projects` (`uuid`, `intern_uuid`, `project_uuid`, `project_features`, `created_at`, `updated_at`) VALUES
('intproj-001', 'intern-001', 'proj-003', 'Property search and filter implementation', '2025-07-01 10:00:00', '2025-07-01 10:00:00'),
('intproj-002', 'intern-002', 'proj-002', 'Patient registration module development', '2025-06-01 10:00:00', '2025-06-01 10:00:00'),
('intproj-003', 'intern-003', 'proj-004', 'Inventory tracking and reporting features', '2025-01-01 10:00:00', '2025-01-01 10:00:00'),
('intproj-004', 'intern-004', 'proj-006', 'UI/UX design for mobile banking screens', '2025-05-15 10:00:00', '2025-05-15 10:00:00'),
('intproj-005', 'intern-005', 'proj-010', 'Fitness tracking dashboard development', '2025-06-15 10:00:00', '2025-06-15 10:00:00'),
('intproj-006', 'intern-006', 'proj-008', 'Testing restaurant POS features', '2025-07-10 10:00:00', '2025-07-10 10:00:00'),
('intproj-007', 'intern-007', 'proj-001', 'Shopping cart and checkout flow', '2024-12-01 10:00:00', '2024-12-01 10:00:00'),
('intproj-008', 'intern-008', 'proj-005', 'Course management module', '2025-06-20 10:00:00', '2025-06-20 10:00:00'),
('intproj-009', 'intern-009', 'proj-007', 'Flight search and booking integration', '2025-07-05 10:00:00', '2025-07-05 10:00:00'),
('intproj-010', 'intern-010', 'proj-009', 'Social media data visualization charts', '2025-06-25 10:00:00', '2025-06-25 10:00:00');

-- ============================================
-- NOTICE_BOARDS TABLE (10 records)
-- ============================================
INSERT INTO `notice_boards` (`uuid`, `description`, `created_by`, `created_at`, `updated_at`, `deleted_at`) VALUES
('notice-001', 'Office will be closed on January 26th for Republic Day celebration', 'emp-007', '2026-01-15 10:00:00', '2026-01-15 10:00:00', NULL),
('notice-002', 'New parking policy effective from February 1st, 2026. Please collect your parking stickers from admin', 'emp-007', '2026-01-18 11:00:00', '2026-01-18 11:00:00', NULL),
('notice-003', 'Fire drill scheduled for January 30th at 3 PM. All employees must participate', 'emp-007', '2026-01-20 09:00:00', '2026-01-20 09:00:00', NULL),
('notice-004', 'Monthly team meeting on February 5th at 10 AM in Conference Room A', 'emp-007', '2026-01-22 14:00:00', '2026-01-22 14:00:00', NULL),
('notice-005', 'Reminder: Submit your timesheets by end of month for salary processing', 'emp-007', '2026-01-23 10:00:00', '2026-01-23 10:00:00', NULL),
('notice-006', 'New coffee machine installed in pantry. Please maintain cleanliness', 'emp-007', '2026-01-24 15:00:00', '2026-01-24 15:00:00', NULL),
('notice-007', 'Annual performance reviews scheduled for February 10-15. HR will send individual schedules', 'emp-007', '2026-01-25 11:00:00', '2026-01-25 11:00:00', NULL),
('notice-008', 'Company picnic planned for March 20th. Register with HR by February 28th', 'emp-007', '2026-01-26 12:00:00', '2026-01-26 12:00:00', NULL),
('notice-009', 'Security system upgrade on weekend. Building will be closed on Saturday', 'emp-007', '2026-01-27 10:00:00', '2026-01-27 10:00:00', NULL),
('notice-010', 'Welcome new team members joining us in February. Orientation on Feb 3rd', 'emp-007', '2026-01-28 09:00:00', '2026-01-28 09:00:00', NULL);

-- ============================================
-- USERS TABLE (10 records)
-- ============================================
INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Admin User', 'admin@company.com', '2024-01-15 10:00:00', '$2y$10$adminpass001', 'remtoken001', '2024-01-15 10:00:00', '2024-01-15 10:00:00'),
(2, 'HR Manager', 'hr@company.com', '2024-01-15 10:05:00', '$2y$10$hrpass002', 'remtoken002', '2024-01-15 10:05:00', '2024-01-15 10:05:00'),
(3, 'IT Support', 'itsupport@company.com', '2024-01-15 10:10:00', '$2y$10$itpass003', 'remtoken003', '2024-01-15 10:10:00', '2024-01-15 10:10:00'),
(4, 'Finance Head', 'finance@company.com', '2024-01-15 10:15:00', '$2y$10$finpass004', 'remtoken004', '2024-01-15 10:15:00', '2024-01-15 10:15:00'),
(5, 'Operations Manager', 'operations@company.com', '2024-01-15 10:20:00', '$2y$10$opspass005', 'remtoken005', '2024-01-15 10:20:00', '2024-01-15 10:20:00'),
(6, 'Marketing Lead', 'marketing@company.com', '2024-01-15 10:25:00', '$2y$10$mktpass006', 'remtoken006', '2024-01-15 10:25:00', '2024-01-15 10:25:00'),
(7, 'Sales Manager', 'sales@company.com', '2024-01-15 10:30:00', '$2y$10$salespass007', 'remtoken007', '2024-01-15 10:30:00', '2024-01-15 10:30:00'),
(8, 'Customer Support', 'support@company.com', '2024-01-15 10:35:00', '$2y$10$supppass008', 'remtoken008', '2024-01-15 10:35:00', '2024-01-15 10:35:00'),
(9, 'Quality Assurance Lead', 'qa@company.com', '2024-01-15 10:40:00', '$2y$10$qapass009', 'remtoken009', '2024-01-15 10:40:00', '2024-01-15 10:40:00'),
(10, 'Product Manager', 'product@company.com', '2024-01-15 10:45:00', '$2y$10$prodpass010', 'remtoken010', '2024-01-15 10:45:00', '2024-01-15 10:45:00');

-- ============================================
-- PASSWORD_RESETS TABLE (10 records)
-- ============================================
INSERT INTO `password_resets` (`email`, `token`, `created_at`) VALUES
('rajesh.kumar@company.com', 'reset_token_001', '2026-01-20 10:00:00'),
('anitha.ramesh@company.com', 'reset_token_002', '2026-01-21 11:00:00'),
('vijay.krishnan@company.com', 'reset_token_003', '2026-01-22 09:00:00'),
('meera.subramanian@company.com', 'reset_token_004', '2026-01-23 14:00:00'),
('karthik.selvam@company.com', 'reset_token_005', '2026-01-24 16:00:00'),
('divya.natarajan@company.com', 'reset_token_006', '2026-01-25 10:30:00'),
('arjun.madhavan@company.com', 'reset_token_007', '2026-01-26 12:00:00'),
('priya.venkatesh@company.com', 'reset_token_008', '2026-01-27 15:00:00'),
('suresh.balaji@company.com', 'reset_token_009', '2026-01-28 09:30:00'),
('lavanya.raman@company.com', 'reset_token_010', '2026-01-28 11:00:00');

-- ============================================
-- PERSONAL_ACCESS_TOKENS TABLE (10 records)
-- ============================================
INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\Employee', 'emp-001', 'auth_token', '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef', '["*"]', '2026-01-28 10:00:00', '2026-01-15 09:00:00', '2026-01-28 10:00:00'),
(2, 'App\\Models\\Employee', 'emp-002', 'auth_token', '2345678901bcdefg2345678901bcdefg2345678901bcdefg2345678901bcdefg', '["*"]', '2026-01-28 11:00:00', '2026-01-15 09:05:00', '2026-01-28 11:00:00'),
(3, 'App\\Models\\Employee', 'emp-003', 'auth_token', '3456789012cdefgh3456789012cdefgh3456789012cdefgh3456789012cdefgh', '["*"]', '2026-01-28 09:30:00', '2026-01-15 09:10:00', '2026-01-28 09:30:00'),
(4, 'App\\Models\\Employee', 'emp-004', 'auth_token', '4567890123defghi4567890123defghi4567890123defghi4567890123defghi', '["*"]', '2026-01-27 16:00:00', '2026-01-15 09:15:00', '2026-01-27 16:00:00'),
(5, 'App\\Models\\Employee', 'emp-005', 'auth_token', '5678901234efghij5678901234efghij5678901234efghij5678901234efghij', '["*"]', '2026-01-28 12:00:00', '2026-01-15 09:20:00', '2026-01-28 12:00:00'),
(6, 'App\\Models\\Intern', 'intern-001', 'auth_token', '6789012345fghijk6789012345fghijk6789012345fghijk6789012345fghijk', '["*"]', '2026-01-28 10:30:00', '2025-07-01 09:00:00', '2026-01-28 10:30:00'),
(7, 'App\\Models\\Intern', 'intern-002', 'auth_token', '7890123456ghijkl7890123456ghijkl7890123456ghijkl7890123456ghijkl', '["*"]', '2026-01-28 11:30:00', '2025-06-01 09:00:00', '2026-01-28 11:30:00'),
(8, 'App\\Models\\Employee', 'emp-007', 'auth_token', '8901234567hijklm8901234567hijklm8901234567hijklm8901234567hijklm', '["*"]', '2026-01-28 14:00:00', '2026-01-15 09:30:00', '2026-01-28 14:00:00'),
(9, 'App\\Models\\Employee', 'emp-008', 'auth_token', '9012345678ijklmn9012345678ijklmn9012345678ijklmn9012345678ijklmn', '["*"]', '2026-01-27 17:00:00', '2026-01-15 09:35:00', '2026-01-27 17:00:00'),
(10, 'App\\Models\\Intern', 'intern-005', 'auth_token', '0123456789jklmno0123456789jklmno0123456789jklmno0123456789jklmno', '["*"]', '2026-01-28 13:00:00', '2025-06-15 09:00:00', '2026-01-28 13:00:00');

-- ============================================
-- MIGRATIONS TABLE (10 records)
-- ============================================
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2023_01_01_000001_create_categories_table', 2),
(6, '2023_01_01_000002_create_technologies_table', 2),
(7, '2023_01_01_000003_create_employees_table', 2),
(8, '2023_01_01_000004_create_designation_table', 2),
(9, '2023_01_01_000005_create_projects_table', 2),
(10, '2023_01_01_000006_create_attendance_records_table', 2);

-- ============================================
-- FAILED_JOBS TABLE (10 records)
-- ============================================
INSERT INTO `failed_jobs` (`id`, `uuid`, `connection`, `queue`, `payload`, `exception`, `failed_at`) VALUES
(1, 'failed-001', 'database', 'default', '{"job":"SendEmailNotification","data":{"email":"user1@example.com"}}', 'Connection timeout exception', '2026-01-15 10:00:00'),
(2, 'failed-002', 'database', 'default', '{"job":"ProcessPayroll","data":{"month":"January"}}', 'Database connection lost', '2026-01-16 11:00:00'),
(3, 'failed-003', 'database', 'emails', '{"job":"SendWelcomeEmail","data":{"employee_id":"emp-001"}}', 'SMTP server error', '2026-01-17 09:00:00'),
(4, 'failed-004', 'database', 'default', '{"job":"GenerateReport","data":{"report_type":"attendance"}}', 'Memory limit exceeded', '2026-01-18 14:00:00'),
(5, 'failed-005', 'database', 'notifications', '{"job":"SendSlackNotification","data":{"message":"Meeting reminder"}}', 'Slack API rate limit', '2026-01-19 16:00:00'),
(6, 'failed-006', 'database', 'default', '{"job":"BackupDatabase","data":{"date":"2026-01-20"}}', 'Insufficient storage space', '2026-01-20 02:00:00'),
(7, 'failed-007', 'database', 'emails', '{"job":"SendLeaveApproval","data":{"leave_id":"leave-001"}}', 'Email template not found', '2026-01-21 12:00:00'),
(8, 'failed-008', 'database', 'default', '{"job":"SyncAttendance","data":{"date":"2026-01-22"}}', 'External API timeout', '2026-01-22 08:00:00'),
(9, 'failed-009', 'database', 'reports', '{"job":"MonthlyReport","data":{"month":"December"}}', 'Invalid data format', '2026-01-23 10:00:00'),
(10, 'failed-010', 'database', 'default', '{"job":"UpdateEmployeeStatus","data":{"employee_id":"emp-005"}}', 'Constraint violation error', '2026-01-24 15:00:00');

-- ============================================
-- EMPLOYEE_DESIGNATION TABLE (10 records)
-- ============================================
INSERT INTO `employee_designation` (`id`, `created_at`, `updated_at`) VALUES
(1, '2024-01-15 10:00:00', '2024-01-15 10:00:00'),
(2, '2024-01-15 10:05:00', '2024-01-15 10:05:00'),
(3, '2024-01-15 10:10:00', '2024-01-15 10:10:00'),
(4, '2024-01-15 10:15:00', '2024-01-15 10:15:00'),
(5, '2024-01-15 10:20:00', '2024-01-15 10:20:00'),
(6, '2024-01-15 10:25:00', '2024-01-15 10:25:00'),
(7, '2024-01-15 10:30:00', '2024-01-15 10:30:00'),
(8, '2024-01-15 10:35:00', '2024-01-15 10:35:00'),
(9, '2024-01-15 10:40:00', '2024-01-15 10:40:00'),
(10, '2024-01-15 10:45:00', '2024-01-15 10:45:00');
