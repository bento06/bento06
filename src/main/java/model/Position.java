package model;

import java.time.LocalDateTime;

public class Position {
    private int id;
    private int departmentId;
    private String name;
    private String description;
    private boolean active;
    private String departmentName;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Position() {
    }

    public Position(int id, int departmentId, String name, String description, boolean active, String departmentName, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.departmentId = departmentId;
        this.name = name;
        this.description = description;
        this.active = active;
        this.departmentName = departmentName;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(int departmentId) {
        this.departmentId = departmentId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }
}