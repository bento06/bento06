<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    User user = (User) request.getAttribute("user");
    String dob = "";
    if (user != null && user.getDateOfBirth() != null) {
        dob = user.getDateOfBirth().toLocalDate().toString();
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | HRM</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<div class="container" style="margin-top: 2rem;">
    <div class="page-header">
        <h2>My Profile</h2>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <c:if test="${empty user}">
        <div class="empty-state">Profile not found.</div>
    </c:if>

    <c:if test="${not empty user}">
        <form action="${pageContext.request.contextPath}/profile" method="post">
            <div class="detail-card">
                <div class="detail-avatar">
                    <c:choose>
                        <c:when test="${not empty user.avatarUrl}">
                            <img src="${user.avatarUrl}" alt="Avatar of ${user.fullName}" style="width: 120px; height: 120px;">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assets/images/default_avatar.jpg" alt="Default Avatar" style="width: 120px; height: 120px;">
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="detail-info">
                    <div class="form-group">
                        <label for="fullName">Full Name</label>
                        <input type="text" id="fullName" value="${user.fullName}" readonly>
                    </div>

                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" value="${user.email}" readonly>
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone</label>
                        <input type="text" id="phone" name="phone" value="${user.phone}" maxlength="20">
                    </div>

                    <div class="form-group">
                        <label for="gender">Gender</label>
                        <select id="gender" name="gender" class="form-select">
                            <option value="">Not updated</option>
                            <option value="Male" ${user.gender == 'Male' ? 'selected' : ''}>Male</option>
                            <option value="Female" ${user.gender == 'Female' ? 'selected' : ''}>Female</option>
                            <option value="Other" ${user.gender == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="dateOfBirth">Date of Birth</label>
                        <input type="date" id="dateOfBirth" name="dateOfBirth" value="<%= dob %>">
                    </div>

                    <div class="form-group">
                        <label for="address">Address</label>
                        <input type="text" id="address" name="address" value="${user.address}">
                    </div>

                    <div class="form-group">
                        <label for="avatarUrl">Avatar URL</label>
                        <input type="text" id="avatarUrl" name="avatarUrl" value="${user.avatarUrl}" maxlength="500">
                    </div>

                    <div class="form-group">
                        <label for="department">Department</label>
                        <input type="text" id="department" value="${empty user.departmentName ? 'No department' : user.departmentName}" readonly>
                    </div>

                    <div class="form-group">
                        <label for="position">Position</label>
                        <input type="text" id="position" value="${empty user.positionName ? 'No position' : user.positionName}" readonly>
                    </div>
                </div>
            </div>

            <div class="form-actions" style="margin-top: 2rem;">
                <button type="submit" class="btn-save">Update Profile</button>
                <a href="${pageContext.request.contextPath}/change-password" class="btn-cancel">Change Password</a>
            </div>
        </form>
    </c:if>
</div>

</body>
</html>
