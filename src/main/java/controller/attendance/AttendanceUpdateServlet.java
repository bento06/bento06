package controller.attendance;

import dao.AttendanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.AttendanceCalculationResult;
import model.AttendanceRecord;
import model.AttendanceRecordDTO;
import service.AttendanceCalculationService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Set;

@WebServlet("/attendance/update")
public class AttendanceUpdateServlet extends HttpServlet {
    private static final List<String> ATTENDANCE_STATUSES = List.of(
            "ON_TIME",
            "LATE",
            "EARLY_LEAVE",
            "LATE_AND_EARLY",
            "ABSENT",
            "ON_LEAVE",
            "FORGOT_CHECKIN",
            "FORGOT_CHECKOUT"
    );
    private static final Set<String> VALID_STATUSES = Set.copyOf(ATTENDANCE_STATUSES);

    private final AttendanceDAO attendanceDAO = new AttendanceDAO();
    private final AttendanceCalculationService calculationService =
            new AttendanceCalculationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer id = parsePositiveInteger(request.getParameter("id"));
        if (id == null) {
            redirectToRecords(request, response, "invalid_id");
            return;
        }

        AttendanceRecordDTO record = attendanceDAO.getAttendanceRecordDetailById(id);
        if (record == null) {
            redirectToRecords(request, response, "record_not_found");
            return;
        }

        record.setStatus(normalizeStatusForForm(record.getStatus()));
        forwardToForm(request, response, record, null);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer id = parsePositiveInteger(request.getParameter("id"));
        if (id == null) {
            redirectToRecords(request, response, "invalid_id");
            return;
        }

        AttendanceRecordDTO existingRecord = attendanceDAO.getAttendanceRecordDetailById(id);
        if (existingRecord == null) {
            redirectToRecords(request, response, "record_not_found");
            return;
        }

        String checkInText = trimToEmpty(request.getParameter("checkIn"));
        String checkOutText = trimToEmpty(request.getParameter("checkOut"));
        String status = trimToEmpty(request.getParameter("status"));
        String note = trimToEmpty(request.getParameter("note"));

        existingRecord.setCheckInText(checkInText);
        existingRecord.setCheckOutText(checkOutText);
        existingRecord.setStatus(status);
        existingRecord.setNote(note);

        if (!VALID_STATUSES.contains(status)) {
            forwardToForm(
                    request,
                    response,
                    existingRecord,
                    "Please select a valid attendance status."
            );
            return;
        }
        if (note.isEmpty()) {
            forwardToForm(
                    request,
                    response,
                    existingRecord,
                    "Reason for change is required."
            );
            return;
        }
        if (note.length() > 1000) {
            forwardToForm(
                    request,
                    response,
                    existingRecord,
                    "Reason for change must not exceed 1000 characters."
            );
            return;
        }

        LocalDateTime checkIn;
        LocalDateTime checkOut;
        try {
            checkIn = parseNullableTime(checkInText, existingRecord);
            checkOut = parseNullableTime(checkOutText, existingRecord);
        } catch (DateTimeParseException e) {
            forwardToForm(
                    request,
                    response,
                    existingRecord,
                    "Check-in or check-out has an invalid time format."
            );
            return;
        }

        if (checkIn != null && checkOut != null && checkOut.isBefore(checkIn)) {
            forwardToForm(
                    request,
                    response,
                    existingRecord,
                    "Check-out time cannot be before check-in time."
            );
            return;
        }

        AttendanceCalculationResult calculation =
                calculationService.calculateAttendanceAfterUpdate(checkIn, checkOut, status);

        AttendanceRecord record = new AttendanceRecord();
        record.setId(id);
        record.setUserId(existingRecord.getUserId());
        record.setWorkDate(existingRecord.getWorkDate());
        record.setCheckIn(checkIn);
        record.setCheckOut(checkOut);
        record.setTotalWorkHours(calculation.getTotalWorkHours());
        record.setLateHours(calculation.getLateHours());
        record.setEarlyLeaveHours(calculation.getEarlyLeaveHours());
        record.setStatus(calculation.getStatus());
        record.setNote(note);

        if (!attendanceDAO.updateAttendanceRecord(record)) {
            forwardToForm(
                    request,
                    response,
                    existingRecord,
                    "Unable to update the attendance record. Please try again."
            );
            return;
        }

        response.sendRedirect(
                request.getContextPath()
                        + "/attendance/records?month=" + existingRecord.getWorkDate().getMonthValue()
                        + "&year=" + existingRecord.getWorkDate().getYear()
                        + "&message=updated"
        );
    }

    private void forwardToForm(
            HttpServletRequest request,
            HttpServletResponse response,
            AttendanceRecordDTO record,
            String error
    ) throws ServletException, IOException {
        request.setAttribute("record", record);
        request.setAttribute("attendanceStatuses", ATTENDANCE_STATUSES);
        request.setAttribute("error", error);
        request.getRequestDispatcher("/WEB-INF/views/attendance/update_attendance_record.jsp")
                .forward(request, response);
    }

    private void redirectToRecords(
            HttpServletRequest request,
            HttpServletResponse response,
            String error
    ) throws IOException {
        response.sendRedirect(
                request.getContextPath() + "/attendance/records?error=" + error
        );
    }

    private LocalDateTime parseNullableTime(String value, AttendanceRecordDTO record) {
        return value.isEmpty()
                ? null
                : LocalDateTime.of(record.getWorkDate(), LocalTime.parse(value));
    }

    private Integer parsePositiveInteger(String value) {
        try {
            int parsed = Integer.parseInt(value);
            return parsed > 0 ? parsed : null;
        } catch (Exception e) {
            return null;
        }
    }

    private String normalizeStatusForForm(String status) {
        if ("FORGOT_CHECK_IN".equals(status)) {
            return "FORGOT_CHECKIN";
        }
        if ("FORGOT_CHECK_OUT".equals(status)) {
            return "FORGOT_CHECKOUT";
        }
        if ("LATE_AND_EARLY_LEAVE".equals(status)) {
            return "LATE_AND_EARLY";
        }
        return status;
    }

    private String trimToEmpty(String value) {
        return value == null ? "" : value.trim();
    }
}
