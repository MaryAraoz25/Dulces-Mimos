
<%@ include file="conexion.jsp" %>

<%
    if (request.getParameter("listar") != null) {
        String listar = request.getParameter("listar");

        if (listar.equals("listar")) {
            // Listar empleados
            try {
                String query = "SELECT e.idempleados, e.emple_nombre, e.emple_apellido, e.emple_ci, e.emple_direccion, e.emple_estado, e.emple_telefono, e.emple_correo, u.idusuarios, u.usu_nombre "
             + "FROM empleados e "
             + "INNER JOIN usuarios u ON e.usuarios_id = u.idusuarios "
             + "ORDER BY e.idempleados ASC";
                try (PreparedStatement pst = conn.prepareStatement(query);
                     ResultSet rs = pst.executeQuery()) {

                    while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getInt(1) %></td>
    <td><%= rs.getString(2) %></td>
    <td><%= rs.getString(3) %></td>
    <td><%= rs.getString(4) %></td>
    <td><%= rs.getString(5) %></td>
    <td><%= rs.getString(6) %></td>
    <td><%= rs.getString(7) %></td>
    <td><%= rs.getString(8) %></td>
    <td><%= rs.getString(10) %></td>
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoEmpleadosEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <!-- Icono de editar -->
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;"
           onclick="rellenarjs('<%= rs.getInt(1)%>', '<%= rs.getString(2)%>', '<%= rs.getString(3)%>', '<%= rs.getString(4)%>', '<%= rs.getString(5)%>', '<%= rs.getString(6)%>', '<%= rs.getString(7)%>', '<%= rs.getString(8)%>', '<%= rs.getString(9)%>')">
        </i>
        <!-- Icono de eliminar -->
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getInt(1)%>')"></i>
    </td>
</tr>
<%
                    }
                }
            } catch (Exception e) {
                out.println("Error al listar empleados: " + e);
            }
        } else if (listar.equals("cargar")) {
            // Cargar empleados
            String emple_nombre = request.getParameter("emple_nombre");
            String emple_apellido = request.getParameter("emple_apellido");
            String emple_ci = request.getParameter("emple_ci");
            String emple_direccion = request.getParameter("emple_direccion");
            String emple_estado = request.getParameter("emple_estado");
            String emple_telefono = request.getParameter("emple_telefono");
            String emple_correo = request.getParameter("emple_correo");
            int usuarios_id = Integer.parseInt(request.getParameter("usuarios_id"));

            // Capitalizar nombres y direcciones
            if (!emple_nombre.isEmpty() || !emple_apellido.isEmpty() || !emple_direccion.isEmpty()) {
                emple_nombre = Character.toUpperCase(emple_nombre.charAt(0)) + emple_nombre.substring(1).toLowerCase();
                emple_apellido = Character.toUpperCase(emple_apellido.charAt(0)) + emple_apellido.substring(1).toLowerCase();
                emple_direccion = Character.toUpperCase(emple_direccion.charAt(0)) + emple_direccion.substring(1).toLowerCase();
            }

            try {
                // Verificar si el empleado ya existe
                String queryCheck = "SELECT COUNT(*) FROM empleados WHERE LOWER(emple_ci) = LOWER(?) OR LOWER(emple_correo) = LOWER(?) OR emple_telefono = ?";
                try (PreparedStatement pstCheck = conn.prepareStatement(queryCheck)) {
                    pstCheck.setString(1, emple_ci);
                    pstCheck.setString(2, emple_correo);
                    pstCheck.setString(3, emple_telefono);
                    ResultSet rsCheck = pstCheck.executeQuery();
                    rsCheck.next();
                    int count = rsCheck.getInt(1);

                    if (count > 0) {
                        out.println("<div class='alert alert-danger' role='alert'>El empleado ya existe.</div>");
                    } else {
                        // Verificar si el usuario ya está asociado a otro empleado
                        String queryUser = "SELECT COUNT(*) FROM empleados WHERE usuarios_id = ?";
                        try (PreparedStatement pstUser = conn.prepareStatement(queryUser)) {
                            pstUser.setInt(1, usuarios_id);
                            ResultSet rsUser = pstUser.executeQuery();
                            rsUser.next();
                            int userCount = rsUser.getInt(1);

                            if (userCount > 0) {
                                out.println("<div class='alert alert-danger' role='alert'>El usuario seleccionado ya está asociado a otro empleado.</div>");
                            } else {
                                // Insertar el nuevo empleado
                                String queryInsert = "INSERT INTO empleados (emple_nombre, emple_apellido, emple_ci, emple_direccion, emple_estado, emple_telefono, emple_correo, usuarios_id) "
                                                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                                try (PreparedStatement pstInsert = conn.prepareStatement(queryInsert)) {
                                    pstInsert.setString(1, emple_nombre);
                                    pstInsert.setString(2, emple_apellido);
                                    pstInsert.setString(3, emple_ci);
                                    pstInsert.setString(4, emple_direccion);
                                    pstInsert.setString(5, emple_estado);
                                    pstInsert.setString(6, emple_telefono);
                                    pstInsert.setString(7, emple_correo);
                                    pstInsert.setInt(8, usuarios_id);
                                    pstInsert.executeUpdate();
                                    out.println("<div class='alert alert-success' role='alert'>Empleado Insertado Correctamente</div>");
                                }
                            }
                        }
                    }
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger' role='alert'>Error al insertar empleado: " + e + "</div>");
            }
        } else if (listar.equals("modificar")) {
            // Modificar empleado
            String idempleados = request.getParameter("idempleados");
            String emple_nombre = request.getParameter("emple_nombre");
            String emple_apellido = request.getParameter("emple_apellido");
            String emple_ci = request.getParameter("emple_ci");
            String emple_direccion = request.getParameter("emple_direccion");
            String emple_estado = request.getParameter("emple_estado");
            String emple_telefono = request.getParameter("emple_telefono");
            String emple_correo = request.getParameter("emple_correo");
            int usuarios_id = Integer.parseInt(request.getParameter("usuarios_id"));

            // Capitalizar nombres y direcciones
            if (!emple_nombre.isEmpty() || !emple_apellido.isEmpty() || !emple_direccion.isEmpty()) {
                emple_nombre = Character.toUpperCase(emple_nombre.charAt(0)) + emple_nombre.substring(1).toLowerCase();
                emple_apellido = Character.toUpperCase(emple_apellido.charAt(0)) + emple_apellido.substring(1).toLowerCase();
                emple_direccion = Character.toUpperCase(emple_direccion.charAt(0)) + emple_direccion.substring(1).toLowerCase();
            }

            try {
                // Verificar si el empleado ya existe
                String queryCheck = "SELECT COUNT(*) FROM empleados WHERE (LOWER(emple_ci) = LOWER(?) OR LOWER(emple_correo) = LOWER(?) OR emple_telefono = ?) AND idempleados != ?";
                try (PreparedStatement pstCheck = conn.prepareStatement(queryCheck)) {
                    pstCheck.setString(1, emple_ci);
                    pstCheck.setString(2, emple_correo);
                    pstCheck.setString(3, emple_telefono);
                    pstCheck.setInt(4, Integer.parseInt(idempleados));
                    ResultSet rsCheck = pstCheck.executeQuery();
                    rsCheck.next();
                    int count = rsCheck.getInt(1);

                    if (count > 0) {
                        out.println("<div class='alert alert-danger' role='alert'>El empleado ya existe.</div>");
                    } else {
                        // Verificar si el usuario ya está asociado a otro empleado
                        String queryUser = "SELECT COUNT(*) FROM empleados WHERE usuarios_id = ? AND idempleados != ?";
                        try (PreparedStatement pstUser = conn.prepareStatement(queryUser)) {
                            pstUser.setInt(1, usuarios_id);
                            pstUser.setInt(2, Integer.parseInt(idempleados));
                            ResultSet rsUser = pstUser.executeQuery();
                            rsUser.next();
                            int userCount = rsUser.getInt(1);

                            if (userCount > 0) {
                                out.println("<div class='alert alert-danger' role='alert'>El usuario seleccionado ya está asociado a otro empleado.</div>");
                            } else {
                                // Modificar el empleado
                                String queryUpdate = "UPDATE empleados SET emple_nombre = ?, emple_apellido = ?, emple_ci = ?, emple_direccion = ?, emple_estado = ?, emple_telefono = ?, emple_correo = ?, usuarios_id = ? "
                                                   + "WHERE idempleados = ?";
                                try (PreparedStatement pstUpdate = conn.prepareStatement(queryUpdate)) {
                                    pstUpdate.setString(1, emple_nombre);
                                    pstUpdate.setString(2, emple_apellido);
                                    pstUpdate.setString(3, emple_ci);
                                    pstUpdate.setString(4, emple_direccion);
                                    pstUpdate.setString(5, emple_estado);
                                    pstUpdate.setString(6, emple_telefono);
                                    pstUpdate.setString(7, emple_correo);
                                    pstUpdate.setInt(8, usuarios_id);
                                    pstUpdate.setInt(9, Integer.parseInt(idempleados));
                                    pstUpdate.executeUpdate();
                                    out.println("<div class='alert alert-success' role='alert'>Empleado Modificado Correctamente</div>");
                                }
                            }
                        }
                    }
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger' role='alert'>Error al modificar empleado: " + e + "</div>");
            }
        } else if (listar.equals("eliminar")) {
            // Eliminar empleado
            String id_delete = request.getParameter("id_delete");

            try {
                String queryDelete = "DELETE FROM empleados WHERE idempleados = ?";
                try (PreparedStatement pstDelete = conn.prepareStatement(queryDelete)) {
                    pstDelete.setInt(1, Integer.parseInt(id_delete));
                    pstDelete.executeUpdate();
                    out.println("<div class='alert alert-success' role='alert'>Empleado Eliminado Correctamente</div>");
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger' role='alert'>Error al eliminar empleado: " + e + "</div>");
            }
        }else if (listar.equals("cargarUsuarios")) {
            // Cargar usuarios
            try {
                String query = "SELECT u.idusuarios, u.usu_nombre " +
               "FROM usuarios u " +
               "JOIN rol r ON u.rol_idrol = r.id_rol " +
               "WHERE r.rol_nombre <> 'Cliente' " +
               "ORDER BY u.usu_nombre ASC";
                try (PreparedStatement pst = conn.prepareStatement(query);
                     ResultSet rs = pst.executeQuery()) {
%>
<option value="">Seleccione un Usuario</option>
<%                     
                    while (rs.next()) {
%>
<option value="<%= rs.getString(1) %>"><%= rs.getString(2) %></option>
<%
                    }
                }
            } catch (Exception e) {
                out.println("Error al cargar usuarios: " + e);
            }
        } else if (listar.equals("buscador")) {
            // Buscador de empleados
            String buscador = request.getParameter("buscador").trim().toLowerCase();
            try {
                String query = "SELECT e.idempleados, e.emple_nombre, e.emple_apellido, e.emple_ci, e.emple_direccion, e.emple_estado, e.emple_telefono, e.emple_correo, u.idusuarios, u.usu_nombre "
             + "FROM empleados e "
             + "INNER JOIN usuarios u ON e.usuarios_id = u.idusuarios "
             + "WHERE LOWER(e.emple_nombre) LIKE LOWER(?) OR LOWER(e.emple_apellido) LIKE LOWER(?) OR LOWER(e.emple_ci) LIKE LOWER(?) OR LOWER(e.emple_direccion) LIKE LOWER(?) OR LOWER(e.emple_estado) LIKE LOWER(?) OR LOWER(e.emple_telefono) LIKE LOWER(?) OR LOWER(e.emple_correo) LIKE LOWER(?) OR LOWER(u.usu_nombre) LIKE LOWER(?) "
             + "ORDER BY e.idempleados ASC";
                try (PreparedStatement pst = conn.prepareStatement(query)) {
                    for (int i = 1; i <= 8; i++) {
                        pst.setString(i, "" + buscador + "%");
                    }
                    try (ResultSet rs = pst.executeQuery()) {
                        while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getInt(1) %></td>
    <td><%= rs.getString(2) %></td>
    <td><%= rs.getString(3) %></td>
    <td><%= rs.getString(4) %></td>
    <td><%= rs.getString(5) %></td>
    <td><%= rs.getString(6) %></td>
    <td><%= rs.getString(7) %></td>
    <td><%= rs.getString(8) %></td>
    <td><%= rs.getString(10) %></td>
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoEmpleadosEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" onclick="rellenarjs('<%= rs.getInt(1) %>', '<%= rs.getString(2) %>', '<%= rs.getString(3) %>', '<%= rs.getString(4) %>', '<%= rs.getString(5) %>', '<%= rs.getString(6) %>', '<%= rs.getString(7) %>', '<%= rs.getString(8) %>', '<%= rs.getString(9) %>')"></i>
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getInt(1) %>')"></i>
    </td>
</tr>
<%
                        }
                    }
                }
            } catch (Exception e) {
                out.println("Error al buscar empleados: " + e);
            }
        }
    }
%>
