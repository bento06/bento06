package controller.attendance;

import dao.AttendanceDAO;
import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AttendanceSummary;
import model.User;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@WebServlet("/attendance/summary")
public class AttendanceSummaryServlet extends HttpServlet {
    private static final double STANDARD_WORK_HOURS = 8.0;
    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = session != null ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String userIdParameter = request.getParameter("userId");
        Integer requestedUserId = null;
        if (userIdParameter != null && !userIdParameter.isBlank()) {
            requestedUserId = parsePositiveInteger(userIdParameter);
            if (requestedUserId == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid employee ID");
                return;
            }
        }

        int targetUserId = requestedUserId != null ? requestedUserId : currentUser.getId();
        if (!canViewSummary(session, currentUser.getId(), targetUserId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        User employee = targetUserId == currentUser.getId()
                ? currentUser
                : userDAO.findById(targetUserId);
        if (employee == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Employee not found");
            return;
        }

        LocalDate today = LocalDate.now();
        int selectedYear = parseIntInRange(request.getParameter("year"), today.getYear(), 2000, 2100);
        int selectedMonth = parseIntInRange(request.getParameter("month"), today.getMonthValue(), 1, 12);
        YearMonth selectedPeriod = YearMonth.of(selectedYear, selectedMonth);

        AttendanceSummary summary = attendanceDAO.getSummaryByUser(
                employee.getId(),
                selectedPeriod.atDay(1),
                selectedPeriod.atEndOfMonth()
        );
        summary.setExpectedWorkHours(countWeekdays(selectedPeriod) * STANDARD_WORK_HOURS);

        request.setAttribute("summary", summary);
        request.setAttribute("displayUser", employee);
        request.setAttribute("summaryAction", request.getContextPath() + "/attendance/summary");
        if (requestedUserId != null) {
            request.setAttribute("summaryUserId", employee.getId());
        }
        request.setAttribute("selectedYear", selectedYear);
        request.setAttribute("selectedMonth", selectedMonth);
        request.setAttribute("years", buildYearOptions(today.getYear(), selectedYear));
        request.getRequestDispatcher("/WEB-INF/views/attendance/summary.jsp").forward(request, response);
    }

    private boolean canViewSummary(HttpSession session, int currentUserId, int targetUserId) {
        @SuppressWarnings("unchecked")
        Set<String> permissions = (Set<String>) session.getAttribute("userPermissions");
        if (permissions == null) {
            return false;
        }
        if (targetUserId == currentUserId) {
            return permissions.contains("ATTENDANCE_VIEW_OWN");
        }
        return permissions.contains("ATTENDANCE_VIEW_ALL");
    }

    private int countWeekdays(YearMonth period) {
        int weekdays = 0;
        for (int day = 1; day <= period.lengthOfMonth(); day++) {
            DayOfWeek dayOfWeek = period.atDay(day).getDayOfWeek();
            if (dayOfWeek != DayOfWeek.SATURDAY && dayOfWeek != DayOfWeek.SUNDAY) {
                weekdays++;
            }
        }
        return weekdays;
    }

    private List<Integer> buildYearOptions(int currentYear, int selectedYear) {
        int firstYear = Math.min(currentYear - 5, selectedYear);
        int lastYear = Math.max(currentYear + 1, selectedYear);
        List<Integer> years = new ArrayList<>();
        for (int year = lastYear; year >= firstYear; year--) {
            years.add(year);
        }
        return years;
    }

    private Integer parsePositiveInteger(String value) {
        try {
            int parsed = Integer.parseInt(value);
            return parsed > 0 ? parsed : null;
        } catch (Exception e) {
            return null;
        }
    }

    private int parseIntInRange(String value, int defaultValue, int min, int max) {
        try {
            int parsed = Integer.parseInt(value);
            return parsed >= min && parsed <= max ? parsed : defaultValue;
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
