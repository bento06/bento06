package controller.task;

import dao.TaskChecklistItemDAO;
import dao.TaskDAO;
import dao.TaskObserverDAO;
import dao.TaskParticipantDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.TaskChecklistItem;
import model.TaskObserver;
import model.TaskParticipant;

import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/tasks")
public class TaskServlet extends HttpServlet {
    private static final int PAGE_SIZE = 10;

    private final TaskDAO taskDAO = new TaskDAO();
    private final TaskParticipantDAO participantDAO = new TaskParticipantDAO();
    private final TaskObserverDAO observerDAO = new TaskObserverDAO();
    private final TaskChecklistItemDAO checklistItemDAO = new TaskChecklistItemDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = getAction(request);

        try {
            switch (action) {
                case "create" -> showCreateForm(request, response);
                case "detail" -> showDetail(request, response);
                case "edit" -> showEditForm(request, response);
                case "delete" -> deleteTask(request, response);
                case "deleteChecklist" -> deleteChecklist(request, response);
                default -> listTasks(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = getAction(request);

        try {
            switch (action) {
                case "insert" -> insertTask(request, response);
                case "update" -> updateTask(request, response);
                case "toggleChecklist" -> toggleChecklist(request, response);
                case "addChecklist" -> addChecklist(request, response);
                case "updateStatus" -> updateStatus(request, response);
                default -> listTasks(request, response);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void listTasks(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");
        int page = parseInt(request.getParameter("page"), 1);
        int totalRecords = taskDAO.countTasks(keyword, status);
        int totalPages = Math.max(1, (int) Math.ceil((double) totalRecords / PAGE_SIZE));
        if (page > totalPages) {
            page = totalPages;
        }

        request.setAttribute("tasks", taskDAO.getTasks(keyword, status, page, PAGE_SIZE));
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.getRequestDispatcher("/WEB-INF/views/task/task-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!hasTaskCreatePermission(request)) {
            forwardForbidden(request, response, "TASK_CREATE");
            return;
        }
        request.setAttribute("users", userDAO.getActiveUsersForTaskSelection());
        request.getRequestDispatcher("/WEB-INF/views/task/task-create.jsp").forward(request, response);
    }

    private void insertTask(HttpServletRequest request, HttpServletResponse response) throws Exception {
        if (!hasTaskCreatePermission(request)) {
            forwardForbidden(request, response, "TASK_CREATE");
            return;
        }

        Task task = buildTaskFromRequest(request);
        task.setCreatedBy(currentUserId(request));
        task.setStatus("TODO");
        task.setProgress(0);

        List<String> checklistContents = cleanTextValues(request.getParameterValues("checklistContent"));
        long taskId = taskDAO.insertTask(task);
        participantDAO.insertParticipants(taskId, parseLongValues(request.getParameterValues("participantIds")));
        observerDAO.insertObservers(taskId, parseLongValues(request.getParameterValues("observerIds")));
        insertChecklistItems(taskId, checklistContents, request.getParameterValues("checklistAssignedTo"));
        taskDAO.refreshProgressAndAutoComplete(taskId);

        request.getSession().setAttribute("message", "Tạo tác vụ thành công.");
        response.sendRedirect(request.getContextPath() + "/tasks?action=detail&id=" + taskId);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long id = parseLong(request.getParameter("id"), 0);
        Task task = taskDAO.getTaskById(id);
        if (task == null) {
            response.sendRedirect(request.getContextPath() + "/tasks?error=not_found");
            return;
        }

        long currentUserId = currentUserId(request);
        request.setAttribute("task", task);
        request.setAttribute("canToggleChecklist", canToggleChecklist(task, currentUserId));
        request.setAttribute("canManageTask", canManageTask(request, task));
        request.setAttribute("users", userDAO.getActiveUsersForTaskSelection());
        request.getRequestDispatcher("/WEB-INF/views/task/task-detail.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long id = parseLong(request.getParameter("id"), 0);
        Task task = taskDAO.getTaskById(id);
        if (task == null) {
            response.sendRedirect(request.getContextPath() + "/tasks?error=not_found");
            return;
        }
        if (!canManageTask(request, task)) {
            forwardForbidden(request, response, "TASK_CREATE");
            return;
        }

        request.setAttribute("task", task);
        request.setAttribute("users", userDAO.getActiveUsersForTaskSelection());
        request.setAttribute("participantIds", participantIdSet(task));
        request.setAttribute("observerIds", observerIdSet(task));
        request.getRequestDispatcher("/WEB-INF/views/task/task-edit.jsp").forward(request, response);
    }

    private void updateTask(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long taskId = parseLong(request.getParameter("id"), 0);
        Task existingTask = taskDAO.getTaskById(taskId);
        if (existingTask == null) {
            response.sendRedirect(request.getContextPath() + "/tasks?error=not_found");
            return;
        }
        if (!canManageTask(request, existingTask)) {
            forwardForbidden(request, response, "TASK_CREATE");
            return;
        }

        Task task = buildTaskFromRequest(request);
        task.setId(taskId);
        task.setProgress("COMPLETED".equals(task.getStatus()) ? 100 : taskDAO.calculateProgress(taskId));
        taskDAO.updateTask(task);
        taskDAO.replaceTaskRelations(
                task,
                parseLongValues(request.getParameterValues("participantIds")),
                parseLongValues(request.getParameterValues("observerIds"))
        );

        updateChecklistItems(request, taskId);
        if ("COMPLETED".equals(task.getStatus())) {
            taskDAO.updateTaskProgress(taskId, 100);
        } else {
            taskDAO.refreshProgressAndAutoComplete(taskId);
        }
        request.getSession().setAttribute("message", "Cập nhật tác vụ thành công.");
        response.sendRedirect(request.getContextPath() + "/tasks?action=detail&id=" + taskId);
    }

    private void deleteTask(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long id = parseLong(request.getParameter("id"), 0);
        Task task = taskDAO.getTaskById(id);
        if (task == null) {
            response.sendRedirect(request.getContextPath() + "/tasks?error=not_found");
            return;
        }
        if (!canManageTask(request, task)) {
            forwardForbidden(request, response, "TASK_CREATE");
            return;
        }
        taskDAO.deleteTask(id);
        request.getSession().setAttribute("message", "Xoá tác vụ thành công.");
        response.sendRedirect(request.getContextPath() + "/tasks");
    }

    private void toggleChecklist(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long itemId = parseLong(request.getParameter("itemId"), 0);
        TaskChecklistItem item = checklistItemDAO.getChecklistItemById(itemId);
        if (item == null) {
            response.sendRedirect(request.getContextPath() + "/tasks?error=not_found");
            return;
        }

        Task task = taskDAO.getTaskById(item.getTaskId());
        long currentUserId = currentUserId(request);
        if (!canToggleChecklist(task, currentUserId)) {
            request.getSession().setAttribute("error", "Bạn không có quyền hoàn thành checklist này.");
            response.sendRedirect(request.getContextPath() + "/tasks?action=detail&id=" + item.getTaskId());
            return;
        }

        checklistItemDAO.toggleChecklistItem(itemId, "true".equals(request.getParameter("completed")));
        taskDAO.refreshProgressAndAutoComplete(item.getTaskId());
        response.sendRedirect(request.getContextPath() + "/tasks?action=detail&id=" + item.getTaskId());
    }

    private void addChecklist(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long taskId = parseLong(request.getParameter("taskId"), 0);
        Task task = taskDAO.getTaskById(taskId);
        if (task == null) {
            response.sendRedirect(request.getContextPath() + "/tasks?error=not_found");
            return;
        }
        if (!canManageTask(request, task)) {
            forwardForbidden(request, response, "TASK_CREATE");
            return;
        }

        String content = trim(request.getParameter("content"));
        if (content != null) {
            TaskChecklistItem item = new TaskChecklistItem();
            item.setTaskId(taskId);
            item.setContent(content);
            item.setAssignedTo(parseNullableLong(request.getParameter("assignedTo")));
            checklistItemDAO.insertChecklistItem(item);
            taskDAO.refreshProgressAndAutoComplete(taskId);
        }
        response.sendRedirect(request.getContextPath() + "/tasks?action=detail&id=" + taskId);
    }

    private void deleteChecklist(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long itemId = parseLong(request.getParameter("itemId"), 0);
        TaskChecklistItem item = checklistItemDAO.getChecklistItemById(itemId);
        if (item == null) {
            response.sendRedirect(request.getContextPath() + "/tasks?error=not_found");
            return;
        }
        Task task = taskDAO.getTaskById(item.getTaskId());
        if (!canManageTask(request, task)) {
            forwardForbidden(request, response, "TASK_CREATE");
            return;
        }
        checklistItemDAO.deleteChecklistItem(itemId);
        taskDAO.refreshProgressAndAutoComplete(item.getTaskId());
        response.sendRedirect(request.getContextPath() + "/tasks?action=detail&id=" + item.getTaskId());
    }

    private void updateStatus(HttpServletRequest request, HttpServletResponse response) throws Exception {
        long taskId = parseLong(request.getParameter("id"), 0);
        Task task = taskDAO.getTaskById(taskId);
        if (task == null) {
            response.sendRedirect(request.getContextPath() + "/tasks?error=not_found");
            return;
        }
        if (!canManageTask(request, task) && task.getAssignedTo() != currentUserId(request)) {
            forwardForbidden(request, response, "TASK_VIEW");
            return;
        }

        String status = normalizeStatus(request.getParameter("status"));
        taskDAO.updateTaskStatus(taskId, status);
        if ("COMPLETED".equals(status)) {
            taskDAO.updateTaskProgress(taskId, 100);
        } else {
            taskDAO.refreshProgressAndAutoComplete(taskId);
        }
        response.sendRedirect(request.getContextPath() + "/tasks?action=detail&id=" + taskId);
    }

    private Task buildTaskFromRequest(HttpServletRequest request) {
        Task task = new Task();
        task.setTitle(requiredTrim(request.getParameter("title"), "Tên tác vụ"));
        task.setDescription(trim(request.getParameter("description")));
        task.setAssignedTo(parseLong(request.getParameter("assignedTo"), 0));
        task.setDeadline(parseRequiredDate(request.getParameter("deadline")));
        task.setStatus(normalizeStatus(request.getParameter("status")));
        task.setAllowParticipantsCompleteChecklist(request.getParameter("allowParticipantsCompleteChecklist") != null);
        if (task.getAssignedTo() <= 0) {
            throw new IllegalArgumentException("Người phụ trách là bắt buộc.");
        }
        return task;
    }

    private void insertChecklistItems(long taskId, List<String> contents, String[] assignedValues) throws Exception {
        for (int i = 0; i < contents.size(); i++) {
            TaskChecklistItem item = new TaskChecklistItem();
            item.setTaskId(taskId);
            item.setContent(contents.get(i));
            if (assignedValues != null && i < assignedValues.length) {
                item.setAssignedTo(parseNullableLong(assignedValues[i]));
            }
            checklistItemDAO.insertChecklistItem(item);
        }
    }

    private void updateChecklistItems(HttpServletRequest request, long taskId) throws Exception {
        String[] itemIds = request.getParameterValues("checklistId");
        String[] contents = request.getParameterValues("checklistContent");
        String[] assignedToValues = request.getParameterValues("checklistAssignedTo");
        if (contents == null) {
            return;
        }

        for (int i = 0; i < contents.length; i++) {
            String content = trim(contents[i]);
            if (content == null) {
                continue;
            }
            Long assignedTo = assignedToValues != null && i < assignedToValues.length
                    ? parseNullableLong(assignedToValues[i])
                    : null;
            long itemId = itemIds != null && i < itemIds.length ? parseLong(itemIds[i], 0) : 0;

            TaskChecklistItem item = new TaskChecklistItem();
            item.setId(itemId);
            item.setTaskId(taskId);
            item.setContent(content);
            item.setAssignedTo(assignedTo);
            if (itemId > 0) {
                checklistItemDAO.updateChecklistItem(item);
            } else {
                checklistItemDAO.insertChecklistItem(item);
            }
        }
    }

    private boolean canManageTask(HttpServletRequest request, Task task) {
        return hasTaskCreatePermission(request) || task.getCreatedBy() == currentUserId(request);
    }

    private boolean canToggleChecklist(Task task, long currentUserId) {
        if (task == null || currentUserId <= 0) {
            return false;
        }
        if (task.getAssignedTo() == currentUserId) {
            return true;
        }
        boolean participant = participantDAO.existsByTaskIdAndUserId(task.getId(), currentUserId);
        return task.isAllowParticipantsCompleteChecklist() && participant;
    }

    @SuppressWarnings("unchecked")
    private boolean hasTaskCreatePermission(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
        return permissions != null && permissions.contains("TASK_CREATE");
    }

    private long currentUserId(HttpServletRequest request) {
        Object value = request.getSession().getAttribute("userId");
        if (value instanceof Number number) {
            return number.longValue();
        }
        return parseLong(String.valueOf(value), 0);
    }

    private String getAction(HttpServletRequest request) {
        String action = request.getParameter("action");
        return action == null || action.isBlank() ? "list" : action;
    }

    private List<Long> parseLongValues(String[] values) {
        Set<Long> ids = new LinkedHashSet<>();
        if (values == null) {
            return new ArrayList<>();
        }
        for (String value : values) {
            Long id = parseNullableLong(value);
            if (id != null && id > 0) {
                ids.add(id);
            }
        }
        return new ArrayList<>(ids);
    }

    private List<String> cleanTextValues(String[] values) {
        List<String> result = new ArrayList<>();
        if (values == null) {
            return result;
        }
        for (String value : values) {
            String trimmed = trim(value);
            if (trimmed != null) {
                result.add(trimmed);
            }
        }
        return result;
    }

    private Set<Long> participantIdSet(Task task) {
        Set<Long> ids = new LinkedHashSet<>();
        for (TaskParticipant participant : task.getParticipants()) {
            ids.add(participant.getUserId());
        }
        return ids;
    }

    private Set<Long> observerIdSet(Task task) {
        Set<Long> ids = new LinkedHashSet<>();
        for (TaskObserver observer : task.getObservers()) {
            ids.add(observer.getUserId());
        }
        return ids;
    }

    private Date parseRequiredDate(String value) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("Hạn chót là bắt buộc.");
        }
        return Date.valueOf(value);
    }

    private String normalizeStatus(String status) {
        if (status == null || status.isBlank() || "OVERDUE".equals(status)) {
            return "TODO";
        }
        return switch (status) {
            case "TODO", "IN_PROGRESS", "COMPLETED", "PAUSED" -> status;
            default -> "TODO";
        };
    }

    private Long parseNullableLong(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        return parseLong(value, 0);
    }

    private long parseLong(String value, long defaultValue) {
        try {
            return value == null || value.isBlank() ? defaultValue : Long.parseLong(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return value == null || value.isBlank() ? defaultValue : Math.max(1, Integer.parseInt(value));
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String requiredTrim(String value, String fieldName) {
        String trimmed = trim(value);
        if (trimmed == null) {
            throw new IllegalArgumentException(fieldName + " là bắt buộc.");
        }
        return trimmed;
    }

    private String trim(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private void forwardForbidden(HttpServletRequest request, HttpServletResponse response, String permission)
            throws ServletException, IOException {
        response.setStatus(HttpServletResponse.SC_FORBIDDEN);
        request.setAttribute("permissionDenied", permission);
        request.getRequestDispatcher("/WEB-INF/views/common/403.jsp").forward(request, response);
    }
}
