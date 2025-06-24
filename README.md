# MySQL Database Configuration - DigitalSkola Homework 16


This project implements MySQL database configuration using Docker Compose to fulfill **DigitalSkola Homework 16 - Database Administrator** assignment. This system provides a reproducible and isolated database environment with multiple databases, users, and privilege management.

<!-- Language Toggle -->
**🌐 Language / Bahasa:**
- [🇺🇸 English - **Now**](#english-version)
- [🇮🇩 Bahasa Indonesia](language/README-ID.md)
---
### 🔗 Quick Navigation

- [📋 Requirements](#requirements)
- [🚀 Quick Start](#quick-start)
- [📊 Database Specifications](#database-specifications)
- [🔧 Detailed Usage](#detailed-usage)
- [🧹 Cleanup](#cleanup)

---

## 📋 Requirements

Before starting, ensure your system has:

- Docker Engine (version 20.10 or newer)
- Docker Compose (version 2.0 or newer)
- Git (for cloning repository)
- Terminal/Command Line access

#### Prerequisites Verification

```bash
# Check Docker version
docker --version

# Check Docker Compose version
docker compose version

# Check Docker service status
sudo systemctl status docker
```

## 🏗️ Project Structure

```
homework-16/
├── docker-compose.yml      # Docker Compose configuration
├── init/
│   └── init-db.sh          # Database initialization script
├── cleanup.sh              # Cleanup script
├── verify.sh               # Verification script
└── README.md               # This documentation
 
```

## 🚀 Quick Start

#### 1. Clone and Enter Project Directory

```bash
git clone https://github.com/dafafrancis/digitalskola-homework-16.git

cd digitalskola-homework-16
```

#### 2. Grant Execute Permission to Scripts

```bash
chmod +x init/init-db.sh
chmod +x cleanup.sh
chmod +x verify.sh
```

#### 3. Run MySQL Container

```bash
docker compose up -d
```

**Note**: MySQL will run on port 3307 (not default 3306) to avoid conflicts with MySQL that might already be installed on the system.

This command will:
- Download MySQL 8.0 image (if not already available)
- Create and run MySQL container
- Run initialization script automatically
- Create databases and users according to requirements

#### 4. Verify Installation

```bash
./verify.sh
```

## 📊 Database Specifications

#### Created Databases

| Database Name | Purpose |
|---------------|----------|
| `Databaseservicea` | Database for service A |
| `Databaseserviceb` | Database for service B |
| `databaseservicec` | Database for service C |

#### Users and Privileges

| Username | Password | Privileges | Target Database |
|----------|----------|------------|----------------|
| `andi` | `password_andi` | SELECT, INSERT, UPDATE, DELETE | `Databaseservicea` |
| `dion` | `password_dion` | SELECT (read-only) | `Databaseserviceb` |
| `eka` | `password_eka` | ALL PRIVILEGES | All databases |
| `root` | `root_password_rahasia` | ALL PRIVILEGES | All databases |

## 🔧 Detailed Usage

#### Running Container

```bash
# Run in background
docker compose up -d

# Check container status
docker compose ps
```

#### Database Access

**Port**: MySQL runs on port **3307** (not default 3306)

##### 1. Access as Root

```bash
docker compose exec mysql-db mysql -u root -p'root_password_rahasia'
```

##### 2. Access as User Andi

```bash
docker compose exec mysql-db mysql -u andi -p'password_andi'
```

##### 3. Access as User Dion

```bash
docker compose exec mysql-db mysql -u dion -p'password_dion'
```

##### 4. Access as User Eka

```bash
docker compose exec mysql-db mysql -u eka -p'password_eka'
```

#### Testing Privileges

##### Test User Andi (CRUD on Databaseservicea)
```bash
# View privileges owned by user Andi
SHOW GRANTS FOR 'andi'@'%';
```

##### Test User Dion (Read-only on Databaseserviceb)
```bash
# View privileges owned by user Dion
SHOW GRANTS FOR 'dion'@'%';
```

##### Test User Eka (Full privileges)
```bash
# View privileges owned by user Eka
SHOW GRANTS FOR 'eka'@'%';
```

## 🔍 Monitoring and Troubleshooting

#### View Container Logs

```bash
# View real-time logs
docker compose logs -f mysql-db

# View recent logs
docker compose logs --tail=50 mysql-db
```

#### Check Container Status

```bash
# Status of all services
docker compose ps

# Container details
docker inspect mysql-homework16
```

#### Restart Container

```bash
# Restart service
docker compose restart mysql-db

# Stop and start again
docker compose down
docker compose up -d
```

#### Database Backup

```bash
# Backup single database
docker compose exec mysql-db mysqldump -u root -p'root_password_rahasia' Databaseservicea > backup_servicea.sql

# Backup all databases
docker compose exec mysql-db mysqldump -u root -p'root_password_rahasia' --all-databases > backup_all.sql
```

#### Database Restore

```bash
# Restore from backup
docker compose exec -T mysql-db mysql -u root -p'root_password_rahasia' Databaseservicea < backup_servicea.sql
```

## 🧹 Cleanup

#### Automatic Cleanup

```bash
./cleanup.sh
```

This script will:
- Stop all containers
- Remove volumes (data will be lost)
- Clean unused networks
- Optional: remove MySQL images

#### Manual Cleanup

```bash
# Stop and remove containers
docker compose down

# Stop, remove containers and volumes
docker compose down -v

# Remove images (optional)
docker rmi mysql:8.0

# System cleanup
docker system prune -f
```

#### Change Password (Production)

```bash
# Edit docker-compose.yml
MYSQL_ROOT_PASSWORD: your_secure_password

# Update user passwords
docker compose exec mysql-db mysql -u root -p
ALTER USER 'andi'@'%' IDENTIFIED BY 'new_secure_password';
FLUSH PRIVILEGES;
```

### 📝 Requirements Verification

| Requirement ID | Description | Status |
|----------------|-------------|--------|
| F-01 | MySQL instance running | ✅ |
| F-02 | Three databases created | ✅ |
| F-03 | Three users created | ✅ |
| F-04 | Andi CRUD access to Databaseservicea | ✅ |
| F-05 | Dion read-only access to Databaseserviceb | ✅ |
| F-06 | Eka full admin privileges | ✅ |

## 📚 References

- [MySQL Official Documentation](https://dev.mysql.com/doc/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [MySQL Docker Image](https://hub.docker.com/_/mysql)

## 👥 Support

If you encounter issues:

1. Check container logs: `docker compose logs mysql-db`
2. Run verification script: `./verify.sh`
3. Restart container: `docker compose restart mysql-db`
4. Cleanup and start fresh: `./cleanup.sh && docker compose up -d`

---

**Created for**: Digital Skola DevOps Homework 16  
**Date**: June 24, 2025  
**Version**: 1.0

---

