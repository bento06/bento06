<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Departments | HRSync</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="dashboard-body">

<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
    
    <main class="page-wrapper">
        <div class="list-header">
            <div class="list-header-left">
                <h1 class="page-title">Departments</h1>
                <div class="list-search">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"></circle>
                        <path d="m21 21-4.35-4.35"></path>
                    </svg>
                    <form action="${pageContext.request.contextPath}/admin/departments" method="GET" style="display: flex; flex: 1; gap: 0.5rem;">
                        <input type="text" name="search" placeholder="Search by name..." value="${not empty search ? search : ''}">
                    </form>
                </div>
            </div>
            <div class="list-header-right">
                <a href="${pageContext.request.contextPath}/admin/departments/add" class="btn-primary">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <line x1="12" y1="5" x2="12" y2="19"></line>
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                    </svg>
                    Add New Department
                </a>
            </div>
        </div>

        <div class="list-content">
            <c:if test="${not empty param.success}">
                <div class="form-success">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                    <span>${param.success}</span>
                </div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="form-error">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                    <span>${param.error}</span>
                </div>
            </c:if>

            <div style="margin-bottom: 1.5rem; display: flex; gap: 1rem; align-items: center; flex-wrap: wrap;">
                <form action="${pageContext.request.contextPath}/admin/departments" method="GET" style="display: flex; gap: 0.5rem; align-items: center; flex-wrap: wrap;">
                    <select name="status" class="filter-select">
                        <option value="all" ${status == 'all' || empty status ? 'selected' : ''}>All Status</option>
                        <option value="true" ${status == 'true' ? 'selected' : ''}>Active</option>
                        <option value="false" ${status == 'false' ? 'selected' : ''}>Inactive</option>
                    </select>
                    <select name="sort" class="filter-select" onchange="this.form.submit()">
                        <option value="name_asc" ${sort == 'name_asc' ? 'selected' : ''}>Name (A-Z)</option>
                        <option value="name_desc" ${sort == 'name_desc' ? 'selected' : ''}>Name (Z-A)</option>
                        <option value="members_desc" ${sort == 'members_desc' ? 'selected' : ''}>Most Members</option>
                        <option value="members_asc" ${sort == 'members_asc' ? 'selected' : ''}>Least Members</option>
                    </select>
                    <button type="submit" class="btn-secondary btn-sm">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="11" cy="11" r="8"></circle>
                            <path d="m21 21-4.35-4.35"></path>
                        </svg>
                        Search
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/departments" class="btn-secondary btn-sm">Clear Filters</a>
                </form>
            </div>

            <table class="data-table">
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Manager</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="dept" items="${departmentList}" varStatus="s">
                    <tr>
                        <td><strong>${dept.name}</strong></td>
                        <td>${dept.description}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty dept.managerName}">
                                    ${dept.managerName}
                                </c:when>
                                <c:otherwise>
                                    –
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${dept.status}">
                                    <span class="badge badge-success">Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">Inactive</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="dept_detail?id=${dept.id}" class="btn-view btn-sm">View</a>
                                <a href="${pageContext.request.contextPath}/admin/departments/update?id=${dept.id}" class="btn-edit btn-sm">Edit</a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty departmentList}">
                    <tr>
                        <td colspan="5" style="text-align: center; padding: 2rem;">
                            <div class="empty-state">
                                <p style="color: #A6B0CF; margin: 0;">No departments found</p>
                            </div>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>

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
                            <c:url var="previousPageUrl" value="/admin/departments">
                                <c:param name="search" value="${search}"/>
                                <c:param name="status" value="${status}"/>
                                <c:param name="sort" value="${sort}"/>
                                <c:param name="page" value="${currentPage - 1}"/>
                            </c:url>
                            <a href="${previousPageUrl}" class="pagination-btn">← Previous</a>
                        </c:otherwise>
                    </c:choose>

                    <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                        <c:url var="pageUrl" value="/admin/departments">
                            <c:param name="search" value="${search}"/>
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
                            <c:url var="nextPageUrl" value="/admin/departments">
                                <c:param name="search" value="${search}"/>
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
                    <td>
                        <c:choose>
                            <c:when test="${dept.active}">
                                <span class="badge badge-active">Active</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-inactive">Inactive</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div class="actions">
                            <a href="${pageContext.request.contextPath}/admin/departments/detail?id=${dept.id}">View Detail</a>
                            <a href="${pageContext.request.contextPath}/admin/departments/update?id=${dept.id}">Update</a>
                            <form action="${pageContext.request.contextPath}/admin/departments/toggle-status" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="${dept.id}">
                                <button type="submit"
                                        class="btn ${dept.active ? 'btn-danger' : 'btn-warning'}"
                                        onclick="return confirm('Are you sure?')">
                                    <c:choose>
                                        <c:when test="${dept.active}">Deactivate</c:when>
                                        <c:otherwise>Activate</c:otherwise>
                                    </c:choose>
                                </button>
                            </form>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty departmentList}">
                <tr>
                    <td colspan="6" class="empty-state">No departments found.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <c:if test="${totalPages > 1}">
        <div class="pagination">
            <c:url var="firstPageUrl" value="/admin/departments">
                <c:param name="page" value="1" />
                <c:if test="${not empty search}"><c:param name="search" value="${search}" /></c:if>
                <c:if test="${not empty status}"><c:param name="status" value="${status}" /></c:if>
                <c:if test="${not empty sort}"><c:param name="sort" value="${sort}" /></c:if>
            </c:url>
            <a href="${firstPageUrl}" class="${currentPage == 1 ? 'disabled' : ''}">First</a>

            <c:url var="prevPageUrl" value="/admin/departments">
                <c:param name="page" value="${currentPage - 1}" />
                <c:if test="${not empty search}"><c:param name="search" value="${search}" /></c:if>
                <c:if test="${not empty status}"><c:param name="status" value="${status}" /></c:if>
                <c:if test="${not empty sort}"><c:param name="sort" value="${sort}" /></c:if>
            </c:url>
            <a href="${prevPageUrl}" class="${currentPage <= 1 ? 'disabled' : ''}">Previous</a>

            <span>Page <span class="current">${currentPage}</span> / ${totalPages}</span>

            <c:url var="nextPageUrl" value="/admin/departments">
                <c:param name="page" value="${currentPage + 1}" />
                <c:if test="${not empty search}"><c:param name="search" value="${search}" /></c:if>
                <c:if test="${not empty status}"><c:param name="status" value="${status}" /></c:if>
                <c:if test="${not empty sort}"><c:param name="sort" value="${sort}" /></c:if>
            </c:url>
            <a href="${nextPageUrl}" class="${currentPage >= totalPages ? 'disabled' : ''}">Next</a>

            <c:url var="lastPageUrl" value="/admin/departments">
                <c:param name="page" value="${totalPages}" />
                <c:if test="${not empty search}"><c:param name="search" value="${search}" /></c:if>
                <c:if test="${not empty status}"><c:param name="status" value="${status}" /></c:if>
                <c:if test="${not empty sort}"><c:param name="sort" value="${sort}" /></c:if>
            </c:url>
            <a href="${lastPageUrl}" class="${currentPage == totalPages ? 'disabled' : ''}">Last</a>
        </div>
    </c:if>
</div>

</body>
</html>
