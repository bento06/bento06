<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | HRSync</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="dashboard-body">

<div class="dashboard-wrapper">
    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
    
    <!-- Main Content -->
    <main class="dashboard-main">
        <!-- Top Header -->
        <header class="dashboard-header">
            <div class="header-left">
                <h1 class="header-title">Dashboard</h1>
            </div>
            <div class="header-right">
                <div class="search-box">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"></circle>
                        <path d="m21 21-4.35-4.35"></path>
                    </svg>
                    <input type="text" placeholder="Search here...">
                </div>
                <button class="header-icon">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                        <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                    </svg>
                </button>
                <div class="header-profile">
                    <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=48&h=48&fit=crop" alt="User">
                    <div class="profile-info">
                        <p class="profile-name">${currentUser.fullName}</p>
                        <p class="profile-status">Online</p>
                    </div>
                </div>
            </div>
        </header>

        <!-- Dashboard Content -->
        <div class="dashboard-content">
            
            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon stat-icon-1">
                        <svg viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm0-13c-2.76 0-5 2.24-5 5s2.24 5 5 5 5-2.24 5-5-2.24-5-5-5z"/>
                        </svg>
                    </div>
                    <div class="stat-body">
                        <p class="stat-value">120</p>
                        <p class="stat-label">Total Employees</p>
                        <p class="stat-change">/ 120</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon stat-icon-2">
                        <svg viewBox="0 0 24 24" fill="currentColor">
                            <path d="M7 10c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm5-3c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm5 5c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zM7 19c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm5-2c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm5-4c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z"/>
                        </svg>
                    </div>
                    <div class="stat-body">
                        <p class="stat-value">24</p>
                        <p class="stat-label">On Leave</p>
                        <p class="stat-change">/ 120</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon stat-icon-3">
                        <svg viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
                        </svg>
                    </div>
                    <div class="stat-body">
                        <p class="stat-value">20</p>
                        <p class="stat-label">New Joinee</p>
                        <p class="stat-change">/ 120</p>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-icon stat-icon-4">
                        <svg viewBox="0 0 24 24" fill="currentColor">
                            <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                        </svg>
                    </div>
                    <div class="stat-body">
                        <p class="stat-value">85%</p>
                        <p class="stat-label">Happiness Rate</p>
                        <p class="stat-change">/ 100%</p>
                    </div>
                </div>
            </div>

            <!-- Main Grid -->
            <div class="dashboard-grid">
                <!-- Employee Status -->
                <div class="dashboard-card">
                    <div class="card-header">
                        <h3>Employee Status</h3>
                        <select class="filter-select">
                            <option>This Week</option>
                            <option>This Month</option>
                            <option>This Year</option>
                        </select>
                    </div>
                    <div class="card-content">
                        <div class="employee-status">
                            <div class="total-employee">
                                <p class="label">Total Employee</p>
                                <p class="value">120</p>
                            </div>
                            <div class="status-bar">
                                <div class="bar" style="width: 48%; background: #8EC5FF;"></div>
                                <div class="bar" style="width: 10%; background: #FFD6A5;"></div>
                                <div class="bar" style="width: 22%; background: #CDB4FF;"></div>
                                <div class="bar" style="width: 20%; background: #FFB4B4;"></div>
                            </div>
                            <div class="status-legend">
                                <div class="legend-item">
                                    <span class="legend-color" style="background: #8EC5FF;"></span>
                                    <span class="legend-label">Fulltime (48%)</span>
                                    <span class="legend-value">58</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background: #FFD6A5;"></span>
                                    <span class="legend-label">Contract (10%)</span>
                                    <span class="legend-value">12</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background: #CDB4FF;"></span>
                                    <span class="legend-label">Probation (22%)</span>
                                    <span class="legend-value">26</span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-color" style="background: #FFB4B4;"></span>
                                    <span class="legend-label">WFH (20%)</span>
                                    <span class="legend-value">24</span>
                                </div>
                            </div>
                        </div>
                        <div class="top-performer">
                            <p class="label">Top Performer</p>
                            <div class="performer">
                                <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=40&h=40&fit=crop" alt="">
                                <div>
                                    <p class="name">Shirley Baker</p>
                                    <p class="title">iOS Developer</p>
                                </div>
                                <span class="performance">98%</span>
                            </div>
                        </div>
                        <a href="#" class="view-link">View All Employees</a>
                    </div>
                </div>

                <!-- Attendance Overview -->
                <div class="dashboard-card">
                    <div class="card-header">
                        <h3>Attendance Overview</h3>
                        <select class="filter-select">
                            <option>Today</option>
                            <option>This Week</option>
                            <option>This Month</option>
                        </select>
                    </div>
                    <div class="card-content">
                        <div class="attendance-chart">
                            <svg class="donut-chart" viewBox="0 0 120 120">
                                <circle cx="60" cy="60" r="50" fill="none" stroke="#8EC5FF" stroke-width="20" stroke-dasharray="235.62 471.24"/>
                                <circle cx="60" cy="60" r="50" fill="none" stroke="#FFD6A5" stroke-width="20" stroke-dasharray="70.69 471.24" stroke-dashoffset="-235.62"/>
                                <circle cx="60" cy="60" r="50" fill="none" stroke="#CDB4FF" stroke-width="20" stroke-dasharray="47.12 471.24" stroke-dashoffset="-306.31"/>
                                <text x="60" y="60" text-anchor="middle" dy=".3em" class="chart-label">120</text>
                                <text x="60" y="70" text-anchor="middle" dy=".3em" class="chart-sublabel">Total Attendance</text>
                            </svg>
                        </div>
                        <div class="attendance-status">
                            <div class="status-item">
                                <span class="status-dot" style="background: #8EC5FF;"></span>
                                <span class="status-text">Present</span>
                                <span class="status-percent">75%</span>
                            </div>
                            <div class="status-item">
                                <span class="status-dot" style="background: #FFD6A5;"></span>
                                <span class="status-text">Late</span>
                                <span class="status-percent">15%</span>
                            </div>
                            <div class="status-item">
                                <span class="status-dot" style="background: #CDB4FF;"></span>
                                <span class="status-text">Absent</span>
                                <span class="status-percent">10%</span>
                            </div>
                        </div>
                        <a href="#" class="view-link">View Details</a>
                    </div>
                </div>

                <!-- Clock In/Out -->
                <div class="dashboard-card">
                    <div class="card-header">
                        <h3>Clock-In/Out</h3>
                        <select class="filter-select">
                            <option>All Departments</option>
                            <option>IT</option>
                            <option>HR</option>
                        </select>
                    </div>
                    <div class="card-content">
                        <div class="clock-list">
                            <div class="clock-item">
                                <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=40&h=40&fit=crop" alt="">
                                <div class="clock-info">
                                    <p class="name">Shirley Baker</p>
                                    <p class="role">iOS Developer</p>
                                </div>
                                <span class="clock-time">09:15</span>
                            </div>
                            <div class="clock-item">
                                <img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=40&h=40&fit=crop" alt="">
                                <div class="clock-info">
                                    <p class="name">Maryann Tabares</p>
                                    <p class="role">UI/UX Designer</p>
                                </div>
                                <span class="clock-time">09:35</span>
                            </div>
                            <div class="clock-item">
                                <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=40&h=40&fit=crop" alt="">
                                <div class="clock-info">
                                    <p class="name">Mario Hildreth</p>
                                    <p class="role">Project Manager</p>
                                </div>
                                <span class="clock-time">09:30</span>
                            </div>
                        </div>
                        <div class="late-section">
                            <p class="label">Late</p>
                            <div class="late-item">
                                <img src="https://images.unsplash.com/photo-1507842072343-583f20270319?w=40&h=40&fit=crop" alt="">
                                <div class="late-info">
                                    <p class="name">Charles Spencer</p>
                                    <p class="role">Marketing Head</p>
                                </div>
                                <span class="late-badge">30 Min</span>
                                <span class="late-time">08:35</span>
                            </div>
                        </div>
                        <a href="#" class="view-link">View All Attendance</a>
                    </div>
                </div>
            </div>

            <!-- Bottom Row -->
            <div class="dashboard-grid">
                <!-- Jobs Applicants -->
                <div class="dashboard-card">
                    <div class="card-header">
                        <h3>Jobs Applicants</h3>
                        <a href="#" class="view-all-link">View All</a>
                    </div>
                    <div class="card-content">
                        <div class="tabs">
                            <button class="tab-btn active">Openings</button>
                            <button class="tab-btn">Applicants</button>
                        </div>
                        <div class="tab-content">
                            <p class="empty-state">No openings at the moment</p>
                        </div>
                    </div>
                </div>

                <!-- Employees -->
                <div class="dashboard-card">
                    <div class="card-header">
                        <h3>Employees</h3>
                        <a href="#" class="view-all-link">View All</a>
                    </div>
                    <div class="card-content">
                        <div class="employee-list">
                            <div class="employee-item">
                                <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=40&h=40&fit=crop" alt="">
                                <div class="employee-detail">
                                    <p class="name">Melissa Wood</p>
                                    <p class="experience">Exp. 2+ Years</p>
                                </div>
                                <span class="employee-tag">Android Developer</span>
                            </div>
                            <div class="employee-item">
                                <img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=40&h=40&fit=crop" alt="">
                                <div class="employee-detail">
                                    <p class="name">Mary Shaw</p>
                                    <p class="experience">Exp. 3+ Years</p>
                                </div>
                                <span class="employee-tag">Frontend Developer</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Todo -->
                <div class="dashboard-card">
                    <div class="card-header">
                        <h3>Todo</h3>
                        <select class="filter-select">
                            <option>Today</option>
                            <option>This Week</option>
                            <option>This Month</option>
                        </select>
                    </div>
                    <div class="card-content">
                        <div class="todo-list">
                            <div class="todo-item">
                                <input type="checkbox" id="todo1">
                                <label for="todo1">Add Holidays</label>
                            </div>
                            <div class="todo-item">
                                <input type="checkbox" id="todo2">
                                <label for="todo2">Management Call</label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</div>

</body>
</html>
