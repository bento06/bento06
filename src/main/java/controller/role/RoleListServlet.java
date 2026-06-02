package controller.role;

import dao.RoleDAO;
import model.Role;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/roles")
public class RoleListServlet extends HttpServlet {

    private final RoleDAO roleDAO = new RoleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy tham số tìm kiếm và lọc
        String search = request.getParameter("search");
        String statusParam = request.getParameter("status");

        // Xác định giá trị active: null, true, false
        Boolean active = null;
        if (statusParam != null && !statusParam.isEmpty() && !statusParam.equals("all")) {
            active = Boolean.parseBoolean(statusParam); // "true" hoặc "false"
        }

        // Gọi DAO
        List<Role> roles = roleDAO.searchRoles(search, active);

        // Truyền dữ liệu sang view
        request.setAttribute("roles", roles);
        request.setAttribute("search", search);
        request.setAttribute("status", statusParam);

        request.getRequestDispatcher("/WEB-INF/views/role/role_list.jsp")
                .forward(request, response);
    }
}
