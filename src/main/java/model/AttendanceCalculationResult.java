package model;

public class AttendanceCalculationResult {
    private final double totalWorkHours;
    private final double lateHours;
    private final double earlyLeaveHours;
    private final String status;

    public AttendanceCalculationResult(
            double totalWorkHours,
            double lateHours,
            double earlyLeaveHours,
            String status
    ) {
        this.totalWorkHours = totalWorkHours;
        this.lateHours = lateHours;
        this.earlyLeaveHours = earlyLeaveHours;
        this.status = status;
    }

    public double getTotalWorkHours() {
        return totalWorkHours;
    }

    public double getLateHours() {
        return lateHours;
    }

    public double getEarlyLeaveHours() {
        return earlyLeaveHours;
    }

    public String getStatus() {
        return status;
    }
}
