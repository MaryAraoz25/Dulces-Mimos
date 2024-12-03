<%-- 
    Document   : FormVentas
    Created on : 24 jun. 2024, 21:07:14
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
                    <h5 class="mb-0">Gestión De Ventas</h5>
                </div>
                <div class="card-body">
                    <form id="form">
                        <!-- Datos del Cliente -->
                        <div class="row">
                            <div class="col-md-6">
                                <input type="hidden" name="listar" id="listar" value="cargar">
                                <input type="hidden" name="idcabecera" id="idcabecera">
                                <div class="mb-3">
                                    <label class="form-label"><b>Pedidos</b></label>
                                    <br>
                                    <select class="selectpicker " id="pedido_id" name="pedido_id" required data-live-search="true" data-dropup-auto="false">

                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label for="clientes_id" class="form-label"><b>Cliente</b></label>
                                    <br>
                                    <select class="selectpicker" id="clientes_id" name="clientes_id" required data-live-search="true" data-dropup-auto="false">

                                    </select>
                                </div>
                                <div class="mb-2">
                                    <label for="cliente_direccion" class="form-label"><b>Dirección</b></label>
                                    <input type="text" class="form-control form-control-sm" id="cliente_direccion" name="cliente_direccion" readonly>
                                </div>
                                <div class="mb-2">
                                    <label for="cliente_correo" class="form-label"><b>Cedula</b></label>
                                    <input type="email" class="form-control form-control-sm" id="cli_cedula" name="cli_cedula" readonly>
                                </div>
                                <div class="mb-2">
                                    <label for="cliente_telefono" class="form-label"><b>Teléfono</b></label>
                                    <input type="text" class="form-control form-control-sm" id="cliente_telefono" name="cliente_telefono" readonly>
                                </div>
                                <div class="mb-2">
                                    <label for="cliente_ruc" class="form-label"><b>RUC</b></label>
                                    <input type="text" class="form-control form-control-sm" id="cliente_ruc" name="cliente_ruc" readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-2">
                                    <label class="form-label"><b>Número De Timbrado</b></label>
                                    <input type="text" class="form-control" id="venta_timbrado" name="venta_timbrado" readonly value="17404739">
                                </div>
                                <div class="mb-2">
                                    <label class="form-label"><b>Fecha Inicio Vigencia</b></label>
                                    <input type="date" class="form-control" id="venta_inicio" name="venta_inicio" readonly value="2024-08-06">
                                </div>
                                <div class="mb-2">
                                    <label class="form-label"><b>Fecha Fin Vigencia</b></label>
                                    <input type="date" class="form-control" id="venta_fin" name="venta_fin" readonly value="2025-08-31">
                                </div>
                                <div class="mb-2">
                                    <label for="ventas_fecha" class="form-label"><b>Fecha</b></label>
                                    <input type="date" class="form-control form-control-sm" id="ventas_fecha" name="ventas_fecha" required readonly>
                                </div>
                                <div class="mb-2">
                                    <label for="ventas_hora" class="form-label"><b>Hora</b></label>
                                    <input type="time" class="form-control form-control-sm" id="ventas_hora" name="ventas_hora" required readonly>
                                </div>
                                <div class="mb-2">
                                    <label for="ventas" class="form-label"><b>Estado</b></label>
                                    <input type="text" class="form-control form-control-sm" id="ventas_estado" name="ventas_estado"  value="Pendiente" required readonly>

                                </div>
                                <div class="mb-2">
                                    <label  class="form-label"><b>Empleado</b></label>
                                    <input type="text" class="form-control form-control-sm" id="empleados_id" name="empleados_id" value="<%= emple_nombre%>" readonly> 
                                </div>
                                <div class="mb-2">
                                    <label  class="form-label"><b>Tipo De Pago</b></label>
                                    <select class="form-select form-select-sm" id="condicion_venta" name="condicion_venta" required>
                                        <option value="seleccione">Seleccione</option>
                                        <option value="Contado">Contado</option>
                                        <option value="Credito">Credito</option>
                                    </select>
                                </div>
                                <div class="mb-2">
                                    <label for="c" class="form-label"><b>A Cuántos Días</b></label>
                                    <input type="number" class="form-control form-control-sm" id="cuotas" name="cuotas" value="0">
                                </div>
                                <div class="mb-2">
                                    <label class="form-label"><b>Medio De Pago</b></label>
                                    <select class="selectpicker" id="idmetodos_pago" name="idmetodos_pago" required data-live-search="true" data-dropup-auto="false">
                                        <!-- Opciones dinámicas se cargarán aquí -->
                                    </select>
                                </div>

                            </div>
                        </div>

                        <!-- Detalle de Ventas -->
                        <div class="row mt-3">
                            <div class="col-md-12">
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="mb-0">Detalle de Ventas</h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-3">
                                                <label for="productos_id" class="form-label"><b>Productos</b></label>
                                                <select class="selectpicker" id="productos_id" name="productos_id" required data-live-search="true" data-dropup-auto="false">
                                                    <!-- Las opciones se cargarán dinámicamente -->
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <label for="impuesto" class="form-label"><b>Impuesto</b></label>
                                                <input type="text" class="form-control form-control-sm" id="impuesto" name="impuesto" readonly>
                                            </div>
                                            <div class="col-md-3">
                                                <label for="detventas_preciounitario" class="form-label"><b>Precio Unitario</b></label>
                                                <input type="text" class="form-control form-control-sm" id="detventas_preciounitario" name="detventas_preciounitario" required readonly>

                                            </div>
                                            <div class="col-md-3">
                                                <label for="detventas_cantidad" class="form-label"><b>Cantidad</b></label>
                                                <input type="number" class="form-control form-control-sm" id="detventas_cantidad" name="detventas_cantidad" required value="1">
                                            </div>
                                        </div>
                                        <div id="mensaje-detalle-ventas"></div>
                                        <br>
                                        <div class="table-responsive">
                                            <table class="table table-bordered table-hover">
                                                <thead class="text-center">
                                                    <tr>
                                                        <th>Cantidad</th>
                                                        <th>Producto</th>
                                                        <th>Precio Unitario</th>
                                                        <th>Gravadas 10%</th>
                                                        <th>Acción</th>
                                                    </tr>
                                                </thead>
                                                <tbody id="resultados">
                                                    <!-- Aquí se agregarán los detalles dinámicamente -->
                                                </tbody>
                                            </table>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <!-- Sub Total -->
                                                <label class="form-label"><b>Sub Total</b></label>
                                            </div>
                                            <div class="col-md-3">
                                                <!-- Campo para Gravadas 10% -->
                                                <input type="text" class="form-control form-control-sm" id="gravadas10" name="gravadas10" readonly>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <!-- Campo para Total en Letras -->
                                            <div class="col-md-9">
                                                <label class="form-label"><b>Total en Letras</b></label>
                                                <input type="text" class="form-control form-control-sm" id="total_letras" name="total_letras" readonly>
                                            </div>

                                            <div class="col-md-3">
                                                <label class="form-label"><b>Total Venta</b></label>
                                                <input type="text" class="form-control form-control-sm" id="total_venta" name="total_venta" value="0" readonly>
                                            </div>
                                        </div>
                                        <div class="row mt-3">
                                            <!-- Campo para IVA 10% -->
                                            <div class="col-md-4">
                                                <label class="form-label"><b>IVA 10%</b></label>
                                                <input type="text" class="form-control form-control-sm" id="iva10_total" name="iva10_total" value="0" readonly>
                                            </div>

                                            <!-- Campo para Total IVA -->
                                            <div class="col-md-4">
                                                <label class="form-label"><b>Total IVA</b></label>
                                                <input type="text" class="form-control form-control-sm" id="iva_total" name="iva_total" value="0" readonly>
                                            </div>
                                        </div>
                                        <br>
                                        <!-- Botones de acción -->
                                        <div class="row">
                                            <div class="col-md-12 text-end">
                                                <div class="d-flex justify-content-end mb-3">
                                                    <div id="mensaje"></div>
                                                </div>
                                                <div class="d-flex justify-content-end">
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
                <button type="button" class="btn btn-danger" id="btn-eliminar" data-bs-dismiss="modal" style="background-color: #ff007b; border-color: #ff007b; color: #000000; min-width: 100px;">Sí</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="color: #000000; border-color: #6c757d; min-width: 100px;">No</button>
            </div>
        </div>
    </div>
</div>                               
<script>
    $(document).ready(function () {
        $('.selectpicker').selectpicker({
            dropupAuto: false,
            width: '100%'
        });
        //alert("hi");
        $('#btn-registrar').hide();
        $('#btn-cancelar').hide();
        ocultarCampos();
        cargarPedidos();
        cargarClientes();
        cargarProductos();
        cargarMetodosDePago();
    });
    $.fn.selectpicker.Constructor.DEFAULTS.liveSearchStyle = 'contains';
    $.fn.selectpicker.Constructor.DEFAULTS.liveSearchFilter = function (searchValue, option) {
        return option.toLowerCase().startsWith(searchValue.toLowerCase());
    };
    $("#condicion_venta").change(function () {
        condicion = $(this).val();
        mostrarCampos(condicion);
    });
    function mostrarCampos(condicion) {
        if (condicion === 'Contado') {
            $("#idmetodos_pago").closest('.mb-2').show();
            $("#cuotas").closest('.mb-2').hide();
        } else if (condicion === 'Credito') {
            $("#cuotas").closest('.mb-2').show();
            $("#idmetodos_pago").closest('.mb-2').show();
        } else {
            ocultarCampos();
        }
    }
    function ocultarCampos() {
        $("#idmetodos_pago").closest('.mb-2').hide();
        $("#cuotas").closest('.mb-2').hide();
    }
    function obtenerFechaActual() {
        fecha = new Date();
        dia = String(fecha.getDate()).padStart(2, '0');
        mes = String(fecha.getMonth() + 1).padStart(2, '0'); 
        año = fecha.getFullYear();
        return año + '-' + mes + '-' + dia;
    }

    function obtenerHoraActual() {
        fecha = new Date();
        hora = fecha.getHours().toString().padStart(2, '0');
        minutos = fecha.getMinutes().toString().padStart(2, '0');
        return hora + ':' + minutos;
    }
    $('#ventas_fecha').val(obtenerFechaActual());
    $('#ventas_hora').val(obtenerHoraActual());
    function cargarMetodosDePago() {
        $.ajax({
            data: {listar: 'cargarMetodosDePago'},
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                $("#idmetodos_pago").html(response);
                $("#idmetodos_pago").selectpicker('refresh');
            }
        });
    }
    function cargarPedidos() {
        $.ajax({
            data: {listar: 'cargarPedidos'},
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                console.log(response);  
                //alert(response);
                $("#pedido_id").html(response);
                $("#pedido_id").selectpicker('refresh');
            }
        });
    }
    $("#pedido_id").change(function () {
        selectedOption = $(this).find("option:selected");

        idCliente = selectedOption.data("idclientes");
        nombre = selectedOption.data("nombre");
        direccion = selectedOption.data("direccion");
        cedula = selectedOption.data("cedula");
        telefono = selectedOption.data("telefono");
        ruc = selectedOption.data("ruc");

        $("#clientes_id").val(idCliente); 
        $("#clientes_id").selectpicker('refresh'); 
        $("#cliente_direccion").val(direccion);
        $("#cli_cedula").val(cedula);
        $("#cliente_telefono").val(telefono);
        $("#cliente_ruc").val(ruc);
    });
    function cargarClientes() {
        $.ajax({
            data: {listar: 'cargarClientes'},
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                $("#clientes_id").html(response);
                $("#clientes_id").change();
                $("#clientes_id").selectpicker('refresh');
            }
        });
    }
    $("#clientes_id").change(function () {
        selectedCliente = $(this).val();
        selectedOption = $(this).find("option:selected");
        $("#cliente_direccion").val(selectedOption.data("direccion"));
        $("#cli_cedula").val(selectedOption.data("cedula"));
        $("#cliente_telefono").val(selectedOption.data("telefono"));
        $("#cliente_ruc").val(selectedOption.data("ruc"));
    });
    $("#productos_id").change(function () {
        selectedOption = $(this).find("option:selected");
        $("#impuesto").val(selectedOption.data("impuesto"));
        $("#detventas_preciounitario").val(selectedOption.data("precio-unitario"));
    });
    function cargarProductos() {
        $.ajax({
            data: {listar: 'cargarProductos'},
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                $("#productos_id").html(response);
                $("#productos_id").change();
                $("#productos_id").selectpicker('refresh');
            }
        });
    }
    $("#btn-agregar").click(function () {
        $('#btn-registrar').show();
        $('#btn-cancelar').show();
        clientes_id = $("#clientes_id").val();
        condicion_venta = $("#condicion_venta").val();
        cuotas = $("#cuotas").val();
        idmetodos_pago = $("#idmetodos_pago").val();
        pedido_id = $("#pedido_id").val();
        //detalle
        productos_id = $("#productos_id").val();
        detventas_cantidad = $("#detventas_cantidad").val();
        detventas_preciounitario = $("#detventas_preciounitario").val();
        pedido_id = $("#pedido_id").val();

        if (!clientes_id || !condicion_venta || !cuotas || !idmetodos_pago) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Rellene Todos Los Campos Obligatorios</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        }else if (detventas_cantidad <= 0) {
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
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                console.log(response);
                $("#mensaje").html(response);
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 4000);
                //alert("dentro del succes");
                mostrardetalles();
                if (!$("#clientes_id").prop("disabled")) {
                    $("#clientes_id").prop("disabled", true);
                    $('#clientes_id').selectpicker('refresh');
                    $("#idmetodos_pago").prop("disabled", true);
                    $('#idmetodos_pago').selectpicker('refresh');
                    $("#condicion_venta").prop("disabled", true);
                    $("#cuotas").prop("readonly", true);
                    $("#pedido_id").prop("disabled", true);
                    $('#pedido_id').selectpicker('refresh');

                }
                $("#productos_id").val('').selectpicker('refresh');
                $("#productos_id").focus();
                $("#detventas_preciounitario").val('');
                $("#impuesto").val('');
                $("#detventas_cantidad").val('1');
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
    function mostrardetalles() {
        pedido_id = $('#pedido_id').val();
        $.ajax({
            data: {listar: 'mostrardetalle', pedido_id: pedido_id},
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                $("#resultados").html(response);
                totalIva10 = $("#totalIva10").val();
                $('#gravadas10').val(totalIva10);
                mostrartotal10();
                mostrartotaliva();
                mostrartotales();
                totalletras();
            }
        });
    }
    function mostrartotales() {
        $.ajax({
            data: {listar: 'mostrartotales'},
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                //alert(response);  
                $("#total_venta").val(response);
            }
        });
    }
    function totalletras() {
        $.ajax({
            data: {listar: 'mostrartotales'},
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                totalNumerico = parseInt(response.replace(/\./g, '').replace(/,/g, ''));
                totalEnLetras = numeroALetras(totalNumerico) + " guaraníes";
                $("#total_letras").val(totalEnLetras);
            }
        });
    }
    function mostrartotaliva() {
        $.ajax({
            data: {listar: 'mostrartotaliva'},
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                //alert(response); 
                $("#iva_total").val(response);
            }
        });
    }
    function mostrartotal10() {
        $.ajax({
            data: {listar: 'mostrartotal10'},
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                $("#iva10_total").val(response);
            }
        });
    }
    $("#btn-eliminar").click(function () {
        listar_delete = $("#listar_delete").val();
        id_delete = $("#id_delete").val();
        $.ajax({
            data: {listar: listar_delete, id_delete: id_delete},
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrardetalles();
                mostrartotal10();
                mostrartotales();
                mostrartotaliva();
                totalletras();
            }
        });
    });
    $("#btn-registrar").click(function () {
        total = $("#total-venta").val();
        idmetodos_pago = $("#idmetodos_pago").val();
        clientes_id = $("#clientes_id").val();
        cuotas = $("#cuotas").val();
        condicion_venta = $("#condicion_venta").val();
        pedido_id = $("#pedido_id").val();
        $.ajax({
            data: {listar: 'finalizar', total: total, clientes_id: clientes_id, idmetodos_pago: idmetodos_pago, cuotas: cuotas, condicion_venta: condicion_venta, pedido_id: pedido_id},
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                console.log("Respuesta del servidor recibida:", response); 
                $("#mensaje").html(response); 
                $("#mensaje").fadeIn(); 
                if (response.includes('Venta cancelada. No hay suficiente stock.')) {
                    console.log("Venta cancelada. No hay suficiente stock.");
                    setTimeout(function () {
                        $("#mensaje").fadeOut();
                        location.href = 'FormListadoVentas.jsp';
                    }, 2000);
                    return; 
                }
                if (condicion_venta === 'Contado') {
                    location.href = 'FormListadoVentas.jsp'; 
                } else if (condicion_venta === 'Credito') {
                    location.href = 'FormCobros.jsp'; 
                }
            }
        });
    });
    $("#btn-cancelar").click(function () {
        $.ajax({
            data: {listar: 'cancelar'},
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                location.href = 'FormListadoVentas.jsp';
            }
        });
    });
    function totalletras() {
        $.ajax({
            data: {listar: 'mostrartotales'},
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                totalNumerico = parseInt(response.replace(/\./g, '').replace(/,/g, ''));
                totalEnLetras = numeroALetras(totalNumerico) + " guaraníes";
                $("#total_letras").val(totalEnLetras);
            }
        });
    }
    function numeroALetras(num) {
    unidades = ["", "uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve"];
    decenas = ["", "", "veinte", "treinta", "cuarenta", "cincuenta", "sesenta", "setenta", "ochenta", "noventa"];
    especiales = ["diez", "once", "doce", "trece", "catorce", "quince", "dieciséis", "diecisiete", "dieciocho", "diecinueve"];
    centenas = ["", "ciento", "doscientos", "trescientos", "cuatrocientos", "quinientos", "seiscientos", "setecientos", "ochocientos", "novecientos"];

    function convertirCientos(n) {
        if (n === 0) return "";
        if (n === 100) return "cien"; 
        return centenas[Math.floor(n / 100)] + (n % 100 !== 0 ? " " + convertirDecenas(n % 100) : "");
    }

    function convertirDecenas(n) {
        if (n < 10) {
            return unidades[n];
        } else if (n >= 10 && n < 20) {
            return especiales[n - 10];
        } else {
            return decenas[Math.floor(n / 10)] + (n % 10 !== 0 ? " y " + unidades[n % 10] : "");
        }
    }

    function convertirMiles(n) {
        if (n === 0) return "";
        if (n >= 1000) {
            const miles = Math.floor(n / 1000);
            const resto = n % 1000;
            return (miles === 1 ? "mil" : convertirCientos(miles) + " mil") + (resto !== 0 ? " " + convertirCientos(resto) : "");
        } else {
            return convertirCientos(n);
        }
    }

    function convertirMillones(n) {
        if (n >= 1000000) {
            const millones = Math.floor(n / 1000000);
            const resto = n % 1000000;
            return (millones === 1 ? "un millón" : convertirCientos(millones) + " millones") + (resto !== 0 ? " " + convertirMiles(resto) : "");
        } else {
            return convertirMiles(n);
        }
    }

    if (num === 0) return "cero";
    return convertirMillones(num).trim();
}

</script>
<%@include file="footer.jsp"%>