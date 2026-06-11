package service;

import model.AttendanceCalculationResult;

import java.time.Duration;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class AttendanceCalculationService {
    private static final LocalTime STANDARD_CHECK_IN = LocalTime.of(8, 0);
    private static final LocalTime STANDARD_CHECK_OUT = LocalTime.of(17, 0);
    private static final double STANDARD_WORK_HOURS = 8.0;
    private static final double HALF_DAY_WORK_HOURS = 4.0;
    private static final int LATE_GRACE_MINUTES = 5;
    private static final int PENALTY_BLOCK_MINUTES = 30;

    public AttendanceCalculationResult calculateAttendanceAfterUpdate(
            LocalDateTime checkIn,
            LocalDateTime checkOut,
            String requestedStatus
    ) {
        if (checkIn == null && checkOut == null) {
            return new AttendanceCalculationResult(0.0, 0.0, 0.0, "ABSENT");
        }
        if (checkIn == null) {
            return new AttendanceCalculationResult(
                    HALF_DAY_WORK_HOURS,
                    0.0,
                    0.0,
                    "FORGOT_CHECKIN"
            );
        }
        if (checkOut == null) {
            return new AttendanceCalculationResult(
                    HALF_DAY_WORK_HOURS,
                    0.0,
                    0.0,
                    "FORGOT_CHECKOUT"
            );
        }

        long lateMinutes = Math.max(
                0,
                Duration.between(STANDARD_CHECK_IN, checkIn.toLocalTime()).toMinutes()
        );
        long earlyLeaveMinutes = Math.max(
                0,
                Duration.between(checkOut.toLocalTime(), STANDARD_CHECK_OUT).toMinutes()
        );

        double latePenalty = calculateLatePenalty(lateMinutes);
        double earlyLeavePenalty = calculateBlockPenalty(earlyLeaveMinutes);
        double totalWorkHours = Math.max(
                0.0,
                STANDARD_WORK_HOURS - latePenalty - earlyLeavePenalty
        );

        return new AttendanceCalculationResult(
                roundToTwoDecimals(totalWorkHours),
                roundToTwoDecimals(lateMinutes / 60.0),
                roundToTwoDecimals(earlyLeaveMinutes / 60.0),
                requestedStatus
        );
    }

    private double calculateLatePenalty(long lateMinutes) {
        if (lateMinutes <= LATE_GRACE_MINUTES) {
            return 0.0;
        }
        long punishableMinutes = lateMinutes - LATE_GRACE_MINUTES;
        return calculateBlockPenalty(punishableMinutes);
    }

    private double calculateBlockPenalty(long minutes) {
        if (minutes <= 0) {
            return 0.0;
        }
        long blocks = (minutes + PENALTY_BLOCK_MINUTES - 1) / PENALTY_BLOCK_MINUTES;
        return blocks * 0.5;
    }

    private double roundToTwoDecimals(double value) {
        return Math.round(value * 100.0) / 100.0;
    }
}
