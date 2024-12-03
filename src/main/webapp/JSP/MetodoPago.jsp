<%@ include file="conexion.jsp" %>

<%
 
    try {
        // Inicializa la conexión (asegúrate de que esto esté en su lugar)
       
        
        String listar = request.getParameter("listar");
        if (listar != null) {
            if (listar.equals("listar")) {
                try {
                    String query = "SELECT idmetodos_pago, metpag_nombre FROM metodos_pago ORDER BY idmetodos_pago ASC";
                    try (PreparedStatement pst = conn.prepareStatement(query);
                         ResultSet rs = pst.executeQuery()) {

                        while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getInt(1) %></td>
    <td><%= rs.getString(2) %></td>
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoMetPagosEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" onclick="rellenarjs('<%= rs.getInt(1) %>', '<%= rs.getString(2) %>')"></i>
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getInt(1) %>')"></i>
    </td>
</tr>
<%
                        }
                    }
                } catch (Exception e) {
                    out.print("Error al listar métodos de pago: " + e);
                }
            } else if (listar.equals("cargar")) {
                String metpag_nombre = request.getParameter("metpag_nombre");
                if (metpag_nombre != null && !metpag_nombre.isEmpty()) {
                    metpag_nombre = Character.toUpperCase(metpag_nombre.charAt(0)) + metpag_nombre.substring(1).toLowerCase();
                }
                try {
                    String checkQuery = "SELECT COUNT(*) FROM metodos_pago WHERE LOWER(metpag_nombre) = LOWER(?)";
                    try (PreparedStatement checkPst = conn.prepareStatement(checkQuery)) {
                        checkPst.setString(1, metpag_nombre);
                        ResultSet rs = checkPst.executeQuery();
                        rs.next();
                        int count = rs.getInt(1);
                        if (count > 0) {
                            out.println("<div class='alert alert-danger' role='alert'>El método de pago ya existe. Ingrese otro método de pago.</div>");
                        } else {
                            String insertQuery = "INSERT INTO metodos_pago (metpag_nombre) VALUES (?)";
                            try (PreparedStatement insertPst = conn.prepareStatement(insertQuery)) {
                                insertPst.setString(1, metpag_nombre);
                                insertPst.executeUpdate();
                                out.println("<div class='alert alert-success' role='alert'>Método de pago Insertado Correctamente</div>");
                            }
                        }
                        rs.close();
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger' role='alert'>Error al insertar método de pago: " + e + "</div>");
                }
            } else if (listar.equals("modificar")) {
                String idmetodos_pago = request.getParameter("idmetodos_pago");
                String metpag_nombre = request.getParameter("metpag_nombre");
                if (metpag_nombre != null && !metpag_nombre.isEmpty()) {
                    metpag_nombre = Character.toUpperCase(metpag_nombre.charAt(0)) + metpag_nombre.substring(1).toLowerCase();
                }
                try {
                    String checkQuery = "SELECT COUNT(*) FROM metodos_pago WHERE LOWER(metpag_nombre) = LOWER(?) AND idmetodos_pago != ?";
                    try (PreparedStatement checkPst = conn.prepareStatement(checkQuery)) {
                        checkPst.setString(1, metpag_nombre);
                        checkPst.setInt(2, Integer.parseInt(idmetodos_pago));
                        ResultSet rs = checkPst.executeQuery();
                        rs.next();
                        int count = rs.getInt(1);
                        if (count > 0) {
                            out.println("<div class='alert alert-danger' role='alert'>El método de pago ya existe. Ingrese otro método de pago.</div>");
                        } else {
                            String updateQuery = "UPDATE metodos_pago SET metpag_nombre = ? WHERE idmetodos_pago = ?";
                            try (PreparedStatement updatePst = conn.prepareStatement(updateQuery)) {
                                updatePst.setString(1, metpag_nombre);
                                updatePst.setInt(2, Integer.parseInt(idmetodos_pago));
                                updatePst.executeUpdate();
                                out.println("<div class='alert alert-success' role='alert'>Método de pago Modificado Correctamente</div>");
                            }
                        }
                        rs.close();
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger' role='alert'>Error al modificar método de pago: " + e + "</div>");
                }
            } else if (listar.equals("eliminar")) {
                String id_delete = request.getParameter("id_delete");
                try {
                    String deleteQuery = "DELETE FROM metodos_pago WHERE idmetodos_pago = ?";
                    try (PreparedStatement deletePst = conn.prepareStatement(deleteQuery)) {
                        deletePst.setInt(1, Integer.parseInt(id_delete));
                        deletePst.executeUpdate();
                        out.println("<div class='alert alert-success' role='alert'>Método de pago Eliminado Correctamente</div>");
                    }
                } catch (SQLException e) {
                    if (e.getSQLState().equals("23503")) {
                        out.println("<div class='alert alert-danger' role='alert'>El método de pago está siendo utilizado y no se puede eliminar</div>");
                    } else {
                        out.println("<div class='alert alert-danger' role='alert'>Error PSQL: " + e + "</div>");
                    }
                }
            } else if (listar.equals("buscador")) {
                String buscador = request.getParameter("buscador").trim().toLowerCase();
                try {
                    String searchQuery = "SELECT idmetodos_pago, metpag_nombre FROM metodos_pago WHERE LOWER(metpag_nombre) LIKE ? ORDER BY idmetodos_pago ASC";
                    try (PreparedStatement searchPst = conn.prepareStatement(searchQuery)) {
                        searchPst.setString(1, buscador + "%");
                        try (ResultSet rs = searchPst.executeQuery()) {
                            while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getInt(1) %></td>
    <td><%= rs.getString(2) %></td>
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoMetPagosEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" onclick="rellenarjs('<%= rs.getInt(1) %>', '<%= rs.getString(2) %>')"></i>
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getInt(1) %>')"></i>
    </td>
</tr>
<%
                            }
                        }
                    }
                } catch (Exception e) {
                    out.println("Error al buscar métodos de pago: " + e);
                }
            }
        }
    } catch (Exception e) {
        out.print("Error al manejar la conexión: " + e);
    } finally {
        // Cierra la conexión en el bloque finally
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                out.println("Error cerrando la conexión: " + e);
            }
        }
    }
%>
