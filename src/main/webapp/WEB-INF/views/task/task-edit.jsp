<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập nhật tác vụ | HRM</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .task-form { display: grid; gap: 18px; max-width: 980px; }
        .form-row { display: grid; gap: 8px; }
        .task-form input, .task-form select, .task-form textarea { width: 100%; padding: 10px 12px; border: 1px solid #d1d5db; border-radius: 6px; }
        .task-form select[multiple] { min-height: 120px; }
        .checklist-row { display: grid; grid-template-columns: 1fr 260px auto; gap: 8px; align-items: center; margin-bottom: 8px; }
        .form-actions { display: flex; gap: 10px; }
    </style>
</head>
<body class="dashboard-body">
<div class="dashboard-wrapper">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp"/>
    <div class="dashboard-main">
        <div class="dashboard-header">
            <div class="header-left">
                <h1 class="header-title">Cập nhật tác vụ</h1>
            </div>
        </div>
        <div class="dashboard-content">
            <fmt:formatDate var="createdAtText" value="${task.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
            <form class="task-form" action="${pageContext.request.contextPath}/tasks?action=update&id=${task.id}" method="post">
                <div class="form-row">
                    <label>Tên tác vụ *</label>
                    <input type="text" name="title" value="${task.title}" required>
                </div>

                <div class="form-row">
                    <label>Mô tả</label>
                    <textarea name="description" rows="7">${task.description}</textarea>
                </div>

                <div class="form-row">
                    <label>Người tạo</label>
                    <input type="text" value="${task.createdByName}" readonly>
                </div>

                <div class="form-row">
                    <label>Ngày tạo</label>
                    <input type="text" value="${createdAtText}" readonly>
                </div>

                <div class="form-row">
                    <label>Người phụ trách *</label>
                    <select name="assignedTo" required>
                        <c:forEach items="${users}" var="user">
                            <option value="${user.id}" ${task.assignedTo == user.id ? 'selected' : ''}>${user.fullName} - ${not empty user.positionName ? user.positionName : user.roleName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-row">
                    <label>Người tham gia</label>
                    <select name="participantIds" multiple>
                        <c:forEach items="${users}" var="user">
                            <c:set var="selectedParticipant" value="false"/>
                            <c:forEach items="${task.participants}" var="participant">
                                <c:if test="${participant.userId == user.id}">
                                    <c:set var="selectedParticipant" value="true"/>
                                </c:if>
                            </c:forEach>
                            <option value="${user.id}" ${selectedParticipant ? 'selected' : ''}>${user.fullName} - ${not empty user.positionName ? user.positionName : user.roleName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-row">
                    <label>Người quan sát</label>
                    <select name="observerIds" multiple>
                        <c:forEach items="${users}" var="user">
                            <c:set var="selectedObserver" value="false"/>
                            <c:forEach items="${task.observers}" var="observer">
                                <c:if test="${observer.userId == user.id}">
                                    <c:set var="selectedObserver" value="true"/>
                                </c:if>
                            </c:forEach>
                            <option value="${user.id}" ${selectedObserver ? 'selected' : ''}>${user.fullName} - ${not empty user.positionName ? user.positionName : user.roleName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-row">
                    <label>Hạn chót *</label>
                    <input type="date" name="deadline" value="${task.deadline}" required>
                </div>

                <div class="form-row">
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value="TODO" ${task.status == 'TODO' ? 'selected' : ''}>Chờ thực hiện</option>
                        <option value="IN_PROGRESS" ${task.status == 'IN_PROGRESS' ? 'selected' : ''}>Đang diễn ra</option>
                        <option value="COMPLETED" ${task.status == 'COMPLETED' ? 'selected' : ''}>Hoàn thành</option>
                        <option value="PAUSED" ${task.status == 'PAUSED' ? 'selected' : ''}>Tạm dừng</option>
                    </select>
                </div>

                <label>
                    <input type="checkbox" name="allowParticipantsCompleteChecklist" value="true" ${task.allowParticipantsCompleteChecklist ? 'checked' : ''}>
                    Cho phép người tham gia bấm hoàn thành checklist
                </label>

                <div class="form-row">
                    <label>Checklist</label>
                    <div id="checklistContainer">
                        <c:forEach items="${task.checklistItems}" var="item">
                            <div class="checklist-row">
                                <input type="hidden" name="checklistId" value="${item.id}">
                                <input type="text" name="checklistContent" value="${item.content}" placeholder="Nội dung công việc con">
                                <select name="checklistAssignedTo">
                                    <option value="">Không gán riêng</option>
                                    <c:forEach items="${users}" var="user">
                                        <option value="${user.id}" ${item.assignedTo == user.id ? 'selected' : ''}>${user.fullName}</option>
                                    </c:forEach>
                                </select>
                                <a class="btn-reset" href="${pageContext.request.contextPath}/tasks?action=deleteChecklist&itemId=${item.id}"
                                   onclick="return confirm('Xoá checklist này?')">Xoá</a>
                            </div>
                        </c:forEach>
                        <c:if test="${empty task.checklistItems}">
                            <div class="checklist-row">
                                <input type="hidden" name="checklistId" value="">
                                <input type="text" name="checklistContent" placeholder="Nội dung công việc con">
                                <select name="checklistAssignedTo">
                                    <option value="">Không gán riêng</option>
                                    <c:forEach items="${users}" var="user">
                                        <option value="${user.id}">${user.fullName}</option>
                                    </c:forEach>
                                </select>
                                <button type="button" class="btn-reset" onclick="removeChecklistRow(this)">Xoá</button>
                            </div>
                        </c:if>
                    </div>
                    <button type="button" class="btn-secondary" onclick="addChecklistRow()">+ Thêm checklist</button>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-primary">Lưu</button>
                    <a href="${pageContext.request.contextPath}/tasks?action=detail&id=${task.id}" class="btn-cancel">Huỷ</a>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
    function addChecklistRow() {
        const container = document.getElementById('checklistContainer');
        const firstRow = document.querySelector('.checklist-row');
        const clone = firstRow.cloneNode(true);
        clone.querySelector('input[name="checklistId"]').value = '';
        clone.querySelector('input[name="checklistContent"]').value = '';
        clone.querySelector('select').value = '';
        const action = clone.querySelector('a, button');
        if (action.tagName.toLowerCase() === 'a') {
            const button = document.createElement('button');
            button.type = 'button';
            button.className = 'btn-reset';
            button.textContent = 'Xoá';
            button.onclick = function() { removeChecklistRow(button); };
            action.replaceWith(button);
        }
        container.appendChild(clone);
    }
    function removeChecklistRow(button) {
        const rows = document.querySelectorAll('.checklist-row');
        if (rows.length > 1) {
            button.closest('.checklist-row').remove();
        } else {
            button.closest('.checklist-row').querySelector('input[name="checklistId"]').value = '';
            button.closest('.checklist-row').querySelector('input[name="checklistContent"]').value = '';
            button.closest('.checklist-row').querySelector('select').value = '';
        }
    }
</script>
</body>
</html>
