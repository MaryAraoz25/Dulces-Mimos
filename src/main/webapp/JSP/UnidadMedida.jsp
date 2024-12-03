<%@ include file="conexion.jsp" %>

<%    if (request.getParameter("listar") != null) {
        String listar = request.getParameter("listar");

        if (listar.equals("listar")) {
            try {
                String query = "SELECT * FROM unidad_medida ORDER BY idunidad_medida ASC";
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
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoUnidadMedidaEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <!-- Icono de editar -->
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" onclick="rellenarjs('<%= rs.getInt(1)%>', '<%= rs.getString(2)%>')"></i>
        <!-- Icono de eliminar -->
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getString(1)%>')"></i>
    </td>
</tr>
<%
            }
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error PSQL: " + e.getMessage() + "</div>");
    }

} else if (listar.equals("cargar")) {
    String descripcion = request.getParameter("descripcion");
    if (descripcion != null && !descripcion.isEmpty()) {
        descripcion = Character.toUpperCase(descripcion.charAt(0)) + descripcion.substring(1).toLowerCase();
    }

    String checkQuery = "SELECT COUNT(*) FROM unidad_medida WHERE LOWER(descripcion) = LOWER(?)";
    String insertQuery = "INSERT INTO unidad_medida (descripcion) VALUES (?)";

    try {
        try (PreparedStatement checkPst = conn.prepareStatement(checkQuery)) {
            checkPst.setString(1, descripcion);
            try (ResultSet rs = checkPst.executeQuery()) {
                rs.next();
                int count = rs.getInt(1);
                if (count > 0) {
                    out.println("<div class='alert alert-danger' role='alert'>La unidad de medida ya existe. Ingrese una unidad de medida diferente.</div>");
                } else {
                    try (PreparedStatement insertPst = conn.prepareStatement(insertQuery)) {
                        insertPst.setString(1, descripcion);
                        insertPst.executeUpdate();
                        out.println("<div class='alert alert-success' role='alert'>Unidad De Medida Insertada Correctamente</div>");
                    }
                }
            }
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error PSQL: " + e.getMessage() + "</div>");
    }
} if (listar.equals("modificar")) {
            String idunidad_medida = request.getParameter("idunidad_medida");
            String descripcion = request.getParameter("descripcion");
            if (descripcion != null && !descripcion.isEmpty()) {
                descripcion = Character.toUpperCase(descripcion.charAt(0)) + descripcion.substring(1).toLowerCase();
            }

            String checkQuery = "SELECT COUNT(*) FROM unidad_medida WHERE LOWER(descripcion) = LOWER(?) AND idunidad_medida != ?";
            String updateQuery = "UPDATE unidad_medida SET descripcion = ? WHERE idunidad_medida = ?";

            try {
                // Verificar si la descripción ya existe para otro ID
                try (PreparedStatement checkPst = conn.prepareStatement(checkQuery)) {
                    checkPst.setString(1, descripcion);
                    checkPst.setInt(2, Integer.parseInt(idunidad_medida));
                    try (ResultSet rs = checkPst.executeQuery()) {
                        rs.next();
                        int count = rs.getInt(1);

                        if (count > 0) {
                            out.println("<div class='alert alert-danger' role='alert'>La unidad de medida ya existe. Ingrese una unidad de medida diferente.</div>");
                        } else {
                            // Actualizar la descripción de la unidad de medida
                            try (PreparedStatement updatePst = conn.prepareStatement(updateQuery)) {
                                updatePst.setString(1, descripcion);
                                updatePst.setInt(2, Integer.parseInt(idunidad_medida));
                                updatePst.executeUpdate();
                                out.println("<div class='alert alert-success' role='alert'>Unidad De Medida Modificada Correctamente</div>");
                            }
                        }
                    }
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger' role='alert'>Error PSQL: " + e.getMessage() + "</div>");
            }
        }else if (listar.equals("eliminar")) {
    String id_delete = request.getParameter("id_delete");
    String deleteQuery = "DELETE FROM unidad_medida WHERE idunidad_medida = ?";

    try {
        try (PreparedStatement deletePst = conn.prepareStatement(deleteQuery)) {
           deletePst.setInt(1, Integer.parseInt(id_delete));
            deletePst.executeUpdate();
            out.println("<div class='alert alert-success' role='alert'>Unidad De Medida Eliminada Correctamente</div>");
        }
    } catch (SQLException e) {
        if ("23503".equals(e.getSQLState())) { // Violación de restricción de clave externa
            out.println("<div class='alert alert-danger' role='alert'>La unidad de medida está siendo utilizada y no se puede eliminar</div>");
        } else {
            out.println("<div class='alert alert-danger' role='alert'>Error PSQL: " + e.getMessage() + "</div>");
        }
    }
} else if (listar.equals("buscador")) {
    String buscador = request.getParameter("buscador").trim().toLowerCase();
    String searchQuery = "SELECT * FROM unidad_medida WHERE LOWER(descripcion) LIKE ? ORDER BY idunidad_medida ASC";

    try {
        try (PreparedStatement searchPst = conn.prepareStatement(searchQuery)) {
            searchPst.setString(1, buscador + "%");
            try (ResultSet rs = searchPst.executeQuery()) {
%>
<%
    while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getInt(1)%></td>
    <td><%= rs.getString(2)%></td>
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoUnidadMedidaEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <!-- Icono de editar -->
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" onclick="rellenarjs('<%= rs.getInt(1)%>', '<%= rs.getString(2)%>')"></i>
        <!-- Icono de eliminar -->
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getString(1)%>')"></i>
    </td>
</tr>
<%
                        }
                    }
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger' role='alert'>Error PSQL: " + e.getMessage() + "</div>");
            }
        }
    }
%>
