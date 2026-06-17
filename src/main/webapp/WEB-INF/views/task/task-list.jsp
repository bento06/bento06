<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Task Management | HRM</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .task-progress { display: flex; align-items: center; gap: 8px; }
        .task-progress-bar { width: 90px; height: 8px; background: #e5e7eb; border-radius: 999px; overflow: hidden; }
        .task-progress-fill { height: 100%; background: #3b82f6; }
        .badge-todo { background: #eef2ff; color: #3730a3; }
        .badge-in_progress { background: #ecfeff; color: #0e7490; }
        .badge-completed { background: #ecfdf5; color: #15803d; }
        .badge-paused { background: #f8fafc; color: #475569; }
        .badge-overdue { background: #fef2f2; color: #dc2626; }
        .actions a { margin-right: 8px; }
    </style>
</head>
<body class="dashboard-body">
<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp"/>
    <div class="dashboard-main">
        <div class="dashboard-header">
            <div class="header-left">
                <h1 class="header-title">Quản lý tác vụ</h1>
            </div>
            <div class="header-right">
                <c:if test="${sessionScope.userPermissions.contains('TASK_CREATE')}">
                    <a href="${pageContext.request.contextPath}/tasks?action=create" class="btn-primary">Tạo tác vụ</a>
                </c:if>
            </div>
        </div>

        <div class="dashboard-content">
            <c:if test="${not empty sessionScope.message}">
                <div class="alert alert-success">${sessionScope.message}</div>
                <c:remove var="message" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="alert alert-error">${sessionScope.error}</div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <div class="search-filter">
                <form action="${pageContext.request.contextPath}/tasks" method="get">
                    <input type="hidden" name="action" value="list">
                    <input type="text" name="keyword" placeholder="Tìm kiếm theo tên tác vụ" value="${keyword}">
                    <select name="status">
                        <option value="" ${empty status ? 'selected' : ''}>Tất cả trạng thái</option>
                        <option value="TODO" ${status == 'TODO' ? 'selected' : ''}>Chờ thực hiện</option>
                        <option value="IN_PROGRESS" ${status == 'IN_PROGRESS' ? 'selected' : ''}>Đang diễn ra</option>
                        <option value="COMPLETED" ${status == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                        <option value="PAUSED" ${status == 'PAUSED' ? 'selected' : ''}>Tạm dừng</option>
                        <option value="OVERDUE" ${status == 'OVERDUE' ? 'selected' : ''}>Quá hạn</option>
                    </select>
                    <button type="submit" class="search-btn">Tìm kiếm</button>
                    <a href="${pageContext.request.contextPath}/tasks" class="btn-reset">Xoá lọc</a>
                </form>
            </div>

            <div class="table-wrapper">
                <table>
                    <thead>
                    <tr>
                        <th>Tên tác vụ</th>
                        <th>Hạn chót</th>
                        <th>Người tạo</th>
                        <th>Người phụ trách</th>
                        <th>Ngày tạo</th>
                        <th>Trạng thái</th>
                        <th>Tiến độ</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${tasks}" var="task">
                        <tr>
                            <td><strong><c:out value="${task.title}"/></strong></td>
                            <td><fmt:formatDate value="${task.deadline}" pattern="dd/MM/yyyy"/></td>
                            <td><c:out value="${task.createdByName}"/></td>
                            <td><c:out value="${task.assignedToName}"/></td>
                            <td><fmt:formatDate value="${task.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td>
                                <span class="badge badge-${fn:toLowerCase(task.displayStatus)}">${task.readableStatus}</span>
                            </td>
                            <td>
                                <div class="task-progress">
                                    <div class="task-progress-bar">
                                        <div class="task-progress-fill" style="width: ${task.progress}%"></div>
                                    </div>
                                    <span>${task.progress}%</span>
                                </div>
                            </td>
                            <td class="actions">
                                <a href="${pageContext.request.contextPath}/tasks?action=detail&id=${task.id}">Xem chi tiết</a>
                                <c:if test="${sessionScope.userPermissions.contains('TASK_CREATE')}">
                                    <a href="${pageContext.request.contextPath}/tasks?action=edit&id=${task.id}">Cập nhật</a>
                                    <a href="${pageContext.request.contextPath}/tasks?action=delete&id=${task.id}"
                                       onclick="return confirm('Xoá tác vụ này?')">Xoá</a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty tasks}">
                        <tr>
                            <td colspan="8" class="empty-state">Không có tác vụ nào.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="${pageContext.request.contextPath}/tasks?page=${currentPage - 1}&keyword=${keyword}&status=${status}">Previous</a>
                </c:if>
                <span>Trang ${currentPage} / ${totalPages} (${totalRecords} tác vụ)</span>
                <c:if test="${currentPage < totalPages}">
                    <a href="${pageContext.request.contextPath}/tasks?page=${currentPage + 1}&keyword=${keyword}&status=${status}">Next</a>
                </c:if>
            </div>
        </div>
    </div>
</div>
</body>
</html>
