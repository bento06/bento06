<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Users | HRSync</title>
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
    <main class="page-wrapper">
        <!-- Page Header -->
        <div class="list-header">
            <div class="list-header-left">
                <h1 class="page-title">Users</h1>
                <div class="list-search">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"></circle>
                        <path d="m21 21-4.35-4.35"></path>
                    </svg>
                    <form action="${pageContext.request.contextPath}/user_list" method="GET" style="display: flex; flex: 1; gap: 0.5rem;">
                        <input type="text" name="keyword" placeholder="Search by name..." value="${keyword}">
                    </form>
                </div>
            </div>
            <div class="list-header-right">
                <a href="${pageContext.request.contextPath}/admin/users/add" class="btn-primary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="12" y1="5" x2="12" y2="19"></line>
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                    </svg>
                    Add New User
                </a>
            </div>
        </div>

        <!-- Filters -->
        <div class="list-content">
            <div style="margin-bottom: 1.5rem; display: flex; gap: 1rem; align-items: center; flex-wrap: wrap;">
                <form action="${pageContext.request.contextPath}/user_list" method="GET" style="display: flex; gap: 0.5rem; align-items: center; flex-wrap: wrap;">
                    <select name="status" class="filter-select">
                        <option value="all" ${status == 'all' ? 'selected' : ''}>All Status</option>
                        <option value="active" ${status == 'active' ? 'selected' : ''}>Active</option>
                        <option value="inactive" ${status == 'inactive' ? 'selected' : ''}>Inactive</option>
                    </select>
                    <select name="sort" class="filter-select" onchange="this.form.submit()">
                        <option value="name_asc" ${sort == 'name_asc' ? 'selected' : ''}>Name (A-Z)</option>
                        <option value="name_desc" ${sort == 'name_desc' ? 'selected' : ''}>Name (Z-A)</option>
                    </select>
                    <button type="submit" class="btn-secondary btn-sm">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="11" cy="11" r="8"></circle>
                            <path d="m21 21-4.35-4.35"></path>
                        </svg>
                        Search
                    </button>
                    <a href="${pageContext.request.contextPath}/user_list" class="btn-secondary btn-sm">Clear Filters</a>
                </form>
            </div>

            <!-- Users Table -->
            <table class="data-table">
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Department</th>
                    <th>Position</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${userList}" var="user" varStatus="s">
                    <tr>
                        <td><strong>${user.fullName}</strong></td>
                        <td>${not empty user.departmentName ? user.departmentName : '–'}</td>
                        <td>${not empty user.positionName ? user.positionName : '–'}</td>
                        <td>
                            <c:choose>
                                <c:when test="${user.active}">
                                    <span class="badge badge-success">Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">Inactive</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="user_detail?id=${user.id}" class="btn-view btn-sm">View</a>
                                <a href="${pageContext.request.contextPath}/users/update?id=${user.id}" class="btn-edit btn-sm">Edit</a>
                                <form action="${pageContext.request.contextPath}/users/toggle-status" method="GET" style="display: inline;">
                                    <input type="hidden" name="id" value="${user.id}">
                                    <input type="hidden" name="action" value="${user.active ? 'Deactivate' : 'Activate'}">
                                    <button type="submit" class="btn-delete btn-sm" onclick="return confirm('${user.active ? 'Deactivate' : 'Activate'} this user?')">
                                        ${user.active ? 'Deactivate' : 'Activate'}
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty userList}">
                    <tr>
                        <td colspan="5" style="text-align: center; padding: 2rem;">
                            <div class="empty-state">
                                <p style="color: #A6B0CF; margin: 0;">No users found</p>
                            </div>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>

            <!-- Pagination -->
            <div class="pagination-wrapper">
                <span class="pagination-info">
                    <c:choose>
                        <c:when test="${totalPages == 0}">Page 1 of 1</c:when>
                        <c:otherwise>Page ${currentPage} of ${totalPages}</c:otherwise>
                    </c:choose>
                </span>

                <c:if test="${totalPages > 1}">
                    <c:choose>
                        <c:when test="${currentPage <= 1}">
                            <button class="pagination-btn disabled" disabled>← Previous</button>
                        </c:when>
                        <c:otherwise>
                            <c:url var="previousPageUrl" value="/user_list">
                                <c:param name="keyword" value="${keyword}"/>
                                <c:param name="status" value="${status}"/>
                                <c:param name="sort" value="${sort}"/>
                                <c:param name="page" value="${currentPage - 1}"/>
                            </c:url>
                            <a href="${previousPageUrl}" class="pagination-btn">← Previous</a>
                        </c:otherwise>
                    </c:choose>

                    <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                        <c:url var="pageUrl" value="/user_list">
                            <c:param name="keyword" value="${keyword}"/>
                            <c:param name="status" value="${status}"/>
                            <c:param name="sort" value="${sort}"/>
                            <c:param name="page" value="${pageNumber}"/>
                        </c:url>
                        <a href="${pageUrl}" class="pagination-btn ${currentPage == pageNumber ? 'active' : ''}">${pageNumber}</a>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${currentPage >= totalPages}">
                            <button class="pagination-btn disabled" disabled>Next →</button>
                        </c:when>
                        <c:otherwise>
                            <c:url var="nextPageUrl" value="/user_list">
                                <c:param name="keyword" value="${keyword}"/>
                                <c:param name="status" value="${status}"/>
                                <c:param name="sort" value="${sort}"/>
                                <c:param name="page" value="${currentPage + 1}"/>
                            </c:url>
                            <a href="${nextPageUrl}" class="pagination-btn">Next →</a>
                        </c:otherwise>
                    </c:choose>
                </c:if>
            </div>
        </div>
    </main>
</div>

</body>
</html>
