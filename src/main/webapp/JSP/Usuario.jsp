<%@ include file="conexion.jsp" %>
<%@ page import="org.mindrot.jbcrypt.BCrypt" %>

<%
if (request.getParameter("listar") != null) {
    try {
        if (request.getParameter("listar").equals("listar")) {
            String query = "SELECT u.idusuarios, u.usu_nombre, u.usu_contraseña, u.usu_estado, r.id_rol, r.rol_nombre FROM usuarios u INNER JOIN rol r ON u.rol_idrol = r.id_rol ORDER BY u.idusuarios ASC";

            try (PreparedStatement ps = conn.prepareStatement(query);
                 ResultSet rs = ps.executeQuery()) {
%>
<%
    while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getInt(1) %></td>
    <td><%= rs.getString(2) %></td>
    <td>********</td>
    <td><%= rs.getString(4) %></td>
    <td><%= rs.getString(6) %></td>
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoUsuariosEspecificos.jsp?id=<%= rs.getInt(1) %>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;"
           onclick="rellenarjs('<%= rs.getInt(1) %>', '<%= rs.getString(2) %>', '<%= rs.getString(3) %>', '<%= rs.getString(4) %>', '<%= rs.getInt(5) %>')">
        </i>
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getInt(1) %>')"></i>
    </td>
</tr>
<%
        }
    }
} else if (request.getParameter("listar").equals("cargar")) {
    String usu_nombre = request.getParameter("usu_nombre");
    String usu_contraseña = request.getParameter("usu_contraseña");
    String usu_estado = request.getParameter("usu_estado");
    int rol_idrol = Integer.parseInt(request.getParameter("rol_idrol"));

    String checkQuery = "SELECT COUNT(*) FROM usuarios WHERE LOWER(usu_nombre) = LOWER(?)";
    String insertQuery = "INSERT INTO usuarios (usu_nombre, usu_contraseña, usu_estado, rol_idrol) VALUES (?, ?, ?, ?)";
    try (PreparedStatement checkPs = conn.prepareStatement(checkQuery)) {
        checkPs.setString(1, usu_nombre);
        try (ResultSet rs = checkPs.executeQuery()) {
            rs.next();
            int count = rs.getInt(1);
            if (count > 0) {
                out.println("<div class='alert alert-danger' role='alert'>El usuario ya existe. Ingrese otro nombre de usuario.</div>");
            } else {
                // Cifrar la contraseña antes de insertarla
                String hashedPassword = BCrypt.hashpw(usu_contraseña, BCrypt.gensalt());
                try (PreparedStatement insertPs = conn.prepareStatement(insertQuery)) {
                    insertPs.setString(1, usu_nombre);
                    insertPs.setString(2, hashedPassword); // Usar la contraseña cifrada
                    insertPs.setString(3, usu_estado);
                    insertPs.setInt(4, rol_idrol);
                    insertPs.executeUpdate();
                    out.println("<div class='alert alert-success' role='alert'>Usuario Insertado Correctamente</div>");
                }
            }
        }
    }
} else if (request.getParameter("listar").equals("modificar")) {
    String idusuario = request.getParameter("idusuario");
    String usu_nombre = request.getParameter("usu_nombre");
    String usu_contraseña = request.getParameter("usu_contraseña");
    String usu_estado = request.getParameter("usu_estado");
    int rol_idrol = Integer.parseInt(request.getParameter("rol_idrol"));

    String checkQuery = "SELECT COUNT(*) FROM usuarios WHERE LOWER(usu_nombre) = LOWER(?) AND idusuarios != ?";
    String updateQuery = "UPDATE usuarios SET usu_nombre = ?, usu_contraseña = ?, usu_estado = ?, rol_idrol = ? WHERE idusuarios = ?";
    try (PreparedStatement checkPs = conn.prepareStatement(checkQuery)) {
        checkPs.setString(1, usu_nombre);
        checkPs.setInt(2, Integer.parseInt(idusuario));
        try (ResultSet rs = checkPs.executeQuery()) {
            rs.next();
            int countName = rs.getInt(1);
            if (countName > 0) {
                out.println("<div class='alert alert-danger' role='alert'>El nombre de usuario ya existe. Ingrese otro nombre de usuario.</div>");
            } else {
                // Cifrar la nueva contraseña antes de actualizar
                String hashedPassword = BCrypt.hashpw(usu_contraseña, BCrypt.gensalt());
                try (PreparedStatement updatePs = conn.prepareStatement(updateQuery)) {
                    updatePs.setString(1, usu_nombre);
                    updatePs.setString(2, hashedPassword); // Usar la nueva contraseña cifrada
                    updatePs.setString(3, usu_estado);
                    updatePs.setInt(4, rol_idrol);
                    updatePs.setInt(5, Integer.parseInt(idusuario));
                    updatePs.executeUpdate();
                    out.println("<div class='alert alert-success' role='alert'>Usuario Modificado Correctamente</div>");
                }
            }
        }
    }
} else if (request.getParameter("listar").equals("eliminar")) {
    String id_delete = request.getParameter("id_delete");
    String deleteQuery = "DELETE FROM usuarios WHERE idusuarios = ?";
    try (PreparedStatement ps = conn.prepareStatement(deleteQuery)) {
        ps.setInt(1, Integer.parseInt(id_delete));
        ps.executeUpdate();
        out.println("<div class='alert alert-success' role='alert'>Usuario Eliminado Correctamente</div>");
    } catch (SQLException e) {
        if (e.getSQLState().equals("23503")) {
            out.println("<div class='alert alert-danger' role='alert'>El Usuario está siendo utilizado y no se puede eliminar</div>");
        } else {
            out.println("<div class='alert alert-danger' role='alert'>Error al eliminar usuario: " + e + "</div>");
        }
    }
} else if (request.getParameter("listar").equals("cargarRoles")) {
    String query = "SELECT * FROM rol WHERE rol_nombre <> 'Cliente'";
    try (PreparedStatement ps = conn.prepareStatement(query);
         ResultSet rs = ps.executeQuery()) {
        out.print("<option value='selectrol'>Seleccione un Rol</option>");
        while (rs.next()) {
            out.print("<option value='" + rs.getInt(1) + "'>" + rs.getString(2) + "</option>");
        }
    } catch (Exception e) {
        out.println("<option value=''>Error al cargar roles</option>");
    }
} else if (request.getParameter("listar").equals("buscador")) {
    String buscador = request.getParameter("buscador").trim().toLowerCase();
    String searchQuery = "SELECT u.idusuarios, u.usu_nombre, u.usu_contraseña, u.usu_estado, r.id_rol, r.rol_nombre FROM usuarios u INNER JOIN rol r ON u.rol_idrol = r.id_rol WHERE LOWER(u.usu_nombre) LIKE ? OR LOWER(r.rol_nombre) LIKE ? ORDER BY u.idusuarios ASC";
    try (PreparedStatement ps = conn.prepareStatement(searchQuery)) {
        ps.setString(1, buscador + "%");
        ps.setString(2, buscador + "%");
        try (ResultSet rs = ps.executeQuery()) {
%>
<%
    while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getInt(1) %></td>
    <td><%= rs.getString(2) %></td>
    <td>********</td>
    <td><%= rs.getString(4) %></td>
    <td><%= rs.getString(6) %></td>
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoUsuariosEspecificos.jsp?id=<%= rs.getInt(1) %>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;"
           onclick="rellenarjs('<%= rs.getInt(1) %>', '<%= rs.getString(2) %>', '<%= rs.getString(3) %>', '<%= rs.getString(4) %>', '<%= rs.getInt(5) %>')">
        </i>
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getInt(1) %>')"></i>
    </td>
</tr>
<%
                        }
                    }
                } catch (Exception e) {
                    out.println("Error: " + e);
                }
            }
        } catch (Exception e) {
            out.print("Error: " + e);
        }
    }
%>