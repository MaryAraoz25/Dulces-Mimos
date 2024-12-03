<%@ include file="conexion.jsp" %>

<%    // Obtener el parámetro de acción
    String action = request.getParameter("listar");

    if (action != null) {
        // Listar todos los clientes
        if (action.equals("listar")) {
            try {
                String query = "SELECT c.idclientes, c.cli_nombre, c.cli_apellido, c.cli_direccion, c.cli_cedula, c.cli_telefono, c.cli_ruc " +
               "FROM clientes c " +
               "ORDER BY c.idclientes ASC";

                try (PreparedStatement pst = conn.prepareStatement(query);
                        ResultSet rs = pst.executeQuery()) {
                    while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getInt(1)%></td>
    <td><%= rs.getString(2)%></td>
    <td><%= rs.getString(3)%></td>
    <td><%= rs.getString(4)%></td>
    <td><%= rs.getString(5)%></td>
    <td><%= rs.getString(6)%></td>
    <td><%= rs.getString(7)%></td>
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoClientesEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <!-- Icono de editar -->
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" onclick="rellenarjs('<%= rs.getInt(1)%>', '<%= rs.getString(2)%>', '<%= rs.getString(3)%>', '<%= rs.getString(4)%>', '<%= rs.getString(5)%>', '<%= rs.getString(6)%>', '<%= rs.getString(7)%>')"></i>
        <!-- Icono de eliminar -->
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getInt("idclientes")%>')"></i>
    </td>
</tr>
<%
            }
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error al listar clientes: " + e.getMessage() + "</div>");
    }
} // Cargar nuevo cliente
else if (action.equals("cargar")) {
    String cli_nombre = request.getParameter("cli_nombre");
    String cli_apellido = request.getParameter("cli_apellido");
    String cli_direccion = request.getParameter("cli_direccion");
    String cli_ci = request.getParameter("cli_ci");
    String cli_telefono = request.getParameter("cli_telefono");
    String cli_ruc = request.getParameter("cli_ruc");

    // Capitalizar las primeras letras
    if (cli_nombre != null && !cli_nombre.isEmpty()) {
        cli_nombre = Character.toUpperCase(cli_nombre.charAt(0)) + cli_nombre.substring(1).toLowerCase();
    }
    if (cli_apellido != null && !cli_apellido.isEmpty()) {
        cli_apellido = Character.toUpperCase(cli_apellido.charAt(0)) + cli_apellido.substring(1).toLowerCase();
    }
    if (cli_direccion != null && !cli_direccion.isEmpty()) {
        cli_direccion = Character.toUpperCase(cli_direccion.charAt(0)) + cli_direccion.substring(1).toLowerCase();
    }

    try {
        String query = "SELECT COUNT(*) FROM clientes WHERE LOWER(cli_cedula) = LOWER(?) OR LOWER(cli_telefono) = LOWER(?)";
        try (PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, cli_ci);
            pst.setString(2, cli_telefono);
            try (ResultSet rs = pst.executeQuery()) {
                rs.next();
                int count = rs.getInt(1);

                if (count > 0) {
                    out.println("<div class='alert alert-danger' role='alert'>El cliente ya existe.</div>");
                } else {
                    // Insertar el nuevo cliente
                    query = "INSERT INTO clientes (cli_nombre, cli_apellido, cli_direccion, cli_cedula, cli_telefono, cli_ruc) VALUES (?, ?, ?, ?, ?, ?)";
                    try (PreparedStatement pstInsert = conn.prepareStatement(query)) {
                        pstInsert.setString(1, cli_nombre);
                        pstInsert.setString(2, cli_apellido);
                        pstInsert.setString(3, cli_direccion);
                        pstInsert.setString(4, cli_ci);
                        pstInsert.setString(5, cli_telefono);
                        pstInsert.setString(6, cli_ruc);
                        pstInsert.executeUpdate();
                        out.println("<div class='alert alert-success' role='alert'>Cliente Insertado Correctamente</div>");
                    }
                }
            }
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error al insertar cliente: " + e.getMessage() + "</div>");
    }
} // Modificar cliente
else if (action.equals("modificar")) {
    String idclientesStr = request.getParameter("idclientes"); // Obtenemos el valor como String
    int idclientes = Integer.parseInt(idclientesStr); // Convertimos a int

    String cli_nombre = request.getParameter("cli_nombre");
    String cli_apellido = request.getParameter("cli_apellido");
    String cli_direccion = request.getParameter("cli_direccion");
    String cli_ci = request.getParameter("cli_ci");
    String cli_telefono = request.getParameter("cli_telefono");
    String cli_ruc = request.getParameter("cli_ruc");

    // Capitalizar las primeras letras
    if (cli_nombre != null && !cli_nombre.isEmpty()) {
        cli_nombre = Character.toUpperCase(cli_nombre.charAt(0)) + cli_nombre.substring(1).toLowerCase();
    }
    if (cli_apellido != null && !cli_apellido.isEmpty()) {
        cli_apellido = Character.toUpperCase(cli_apellido.charAt(0)) + cli_apellido.substring(1).toLowerCase();
    }
    if (cli_direccion != null && !cli_direccion.isEmpty()) {
        cli_direccion = Character.toUpperCase(cli_direccion.charAt(0)) + cli_direccion.substring(1).toLowerCase();
    }

    try {
        String query = "SELECT COUNT(*) FROM clientes WHERE (LOWER(cli_cedula) = LOWER(?) OR LOWER(cli_telefono) = LOWER(?)) AND idclientes != ?";
        try (PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, cli_ci);
            pst.setString(2, cli_telefono);
            pst.setInt(3, idclientes); // Cambiamos setString a setInt
            try (ResultSet rs = pst.executeQuery()) {
                rs.next();
                int count = rs.getInt(1);

                if (count > 0) {
                    out.println("<div class='alert alert-danger' role='alert'>El cliente ya existe.</div>");
                } else {
                    // Actualizar el cliente
                    query = "UPDATE clientes SET cli_nombre = ?, cli_apellido = ?, cli_direccion = ?, cli_cedula = ?, cli_telefono = ?, cli_ruc = ? WHERE idclientes = ?";
                    try (PreparedStatement pstUpdate = conn.prepareStatement(query)) {
                        pstUpdate.setString(1, cli_nombre);
                        pstUpdate.setString(2, cli_apellido);
                        pstUpdate.setString(3, cli_direccion);
                        pstUpdate.setString(4, cli_ci);
                        pstUpdate.setString(5, cli_telefono);
                        pstUpdate.setString(6, cli_ruc);
                        pstUpdate.setInt(7, idclientes); // Cambiamos setString a setInt
                        pstUpdate.executeUpdate();
                        out.println("<div class='alert alert-success' role='alert'>Cliente Modificado Correctamente</div>");
                    }
                }
            }
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error al modificar cliente: " + e.getMessage() + "</div>");
    }
} else if (action.equals("eliminar")) {
    String id_deleteStr = request.getParameter("id_delete"); // Obtenemos el valor como String
    int id_delete = Integer.parseInt(id_deleteStr); // Convertimos a int

    try {
        String query = "DELETE FROM clientes WHERE idclientes = ?";
        try (PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, id_delete); // Cambiamos setString a setInt
            pst.executeUpdate();
            out.println("<div class='alert alert-success' role='alert'>Cliente Eliminado Correctamente</div>");
        }
    } catch (SQLException e) {
        if (e.getSQLState().equals("23503")) {
            out.println("<div class='alert alert-danger' role='alert'>El cliente está siendo utilizado y no puede ser eliminado</div>");
        } else {
            out.println("<div class='alert alert-danger' role='alert'>Error al eliminar cliente: " + e.getMessage() + "</div>");
        }
    }
} /*else if (action.equals("cargarUsuarios")) {
    try {
        String query = "SELECT * FROM usuarios u "
                + "JOIN rol r ON u.rol_idrol = r.id_rol "
                + "WHERE r.rol_nombre = 'Cliente'";
        try (PreparedStatement pst = conn.prepareStatement(query);
                ResultSet rs = pst.executeQuery()) {
            out.print("<option value='selectusu'>Seleccione un Usuario</option>");
            while (rs.next()) {
                out.print("<option value='" + rs.getInt("idusuarios") + "'>" + rs.getString("usu_nombre") + "</option>");
            }
        }
    } catch (Exception e) {
        out.println("<option value=''>Error al cargar usuarios</option>");
    }
}*/
else if (action.equals("buscador")) {
    String buscador = request.getParameter("buscador");
    if (buscador != null) {
        buscador = buscador.trim().toLowerCase();
        try {
            String query = "SELECT c.idclientes, c.cli_nombre, c.cli_apellido, c.cli_direccion, c.cli_cedula, c.cli_telefono, c.cli_ruc " +
               "FROM clientes c " +
               "WHERE LOWER(c.cli_nombre) LIKE ? OR LOWER(c.cli_cedula) LIKE ? " +
               "ORDER BY c.idclientes ASC";
            try (PreparedStatement pst = conn.prepareStatement(query)) {
                pst.setString(1, buscador + "%");
                pst.setString(2, buscador + "%");
                try (ResultSet rs = pst.executeQuery()) {
                    while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getInt(1)%></td>
    <td><%= rs.getString(2)%></td>
    <td><%= rs.getString(3)%></td>
    <td><%= rs.getString(4)%></td>
    <td><%= rs.getString(5)%></td>
    <td><%= rs.getString(6)%></td>
    <td><%= rs.getString(7)%></td>
    
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoClientesEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <!-- Icono de editar -->
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" onclick="rellenarjs('<%= rs.getInt(1)%>', '<%= rs.getString(2)%>', '<%= rs.getString(3)%>', '<%= rs.getString(4)%>', '<%= rs.getString(5)%>', '<%= rs.getString(6)%>', '<%= rs.getString(7)%>')"></i>
        <!-- Icono de eliminar -->
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getInt("idclientes")%>')"></i>
    </td>
</tr>
<%
                            }
                        }
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger' role='alert'>Error al buscar clientes: " + e.getMessage() + "</div>");
                }
            }
        }
    }
%>
