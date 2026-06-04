<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New User | HRSync</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="dashboard-body">

<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
    
    <main class="page-wrapper">
        <div class="form-page">
            <div class="form-header">
                <h1>Add New User</h1>
                <p>Create a new user account with role and permissions</p>
            </div>

            <div class="form-container">
                <c:if test="${not empty error}">
                    <div class="form-error">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="12" cy="12" r="10"></circle>
                            <line x1="12" y1="8" x2="12" y2="12"></line>
                            <line x1="12" y1="16" x2="12.01" y2="16"></line>
                        </svg>
                        <span>${error}</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/users/add" method="post">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="fullName">Full Name *</label>
                            <input type="text" id="fullName" name="fullName" placeholder="John Doe" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email Address *</label>
                            <input type="email" id="email" name="email" placeholder="john@example.com" required>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="phone">Phone Number</label>
                            <input type="text" id="phone" name="phone" placeholder="+1 (555) 000-0000">
                        </div>
                        <div class="form-group">
                            <label for="gender">Gender</label>
                            <select id="gender" name="gender">
                                <option value="">Select gender</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="dateOfBirth">Date of Birth</label>
                            <input type="date" id="dateOfBirth" name="dateOfBirth">
                        </div>
                        <div class="form-group">
                            <label for="password">Password *</label>
                            <input type="password" id="password" name="password" placeholder="Enter secure password" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="address">Address</label>
                        <input type="text" id="address" name="address" placeholder="123 Main Street, City, State">
                    </div>

                    <div class="form-group">
                        <label for="avatarUrl">Avatar URL</label>
                        <input type="text" id="avatarUrl" name="avatarUrl" placeholder="https://example.com/avatar.jpg">
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="roleId">Role *</label>
                            <select id="roleId" name="roleId" required>
                                <option value="" disabled selected>Select a role</option>
                                <c:forEach items="${roles}" var="role">
                                    <option value="${role.id}">${role.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Active Status</label>
                            <div style="padding: 0.9rem; background: #1C2740; border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 8px; display: flex; gap: 2rem;">
                                <label style="display: flex; align-items: center; gap: 0.5rem; color: #FFFFFF; margin: 0; cursor: pointer; font-weight: 400; text-transform: none; letter-spacing: normal;">
                                    <input type="radio" name="active" value="true" checked style="cursor: pointer; accent-color: #8EC5FF;">
                                    <span>Active</span>
                                </label>
                                <label style="display: flex; align-items: center; gap: 0.5rem; color: #FFFFFF; margin: 0; cursor: pointer; font-weight: 400; text-transform: none; letter-spacing: normal;">
                                    <input type="radio" name="active" value="false" style="cursor: pointer; accent-color: #8EC5FF;">
                                    <span>Inactive</span>
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-submit">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="20 6 9 17 4 12"></polyline>
                            </svg>
                            Create User
                        </button>
                        <a href="${pageContext.request.contextPath}/user_list" class="btn-cancel">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

</body>
</html>
