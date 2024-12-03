<%@ page import="java.sql.*, javax.sql.*" %>
<%@ include file="conexion.jsp" %>
<%    String listar = request.getParameter("listar");

    // Verificamos si la solicitud es para cargar empleados
    if ("CargarInformeEmpleado".equals(listar)) {
        try ( Statement st = conn.createStatement();  ResultSet rs = st.executeQuery("SELECT idempleados, emple_nombre || ' ' || emple_apellido AS nombre_completo FROM public.empleados ORDER BY idempleados")) {

            out.print("<option value=''>Seleccione Todos</option>");
            while (rs.next()) {
                int idEmpleado = rs.getInt("idempleados");
                String nombreCompleto = rs.getString("nombre_completo");
                out.print("<option value='" + idEmpleado + "'>" + nombreCompleto + "</option>");
            }
        } catch (SQLException e) {
            out.println("<option value=''>Error al cargar empleados</option>");
        }
    }
    if ("CargarInformeProveedor".equals(listar)) {
        try ( Statement st = conn.createStatement();  ResultSet rs = st.executeQuery("SELECT idproveedores, prov_nombre || ' - ' || prov_telefono AS nombre_completo FROM public.proveedores ORDER BY idproveedores")) {

            out.print("<option value=''>Seleccione Todos</option>");
            while (rs.next()) {
                int idProveedor = rs.getInt("idproveedores");
                String nombreCompleto = rs.getString("nombre_completo");
                out.print("<option value='" + idProveedor + "'>" + nombreCompleto + "</option>");
            }
        } catch (SQLException e) {
            out.println("<option value=''>Error al cargar proveedores</option>");
        }
    }
    if ("CargarInformeClientePedido".equals(listar)) {
        try ( Statement st = conn.createStatement();  ResultSet rs = st.executeQuery("SELECT idclientes, cli_nombre || ' - ' || cli_cedula AS nombre_cedula FROM clientes")) {

            out.print("<option value=''>Seleccione Todos</option>");
            while (rs.next()) {
                int idcliente = rs.getInt("idclientes");
                String nombreCedula = rs.getString("nombre_cedula");

                out.print("<option value='" + idcliente + "'>" + nombreCedula + "</option>");
            }
        } catch (SQLException e) {
            out.println("<option value=''>Error al cargar clientes</option>");
        }
    }
    if ("CargarInformeRecetas".equals(listar)) {
        try ( Statement st = conn.createStatement();  ResultSet rs = st.executeQuery("SELECT idrecetas_productos, nombre_receta FROM recetas")) {

            out.print("<option value=''>Seleccione Todos</option>");
            while (rs.next()) {
                int idreceta = rs.getInt("idrecetas_productos");
                String nombreReceta = rs.getString("nombre_receta");

                out.print("<option value='" + idreceta + "'>" + nombreReceta + "</option>");
            }
        } catch (SQLException e) {
            out.println("<option value=''>Error al cargar recetas</option>");
        }
    }
    if ("CargarInformeProductos".equals(listar)) {
        try ( Statement st = conn.createStatement();  ResultSet rs = st.executeQuery("SELECT idproductos, pro_nombre FROM productos")) {

            out.print("<option value=''>Seleccione Todos</option>");
            while (rs.next()) {
                int idproducto = rs.getInt("idproductos");
                String nombreProducto = rs.getString("pro_nombre");

                out.print("<option value='" + idproducto + "'>" + nombreProducto + "</option>");
            }
        } catch (SQLException e) {
            out.println("<option value=''>Error al cargar productos</option>");
        }
    }if ("CargarInformeCliente".equals(listar)) {
        try ( Statement st = conn.createStatement();  ResultSet rs = st.executeQuery("SELECT idclientes, cli_nombre || ' - ' || cli_cedula AS nombre_cedula FROM clientes")) {

            out.print("<option value=''>Seleccione Todos</option>");
            while (rs.next()) {
                int idcliente = rs.getInt("idclientes");
                String nombreCedula = rs.getString("nombre_cedula");

                out.print("<option value='" + idcliente + "'>" + nombreCedula + "</option>");
            }
        } catch (SQLException e) {
            out.println("<option value=''>Error al cargar clientes</option>");
        }
    }

%>