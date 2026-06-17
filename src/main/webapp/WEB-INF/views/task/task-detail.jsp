<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết tác vụ | HRM</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .detail-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 16px; margin-bottom: 24px; }
        .detail-item { padding: 12px 0; border-bottom: 1px solid #e5e7eb; }
        .detail-label { display: block; color: #6b7280; font-size: 13px; margin-bottom: 4px; }
        .checklist-table td { vertical-align: middle; }
        .progress-line { height: 8px; background: #e5e7eb; border-radius: 999px; overflow: hidden; max-width: 240px; }
        .progress-fill { height: 100%; background: #3b82f6; }
        .badge-todo { background: #eef2ff; color: #3730a3; }
        .badge-in_progress { background: #ecfeff; color: #0e7490; }
        .badge-completed { background: #ecfdf5; color: #15803d; }
        .badge-paused { background: #f8fafc; color: #475569; }
        .badge-overdue { background: #fef2f2; color: #dc2626; }
        .inline-form { display: inline-flex; gap: 8px; align-items: center; }
    </style>
</head>
<body class="dashboard-body">
<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp"/>
    <div class="dashboard-main">
        <div class="dashboard-header">
            <div class="header-left">
                <h1 class="header-title">Chi tiết tác vụ</h1>
            </div>
            <div class="header-right">
                <c:if test="${canManageTask}">
                    <a href="${pageContext.request.contextPath}/tasks?action=edit&id=${task.id}" class="btn-primary">Cập nhật</a>
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

            <h2><c:out value="${task.title}"/></h2>
            <div class="detail-grid">
                <div class="detail-item">
                    <span class="detail-label">Mô tả</span>
                    <span><c:out value="${not empty task.description ? task.description : 'Không có mô tả'}"/></span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Trạng thái</span>
                    <span class="badge badge-${fn:toLowerCase(task.displayStatus)}">${task.readableStatus}</span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Người tạo</span>
                    <span><c:out value="${task.createdByName}"/></span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Người phụ trách</span>
                    <span><c:out value="${task.assignedToName}"/></span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Người tham gia</span>
                    <c:choose>
                        <c:when test="${not empty task.participants}">
                            <c:forEach items="${task.participants}" var="participant" varStatus="s">
                                <c:out value="${participant.userName}"/><c:if test="${!s.last}">, </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>Không có</c:otherwise>
                    </c:choose>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Người quan sát</span>
                    <c:choose>
                        <c:when test="${not empty task.observers}">
                            <c:forEach items="${task.observers}" var="observer" varStatus="s">
                                <c:out value="${observer.userName}"/><c:if test="${!s.last}">, </c:if>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>Không có</c:otherwise>
                    </c:choose>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Hạn chót</span>
                    <span><fmt:formatDate value="${task.deadline}" pattern="dd/MM/yyyy"/></span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Ngày tạo</span>
                    <span><fmt:formatDate value="${task.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Tiến độ</span>
                    <div class="progress-line">
                        <div class="progress-fill" style="width: ${task.progress}%"></div>
                    </div>
                    <strong>${task.progress}%</strong>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Quyền tick checklist</span>
                    <span>${task.allowParticipantsCompleteChecklist ? 'Người phụ trách và người tham gia' : 'Chỉ người phụ trách'}</span>
                </div>
            </div>

            <form class="inline-form" action="${pageContext.request.contextPath}/tasks?action=updateStatus&id=${task.id}" method="post">
                <label>Cập nhật trạng thái</label>
                <select name="status">
                    <option value="TODO" ${task.status == 'TODO' ? 'selected' : ''}>Chờ thực hiện</option>
                    <option value="IN_PROGRESS" ${task.status == 'IN_PROGRESS' ? 'selected' : ''}>Đang diễn ra</option>
                    <option value="COMPLETED" ${task.status == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                    <option value="PAUSED" ${task.status == 'PAUSED' ? 'selected' : ''}>Tạm dừng</option>
                </select>
                <button type="submit" class="btn-secondary">Lưu trạng thái</button>
            </form>

            <h3>Checklist</h3>
            <div class="table-wrapper">
                <table class="checklist-table">
                    <thead>
                    <tr>
                        <th>Hoàn thành</th>
                        <th>Nội dung công việc con</th>
                        <th>Người phụ trách</th>
                        <th>Ngày hoàn thành</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${task.checklistItems}" var="item">
                        <tr>
                            <td>
                                <form action="${pageContext.request.contextPath}/tasks?action=toggleChecklist" method="post">
                                    <input type="hidden" name="itemId" value="${item.id}">
                                    <input type="hidden" name="completed" value="${!item.completed}">
                                    <input type="checkbox" ${item.completed ? 'checked' : ''} ${canToggleChecklist ? '' : 'disabled'}
                                           onchange="this.form.submit()">
                                </form>
                            </td>
                            <td><c:out value="${item.content}"/></td>
                            <td><c:out value="${not empty item.assignedToName ? item.assignedToName : '-'}"/></td>
                            <td><fmt:formatDate value="${item.completedAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td>
                                <c:if test="${canManageTask}">
                                    <a href="${pageContext.request.contextPath}/tasks?action=deleteChecklist&itemId=${item.id}"
                                       onclick="return confirm('Xoá checklist này?')">Xoá</a>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty task.checklistItems}">
                        <tr><td colspan="5" class="empty-state">Chưa có checklist.</td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>

            <c:if test="${canManageTask}">
                <form class="inline-form" action="${pageContext.request.contextPath}/tasks?action=addChecklist" method="post">
                    <input type="hidden" name="taskId" value="${task.id}">
                    <input type="text" name="content" placeholder="Thêm checklist item" required>
                    <select name="assignedTo">
                        <option value="">Không gán riêng</option>
                        <c:forEach items="${users}" var="user">
                            <option value="${user.id}">${user.fullName}</option>
                        </c:forEach>
                    </select>
                    <button type="submit" class="btn-secondary">Thêm checklist</button>
                </form>
            </c:if>

            <p>
                <a href="${pageContext.request.contextPath}/tasks" class="btn-cancel">Quay lại danh sách</a>
            </p>
        </div>
    </div>
</div>
</body>
</html>
