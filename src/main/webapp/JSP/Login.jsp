<%@page import="java.math.BigInteger"%>
<%@page import="java.security.MessageDigest"%>
<%@page import="org.mindrot.jbcrypt.BCrypt"%>
<%@include file="conexion.jsp"%>

<%
    PreparedStatement ps = null;
    ResultSet rs = null;

    if (request.getParameter("listar") != null) {
        if (request.getParameter("listar").equals("ingresar")) {
            String usu_nombre = request.getParameter("usu_nombre");
            String usu_contraseña = request.getParameter("usu_contraseña");

            HttpSession sesion = request.getSession();
            try {
                String sql = "SELECT u.usu_nombre, u.idusuarios, u.usu_estado, u.usu_contraseña, u.intentos_fallidos, u.ultimo_intento, "
                           + "r.rol_nombre, e.emple_nombre, e.idempleados "
                           + "FROM usuarios u "
                           + "LEFT JOIN rol r ON u.rol_idrol = r.id_rol "
                           + "LEFT JOIN empleados e ON u.idusuarios = e.usuarios_id "
                           + "WHERE u.usu_nombre = ?";

                ps = conn.prepareStatement(sql);
                ps.setString(1, usu_nombre);

                rs = ps.executeQuery();

                if (rs.next()) {
                    String estado = rs.getString("usu_estado");
                    int intentos_fallidos = rs.getInt("intentos_fallidos");
                    String storedHash = rs.getString("usu_contraseña");

                    if (estado.equals("Inactivo")) {
                        out.println("<div class=\"alert alert-danger\" role=\"alert\">Usuario inactivo. Contacte al administrador.</div>");
                    } else {
                        if (BCrypt.checkpw(usu_contraseña, storedHash)) {
                            // Contraseña correcta: reiniciar contador y permitir acceso
                            String updateSql = "UPDATE usuarios SET intentos_fallidos = 0, ultimo_intento = now() WHERE usu_nombre = ?";
                            ps = conn.prepareStatement(updateSql);
                            ps.setString(1, usu_nombre);
                            ps.executeUpdate();

                            String rol_nombre = rs.getString("rol_nombre");
                            sesion.setAttribute("logueado", "1");
                            sesion.setAttribute("usu_nombre", rs.getString("usu_nombre"));
                            sesion.setAttribute("idusuarios", rs.getString("idusuarios"));
                            sesion.setAttribute("rol_nombre", rol_nombre);

                            String emple_nombre = rs.getString("emple_nombre") != null ? rs.getString("emple_nombre") : rs.getString("usu_nombre");
                            sesion.setAttribute("emple_nombre", emple_nombre);
                            sesion.setAttribute("idempleados", rs.getInt("idempleados"));

                            out.print("Usuario Válido");
                        } else {
                            // Contraseña incorrecta: incrementar contador
                            intentos_fallidos++;

                            if (intentos_fallidos >= 3) {
                                String updateSql = "UPDATE usuarios SET usu_estado = 'Inactivo', intentos_fallidos = 3 WHERE usu_nombre = ?";
                                ps = conn.prepareStatement(updateSql);
                                ps.setString(1, usu_nombre);
                                ps.executeUpdate();

out.println("<div class='alert alert-danger' role='alert'>Demasiados intentos fallidos.<br>Usuario inactivo.<br>Contacte al administrador.</div>");
                            } else {
                                String updateSql = "UPDATE usuarios SET intentos_fallidos = ?, ultimo_intento = now() WHERE usu_nombre = ?";
                                ps = conn.prepareStatement(updateSql);
                                ps.setInt(1, intentos_fallidos);
                                ps.setString(2, usu_nombre);
                                ps.executeUpdate();

                                out.println("<div class=\"alert alert-danger\" role=\"alert\">Contraseña incorrecta.<br>Intentos restantes: " + (3 - intentos_fallidos) + "</div>");
                            }
                        }
                    }
                } else {
                    out.println("<div class=\"alert alert-danger\" role=\"alert\">Usuario no encontrado</div>");
                }
            } catch (Exception e) {
                out.println("<div class=\"alert alert-danger\" role=\"alert\">Error inesperado: " + e.getMessage() + "</div>");
            }
        }
    }
%>
