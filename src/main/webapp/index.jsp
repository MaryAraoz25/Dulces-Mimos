<%-- 
    Document   : index
    Created on : 21 may. 2024, 08:14:15
    Author     : Maria
--%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Login</title>
        <link href="css/webfonts.css" rel="stylesheet">
        
        <link rel="stylesheet" href="css/estilologin.css">
        <script src="js/jquery-3.7.1.min.js"></script>
        <!-- Favicon -->
        <link href="img/pasteleria.png" rel="icon">
    </head>
    <body>
        <div class="container signinForm">
            <div class="form signin">
                <form id="form">
                    <input type="hidden" id="listar" name="listar" value="ingresar">
                    <h2 style="text-align: center;">Iniciar Sesión</h2>
                    <br>
                    <div class="inputBox">
                        <input type="text" id="usu_nombre" name="usu_nombre" required="required">
                        <i class="fa-regular fa-user"></i>
                        <span>Nombre De Usuario</span>
                    </div>
                    <br>
                    <div class="inputBox">
                        <input type="password" id="usu_contraseña" name="usu_contraseña" required="required">
                        <i class="fa-solid fa-lock"></i>
                        <span>Contraseña</span>
                    </div>
                    
                    <br>
                    <div class="inputBox">
                        <button type="button" id="btn-ingresar"  name="btn-ingresar" style="padding: 12px 10px; border: none; width: 100%; background: #ff007b; color: black; font-weight: bold; border-radius: 25px; font-size: 1em; transition: 0.5s; outline: none; cursor: pointer; text-align: center;">Iniciar Sesión</button>
                    </div>   
                    <br>
                    <div id="mensaje" style="color: #ff007b;"></div>
                </form>  
            </div>
        </div>
        <script>
            $(document).ready(function () {
                $("#usu_nombre").focus();
                $("#btn-ingresar").on('click', function () {
                    enviarFormulario();
                });
                $("#usu_contraseña, #btn-ingresar").on('keypress', function (e) {
                    if (e.which === 13 || e.which === 109) { // Tecla Enter y Enter del teclado numérico
                        enviarFormulario();
                    }
                });
            });

            function enviarFormulario() {
                formdata = $("#form").serialize();
                $.ajax({
                    data: formdata,
                    url: 'JSP/Login.jsp',
                    type: 'post',
                    success: function (response) {
                        if (response.indexOf('Usuario Válido') !== -1) {
                            location.href = 'dashboard.jsp';
                        } else {
                            $("#mensaje").html(response);
                            resetForm();
                        }
                    }
                });
            }
            function resetForm() {
                $("#form")[0].reset();
                $("#usu_nombre").focus();
            }
        </script>
    </body>
</html>