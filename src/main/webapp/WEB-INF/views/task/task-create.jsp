<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Tạo tác vụ | HRM</title>
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
                <h1 class="header-title">Tạo tác vụ</h1>
            </div>
        </div>
        <div class="dashboard-content">
            <c:if test="${not empty error}">
                <div class="alert alert-error">${error}</div>
            </c:if>
            <form class="task-form" action="${pageContext.request.contextPath}/tasks?action=insert" method="post">
                <div class="form-row">
                    <label>Tên tác vụ *</label>
                    <input type="text" name="title" required>
                </div>

                <div class="form-row">
                    <label>Nội dung tác vụ / mô tả chi tiết</label>
                    <textarea name="description" rows="7"></textarea>
                </div>

                <div class="form-row">
                    <label>Người phụ trách *</label>
                    <select name="assignedTo" required>
                        <option value="">-- Chọn người phụ trách --</option>
                        <c:forEach items="${users}" var="user">
                            <option value="${user.id}">${user.fullName} - ${not empty user.positionName ? user.positionName : user.roleName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-row">
                    <label>Người tham gia</label>
                    <select name="participantIds" multiple>
                        <c:forEach items="${users}" var="user">
                            <option value="${user.id}">${user.fullName} - ${not empty user.positionName ? user.positionName : user.roleName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-row">
                    <label>Người quan sát</label>
                    <select name="observerIds" multiple>
                        <c:forEach items="${users}" var="user">
                            <option value="${user.id}">${user.fullName} - ${not empty user.positionName ? user.positionName : user.roleName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-row">
                    <label>Hạn chót *</label>
                    <input type="date" name="deadline" required>
                </div>

                <label>
                    <input type="checkbox" name="allowParticipantsCompleteChecklist" value="true">
                    Cho phép người tham gia bấm hoàn thành checklist
                </label>

                <div class="form-row">
                    <label>Danh sách checklist</label>
                    <div id="checklistContainer">
                        <div class="checklist-row">
                            <input type="text" name="checklistContent" placeholder="Nội dung công việc con">
                            <select name="checklistAssignedTo">
                                <option value="">Không gán riêng</option>
                                <c:forEach items="${users}" var="user">
                                    <option value="${user.id}">${user.fullName}</option>
                                </c:forEach>
                            </select>
                            <button type="button" class="btn-reset" onclick="removeChecklistRow(this)">Xoá</button>
                        </div>
                    </div>
                    <button type="button" class="btn-secondary" onclick="addChecklistRow()">+ Thêm checklist</button>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-primary">Lưu</button>
                    <a href="${pageContext.request.contextPath}/tasks" class="btn-cancel">Huỷ</a>
                </div>
            </form>
        </div>
    </div>
</div>
<script>
    function addChecklistRow() {
        const firstRow = document.querySelector('.checklist-row');
        const clone = firstRow.cloneNode(true);
        clone.querySelector('input').value = '';
        clone.querySelector('select').value = '';
        document.getElementById('checklistContainer').appendChild(clone);
    }
    function removeChecklistRow(button) {
        const rows = document.querySelectorAll('.checklist-row');
        if (rows.length > 1) {
            button.closest('.checklist-row').remove();
        } else {
            button.closest('.checklist-row').querySelector('input').value = '';
            button.closest('.checklist-row').querySelector('select').value = '';
        }
    }
</script>
</body>
</html>
