<%@ page import="java.sql.*, org.mindrot.jbcrypt.BCrypt" %>
<%@ include file="conexion.jsp" %>
<%
    // Obt�n el par�metro 'action'
    String action = request.getParameter("action");

    if ("modificar".equals(action)) {
        // Recupera el ID del usuario desde la sesi�n
        HttpSession sesion = request.getSession();
        String idusuario = (String) sesion.getAttribute("idusuarios");

        if (idusuario != null) {
            // Recupera la nueva contrase�a del formulario
            String nueva_contrase�a = request.getParameter("nueva_contrase�a");

            // Actualiza la contrase�a en la base de datos
            String updateQuery = "UPDATE usuarios SET usu_contrase�a = ? WHERE idusuarios = ?";

            try (PreparedStatement updatePs = conn.prepareStatement(updateQuery)) {
                // Generar el hash de la nueva contrase�a utilizando bcrypt
                String hashedPassword = BCrypt.hashpw(nueva_contrase�a, BCrypt.gensalt());

                // Establece los valores para la consulta
                updatePs.setString(1, hashedPassword);
                updatePs.setInt(2, Integer.parseInt(idusuario));

                // Ejecuta la actualizaci�n
                int rowsUpdated = updatePs.executeUpdate();
                if (rowsUpdated > 0) {
                    out.println("<div class='alert alert-success' role='alert'>�Contrase�a actualizada correctamente!</div>");
                } else {
                    out.println("<div class='alert alert-danger' role='alert'>�Error al actualizar la contrase�a!</div>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class='alert alert-danger' role='alert'>�Error interno del servidor!</div>");
            }
        } else {
            out.println("<div class='alert alert-danger' role='alert'>�Usuario no autenticado!</div>");
        }
    }
%>
