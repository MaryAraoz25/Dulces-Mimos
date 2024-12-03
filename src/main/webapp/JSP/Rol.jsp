<%@ include file="conexion.jsp" %>

<%    if (request.getParameter("listar") != null) {
        try {
            if (request.getParameter("listar").equals("listar")) {
                String query = "SELECT * FROM rol ORDER BY id_rol ASC";
                try (PreparedStatement pst = conn.prepareStatement(query);
                        ResultSet rs = pst.executeQuery()) {
%>
<%
    while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getInt(1)%></td>
    <td><%= rs.getString(2)%></td>
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoRolesEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" onclick="rellenarjs('<%= rs.getInt(1)%>', '<%= rs.getString(2)%>')"></i>
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getInt(1)%>')"></i>
    </td>
</tr>
<%
        }
    }
} else if (request.getParameter("listar").equals("cargar")) {
    String rol_nombre = request.getParameter("rol_nombre").trim();
    if (!rol_nombre.isEmpty()) {
        rol_nombre = Character.toUpperCase(rol_nombre.charAt(0)) + rol_nombre.substring(1).toLowerCase();
    }
    String queryCheck = "SELECT COUNT(*) FROM rol WHERE LOWER(rol_nombre) = ?";
    try (PreparedStatement pstCheck = conn.prepareStatement(queryCheck)) {
        pstCheck.setString(1, rol_nombre.toLowerCase());
        try (ResultSet rs = pstCheck.executeQuery()) {
            rs.next();
            int count = rs.getInt(1);
            if (count > 0) {
                out.println("<div class='alert alert-danger' role='alert'>El rol ya existe. Ingrese un rol diferente.</div>");
            } else {
                String queryInsert = "INSERT INTO rol (rol_nombre) VALUES (?)";
                try (PreparedStatement pstInsert = conn.prepareStatement(queryInsert)) {
                    pstInsert.setString(1, rol_nombre);
                    pstInsert.executeUpdate();
                    out.println("<div class='alert alert-success' role='alert'>Rol Insertado Correctamente</div>");
                }
            }
        }
    }
} else if (request.getParameter("listar").equals("modificar")) {
    String id_rol = request.getParameter("id_rol");
    String rol_nombre = request.getParameter("rol_nombre").trim();
    if (!rol_nombre.isEmpty()) {
        rol_nombre = Character.toUpperCase(rol_nombre.charAt(0)) + rol_nombre.substring(1).toLowerCase();
    }
    String queryCheck = "SELECT COUNT(*) FROM rol WHERE LOWER(rol_nombre) = ? AND id_rol != ?";
    try (PreparedStatement pstCheck = conn.prepareStatement(queryCheck)) {
        pstCheck.setString(1, rol_nombre.toLowerCase());
        pstCheck.setInt(2, Integer.parseInt(id_rol));
        try (ResultSet rs = pstCheck.executeQuery()) {
            rs.next();
            int count = rs.getInt(1);
            if (count > 0) {
                out.println("<div class='alert alert-danger' role='alert'>El rol ya existe. Ingrese un rol diferente.</div>");
            } else {
                String queryUpdate = "UPDATE rol SET rol_nombre = ? WHERE id_rol = ?";
                try (PreparedStatement pstUpdate = conn.prepareStatement(queryUpdate)) {
                    pstUpdate.setString(1, rol_nombre);
                    pstUpdate.setInt(2, Integer.parseInt(id_rol));
                    pstUpdate.executeUpdate();
                    out.println("<div class='alert alert-success' role='alert'>Rol Modificado Correctamente</div>");
                }
            }
        }
    }
} else if (request.getParameter("listar").equals("eliminar")) {
    String id_delete = request.getParameter("id_delete");
    String queryDelete = "DELETE FROM rol WHERE id_rol = ?";
    try (PreparedStatement pstDelete = conn.prepareStatement(queryDelete)) {
        pstDelete.setInt(1, Integer.parseInt(id_delete));
        pstDelete.executeUpdate();
        out.println("<div class='alert alert-success' role='alert'>Rol Eliminado Correctamente</div>");
    } catch (SQLException e) {
        if (e.getSQLState().equals("23503")) {
            out.println("<div class='alert alert-danger' role='alert'>El Rol está siendo utilizado y no se puede eliminar</div>");
        } else {
            out.println("<div class='alert alert-danger' role='alert'>Error PSQL: " + e + "</div>");
        }
    }
} else if (request.getParameter("listar").equals("buscador")) {
    String buscador = request.getParameter("buscador").trim().toLowerCase();
    String query = "SELECT * FROM rol WHERE LOWER(rol_nombre) LIKE ? ORDER BY id_rol ASC";
    try (PreparedStatement pst = conn.prepareStatement(query)) {
        pst.setString(1, buscador + "%");
        try (ResultSet rs = pst.executeQuery()) {
%>
<%
    while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getInt(1)%></td>
    <td><%= rs.getString(2)%></td>
    <td class="text-center">
        <!-- Icono de editar -->
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" onclick="rellenarjs('<%= rs.getInt(1)%>', '<%= rs.getString(2)%>')"></i>
        <!-- Icono de eliminar -->
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getInt(1)%>')"></i>
        <a href="${pageContext.request.contextPath}/ReportesJSP/ListadoRolesEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
    </td>
</tr>
<%
                        }
                    }
                } catch (Exception e) {
                    out.println("Error PSQL: " + e);
                }
            }
        } catch (Exception e) {
            out.print("Error: " + e);
            
        }
    }
    
%>
