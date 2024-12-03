
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
                    <h5 class="mb-0">Gestión De Compras</h5>
                </div>
                <div class="card-body">
                    <form id="form" method="post">
                        <!-- Datos del Proveedor -->
                        <div class="row">
                            <div class="col-md-6">
                                <input type="hidden" name="listar" id="listar" value="cargar">
                                <div class="mb-2">
                                    <label class="form-label"><b>Proveedor</b></label>
                                    <select class="selectpicker " id="proveedores_id" name="proveedores_id" required data-live-search="true" data-dropup-auto="false">
                                        <!-- Opciones dinámicas se cargarán aquí -->
                                    </select>
                                </div>
                                <div class="mb-2">
                                    <label for="prov_direccion" class="form-label"><b>Dirección</b></label>
                                    <input type="text" class="form-control form-control-sm" id="prov_direccion" name="prov_direccion" readonly>
                                </div>
                                <div class="mb-2">
                                    <label for="prov_correo" class="form-label"><b>Correo</b></label>
                                    <input type="email" class="form-control form-control-sm" id="prov_correo" name="prov_correo" readonly>
                                </div>
                                <div class="mb-2">
                                    <label for="prov_telefono" class="form-label"><b>Teléfono</b></label>
                                    <input type="text" class="form-control form-control-sm" id="prov_telefono" name="prov_telefono" readonly>
                                </div>
                                <div class="mb-2">
                                    <label  class="form-label"><b>RUC</b></label>
                                    <input type="text" class="form-control form-control-sm" id="prov_ruc" name="prov_ruc" readonly>
                                </div>
                                <!-- Nuevos campos añadidos -->
                                <div class="mb-3">
                                    <label  class="form-label"><b>Número De Timbrado</b></label>
                                    <input type="text" class="form-control" id="prov_timbrado" name="prov_timbrado" readonly>
                                </div>
                                <div class="mb-3">
                                    <label  class="form-label"><b>Fecha Inicio Vigencia</b></label>
                                    <input type="date" class="form-control" id="prov_inicio" name="prov_inicio" readonly>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label"><b>Fecha Fin Vigencia</b></label>
                                    <input type="date" class="form-control" id="prov_fin" name="prov_fin" readonly>
                                </div>
                            </div>

                            <div class="col-md-6">
                                <!-- Datos de la Compra -->
                                <div class="mb-2">
                                    <label class="form-label"><b>Fecha</b></label>
                                    <input type="date" class="form-control form-control-sm" id="compras_fecha" name="compras_fecha" required readonly>
                                </div>
                                <div class="mb-2">
                                    <label class="form-label"><b>Hora</b></label>
                                    <input type="time" class="form-control form-control-sm" id="compras_hora" name="compras_hora" required readonly>
                                </div>
                                <div class="mb-2">
                                    <label class="form-label"><b>Estado</b></label>
                                    <input type="text" value="Pendiente" class="form-control form-control-sm" id="compras_estado" name="compras_estado" required readonly>
                                </div>
                                <div class="mb-2">
                                    <label class="form-label"><b>Empleado</b></label>
                                    <input type="text" class="form-control form-control-sm" id="empleados_id" name="empleados_id" value="<%= emple_nombre%>" readonly>
                                </div>
                                <div class="mb-2">
                                    <label class="form-label"><b>Tipo De Pago</b></label>
                                    <select class="form-select form-select-sm" id="condicion_compra" name="condicion_compra" required>
                                        <option value="sel" id="sel" name="sel">Selecciona</option>
                                        <option value="Contado" id="contado" name="contado">Contado</option>
                                        <option value="Credito" id="credito" name="credito">Credito</option>
                                    </select>
                                </div>
                                <div class="mb-2">
                                    <label for="c" class="form-label"><b>A Cuántos Días</b></label>
                                    <input type="number" class="form-control form-control-sm" id="cuotas" name="cuotas" value="0">
                                </div>
                                <div class="mb-2">
                                    <label class="form-label"><b>Medio De Pago</b></label>
                                    <select class="selectpicker " id="idmetodos_pago" name="idmetodos_pago" required data-live-search="true" data-dropup-auto="false">
                                        <!-- Opciones dinámicas se cargarán aquí -->
                                    </select>
                                </div>
                            </div>



                            <!-- Detalle de Compras -->
                            <div class="row mt-3">
                                <div class="col-md-12">
                                    <div class="card">
                                        <div class="card-header">
                                            <h5 class="mb-0">Detalle de Compras</h5>
                                        </div>
                                        <div class="card-body">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <label  class="form-label"><b>Ingrediente</b></label>
                                                    <select class="selectpicker " id="ingredientes_id" name="ingredientes_id" required data-live-search="true" data-dropup-auto="false">
                                                        <!-- Opciones dinámicas se cargarán aquí -->
                                                    </select>
                                                </div>
                                                <div class="col-md-6">
                                                    <label class="form-label"><b>Unidad de Medida</b></label>
                                                    <!--input type="text" class="form-control form-control-sm" id="unidad_medidaid" name="unidad_medida" -->
                                                    <select class="selectpicker " id="unidad_medidaid" name="unidad_medidaid" required data-live-search="true" data-dropup-auto="false">
                                                        <!-- Opciones dinámicas se cargarán aquí -->
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-md-4">
                                                    <label  class="form-label"><b>Impuesto</b></label>
                                                    <input type="text" class="form-control form-control-sm" id="impuesto" name="impuesto" readonly>
                                                </div>
                                                <div class="col-md-4">
                                                    <label  class="form-label"><b>Precio Unitario</b></label>
                                                    <input type="number" class="form-control form-control-sm" id="detcompras_preciounitario" name="detcompras_preciounitario" value="0" required>
                                                </div>
                                                <div class="col-md-4">
                                                    <label  class="form-label"><b>Cantidad</b></label>
                                                    <input type="number" class="form-control form-control-sm" id="detcompras_cantidad" name="detcompras_cantidad" value="1" required>
                                                </div>
                                            </div>
                                            <br>
                                            <div id="mensaje-detalle-compras"></div>
                                            <div class="table-responsive">
                                                <table class="table table-bordered table-hover">
                                                    <thead class="text-center">
                                                        <tr>
                                                            <th>Cantidad</th>
                                                            <th>Ingrediente</th>
                                                            <th>Unidad De Medida</th>
                                                            <th>Precio Unitario</th>
                                                            <th>Gravadas 5%</th>
                                                            <th>Gravadas 10%</th>
                                                            <th>Acción</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="resultados">

                                                    </tbody>
                                                </table>

                                            </div>
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <!-- Sub Total -->
                                                    <label class="form-label"><b>Sub Total</b></label>
                                                </div>
                                                <div class="col-md-3">
                                                    <!-- Campo para Gravadas 5% -->
                                                    <input type="text" class="form-control form-control-sm" id="gravadas5" name="gravadas5" readonly>
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

                                                <!-- Campo para Total Compra -->
                                                <div class="col-md-3">
                                                    <label class="form-label"><b>Total Compra</b></label>
                                                    <input type="text" class="form-control form-control-sm" id="total_compra" name="total_compra" value="0" readonly>
                                                </div>
                                            </div>

                                            <div class="row mt-3">
                                                <!-- Campo para IVA 5% -->
                                                <div class="col-md-4">
                                                    <label class="form-label"><b>IVA 5%</b></label>
                                                    <input type="text" class="form-control form-control-sm" id="iva5_total" name="iva5_total" value="0" readonly>
                                                </div>

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
                    </form>
                </div>
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
        cargarIngredientes();
        cargarUnidadDeMedida();
        cargarProveedores();
        cargarMetodosDePago();
    });
    $.fn.selectpicker.Constructor.DEFAULTS.liveSearchStyle = 'contains';
    $.fn.selectpicker.Constructor.DEFAULTS.liveSearchFilter = function (searchValue, option) {
        return option.toLowerCase().startsWith(searchValue.toLowerCase());
    };
    $("#condicion_compra").change(function () {
        condicion = $(this).val();
        mostrarCampos(condicion);
    });
    function mostrarCampos(condicion) {
        if (condicion === 'Contado') {
            $("#idmetodos_pago").closest('.mb-2').show();
            $("#cuotas").closest('.mb-2').hide();
            //cargarMetodosDePago();


        } else if (condicion === 'Credito') {
            $("#cuotas").closest('.mb-2').show();
            $("#idmetodos_pago").closest('.mb-2').show();
            //cargarMetodosDePago();
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
    $('#compras_fecha').val(obtenerFechaActual());
    $('#compras_hora').val(obtenerHoraActual());
    function cargarMetodosDePago() {
        $.ajax({
            data: {listar: 'cargarMetodosDePago'},
            url: 'JSP/Compras.jsp',
            type: 'post',
            success: function (response) {
                $("#idmetodos_pago").html(response);
                $("#idmetodos_pago").selectpicker('refresh');
            }
        });
    }
    $("#proveedores_id").change(function () {
        selectedProveedor = $(this).val();
        selectedOption = $(this).find("option:selected");

        $("#prov_direccion").val(selectedOption.data("direccion"));
        $("#prov_correo").val(selectedOption.data("correo"));
        $("#prov_telefono").val(selectedOption.data("telefono"));
        $("#prov_ruc").val(selectedOption.data("ruc"));
        $("#prov_timbrado").val(selectedOption.data("timbrado")); 
        $("#prov_inicio").val(selectedOption.data("inicio")); 
        $("#prov_fin").val(selectedOption.data("fin"));
    });
    function cargarProveedores() {
        $.ajax({
            data: {listar: 'cargarProveedores'},
            url: 'JSP/Compras.jsp',
            type: 'post',
            success: function (response) {
                //console.log(response);
                $("#proveedores_id").html(response);
                $("#proveedores_id").change();
                $("#proveedores_id").selectpicker('refresh');
            }
        });
    }
    $("#ingredientes_id").change(function () {
        selectedIngrediente = $(this).val();
        selectedOption = $(this).find("option:selected");
        $("#impuesto").val(selectedOption.data("impuesto"));
    });
    function cargarIngredientes() {
        $.ajax({
            data: {listar: 'cargarIngredientes'},
            url: 'JSP/Compras.jsp',
            type: 'post',
            success: function (response) {
                $("#ingredientes_id").html(response);
                $("#ingredientes_id").change();
                $("#ingredientes_id").selectpicker('refresh');
            }
        });
    }
    function cargarUnidadDeMedida() {
        $.ajax({
            data: {listar: 'cargarUnidadDeMedida'},
            url: 'JSP/Compras.jsp',
            type: 'post',
            success: function (response) {
                $("#unidad_medidaid").html(response);
                $("#unidad_medidaid").selectpicker('refresh');
            }
        });
    }
    $("#btn-agregar").click(function () {
        $('#btn-registrar').show();
        $('#btn-cancelar').show();
        proveedores_id = $("#proveedores_id").val();
        prov_direccion = $("#prov_direccion").val();
        prov_correo = $("#prov_correo").val();
        prov_ruc = $("#prov_ruc").val();
        prov_telefono = $("#prov_telefono").val();
        prov_timbrado = $("#prov_timbrado").val();
        prov_inicio = $("#prov_inicio").val();
        prov_fin = $("#prov_fin").val();
        compras_fecha = $("#compras_fecha").val();
        compras_hora = $("#compras_hora").val();
        compras_estado = $("#compras_estado").val();
        empleados_id = $("#empleados_id").val();
        condicion_compra = $("#condicion_compra").val();
        cuotas = $("#cuotas").val();
        idmetodos_pago = $("#idmetodos_pago").val();
        //detalle
        ingredientes_id = $("#ingredientes_id").val();
        unidad_medidaid = $("#unidad_medidaid").val();
        impuesto = $("#impuesto").val();
        detcompras_preciounitario = $("#detcompras_preciounitario").val();
        detcompras_cantidad = $("#detcompras_cantidad").val();
        total_letras = $("#total_letras").val();
        iva5_total = $("#iva5_total").val();
        iva10_total = $("#iva10_total").val();
        iva_total = $("#iva_total").val();
        total_compra = $("#total_compra").val();

        if (!proveedores_id || !condicion_compra || !ingredientes_id || !unidad_medidaid ||
                !impuesto || !detcompras_preciounitario || !detcompras_cantidad || !idmetodos_pago) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Rellene Todos Los Campos Obligatorios</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (detcompras_cantidad <= 0) {
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
            url: 'JSP/Compras.jsp',
            type: 'post',
            success: function (response) {
                console.log(response);
                $("#mensaje").html(response);
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 4000);
                //alert("dentro del succes");
                mostrardetalles();
                if (!$("#proveedores_id").prop("disabled")) {
                    $("#proveedores_id").prop("disabled", true);
                    $('#proveedores_id').selectpicker('refresh');
                    $("#idmetodos_pago").prop("disabled", true);
                    $('#idmetodos_pago').selectpicker('refresh');
                    $("#condicion_compra").prop("disabled", true);
                    $("#cuotas").prop("readonly", true);
                }
                $("#ingredientes_id").val('').selectpicker('refresh');
                $("#detcompras_preciounitario").val('');
                $("#impuesto").val('');
                $("#detcompras_cantidad").val('1');
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
        $.ajax({
            data: {listar: 'mostrardetalle'},
            url: 'JSP/Compras.jsp',
            type: 'post',
            success: function (response) {
                $("#resultados").html(response);
                totalIva5 = $("#totalIva5").val();
                totalIva10 = $("#totalIva10").val();
                $('#gravadas5').val(totalIva5);
                $('#gravadas10').val(totalIva10);
                mostrartotal10();
                mostrartotal5();
                mostrartotales();
                mostrartotaliva();
                totalletras();

            }
        });
    }
    $("#btn-eliminar").click(function () {
        listar_delete = $("#listar_delete").val();
        id_delete = $("#id_delete").val();
        $.ajax({
            data: {listar: listar_delete, id_delete: id_delete},
            url: 'JSP/Compras.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrardetalles();
                mostrartotal10();
                mostrartotal5();
                mostrartotales();
                mostrartotaliva();
                totalletras();
            }
        });
    });
    function mostrartotales() {
        $.ajax({
            data: {listar: 'mostrartotales'},
            url: 'JSP/Compras.jsp',
            type: 'post',
            success: function (response) {
                //alert(response);  
                $("#total_compra").val(response);
            }
        });
    }
    function totalletras() {
        $.ajax({
            data: {listar: 'mostrartotales'},
            url: 'JSP/Compras.jsp',
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
            url: 'JSP/Compras.jsp',
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
            url: 'JSP/Compras.jsp',
            type: 'post',
            success: function (response) {
                $("#iva10_total").val(response);
            }
        });
    }
    function mostrartotal5() {
        $.ajax({
            data: {listar: 'mostrartotal5'},
            url: 'JSP/Compras.jsp',
            type: 'post',
            success: function (response) {
                $("#iva5_total").val(response);
            }
        });
    }
    function numeroALetras(num) {
        unidades = ["", "uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve"];
        decenas = ["", "", "veinte", "treinta", "cuarenta", "cincuenta", "sesenta", "setenta", "ochenta", "noventa"];
        especiales = ["diez", "once", "doce", "trece", "catorce", "quince", "dieciséis", "diecisiete", "dieciocho", "diecinueve"];
       centenas = ["", "ciento", "doscientos", "trescientos", "cuatrocientos", "quinientos", "seiscientos", "setecientos", "ochocientos", "novecientos"];

        function convertirCientos(n) {
            if (n === 0)
                return "";
            if (n === 100)
                return "cien"; 
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
            if (n === 0)
                return "";
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
        if (num === 0)
            return "cero";
        return convertirMillones(num).trim();
    }
    $("#btn-registrar").click(function () {
        total = $("#total-compra").val();
        proveedores_id = $("#proveedores_id").val();
        idmetodos_pago = $("#idmetodos_pago").val();
        cuotas = $("#cuotas").val();
        condicion_compra = $("#condicion_compra").val();
        $.ajax({
            data: {
                listar: 'finalizar',
                total: total,
                proveedores_id: proveedores_id,
                idmetodos_pago: idmetodos_pago,
                cuotas: cuotas,
                condicion_compra: condicion_compra
            },
            url: 'JSP/Compras.jsp',
            type: 'post',
            success: function (response) {
                //alert(response);
                $("#mensaje").val(response);
                if (condicion_compra === 'Contado') {
                    location.href = 'FormListadoCompras.jsp';
                } else if (condicion_compra === 'Credito') {
                    location.href = 'FormPagos.jsp';
                }
            },
            error: function (xhr, status, error) {
                console.error("Error en la solicitud AJAX: " + error);
                console.log(xhr.responseText);
            }
        });
    });
    $("#btn-cancelar").click(function () {
        $.ajax({
            data: {listar: 'cancelar'},
            url: 'JSP/Compras.jsp',
            type: 'post',
            success: function (response) {
                location.href = 'FormListadoCompras.jsp';
            }
        });
    });
</script>
<%@include file="footer.jsp"%>
