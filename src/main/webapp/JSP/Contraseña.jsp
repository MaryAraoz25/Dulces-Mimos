<%@ page import="java.sql.*, org.mindrot.jbcrypt.BCrypt" %>
<%@ include file="conexion.jsp" %>
<%
    // Obtén el parámetro 'action'
    String action = request.getParameter("action");

    if ("modificar".equals(action)) {
        // Recupera el ID del usuario desde la sesión
        HttpSession sesion = request.getSession();
        String idusuario = (String) sesion.getAttribute("idusuarios");

        if (idusuario != null) {
            // Recupera la nueva contraseña del formulario
            String nueva_contraseña = request.getParameter("nueva_contraseña");

            // Actualiza la contraseña en la base de datos
            String updateQuery = "UPDATE usuarios SET usu_contraseña = ? WHERE idusuarios = ?";

            try (PreparedStatement updatePs = conn.prepareStatement(updateQuery)) {
                // Generar el hash de la nueva contraseña utilizando bcrypt
                String hashedPassword = BCrypt.hashpw(nueva_contraseña, BCrypt.gensalt());

                // Establece los valores para la consulta
                updatePs.setString(1, hashedPassword);
                updatePs.setInt(2, Integer.parseInt(idusuario));

                // Ejecuta la actualización
                int rowsUpdated = updatePs.executeUpdate();
                if (rowsUpdated > 0) {
                    out.println("<div class='alert alert-success' role='alert'>¡Contraseña actualizada correctamente!</div>");
                } else {
                    out.println("<div class='alert alert-danger' role='alert'>¡Error al actualizar la contraseña!</div>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class='alert alert-danger' role='alert'>¡Error interno del servidor!</div>");
            }
        } else {
            out.println("<div class='alert alert-danger' role='alert'>¡Usuario no autenticado!</div>");
        }
    }
%>
