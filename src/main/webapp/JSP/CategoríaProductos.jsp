<%@ include file="conexion.jsp" %>

<%
    // Inicializa variables para el PreparedStatement y ResultSet
    PreparedStatement pst = null;
    ResultSet rs = null;

    if (request.getParameter("listar") != null) {
        if (request.getParameter("listar").equals("listar")) {
            try {
                pst = conn.prepareStatement("SELECT * FROM categ_productos ORDER BY idcateg_productos ASC");
                rs = pst.executeQuery();
%>
<%
    while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getString(1)%></td>
    <td><%= rs.getString(2)%></td>
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoCategoriasEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <!-- Icono de editar -->
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" onclick="rellenarjs('<%= rs.getString(1)%>', '<%= rs.getString(2)%>')"></i>
        <!-- Icono de eliminar -->
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getString(1)%>')"></i>
    </td>                
</tr>
<%
        }
        // Cierra ResultSet y PreparedStatement
        rs.close();
        pst.close();
    } catch (Exception e) {
        out.print("Error PSQL: " + e);
    }

} else if (request.getParameter("listar").equals("cargar")) {
    String categ_nombre = request.getParameter("categ_nombre");
    if (!categ_nombre.isEmpty()) {
        categ_nombre = Character.toUpperCase(categ_nombre.charAt(0)) + categ_nombre.substring(1).toLowerCase();
    }
    try {
        pst = conn.prepareStatement("SELECT COUNT(*) FROM categ_productos WHERE LOWER(categ_nombre) = LOWER(?)");
        pst.setString(1, categ_nombre);
        rs = pst.executeQuery();
        rs.next();
        int count = rs.getInt(1);
        if (count > 0) {
            out.println("<div class='alert alert-danger' role='alert'>La categoría ya existe. Ingrese una categoría diferente.</div>");
        } else {
            pst = conn.prepareStatement("INSERT INTO categ_productos (categ_nombre) VALUES (?)");
            pst.setString(1, categ_nombre);
            pst.executeUpdate();
            out.println("<div class='alert alert-success' role='alert'>Categoría Insertada Correctamente</div>");
        }
        // Cierra ResultSet y PreparedStatement
        if (rs != null) rs.close();
        pst.close();
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error PSQL: " + e + "</div>");
    }

} else if (request.getParameter("listar").equals("modificar")) {
    String idcateg_productos = request.getParameter("idcateg_productos");
    String categ_nombre = request.getParameter("categ_nombre");
    if (!categ_nombre.isEmpty()) {
        categ_nombre = Character.toUpperCase(categ_nombre.charAt(0)) + categ_nombre.substring(1).toLowerCase();
    }
    try {
        pst = conn.prepareStatement("SELECT COUNT(*) FROM categ_productos WHERE LOWER(categ_nombre) = LOWER(?) AND idcateg_productos != ?");
        pst.setString(1, categ_nombre);
        pst.setInt(2, Integer.parseInt(idcateg_productos));
        rs = pst.executeQuery();
        rs.next();
        int count = rs.getInt(1);
        if (count > 0) {
            out.println("<div class='alert alert-danger' role='alert'>La categoría ya existe. Ingrese una categoría diferente.</div>");
        } else {
            // Actualizar la categoría
            pst = conn.prepareStatement("UPDATE categ_productos SET categ_nombre = ? WHERE idcateg_productos = ?");
            pst.setString(1, categ_nombre);
            pst.setInt(2, Integer.parseInt(idcateg_productos));
            pst.executeUpdate();
            out.println("<div class='alert alert-success' role='alert'>Categoría Modificada Correctamente</div>");
        }
        // Cierra ResultSet y PreparedStatement
        if (rs != null) rs.close();
        pst.close();
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error PSQL: " + e + "</div>");
    }

} else if (request.getParameter("listar").equals("eliminar")) {
    String id_delete = request.getParameter("id_delete");
    try {
        pst = conn.prepareStatement("DELETE FROM categ_productos WHERE idcateg_productos = ?");
        pst.setInt(1, Integer.parseInt(id_delete));
        pst.executeUpdate();
        out.println("<div class='alert alert-success' role='alert'>Categoría Eliminada Correctamente</div>");
        pst.close();
    } catch (SQLException e) {
        if (e.getSQLState().equals("23503")) {
            out.println("<div class='alert alert-danger' role='alert'>La Categoría está siendo utilizada y no se puede eliminar</div>");
        } else {
            out.println("<div class='alert alert-danger' role='alert'>Error PSQL: " + e + "</div>");
        }
    }

} else if (request.getParameter("listar").equals("buscador")) {
    String buscador = request.getParameter("buscador").trim().toLowerCase();
    try {
        pst = conn.prepareStatement("SELECT * FROM categ_productos WHERE LOWER(categ_nombre) LIKE ? ORDER BY idcateg_productos ASC");
        pst.setString(1, buscador + "%");
        rs = pst.executeQuery();
%>
<%
    while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getString(1)%></td>
    <td><%= rs.getString(2)%></td>
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoCategoriasEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <!-- Icono de editar -->
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" onclick="rellenarjs('<%= rs.getString(1)%>', '<%= rs.getString(2)%>')"></i>
        <!-- Icono de eliminar -->
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getString(1)%>')"></i>
    </td>                     
</tr>
<%
                }
                // Cierra ResultSet y PreparedStatement
                rs.close();
                pst.close();
            } catch (Exception e) {
                out.println("Error PSQL: " + e);
            }
        }
    }
%>

<% 
    // Cierre de la conexión en el bloque finally
    try {
        if (conn != null) {
            conn.close();
        }
    } catch (SQLException e) {
        out.println("Error al cerrar la conexión: " + e);
    }
%>
