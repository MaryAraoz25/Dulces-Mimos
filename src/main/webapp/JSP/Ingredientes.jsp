<%@ include file="conexion.jsp" %>

<%    String listar = request.getParameter("listar");

    if (listar != null) {
        if (listar.equals("listar")) {
            try {
                String sql = "SELECT i.idingredientes, i.ingre_nombre, i.ingre_stock, i.ingre_stockmin, u.idunidad_medida, u.descripcion, i.impuesto "
                        + "FROM ingredientes i "
                        + "JOIN unidad_medida u ON i.unidad_de_medida_id = u.idunidad_medida "
                        + "ORDER BY i.idingredientes ASC";
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getInt(1)%></td> <!-- idingredientes -->
    <td><%= rs.getString(2)%></td> <!-- ingre_nombre -->
    <td><%= rs.getInt(3)%></td> <!-- ingre_stock -->
    <td><%= rs.getInt(4)%></td> <!-- ingre_stockmin -->
    <td><%= rs.getString(6)%></td> <!-- u.descripcion (nombre de unidad de medida) -->
    <td><%= rs.getString(7)%></td> <!-- impuesto -->
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoIngredientesEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;"
           onclick="rellenarjs('<%= rs.getInt(1)%>', '<%= rs.getString(2)%>', '<%= rs.getInt(3)%>', '<%= rs.getInt(4)%>', '<%= rs.getString(5)%>', '<%= rs.getString(7)%>')"></i>
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;"
           data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getInt(1)%>')"></i>
    </td>
</tr>
<%
        }
        rs.close();
        ps.close();
    } catch (Exception e) {
        out.print("Error al listar ingredientes: " + e);
    }
} else if (listar.equals("cargar")) {
    String ingre_nombre = request.getParameter("ingre_nombre");
    int ingre_stock = Integer.parseInt(request.getParameter("ingre_stock"));
    int ingre_stockmin = Integer.parseInt(request.getParameter("ingre_stockmin"));
    int unidad_de_medida_id = Integer.parseInt(request.getParameter("unidad_de_medida_id"));
    String impuesto = request.getParameter("impuesto");

    if (!ingre_nombre.isEmpty()) {
        ingre_nombre = Character.toUpperCase(ingre_nombre.charAt(0)) + ingre_nombre.substring(1).toLowerCase();
    }

    try {
        String sqlCheck = "SELECT COUNT(*) FROM ingredientes WHERE LOWER(ingre_nombre) = LOWER(?)";
        PreparedStatement psCheck = conn.prepareStatement(sqlCheck);
        psCheck.setString(1, ingre_nombre);
        ResultSet rs = psCheck.executeQuery();
        rs.next();
        int count = rs.getInt(1);

        if (count > 0) {
            out.println("<div class='alert alert-danger' role='alert'>El ingrediente ya existe. Ingrese otro ingrediente.</div>");
        } else {
            String sqlInsert = "INSERT INTO ingredientes (ingre_nombre, ingre_stock, ingre_stockmin, unidad_de_medida_id, impuesto) "
                    + "VALUES (?, ?, ?, ?, ?)";
            PreparedStatement psInsert = conn.prepareStatement(sqlInsert);
            psInsert.setString(1, ingre_nombre);
            psInsert.setInt(2, ingre_stock);
            psInsert.setInt(3, ingre_stockmin);
            psInsert.setInt(4, unidad_de_medida_id);
            psInsert.setString(5, impuesto);
            psInsert.executeUpdate();
            out.println("<div class='alert alert-success' role='alert'>Ingrediente Insertado Correctamente</div>");
            psInsert.close();
        }
        rs.close();
        psCheck.close();
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error al insertar ingrediente: " + e + "</div>");
    }
} else if (listar.equals("modificar")) {
    String idingredientes = request.getParameter("idingredientes");
    String ingre_nombre = request.getParameter("ingre_nombre");
    int ingre_stock = Integer.parseInt(request.getParameter("ingre_stock"));
    int ingre_stockmin = Integer.parseInt(request.getParameter("ingre_stockmin"));
    int unidad_de_medida_id = Integer.parseInt(request.getParameter("unidad_de_medida_id"));
    String impuesto = request.getParameter("impuesto");

    if (!ingre_nombre.isEmpty()) {
        ingre_nombre = Character.toUpperCase(ingre_nombre.charAt(0)) + ingre_nombre.substring(1).toLowerCase();
    }

    try {
        String sqlCheck = "SELECT COUNT(*) FROM ingredientes WHERE LOWER(ingre_nombre) = LOWER(?) AND idingredientes <> ?";
        PreparedStatement psCheck = conn.prepareStatement(sqlCheck);
        psCheck.setString(1, ingre_nombre);
        psCheck.setInt(2, Integer.parseInt(idingredientes));
        ResultSet rs = psCheck.executeQuery();
        rs.next();
        int count = rs.getInt(1);

        if (count > 0) {
            out.println("<div class='alert alert-danger' role='alert'>El ingrediente ya existe. No se pueden modificar los datos.</div>");
        } else {
            String sqlUpdate = "UPDATE ingredientes SET ingre_nombre = ?, ingre_stock = ?, ingre_stockmin = ?, unidad_de_medida_id = ?, impuesto = ? WHERE idingredientes = ?";
            PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
            psUpdate.setString(1, ingre_nombre);
            psUpdate.setInt(2, ingre_stock);
            psUpdate.setInt(3, ingre_stockmin);
            psUpdate.setInt(4, unidad_de_medida_id);
            psUpdate.setString(5, impuesto);
            psUpdate.setInt(6, Integer.parseInt(idingredientes));
            psUpdate.executeUpdate();
            out.println("<div class='alert alert-success' role='alert'>Ingrediente Modificado Correctamente</div>");
            psUpdate.close();
        }
        rs.close();
        psCheck.close();
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error al modificar ingrediente: " + e + "</div>");
    }
} else if (listar.equals("eliminar")) {
    String id_delete = request.getParameter("id_delete");

    try {
        String sqlDelete = "DELETE FROM ingredientes WHERE idingredientes = ?";
        PreparedStatement psDelete = conn.prepareStatement(sqlDelete);
        psDelete.setInt(1, Integer.parseInt(id_delete));
        psDelete.executeUpdate();
        out.println("<div class='alert alert-success' role='alert'>Ingrediente Eliminado Correctamente</div>");
        psDelete.close();
    } catch (SQLException e) {
        if (e.getSQLState().equals("23503")) { // Violación de restricción de clave externa
            out.println("<div class='alert alert-danger' role='alert'>El ingrediente está siendo utilizado y no puede ser eliminado</div>");
        } else {
            out.println("<div class='alert alert-danger' role='alert'>Error al eliminar ingrediente: " + e.getMessage() + "</div>");
        }
    }
} else if (listar.equals("cargarUnidades")) {
    try {
        String sqlLoadUnits = "SELECT idunidad_medida, descripcion FROM unidad_medida";
        PreparedStatement psLoadUnits = conn.prepareStatement(sqlLoadUnits);
        ResultSet rs = psLoadUnits.executeQuery();
        out.print("<option value=''>Seleccione una Unidad de Medida</option>");
        while (rs.next()) {
            out.print("<option value='" + rs.getInt(1) + "'>" + rs.getString(2) + "</option>");
        }
        rs.close();
        psLoadUnits.close();
    } catch (Exception e) {
        out.println("<option value=''>Error al cargar unidades de medida</option>");
    }
} else if (listar.equals("cargarProveedores")) {
    try {
        String sqlLoadProviders = "SELECT idproveedores, prov_nombre FROM proveedores";
        PreparedStatement psLoadProviders = conn.prepareStatement(sqlLoadProviders);
        ResultSet rs = psLoadProviders.executeQuery();
        out.print("<option value=''>Seleccione un Proveedor</option>");
        while (rs.next()) {
            out.print("<option value='" + rs.getInt(1) + "'>" + rs.getString(2) + "</option>");
        }
        rs.close();
        psLoadProviders.close();
    } catch (Exception e) {
        out.println("<option value=''>Error al cargar proveedores</option>");
    }
} else if (listar.equals("buscador")) {
    // Código para buscar ingredientes
    String buscador = request.getParameter("buscador").trim().toLowerCase();
    try {
        String sql = "SELECT i.idingredientes, i.ingre_nombre, i.ingre_stock, i.ingre_stockmin, u.idunidad_medida, u.descripcion, i.impuesto "
                + "FROM ingredientes i "
                + "JOIN unidad_medida u ON i.unidad_de_medida_id = u.idunidad_medida "
                + "WHERE LOWER(i.ingre_nombre) LIKE ? "
                + "ORDER BY i.idingredientes ASC";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, buscador + "%");
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getInt(1)%></td> <!-- idingredientes -->
    <td><%= rs.getString(2)%></td> <!-- ingre_nombre -->
    <td><%= rs.getInt(3)%></td> <!-- ingre_stock -->
    <td><%= rs.getInt(4)%></td> <!-- ingre_stockmin -->
    <td><%= rs.getString(6)%></td> <!-- u.descripcion (nombre de unidad de medida) -->
    <td><%= rs.getString(7)%></td> <!-- impuesto -->
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoIngredientesEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;"
           onclick="rellenarjs('<%= rs.getInt(1)%>', '<%= rs.getString(2)%>', '<%= rs.getInt(3)%>', '<%= rs.getInt(4)%>', '<%= rs.getString(5)%>', '<%= rs.getString(7)%>')"></i>
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;"
           data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getInt(1)%>')"></i>
    </td>
</tr>
<%
                }
                rs.close();
                ps.close();
            } catch (Exception e) {
                out.print("Error al buscar ingredientes: " + e);
            }
        }
    }
%>