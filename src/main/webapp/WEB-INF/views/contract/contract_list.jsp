<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contracts | HRSync</title>
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
                <h1 class="page-title">Contracts</h1>
                <div class="list-search">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="11" cy="11" r="8"></circle>
                        <path d="m21 21-4.35-4.35"></path>
                    </svg>
                    <form action="${pageContext.request.contextPath}/contracts" method="GET" style="display: flex; flex: 1; gap: 0.5rem;">
                        <input type="text" name="search" placeholder="Search code or employee..." value="${search}">
                    </form>
                </div>
            </div>
            <div class="list-header-right">
                <c:if test="${canCreateContract}">
                    <a href="${pageContext.request.contextPath}/contracts/add" class="btn-primary">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        Add Contract
                    </a>
                </c:if>
            </div>
        </div>

        <div class="list-content">
            <div style="margin-bottom: 1.5rem; display: flex; gap: 1rem; align-items: center; flex-wrap: wrap;">
                <form action="${pageContext.request.contextPath}/contracts" method="GET" style="display: flex; gap: 0.5rem; align-items: center; flex-wrap: wrap;">
                    <select name="contractType" class="filter-select">
                        <option value="all" ${empty contractType ? 'selected' : ''}>All Types</option>
                        <option value="FIXED_TERM" ${contractType == 'FIXED_TERM' ? 'selected' : ''}>Fixed Term</option>
                        <option value="INDEFINITE_TERM" ${contractType == 'INDEFINITE_TERM' ? 'selected' : ''}>Indefinite Term</option>
                        <option value="PROBATION" ${contractType == 'PROBATION' ? 'selected' : ''}>Probation</option>
                        <option value="PART_TIME" ${contractType == 'PART_TIME' ? 'selected' : ''}>Part Time</option>
                    </select>
                    <select name="status" class="filter-select">
                        <option value="all" ${empty status ? 'selected' : ''}>All Status</option>
                        <option value="ACTIVE" ${status == 'ACTIVE' ? 'selected' : ''}>Active</option>
                        <option value="EXPIRED" ${status == 'EXPIRED' ? 'selected' : ''}>Expired</option>
                        <option value="TERMINATED" ${status == 'TERMINATED' ? 'selected' : ''}>Terminated</option>
                    </select>
                    <button type="submit" class="btn-secondary btn-sm">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="11" cy="11" r="8"></circle>
                            <path d="m21 21-4.35-4.35"></path>
                        </svg>
                        Search
                    </button>
                    <a href="${pageContext.request.contextPath}/contracts" class="btn-secondary btn-sm">Clear Filters</a>
                </form>
            </div>

            <table class="data-table">
                <thead>
                <tr>
                    <th>Code</th>
                    <th>Employee</th>
                    <th>Type</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${contracts}" var="contract">
                    <tr>
                        <td><strong>${contract.contractCode}</strong></td>
                        <td>
                            ${contract.employeeName}
                            <c:if test="${not empty contract.employeeCode}">
                                (${contract.employeeCode})
                            </c:if>
                        </td>
                        <td>${contract.contractType}</td>
                        <td>${contract.startDate}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty contract.endDate}">${contract.endDate}</c:when>
                                <c:otherwise>–</c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${contract.status == 'ACTIVE'}">
                                    <span class="badge badge-success">Active</span>
                                </c:when>
                                <c:when test="${contract.status == 'TERMINATED'}">
                                    <span class="badge badge-danger">Terminated</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-warning">${contract.status}</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-buttons">
                                <a href="${pageContext.request.contextPath}/contracts/detail?id=${contract.id}" class="btn-view btn-sm">View</a>
                                <c:if test="${canUpdateContract && contract.status != 'TERMINATED'}">
                                    <a href="${pageContext.request.contextPath}/contracts/update?id=${contract.id}" class="btn-edit btn-sm">Edit</a>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty contracts}">
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 2rem;">
                            <div class="empty-state">
                                <p style="color: #A6B0CF; margin: 0;">No contracts found</p>
                            </div>
                        </td>
                    </tr>
                </c:if>
                </tbody>
            </table>

            <c:if test="${totalPages > 1}">
                <div class="pagination-wrapper">
                    <span class="pagination-info">
                        Page ${currentPage} of ${totalPages}
                    </span>

                    <c:choose>
                        <c:when test="${currentPage <= 1}">
                            <button class="pagination-btn disabled" disabled>← Previous</button>
                        </c:when>
                        <c:otherwise>
                            <c:url var="previousPageUrl" value="/contracts">
                                <c:param name="search" value="${search}" />
                                <c:param name="contractType" value="${contractType}" />
                                <c:param name="status" value="${status}" />
                                <c:param name="page" value="${currentPage - 1}" />
                            </c:url>
                            <a href="${previousPageUrl}" class="pagination-btn">← Previous</a>
                        </c:otherwise>
                    </c:choose>

                    <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                        <c:url var="pageUrl" value="/contracts">
                            <c:param name="search" value="${search}" />
                            <c:param name="contractType" value="${contractType}" />
                            <c:param name="status" value="${status}" />
                            <c:param name="page" value="${pageNumber}" />
                        </c:url>
                        <a href="${pageUrl}" class="pagination-btn ${pageNumber == currentPage ? 'active' : ''}">${pageNumber}</a>
                    </c:forEach>

                    <c:choose>
                        <c:when test="${currentPage >= totalPages}">
                            <button class="pagination-btn disabled" disabled>Next →</button>
                        </c:when>
                        <c:otherwise>
                            <c:url var="nextPageUrl" value="/contracts">
                                <c:param name="search" value="${search}" />
                                <c:param name="contractType" value="${contractType}" />
                                <c:param name="status" value="${status}" />
                                <c:param name="page" value="${currentPage + 1}" />
                            </c:url>
                            <a href="${nextPageUrl}" class="pagination-btn">Next →</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:if>
        </div>
    </main>
</div>

</body>
</html>

    <div class="table-wrapper">
        <table>
            <thead>
            <tr>
                <th>Code</th>
                <th>Employee</th>
                <th>Type</th>
                <th>Start Date</th>
                <th>End Date</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${contracts}" var="contract">
                <tr>
                    <td><strong>${contract.contractCode}</strong></td>
                    <td>
                        ${contract.employeeName}
                        <c:if test="${not empty contract.employeeCode}">
                            (${contract.employeeCode})
                        </c:if>
                    </td>
                    <td>${contract.contractType}</td>
                    <td>${contract.startDate}</td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty contract.endDate}">${contract.endDate}</c:when>
                            <c:otherwise>Open-ended</c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${contract.status == 'ACTIVE'}">
                                <span class="badge badge-active">ACTIVE</span>
                            </c:when>
                            <c:when test="${contract.status == 'TERMINATED'}">
                                <span class="badge badge-inactive">TERMINATED</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-pending">${contract.status}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <div class="actions">
                            <a href="${pageContext.request.contextPath}/contracts/detail?id=${contract.id}">View Detail</a>
                            <c:if test="${canUpdateContract && contract.status != 'TERMINATED'}">
                                <a href="${pageContext.request.contextPath}/contracts/update?id=${contract.id}">Update</a>
                            </c:if>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty contracts}">
                <tr>
                    <td colspan="7" class="empty-state">No contracts found.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <div class="pagination-wrapper">
        <div class="pagination-summary">
            Showing page ${currentPage} of ${totalPages} (${totalRecords} contracts)
        </div>

        <c:if test="${totalPages > 1}">
            <div class="pagination">
                <c:url var="previousPageUrl" value="/contracts">
                    <c:param name="search" value="${search}" />
                    <c:param name="contractType" value="${contractType}" />
                    <c:param name="status" value="${status}" />
                    <c:param name="page" value="${currentPage - 1}" />
                </c:url>
                <a class="page-link ${currentPage == 1 ? 'disabled' : ''}"
                   href="${currentPage == 1 ? '#' : previousPageUrl}">Previous</a>

                <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                    <c:url var="pageUrl" value="/contracts">
                        <c:param name="search" value="${search}" />
                        <c:param name="contractType" value="${contractType}" />
                        <c:param name="status" value="${status}" />
                        <c:param name="page" value="${pageNumber}" />
                    </c:url>
                    <a class="page-link ${pageNumber == currentPage ? 'active' : ''}" href="${pageUrl}">${pageNumber}</a>
                </c:forEach>

                <c:url var="nextPageUrl" value="/contracts">
                    <c:param name="search" value="${search}" />
                    <c:param name="contractType" value="${contractType}" />
                    <c:param name="status" value="${status}" />
                    <c:param name="page" value="${currentPage + 1}" />
                </c:url>
                <a class="page-link ${currentPage == totalPages ? 'disabled' : ''}"
                   href="${currentPage == totalPages ? '#' : nextPageUrl}">Next</a>
            </div>
        </c:if>
    </div>
</div>

</body>
</html>
