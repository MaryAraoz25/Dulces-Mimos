<%-- 
    Document   : FormProduccion
    Created on : 24 jun. 2024, 21:05:58
    Author     : Maria
--%>
<%@ include file="header.jsp"%>
<%
    String emple_nombre = (String) sesion.getAttribute("emple_nombre");
%>
<style>
    .card-header {
        background-color: #ff007b;
        color: white;
    }
    .card:hover {
        transform: none;
        transition: none;
    }

    /* Opcionalmente, desactiva cualquier transición en general */
    .card {
        transition: none;
    }
</style>
<div class="container-fluid">
    <div class="row">
        <div class="col-11 mx-auto d-block mt-3">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Gestión De Producción</h5>
                </div>
                <div class="card-body">
                    <form id="form">
                        <div class="row">
                            <div class="col-md-6">
                                <input type="hidden" name="listar" id="listar" value="cargar">
                                <input type="hidden" name="idproduccion" id="idproduccion">
                                <div class="mb-3">
                                    <label for="fecha_elaboracion" class="form-label"><b>Fecha De Elaboración</b></label>
                                    <input type="date" class="form-control form-control-sm" id="fecha_elaboracion" name="fecha_elaboracion" required readonly>
                                </div>
                                <div class="mb-3">
                                    <label for="fecha_vencimiento" class="form-label"><b>Fecha De Vencimiento</b></label>
                                    <input type="date" class="form-control form-control-sm" id="fecha_vencimiento" name="fecha_vencimiento" required>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="empleados_id" class="form-label"><b>Empleado</b></label>
                                    <input type="text" class="form-control form-control-sm" id="empleados_id" name="empleados_id" value="<%= emple_nombre%>" readonly>
                                </div>
                                <div class="mb-3">
                                    <label for="estado_produccion" class="form-label"><b>Estado</b></label>
                                    <input type="text" class="form-control form-control-sm" id="estado_produccion" name="estado_produccion" required value="Pendiente" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-12 text-end">
                                <div class="mb-3 d-flex align-items-center justify-content-end">
                                    <label  class="form-label me-2"><b>Pedidos</b></label>
                                    <select class="selectpicker" id="pedido_id" name="pedido_id" required data-live-search="true" data-dropup-auto="false">
                                        <!-- Opciones aquí -->
                                    </select>
                                </div>
                                <div class="table-responsive mt-3">
                                    <table class="table table-bordered table-hover">
                                        <thead class="text-center">
                                            <tr>
                                                <th>Producto</th>
                                                <th>Cantidad</th>
                                                <th>Disponibilidad</th>
                                            </tr>
                                        </thead>
                                        <tbody id="resultados_pedidos">
                                            <!-- Aquí se agregarán los detalles dinámicamente -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Detalle de Recetas -->
                        <div class="row mt-3">
                            <div class="col-md-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="mb-0">Detalle de Producción</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row align-items-center">
                                            <div class="col-md-9">
                                                <label for="receta" class="form-label"><b>Recetas</b></label>
                                                <select class="selectpicker" id="receta_id" name="receta_id" required data-live-search="true" data-dropup-auto="false">

                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <label  class="form-label"><b>Cantidad A Producir</b></label>
                                                <input type="number" class="form-control form-control-sm" id="cantidad" name="cantidad" required value="1">
                                            </div>
                                        </div>
                                        <div class="table-responsive mt-3">
                                            <table class="table table-bordered table-hover">
                                                <thead class="text-center">
                                                    <tr>
                                                        <th>Ingrediente</th>
                                                        <th>Unidad De Medida</th>
                                                        <th>Cantidad</th>
                                                        <th>Disponibilidad</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="resultados">
                                                    <!-- Aquí se agregarán los detalles dinámicamente -->
                                                </tbody>
                                            </table>
                                        </div>
                                        <div class="row mt-3">
                                            <div class="col-md-12 text-end">
                                                <div class="col-md-12 text-end">
                                                    <div class="mb-12 d-flex justify-content-end">
                                                        <div id="mensaje"></div>
                                                    </div>

                                                </div>
                                                <div class="mb-2 d-flex justify-content-end">
                                                    <button type="button" class="btn btn-primary btn-sm me-2" id="btn-agregar">Agregar</button>
                                                    <button type="button" class="btn btn-secondary btn-sm me-2" id="btn-registrar" style="color: #ffffff;">Registrar</button>
                                                    <button type="button" class="btn btn-danger btn-sm" id="btn-cancelar">Cancelar</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        cargarRecetas();
        cargarPedidos();
        $('.selectpicker').selectpicker({
            dropupAuto: false,
            width: '100%'
        });
        $('#pedido_id').change(function () {
            mostrarproductos();
        });
        $('#btn-registrar').hide();
        $('#btn-cancelar').hide();
        // Obtener la fecha actual
        today = new Date();
        minDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 1);
        minDateISO = minDate.toISOString().split('T')[0];
        $("#fecha_vencimiento").attr("min", minDateISO);
    });

    function obtenerFechaActual() {
        fecha = new Date();
        dia = String(fecha.getDate()).padStart(2, '0');
        mes = String(fecha.getMonth() + 1).padStart(2, '0');
        año = fecha.getFullYear();
        return año + '-' + mes + '-' + dia;
    }
    $('#fecha_elaboracion').val(obtenerFechaActual());

    function cargarRecetas() {
        $.ajax({
            data: {listar: 'cargarRecetas'},
            url: 'JSP/Produccion.jsp',
            type: 'post',
            success: function (response) {
                $("#receta_id").html(response);
                $("#receta_id").selectpicker('refresh');
            }
        });
    }
    function cargarPedidos() {
        $.ajax({
            data: {listar: 'cargarPedidos'},
            url: 'JSP/Produccion.jsp',
            type: 'post',
            success: function (response) {
                $("#pedido_id").html(response);
                $("#pedido_id").selectpicker('refresh');
                mostrarproductos();
            }
        });
    }
    $.fn.selectpicker.Constructor.DEFAULTS.liveSearchStyle = 'startsWith';
    $.fn.selectpicker.Constructor.DEFAULTS.liveSearchFilter = function (searchValue, option) {
        return option.toLowerCase().startsWith(searchValue.toLowerCase());
    };

    $("#btn-agregar").click(function () {
        $('#btn-registrar').show();
        $('#btn-cancelar').show();
        fecha_elaboracion = $("#fecha_elaboracion").val();
        fecha_vencimiento = $("#fecha_vencimiento").val();
        empleados_id = $("#empleados_id").val();
        estado_produccion = $("#estado_produccion").val();
        receta_id = $("#receta_id").val();
        cantidad = $("#cantidad").val();
        pedido_id = $("#pedido_id").val();
        // Validación de campos
        if (!fecha_elaboracion || !fecha_vencimiento || !empleados_id || !estado_produccion ||
                !receta_id || !cantidad) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Rellene Todos Los Campos</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (cantidad <= 0) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>No se permiten números negativos</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        }
        form = $("#form").serialize();
        $.ajax({
            data: form,
            url: 'JSP/Produccion.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 4000);
                mostrardetalles();
                $("#receta_id").prop("disabled");
                $("#receta_id").prop("disabled", true);
                $('#receta_id').selectpicker('refresh');
                $("#fecha_elaboracion").prop("readonly", true);
                $("#fecha_vencimiento").prop("readonly", true);
                $("#empleados_id").prop("readonly", true);
                $("#estado_produccion").prop("readonly", true);
                $("#cantidad").prop("readonly", true);
                $("#pedido_id").prop("disabled");
                $("#pedido_id").prop("disabled", true);
                $('#pedido_id').selectpicker('refresh');
                $('#btn-registrar').show();
                $('#btn-cancelar').show();
                $('#btn-agregar').hide();
            },
            error: function (xhr, status, error) {
                $("#mensaje").html("<div class='alert alert-danger' role='alert'>Ocurrió un error: " + error + "</div>");
                $("#mensaje").fadeIn();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 3000);
            }
        });
    });

    $("#btn-registrar").click(function () {
        console.log("Botón de registrar clickeado.");
        pedido_id = $("#pedido_id").val();
        $.ajax({
            data: {listar: 'finalizar', pedido_id: pedido_id},
            url: 'JSP/Produccion.jsp',
            type: 'post',
            success: function (response) {
                console.log("Respuesta del servidor recibida:", response);
                $("#mensaje").html(response);
                $("#mensaje").fadeIn();
                if (response.includes("Producción Finalizada.")) {
                    console.log("Producción finalizada con éxito.");
                    setTimeout(function () {
                        location.href = 'FormListadoProduccion.jsp';
                    }, 2000);
                } else {
                    console.log("Producción cancelada o sin cambios.");
                    setTimeout(function () {
                        $("#mensaje").fadeOut();
                        location.href = 'FormListadoProduccion.jsp';
                    }, 2000);
                }
            },
            error: function (xhr, status, error) {
                console.error("Error en la solicitud AJAX:", error);
                $("#mensaje").html("<div class='alert alert-danger' role='alert'>Error en la solicitud: " + error + "</div>");
                $("#mensaje").fadeIn();
            }
        });
    });
    function mostrardetalles() {
        recetaId = $('#receta_id').val();
        cantidad = $("#cantidad").val();
        console.log("Receta ID: " + recetaId + ", Cantidad: " + cantidad);
        $.ajax({
            data: {listar: 'mostrardetalle', receta_id: recetaId, cantidad: cantidad},
            url: 'JSP/Produccion.jsp',
            type: 'post',
            success: function (response) {
                console.log("Respuesta del servidor: ", response);
                $("#resultados").html(response);
            },
            error: function (xhr, status, error) {
                console.log("Error en la solicitud AJAX: ", error);
            }
        });
    }
    function mostrarproductos() {
        pedido = $('#pedido_id').val();
        $.ajax({
            data: {listar: 'mostrarproductos', pedido_id: pedido},
            url: 'JSP/Produccion.jsp',
            type: 'post',
            success: function (response) {
                console.log("Respuesta del servidor: ", response);
                $("#resultados_pedidos").html(response);
            },
            error: function (xhr, status, error) {
                console.log("Error en la solicitud AJAX: ", error);
            }
        });
    }
    $("#btn-cancelar").click(function () {
        $.ajax({
            data: {listar: 'cancelar'},
            url: 'JSP/Produccion.jsp',
            type: 'post',
            success: function (response) {
                location.href = 'FormListadoProduccion.jsp';
            }
        });
    });
</script>
<%@include file="footer.jsp"%>
