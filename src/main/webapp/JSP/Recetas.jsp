<%@ include file="conexion.jsp" %>

<%    String listar = request.getParameter("listar");

    if (listar.equals("cargarProductos")) {
        try {
            String query = "SELECT * FROM productos p " +
               "WHERE p.idproductos NOT IN (SELECT r.productos_id " +
               "FROM recetas r WHERE r.recetaspro_estado = 'Finalizado') " +
               "ORDER BY p.idproductos ASC";
            PreparedStatement pst = conn.prepareStatement(query);
            ResultSet rs = pst.executeQuery();
            out.print("<option value=''>Seleccione un Producto</option>");
            while (rs.next()) {
                out.print("<option value='" + rs.getInt("idproductos") + "'>" + rs.getString("pro_nombre") + "</option>");
            }
            rs.close();
            pst.close();
        } catch (SQLException e) {
            out.println("<option value=''>Error al cargar productos</option>");
        }
    } else if (listar.equals("cargarIngredientes")) {
        try {
            String query = "SELECT idingredientes, ingre_nombre, descripcion, impuesto "
                    + "FROM ingredientes i JOIN unidad_medida u ON i.unidad_de_medida_id = u.idunidad_medida "
                    + "ORDER BY idingredientes ASC";
            PreparedStatement pst = conn.prepareStatement(query);
            ResultSet rs = pst.executeQuery();
            out.print("<option value=''>Seleccione un Ingrediente</option>");
            while (rs.next()) {
                int idIngrediente = rs.getInt("idingredientes");
                String nombreIngrediente = rs.getString("ingre_nombre");
                String unidadMedida = rs.getString("descripcion");
                out.print("<option value='" + idIngrediente + "' data-unidad='" + unidadMedida + "'>" + nombreIngrediente + "</option>");
            }
            rs.close();
            pst.close();
        } catch (SQLException e) {
            out.println("<option value=''>Error al cargar ingredientes</option>");
        }
    } else if (listar.equals("cargar")) {
    String recetaspro_estado = request.getParameter("recetaspro_estado");
    String productos_id = request.getParameter("productos_id");
    String preparacion = request.getParameter("tipo_preparacion");
    String nombre_receta = request.getParameter("nombre_receta");
    String cantidad = request.getParameter("detcompras_cantidad");
    String ingredientes_id = request.getParameter("ingredientes_id");

    try {
        Statement st = conn.createStatement();
        HttpSession sesion = request.getSession();
        int empleados_id = (Integer) sesion.getAttribute("idempleados");

        // Verificar si la receta ya existe en estado Pendiente
        ResultSet rsRecetaPendiente = st.executeQuery("SELECT idrecetas_productos FROM recetas WHERE recetaspro_estado = 'Pendiente'");
        if (rsRecetaPendiente.next()) {
            // Si existe una receta pendiente, comprobar si el detalle ya existe
            int idReceta = rsRecetaPendiente.getInt("idrecetas_productos");

            // Validar que el ingrediente no esté ya registrado para esta receta
            ResultSet rsDetalleExistente = st.executeQuery("SELECT COUNT(*) AS count FROM detalle_recetas WHERE recetas_id = " + idReceta + " AND ingredientes_id = " + ingredientes_id);
            if (rsDetalleExistente.next()) {
                int count = rsDetalleExistente.getInt("count");

                if (count > 0) {
                    
                    out.println("<div class='alert alert-warning' role='alert'>Ingrediente ya Ingresado.</div>");
                } else {
                    // Si no existe el detalle, inserta el nuevo detalle
                    String insertDetalle = "INSERT INTO detalle_recetas (cantidad, recetas_id, ingredientes_id) VALUES (" + cantidad + ", " + idReceta + ", " + ingredientes_id + ")";
                    int rowsDetalle = st.executeUpdate(insertDetalle);
                    if (rowsDetalle > 0) {
                        out.println("<div class='alert alert-success' role='alert'>Detalle Insertado Correctamente</div>");
                    }
                }
            }
        } else {
            // Si no hay receta pendiente, inserta la cabecera primero
            String insertReceta = "INSERT INTO recetas (recetaspro_estado, productos_id, empleados_id, preparacion, nombre_receta) VALUES ('"
                    + recetaspro_estado + "', " + productos_id + ", " + empleados_id + ", '" + preparacion + "', '" + nombre_receta + "')";
            int rowsReceta = st.executeUpdate(insertReceta, Statement.RETURN_GENERATED_KEYS);
            if (rowsReceta > 0) {
                ResultSet generatedKeys = st.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int idReceta = generatedKeys.getInt(1);

                    // Insertar el detalle para la nueva receta
                    String insertDetalle = "INSERT INTO detalle_recetas (cantidad, recetas_id, ingredientes_id) VALUES (" + cantidad + ", " + idReceta + ", " + ingredientes_id + ")";
                    int rowsDetalle = st.executeUpdate(insertDetalle);
                    if (rowsDetalle > 0) {
                        out.println("<div class='alert alert-success' role='alert'>Cabecera y Detalle Insertados Correctamente</div>");
                    }
                }
            } else {
                out.println("<div class='alert alert-danger' role='alert'>Error al insertar la receta</div>");
            }
        }
    } catch (SQLException e) {
        out.println("Error al cargar recetas: " + e.getMessage());
    }
} else if (listar.equals("mostrardetalle")) {
        try {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT idrecetas_productos FROM recetas WHERE recetaspro_estado='Pendiente';");
            if (rs.next()) {
                int idReceta = rs.getInt("idrecetas_productos");
                ResultSet pk = st.executeQuery("SELECT dr.iddetalle_recetas, i.ingre_nombre AS ingredientes_id, um.descripcion AS unidad_medida, "
                        + "dr.cantidad "
                        + "FROM detalle_recetas dr "
                        + "JOIN ingredientes i ON dr.ingredientes_id = i.idingredientes "
                        + "JOIN unidad_medida um ON i.unidad_de_medida_id = um.idunidad_medida "
                        + "WHERE dr.recetas_id =" + idReceta);
                while (pk.next()) {
                    int iddetalle_recetas = pk.getInt("iddetalle_recetas");
                    String ingredientes_id = pk.getString("ingredientes_id");
                    String unidad_medida = pk.getString("unidad_medida");
                    int cantidad = pk.getInt("cantidad");
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"><%= ingredientes_id%></td>
    <td style="text-align: center; vertical-align: middle;"><%= unidad_medida%></td>
    <td style="text-align: center; vertical-align: middle;"><%= cantidad%></td>
    <td style="text-align: center; vertical-align: middle;">

        <i class="fa fa-trash" data-bs-toggle="modal" data-bs-target="#staticBackdrop" style="color: blue; font-size: 16px;" onclick="$('#id_delete').val('<%= iddetalle_recetas%>')"></i>
    </td>
</tr>
<%
            }
        }
    } catch (SQLException e) {
        out.println("error PSQL" + e);
    }
} else if (listar.equals("cancelar")) {
    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT idrecetas_productos FROM recetas WHERE recetaspro_estado='Pendiente';");
        if (rs.next()) {
            st.executeUpdate("UPDATE recetas SET recetaspro_estado ='Cancelado' WHERE idrecetas_productos =" + rs.getString(1));
        }
    } catch (SQLException e) {
        out.println("error PSQL" + e);
    }
} else if (listar.equals("eliminar")) {
    String id_delete = request.getParameter("id_delete");
    try {
        Statement st = conn.createStatement();
        st.executeUpdate("DELETE FROM detalle_recetas WHERE iddetalle_recetas=" + id_delete);
    } catch (SQLException e) {
        out.println("error PSQL" + e);
    }
} else if (listar.equals("finalizar")) {
    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT idrecetas_productos FROM recetas WHERE recetaspro_estado='Pendiente';");
        if (rs.next()) {
            int idReceta = rs.getInt("idrecetas_productos");
            st.executeUpdate("UPDATE recetas SET recetaspro_estado = 'Finalizado' WHERE idrecetas_productos = " + idReceta);
        }
    } catch (SQLException e) {
        out.println("error PSQL" + e);
    }
} else if (listar.equals("mostrarrecetas")) {
    try {
        Statement st = conn.createStatement();
        HttpSession sesion = request.getSession();
        int empleado_id = (Integer) sesion.getAttribute("idempleados");
        String rolNombre = (String) sesion.getAttribute("rol_nombre");
        String query;

        if ("Administrador".equals(rolNombre)) {
            query = "SELECT r.idrecetas_productos AS id, "
                    + "p.pro_nombre AS producto, "
                    + "r.recetaspro_estado AS estado, "
                    + "e.emple_nombre AS empleado, "
                    + "r.fecha_receta AS fecha "
                    + "FROM recetas r "
                    + "JOIN productos p ON r.productos_id = p.idproductos "
                    + "JOIN empleados e ON r.empleados_id = e.idempleados "
                    + "WHERE r.recetaspro_estado = 'Finalizado' "
                    + "ORDER BY r.idrecetas_productos DESC;"; 
        } else {
            query = "SELECT r.idrecetas_productos AS id, "
                    + "p.pro_nombre AS producto, "
                    + "r.recetaspro_estado AS estado, "
                    + "e.emple_nombre AS empleado, "
                    + "r.fecha_receta AS fecha "
                    + "FROM recetas r "
                    + "JOIN productos p ON r.productos_id = p.idproductos "
                    + "JOIN empleados e ON r.empleados_id = e.idempleados "
                    + "WHERE r.recetaspro_estado = 'Finalizado' "
                    + "AND r.empleados_id = " + empleado_id + " " 
                    + "ORDER BY r.idrecetas_productos DESC;";
        }

        ResultSet pk = st.executeQuery(query);
        while (pk.next()) {
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("id")); %></td>
      <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getDate("fecha")); %></td> 
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("producto")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("estado")); %></td>
    <td style="text-align: center; vertical-align: middle;"><% out.print(pk.getString("empleado")); %></td>
  <!-- Mostrar la fecha -->
    <td style="text-align: center; vertical-align: middle;">
        <i class="fa fa-trash" data-bs-toggle="modal" data-bs-target="#staticBackdrop" 
           style="color:#ff007b; font-size: 16px;" 
           onclick="$('#pkdelete').val('<%= pk.getString("id") %>')"></i>
        <a href="${pageContext.request.contextPath}/ReportesMyD_JSP/ReporteRecetas.jsp?id=<%= pk.getString("id") %>" target="_blank">
            <i class="fa fa-file-pdf" style="color: black; font-size: 18px;"></i>
        </a>
    </td>
</tr>
<%
        }
    } catch (SQLException e) {
        out.println("error PSQL" + e);
    }
} else if (listar.equals("buscador")) {
    String buscador = request.getParameter("buscador").trim().toLowerCase(); 
    HttpSession sesion = request.getSession();
    int empleado_id = (Integer) sesion.getAttribute("idempleados");
    String rolNombre = (String) sesion.getAttribute("rol_nombre");
    String query;

    if ("Administrador".equals(rolNombre)) {
        query = "SELECT r.idrecetas_productos AS id, "
                + "p.pro_nombre AS producto, "
                + "r.recetaspro_estado AS estado, "
                + "e.emple_nombre AS empleado, "
                + "r.fecha_receta AS fecha "
                + "FROM recetas r "
                + "JOIN productos p ON r.productos_id = p.idproductos "
                + "JOIN empleados e ON r.empleados_id = e.idempleados "
                + "WHERE r.recetaspro_estado = 'Finalizado' "
                + "AND (LOWER(p.pro_nombre) LIKE ? OR LOWER(r.recetaspro_estado) LIKE ?) "
                + "ORDER BY r.idrecetas_productos DESC;";
    } else {
        query = "SELECT r.idrecetas_productos AS id, "
                + "p.pro_nombre AS producto, "
                + "r.recetaspro_estado AS estado, "
                + "e.emple_nombre AS empleado, "
                + "r.fecha_receta AS fecha "
                + "FROM recetas r "
                + "JOIN productos p ON r.productos_id = p.idproductos "
                + "JOIN empleados e ON r.empleados_id = e.idempleados "
                + "WHERE r.recetaspro_estado = 'Finalizado' "
                + "AND (LOWER(p.pro_nombre) LIKE ? OR LOWER(r.recetaspro_estado) LIKE ?) "
                + "AND r.empleados_id = ? " 
                + "ORDER BY r.idrecetas_productos DESC;";
    }

    try (PreparedStatement pst = conn.prepareStatement(query)) {
        pst.setString(1, buscador + "%");
        pst.setString(2, buscador + "%");
        if (!"Administrador".equals(rolNombre)) {
            pst.setInt(3, empleado_id); 
        }

        try (ResultSet pk = pst.executeQuery()) {
            while (pk.next()) {
%>
<tr>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("id") %></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getDate("fecha") %></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("producto") %></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("estado") %></td>
    <td style="text-align: center; vertical-align: middle;"><%= pk.getString("empleado") %></td>
     <!-- Mostrar la fecha -->
    <td style="text-align: center; vertical-align: middle;">
        <i class="fa fa-trash" data-bs-toggle="modal" data-bs-target="#staticBackdrop" 
           style="color:#ff007b; font-size: 16px;" 
           onclick="$('#pkdelete').val('<%= pk.getString("id") %>')"></i>
        <a href="${pageContext.request.contextPath}/ReportesMyD_JSP/ReporteRecetas.jsp?id=<%= pk.getString("id") %>" target="_blank">
            <i class="fa fa-file-pdf" style="color: black; font-size: 18px;"></i>
        </a>
    </td>
</tr>
<%
            }
        }
    } catch (SQLException e) {
        out.println("error PSQL: " + e.getMessage());
    }
}else if (request.getParameter("listar").equals("anular")) {
        Statement st = null;
        ResultSet rs = null;
        String pkdelete = request.getParameter("pkdelete");
        try {
            st = conn.createStatement();
            st.executeUpdate("UPDATE recetas SET recetaspro_estado = 'Anulado' WHERE idrecetas_productos = " + pkdelete);
            //out.println("<div class='alert alert-success' role='alert'>Datos modificados correctamente</div>");
        } catch (Exception e) {
            out.println("error PSQL" + e);
        }
    }
%>