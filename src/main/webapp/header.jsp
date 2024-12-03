<%
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("logueado") == null || sesion.getAttribute("logueado").equals("0")) {
%>
<script>
    alert('Debe Iniciar Sesión');
    location.href = 'index.jsp';
</script>
<%
        return;
    }
    String userRole = (String) sesion.getAttribute("rol_nombre");
    if (userRole == null || (!"Administrador".equals(userRole) && request.getRequestURI().contains("FormRol.jsp"))) {
        response.sendRedirect("dashboard.jsp");
        return;
    } else if (userRole == null || (!"Administrador".equals(userRole) && request.getRequestURI().contains("FormUsuarios.jsp"))) {
        response.sendRedirect("dashboard.jsp");
        return;
    } else if (userRole == null || (!"Administrador".equals(userRole) && request.getRequestURI().contains("FormEmpleados.jsp"))) {
        response.sendRedirect("dashboard.jsp");
        return;
    } else if (userRole == null || (!"Administrador".equals(userRole) && request.getRequestURI().contains("FormClientes.jsp"))) {
        response.sendRedirect("dashboard.jsp");
        return;
    } else if (userRole == null || (!"Administrador".equals(userRole) && request.getRequestURI().contains("FormMetodosPagos.jsp"))) {
        response.sendRedirect("dashboard.jsp");
        return;
    } else if (userRole == null || (!"Administrador".equals(userRole) && request.getRequestURI().contains("FormProveedores.jsp"))) {
        response.sendRedirect("dashboard.jsp");
        return;
    } else if (userRole == null || (!"Administrador".equals(userRole) && request.getRequestURI().contains("FormUnidadMedidas.jsp"))) {
        response.sendRedirect("dashboard.jsp");
        return;
    } else if (userRole == null || (!"Administrador".equals(userRole) && request.getRequestURI().contains("FormIngredientes.jsp"))) {
        response.sendRedirect("dashboard.jsp");
        return;
    } else if (userRole == null || (!"Administrador".equals(userRole) && request.getRequestURI().contains("FormCategoriasProductos.jsp"))) {
        response.sendRedirect("dashboard.jsp");
        return;
    } else if (userRole == null || (!"Administrador".equals(userRole) && request.getRequestURI().contains("FormProductos.jsp"))) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
    if (userRole == null
            || ("Gerente".equals(userRole)
            && (request.getRequestURI().contains("FormCompras.jsp")
            || request.getRequestURI().contains("FormListadoCompras.jsp")))) {
        response.sendRedirect("dashboard.jsp");
        return;
    } else if (userRole == null
            || ("Gerente".equals(userRole)
            && (request.getRequestURI().contains("FormRecetas.jsp")
            || request.getRequestURI().contains("FormListadoRecetas.jsp")))) {
        response.sendRedirect("dashboard.jsp");
        return;
    } else if (userRole == null
            || ("Gerente".equals(userRole)
            && (request.getRequestURI().contains("FormPedidos.jsp")
            || request.getRequestURI().contains("FormListadoPedidos.jsp")))) {
        response.sendRedirect("dashboard.jsp");
        return;
    } else if (userRole == null
            || ("Gerente".equals(userRole)
            && (request.getRequestURI().contains("FormProduccion.jsp")
            || request.getRequestURI().contains("FormListadoProduccion.jsp")))) {
        response.sendRedirect("dashboard.jsp");
        return;
    } else if (userRole == null
            || ("Gerente".equals(userRole)
            && (request.getRequestURI().contains("FormVentas.jsp")
            || request.getRequestURI().contains("FormListadoVentas.jsp")))) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>


<!DOCTYPE html>
<html lang="es">

    <head>
        <meta charset="utf-8">
        <title>Dulces Mimos</title>
        <%
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");
            response.setHeader("X-XSS-Protection", "1; mode=block");
            response.setHeader("Content-Security-Policy", "script-src 'self'");
        %>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="" name="keywords">
        <meta content="" name="description">

        <!-- Favicon -->
        <link href="img/pasteleria.png" rel="icon">
        <link href="css/css2.css" rel="stylesheet">

        <!-- Icon Font Stylesheet -->

        <link href="css/webfonts.css" rel="stylesheet">

        <!-- Bootstrap CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <!-- Template Stylesheet -->
        <link href="css/style.css" rel="stylesheet">
        <link href="lib/bootstrap-select.min.css" rel="stylesheet">

        <!-- JavaScript Libraries -->
        <script src="js/jquery-3.7.1.min.js"></script>
        <script src="js/bootstrap.bundle.min.js"></script>
        <script src="lib/tempusdominus/js/moment.min.js"></script>
        <script src="lib/tempusdominus/js/moment-timezone.min.js"></script>
        <script src="lib/chart/chart.min.js"></script>
        <script src="lib/bootstrap-select.min.js"></script>
        <script src="js/index.global.js"></script>




        <style>
            #sidebar{
                scrollbar-width: none;
            }
            #sidebar::-webkit-scrollbar{
                display: none;
            }
            .content.shifted {
                margin-left: 18rem; 
            }
        </style>
    </head>
    <body style="display: flex; flex-direction: column; min-height: 100vh;">
        <div class="container-xxl position-relative bg-white d-flex p-0">
            <!-- Sidebar Start -->
            <div class="sidebar pb-5" id="sidebar">
                <nav class="navbar bg-light navbar-light flex-column align-items-center">
                    <a href="dashboard.jsp" class="navbar-brand mx-auto d-flex justify-content-center mb-3">
                        <h3 style="color: #ff007b" class="text-center">Dulces Mimos</h3>
                    </a>
                    <div class="d-flex align-items-center ms-4 mb-4">
                        <div class="position-relative">
                            <img class="rounded-circle" src="img/cocinar.png" alt="" style="width: 40px; height: 40px;">
                            <div class="bg-success rounded-circle border border-2 border-white position-absolute end-0 bottom-0 p-1"></div>
                        </div>
                        <div class="ms-3">
                            <h6 class="mb-0"><% out.print(sesion.getAttribute("usu_nombre")); %></h6>
                            <span><% out.print(sesion.getAttribute("rol_nombre")); %></span>
                        </div>
                    </div>
                    <br>
                    <div class="navbar-nav w-100">
                        <a href="dashboard.jsp" class="nav-item nav-link active" style="display: flex; align-items: center;">
                            <i class="fas fa-house" style="color: #ff007b; font-size: 1.5rem"></i>
                            <label style="display: flex; align-items: center;">Dashboard</label>
                        </a>
                        <br>
                        <% if ("Administrador".equals(userRole)) { %>
                        <!-- Mantenimiento -->
                        <div class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" data-bs-toggle="dropdown" style="align-items: center;">
                                <i class="fas fa-cogs m-1" style="color: #ff007b; font-size: 1.5rem;" id="i_menu"></i>
                                <label style="display: flex; align-items: center; width: 100%;">Mantenimiento</label>
                            </a>
                            <div class="dropdown-menu bg-transparent border-0">
                                <a href="FormRol.jsp" class="dropdown-item">Rol</a>
                                <a href="FormUsuarios.jsp" class="dropdown-item">Usuarios</a>
                                <a href="FormEmpleados.jsp" class="dropdown-item">Empleados</a>
                                <a href="FormClientes.jsp" class="dropdown-item">Clientes</a>
                                <a href="FormMetodosPagos.jsp" class="dropdown-item">Métodos De Pagos</a>
                                <a href="FormProveedores.jsp" class="dropdown-item">Proveedores</a>
                                <a href="FormUnidadMedidas.jsp" class="dropdown-item">Unidad De Medidas</a>
                                <a href="FormIngredientes.jsp" class="dropdown-item">Ingredientes</a>
                                <a href="FormCategoriasProductos.jsp" class="dropdown-item">Categoría De Productos</a>
                                <a href="FormProductos.jsp" class="dropdown-item">Productos</a>
                            </div>
                        </div>
                        <% } %>
                        <% if (!"Gerente".equals(userRole)) { %>
                        <!-- Módulo de Compras -->
                        <div class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" data-bs-toggle="dropdown" style="align-items: center;">
                                <i class="fas fa-shopping-basket m-1" style="color: #ff007b; font-size: 1.5rem;"></i>
                                <label style="display: flex; align-items: center; width: 100%;">Módulo De Compras</label>
                            </a>
                            <div class="dropdown-menu bg-transparent border-0">
                                <a href="FormCompras.jsp" class="dropdown-item"><b>Nueva Compra</b></a>
                                <a href="FormListadoCompras.jsp" class="dropdown-item">Listado De Compras</a>
                            </div>
                        </div>
                        <!-- Módulo de Producción -->
                        <div class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" data-bs-toggle="dropdown" style="align-items: center;">
                                <i class="fa-solid fa-tools m-1" style="color: #ff007b; font-size: 1.5rem;"></i>
                                <label style="display: flex; align-items: center; width: 100%;">Módulo De Producción</label>
                            </a>
                            <div class="dropdown-menu bg-transparent border-0">
                                <a href="FormRecetas.jsp" class="dropdown-item"><b>Nueva Receta</b></a>
                                <a href="FormListadoRecetas.jsp" class="dropdown-item">Listado De Recetas</a>
                                <a href="FormPedidos.jsp" class="dropdown-item"><b>Nuevo Pedido</b></a>
                                <a href="FormListadoPedidos.jsp" class="dropdown-item">Listado De Pedidos</a>
                                <a href="FormProduccion.jsp" class="dropdown-item"><b>Nueva Producción</b></a>
                                <a href="FormListadoProduccion.jsp" class="dropdown-item">Listado De Producción</a>
                            </div>
                        </div>
                        <!-- Módulo de Ventas -->
                        <div class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" data-bs-toggle="dropdown" style="align-items: center;">
                                <i class="fa-solid fa-cash-register m-1" style="color: #ff007b; font-size: 1.5rem;"></i>
                                <label style="display: flex; align-items: center; width: 100%;">Módulo De Ventas</label>
                            </a>
                            <div class="dropdown-menu bg-transparent border-0">
                                <a href="FormVentas.jsp" class="dropdown-item"><b>Nueva Venta</b></a>
                                <a href="FormListadoVentas.jsp" class="dropdown-item">Listado De Ventas</a>
                            </div>
                        </div>
                        <!-- Módulo de Finanzas -->
                        <div class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" data-bs-toggle="dropdown" style="align-items: center;">
                                <i class="fa-solid fa-money-bill-wave m-1" style="color: #ff007b; font-size: 1.5rem;"></i>
                                <label style="display: flex; align-items: center; width: 100%;">Módulo De Finanzas</label>
                            </a>
                            <div class="dropdown-menu bg-transparent border-0">
                                <a href="FormPagos.jsp" class="dropdown-item">Listado De Pagos</a>
                                <a href="FormCobros.jsp" class="dropdown-item">Listado De Cobros</a>
                            </div>
                        </div>
                        <% } %>
                        <% if ("Administrador".equals(userRole) || "Gerente".equals(userRole)) { %>
                        <!-- Informes -->
                        <div class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" data-bs-toggle="dropdown" style="align-items: center;">
                                <i class="fa-solid fa-file-pdf" style="color: #ff007b; font-size: 1.5rem;"></i>
                                <label style="display: flex; align-items: center; width: 100%;">Informes</label>
                            </a>
                            <div class="dropdown-menu bg-transparent border-0">
                                <a href="#" class="dropdown-item" data-bs-toggle="modal" data-bs-target="#modalCompras">Informes De Compras</a>
                                <a href="#" class="dropdown-item" data-bs-toggle="modal" data-bs-target="#modalRecetas">Informes De Recetas</a>
                                <a href="#" class="dropdown-item" data-bs-toggle="modal" data-bs-target="#modalPedidos">Informes De Pedidos</a>
                                <a href="#" class="dropdown-item" data-bs-toggle="modal" data-bs-target="#modalProduccion">Informes De Producción</a>
                                <a href="#" class="dropdown-item" data-bs-toggle="modal" data-bs-target="#modalVentas">Informes De Ventas</a>
                                <a href="#" class="dropdown-item" data-bs-toggle="modal" data-bs-target="#modalPagos">Informes De Pagos</a>
                                <a href="#" class="dropdown-item" data-bs-toggle="modal" data-bs-target="#modalCobros">Informes De Cobros</a>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </nav>
            </div>
            <!-- Sidebar End -->

            <!-- Content Start -->
            <div class="content">
                <!-- Navbar Start -->
                <nav class="navbar navbar-expand bg-light navbar-light sticky-top px-4 py-0">
                    <div class="navbar-nav align-items-center">
                        <a href="#" class="sidebar-toggler flex-shrink-0 mb-2" style="color: #ff007b;">
                            <i class="fa fa-bars" style="color: #ff007b; font-size: 22px"></i>
                        </a>
                    </div>

                    <div class="navbar-nav align-items-center ms-auto">
                        <div class="nav-item dropdown d-flex align-items-center">
                            <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" style="position: relative;" aria-expanded="false">
                                <i class="fa fa-bell me-lg-2" style="color: #ff007b; font-size: 22px; position: relative;">
                                    <span id="notification-count" style="background-color: white; color: #ff007b; font-size: 10px; border-radius: 50%; padding: 3px 6px; position: absolute; top: -5px; right: -10px; display: none;">0</span>
                                </i>
                                <span class="d-none d-lg-inline-flex">Notificaciones</span>
                            </a>
                            <div class="dropdown-menu dropdown-menu-end bg-light border-0 rounded-0 rounded-bottom m-0">
                                <div id="notificaciones" style="max-height: 300px; overflow-y: auto;">
                                    <a href="#" class="dropdown-item" id="mensaje_ingredientes" name="mensaje_ingredientes">Ingredientes</a>
                                    <a href="#" class="dropdown-item" id="mensaje_productos" name="mensaje_productos">Productos</a>
                                    <a href="#" class="dropdown-item" id="mensaje_pedidos" name="mensaje_pedidos">Pedidos</a>
                                    <a href="#" class="dropdown-item" id="mensaje_produccion" name="mensaje_produccion">Producción</a>
                                    <a href="#" class="dropdown-item" id="mensaje_pagos" name="mensaje_pagos">Pagos</a>
                                    <a href="#" class="dropdown-item" id="mensaje_cobros" name="mensaje_cobros">Cobros</a>
                                </div>
                            </div>
                        </div>
                        <div class="nav-item dropdown d-flex align-items-center">
                            <a class="nav-link dropdown-toggle" data-bs-toggle="dropdown" style="position: relative;" aria-expanded="false">
                                <i class="fa fa-bolt me-lg-2" style="color: #ff007b; font-size: 22px; position: relative;">
                                    <span id="notification-counts" style="background-color: white; color: #ff007b; font-size: 10px; border-radius: 50%; padding: 3px 6px; position: absolute; top: -5px; right: -10px; display: none;">0</span>
                                </i>
                                <span class="d-none d-lg-inline-flex">Avisos</span>
                            </a>
                            <div class="dropdown-menu dropdown-menu-end bg-light border-0 rounded-0 rounded-bottom m-0">
                                <div id="actualizar_Estado" style="max-height: 300px; overflow-y: auto;">

                                    <a href="#" class="dropdown-item" id="estado_pedidos" name="estado_pedidos" style="cursor: default;">Producción</a>
                                    <a href="#" class="dropdown-item" id="estado_pagos" name="estado_pagos" style="cursor: default;">Pagos</a>
                                    <a href="#" class="dropdown-item" id="estado_cobros" name="estado_cobros" style="cursor: default;">Cobros</a>
                                </div>
                            </div>
                        </div>

                        <div class="nav-item dropdown d-flex align-items-center ms-3">
                            <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
                                <img class="rounded-circle me-lg-2" src="img/cocinar.png" alt="" style="width: 40px; height: 40px;">
                                <span class="d-none d-lg-inline-flex"><% out.print(sesion.getAttribute("usu_nombre"));%></span>
                            </a>
                            <div class="dropdown-menu dropdown-menu-end bg-light border-0 rounded-0 rounded-bottom m-0">
                                <a href="#" class="dropdown-item" data-bs-toggle="modal" data-bs-target="#modalContraseña">Cambiar Contraseña</a>
                                <a href="JSP/Logout.jsp" class="dropdown-item" id="cerrarsesion" name="cerrarsesion">Cerrar Sesión</a>
                            </div>
                        </div>
                </nav>
                <!-- Modal para Informes de Compras -->
                <div class="modal fade" id="modalCompras" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="modalComprasLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content" style="background-color: #ffffff; border-radius: 0.25rem;">
                            <div class="modal-header" style="background-color: #ff007b; border-bottom: 1px solid #e9ecef;">
                                <h1 class="modal-title fs-5" id="modalComprasLabel" style="color: #ffffff;"><b>Informe De Compras</b></h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="color: #ffffff; opacity: 0.5;"></button>
                            </div>
                            <div class="modal-body" style="padding: 2rem; font-size: 1.1rem;">
                                <div class="mb-4">
                                    <label class="form-label">Fecha Desde:</label>
                                    <input type="date" class="form-control" id="fecha_desde" name="fecha_desde" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Fecha Hasta:</label>
                                    <input type="date" class="form-control" id="fecha_hasta" name="fecha_hasta" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Proveedor:</label>
                                    <select id="prov_informe" class="form-control" name="prov_informe" required>
                                    </select>                                
                                </div>

                            </div>
                            <div id="informes_compras">
                            </div>
                            <div class="modal-footer" style="background-color: #f8f9fa; border-top: 1px solid #e9ecef; display: flex; justify-content: center;">
                                <button type="button" class="btn btn-danger" id="btn-filtrar-compras" style="background-color: #ff007b; border-color: #ff007b; color: #000000; min-width: 100px;">Filtrar</button>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="color: #000000; border-color: #6c757d; min-width: 100px;">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Modal para Informe de Recetas -->
                <div class="modal fade" id="modalRecetas" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="modalRecetasLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content" style="background-color: #ffffff; border-radius: 0.25rem;">
                            <div class="modal-header" style="background-color: #ff007b; border-bottom: 1px solid #e9ecef;">
                                <h1 class="modal-title fs-5" id="modalRecetasLabel" style="color: #ffffff;"><b>Informe De Recetas</b></h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="color: #ffffff; opacity: 0.5;"></button>
                            </div>
                            <div class="modal-body" style="padding: 2rem; font-size: 1.1rem;">
                                <div class="mb-4">
                                    <label class="form-label">Fecha Desde:</label>
                                    <input type="date" class="form-control" id="fecha_desde_receta" name="fecha_desde_receta" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Fecha Hasta:</label>
                                    <input type="date" class="form-control" id="fecha_hasta_receta" name="fecha_hasta_receta" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Empleado:</label>
                                    <select id="informe_empleado" class="form-control" name="informe_empleado" required>
                                        <option value="">Seleccione un Empleado</option>
                                    </select>
                                </div>
                            </div>
                            <div id="informes_recetas">
                            </div>
                            <div class="modal-footer" style="background-color: #f8f9fa; border-top: 1px solid #e9ecef; display: flex; justify-content: center;">
                                <button type="button" class="btn btn-danger" id="btn-filtrar-recetas"  style="background-color: #ff007b; border-color: #ff007b; color: #000000; min-width: 100px;">Filtrar</button>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="color: #000000; border-color: #6c757d; min-width: 100px;">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Modal para Informe de Pedidos -->
                <div class="modal fade" id="modalPedidos" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="modalPedidosLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content" style="background-color: #ffffff; border-radius: 0.25rem;">
                            <div class="modal-header" style="background-color: #ff007b; border-bottom: 1px solid #e9ecef;">
                                <h1 class="modal-title fs-5" id="modalPedidosLabel" style="color: #ffffff;"><b>Informe De Pedidos</b></h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="color: #ffffff; opacity: 0.5;"></button>
                            </div>
                            <div class="modal-body" style="padding: 2rem; font-size: 1.1rem;">
                                <div class="mb-4">
                                    <label class="form-label">Fecha Desde:</label>
                                    <input type="date" class="form-control" id="fecha_desde_pedidos" name="fecha_desde_pedidos" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Fecha Hasta:</label>
                                    <input type="date" class="form-control" id="fecha_hasta_pedidos" name="fecha_hasta_pedidos" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Cliente:</label>
                                    <select id="cli_informe" class="form-control" name="cli_informe" required>
                                        <option value="">Seleccione un Cliente</option>
                                    </select>
                                </div>
                            </div>
                            <div id="informes_pedidos">
                            </div>
                            <div class="modal-footer" style="background-color: #f8f9fa; border-top: 1px solid #e9ecef; display: flex; justify-content: center;">
                                <button type="button" class="btn btn-danger" id="btn-filtrar-pedidos" style="background-color: #ff007b; border-color: #ff007b; color: #000000; min-width: 100px;">Filtrar</button>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="color: #000000; border-color: #6c757d; min-width: 100px;">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Modal para Informe de Producción -->
                <div class="modal fade" id="modalProduccion" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="modalProduccionLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content" style="background-color: #ffffff; border-radius: 0.25rem;">
                            <div class="modal-header" style="background-color: #ff007b; border-bottom: 1px solid #e9ecef;">
                                <h1 class="modal-title fs-5" id="modalProduccionLabel" style="color: #ffffff;"><b>Informe De Producción</b></h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="color: #ffffff; opacity: 0.5;"></button>
                            </div>
                            <div class="modal-body" style="padding: 2rem; font-size: 1.1rem;">
                                <div class="mb-4">
                                    <label class="form-label">Fecha Desde:</label>
                                    <input type="date" class="form-control" id="fecha_desde_produccion" name="fecha_desde_produccion" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Fecha Hasta:</label>
                                    <input type="date" class="form-control" id="fecha_hasta_produccion" name="fecha_hasta_produccion" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Receta:</label>
                                    <select id="produc_informe" class="form-control" name="produc_informe" required>
                                        <option value="">Seleccione una Receta</option>
                                    </select>
                                </div>
                            </div>
                            <div id="informes_produccion">
                            </div>
                            <div class="modal-footer" style="background-color: #f8f9fa; border-top: 1px solid #e9ecef; display: flex; justify-content: center;">
                                <button type="button" class="btn btn-danger" id="btn-filtrar-produccion"  style="background-color: #ff007b; border-color: #ff007b; color: #000000; min-width: 100px;">Filtrar</button>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="color: #000000; border-color: #6c757d; min-width: 100px;">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Modal para Informe de Ventas -->
                <div class="modal fade" id="modalVentas" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="modalVentasLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content" style="background-color: #ffffff; border-radius: 0.25rem;">
                            <div class="modal-header" style="background-color: #ff007b; border-bottom: 1px solid #e9ecef;">
                                <h1 class="modal-title fs-5" id="modalVentasLabel" style="color: #ffffff;"><b>Informe De Ventas</b></h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="color: #ffffff; opacity: 0.5;"></button>
                            </div>
                            <div class="modal-body" style="padding: 2rem; font-size: 1.1rem;">
                                <div class="mb-4">
                                    <label class="form-label">Fecha Desde:</label>
                                    <input type="date" class="form-control" id="fecha_desde_ventas" name="fecha_desde_ventas" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Fecha Hasta:</label>
                                    <input type="date" class="form-control" id="fecha_hasta_ventas" name="fecha_hasta_ventas" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Cliente:</label>
                                    <select id="informe_cliente" class="form-control" name="informe_cliente" required>
                                        <option value="">Seleccione un Cliente</option>
                                    </select>
                                </div>
                            </div>
                            <div id="informes_ventas">
                            </div>
                            <div class="modal-footer" style="background-color: #f8f9fa; border-top: 1px solid #e9ecef; display: flex; justify-content: center;">
                                <button type="button" class="btn btn-danger" id="btn-filtrar-ventas"  style="background-color: #ff007b; border-color: #ff007b; color: #000000; min-width: 100px;">Filtrar</button>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="color: #000000; border-color: #6c757d; min-width: 100px;">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Modal para Informe de Pagos -->
                <div class="modal fade" id="modalPagos" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="modalPagosLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content" style="background-color: #ffffff; border-radius: 0.25rem;">
                            <div class="modal-header" style="background-color: #ff007b; border-bottom: 1px solid #e9ecef;">
                                <h1 class="modal-title fs-5" id="modalPagosLabel" style="color: #ffffff;"><b>Informe De Pagos</b></h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="color: #ffffff; opacity: 0.5;"></button>
                            </div>
                            <div class="modal-body" style="padding: 2rem; font-size: 1.1rem;">
                                <div class="mb-4">
                                    <label class="form-label">Fecha Desde:</label>
                                    <input type="date" class="form-control" id="fecha_desde_pagos" name="fecha_desde_pagos" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Fecha Hasta:</label>
                                    <input type="date" class="form-control" id="fecha_hasta_pagos" name="fecha_hasta_pagos" required>
                                </div>
                            </div>
                            <div id="informes_pagos">
                            </div>
                            <div class="modal-footer" style="background-color: #f8f9fa; border-top: 1px solid #e9ecef; display: flex; justify-content: center;">
                                <button type="button" class="btn btn-danger" id="btn-filtrar-pagos"  style="background-color: #ff007b; border-color: #ff007b; color: #000000; min-width: 100px;">Filtrar</button>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="color: #000000; border-color: #6c757d; min-width: 100px;">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Modal para Informe de Cobros -->
                <div class="modal fade" id="modalCobros" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="modalCobrosLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content" style="background-color: #ffffff; border-radius: 0.25rem;">
                            <div class="modal-header" style="background-color: #ff007b; border-bottom: 1px solid #e9ecef;">
                                <h1 class="modal-title fs-5"  style="color: #ffffff;"><b>Informe De Cobros</b></h1>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="color: #ffffff; opacity: 0.5;"></button>
                            </div>
                            <div class="modal-body" style="padding: 2rem; font-size: 1.1rem;">
                                <div class="mb-4">
                                    <label class="form-label">Fecha Desde:</label>
                                    <input type="date" class="form-control" id="fecha_desde_cobros" name="fecha_desde_cobros" required>
                                </div>
                                <div class="mb-4">
                                    <label class="form-label">Fecha Hasta:</label>
                                    <input type="date" class="form-control" id="fecha_hasta_cobros" name="fecha_hasta_cobros" required>
                                </div>
                            </div>
                            <div id="informes_cobros">
                            </div>
                            <div class="modal-footer" style="background-color: #f8f9fa; border-top: 1px solid #e9ecef; display: flex; justify-content: center;">
                                <button type="button" class="btn btn-danger" id="btn-filtrar-cobros"  style="background-color: #ff007b; border-color: #ff007b; color: #000000; min-width: 100px;">Filtrar</button>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="color: #000000; border-color: #6c757d; min-width: 100px;">Cerrar</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Modal para  de Contraseña -->
                <div class="modal fade" id="modalContraseña" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="modal" aria-hidden="true">
                    <div class="modal-dialog">
                        <form id="nuevacontraseña">
                            <input type="hidden" name="action" id="action" value="modificar">
                            <div class="modal-content" style="background-color: #ffffff; border-radius: 0.25rem;">
                                <div class="modal-header" style="background-color: #ff007b; border-bottom: 1px solid #e9ecef;">
                                    <h1 class="modal-title fs-5"  style="color: #ffffff;"><b>Cambiar Contraseña</b></h1>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="color: #ffffff; opacity: 0.5;"></button>
                                </div>
                                <div class="modal-body" style="padding: 2rem; font-size: 1.1rem;">
                                    <div class="mb-4">
                                        <label class="form-label">Ingrese su Nueva Contraseña:</label>
                                        <br>
                                        <span id="indicios" style="display: none; color: gray;">La contraseña debe tener al menos una letra mayúscula, una letra minúscula, un número y un carácter especial.</span>
                                        <input type="text" class="form-control" id="nueva_contraseña" name="nueva_contraseña" required>
                                        <span id="fuerzacontraseñas" style="display: none;"></span>
                                    </div>

                                </div>
                                <div id="contraseña_mensaje">
                                </div>
                                <div class="modal-footer" style="background-color: #f8f9fa; border-top: 1px solid #e9ecef; display: flex; justify-content: center;">
                                    <button type="button" class="btn btn-danger" id="btn-nuevacontraseña"  style="background-color: #ff007b; border-color: #ff007b; color: #000000; min-width: 100px;">Modificar Contraseña</button>
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="color: #000000; border-color: #6c757d; min-width: 100px;">Cerrar</button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <script>
    $(document).ready(function () {
        contarDatos();
        ActualizarEstados();
        setInterval(contarDatos, 5000);
        setInterval(ActualizarEstados, 5000);
        $('#modalCompras').on('show.bs.modal', function () {
            CargarInformeProveedor();
        });
        $('#modalRecetas').on('show.bs.modal', function () {
            CargarInformeEmpleado();
        });
        $('#modalPedidos').on('show.bs.modal', function () {
            CargarInformeClientePedido();
        });
        $('#modalProduccion').on('show.bs.modal', function () {
            CargarInformeRecetas();
        });
        $('#modalVentas').on('show.bs.modal', function () {
            CargarInformeCliente();
        });
    });
    function CargarInformeCliente() {
        $.ajax({
            data: {listar: 'CargarInformeCliente'},
            url: "JSP/Modales.jsp",
            type: "post",
            success: function (response) {
                $("#informe_cliente").html(response);
            },
            error: function (error) {
                console.error("Error al cargar los clientes:", error);
                $("#informe_cliente").html('<option value="">¡Error al cargar los clientes!</option>');
            }
        });
    }
    function CargarInformeEmpleado() {
        $.ajax({
            data: {listar: 'CargarInformeEmpleado'},
            url: "JSP/Modales.jsp",
            type: "post",
            success: function (response) {
                $("#informe_empleado").html(response);
            },
            error: function (error) {
                console.error("Error al cargar los empleados:", error);
                $("#informe_empleado").html('<option value="">¡Error al cargar los Empleados!</option>');
            }
        });
    }
    function CargarInformeRecetas() {
        $.ajax({
            data: {listar: 'CargarInformeRecetas'},
            url: "JSP/Modales.jsp",
            type: "post",
            success: function (response) {
                $("#produc_informe").html(response);
            },
            error: function (error) {
                console.error("Error al cargar las recetas:", error);
                $("#produc_informe").html('<option value="">¡Error al cargar las Recetas!</option>');
            }
        });
    }
    function CargarInformeProveedor() {
        $.ajax({
            data: {listar: 'CargarInformeProveedor'},
            url: "JSP/Modales.jsp",
            type: "post",
            success: function (response) {
                $("#prov_informe").html(response);
            },
            error: function (error) {
                console.error("Error al cargar los proveedores:", error);
                $("#prov_informe").html('<option value="">¡Error al cargar los Proveedores!</option>');
            }
        });
    }
    function CargarInformeClientePedido() {
        $.ajax({
            data: {listar: 'CargarInformeClientePedido'},
            url: "JSP/Modales.jsp",
            type: "post",
            success: function (response) {
                $("#cli_informe").html(response);
            },
            error: function (error) {
                console.error("Error al cargar los clientes:", error);
                $("#cli_informe").html('<option value="">¡Error al cargar los Clientes!</option>');
            }
        });
    }

    $("#nueva_contraseña").on('focus', function () {
        $("#indicios").show();
    });
    $("#nueva_contraseña").on('blur', function () {
        $("#indicios").hide();
    });
    $("#nueva_contraseña").on('input', function () {
        this.value = this.value.slice(0, 10);
        password = $(this).val();
        fuerzacontraseña = $("#fuerzacontraseñas");


        if (password.length >= 8 && /[a-z]/.test(password) && /[A-Z]/.test(password) && /\d/.test(password) && /[@$!%*?&]/.test(password)) {
            fuerzacontraseñas.text("Fuerte").removeClass().addClass("strong");
        } else if (password.length >= 6 && ((/[a-z]/.test(password) && /[A-Z]/.test(password)) || (/\d/.test(password) && /[@$!%*?&]/.test(password)))) {
            fuerzacontraseña.text("Media").removeClass().addClass("medium");
        } else {
            fuerzacontraseñas.text("Débil").removeClass().addClass("weak");
        }

        if (password.length > 0) {
            fuerzacontraseñas.show();
        } else {
            fuerzacontraseñas.hide();
        }
    });
    $("#btn-nuevacontraseña").on("click", function () {
        nueva_contraseña = $("#nueva_contraseña").val();
        if (nueva_contraseña.trim() === "") {
            $("#contraseña_mensaje").html('<div class="alert alert-danger" role="alert">¡La contraseña no puede estar vacía!</div>');
            return;
        }
        formData = $("#nuevacontraseña").serialize();
        $.ajax({
            data: formData,
            url: "JSP/Contraseña.jsp",
            type: "post",
            success: function (response) {
                $("#contraseña_mensaje").html(response);
                if (response.includes("success")) {
                    setTimeout(function () {
                        $("#modalContraseña").modal("hide");
                        $("#nuevacontraseña")[0].reset();
                    }, 2000);
                }
            },
            error: function () {
                $("#contraseña_mensaje").html('<div class="alert alert-danger" role="alert">¡Error al actualizar la contraseña!</div>');
            }
        });
    });


    $("#btn-filtrar-compras").on("click", function (e) {
        e.preventDefault();
        fecha_desde = $("#fecha_desde").val();
        fecha_hasta = $("#fecha_hasta").val();
        prov_informe = $("#prov_informe").val();

        if (fecha_desde !== "" && fecha_hasta !== "") {
            $.ajax({
                url: 'InformesJSP/InformeCompras.jsp',
                type: 'post',
                data: {
                    fecha_desde: fecha_desde,
                    fecha_hasta: fecha_hasta,
                    prov_informe: prov_informe
                },
                success: function (response) {
                    if (response.trim() === "NO_DATOS") {
                        $("#informes_compras").html("<div class='alert alert-warning' role='alert'>No hay compras disponibles según los datos cargados. Intente nuevamente. </div>");
                        $("#informes_compras").fadeIn();
                        setTimeout(function () {
                            $("#informes_compras").fadeOut();
                        }, 2000);
                        $("#fecha_desde").val("");
                        $("#fecha_hasta").val("");
                        $("#prov_informe").val("");

                    } else {
                        const url = 'InformesJSP/InformeCompras.jsp?fecha_desde=' + encodeURIComponent(fecha_desde) +
                                '&fecha_hasta=' + encodeURIComponent(fecha_hasta) +
                                '&prov_informe=' + encodeURIComponent(prov_informe);
                        window.open(url, '_blank');
                        $("#fecha_desde").val("");
                        $("#fecha_hasta").val("");
                        $("#prov_informe").val("");

                    }
                },
                error: function () {
                    $("#informes_compras").html("<div class='alert alert-danger' role='alert'>Error al generar el informe. Intente nuevamente.</div>");
                    $("#informes_compras").fadeIn();
                    setTimeout(function () {
                        $("#informes_compras").fadeOut();
                    }, 2000);
                }
            });
        } else {
            $("#informes_compras").html("<div class='alert alert-danger' role='alert'>Por Favor, seleccione ambas fechas.</div>");
            $("#informes_compras").fadeIn();
            setTimeout(function () {
                $("#informes_compras").fadeOut();
            }, 2000);
        }
    });
    $("#btn-filtrar-recetas").on("click", function (e) {
        e.preventDefault();
        fecha_desde = $("#fecha_desde_receta").val();
        fecha_hasta = $("#fecha_hasta_receta").val();
        empleado_id = $("#informe_empleado").val();

        if (fecha_desde !== "" && fecha_hasta !== "") {
            $.ajax({
                url: 'InformesJSP/InformeRecetas.jsp',
                type: 'GET',
                data: {
                    fecha_desde: fecha_desde,
                    fecha_hasta: fecha_hasta,
                    empleado_id: empleado_id
                },
                success: function (response) {
                    if (response.trim() === "NO_DATOS") {
                        $("#informes_recetas").html("<div class='alert alert-warning' role='alert'>No hay recetas disponibles según los datos cargados. Intente nuevamente.</div>");
                        $("#informes_recetas").fadeIn();
                        setTimeout(function () {
                            $("#informes_recetas").fadeOut();
                        }, 2000);
                    } else {
                        const url = 'InformesJSP/InformeRecetas.jsp?fecha_desde=' + encodeURIComponent(fecha_desde) +
                                '&fecha_hasta=' + encodeURIComponent(fecha_hasta) +
                                '&empleado_id=' + encodeURIComponent(empleado_id);
                        window.open(url, '_blank');
                    }

                    $("#fecha_desde_receta").val("");
                    $("#fecha_hasta_receta").val("");
                    $("#informe_empleado").val("");
                },
                error: function () {
                    $("#informes_recetas").html("<div class='alert alert-danger' role='alert'>Error al generar el informe. Intente nuevamente.</div>");
                    $("#informes_recetas").fadeIn();
                    setTimeout(function () {
                        $("#informes_recetas").fadeOut();
                    }, 2000);

                    $("#fecha_desde_receta").val("");
                    $("#fecha_hasta_receta").val("");
                    $("#informe_empleado").val("");
                }
            });
        } else {
            $("#informes_recetas").html("<div class='alert alert-danger' role='alert'>Por favor, seleccione ambas fechas.</div>");
            $("#informes_recetas").fadeIn();
            setTimeout(function () {
                $("#informes_recetas").fadeOut();
            }, 2000);
            $("#fecha_desde_receta").val("");
            $("#fecha_hasta_receta").val("");
            $("#informe_empleado").val("");
        }
    });


    $("#btn-filtrar-pedidos").on("click", function (e) {
        e.preventDefault();


        fecha_desde_pedidos = $("#fecha_desde_pedidos").val();
        fecha_hasta_pedidos = $("#fecha_hasta_pedidos").val();
        cli_informe = $("#cli_informe").val();

        if (fecha_desde_pedidos !== "" && fecha_hasta_pedidos !== "") {
            $.ajax({
                url: 'InformesJSP/InformePedidos.jsp',
                type: 'GET',
                data: {
                    fecha_desde_pedidos: fecha_desde_pedidos,
                    fecha_hasta_pedidos: fecha_hasta_pedidos,
                    cli_informe: cli_informe
                },
                success: function (response) {
                    if (response.trim() === "NO_DATOS") {
                        $("#informes_pedidos").html("<div class='alert alert-warning' role='alert'>No hay datos disponibles para el rango de fechas seleccionado. Por favor, ingrese otro rango de fechas.</div>");
                        $("#informes_pedidos").fadeIn();
                        setTimeout(function () {
                            $("#informes_pedidos").fadeOut();
                            $("#fecha_desde_pedidos").val("");
                            $("#fecha_hasta_pedidos").val("");
                            $("#cli_informe").val("");
                            $("#cli_informe").selectpicker("refresh");
                        }, 2000);
                    } else {
                        url = 'InformesJSP/InformePedidos.jsp?fecha_desde_pedidos=' + encodeURIComponent(fecha_desde_pedidos) +
                                '&fecha_hasta_pedidos=' + encodeURIComponent(fecha_hasta_pedidos) +
                                '&cli_informe=' + encodeURIComponent(cli_informe);
                        window.open(url, '_blank');
                        $("#fecha_desde_pedidos").val("");
                        $("#fecha_hasta_pedidos").val("");
                        $("#cli_informe").val("");
                        $("#cli_informe").selectpicker("refresh");
                    }
                },
                error: function () {
                    $("#informes_pedidos").html("<div class='alert alert-danger' role='alert'>Error al generar el informe. Intente nuevamente.</div>");
                    $("#informes_pedidos").fadeIn();
                    setTimeout(function () {
                        $("#informes_pedidos").fadeOut();
                    }, 2000);
                }
            });
        } else {
            $("#informes_pedidos").html("<div class='alert alert-danger' role='alert'>Por favor, seleccione ambas fechas</div>");
            $("#informes_pedidos").fadeIn();
            setTimeout(function () {
                $("#informes_pedidos").fadeOut();
            }, 2000);
        }
    });

    $("#btn-filtrar-produccion").on("click", function (e) {
        e.preventDefault();
        fecha_desde_produccion = $("#fecha_desde_produccion").val();
        fecha_hasta_produccion = $("#fecha_hasta_produccion").val();
        produc_informe = $("#produc_informe").val();
        if (fecha_desde_produccion !== "" && fecha_hasta_produccion !== "") {
            $.ajax({
                url: 'InformesJSP/InformeProduccion.jsp',
                type: 'GET',
                data: {
                    fecha_desde_produccion: fecha_desde_produccion,
                    fecha_hasta_produccion: fecha_hasta_produccion,
                    produc_informe: produc_informe
                },
                success: function (response) {
                    if (response.trim() === "NO_DATOS") {

                        $("#informes_produccion").html("<div class='alert alert-warning' role='alert'>No hay datos disponibles para el rango de fechas y receta seleccionado. Por favor, ingrese otro rango de fechas.</div>");
                        $("#informes_produccion").fadeIn();
                        setTimeout(function () {
                            $("#informes_produccion").fadeOut();
                            $("#fecha_desde_produccion").val("");
                            $("#fecha_hasta_produccion").val("");
                            $("#produc_informe").val("");
                        }, 2000);
                    } else {

                        url = 'InformesJSP/InformeProduccion.jsp?fecha_desde_produccion=' + encodeURIComponent(fecha_desde_produccion) +
                                '&fecha_hasta_produccion=' + encodeURIComponent(fecha_hasta_produccion) +
                                '&produc_informe=' + encodeURIComponent(produc_informe);
                        window.open(url, '_blank');

                        $("#fecha_desde_produccion").val("");
                        $("#fecha_hasta_produccion").val("");
                        $("#produc_informe").val("");
                        $("#produc_informe").selectpicker("refresh");
                    }
                },
                error: function () {

                    $("#informes_produccion").html("<div class='alert alert-danger' role='alert'>Error al generar el informe. Intente nuevamente.</div>");
                    $("#informes_produccion").fadeIn();
                    setTimeout(function () {
                        $("#informes_produccion").fadeOut();
                    }, 3000);
                }
            });
        } else {

            $("#informes_produccion").html("<div class='alert alert-danger' role='alert'>Por favor, seleccione ambas fechas y un producto.</div>");
            $("#informes_produccion").fadeIn();
            setTimeout(function () {
                $("#informes_produccion").fadeOut();
            }, 2000);
        }
    });

// Filtrar para el modal de ventas
    $("#btn-filtrar-ventas").on("click", function (e) {
        e.preventDefault();
        fecha_desde_ventas = $("#fecha_desde_ventas").val();
        fecha_hasta_ventas = $("#fecha_hasta_ventas").val();
        informe_cliente = $("#informe_cliente").val();

        // Verificar que las fechas sean seleccionadas
        if (fecha_desde_ventas !== "" && fecha_hasta_ventas !== "") {
            $.ajax({
                url: 'InformesJSP/InformeVentas.jsp',
                type: 'GET',
                data: {
                    fecha_desde_ventas: fecha_desde_ventas,
                    fecha_hasta_ventas: fecha_hasta_ventas,
                    informe_cliente: informe_cliente
                },
                success: function (response) {
                    if (response.trim() === "NO_DATOS") {
                        $("#informes_ventas").html("<div class='alert alert-warning' role='alert'>No hay datos disponibles para el rango de fechas seleccionado. Por favor, ingrese otro rango de fechas.</div>");
                        $("#informes_ventas").fadeIn();
                        setTimeout(function () {
                            $("#informes_ventas").fadeOut();
                            $("#fecha_desde_ventas").val("");
                            $("#fecha_hasta_ventas").val("");
                            $("#informe_cliente").val("");
                        }, 2000);
                    } else {

                        url = 'InformesJSP/InformeVentas.jsp?fecha_desde_ventas=' + encodeURIComponent(fecha_desde_ventas) +
                                '&fecha_hasta_ventas=' + encodeURIComponent(fecha_hasta_ventas) +
                                '&informe_cliente=' + encodeURIComponent(informe_cliente);
                        window.open(url, '_blank');

                        $("#fecha_desde_ventas").val("");
                        $("#fecha_hasta_ventas").val("");
                        $("#informe_cliente").val("");
                    }
                },
                error: function () {
                    $("#informes_ventas").html("<div class='alert alert-danger' role='alert'>Error al generar el informe. Intente nuevamente.</div>");
                    $("#informes_ventas").fadeIn();
                    setTimeout(function () {
                        $("#informes_ventas").fadeOut();
                    }, 2000);
                }
            });
        } else {
            $("#informes_ventas").html("<div class='alert alert-danger' role='alert'>Por favor, seleccione ambas fechas</div>");
            $("#informes_ventas").fadeIn();
            setTimeout(function () {
                $("#informes_ventas").fadeOut();
            }, 2000);
        }
    });

// Filtrar para el modal de pagos
    $("#btn-filtrar-pagos").on("click", function (e) {
        e.preventDefault();
        fecha_desde_pagos = $("#fecha_desde_pagos").val();
        fecha_hasta_pagos = $("#fecha_hasta_pagos").val();

        if (fecha_desde_pagos !== "" && fecha_hasta_pagos !== "") {
            $.ajax({
                url: 'InformesJSP/InformePagos.jsp',
                type: 'GET',
                data: {
                    fecha_desde_pagos: fecha_desde_pagos,
                    fecha_hasta_pagos: fecha_hasta_pagos
                },
                success: function (response) {
                    if (response.trim() === "NO_DATOS") {
                        $("#informes_pagos").html("<div class='alert alert-warning' role='alert'>No hay datos disponibles para el rango de fechas seleccionado. Por favor, ingrese otro rango de fechas.</div>");
                        $("#informes_pagos").fadeIn();
                        setTimeout(function () {
                            $("#informes_pagos").fadeOut();
                            $("#fecha_desde_pagos").val("");
                            $("#fecha_hasta_pagos").val("");
                        }, 2000);
                    } else {
                        url = 'InformesJSP/InformePagos.jsp?fecha_desde_pagos=' + encodeURIComponent(fecha_desde_pagos) + '&fecha_hasta_pagos=' + encodeURIComponent(fecha_hasta_pagos);
                        window.open(url, '_blank');
                        $("#fecha_desde_pagos").val("");
                        $("#fecha_hasta_pagos").val("");
                    }
                },
                error: function () {
                    $("#informes_pagos").html("<div class='alert alert-danger' role='alert'>Error al generar el informe. Intente nuevamente.</div>");
                    $("#informes_pagos").fadeIn();
                    setTimeout(function () {
                        $("#informes_pagos").fadeOut();
                    }, 2000);
                }
            });
        } else {
            $("#informes_pagos").html("<div class='alert alert-danger' role='alert'>Por favor, seleccione ambas fechas</div>");
            $("#informes_pagos").fadeIn();
            setTimeout(function () {
                $("#informes_pagos").fadeOut();
            }, 2000);
        }
    });

    $("#btn-filtrar-cobros").on("click", function (e) {
        e.preventDefault();
        fechaDesde = $("#fecha_desde_cobros").val();
        fechaHasta = $("#fecha_hasta_cobros").val();

        if (fechaDesde !== "" && fechaHasta !== "") {
            $.ajax({
                url: 'InformesJSP/InformeCobros.jsp',
                type: 'GET',
                data: {
                    fecha_desde_cobros: fechaDesde,
                    fecha_hasta_cobros: fechaHasta
                },
                success: function (response) {
                    if (response.trim() === "NO_DATOS") {
                        $("#informes_cobros").html("<div class='alert alert-warning' role='alert'>No hay datos disponibles para el rango de fechas seleccionado. Por favor, ingrese otro rango de fechas.</div>");
                        $("#informes_cobros").fadeIn();
                        setTimeout(function () {
                            $("#informes_cobros").fadeOut();
                            $("#fecha_desde_cobros").val("");
                            $("#fecha_hasta_cobros").val("");
                        }, 2000);
                    } else {
                        url = 'InformesJSP/InformeCobros.jsp?fecha_desde_cobros=' + encodeURIComponent(fechaDesde) + '&fecha_hasta_cobros=' + encodeURIComponent(fechaHasta);
                        window.open(url, '_blank');
                        $("#fecha_desde_cobros").val("");
                        $("#fecha_hasta_cobros").val("");
                    }
                },
                error: function () {
                    $("#informes_cobros").html("<div class='alert alert-danger' role='alert'>Error al generar el informe. Intente nuevamente.</div>");
                    $("#informes_cobros").fadeIn();
                    setTimeout(function () {
                        $("#informes_cobros").fadeOut();
                    }, 2000);
                }
            });
        } else {
            $("#informes_cobros").html("<div class='alert alert-danger' role='alert'>Por favor, seleccione ambas fechas</div>");
            $("#informes_cobros").fadeIn();
            setTimeout(function () {
                $("#informes_cobros").fadeOut();
            }, 2000);
        }
    });

    function ActualizarEstados() {
        tipos = [
            'actualizarEstadoPedidos',
            'actualizarEstadoPagos',
            'actualizarEstadoCobros'
        ];
        tipos.forEach(tipo => {
            $.ajax({
                data: {listar: tipo},
                url: 'JSP/Estados.jsp',
                type: 'post',
                success: function (response) {
                    switch (tipo) {
                        case 'actualizarEstadoPedidos':
                            $("#estado_pedidos").html(response);
                            break;

                        case 'actualizarEstadoPagos':
                            $("#estado_pagos").html(response);
                            break;
                        case 'actualizarEstadoCobros':
                            $("#estado_cobros").html(response);
                            break;

                    }
                    actualizarConteo();
                },
                error: function (xhr, status, error) {
                    console.error("Error en la llamada AJAX: ", error);
                }
            });
        });
    }

    function actualizarConteo() {
        estadopedidos = $("#estado_pedidos .alert").length;
        estadopagos = $("#estado_pagos .alert").length;
        estadocobros = $("#estado_cobros .alert").length;

        totalNotificacion = estadopedidos + estadopagos + estadocobros;

        if (totalNotificacion > 0) {
            $("#notification-counts").text(totalNotificacion).show();
        } else {
            $("#notification-counts").hide();
        }
    }

    function contarDatos() {
        tipos = [
            'contarIngredientes',
            'contarStockProductos',
            'pedidosProximos',
            'produccionProxima',
            'conteoRegresivoPago',
            'conteoRegresivoCobros'
        ];

        tipos.forEach(tipo => {
            $.ajax({
                data: {listar: tipo},
                url: 'JSP/Dashboard.jsp',
                type: 'post',
                success: function (response) {
                    switch (tipo) {
                        case 'contarIngredientes':
                            $("#mensaje_ingredientes").html(response);
                            break;
                        case 'contarStockProductos':
                            $("#mensaje_productos").html(response);
                            break;
                        case 'pedidosProximos':
                            $("#mensaje_pedidos").html(response);
                            break;
                        case 'produccionProxima':
                            $("#mensaje_produccion").html(response);
                            break;
                        case 'conteoRegresivoPago':
                            $("#mensaje_pagos").html(response);
                            break;
                        case 'conteoRegresivoCobros':
                            $("#mensaje_cobros").html(response);
                            break;

                    }
                    actualizarConteoNotificaciones();
                },
                error: function (xhr, status, error) {
                    console.error("Error en la llamada AJAX: ", error);
                }
            });
        });
    }

    function actualizarConteoNotificaciones() {
        numIngredientes = $("#mensaje_ingredientes .alert").length;
        numProductos = $("#mensaje_productos .alert").length;
        numPedidos = $("#mensaje_pedidos .alert").length;
        numProduccion = $("#mensaje_produccion .alert").length;
        numPagosPendientes = $("#mensaje_pagos .alert").length;
        numCobrosPendientes = $("#mensaje_cobros .alert").length;

        totalNotificaciones = numIngredientes + numProductos + numPedidos + numProduccion + numPagosPendientes + numCobrosPendientes;

        if (totalNotificaciones > 0) {
            $("#notification-count").text(totalNotificaciones).show();
        } else {
            $("#notification-count").hide();
        }
    }

                </script>


