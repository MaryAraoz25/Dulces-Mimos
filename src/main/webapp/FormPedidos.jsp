<%-- 
    Document   : FormPedidos
    Created on : 24 jun. 2024, 21:06:44
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
                    <h5 class="mb-0">Gestión De Pedidos</h5>
                </div>
                <div class="card-body">
                    <form id="form">
                        <input type="hidden" name="listar" id="listar" value="cargar">
                        <input type="hidden" name="idpedidos" id="idpedidos">
                        <input type="hidden" name="estado_stock" id="estado_stock" value="Pendiente">
                        <input type="hidden" name="estado_entrega" id="estado_entrega" value="Pendiente">
                        <div class="row">
                            <div class="col-md-6">
                                <!-- Cliente -->
                                <div class="mb-2">
                                    <label for="clientes_id" class="form-label"><b>Cliente</b></label>
                                    <select class="selectpicker form-control" id="clientes_id" name="clientes_id" required data-live-search="true" data-dropup-auto="false">
                                        <!-- Opciones dinámicas se cargarán aquí -->
                                    </select>
                                </div>
                                <!-- Dirección -->
                                <div class="mb-2">
                                    <label for="cliente_direccion" class="form-label"><b>Dirección</b></label>
                                    <input type="text" class="form-control form-control-sm" id="cliente_direccion" name="cliente_direccion" readonly>
                                </div>
                                <!-- Cédula -->
                                <div class="mb-2">
                                    <label for="cli_cedula" class="form-label"><b>Cédula</b></label>
                                    <input type="text" class="form-control form-control-sm" id="cli_cedula" name="cli_cedula" readonly>
                                </div>
                                <!-- Teléfono -->
                                <div class="mb-2">
                                    <label for="cliente_telefono" class="form-label"><b>Teléfono</b></label>
                                    <input type="text" class="form-control form-control-sm" id="cliente_telefono" name="cliente_telefono" readonly>
                                </div>

                            </div>

                            <div class="col-md-6">
                                <!-- RUC -->
                                <div class="mb-2">
                                    <label for="cliente_ruc" class="form-label"><b>RUC</b></label>
                                    <input type="text" class="form-control form-control-sm" id="cliente_ruc" name="cliente_ruc" readonly>
                                </div>
                                <!-- Fecha de Entrega -->
                                <div class="mb-2">
                                    <label for="pedidos_fecha" class="form-label"><b>Fecha De Entrega</b></label>
                                    <input type="date" class="form-control form-control-sm" id="pedidos_fecha" name="pedidos_fecha" required>
                                </div>
                                <div class="mb-2">
                                    <label for="estado_pedidos" class="form-label"><b>Estado</b></label>
                                    <input type="text" class="form-control form-control-sm" id="estado_pedidos" name="estado_pedidos" value="Pendiente" required readonly>
                                </div>
                                <!-- Empleado -->
                                <div class="mb-2">
                                    <label for="empleados_id" class="form-label"><b>Empleado</b></label>
                                    <input type="text" class="form-control form-control-sm" id="empleados_id" name="empleados_id" value="<%= emple_nombre%>" readonly>
                                </div>
                                <br>

                            </div>
                        </div>

                        <!-- Detalle de Pedidos -->
                        <div class="row mt-3">
                            <div class="col-md-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="mb-0">Detalle de Pedidos</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <label for="productos_id" class="form-label"><b>Productos</b></label>
                                                <select class="selectpicker " id="productos_id" name="productos_id" required data-live-search="true" data-dropup-auto="false">
                                                    <!-- Opciones dinámicas se cargarán aquí -->
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                                <label for="unidad_medida" class="form-label"><b>U. de Medida</b></label>
                                                <input type="text" class="form-control form-control-sm" id="unidad_medida" name="unidad_medida" readonly>
                                            </div>
                                            <div class="col-md-2">
                                                <label for="impuesto" class="form-label"><b>IVA</b></label>
                                                <input type="text" class="form-control form-control-sm" id="impuesto" name="impuesto" readonly>
                                            </div>
                                            <div class="col-md-2">

                                                <label for="detpedidos_preciounitario" class="form-label"><b>Precio Unitario</b></label>
                                                <input type="text" class="form-control form-control-sm" id="detpedidos_preciounitario" name="detpedidos_preciounitario" required readonly>

                                            </div>
                                            <div class="col-md-2">
                                                <label for="detpedidos_cantidad" class="form-label"><b>Cantidad</b></label>
                                                <input type="number" class="form-control form-control-sm" id="detpedidos_cantidad" name="detpedidos_cantidad" required value="1">
                                            </div>
                                        </div>
                                        <br>
                                        <div id="mensaje-detalle-pedidos"></div>
                                        <div class="table-responsive">
                                            <table class="table table-bordered table-hover">
                                                <thead class="text-center">
                                                    <tr>
                                                        <th>Cantidad</th>
                                                        <th>Producto</th>
                                                        <th>Unidad De Medida</th>
                                                        <th>Precio Unitario</th>
                                                        <th>Gravadas 10%</th>
                                                        <th>Disponibilidad</th>
                                                        <th>Acción</th>

                                                    </tr>
                                                </thead>
                                                <tbody id="resultados">
                                                    <!-- <th>Subtotal</th> agregarán los detalles dinámicamente -->
                                                </tbody>
                                            </table>
                                        </div>
                                        <div class="row mt-3">
                                            <div class="row mt-3">
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label for="iva10" class="form-label"><b>IVA 10%</b></label>
                                                        <input type="text" class="form-control form-control-sm" id="iva10-total" name="iva10-total" value="0" readonly>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="mb-3">
                                                        <label for="total" class="form-label"><b>Total Pedido</b></label>
                                                        <input type="text" class="form-control form-control-sm" id="total_pedido" name="total_pedido" value="0" readonly>
                                                    </div>
                                                </div>
                                                <div class="row">
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
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <!-- Modal -->
    <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content" style="background-color: #ffffff; border-radius: 0.25rem;">
                <div class="modal-header" style="background-color: #ff007b; border-bottom: 1px solid #e9ecef;">
                    <h1 class="modal-title fs-5" id="staticBackdropLabel" style="color: #ffffff;"><b>Eliminar Registro</b></h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="color: #ffffff; opacity: 0.5;"></button>
                </div>
                <div class="modal-body" style="padding: 2rem; font-size: 1.1rem;">
                    <input type="hidden" name="listar_delete" id="listar_delete" value="eliminar">
                    <input type="hidden" name="id_delete" id="id_delete">
                    <p><b>¿Está seguro que desea eliminar el registro?</b></p>
                </div>
                <div class="modal-footer" style="background-color: #f8f9fa; border-top: 1px solid #e9ecef; display: flex; justify-content: center;">
                    <button type="button" class="btn btn-danger" id="btn-eliminar" name="btn-eliminar" data-bs-dismiss="modal" style="background-color: #ff007b; border-color: #ff007b; color: #000000; min-width: 100px;">Sí</button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="color: #000000; border-color: #6c757d; min-width: 100px;">No</button>
                </div>
            </div>
        </div>
    </div>  

    <script>
        $(document).ready(function () {
            cargarClientes();
            cargarProductos();
            $('.selectpicker').selectpicker({
                dropupAuto: false,
                width: '100%'
            });
            $('#btn-registrar').hide();
            $('#btn-cancelar').hide();
            today = new Date().toISOString().split('T')[0];
            $("#pedidos_fecha").attr("min", today);
        });
        $.fn.selectpicker.Constructor.DEFAULTS.liveSearchStyle = 'contains';
        $.fn.selectpicker.Constructor.DEFAULTS.liveSearchFilter = function (searchValue, option) {
            return option.toLowerCase().startsWith(searchValue.toLowerCase());
        };

        $("#btn-agregar").click(function () {
            $('#btn-registrar').show();
            $('#btn-cancelar').show();
            clientes_id = $("#clientes_id").val();
            cliente_direccion = $("#cliente_direccion").val();
            cli_cedula = $("#cli_cedula").val();
            cliente_telefono = $("#cliente_telefono").val();

            pedidos_fecha = $("#pedidos_fecha").val();
            estado_pedidos = $("#estado_pedidos").val();
            empleados_id = $("#empleados_id").val();
            productos_id = $("#productos_id").val();
            impuesto = $("#impuesto").val();
            detpedidos_preciounitario = $("#detpedidos_preciounitario").val();
            detpedidos_cantidad = $("#detpedidos_cantidad").val();
            if (!clientes_id || !pedidos_fecha || !empleados_id || !productos_id || !detpedidos_cantidad) {
                $("#mensaje").html("<div class='alert alert-danger' role='alert'>Rellene Todos Los Campos</div>");
                $("#mensaje").fadeIn();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 3000);
                return;
            } else if (detpedidos_cantidad <= 0) {
                $("#mensaje").html("<div class='alert alert-danger' role='alert'>No se permiten números negativos</div>");
                $("#mensaje").fadeIn();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 3000);
                return;
            }
            form = $("#form").serialize();
            //alert(form);
            $.ajax({
                data: form,
                url: 'JSP/Pedidos.jsp',
                type: 'post',
                success: function (response) {
                    $("#mensaje").html(response);
                    setTimeout(function () {
                        $("#mensaje").fadeOut();
                    }, 4000);

                    mostrardetalles();

                    if (!$("#clientes_id").prop("disabled")) {
                        $("#clientes_id").prop("disabled", true);
                        $('#clientes_id').selectpicker('refresh');
                        $("#pedidos_fecha").prop("readonly", true);
                    }
                    $("#productos_id").val('').selectpicker('refresh');
                    $("#impuesto").val('');
                    $("#detpedidos_preciounitario").val('');
                    $("#detpedidos_cantidad").val('1');
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
        $("#clientes_id").change(function () {
            selectedCliente = $(this).val();
            selectedOption = $(this).find("option:selected");
            $("#cliente_direccion").val(selectedOption.data("direccion"));
            $("#cli_cedula").val(selectedOption.data("cedula"));
            $("#cliente_telefono").val(selectedOption.data("telefono"));
            $("#cliente_ruc").val(selectedOption.data("ruc"));
        });
        function cargarClientes() {
            $.ajax({
                data: {listar: 'cargarClientes'},
                url: 'JSP/Pedidos.jsp',
                type: 'post',
                success: function (response) {
                    $("#clientes_id").html(response);
                    $("#clientes_id").change();
                    $("#clientes_id").selectpicker('refresh');
                }
            });
        }
        $("#productos_id").change(function () {
            selectedOption = $(this).find("option:selected");
            unidad = selectedOption.data("unidad");
            impuesto = selectedOption.data("impuesto");
            precioUnitario = selectedOption.data("precio-unitario");

            $("#unidad_medida").val(unidad);
            $("#impuesto").val(impuesto);
            $("#detpedidos_preciounitario").val(precioUnitario);
        });
        function cargarProductos() {
            $.ajax({
                data: {listar: 'cargarProductos'},
                url: 'JSP/Pedidos.jsp',
                type: 'post',
                success: function (response) {
                    $("#productos_id").html(response);
                    $("#productos_id").change();
                    $("#productos_id").selectpicker('refresh');
                }
            });
        }

        function resetForm() {
            $("#form")[0].reset();
            $("#listar").val("cargar");
            $("#clientes_id").focus();
            $("#clientes_id").selectpicker('refresh');
        }

        function mostrardetalles() {
            $.ajax({
                data: {listar: 'mostrardetalle'},
                url: 'JSP/Pedidos.jsp',
                type: 'post',
                success: function (response) {
                    $("#resultados").html(response);
                    mostrartotal10();
                    mostrartotales();
                }
            });
        }
        function mostrartotales() {
            $.ajax({
                data: {listar: 'mostrartotales'},
                url: 'JSP/Pedidos.jsp',
                type: 'post',
                success: function (response) {
                    //alert(response
                    $("#total_pedido").val(response);
                }
            });
        }
        function mostrartotal10() {
            $.ajax({
                data: {listar: 'mostrartotal10'},
                url: 'JSP/Pedidos.jsp',
                type: 'post',
                success: function (response) {
                    //alert(response)
                    $("#iva10-total").val(response);
                }
            });
        }
        $("#btn-eliminar").click(function () {
            listar_delete = $("#listar_delete").val();
            id_delete = $("#id_delete").val();
            $.ajax({
                data: {listar: listar_delete, id_delete: id_delete},
                url: 'JSP/Pedidos.jsp',
                type: 'post',
                success: function (response) {
                    $("#mensaje").html(response);
                    mostrardetalles();
                    mostrartotal10();
                    mostrartotales();
                }
            });
        });
        $("#btn-registrar").click(function () {
            total = $("#total_pedido").val();
            $.ajax({
                data: {listar: 'finalizar', total: total},
                url: 'JSP/Pedidos.jsp',
                type: 'post',
                success: function (response) {
                    location.href = 'FormListadoPedidos.jsp';
                }
            });
        });
        $("#btn-cancelar").click(function () {
            $.ajax({
                data: {listar: 'cancelar'},
                url: 'JSP/Pedidos.jsp',
                type: 'post',
                success: function (response) {
                    location.href = 'FormListadoPedidos.jsp';
                }
            });
        });
    </script>
    <%@include file="footer.jsp"%>