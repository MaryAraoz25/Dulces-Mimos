<%@ include file="header.jsp" %>
<!-- Sale & Revenue Start -->
<% if ("Administrador".equals(session.getAttribute("rol_nombre"))) { %>
<style>
        .salto-medio {
            height: 0.5em; /* Ajusta la altura según desees */
            display: block;
        }
    </style>
<div class="container-fluid pt-4 px-4 card-container">
    <div class="row g-4">
        <div class="col-sm-6 col-xl-3">
            <a href="FormClientes.jsp" class="text-decoration-none">
                <div class="d-flex align-items-center justify-content-between p-4 card custom-card">
                    <i class="fa-solid fa-users"></i>
                    <div class="ms-3 text-center">
                        <p class="mb-2">Clientes</p>
                        <div id="suma_clientes"></div>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-sm-6 col-xl-3">
            <a href="FormUsuarios.jsp" class="text-decoration-none">
                <div class="d-flex align-items-center justify-content-between p-4 card custom-card">
                    <i class="fa-solid fa-user"></i>
                    <div class="ms-3 text-center">
                        <p class="mb-2">Usuarios</p>
                        <div id="suma_usuarios"></div>
                    </div>
                </div>
            </a>
        </div>

        <div class="col-sm-6 col-xl-3">
            <a href="FormEmpleados.jsp" class="text-decoration-none">
                <div class="d-flex align-items-center justify-content-between p-4 card custom-card">
                    <i class="fa-solid fa-id-badge"></i>
                    <div class="ms-3 text-center">
                        <p class="mb-2">Empleados</p>
                        <div id="suma_empleados"></div>
                    </div>
                </div>
            </a>
        </div>

        <div class="col-sm-6 col-xl-3">
            <a href="FormProductos.jsp" class="text-decoration-none">
                <div class="d-flex align-items-center justify-content-between p-4 card custom-card">
                    <i class="fa-solid fa-chart-pie"></i>
                    <div class="ms-3 text-center">
                        <p class="mb-2">Productos</p>
                        <div id="suma_productos"></div>
                    </div>
                </div>
            </a>
        </div>
    </div>
</div>

<% } %>
<script>

    $(document).ready(function () {
        contarClientes();
        contarProductos();
        contarUsuarios();
        contarEmpleados();

    });
    function contarClientes() {
        $.ajax({
            data: {listar: 'contarClientes'},
            url: 'JSP/Dashboard.jsp',
            type: 'post',
            success: function (response) {
                $("#suma_clientes").html(response);
            }
        });
    }
    function contarProductos() {
        $.ajax({
            data: {listar: 'contarProductos'},
            url: 'JSP/Dashboard.jsp',
            type: 'post',
            success: function (response) {
                $("#suma_productos").html(response);
            }
        });
    }
    function contarUsuarios() {
        $.ajax({
            data: {listar: 'contarUsuarios'},
            url: 'JSP/Dashboard.jsp',
            type: 'post',
            success: function (response) {
                $("#suma_usuarios").html(response);
            }
        });
    }
    function contarEmpleados() {
        $.ajax({
            data: {listar: 'contarEmpleados'},
            url: 'JSP/Dashboard.jsp',
            type: 'post',
            success: function (response) {
                $("#suma_empleados").html(response);
            }
        });
    }
</script>
<br>
<br>
<br>
<br>
<br>
<br>
<br>
<br>

<div class="salto-medio"></div>
<%@ include file="footer.jsp" %>
