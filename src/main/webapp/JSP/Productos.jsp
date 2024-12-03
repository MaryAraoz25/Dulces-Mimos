<%@ include file="conexion.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%    String listar = request.getParameter("listar");

    if (listar != null) {
        if (listar.equals("listar")) {
            // Código para listar productos
            try {
                String query = "SELECT p.idproductos, p.pro_nombre, p.pro_precio, "
                        + "p.stock_actual, p.stock_minimo, p.impuesto, "
                        + "c.idcateg_productos, c.categ_nombre, um.idunidad_medida, um.descripcion AS unidad_medida "
                        + "FROM productos p "
                        + "JOIN categ_productos c ON p.categ_productos = c.idcateg_productos "
                        + "JOIN unidad_medida um ON p.unidad_de_medida_id = um.idunidad_medida "
                        + "ORDER BY p.idproductos ASC";
                PreparedStatement pst = conn.prepareStatement(query);
                ResultSet rs = pst.executeQuery();

                while (rs.next()) {
                    String StrPrecio = rs.getString("pro_precio");
                double precio = Double.parseDouble(StrPrecio);
                NumberFormat NumeroFormateado = NumberFormat.getNumberInstance(Locale.GERMANY);
                String precioFormateado = NumeroFormateado.format(precio);
%>
<tr>
    <td class="text-center"><%= rs.getInt("idproductos")%></td>
    <td><%= rs.getString("pro_nombre")%></td>
    <td><% out.print(precioFormateado);%></td>
    <td><%= rs.getInt("stock_actual")%></td>
    <td><%= rs.getInt("stock_minimo")%></td>
    <td><%= rs.getString("impuesto")%></td>
    <td><%= rs.getString("categ_nombre")%></td>
    <td><%= rs.getString("unidad_medida")%></td>
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoProductosEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" 
           onclick="rellenarjs('<%= rs.getInt("idproductos")%>', '<%= rs.getString("pro_nombre")%>', '<%= rs.getString("pro_precio")%>', '<%= rs.getInt("stock_actual")%>', '<%= rs.getInt("stock_minimo")%>', '<%= rs.getString("impuesto")%>', '<%= rs.getInt("idcateg_productos")%>', '<%= rs.getInt("idunidad_medida")%>')" title="Editar Producto"></i>
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" 
           data-bs-toggle="modal" data-bs-target="#staticBackdrop" 
           onclick="$('#id_delete').val('<%= rs.getInt(1)%>')"></i>
    </td>
</tr>
<%
        }
        rs.close();
        pst.close();
    } catch (Exception e) {
        out.print("Error al listar productos: " + e);
    }
} else if (listar.equals("cargar")) {
    // Código para insertar un nuevo producto
    String pro_nombre = request.getParameter("pro_nombre");
    String pro_precio = request.getParameter("pro_precio");
    String precioForm = pro_precio.replace(".", "");
    int stock_actual = Integer.parseInt(request.getParameter("stock_actual"));
    int stock_minimo = Integer.parseInt(request.getParameter("stock_minimo"));
    String impuesto = request.getParameter("impuesto");
    int categ_productos = Integer.parseInt(request.getParameter("categ_productos"));
    String unidad_de_medida_id_str = request.getParameter("unidad_de_medida_id");
    int unidad_de_medida_id = Integer.parseInt(unidad_de_medida_id_str);

    if (!pro_nombre.isEmpty()) {
        pro_nombre = Character.toUpperCase(pro_nombre.charAt(0)) + pro_nombre.substring(1).toLowerCase();
    }

    try {
        String checkExistenceQuery = "SELECT COUNT(*) FROM productos WHERE LOWER(pro_nombre) = LOWER(?)";
        PreparedStatement pstCheck = conn.prepareStatement(checkExistenceQuery);
        pstCheck.setString(1, pro_nombre);
        ResultSet rsCheck = pstCheck.executeQuery();
        rsCheck.next();
        int count = rsCheck.getInt(1);
        rsCheck.close();
        pstCheck.close();

        if (count > 0) {
            out.println("<div class='alert alert-danger' role='alert'>El producto ya existe. Ingrese otro producto.</div>");
        } else {
            String insertQuery = "INSERT INTO productos (pro_nombre, pro_precio, stock_actual, stock_minimo, impuesto, categ_productos, unidad_de_medida_id) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement pstInsert = conn.prepareStatement(insertQuery);
            pstInsert.setString(1, pro_nombre);
            pstInsert.setDouble(2, Double.parseDouble(precioForm));
            pstInsert.setInt(3, stock_actual);
            pstInsert.setInt(4, stock_minimo);
            pstInsert.setString(5, impuesto);
            pstInsert.setInt(6, categ_productos);
            pstInsert.setInt(7, unidad_de_medida_id);
            pstInsert.executeUpdate();
            out.println("<div class='alert alert-success' role='alert'>Producto insertado correctamente</div>");
            pstInsert.close();
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error al insertar producto: " + e + "</div>");
    }
} else if (listar.equals("modificar")) {
    // Código para modificar un producto existente
    int idproductos = Integer.parseInt(request.getParameter("idproductos"));
    String pro_nombre = request.getParameter("pro_nombre");
    String pro_precio = request.getParameter("pro_precio");
    String precioForm = pro_precio.replace(".", "");
    int stock_actual = Integer.parseInt(request.getParameter("stock_actual"));
    int stock_minimo = Integer.parseInt(request.getParameter("stock_minimo"));
    String impuesto = request.getParameter("impuesto");
    int categ_productos = Integer.parseInt(request.getParameter("categ_productos"));
    String unidad_de_medida_id_str = request.getParameter("unidad_de_medida_id");
int unidad_de_medida_id = Integer.parseInt(unidad_de_medida_id_str);

    if (!pro_nombre.isEmpty()) {
        pro_nombre = Character.toUpperCase(pro_nombre.charAt(0)) + pro_nombre.substring(1).toLowerCase();
    }

    try {
        String checkExistenceQuery = "SELECT COUNT(*) FROM productos WHERE LOWER(pro_nombre) = LOWER(?) AND idproductos != ?";
        PreparedStatement pstCheck = conn.prepareStatement(checkExistenceQuery);
        pstCheck.setString(1, pro_nombre);
        pstCheck.setInt(2, idproductos);
        ResultSet rsCheck = pstCheck.executeQuery();
        rsCheck.next();
        int count = rsCheck.getInt(1);
        rsCheck.close();
        pstCheck.close();

        if (count > 0) {
            out.println("<div class='alert alert-danger' role='alert'>Ya existe otro producto con el mismo nombre.</div>");
        } else {
            String updateQuery = "UPDATE productos SET pro_nombre = ?, pro_precio = ?, "
                    + "stock_actual = ?, stock_minimo = ?, impuesto = ?, categ_productos = ?, unidad_de_medida_id = ? WHERE idproductos = ?";
            PreparedStatement pstUpdate = conn.prepareStatement(updateQuery);
            pstUpdate.setString(1, pro_nombre);
            pstUpdate.setDouble(2, Double.parseDouble(precioForm));
            pstUpdate.setInt(3, stock_actual);
            pstUpdate.setInt(4, stock_minimo);
            pstUpdate.setString(5, impuesto);
            pstUpdate.setInt(6, categ_productos);
            pstUpdate.setInt(7, unidad_de_medida_id);
            pstUpdate.setInt(8, idproductos);
            pstUpdate.executeUpdate();
            out.println("<div class='alert alert-success' role='alert'>Producto modificado correctamente</div>");
            pstUpdate.close();
        }
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error al modificar producto: " + e + "</div>");
    }
} else if (listar.equals("eliminar")) {
    // Código para eliminar un producto
    int id_delete = Integer.parseInt(request.getParameter("id_delete"));
    try {
        String deleteQuery = "DELETE FROM productos WHERE idproductos = ?";
        PreparedStatement pstDelete = conn.prepareStatement(deleteQuery);
        pstDelete.setInt(1, id_delete);
        pstDelete.executeUpdate();
        out.println("<div class='alert alert-success' role='alert'>Producto eliminado correctamente</div>");
        pstDelete.close();
    } catch (SQLException e) {
        if (e.getSQLState().equals("23503")) {
            out.println("<div class='alert alert-danger' role='alert'>El producto está siendo utilizado y no puede ser eliminado</div>");
        } else {
            out.println("<div class='alert alert-danger' role='alert'>Error al eliminar producto: " + e.getMessage() + "</div>");
        }
    }
} else if (listar.equals("cargarCategorias")) {
    // Código para cargar las categorías
    try {
        String query = "SELECT idcateg_productos, categ_nombre FROM categ_productos";
        PreparedStatement pst = conn.prepareStatement(query);
        ResultSet rs = pst.executeQuery();
        out.print("<option value='selectcateg'>Seleccione una Categoría</option>");
        while (rs.next()) {
            out.print("<option value='" + rs.getInt(1) + "'>" + rs.getString(2) + "</option>");
        }
        rs.close();
        pst.close();
    } catch (Exception e) {
        out.println("<option value=''>Error al cargar categorías: " + e.getMessage() + "</option>");
    }
} else if (request.getParameter("listar").equals("cargarUnidades")) {
    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT idunidad_medida, descripcion FROM unidad_medida WHERE descripcion = 'Unidad'");
        out.print("<option value='selectum'>Seleccione una Unidad de Medida</option>");
        while (rs.next()) {
            int idUnidadMedida = rs.getInt("idunidad_medida");
            String descripcion = rs.getString("descripcion");
            out.print("<option value='" + idUnidadMedida + "'>" + descripcion + "</option>");
        }
        rs.close();
        st.close();
    } catch (SQLException e) {
        out.println("<option value=''>Error al cargar unidades de medida</option>");
    }
} else if (listar.equals("buscador")) {
    // Nueva función de búsqueda de productos
    String buscador = request.getParameter("buscador");
    if (buscador != null) {
        buscador = buscador.trim().toLowerCase();
        try {
            String query = "SELECT p.idproductos, p.pro_nombre, p.pro_precio, p.stock_actual, p.stock_minimo, p.impuesto, p.unidad_de_medida_id,um.idunidad_medida, um.descripcion AS unidad_descripcion, c.idcateg_productos, c.categ_nombre "
                    + "FROM productos p "
                    + "JOIN categ_productos c ON p.categ_productos = c.idcateg_productos "
                    + "JOIN unidad_medida um ON p.unidad_de_medida_id = um.idunidad_medida "
                    + "WHERE LOWER(p.pro_nombre) LIKE ? "
                    + "ORDER BY p.idproductos ASC";
            try (PreparedStatement pst = conn.prepareStatement(query)) {
                pst.setString(1, buscador + "%");
                try (ResultSet rs = pst.executeQuery()) {
                    while (rs.next()) {
%>
<tr>
    <td class="text-center"><%= rs.getInt("idproductos")%></td>
    <td><%= rs.getString("pro_nombre")%></td>
    <td><%= rs.getString("pro_precio")%></td>
    <td><%= rs.getInt("stock_actual")%></td>
    <td><%= rs.getInt("stock_minimo")%></td>
    <td><%= rs.getString("impuesto")%></td>
    <td><%= rs.getString("categ_nombre")%></td>
    <td><%= rs.getString("unidad_descripcion")%></td>
    <td class="text-center">
        <a href="${pageContext.request.contextPath}/Reportes_EspecificosJSP/ListadoProductosEspecificos.jsp?id=<%= rs.getInt(1)%>" target="_blank">
            <i class="fas fa-print" style="color: black; cursor: pointer; font-size: 20px;"></i>
        </a>
        <!-- Icono de editar -->
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" onclick="rellenarjs('<%= rs.getInt("idproductos")%>', '<%= rs.getString("pro_nombre")%>', '<%= rs.getString("pro_precio")%>', '<%= rs.getInt("stock_actual")%>', '<%= rs.getInt("stock_minimo")%>', '<%= rs.getString("impuesto")%>', '<%= rs.getInt("idcateg_productos")%>', '<%= rs.getInt("idunidad_medida")%>')"></i>
        <!-- Icono de eliminar -->
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getInt("idproductos")%>')"></i>
    </td>
</tr>
<%
                            }
                        }
                    }
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger' role='alert'>Error al buscar productos: " + e.getMessage() + "</div>");
                }
            }
        }
    }
%>