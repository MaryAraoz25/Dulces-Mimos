<%@ include file="conexion.jsp" %>

<%    if (request.getParameter("listar") != null) {
        String listar = request.getParameter("listar");

        try {
            if (listar.equals("listar")) {
                String query = "SELECT * FROM proveedores ORDER BY idproveedores ASC";
                try (PreparedStatement pst = conn.prepareStatement(query);
                        ResultSet rs = pst.executeQuery()) {
%>
<%
    while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getInt(1)%></td> <!-- idproveedores es un entero -->
    <td><%= rs.getString(2)%></td> <!-- prov_nombre es una cadena -->
    <td><%= rs.getString(3)%></td> <!-- prov_direccion es una cadena -->
    <td><%= rs.getString(4)%></td> <!-- prov_correo es una cadena -->
    <td><%= rs.getString(5)%></td> <!-- prov_telefono es una cadena -->
    <td><%= rs.getString(6)%></td>
    <td><%= rs.getString(7)%></td>
    <td><%= rs.getString(8)%></td>
    <td><%= rs.getString(9)%></td>
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoProveedoresEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <!-- Icono de editar -->
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" onclick="rellenarjs('<%= rs.getInt(1)%>', '<%= rs.getString(2)%>', '<%= rs.getString(3)%>', '<%= rs.getString(4)%>', '<%= rs.getString(5)%>', '<%= rs.getString(6)%>', '<%= rs.getString(7)%>', '<%= rs.getString(8)%>', '<%= rs.getString(9)%>')"></i>
        <!-- Icono de eliminar -->
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getInt(1)%>')"></i>
    </td>
</tr>
<%
    }
%>
<%
    }
} else if (listar.equals("cargar")) {
    String prov_nombre = request.getParameter("prov_nombre");
    String prov_direccion = request.getParameter("prov_direccion");
    String prov_correo = request.getParameter("prov_correo");
    String prov_telefono = request.getParameter("prov_telefono");
    String prov_ruc = request.getParameter("prov_ruc");
    String prov_timbrado = request.getParameter("prov_timbrado");
    String prov_inicio = request.getParameter("prov_inicio");
    String prov_fin = request.getParameter("prov_fin");

    try {
        String checkQuery = "SELECT COUNT(*) FROM proveedores WHERE LOWER(prov_correo) = LOWER(?) OR LOWER(prov_nombre) = LOWER(?) OR LOWER(prov_ruc) = LOWER(?) OR LOWER(prov_telefono) = LOWER(?)";
        try (PreparedStatement checkPst = conn.prepareStatement(checkQuery)) {
            checkPst.setString(1, prov_correo);
            checkPst.setString(2, prov_nombre);
            checkPst.setString(3, prov_ruc);
            checkPst.setString(4, prov_telefono);
            try (ResultSet rs = checkPst.executeQuery()) {
                rs.next();
                int count = rs.getInt(1);

                if (count > 0) {
                    out.println("<div class='alert alert-danger' role='alert'>El proveedor ya existe. Ingrese un proveedor diferente.</div>");
                } else {
                    String insertQuery = "INSERT INTO proveedores (prov_nombre, prov_direccion, prov_correo, prov_telefono, prov_ruc, prov_timbrado, prov_inicio, prov_fin) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement insertPst = conn.prepareStatement(insertQuery)) {
                        insertPst.setString(1, prov_nombre);
                        insertPst.setString(2, prov_direccion);
                        insertPst.setString(3, prov_correo);
                        insertPst.setString(4, prov_telefono);
                        insertPst.setString(5, prov_ruc);
                        insertPst.setString(6, prov_timbrado);
                        insertPst.setDate(7, java.sql.Date.valueOf(prov_inicio)); // Convertir a java.sql.Date
                        insertPst.setDate(8, java.sql.Date.valueOf(prov_fin));    // Convertir a java.sql.Date
                        insertPst.executeUpdate();
                        out.println("<div class='alert alert-success' role='alert'>Proveedor Insertado Correctamente</div>");
                    }
                }
            }
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error PSQL: " + e.getMessage() + "</div>");
    }
} else if (listar.equals("modificar")) {
    String idproveedores = request.getParameter("idproveedores");
    String prov_nombre = request.getParameter("prov_nombre");
    String prov_direccion = request.getParameter("prov_direccion");
    String prov_correo = request.getParameter("prov_correo");
    String prov_telefono = request.getParameter("prov_telefono");
    String prov_ruc = request.getParameter("prov_ruc");
    String prov_timbrado = request.getParameter("prov_timbrado");
    String prov_inicio = request.getParameter("prov_inicio");
    String prov_fin = request.getParameter("prov_fin");

    try {
        String checkQuery = "SELECT COUNT(*) FROM proveedores WHERE (LOWER(prov_correo) = LOWER(?) OR LOWER(prov_nombre) = LOWER(?) OR LOWER(prov_ruc) = LOWER(?) OR LOWER(prov_telefono) = LOWER(?)) AND idproveedores != ?";
        try (PreparedStatement checkPst = conn.prepareStatement(checkQuery)) {
            checkPst.setString(1, prov_correo);
            checkPst.setString(2, prov_nombre);
            checkPst.setString(3, prov_ruc);
            checkPst.setString(4, prov_telefono);
            checkPst.setInt(5, Integer.parseInt(idproveedores));
            try (ResultSet rs = checkPst.executeQuery()) {
                rs.next();
                int count = rs.getInt(1);

                if (count > 0) {
                    out.println("<div class='alert alert-danger' role='alert'>El proveedor ya existe. Ingrese un proveedor diferente.</div>");
                } else {
                    String updateQuery = "UPDATE proveedores SET prov_nombre = ?, prov_direccion = ?, prov_correo = ?, prov_telefono = ?, prov_ruc = ?, prov_timbrado = ?, prov_inicio = ?, prov_fin = ? WHERE idproveedores = ?";
                    try (PreparedStatement updatePst = conn.prepareStatement(updateQuery)) {
                        updatePst.setString(1, prov_nombre);
                        updatePst.setString(2, prov_direccion);
                        updatePst.setString(3, prov_correo);
                        updatePst.setString(4, prov_telefono);
                        updatePst.setString(5, prov_ruc);
                        updatePst.setString(6, prov_timbrado);
                        updatePst.setDate(7, java.sql.Date.valueOf(prov_inicio)); // Convertir a java.sql.Date
                        updatePst.setDate(8, java.sql.Date.valueOf(prov_fin));    // Convertir a java.sql.Date
                        updatePst.setInt(9, Integer.parseInt(idproveedores)); // ID del proveedor
                        updatePst.executeUpdate();
                        out.println("<div class='alert alert-success' role='alert'>Proveedor Modificado Correctamente</div>");
                    }
                }
            }
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error PSQL: " + e.getMessage() + "</div>");
    }
} else if (listar.equals("eliminar")) {
    String id_delete = request.getParameter("id_delete");
    try {
        String deleteQuery = "DELETE FROM proveedores WHERE idproveedores = ?";
        try (PreparedStatement deletePst = conn.prepareStatement(deleteQuery)) {
            deletePst.setInt(1, Integer.parseInt(id_delete));
            deletePst.executeUpdate();
            out.println("<div class='alert alert-success' role='alert'>Proveedor Eliminado Correctamente</div>");
        }
    } catch (SQLException e) {
        if ("23503".equals(e.getSQLState())) { // Violación de restricción de clave externa
            out.println("<div class='alert alert-danger' role='alert'>El proveedor está siendo utilizado y no puede ser eliminado</div>");
        } else {
            out.println("<div class='alert alert-danger' role='alert'>Error al eliminar proveedor: " + e.getMessage() + "</div>");
        }
    }
} else if (listar.equals("buscador")) {
    String buscador = request.getParameter("buscador").trim().toLowerCase();
    try {
        String searchQuery = "SELECT * FROM proveedores WHERE LOWER(prov_nombre) LIKE ? OR LOWER(prov_ruc) LIKE ? ORDER BY idproveedores ASC";
        try (PreparedStatement searchPst = conn.prepareStatement(searchQuery)) {
            searchPst.setString(1, buscador + "%");
            searchPst.setString(2, buscador + "%");
            try (ResultSet rs = searchPst.executeQuery()) {
%>
<%
    while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getInt(1)%></td> <!-- idproveedores es un entero -->
    <td><%= rs.getString(2)%></td> <!-- prov_nombre es una cadena -->
    <td><%= rs.getString(3)%></td> <!-- prov_direccion es una cadena -->
    <td><%= rs.getString(4)%></td> <!-- prov_correo es una cadena -->
    <td><%= rs.getString(5)%></td> <!-- prov_telefono es una cadena -->
    <td><%= rs.getString(6)%></td>
    <td><%= rs.getString(7)%></td>
    <td><%= rs.getString(8)%></td>
    <td><%= rs.getString(9)%></td><!-- prov_ruc es una cadena -->
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoProveedoresEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <!-- Icono de editar -->
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" onclick="rellenarjs('<%= rs.getInt(1)%>', '<%= rs.getString(2)%>', '<%= rs.getString(3)%>', '<%= rs.getString(4)%>', '<%= rs.getString(5)%>', '<%= rs.getString(6)%>, '<%= rs.getString(7)%>', '<%= rs.getString(8)%>', '<%= rs.getString(9)%>')"></i>
        <!-- Icono de eliminar -->
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getInt(1)%>')"></i>
    </td>
</tr>
<%
    }
%>
<%
                        }
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger' role='alert'>Error PSQL: " + e.getMessage() + "</div>");
                }
            }
        } catch (Exception e) {
            out.println("<div class='alert alert-danger' role='alert'>Error al procesar la solicitud: " + e.getMessage() + "</div>");
        }
    }
%>