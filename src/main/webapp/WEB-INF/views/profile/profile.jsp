<%@ page import="model.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    User user = (User) request.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Profile</title>
</head>
<body>

<jsp:include page="/WEB-INF/views/common/navbar.jsp" />

<div>
    <h1>My Profile</h1>

    <table>
        <tr>
            <td><strong>Avatar:</strong></td>
            <td>
                <% if (user.getAvatarUrl() != null && !user.getAvatarUrl().trim().isEmpty()) { %>
                    <img src="<%= user.getAvatarUrl() %>" width="100" height="100" alt="Avatar">
                <% } else { %>
                    <img src="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='100'%3E%3Crect width='100' height='100' fill='white' stroke='%23cccccc'/%3E%3Ctext x='8' y='18' font-size='14' fill='black'%3ENo Avatar%3C/text%3E%3C/svg%3E"
                         width="100" height="100" alt="No Avatar">
                <% } %>
            </td>
        </tr>
    </table>

    <p><strong>Full Name:</strong> <%= user.getFullName() %></p>
    <p><strong>Email:</strong> <%= user.getEmail() %></p>
    <p><strong>Phone:</strong> <%= user.getPhone() %></p>
    <p><strong>Gender:</strong> <%= user.getGender() %></p>
    <p><strong>Date of Birth:</strong> <%= user.getDateOfBirth() != null ? user.getDateOfBirth().toLocalDate() : "" %></p>
    <p><strong>Address:</strong> <%= user.getAddress() %></p>
    <p><strong>Role:</strong> <%= user.getRoleName() %></p>
    <p><strong>Status:</strong> <%= user.isActive() ? "Active" : "Inactive" %></p>
</div>

</body>
</html>
