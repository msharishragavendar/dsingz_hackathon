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


CREATE TABLE `salary_records` (
  `uuid` char(36) NOT NULL,
  `employee_id` char(36) NOT NULL,
  `month` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `base_salary` decimal(10,2) DEFAULT NULL,
  `working_days` int(11) DEFAULT NULL,
  `attendance_days` int(11) DEFAULT NULL,
  `gross_salary` decimal(10,2) DEFAULT NULL,
  `total_deductions` decimal(10,2) DEFAULT NULL,
  `net_salary` decimal(10,2) DEFAULT NULL,
  `status` enum('pending','calculated','approved','paid') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `salary_deductions` (
  `uuid` char(36) NOT NULL,
  `salary_record_id` char(36) NOT NULL,
  `deduction_type` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


CREATE TABLE `salary_bonuses` (
  `uuid` char(36) NOT NULL,
  `employee_id` char(36) NOT NULL,
  `month` int(11) NOT NULL,
  `year` int(11) NOT NULL,
  `bonus_type` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `reason` text DEFAULT NULL,
  `approved_by` char(36) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
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
('cat-010', 'Version Control', 'Version control systems and tools', '2024-01-15 10:45:00', '2024-01-15 10:45:00', NULL),
('cat-011', 'AI/ML Tools', 'Artificial intelligence and machine learning frameworks', '2024-01-15 10:50:00', '2024-01-15 10:50:00', NULL),
('cat-012', 'Data Visualization', 'Data visualization and analytics tools', '2024-01-15 10:55:00', '2024-01-15 10:55:00', NULL),
('cat-013', 'Security Tools', 'Security and encryption technologies', '2024-01-15 11:00:00', '2024-01-15 11:00:00', NULL),
('cat-014', 'API Integration', 'API and integration platforms', '2024-01-15 11:05:00', '2024-01-15 11:05:00', NULL),
('cat-015', 'CMS Platforms', 'Content management systems', '2024-01-15 11:10:00', '2024-01-15 11:10:00', NULL);

-- ============================================
-- TECHNOLOGIES TABLE (20 records)
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
('tech-010', 'Git', 'cat-010', '2024-01-15 11:45:00', '2024-01-15 11:45:00', NULL),
('tech-011', 'JavaScript', 'cat-001', '2024-01-15 11:50:00', '2024-01-15 11:50:00', NULL),
('tech-012', 'Vue.js', 'cat-007', '2024-01-15 11:55:00', '2024-01-15 11:55:00', NULL),
('tech-013', 'PostgreSQL', 'cat-003', '2024-01-15 12:00:00', '2024-01-15 12:00:00', NULL),
('tech-014', 'Kubernetes', 'cat-004', '2024-01-15 12:05:00', '2024-01-15 12:05:00', NULL),
('tech-015', 'Spring Boot', 'cat-008', '2024-01-15 12:10:00', '2024-01-15 12:10:00', NULL),
('tech-016', 'TensorFlow', 'cat-011', '2024-01-15 12:15:00', '2024-01-15 12:15:00', NULL),
('tech-017', 'Tableau', 'cat-012', '2024-01-15 12:20:00', '2024-01-15 12:20:00', NULL),
('tech-018', 'Azure', 'cat-006', '2024-01-15 12:25:00', '2024-01-15 12:25:00', NULL),
('tech-019', 'TypeScript', 'cat-001', '2024-01-15 12:30:00', '2024-01-15 12:30:00', NULL),
('tech-020', 'MongoDB', 'cat-003', '2024-01-15 12:35:00', '2024-01-15 12:35:00', NULL);

-- ============================================
-- DESIGNATION TABLE (20 records)
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
('desig-010', 'Mobile Developer', 'emp-010', '2024-01-15 12:45:00', '2024-01-15 12:45:00', NULL),
('desig-011', 'Cloud Architect', 'emp-011', '2024-01-15 12:50:00', '2024-01-15 12:50:00', NULL),
('desig-012', 'Security Engineer', 'emp-012', '2024-01-15 12:55:00', '2024-01-15 12:55:00', NULL),
('desig-013', 'Business Analyst', 'emp-013', '2024-01-15 13:00:00', '2024-01-15 13:00:00', NULL),
('desig-014', 'Technical Lead', 'emp-014', '2024-01-15 13:05:00', '2024-01-15 13:05:00', NULL),
('desig-015', 'Systems Administrator', 'emp-015', '2024-01-15 13:10:00', '2024-01-15 13:10:00', NULL),
('desig-016', 'Solutions Architect', 'emp-016', '2024-01-15 13:15:00', '2024-01-15 13:15:00', NULL),
('desig-017', 'Junior Developer', 'emp-017', '2024-01-15 13:20:00', '2024-01-15 13:20:00', NULL),
('desig-018', 'Technical Writer', 'emp-018', '2024-01-15 13:25:00', '2024-01-15 13:25:00', NULL),
('desig-019', 'Product Owner', 'emp-019', '2024-01-15 13:30:00', '2024-01-15 13:30:00', NULL),
('desig-020', 'Scrum Master', 'emp-020', '2024-01-15 13:35:00', '2024-01-15 13:35:00', NULL);

-- ============================================
-- EMPLOYEES TABLE (20 records)
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
('emp-010', 'EMP010', 'profile10.jpg', 'Lavanya', 'Raman', 'lavanya.raman@company.com', '$2y$10$jklmno0123456789', 'SKBFG2MYNRUY2YGY', 0, '+91-9876543300', 'lavanya.r@gmail.com', 'JKLMN0123O', '2024-01-05', '1996-06-28', '1996-06-28', 'A+', '321 Egmore, Chennai', '654 Kilpauk, Chennai', 'Raman Kumar', '+91-9876543301', 'emp-007', 'official', 'LAP010', '8GB', 'Intel i5', '256GB SSD', 'yes', 'user', 'desig-010', NULL, 'face_data_010', '2024-01-05', 'U01234JKL', 'token010', NULL, NULL, '2024-01-15 13:45:00', '2024-01-15 13:45:00', NULL),
('emp-011', 'EMP011', 'profile11.jpg', 'Ashok', 'Dutta', 'ashok.dutta@company.com', '$2y$10$klmnop1234567890', 'TLCGH3NZOSV3ZHZ', 1, '+91-9876543310', 'ashok.d@gmail.com', 'KLMNO1234P', '2023-06-15', '1991-10-12', '1991-10-12', 'B+', '789 Broadway, Chennai', '456 Triplicane, Chennai', 'Dutta Roy', '+91-9876543311', 'emp-007', 'official', 'LAP011', '16GB', 'Intel i7', '512GB SSD', 'yes', 'user', 'desig-011', NULL, 'face_data_011', '2023-06-15', 'U01234KLM', 'token011', NULL, NULL, '2024-01-15 13:50:00', '2024-01-15 13:50:00', NULL),
('emp-012', 'EMP012', 'profile12.jpg', 'Sanjana', 'Rao', 'sanjana.rao@company.com', '$2y$10$lmnopq2345678901', 'UMDHI4OATPW4AI0', 0, '+91-9876543320', 'sanjana.r@gmail.com', 'LMNOP2345Q', '2023-04-20', '1994-01-08', '1994-01-08', 'O-', '654 Brigade Road, Bangalore', '123 Indiranagar, Bangalore', 'Rao Krishnan', '+91-9876543321', 'emp-007', 'official', 'LAP012', '8GB', 'Intel i5', '512GB SSD', 'yes', 'user', 'desig-012', NULL, 'face_data_012', '2023-04-20', 'U01234LMN', 'token012', NULL, NULL, '2024-01-15 13:55:00', '2024-01-15 13:55:00', NULL),
('emp-013', 'EMP013', 'profile13.jpg', 'Nikhil', 'Patel', 'nikhil.patel@company.com', '$2y$10$mnopqr3456789012', 'VNEIJ5PBUQX5BJ1', 1, '+91-9876543330', 'nikhil.p@gmail.com', 'MNOPQ3456R', '2022-09-05', '1993-07-22', '1993-07-22', 'AB+', '987 Park Street, Pune', '321 Baner, Pune', 'Patel Arun', '+91-9876543331', 'emp-007', 'official', 'LAP013', '16GB', 'Intel i7', '512GB SSD', 'yes', 'user', 'desig-013', NULL, 'face_data_013', '2022-09-05', 'U01234MNO', 'token013', NULL, NULL, '2024-01-15 14:00:00', '2024-01-15 14:00:00', NULL),
('emp-014', 'EMP014', 'profile14.jpg', 'Deepak', 'Singh', 'deepak.singh@company.com', '$2y$10$nopqrs4567890123', 'WOFJK6QCRVY6CK2', 0, '+91-9876543340', 'deepak.s@gmail.com', 'NOPQR4567S', '2021-12-10', '1987-04-16', '1987-04-16', 'A-', '123 Sector 15, Noida', '456 Sector 51, Noida', 'Singh Rajesh', '+91-9876543341', 'emp-007', 'official', 'LAP014', '32GB', 'Intel i9', '1TB SSD', 'yes', 'user', 'desig-014', NULL, 'face_data_014', '2021-12-10', 'U01234OPQ', 'token014', NULL, NULL, '2024-01-15 14:05:00', '2024-01-15 14:05:00', NULL),
('emp-015', 'EMP015', 'profile15.jpg', 'Shruti', 'Verma', 'shruti.verma@company.com', '$2y$10$opqrst5678901234', 'XPGKL7RDSWY7DL3', 1, '+91-9876543350', 'shruti.v@gmail.com', 'OPQRS5678T', '2023-02-14', '1995-09-30', '1995-09-30', 'B-', '789 MG Road, Hyderabad', '654 Jubilee Hills, Hyderabad', 'Verma Sunil', '+91-9876543351', 'emp-007', 'official', 'LAP015', '8GB', 'AMD Ryzen 5', '512GB SSD', 'yes', 'user', 'desig-015', NULL, 'face_data_015', '2023-02-14', 'U01234PQR', 'token015', NULL, NULL, '2024-01-15 14:10:00', '2024-01-15 14:10:00', NULL),
('emp-016', 'EMP016', 'profile16.jpg', 'Anil', 'Gupta', 'anil.gupta@company.com', '$2y$10$pqrstu6789012345', 'YQHML8SETXZ8EM4', 0, '+91-9876543360', 'anil.g@gmail.com', 'PQRST6789U', '2022-08-18', '1989-11-05', '1989-11-05', 'O+', '456 Cyber Hub, Gurgaon', '789 Golf Course Road, Gurgaon', 'Gupta Ramesh', '+91-9876543361', 'emp-007', 'official', 'LAP016', '16GB', 'Intel i7', '512GB SSD', 'yes', 'user', 'desig-016', NULL, 'face_data_016', '2022-08-18', 'U01234QRS', 'token016', NULL, NULL, '2024-01-15 14:15:00', '2024-01-15 14:15:00', NULL),
('emp-017', 'EMP017', 'profile17.jpg', 'Pooja', 'Sharma', 'pooja.sharma@company.com', '$2y$10$qrstuv7890123456', 'ZRINM9TFUYA9FN5', 1, '+91-9876543370', 'pooja.s@gmail.com', 'QRSTU7890V', '2024-01-08', '1997-03-20', '1997-03-20', 'A+', '123 Whitefield, Bangalore', '456 Marathahalli, Bangalore', 'Sharma Vikram', '+91-9876543371', 'emp-007', 'official', 'LAP017', '8GB', 'Intel i5', '256GB SSD', 'yes', 'user', 'desig-017', NULL, 'face_data_017', '2024-01-08', 'U01234RST', 'token017', NULL, NULL, '2024-01-15 14:20:00', '2024-01-15 14:20:00', NULL),
('emp-018', 'EMP018', 'profile18.jpg', 'Rahul', 'Desai', 'rahul.desai@company.com', '$2y$10$rstuvw8901234567', 'ASJNO0UGVZB0GO6', 0, '+91-9876543380', 'rahul.d@gmail.com', 'RSTUV8901W', '2023-07-12', '1992-06-14', '1992-06-14', 'B+', '789 Fort Kochi, Kochi', '654 Ernakulathappan, Kochi', 'Desai Rohit', '+91-9876543381', 'emp-007', 'personal', 'LAP018', '8GB', 'Intel i5', '512GB SSD', 'no', 'user', 'desig-018', NULL, 'face_data_018', '2023-07-12', 'U01234STU', 'token018', NULL, NULL, '2024-01-15 14:25:00', '2024-01-15 14:25:00', NULL),
('emp-019', 'EMP019', 'profile19.jpg', 'Neha', 'Joshi', 'neha.joshi@company.com', '$2y$10$stuvwx9012345678', 'BTKOP1VHWAC1HP7', 1, '+91-9876543390', 'neha.j@gmail.com', 'STUVW9012X', '2023-05-22', '1994-08-25', '1994-08-25', 'AB+', '456 Rajajinagar, Bangalore', '789 Challaghata, Bangalore', 'Joshi Aditya', '+91-9876543391', 'emp-007', 'official', 'LAP019', '16GB', 'Intel i7', '512GB SSD', 'yes', 'user', 'desig-019', NULL, 'face_data_019', '2023-05-22', 'U01234TUV', 'token019', NULL, NULL, '2024-01-15 14:30:00', '2024-01-15 14:30:00', NULL),
('emp-020', 'EMP020', 'profile20.jpg', 'Vikram', 'Reddy', 'vikram.reddy@company.com', '$2y$10$tuvwxy0123456789', 'CULPQ2WIXBD2IQ8', 0, '+91-9876543400', 'vikram.r@gmail.com', 'TUVWX0123Y', '2022-11-28', '1990-02-19', '1990-02-19', 'O-', '987 Secunderabad, Hyderabad', '123 Ameerpet, Hyderabad', 'Reddy Naresh', '+91-9876543401', 'emp-007', 'official', 'LAP020', '8GB', 'AMD Ryzen 7', '512GB SSD', 'yes', 'user', 'desig-020', NULL, 'face_data_020', '2022-11-28', 'U01234UVW', 'token020', NULL, NULL, '2024-01-15 14:35:00', '2024-01-15 14:35:00', NULL);

-- ============================================
-- EMPLOYEES_SKILLS TABLE (25 records)
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
('empskill-010', 'emp-010', 'tech-008', 'intermediate', '2024-01-15 14:45:00', '2024-01-15 14:45:00'),
('empskill-011', 'emp-011', 'tech-014', 'expert', '2024-01-15 14:50:00', '2024-01-15 14:50:00'),
('empskill-012', 'emp-012', 'tech-003', 'intermediate', '2024-01-15 14:55:00', '2024-01-15 14:55:00'),
('empskill-013', 'emp-013', 'tech-011', 'beginner', '2024-01-15 15:00:00', '2024-01-15 15:00:00'),
('empskill-014', 'emp-014', 'tech-015', 'expert', '2024-01-15 15:05:00', '2024-01-15 15:05:00'),
('empskill-015', 'emp-015', 'tech-006', 'intermediate', '2024-01-15 15:10:00', '2024-01-15 15:10:00'),
('empskill-016', 'emp-016', 'tech-016', 'intermediate', '2024-01-15 15:15:00', '2024-01-15 15:15:00'),
('empskill-017', 'emp-017', 'tech-002', 'beginner', '2024-01-15 15:20:00', '2024-01-15 15:20:00'),
('empskill-018', 'emp-018', 'tech-005', 'intermediate', '2024-01-15 15:25:00', '2024-01-15 15:25:00'),
('empskill-019', 'emp-019', 'tech-013', 'expert', '2024-01-15 15:30:00', '2024-01-15 15:30:00'),
('empskill-020', 'emp-020', 'tech-010', 'intermediate', '2024-01-15 15:35:00', '2024-01-15 15:35:00'),
('empskill-021', 'emp-001', 'tech-005', 'intermediate', '2024-01-15 15:40:00', '2024-01-15 15:40:00'),
('empskill-022', 'emp-003', 'tech-012', 'intermediate', '2024-01-15 15:45:00', '2024-01-15 15:45:00'),
('empskill-023', 'emp-006', 'tech-019', 'beginner', '2024-01-15 15:50:00', '2024-01-15 15:50:00'),
('empskill-024', 'emp-009', 'tech-017', 'expert', '2024-01-15 15:55:00', '2024-01-15 15:55:00'),
('empskill-025', 'emp-012', 'tech-020', 'intermediate', '2024-01-15 16:00:00', '2024-01-15 16:00:00');

-- ============================================
-- EMPLOYEE_SKILL_TECHNOLOGIES TABLE (expanded with all skill links)
-- ============================================
INSERT INTO `employee_skill_technologies` (`id`, `employee_skill_id`, `technology_id`, `created_at`, `updated_at`) VALUES
-- Original 10 records
(1, 'empskill-001', 'tech-001', '2024-01-15 15:00:00', '2024-01-15 15:00:00'),
(2, 'empskill-002', 'tech-002', '2024-01-15 15:05:00', '2024-01-15 15:05:00'),
(3, 'empskill-003', 'tech-002', '2024-01-15 15:10:00', '2024-01-15 15:10:00'),
(4, 'empskill-004', 'tech-005', '2024-01-15 15:15:00', '2024-01-15 15:15:00'),
(5, 'empskill-005', 'tech-004', '2024-01-15 15:20:00', '2024-01-15 15:20:00'),
(6, 'empskill-006', 'tech-002', '2024-01-15 15:25:00', '2024-01-15 15:25:00'),
(7, 'empskill-007', 'tech-007', '2024-01-15 15:30:00', '2024-01-15 15:30:00'),
(8, 'empskill-008', 'tech-009', '2024-01-15 15:35:00', '2024-01-15 15:35:00'),
(9, 'empskill-009', 'tech-001', '2024-01-15 15:40:00', '2024-01-15 15:40:00'),
(10, 'empskill-010', 'tech-008', '2024-01-15 15:45:00', '2024-01-15 15:45:00'),
-- Missing links for existing skills (11-25)
(11, 'empskill-011', 'tech-014', '2024-01-15 15:50:00', '2024-01-15 15:50:00'),
(12, 'empskill-012', 'tech-003', '2024-01-15 15:55:00', '2024-01-15 15:55:00'),
(13, 'empskill-013', 'tech-011', '2024-01-15 16:00:00', '2024-01-15 16:00:00'),
(14, 'empskill-014', 'tech-015', '2024-01-15 16:05:00', '2024-01-15 16:05:00'),
(15, 'empskill-015', 'tech-006', '2024-01-15 16:10:00', '2024-01-15 16:10:00'),
(16, 'empskill-016', 'tech-016', '2024-01-15 16:15:00', '2024-01-15 16:15:00'),
(17, 'empskill-017', 'tech-002', '2024-01-15 16:20:00', '2024-01-15 16:20:00'),
(18, 'empskill-018', 'tech-005', '2024-01-15 16:25:00', '2024-01-15 16:25:00'),
(19, 'empskill-019', 'tech-013', '2024-01-15 16:30:00', '2024-01-15 16:30:00'),
(20, 'empskill-020', 'tech-010', '2024-01-15 16:35:00', '2024-01-15 16:35:00'),
(21, 'empskill-021', 'tech-005', '2024-01-15 16:40:00', '2024-01-15 16:40:00'),
(22, 'empskill-022', 'tech-012', '2024-01-15 16:45:00', '2024-01-15 16:45:00'),
(23, 'empskill-023', 'tech-019', '2024-01-15 16:50:00', '2024-01-15 16:50:00'),
(24, 'empskill-024', 'tech-017', '2024-01-15 16:55:00', '2024-01-15 16:55:00'),
(25, 'empskill-025', 'tech-020', '2024-01-15 17:00:00', '2024-01-15 17:00:00');

-- Add more skills for Rajesh, Vijay, and Divya (for radar chart - need 3+ categories)
INSERT INTO `employees_skills` (`uuid`, `employee_id`, `technology_ids`, `level`, `created_at`, `updated_at`) VALUES
-- Rajesh: Add MySQL (databases), Docker (devops) 
('empskill-026', 'emp-001', 'tech-003', 'intermediate', '2024-01-15 17:00:00', '2024-01-15 17:00:00'),
('empskill-027', 'emp-001', 'tech-004', 'beginner', '2024-01-15 17:05:00', '2024-01-15 17:05:00'),
-- Vijay: Add MySQL (databases), Docker (devops)
('empskill-028', 'emp-003', 'tech-003', 'expert', '2024-01-15 17:10:00', '2024-01-15 17:10:00'),
('empskill-029', 'emp-003', 'tech-004', 'intermediate', '2024-01-15 17:15:00', '2024-01-15 17:15:00'),
-- Divya: Add MySQL (databases), Docker (devops)
('empskill-030', 'emp-006', 'tech-003', 'intermediate', '2024-01-15 17:20:00', '2024-01-15 17:20:00'),
('empskill-031', 'emp-006', 'tech-004', 'beginner', '2024-01-15 17:25:00', '2024-01-15 17:25:00');

-- Link new skills to technologies
INSERT INTO `employee_skill_technologies` (`id`, `employee_skill_id`, `technology_id`, `created_at`, `updated_at`) VALUES
(26, 'empskill-026', 'tech-003', '2024-01-15 17:00:00', '2024-01-15 17:00:00'),
(27, 'empskill-027', 'tech-004', '2024-01-15 17:05:00', '2024-01-15 17:05:00'),
(28, 'empskill-028', 'tech-003', '2024-01-15 17:10:00', '2024-01-15 17:10:00'),
(29, 'empskill-029', 'tech-004', '2024-01-15 17:15:00', '2024-01-15 17:15:00'),
(30, 'empskill-030', 'tech-003', '2024-01-15 17:20:00', '2024-01-15 17:20:00'),
(31, 'empskill-031', 'tech-004', '2024-01-15 17:25:00', '2024-01-15 17:25:00');

-- Add 2 more skills for Divya (AWS - Cloud, TensorFlow - AI/ML) for 6 total categories
INSERT INTO `employees_skills` (`uuid`, `employee_id`, `technology_ids`, `level`, `created_at`, `updated_at`) VALUES
('empskill-032', 'emp-006', 'tech-006', 'intermediate', '2024-01-15 17:30:00', '2024-01-15 17:30:00'),
('empskill-033', 'emp-006', 'tech-016', 'beginner', '2024-01-15 17:35:00', '2024-01-15 17:35:00');

INSERT INTO `employee_skill_technologies` (`id`, `employee_skill_id`, `technology_id`, `created_at`, `updated_at`) VALUES
(32, 'empskill-032', 'tech-006', '2024-01-15 17:30:00', '2024-01-15 17:30:00'),
(33, 'empskill-033', 'tech-016', '2024-01-15 17:35:00', '2024-01-15 17:35:00');

-- ============================================
-- PROJECTS TABLE (20 records)
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
('proj-010', 'emp-010', 'Fitness Tracking App', 'Germany', 'Mobile app for fitness tracking and health monitoring', 'In-Progress', 'billable', 'fitness_logo.png', 'https://fitness-demo.com', '{"frontend": "Flutter", "backend": "Node.js", "database": "Firebase"}', '2024-01-15 16:45:00', '2024-01-15 16:45:00', NULL),
('proj-011', 'emp-011', 'Supply Chain Management', 'USA', 'End-to-end supply chain visibility platform', 'In-Progress', 'billable', 'supply_chain_logo.png', 'https://supply-chain-demo.com', '{"frontend": "React", "backend": "Spring Boot", "database": "PostgreSQL"}', '2024-01-15 16:50:00', '2024-01-15 16:50:00', NULL),
('proj-012', 'emp-012', 'CRM System', 'Europe', 'Customer relationship management platform', 'In-Progress', 'billable', 'crm_logo.png', 'https://crm-demo.com', '{"frontend": "Vue.js", "backend": "Laravel", "database": "MySQL"}', '2024-01-15 16:55:00', '2024-01-15 16:55:00', NULL),
('proj-013', 'emp-013', 'Data Analytics Dashboard', 'USA', 'Advanced business intelligence and analytics', 'Completed', 'billable', 'bi_logo.png', 'https://bi-demo.com', '{"frontend": "React", "backend": "Python", "database": "MongoDB"}', '2024-01-15 17:00:00', '2024-01-15 17:00:00', NULL),
('proj-014', 'emp-014', 'IoT Platform', 'India', 'Internet of Things device management platform', 'In-Progress', 'buffer', 'iot_logo.png', 'https://iot-demo.com', '{"frontend": "React", "backend": "Node.js", "database": "InfluxDB"}', '2024-01-15 17:05:00', '2024-01-15 17:05:00', NULL),
('proj-015', 'emp-015', 'Appointment Booking System', 'Australia', 'Scheduling and appointment management', 'In-Progress', 'billable', 'booking_logo.png', 'https://booking-demo.com', '{"frontend": "React", "backend": "Express", "database": "MongoDB"}', '2024-01-15 17:10:00', '2024-01-15 17:10:00', NULL),
('proj-016', 'emp-016', 'Video Streaming Platform', 'USA', 'Streaming video content platform with analytics', 'In-Progress', 'billable', 'video_logo.png', 'https://video-demo.com', '{"frontend": "React", "backend": "Node.js", "database": "MongoDB"}', '2024-01-15 17:15:00', '2024-01-15 17:15:00', NULL),
('proj-017', 'emp-017', 'E-Learning Portal', 'India', 'Online learning and certification platform', 'In-Progress', 'billable', 'elearning_logo.png', 'https://elearning-demo.com', '{"frontend": "React", "backend": "Django", "database": "PostgreSQL"}', '2024-01-15 17:20:00', '2024-01-15 17:20:00', NULL),
('proj-018', 'emp-018', 'Accounting Software', 'UK', 'Financial accounting and reporting system', 'Completed', 'billable', 'accounting_logo.png', 'https://accounting-demo.com', '{"frontend": "Angular", "backend": "Laravel", "database": "MySQL"}', '2024-01-15 17:25:00', '2024-01-15 17:25:00', NULL),
('proj-019', 'emp-019', 'HR Management Suite', 'India', 'Complete HR management and payroll solution', 'In-Progress', 'billable', 'hrm_logo.png', 'https://hrm-demo.com', '{"frontend": "React", "backend": "Spring Boot", "database": "Oracle"}', '2024-01-15 17:30:00', '2024-01-15 17:30:00', NULL),
('proj-020', 'emp-020', 'Document Management System', 'USA', 'Enterprise document management and workflow', 'In-Progress', 'buffer', 'dms_logo.png', 'https://dms-demo.com', '{"frontend": "React", "backend": "Node.js", "database": "MongoDB"}', '2024-01-15 17:35:00', '2024-01-15 17:35:00', NULL);

-- ============================================
-- ATTENDANCE_RECORDS TABLE (60 records for trend analysis)
-- ============================================



INSERT INTO `attendance_records` (`uuid`, `employee_id`, `date`, `check_in_time`, `check_out_time`, `status`, `leave_deducted`, `created_at`, `updated_at`, `deleted_at`) VALUES
-- Expanded January 2026 working days (22 days per employee) for emp-001..emp-020
-- Working dates: 2026-01-01,02,05,06,07,08,09,12,13,14,15,16,19,20,21,22,23,26,27,28,29,30

-- Status pattern per employee: present,present,late,present,present,work_from_home,present,present,absent,present,first_half_leave,second_half_leave,present,present,late,present,present,present,present,present,present,present

-- Employee 1 (emp-001)
('attend-001','emp-001','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-002','emp-001','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-003','emp-001','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-004','emp-001','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-005','emp-001','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-006','emp-001','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-007','emp-001','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-008','emp-001','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-009','emp-001','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-010','emp-001','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-011','emp-001','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-012','emp-001','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-013','emp-001','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-014','emp-001','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-015','emp-001','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-016','emp-001','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-017','emp-001','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-018','emp-001','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-019','emp-001','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-020','emp-001','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-021','emp-001','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-022','emp-001','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 2 (emp-002)
('attend-023','emp-002','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-024','emp-002','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-025','emp-002','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-026','emp-002','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-027','emp-002','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-028','emp-002','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-029','emp-002','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-030','emp-002','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-031','emp-002','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-032','emp-002','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-033','emp-002','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-034','emp-002','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-035','emp-002','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-036','emp-002','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-037','emp-002','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-038','emp-002','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-039','emp-002','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-040','emp-002','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-041','emp-002','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-042','emp-002','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-043','emp-002','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-044','emp-002','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 3 (emp-003)
('attend-045','emp-003','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-046','emp-003','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-047','emp-003','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-048','emp-003','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-049','emp-003','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-050','emp-003','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-051','emp-003','2026-01-09',NULL,NULL,'absent',0,'2026-01-09 09:00:00','2026-01-09 09:00:00',NULL),
('attend-052','emp-003','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-053','emp-003','2026-01-13','2026-01-13 09:00:00','2026-01-13 18:30:00','present',0,'2026-01-13 09:00:00','2026-01-13 18:30:00',NULL),
('attend-054','emp-003','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-055','emp-003','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-056','emp-003','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-057','emp-003','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-058','emp-003','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-059','emp-003','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-060','emp-003','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-061','emp-003','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-062','emp-003','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-063','emp-003','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-064','emp-003','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-065','emp-003','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-066','emp-003','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 4 (emp-004)
('attend-067','emp-004','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-068','emp-004','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-069','emp-004','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-070','emp-004','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-071','emp-004','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-072','emp-004','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-073','emp-004','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-074','emp-004','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-075','emp-004','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-076','emp-004','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-077','emp-004','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-078','emp-004','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-079','emp-004','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-080','emp-004','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-081','emp-004','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-082','emp-004','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-083','emp-004','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-084','emp-004','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-085','emp-004','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-086','emp-004','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-087','emp-004','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-088','emp-004','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 5 (emp-005)
('attend-089','emp-005','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-090','emp-005','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-091','emp-005','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-092','emp-005','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-093','emp-005','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-094','emp-005','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-095','emp-005','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-096','emp-005','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-097','emp-005','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-098','emp-005','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-099','emp-005','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-100','emp-005','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),

-- Continue Employee 5 (emp-005) remaining dates
('attend-101','emp-005','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-102','emp-005','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-103','emp-005','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-104','emp-005','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-105','emp-005','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-106','emp-005','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-107','emp-005','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-108','emp-005','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-109','emp-005','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-110','emp-005','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employees 6..20 (emp-006 to emp-020) repeating same 22-day pattern
-- Employee 6 (emp-006)
('attend-111','emp-006','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-112','emp-006','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-113','emp-006','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-114','emp-006','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-115','emp-006','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-116','emp-006','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-117','emp-006','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-118','emp-006','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-119','emp-006','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-120','emp-006','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-121','emp-006','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-122','emp-006','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-123','emp-006','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-124','emp-006','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-125','emp-006','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-126','emp-006','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-127','emp-006','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-128','emp-006','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-129','emp-006','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-130','emp-006','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-131','emp-006','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-132','emp-006','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 7 (emp-007)
('attend-133','emp-007','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-134','emp-007','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-135','emp-007','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-136','emp-007','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-137','emp-007','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-138','emp-007','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-139','emp-007','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-140','emp-007','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-141','emp-007','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-142','emp-007','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-143','emp-007','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-144','emp-007','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-145','emp-007','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-146','emp-007','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-147','emp-007','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-148','emp-007','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-149','emp-007','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-150','emp-007','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-151','emp-007','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-152','emp-007','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-153','emp-007','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-154','emp-007','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 8 (emp-008)
('attend-155','emp-008','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-156','emp-008','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-157','emp-008','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-158','emp-008','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-159','emp-008','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-160','emp-008','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-161','emp-008','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-162','emp-008','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-163','emp-008','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-164','emp-008','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-165','emp-008','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-166','emp-008','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-167','emp-008','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-168','emp-008','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-169','emp-008','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-170','emp-008','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-171','emp-008','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-172','emp-008','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-173','emp-008','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-174','emp-008','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-175','emp-008','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-176','emp-008','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 9 (emp-009)
('attend-177','emp-009','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-178','emp-009','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-179','emp-009','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-180','emp-009','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-181','emp-009','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-182','emp-009','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-183','emp-009','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-184','emp-009','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-185','emp-009','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-186','emp-009','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-187','emp-009','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-188','emp-009','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-189','emp-009','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-190','emp-009','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-191','emp-009','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-192','emp-009','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-193','emp-009','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-194','emp-009','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-195','emp-009','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-196','emp-009','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-197','emp-009','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-198','emp-009','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 10 (emp-010)
('attend-199','emp-010','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-200','emp-010','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-201','emp-010','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-202','emp-010','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-203','emp-010','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-204','emp-010','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-205','emp-010','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-206','emp-010','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-207','emp-010','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-208','emp-010','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-209','emp-010','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-210','emp-010','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-211','emp-010','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-212','emp-010','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-213','emp-010','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-214','emp-010','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-215','emp-010','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-216','emp-010','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-217','emp-010','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-218','emp-010','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-219','emp-010','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-220','emp-010','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 11 (emp-011)
('attend-221','emp-011','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-222','emp-011','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-223','emp-011','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-224','emp-011','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-225','emp-011','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-226','emp-011','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-227','emp-011','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-228','emp-011','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-229','emp-011','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-230','emp-011','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-231','emp-011','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-232','emp-011','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-233','emp-011','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-234','emp-011','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-235','emp-011','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-236','emp-011','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-237','emp-011','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-238','emp-011','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-239','emp-011','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-240','emp-011','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-241','emp-011','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-242','emp-011','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 12 (emp-012)
('attend-243','emp-012','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-244','emp-012','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-245','emp-012','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-246','emp-012','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-247','emp-012','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-248','emp-012','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-249','emp-012','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-250','emp-012','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-251','emp-012','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-252','emp-012','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-253','emp-012','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-254','emp-012','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-255','emp-012','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-256','emp-012','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-257','emp-012','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-258','emp-012','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-259','emp-012','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-260','emp-012','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-261','emp-012','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-262','emp-012','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-263','emp-012','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-264','emp-012','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 13 (emp-013)
('attend-265','emp-013','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-266','emp-013','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-267','emp-013','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-268','emp-013','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-269','emp-013','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-270','emp-013','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-271','emp-013','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-272','emp-013','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-273','emp-013','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-274','emp-013','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-275','emp-013','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-276','emp-013','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-277','emp-013','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-278','emp-013','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-279','emp-013','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-280','emp-013','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-281','emp-013','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-282','emp-013','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-283','emp-013','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-284','emp-013','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-285','emp-013','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-286','emp-013','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 14 (emp-014)
('attend-287','emp-014','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-288','emp-014','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-289','emp-014','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-290','emp-014','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-291','emp-014','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-292','emp-014','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-293','emp-014','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-294','emp-014','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-295','emp-014','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-296','emp-014','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-297','emp-014','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-298','emp-014','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-299','emp-014','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-300','emp-014','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-301','emp-014','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-302','emp-014','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-303','emp-014','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-304','emp-014','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-305','emp-014','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-306','emp-014','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-307','emp-014','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-308','emp-014','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 15 (emp-015)
('attend-309','emp-015','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-310','emp-015','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-311','emp-015','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-312','emp-015','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-313','emp-015','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-314','emp-015','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-315','emp-015','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-316','emp-015','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-317','emp-015','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-318','emp-015','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-319','emp-015','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-320','emp-015','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-321','emp-015','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-322','emp-015','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-323','emp-015','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-324','emp-015','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-325','emp-015','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-326','emp-015','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-327','emp-015','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-328','emp-015','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-329','emp-015','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-330','emp-015','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 16 (emp-016)
('attend-331','emp-016','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-332','emp-016','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-333','emp-016','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-334','emp-016','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-335','emp-016','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-336','emp-016','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-337','emp-016','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-338','emp-016','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-339','emp-016','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-340','emp-016','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-341','emp-016','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-342','emp-016','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-343','emp-016','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-344','emp-016','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-345','emp-016','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-346','emp-016','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-347','emp-016','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-348','emp-016','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-349','emp-016','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-350','emp-016','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-351','emp-016','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-352','emp-016','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 17 (emp-017)
('attend-353','emp-017','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-354','emp-017','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-355','emp-017','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-356','emp-017','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-357','emp-017','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-358','emp-017','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-359','emp-017','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-360','emp-017','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-361','emp-017','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-362','emp-017','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-363','emp-017','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-364','emp-017','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-365','emp-017','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-366','emp-017','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-367','emp-017','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-368','emp-017','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-369','emp-017','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-370','emp-017','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-371','emp-017','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-372','emp-017','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-373','emp-017','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-374','emp-017','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 18 (emp-018)
('attend-375','emp-018','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-376','emp-018','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-377','emp-018','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-378','emp-018','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-379','emp-018','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-380','emp-018','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-381','emp-018','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-382','emp-018','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-383','emp-018','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-384','emp-018','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-385','emp-018','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-386','emp-018','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-387','emp-018','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-388','emp-018','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-389','emp-018','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-390','emp-018','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-391','emp-018','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-392','emp-018','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-393','emp-018','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-394','emp-018','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-395','emp-018','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-396','emp-018','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 19 (emp-019)
('attend-397','emp-019','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-398','emp-019','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-399','emp-019','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-400','emp-019','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-401','emp-019','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-402','emp-019','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-403','emp-019','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-404','emp-019','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-405','emp-019','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-406','emp-019','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-407','emp-019','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-408','emp-019','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-409','emp-019','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-410','emp-019','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-411','emp-019','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-412','emp-019','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-413','emp-019','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-414','emp-019','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-415','emp-019','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-416','emp-019','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-417','emp-019','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-418','emp-019','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL),

-- Employee 20 (emp-020)
('attend-419','emp-020','2026-01-01','2026-01-01 09:00:00','2026-01-01 18:30:00','present',0,'2026-01-01 09:00:00','2026-01-01 18:30:00',NULL),
('attend-420','emp-020','2026-01-02','2026-01-02 09:00:00','2026-01-02 18:30:00','present',0,'2026-01-02 09:00:00','2026-01-02 18:30:00',NULL),
('attend-421','emp-020','2026-01-05','2026-01-05 09:20:00','2026-01-05 18:30:00','late',0,'2026-01-05 09:20:00','2026-01-05 18:30:00',NULL),
('attend-422','emp-020','2026-01-06','2026-01-06 09:00:00','2026-01-06 18:30:00','present',0,'2026-01-06 09:00:00','2026-01-06 18:30:00',NULL),
('attend-423','emp-020','2026-01-07','2026-01-07 09:00:00','2026-01-07 18:30:00','present',0,'2026-01-07 09:00:00','2026-01-07 18:30:00',NULL),
('attend-424','emp-020','2026-01-08','2026-01-08 09:00:00','2026-01-08 18:30:00','work_from_home',0,'2026-01-08 09:00:00','2026-01-08 18:30:00',NULL),
('attend-425','emp-020','2026-01-09','2026-01-09 09:00:00','2026-01-09 18:30:00','present',0,'2026-01-09 09:00:00','2026-01-09 18:30:00',NULL),
('attend-426','emp-020','2026-01-12','2026-01-12 09:00:00','2026-01-12 18:30:00','present',0,'2026-01-12 09:00:00','2026-01-12 18:30:00',NULL),
('attend-427','emp-020','2026-01-13',NULL,NULL,'absent',0,'2026-01-13 09:00:00','2026-01-13 09:00:00',NULL),
('attend-428','emp-020','2026-01-14','2026-01-14 09:00:00','2026-01-14 13:00:00','first_half_leave',1,'2026-01-14 09:00:00','2026-01-14 13:00:00',NULL),
('attend-429','emp-020','2026-01-15','2026-01-15 14:00:00','2026-01-15 18:30:00','second_half_leave',1,'2026-01-15 14:00:00','2026-01-15 18:30:00',NULL),
('attend-430','emp-020','2026-01-16','2026-01-16 09:00:00','2026-01-16 18:30:00','present',0,'2026-01-16 09:00:00','2026-01-16 18:30:00',NULL),
('attend-431','emp-020','2026-01-19','2026-01-19 09:00:00','2026-01-19 18:30:00','present',0,'2026-01-19 09:00:00','2026-01-19 18:30:00',NULL),
('attend-432','emp-020','2026-01-20','2026-01-20 09:00:00','2026-01-20 18:30:00','present',0,'2026-01-20 09:00:00','2026-01-20 18:30:00',NULL),
('attend-433','emp-020','2026-01-21','2026-01-21 09:20:00','2026-01-21 18:30:00','late',0,'2026-01-21 09:20:00','2026-01-21 18:30:00',NULL),
('attend-434','emp-020','2026-01-22','2026-01-22 09:00:00','2026-01-22 18:30:00','present',0,'2026-01-22 09:00:00','2026-01-22 18:30:00',NULL),
('attend-435','emp-020','2026-01-23','2026-01-23 09:00:00','2026-01-23 18:30:00','present',0,'2026-01-23 09:00:00','2026-01-23 18:30:00',NULL),
('attend-436','emp-020','2026-01-26','2026-01-26 09:00:00','2026-01-26 18:30:00','present',0,'2026-01-26 09:00:00','2026-01-26 18:30:00',NULL),
('attend-437','emp-020','2026-01-27','2026-01-27 09:00:00','2026-01-27 18:30:00','present',0,'2026-01-27 09:00:00','2026-01-27 18:30:00',NULL),
('attend-438','emp-020','2026-01-28','2026-01-28 09:00:00','2026-01-28 18:30:00','present',0,'2026-01-28 09:00:00','2026-01-28 18:30:00',NULL),
('attend-439','emp-020','2026-01-29','2026-01-29 09:00:00','2026-01-29 18:30:00','present',0,'2026-01-29 09:00:00','2026-01-29 18:30:00',NULL),
('attend-440','emp-020','2026-01-30','2026-01-30 09:00:00','2026-01-30 18:30:00','present',0,'2026-01-30 09:00:00','2026-01-30 18:30:00',NULL);

-- ============================================
-- SALARY_RECORDS TABLE (240 records - 20 employees x 12 months)
-- ============================================
INSERT INTO `salary_records` (`uuid`, `employee_id`, `month`, `year`, `base_salary`, `working_days`, `attendance_days`, `gross_salary`, `total_deductions`, `net_salary`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
('sal-001', 'emp-001', 1, 2026, 120000, 22, 20, 130909, 25636, 105273, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-002', 'emp-001', 2, 2026, 120000, 20, 19, 114545, 22545, 92000, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-003', 'emp-001', 3, 2026, 120000, 22, 22, 130909, 25636, 105273, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-004', 'emp-001', 4, 2026, 120000, 22, 21, 125454, 24636, 100818, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-005', 'emp-001', 5, 2026, 120000, 22, 22, 130909, 25636, 105273, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-006', 'emp-001', 6, 2026, 120000, 22, 20, 119454, 23636, 95818, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-007', 'emp-001', 7, 2026, 120000, 23, 22, 137391, 26691, 110700, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-008', 'emp-001', 8, 2026, 120000, 23, 23, 137391, 26691, 110700, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-009', 'emp-001', 9, 2026, 120000, 22, 21, 125454, 24636, 100818, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-010', 'emp-001', 10, 2026, 120000, 23, 22, 137391, 26691, 110700, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-011', 'emp-001', 11, 2026, 120000, 22, 22, 130909, 25636, 105273, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-012', 'emp-001', 12, 2026, 120000, 22, 22, 130909, 25636, 105273, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-013', 'emp-002', 1, 2026, 120000, 22, 21, 125454, 24636, 100818, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-014', 'emp-002', 2, 2026, 120000, 20, 20, 120000, 23545, 96455, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-015', 'emp-002', 3, 2026, 120000, 22, 22, 130909, 25636, 105273, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-016', 'emp-002', 4, 2026, 120000, 22, 22, 130909, 25636, 105273, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-017', 'emp-002', 5, 2026, 120000, 22, 21, 125454, 24636, 100818, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-018', 'emp-002', 6, 2026, 120000, 22, 22, 130909, 25636, 105273, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-019', 'emp-002', 7, 2026, 120000, 23, 23, 137391, 26691, 110700, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-020', 'emp-002', 8, 2026, 120000, 23, 22, 137391, 26691, 110700, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-021', 'emp-002', 9, 2026, 120000, 22, 22, 130909, 25636, 105273, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-022', 'emp-002', 10, 2026, 120000, 23, 21, 137391, 26691, 110700, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-023', 'emp-002', 11, 2026, 120000, 22, 22, 130909, 25636, 105273, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-024', 'emp-002', 12, 2026, 120000, 22, 22, 130909, 25636, 105273, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-025', 'emp-003', 1, 2026, 80000, 22, 20, 86939, 17091, 69848, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-026', 'emp-003', 2, 2026, 80000, 20, 18, 72000, 14182, 57818, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-027', 'emp-003', 3, 2026, 80000, 22, 19, 81939, 16091, 65848, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-028', 'emp-003', 4, 2026, 80000, 22, 22, 86939, 17091, 69848, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-029', 'emp-003', 5, 2026, 80000, 22, 21, 80000, 15727, 64273, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-030', 'emp-003', 6, 2026, 80000, 22, 22, 86939, 17091, 69848, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-031', 'emp-003', 7, 2026, 80000, 23, 21, 91594, 18000, 73594, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-032', 'emp-003', 8, 2026, 80000, 23, 23, 91594, 18000, 73594, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-033', 'emp-003', 9, 2026, 80000, 22, 20, 86939, 17091, 69848, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-034', 'emp-003', 10, 2026, 80000, 23, 23, 91594, 18000, 73594, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-035', 'emp-003', 11, 2026, 80000, 22, 22, 86939, 17091, 69848, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-036', 'emp-003', 12, 2026, 80000, 22, 22, 86939, 17091, 69848, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-037', 'emp-004', 1, 2026, 80000, 22, 22, 86939, 17091, 69848, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-038', 'emp-004', 2, 2026, 80000, 20, 20, 80000, 15727, 64273, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-039', 'emp-004', 3, 2026, 80000, 22, 22, 86939, 17091, 69848, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-040', 'emp-004', 4, 2026, 80000, 22, 22, 86939, 17091, 69848, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-041', 'emp-004', 5, 2026, 80000, 22, 22, 86939, 17091, 69848, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-042', 'emp-004', 6, 2026, 80000, 22, 22, 86939, 17091, 69848, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-043', 'emp-004', 7, 2026, 80000, 23, 23, 91594, 18000, 73594, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-044', 'emp-004', 8, 2026, 80000, 23, 23, 91594, 18000, 73594, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-045', 'emp-004', 9, 2026, 80000, 22, 22, 86939, 17091, 69848, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-046', 'emp-004', 10, 2026, 80000, 23, 23, 91594, 18000, 73594, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-047', 'emp-004', 11, 2026, 80000, 22, 22, 86939, 17091, 69848, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-048', 'emp-004', 12, 2026, 80000, 22, 22, 86939, 17091, 69848, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-049', 'emp-005', 1, 2026, 110000, 22, 22, 119545, 23454, 96091, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-050', 'emp-005', 2, 2026, 110000, 20, 20, 110000, 21636, 88364, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-051', 'emp-005', 3, 2026, 110000, 22, 22, 119545, 23454, 96091, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-052', 'emp-005', 4, 2026, 110000, 22, 21, 114545, 22454, 92091, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-053', 'emp-005', 5, 2026, 110000, 22, 22, 119545, 23454, 96091, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-054', 'emp-005', 6, 2026, 110000, 22, 20, 109545, 21454, 88091, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-055', 'emp-005', 7, 2026, 110000, 23, 23, 125652, 24609, 101043, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-056', 'emp-005', 8, 2026, 110000, 23, 22, 125652, 24609, 101043, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-057', 'emp-005', 9, 2026, 110000, 22, 22, 119545, 23454, 96091, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-058', 'emp-005', 10, 2026, 110000, 23, 22, 125652, 24609, 101043, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-059', 'emp-005', 11, 2026, 110000, 22, 22, 119545, 23454, 96091, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-060', 'emp-005', 12, 2026, 110000, 22, 22, 119545, 23454, 96091, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-061', 'emp-006', 1, 2026, 75000, 22, 22, 81818, 16091, 65727, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-062', 'emp-006', 2, 2026, 75000, 20, 20, 75000, 14727, 60273, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-063', 'emp-006', 3, 2026, 75000, 22, 22, 81818, 16091, 65727, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-064', 'emp-006', 4, 2026, 75000, 22, 22, 81818, 16091, 65727, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-065', 'emp-006', 5, 2026, 75000, 22, 22, 81818, 16091, 65727, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-066', 'emp-006', 6, 2026, 75000, 22, 21, 78409, 15409, 62999, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-067', 'emp-006', 7, 2026, 75000, 23, 23, 85869, 16909, 68960, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-068', 'emp-006', 8, 2026, 75000, 23, 23, 85869, 16909, 68960, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-069', 'emp-006', 9, 2026, 75000, 22, 22, 81818, 16091, 65727, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-070', 'emp-006', 10, 2026, 75000, 23, 23, 85869, 16909, 68960, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-071', 'emp-006', 11, 2026, 75000, 22, 22, 81818, 16091, 65727, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-072', 'emp-006', 12, 2026, 75000, 22, 22, 81818, 16091, 65727, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-073', 'emp-007', 1, 2026, 50000, 22, 22, 54545, 10727, 43818, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-074', 'emp-007', 2, 2026, 50000, 20, 20, 50000, 9818, 40182, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-075', 'emp-007', 3, 2026, 50000, 22, 22, 54545, 10727, 43818, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-076', 'emp-007', 4, 2026, 50000, 22, 21, 50000, 9818, 40182, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-077', 'emp-007', 5, 2026, 50000, 22, 22, 54545, 10727, 43818, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-078', 'emp-007', 6, 2026, 50000, 22, 22, 54545, 10727, 43818, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-079', 'emp-007', 7, 2026, 50000, 23, 23, 57246, 11246, 45999, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-080', 'emp-007', 8, 2026, 50000, 23, 22, 57246, 11246, 45999, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-081', 'emp-007', 9, 2026, 50000, 22, 22, 54545, 10727, 43818, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-082', 'emp-007', 10, 2026, 50000, 23, 23, 57246, 11246, 45999, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-083', 'emp-007', 11, 2026, 50000, 22, 22, 54545, 10727, 43818, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-084', 'emp-007', 12, 2026, 50000, 22, 22, 54545, 10727, 43818, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-085', 'emp-008', 1, 2026, 95000, 22, 22, 103409, 20318, 83091, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-086', 'emp-008', 2, 2026, 95000, 20, 20, 95000, 18682, 76318, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-087', 'emp-008', 3, 2026, 95000, 22, 22, 103409, 20318, 83091, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-088', 'emp-008', 4, 2026, 95000, 22, 21, 98409, 19318, 79091, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-089', 'emp-008', 5, 2026, 95000, 22, 22, 103409, 20318, 83091, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-090', 'emp-008', 6, 2026, 95000, 22, 22, 103409, 20318, 83091, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-091', 'emp-008', 7, 2026, 95000, 23, 23, 109913, 21609, 88304, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-092', 'emp-008', 8, 2026, 95000, 23, 22, 109913, 21609, 88304, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-093', 'emp-008', 9, 2026, 95000, 22, 22, 103409, 20318, 83091, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-094', 'emp-008', 10, 2026, 95000, 23, 23, 109913, 21609, 88304, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-095', 'emp-008', 11, 2026, 95000, 22, 22, 103409, 20318, 83091, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-096', 'emp-008', 12, 2026, 95000, 22, 22, 103409, 20318, 83091, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-097', 'emp-009', 1, 2026, 130000, 22, 22, 141364, 27727, 113636, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-098', 'emp-009', 2, 2026, 130000, 20, 20, 130000, 25545, 104454, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-099', 'emp-009', 3, 2026, 130000, 22, 22, 141364, 27727, 113636, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-100', 'emp-009', 4, 2026, 130000, 22, 21, 136364, 26727, 109636, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-101', 'emp-009', 5, 2026, 130000, 22, 22, 141364, 27727, 113636, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-102', 'emp-009', 6, 2026, 130000, 22, 22, 141364, 27727, 113636, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-103', 'emp-009', 7, 2026, 130000, 23, 23, 149565, 29304, 120260, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-104', 'emp-009', 8, 2026, 130000, 23, 22, 149565, 29304, 120260, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-105', 'emp-009', 9, 2026, 130000, 22, 22, 141364, 27727, 113636, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-106', 'emp-009', 10, 2026, 130000, 23, 23, 149565, 29304, 120260, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-107', 'emp-009', 11, 2026, 130000, 22, 22, 141364, 27727, 113636, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-108', 'emp-009', 12, 2026, 130000, 22, 22, 141364, 27727, 113636, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-109', 'emp-010', 1, 2026, 115000, 22, 22, 125000, 24545, 100454, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-110', 'emp-010', 2, 2026, 115000, 20, 20, 115000, 22590, 92409, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-111', 'emp-010', 3, 2026, 115000, 22, 22, 125000, 24545, 100454, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-112', 'emp-010', 4, 2026, 115000, 22, 21, 120000, 23545, 96454, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-113', 'emp-010', 5, 2026, 115000, 22, 22, 125000, 24545, 100454, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-114', 'emp-010', 6, 2026, 115000, 22, 22, 125000, 24545, 100454, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-115', 'emp-010', 7, 2026, 115000, 23, 23, 132609, 26043, 106565, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-116', 'emp-010', 8, 2026, 115000, 23, 22, 132609, 26043, 106565, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-117', 'emp-010', 9, 2026, 115000, 22, 22, 125000, 24545, 100454, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-118', 'emp-010', 10, 2026, 115000, 23, 23, 132609, 26043, 106565, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-119', 'emp-010', 11, 2026, 115000, 22, 22, 125000, 24545, 100454, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-120', 'emp-010', 12, 2026, 115000, 22, 22, 125000, 24545, 100454, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-121', 'emp-011', 1, 2026, 70000, 22, 22, 76364, 15000, 61364, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-122', 'emp-011', 2, 2026, 70000, 20, 20, 70000, 13727, 56272, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-123', 'emp-011', 3, 2026, 70000, 22, 22, 76364, 15000, 61364, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-124', 'emp-011', 4, 2026, 70000, 22, 21, 70000, 13727, 56272, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-125', 'emp-011', 5, 2026, 70000, 22, 22, 76364, 15000, 61364, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-126', 'emp-011', 6, 2026, 70000, 22, 22, 76364, 15000, 61364, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-127', 'emp-011', 7, 2026, 70000, 23, 23, 79565, 15609, 63956, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-128', 'emp-011', 8, 2026, 70000, 23, 22, 79565, 15609, 63956, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-129', 'emp-011', 9, 2026, 70000, 22, 22, 76364, 15000, 61364, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-130', 'emp-011', 10, 2026, 70000, 23, 23, 79565, 15609, 63956, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-131', 'emp-011', 11, 2026, 70000, 22, 22, 76364, 15000, 61364, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-132', 'emp-011', 12, 2026, 70000, 22, 22, 76364, 15000, 61364, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-133', 'emp-012', 1, 2026, 85000, 22, 22, 92454, 18181, 74272, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-134', 'emp-012', 2, 2026, 85000, 20, 20, 85000, 16727, 68272, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-135', 'emp-012', 3, 2026, 85000, 22, 22, 92454, 18181, 74272, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-136', 'emp-012', 4, 2026, 85000, 22, 21, 87454, 17181, 70272, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-137', 'emp-012', 5, 2026, 85000, 22, 22, 92454, 18181, 74272, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-138', 'emp-012', 6, 2026, 85000, 22, 22, 92454, 18181, 74272, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-139', 'emp-012', 7, 2026, 85000, 23, 23, 99130, 19435, 79695, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-140', 'emp-012', 8, 2026, 85000, 23, 22, 99130, 19435, 79695, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-141', 'emp-012', 9, 2026, 85000, 22, 22, 92454, 18181, 74272, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-142', 'emp-012', 10, 2026, 85000, 23, 23, 99130, 19435, 79695, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-143', 'emp-012', 11, 2026, 85000, 22, 22, 92454, 18181, 74272, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-144', 'emp-012', 12, 2026, 85000, 22, 22, 92454, 18181, 74272, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-145', 'emp-013', 1, 2026, 100000, 22, 22, 109091, 21409, 87681, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-146', 'emp-013', 2, 2026, 100000, 20, 20, 100000, 19636, 80363, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-147', 'emp-013', 3, 2026, 100000, 22, 22, 109091, 21409, 87681, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-148', 'emp-013', 4, 2026, 100000, 22, 21, 104091, 20409, 83681, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-149', 'emp-013', 5, 2026, 100000, 22, 22, 109091, 21409, 87681, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-150', 'emp-013', 6, 2026, 100000, 22, 22, 109091, 21409, 87681, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-151', 'emp-013', 7, 2026, 100000, 23, 23, 117391, 23043, 94347, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-152', 'emp-013', 8, 2026, 100000, 23, 22, 117391, 23043, 94347, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-153', 'emp-013', 9, 2026, 100000, 22, 22, 109091, 21409, 87681, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-154', 'emp-013', 10, 2026, 100000, 23, 23, 117391, 23043, 94347, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-155', 'emp-013', 11, 2026, 100000, 22, 22, 109091, 21409, 87681, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-156', 'emp-013', 12, 2026, 100000, 22, 22, 109091, 21409, 87681, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-157', 'emp-014', 1, 2026, 65000, 22, 22, 70682, 13909, 56772, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-158', 'emp-014', 2, 2026, 65000, 20, 20, 65000, 12727, 52272, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-159', 'emp-014', 3, 2026, 65000, 22, 22, 70682, 13909, 56772, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-160', 'emp-014', 4, 2026, 65000, 22, 21, 65000, 12727, 52272, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-161', 'emp-014', 5, 2026, 65000, 22, 22, 70682, 13909, 56772, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-162', 'emp-014', 6, 2026, 65000, 22, 22, 70682, 13909, 56772, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-163', 'emp-014', 7, 2026, 65000, 23, 23, 74652, 14652, 59999, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-164', 'emp-014', 8, 2026, 65000, 23, 22, 74652, 14652, 59999, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-165', 'emp-014', 9, 2026, 65000, 22, 22, 70682, 13909, 56772, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-166', 'emp-014', 10, 2026, 65000, 23, 23, 74652, 14652, 59999, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-167', 'emp-014', 11, 2026, 65000, 22, 22, 70682, 13909, 56772, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-168', 'emp-014', 12, 2026, 65000, 22, 22, 70682, 13909, 56772, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-169', 'emp-015', 1, 2026, 72000, 22, 22, 78545, 15409, 63136, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-170', 'emp-015', 2, 2026, 72000, 20, 20, 72000, 14136, 57863, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-171', 'emp-015', 3, 2026, 72000, 22, 22, 78545, 15409, 63136, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-172', 'emp-015', 4, 2026, 72000, 22, 21, 72000, 14136, 57863, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-173', 'emp-015', 5, 2026, 72000, 22, 22, 78545, 15409, 63136, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-174', 'emp-015', 6, 2026, 72000, 22, 22, 78545, 15409, 63136, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-175', 'emp-015', 7, 2026, 72000, 23, 23, 82826, 16261, 66565, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-176', 'emp-015', 8, 2026, 72000, 23, 22, 82826, 16261, 66565, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-177', 'emp-015', 9, 2026, 72000, 22, 22, 78545, 15409, 63136, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-178', 'emp-015', 10, 2026, 72000, 23, 23, 82826, 16261, 66565, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-179', 'emp-015', 11, 2026, 72000, 22, 22, 78545, 15409, 63136, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-180', 'emp-015', 12, 2026, 72000, 22, 22, 78545, 15409, 63136, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-181', 'emp-016', 1, 2026, 58000, 22, 22, 63091, 12409, 50681, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-182', 'emp-016', 2, 2026, 58000, 20, 20, 58000, 11409, 46590, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-183', 'emp-016', 3, 2026, 58000, 22, 22, 63091, 12409, 50681, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-184', 'emp-016', 4, 2026, 58000, 22, 21, 58000, 11409, 46590, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-185', 'emp-016', 5, 2026, 58000, 22, 22, 63091, 12409, 50681, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-186', 'emp-016', 6, 2026, 58000, 22, 22, 63091, 12409, 50681, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-187', 'emp-016', 7, 2026, 58000, 23, 23, 66478, 13043, 53434, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-188', 'emp-016', 8, 2026, 58000, 23, 22, 66478, 13043, 53434, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-189', 'emp-016', 9, 2026, 58000, 22, 22, 63091, 12409, 50681, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-190', 'emp-016', 10, 2026, 58000, 23, 23, 66478, 13043, 53434, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-191', 'emp-016', 11, 2026, 58000, 22, 22, 63091, 12409, 50681, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-192', 'emp-016', 12, 2026, 58000, 22, 22, 63091, 12409, 50681, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-193', 'emp-017', 1, 2026, 105000, 22, 22, 114318, 22454, 91863, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-194', 'emp-017', 2, 2026, 105000, 20, 20, 105000, 20636, 84363, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-195', 'emp-017', 3, 2026, 105000, 22, 22, 114318, 22454, 91863, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-196', 'emp-017', 4, 2026, 105000, 22, 21, 109318, 21454, 87863, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-197', 'emp-017', 5, 2026, 105000, 22, 22, 114318, 22454, 91863, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-198', 'emp-017', 6, 2026, 105000, 22, 22, 114318, 22454, 91863, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-199', 'emp-017', 7, 2026, 105000, 23, 23, 122173, 24000, 98173, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-200', 'emp-017', 8, 2026, 105000, 23, 22, 122173, 24000, 98173, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-201', 'emp-017', 9, 2026, 105000, 22, 22, 114318, 22454, 91863, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-202', 'emp-017', 10, 2026, 105000, 23, 23, 122173, 24000, 98173, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-203', 'emp-017', 11, 2026, 105000, 22, 22, 114318, 22454, 91863, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-204', 'emp-017', 12, 2026, 105000, 22, 22, 114318, 22454, 91863, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-205', 'emp-018', 1, 2026, 62000, 22, 22, 67409, 13245, 54163, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-206', 'emp-018', 2, 2026, 62000, 20, 20, 62000, 12181, 49818, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-207', 'emp-018', 3, 2026, 62000, 22, 22, 67409, 13245, 54163, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-208', 'emp-018', 4, 2026, 62000, 22, 21, 62000, 12181, 49818, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-209', 'emp-018', 5, 2026, 62000, 22, 22, 67409, 13245, 54163, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-210', 'emp-018', 6, 2026, 62000, 22, 22, 67409, 13245, 54163, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-211', 'emp-018', 7, 2026, 62000, 23, 23, 71130, 13978, 57151, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-212', 'emp-018', 8, 2026, 62000, 23, 22, 71130, 13978, 57151, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-213', 'emp-018', 9, 2026, 62000, 22, 22, 67409, 13245, 54163, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-214', 'emp-018', 10, 2026, 62000, 23, 23, 71130, 13978, 57151, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-215', 'emp-018', 11, 2026, 62000, 22, 22, 67409, 13245, 54163, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-216', 'emp-018', 12, 2026, 62000, 22, 22, 67409, 13245, 54163, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-217', 'emp-019', 1, 2026, 90000, 22, 22, 97909, 19227, 78681, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-218', 'emp-019', 2, 2026, 90000, 20, 20, 90000, 17727, 72272, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-219', 'emp-019', 3, 2026, 90000, 22, 22, 97909, 19227, 78681, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-220', 'emp-019', 4, 2026, 90000, 22, 21, 92909, 18227, 74681, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-221', 'emp-019', 5, 2026, 90000, 22, 22, 97909, 19227, 78681, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-222', 'emp-019', 6, 2026, 90000, 22, 22, 97909, 19227, 78681, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-223', 'emp-019', 7, 2026, 90000, 23, 23, 104565, 20609, 83956, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-224', 'emp-019', 8, 2026, 90000, 23, 22, 104565, 20609, 83956, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-225', 'emp-019', 9, 2026, 90000, 22, 22, 97909, 19227, 78681, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-226', 'emp-019', 10, 2026, 90000, 23, 23, 104565, 20609, 83956, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-227', 'emp-019', 11, 2026, 90000, 22, 22, 97909, 19227, 78681, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-228', 'emp-019', 12, 2026, 90000, 22, 22, 97909, 19227, 78681, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL),
('sal-229', 'emp-020', 1, 2026, 55000, 22, 22, 59818, 11727, 48090, 'calculated', '2026-01-31 23:59:59', '2026-01-31 23:59:59', NULL),
('sal-230', 'emp-020', 2, 2026, 55000, 20, 20, 55000, 10818, 44181, 'calculated', '2026-02-28 23:59:59', '2026-02-28 23:59:59', NULL),
('sal-231', 'emp-020', 3, 2026, 55000, 22, 22, 59818, 11727, 48090, 'calculated', '2026-03-31 23:59:59', '2026-03-31 23:59:59', NULL),
('sal-232', 'emp-020', 4, 2026, 55000, 22, 21, 55000, 10818, 44181, 'calculated', '2026-04-30 23:59:59', '2026-04-30 23:59:59', NULL),
('sal-233', 'emp-020', 5, 2026, 55000, 22, 22, 59818, 11727, 48090, 'calculated', '2026-05-31 23:59:59', '2026-05-31 23:59:59', NULL),
('sal-234', 'emp-020', 6, 2026, 55000, 22, 22, 59818, 11727, 48090, 'calculated', '2026-06-30 23:59:59', '2026-06-30 23:59:59', NULL),
('sal-235', 'emp-020', 7, 2026, 55000, 23, 23, 63478, 12478, 50999, 'calculated', '2026-07-31 23:59:59', '2026-07-31 23:59:59', NULL),
('sal-236', 'emp-020', 8, 2026, 55000, 23, 22, 63478, 12478, 50999, 'calculated', '2026-08-31 23:59:59', '2026-08-31 23:59:59', NULL),
('sal-237', 'emp-020', 9, 2026, 55000, 22, 22, 59818, 11727, 48090, 'calculated', '2026-09-30 23:59:59', '2026-09-30 23:59:59', NULL),
('sal-238', 'emp-020', 10, 2026, 55000, 23, 23, 63478, 12478, 50999, 'calculated', '2026-10-31 23:59:59', '2026-10-31 23:59:59', NULL),
('sal-239', 'emp-020', 11, 2026, 55000, 22, 22, 59818, 11727, 48090, 'calculated', '2026-11-30 23:59:59', '2026-11-30 23:59:59', NULL),
('sal-240', 'emp-020', 12, 2026, 55000, 22, 22, 59818, 11727, 48090, 'calculated', '2026-12-31 23:59:59', '2026-12-31 23:59:59', NULL);

-- ============================================
-- LEAVES TABLE (20 records)
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
('leave-010', 'emp-001', 'leave', 'planned', '2026-03-15', '2026-03-20', 6, 'pending', 'Family trip to Kerala', '', 'emp-007', NULL, '2026-01-25 10:00:00', '2026-01-25 10:00:00', NULL),
('leave-011', 'emp-011', 'leave', 'planned', '2026-02-20', '2026-02-22', 3, 'approved', 'Wedding preparation', '', 'emp-007', '2026-01-28 10:00:00', '2026-01-27 09:00:00', '2026-01-28 10:00:00', NULL),
('leave-012', 'emp-012', 'work_from_home', 'planned', '2026-01-31', '2026-01-31', 1, 'approved', 'System upgrade at home', '', 'emp-007', '2026-01-30 14:00:00', '2026-01-30 12:00:00', '2026-01-30 14:00:00', NULL),
('leave-013', 'emp-013', 'leave', 'sick', '2026-02-02', '2026-02-02', 1, 'pending', 'Migraine', '', 'emp-007', NULL, '2026-01-31 11:00:00', '2026-01-31 11:00:00', NULL),
('leave-014', 'emp-014', 'leave', 'planned', '2026-02-08', '2026-02-09', 2, 'approved', 'Conference attendance', '', 'emp-007', '2026-02-01 16:00:00', '2026-01-31 14:00:00', '2026-02-01 16:00:00', NULL),
('leave-015', 'emp-015', 'leave', 'first_half', '2026-02-04', '2026-02-04', 1, 'approved', 'College fee submission', '', 'emp-007', '2026-02-03 10:00:00', '2026-02-03 09:00:00', '2026-02-03 10:00:00', NULL),
('leave-016', 'emp-016', 'leave', 'second_half', '2026-02-05', '2026-02-05', 1, 'pending', 'Office work at home', '', 'emp-007', NULL, '2026-02-04 11:00:00', '2026-02-04 11:00:00', NULL),
('leave-017', 'emp-017', 'leave', 'planned', '2026-02-15', '2026-02-17', 3, 'approved', 'Project submission', '', 'emp-007', '2026-02-10 15:00:00', '2026-02-10 13:00:00', '2026-02-10 15:00:00', NULL),
('leave-018', 'emp-018', 'work_from_home', 'planned', '2026-02-06', '2026-02-06', 1, 'approved', 'Delivery at home', '', 'emp-007', '2026-02-05 10:00:00', '2026-02-05 09:00:00', '2026-02-05 10:00:00', NULL),
('leave-019', 'emp-019', 'leave', 'sick', '2026-02-07', '2026-02-08', 2, 'pending', 'Tooth pain', '', 'emp-007', NULL, '2026-02-06 12:00:00', '2026-02-06 12:00:00', NULL),
('leave-020', 'emp-020', 'leave', 'planned', '2026-02-18', '2026-02-19', 2, 'approved', 'Personal errands', '', 'emp-007', '2026-02-15 16:00:00', '2026-02-15 14:00:00', '2026-02-15 16:00:00', NULL);

-- ============================================
-- SALARY_DEDUCTIONS TABLE (sample deductions for salary calculation)
-- ============================================
INSERT INTO `salary_deductions` (`uuid`, `salary_record_id`, `deduction_type`, `amount`, `description`, `created_at`, `updated_at`) VALUES
('deduct-001', 'sal-001', 'PF', 14400, 'Provident Fund - 12% of base salary', '2026-01-31 23:59:59', '2026-01-31 23:59:59'),
('deduct-002', 'sal-001', 'ESI', 5700, 'ESI Insurance - 4.75% of base salary', '2026-01-31 23:59:59', '2026-01-31 23:59:59'),
('deduct-003', 'sal-001', 'Income Tax', 4800, 'Income Tax Deduction', '2026-01-31 23:59:59', '2026-01-31 23:59:59'),
('deduct-004', 'sal-001', 'Health Insurance', 736, 'Health Insurance Premium', '2026-01-31 23:59:59', '2026-01-31 23:59:59'),
('deduct-005', 'sal-002', 'PF', 14400, 'Provident Fund - 12% of base salary', '2026-02-28 23:59:59', '2026-02-28 23:59:59'),
('deduct-006', 'sal-002', 'ESI', 5700, 'ESI Insurance - 4.75% of base salary', '2026-02-28 23:59:59', '2026-02-28 23:59:59'),
('deduct-007', 'sal-002', 'Income Tax', 2445, 'Income Tax Deduction', '2026-02-28 23:59:59', '2026-02-28 23:59:59'),
('deduct-008', 'sal-003', 'PF', 14400, 'Provident Fund - 12% of base salary', '2026-03-31 23:59:59', '2026-03-31 23:59:59'),
('deduct-009', 'sal-003', 'ESI', 5700, 'ESI Insurance - 4.75% of base salary', '2026-03-31 23:59:59', '2026-03-31 23:59:59'),
('deduct-010', 'sal-003', 'Income Tax', 4800, 'Income Tax Deduction', '2026-03-31 23:59:59', '2026-03-31 23:59:59'),
('deduct-011', 'sal-004', 'PF', 13200, 'Provident Fund - 12% of base salary', '2026-04-30 23:59:59', '2026-04-30 23:59:59'),
('deduct-012', 'sal-004', 'ESI', 5700, 'ESI Insurance - 4.75% of base salary', '2026-04-30 23:59:59', '2026-04-30 23:59:59'),
('deduct-013', 'sal-004', 'Income Tax', 4200, 'Income Tax Deduction', '2026-04-30 23:59:59', '2026-04-30 23:59:59'),
('deduct-014', 'sal-013', 'PF', 14400, 'Provident Fund - 12% of base salary', '2026-01-31 23:59:59', '2026-01-31 23:59:59'),
('deduct-015', 'sal-013', 'ESI', 5700, 'ESI Insurance - 4.75% of base salary', '2026-01-31 23:59:59', '2026-01-31 23:59:59'),
('deduct-016', 'sal-013', 'Income Tax', 4200, 'Income Tax Deduction', '2026-01-31 23:59:59', '2026-01-31 23:59:59'),
('deduct-017', 'sal-025', 'PF', 9600, 'Provident Fund - 12% of base salary', '2026-01-31 23:59:59', '2026-01-31 23:59:59'),
('deduct-018', 'sal-025', 'ESI', 3800, 'ESI Insurance - 4.75% of base salary', '2026-01-31 23:59:59', '2026-01-31 23:59:59'),
('deduct-019', 'sal-025', 'Income Tax', 3400, 'Income Tax Deduction', '2026-01-31 23:59:59', '2026-01-31 23:59:59'),
('deduct-020', 'sal-073', 'PF', 6000, 'Provident Fund - 12% of base salary', '2026-01-31 23:59:59', '2026-01-31 23:59:59');

-- ============================================
-- SALARY_BONUSES TABLE (performance and festival bonuses)
-- ============================================
INSERT INTO `salary_bonuses` (`uuid`, `employee_id`, `month`, `year`, `bonus_type`, `amount`, `reason`, `approved_by`, `created_at`, `updated_at`) VALUES
('bonus-001', 'emp-001', 1, 2026, 'Performance Bonus', 6000, 'Excellent project delivery and client satisfaction', 'emp-007', '2026-01-31 23:59:59', '2026-01-31 23:59:59'),
('bonus-002', 'emp-001', 3, 2026, 'Holi Bonus', 5000, 'Festival bonus for Holi celebration', 'emp-007', '2026-03-31 23:59:59', '2026-03-31 23:59:59'),
('bonus-003', 'emp-001', 8, 2026, 'Independence Day Bonus', 4000, 'National holiday bonus', 'emp-007', '2026-08-31 23:59:59', '2026-08-31 23:59:59'),
('bonus-004', 'emp-001', 11, 2026, 'Diwali Bonus', 7000, 'Festival bonus for Diwali celebration', 'emp-007', '2026-11-30 23:59:59', '2026-11-30 23:59:59'),
('bonus-005', 'emp-002', 2, 2026, 'Performance Bonus', 5000, 'Consistent high performance', 'emp-007', '2026-02-28 23:59:59', '2026-02-28 23:59:59'),
('bonus-006', 'emp-002', 3, 2026, 'Perfect Attendance Bonus', 3000, 'Perfect attendance throughout March', 'emp-007', '2026-03-31 23:59:59', '2026-03-31 23:59:59'),
('bonus-007', 'emp-002', 11, 2026, 'Diwali Bonus', 7000, 'Festival bonus for Diwali celebration', 'emp-007', '2026-11-30 23:59:59', '2026-11-30 23:59:59'),
('bonus-008', 'emp-003', 5, 2026, 'Performance Bonus', 4000, 'Good work on critical projects', 'emp-007', '2026-05-31 23:59:59', '2026-05-31 23:59:59'),
('bonus-009', 'emp-003', 8, 2026, 'Independence Day Bonus', 4000, 'National holiday bonus', 'emp-007', '2026-08-31 23:59:59', '2026-08-31 23:59:59'),
('bonus-010', 'emp-004', 1, 2026, 'Performance Bonus', 4800, 'Excellent performance in Q1', 'emp-007', '2026-01-31 23:59:59', '2026-01-31 23:59:59'),
('bonus-011', 'emp-004', 3, 2026, 'Perfect Attendance Bonus', 2500, 'Perfect attendance throughout March', 'emp-007', '2026-03-31 23:59:59', '2026-03-31 23:59:59'),
('bonus-012', 'emp-004', 11, 2026, 'Diwali Bonus', 6000, 'Festival bonus for Diwali celebration', 'emp-007', '2026-11-30 23:59:59', '2026-11-30 23:59:59'),
('bonus-013', 'emp-005', 2, 2026, 'Performance Bonus', 5500, 'Exceptional technical contributions', 'emp-007', '2026-02-28 23:59:59', '2026-02-28 23:59:59'),
('bonus-014', 'emp-005', 8, 2026, 'Independence Day Bonus', 4500, 'National holiday bonus', 'emp-007', '2026-08-31 23:59:59', '2026-08-31 23:59:59'),
('bonus-015', 'emp-006', 3, 2026, 'Perfect Attendance Bonus', 3000, 'Perfect attendance throughout March', 'emp-007', '2026-03-31 23:59:59', '2026-03-31 23:59:59'),
('bonus-016', 'emp-006', 11, 2026, 'Diwali Bonus', 5000, 'Festival bonus for Diwali celebration', 'emp-007', '2026-11-30 23:59:59', '2026-11-30 23:59:59'),
('bonus-017', 'emp-007', 1, 2026, 'Performance Bonus', 3000, 'Good work quality', 'emp-007', '2026-01-31 23:59:59', '2026-01-31 23:59:59'),
('bonus-018', 'emp-007', 8, 2026, 'Independence Day Bonus', 2500, 'National holiday bonus', 'emp-007', '2026-08-31 23:59:59', '2026-08-31 23:59:59'),
('bonus-019', 'emp-008', 2, 2026, 'Performance Bonus', 4750, 'Strong technical skills', 'emp-007', '2026-02-28 23:59:59', '2026-02-28 23:59:59'),
('bonus-020', 'emp-008', 3, 2026, 'Perfect Attendance Bonus', 2800, 'Perfect attendance throughout March', 'emp-007', '2026-03-31 23:59:59', '2026-03-31 23:59:59'),
('bonus-021', 'emp-009', 1, 2026, 'Performance Bonus', 6500, 'Leadership excellence', 'emp-007', '2026-01-31 23:59:59', '2026-01-31 23:59:59'),
('bonus-022', 'emp-009', 3, 2026, 'Holi Bonus', 6500, 'Festival bonus for Holi celebration', 'emp-007', '2026-03-31 23:59:59', '2026-03-31 23:59:59'),
('bonus-023', 'emp-009', 8, 2026, 'Independence Day Bonus', 5000, 'National holiday bonus', 'emp-007', '2026-08-31 23:59:59', '2026-08-31 23:59:59'),
('bonus-024', 'emp-009', 11, 2026, 'Diwali Bonus', 8000, 'Festival bonus for Diwali celebration', 'emp-007', '2026-11-30 23:59:59', '2026-11-30 23:59:59'),
('bonus-025', 'emp-010', 2, 2026, 'Performance Bonus', 5000, 'Consistent performance', 'emp-007', '2026-02-28 23:59:59', '2026-02-28 23:59:59'),
('bonus-026', 'emp-010', 8, 2026, 'Independence Day Bonus', 4500, 'National holiday bonus', 'emp-007', '2026-08-31 23:59:59', '2026-08-31 23:59:59'),
('bonus-027', 'emp-011', 1, 2026, 'Performance Bonus', 3500, 'Good work delivery', 'emp-007', '2026-01-31 23:59:59', '2026-01-31 23:59:59'),
('bonus-028', 'emp-011', 11, 2026, 'Diwali Bonus', 5000, 'Festival bonus for Diwali celebration', 'emp-007', '2026-11-30 23:59:59', '2026-11-30 23:59:59'),
('bonus-029', 'emp-012', 3, 2026, 'Perfect Attendance Bonus', 3100, 'Perfect attendance throughout March', 'emp-007', '2026-03-31 23:59:59', '2026-03-31 23:59:59'),
('bonus-030', 'emp-012', 8, 2026, 'Independence Day Bonus', 3500, 'National holiday bonus', 'emp-007', '2026-08-31 23:59:59', '2026-08-31 23:59:59');

-- ============================================
-- HOLIDAYS TABLE (15 records)
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
('holiday-010', 'Dussehra', '2026-10-13', 'Hindu festival celebrating victory of good over evil', '2026-01-01 10:45:00', '2026-01-01 10:45:00'),
('holiday-011', 'New Year', '2026-01-01', 'Celebrating the beginning of the new calendar year', '2026-01-01 10:50:00', '2026-01-01 10:50:00'),
('holiday-012', 'Eid-ul-Fitr', '2026-05-13', 'Islamic festival marking end of Ramadan', '2026-01-01 10:55:00', '2026-01-01 10:55:00'),
('holiday-013', 'Janmashtami', '2026-08-26', 'Hindu festival celebrating birth of Lord Krishna', '2026-01-01 11:00:00', '2026-01-01 11:00:00'),
('holiday-014', 'Mahavir Jayanti', '2026-04-20', 'Birth of Lord Mahavira', '2026-01-01 11:05:00', '2026-01-01 11:05:00'),
('holiday-015', 'Navratri', '2026-10-02', 'Hindu festival celebrated over nine days', '2026-01-01 11:10:00', '2026-01-01 11:10:00');

-- ============================================
-- INTERNS TABLE (15 records)
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
('intern-010', 'INT010', 'intern10.jpg', 'intern_face_010', 'Pavithra', 'Mohan', 'pavithra.mohan@student.edu', '+91-9123456799', 'desig-003', 'active', '$2y$10$intern010', '', NULL, 'Loyola College', 'Computer Applications', '3rd Year', '4 months', '2025-06-25', '2025-10-25', 'YZABC0123D', 'intern', 'Mohan Das', '+91-9123456800', '2003-10-08', '2003-10-08', 'A+', '123 Nungambakkam, Chennai', '456 Beach Road, Pondicherry', '2025-06-25 09:00:00', '2025-06-25 09:00:00', NULL),
('intern-011', 'INT011', 'intern11.jpg', 'intern_face_011', 'Rajesh', 'Kumar', 'rajesh.intern@student.edu', '+91-9123456801', 'desig-005', 'active', '$2y$10$intern011', '', NULL, 'IIT Bombay', 'Mechanical Engineering', '2nd Year', '6 months', '2025-05-01', '2025-10-31', 'ZABCD1234E', 'trainee', 'Kumar Ramakrishnan', '+91-9123456802', '2004-02-14', '2004-02-14', 'B+', '789 Powai, Mumbai', '123 Dadar, Mumbai', '2025-05-01 09:00:00', '2025-05-01 09:00:00', NULL),
('intern-012', 'INT012', 'intern12.jpg', 'intern_face_012', 'Ananya', 'Verma', 'ananya.intern@student.edu', '+91-9123456803', 'desig-006', 'active', '$2y$10$intern012', '', NULL, 'Delhi University', 'Computer Science', 'Final Year', '5 months', '2025-07-15', '2025-12-15', 'ABCDE2345F', 'intern', 'Verma Suresh', '+91-9123456804', '2002-08-22', '2002-08-22', 'O-', '654 Malviya Nagar, Delhi', '987 Laxmi Nagar, Delhi', '2025-07-15 09:00:00', '2025-07-15 09:00:00', NULL),
('intern-013', 'INT013', 'intern13.jpg', 'intern_face_013', 'Arjun', 'Singh', 'arjun.intern@student.edu', '+91-9123456805', 'desig-004', 'completed', '$2y$10$intern013', '', NULL, 'Presidency University', 'Engineering', 'Final Year', '6 months', '2024-11-15', '2025-05-15', 'BCDEF3456G', 'intern', 'Singh Rajendra', '+91-9123456806', '2002-10-30', '2002-10-30', 'A+', '123 Salt Lake, Kolkata', '456 Ballygunge, Kolkata', '2024-11-15 09:00:00', '2025-05-15 18:00:00', NULL),
('intern-014', 'INT014', 'intern14.jpg', 'intern_face_014', 'Divya', 'Pandey', 'divya.intern@student.edu', '+91-9123456807', 'desig-002', 'active', '$2y$10$intern014', '', NULL, 'BITS Pilani', 'Computer Science', '3rd Year', '4 months', '2025-06-10', '2025-10-10', 'CDEFG4567H', 'trainee', 'Pandey Anil', '+91-9123456808', '2003-12-05', '2003-12-05', 'AB+', '789 Campus, Pilani', '321 Railway Road, Agra', '2025-06-10 09:00:00', '2025-06-10 09:00:00', NULL),
('intern-015', 'INT015', 'intern15.jpg', 'intern_face_015', 'Saurav', 'Desai', 'saurav.intern@student.edu', '+91-9123456809', 'desig-003', 'active', '$2y$10$intern015', '', NULL, 'Manipal University', 'Information Technology', '2nd Year', '3 months', '2025-07-20', '2025-10-20', 'DEFGH5678I', 'intern', 'Desai Rajesh', '+91-9123456810', '2004-01-18', '2004-01-18', 'B-', '654 Manipal Campus', '987 Udupi Road, Bangalore', '2025-07-20 09:00:00', '2025-07-20 09:00:00', NULL);

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
-- NOTICE_BOARDS TABLE (15 records)
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
('notice-010', 'Welcome new team members joining us in February. Orientation on Feb 3rd', 'emp-007', '2026-01-28 09:00:00', '2026-01-28 09:00:00', NULL),
('notice-011', 'Workplace wellness program starts next month. Free health checkups available', 'emp-007', '2026-01-29 14:00:00', '2026-01-29 14:00:00', NULL),
('notice-012', 'IT Network maintenance scheduled for February 15th, 2-6 PM. Internet will be unavailable', 'emp-007', '2026-01-30 10:30:00', '2026-01-30 10:30:00', NULL),
('notice-013', 'New company app launched for employee engagement. Download instructions coming soon', 'emp-007', '2026-01-31 11:00:00', '2026-01-31 11:00:00', NULL),
('notice-014', 'Office closure notice: All employees are requested to submit their work by 3 PM on Feb 2nd', 'emp-007', '2026-02-01 09:00:00', '2026-02-01 09:00:00', NULL),
('notice-015', 'Training session on new workplace safety protocols on February 8th at 2 PM', 'emp-007', '2026-02-02 10:00:00', '2026-02-02 10:00:00', NULL);

-- ============================================
-- USERS TABLE (15 records)
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
(10, 'Product Manager', 'product@company.com', '2024-01-15 10:45:00', '$2y$10$prodpass010', 'remtoken010', '2024-01-15 10:45:00', '2024-01-15 10:45:00'),
(11, 'Compliance Officer', 'compliance@company.com', '2024-01-15 10:50:00', '$2y$10$comppass011', 'remtoken011', '2024-01-15 10:50:00', '2024-01-15 10:50:00'),
(12, 'Recruitment Head', 'recruitment@company.com', '2024-01-15 10:55:00', '$2y$10$recpass012', 'remtoken012', '2024-01-15 10:55:00', '2024-01-15 10:55:00'),
(13, 'Training Coordinator', 'training@company.com', '2024-01-15 11:00:00', '$2y$10$trainpass013', 'remtoken013', '2024-01-15 11:00:00', '2024-01-15 11:00:00'),
(14, 'Facilities Manager', 'facilities@company.com', '2024-01-15 11:05:00', '$2y$10$facpass014', 'remtoken014', '2024-01-15 11:05:00', '2024-01-15 11:05:00'),
(15, 'Legal Advisor', 'legal@company.com', '2024-01-15 11:10:00', '$2y$10$legpass015', 'remtoken015', '2024-01-15 11:10:00', '2024-01-15 11:10:00');

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
