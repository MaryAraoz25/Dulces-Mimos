<%@ include file="header.jsp"%>
<style>
    .card:hover {
        transform: none;
        transition: none;
    }

    /* Opcionalmente, desactiva cualquier transición en general */
    .card {
        transition: none;
    }
</style>
<br>
<div class="container-fluid">
    <form id="form">
        <div class="row">
            <!-- Div del Formulario -->
            <div class="col-xl-4">
                <div class="card">
                    <div class="card-header" style="background-color: #ff007b; color: white;">
                        <h5 class="mb-0">Gestión De Productos</h5>
                    </div>
                    <div class="card-body">
                        <input type="hidden" name="listar" id="listar" value="cargar">
                        <input type="hidden" name="idproductos" id="idproductos">
                        <div class="mb-3">
                            <label for="pro_nombre" class="form-label"><b>Nombre</b></label>
                            <input type="text" class="form-control" id="pro_nombre" name="pro_nombre" required>
                        </div>
                        <div class="mb-3">
                            <label for="pro_precio" class="form-label"><b>Precio</b></label>
                            <input type="text" class="form-control" id="pro_precio" name="pro_precio" required>
                        </div>
                        <div class="mb-3">
                            <label for="stock_actual" class="form-label"><b>Stock Actual</b></label>
                            <input type="number" class="form-control" id="stock_actual" name="stock_actual" required>
                        </div>
                        <div class="mb-3">
                            <label for="stock_minimo" class="form-label"><b>Stock Mínimo</b></label>
                            <input type="number" class="form-control" id="stock_minimo" name="stock_minimo" required>
                        </div>
                        <div class="mb-3">
                            <label for="impuesto" class="form-label"><b>Impuesto</b></label>
                            <input type="number" class="form-control" id="impuesto" name="impuesto" value="10" readonly>
                        </div>
                        <div class="mb-3">
                            <label for="categ_productos" class="form-label"><b>Categoría</b></label>
                            <select class="selectpicker" id="categ_productos" name="categ_productos" required data-live-search="true" data-dropup-auto="false">
                                <!-- Opciones dinámicas se cargarán aquí -->
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="unidad_de_medida_id" class="form-label"><b>Unidad De Medida</b></label>
                            <!--input type="text" class="form-control" id="unidad_de_medida_id" name="unidad_de_medida_id" --->
                            <select class="selectpicker" id="unidad_de_medida_id" name="unidad_de_medida_id" required data-live-search="true" data-dropup-auto="false">
                                <!-- Opciones dinámicas se cargarán aquí -->
                            </select>
                        </div>
                        <div class="mb-3 text-end">
                            <button type="button" class="btn btn-success" id="boton">Guardar</button>
                            <button type="button" class="btn btn-secondary" id="btn-cancelar">Cancelar</button>
                        </div>
                        <div id="mensaje"></div>
                    </div>
                </div>
            </div>

            <!-- Div de la Tabla -->
            <div class="col-xl-8 col-lg-8 col-md-12">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center" style="background-color: #ff007b; color: white;">
                        <h5 class="mb-0">Lista De Productos</h5>
                        <a href="${pageContext.request.contextPath}/ReportesJSP/ListadoProductos.jsp" target="_blank" style="color: black;" title="Generar Reporte"><i class="fa-solid fa-print" style="color: black; font-size: 1.5rem;"></i></a>
                    </div>
                    <div class="card-body">
                        <div class="input-group mb-3">
                            <input type="text" class="form-control" placeholder="Buscar" id="buscador" name="buscador">
                        </div>
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover" id="resultado">
                                <thead class="text-center">
                                    <tr>
                                        <th>Id</th>
                                        <th>Nombre</th>
                                        <th>Precio</th>
                                        <th>Stock Actual</th>
                                        <th>Stock Mínimo</th>
                                        <th>Impuesto</th>
                                        <th>Categoría</th>
                                        <th>Unidad De Medida</th>
                                        <th>Acción</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Aquí se cargarán los datos dinámicamente -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
    </form>
</div>

<!-- Modal -->
<div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content" style="background-color: #ffffff; border-radius: 0.25rem;">
            <div class="modal-header" style="background-color: #ff007b; border-bottom: 1px solid #e9ecef;">
                <h1 class="modal-title fs-5" id="staticBackdropLabel" style="color: #ffffff;"><b>Eliminar Datos</b></h1>
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
        rellenardatos();
        cargarUnidades();
        cargarCategorias();
        $("#unidad_de_medida_id").on("keypress", function (event) {
            if (event.which === 13) {
                event.preventDefault();
                $("#boton").click();
            }
        });
        $('.selectpicker').selectpicker({
            dropupAuto: false,
            width: '100%'
        });
        invalidChars = /[><"'()]/;
        function preventInvalidInput(event) {
            input = $(this).val();
            if (invalidChars.test(input)) {
                $(this).val(input.replace(invalidChars, ''));
            }
        }
        $("#pro_nombre, #pro_precio, #buscador").on("input", preventInvalidInput);
    });
    $("#boton").on('click', function () {
        pro_nombre = $("#pro_nombre").val();
        pro_precio = $("#pro_precio").val().replace('.', '');
        stock_actual = $("#stock_actual").val();
        stock_minimo = $("#stock_minimo").val();
        impuesto = $("#impuesto").val();
        categ_productos = $("#categ_productos").val();
        unidad_de_medida_id = $("#unidad_de_medida_id").val();


        if (pro_nombre === "" || !/^[A-Za-záéíóúüÜñÑ\s]+$/.test(pro_nombre)) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El nombre debe contener solo letras y no puede estar vacío.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 2000);
            return;
        } else if (pro_precio === "" || parseFloat(pro_precio) <= 0) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El precio debe ser un número positivo y no puede estar vacío.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 2000);
            return;
        } else if (pro_nombre.trim().length < 3) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El nombre del producto debe contener al menos 3 letras.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 2000);
            return;
        } else if (stock_actual === "" || !/^\d+$/.test(stock_actual) || parseInt(stock_actual) <= 0) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El stock actual debe ser un número positivo y no puede estar vacío.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 2000);
            return;
        } else if (stock_minimo === "" || !/^\d+$/.test(stock_minimo) || parseInt(stock_minimo) <= 0) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El stock mínimo debe ser un número positivo y no puede estar vacío.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 2000);
            return;
        } else if (categ_productos === "selectcateg") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Debe seleccionar una categoría.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 2000);
            return;
        } else {
            formdata = $("#form").serialize();
            $.ajax({
                data: formdata,
                url: 'JSP/Productos.jsp',
                type: 'post',
                success: function (response) {
                    $("#mensaje").html(response);
                    $("#mensaje").fadeIn();
                    rellenardatos();
                    //cargarUnidades();
                    cargarCategorias();
                    setTimeout(function () {
                        $("#mensaje").fadeOut();
                    }, 2000);
                    resetForm();
                    $("#buscador").val("");
                },
                error: function (xhr, status, error) {
                    console.error(xhr.responseText);
                }
            });
        }
    });
    $('#pro_precio').on('input', function (e) {
        $(this).val(formatNumber($(this).val()));
    });

    $("#btn-cancelar").on('click', function () {
        resetForm();
        $("#buscador").val('');
        $("#categ_productos").selectpicker('refresh');
        //$("#unidad_de_medida_id").selectpicker('refresh');
        rellenardatos();
    });

    $("#btn-eliminar").on('click', function () {
        listar_delete = $("#listar_delete").val();
        id_delete = $("#id_delete").val();
        $.ajax({
            data: {listar: listar_delete, id_delete: id_delete},
            url: 'JSP/Productos.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                $("#mensaje").fadeIn();
                rellenardatos();
                //cargarUnidades();
                cargarCategorias();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 2000);
                $("#buscador").val("");
            }
        });
    });
    $('#buscador').on('keyup', function () {
        buscador = $(this).val();
        $.ajax({
            data: {listar: 'buscador', buscador: buscador},
            url: 'JSP/Productos.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
            }
        });
    });

    function rellenardatos() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'JSP/Productos.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
                $("#pro_nombre").focus();
            }
        });
    }
    function resetForm() {
        $("#form")[0].reset();
        $("#listar").val("cargar");
        $("#pro_nombre").focus();
    }
    function cargarCategorias() {
        $.ajax({
            data: {listar: 'cargarCategorias'},
            url: 'JSP/Productos.jsp',
            type: 'post',
            success: function (response) {
                $("#categ_productos").html(response);
                $("#categ_productos").selectpicker('refresh');
            }
        });
    }

    function cargarUnidades() {
        $.ajax({
            data: {listar: 'cargarUnidades'},
            url: 'JSP/Productos.jsp',
            type: 'post',
            success: function (response) {
                $("#unidad_de_medida_id").html(response);
                $("#unidad_de_medida_id").selectpicker('refresh');
            }
        });
    }
    $.fn.selectpicker.Constructor.DEFAULTS.liveSearchStyle = 'startsWith';
    $.fn.selectpicker.Constructor.DEFAULTS.liveSearchFilter = function (searchValue, option) {
        return option.toLowerCase().startsWith(searchValue.toLowerCase());
    };

    function rellenarjs(idproductos, pro_nombre, pro_precio, stock_actual, stock_minimo, impuesto, categ_productos, unidad_de_medida_id) {
        $("#idproductos").val(idproductos);
        $("#pro_nombre").val(pro_nombre);
        var pro_precioForm = parseInt(pro_precio).toLocaleString('es-ES');
        $("#pro_precio").val(pro_precioForm);
        $("#stock_actual").val(stock_actual);
        $("#stock_minimo").val(stock_minimo);
        $("#impuesto").val(impuesto);
        $("#unidad_de_medida_id").val(unidad_de_medida_id);
        $("#categ_productos").val(categ_productos).selectpicker('refresh');
        $("#unidad_de_medida_id").val(unidad_de_medida_id).selectpicker('refresh');
        $("#listar").val("modificar");
    }

    function formatNumber(number) {
        return number.replace(/\D/g, "")
                .replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    }




</script>

<%@include file="footer.jsp"%>

