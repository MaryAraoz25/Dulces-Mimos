<%@ include file="conexion.jsp" %>

<%    if (request.getParameter("listar") != null) {
        if (request.getParameter("listar").equals("listar")) {
            try {
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM rol");
%>
<%
    while (rs.next()) {
%>
<tr>
    <td><%= rs.getString(1)%></td>
    <td><%= rs.getString(2)%></td>
    <td>
        <!-- Icono de editar -->
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" onclick="rellenarjs('<%= rs.getString(1)%>', '<%= rs.getString(2)%>')"></i>
        <!-- Icono de eliminar -->
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getString(1)%>')"></i>
    </td>                 
</tr>
<%
        }
        rs.close();
        st.close();
    } catch (Exception e) {
        out.print("Error PSQL: " + e);
    }
} else if (request.getParameter("listar").equals("cargar")) {
    String Rol = request.getParameter("rol_nombre").toLowerCase();
    Statement St = null;
    ResultSet Rs = null;
    String Consulta = "SELECT * FROM rol WHERE LOWER (rol_nombre) = '" + Rol + "'";
    St = conn.createStatement();
    Rs = St.executeQuery(Consulta);
    if (Rs.next()) {
        out.print("<div class='alert alert-danger' role='alert'>El rol ya existe. Ingrese un rol diferente.</div>");
    } else {
        try {
            String SQL = "INSERT INTO rol(rol_nombre) VALUES ('" + Rol + "')";
            St.executeUpdate(SQL);
            out.println("¡Datos Registrados!");
        } catch (Exception Ex) {
            out.println("¡Error al registrar! " + Ex);
        }
    }

} else if (request.getParameter("listar").equals("modificar")) {
    String Rol = request.getParameter("rol_nombre").toLowerCase();
    String pkid = request.getParameter("pkid");
    Statement St = null;
    ResultSet Rs = null;
    String Consulta = "SELECT * FROM rol WHERE LOWER (rol_nombre) = '" + Rol + "'";
    St = conn.createStatement();
    Rs = St.executeQuery(Consulta);
    if (Rs.next()) {
        out.print("<div class='alert alert-danger' role='alert'>El rol ya existe. Ingrese un rol diferente.</div>");
    } else {
        try {
            String SQL = "UPDATE rol SET rol_nombre='"+Rol+"' WHERE id_rol = '"+pkid+"'";
            St.executeUpdate(SQL);
            out.println("¡Datos Modificados!");
        } catch (Exception Ex) {
            out.println("¡Error al modificar! " + Ex);
        }
    }
} else if (request.getParameter("listar").equals("eliminar")) {
    String id_delete = request.getParameter("id_delete");
    try {
        Statement st = conn.createStatement();
        st.executeUpdate("DELETE FROM rol WHERE id_rol = '" + id_delete + "'");
        out.println("<div class='alert alert-success' role='alert'>Datos eliminados correctamente</div>");
        st.close();
    } catch (Exception e) {
        out.println("<div class='alert alert-danger' role='alert'>Error PSQL: " + e + "</div>");
    }
} else if (request.getParameter("listar").equals("buscador")) {
    String buscador = request.getParameter("buscador").trim().toLowerCase();
    try {
        Statement st = conn.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM rol WHERE LOWER(rol_nombre) LIKE '" + buscador + "%'");
%>
<%
    while (rs.next()) {
%>
<tr>
    <td><%= rs.getString(1)%></td>
    <td><%= rs.getString(2)%></td>
    <td>
        <!-- Icono de editar -->
        <i class="fas fa-edit" style="color: green; cursor: pointer; font-size: 20px;" onclick="rellenarjs('<%= rs.getString(1)%>', '<%= rs.getString(2)%>')"></i>
        <!-- Icono de eliminar -->
        <i class="fas fa-trash" style="color: red; cursor: pointer; font-size: 20px;" data-bs-toggle="modal" data-bs-target="#staticBackdrop" onclick="$('#id_delete').val('<%= rs.getString(1)%>')"></i>
    </td>                     
</tr>
<%
                }
                rs.close();
                st.close();
            } catch (Exception e) {
                out.println("Error PSQL: " + e);
            }
        }
    }
%>