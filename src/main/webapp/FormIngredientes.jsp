<%-- 
    Document   : FormIngredientes
    Created on : 30 may. 2024, 20:31:55
    Author     : Maria
--%>


<%@include file="header.jsp"%>
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
    <div class="row">
        <!-- Formulario -->
        <div class="col-xl-4">
            <div class="card">
                <div class="card-header" style="background-color: #ff007b; color: white;">
                    <h5 class="mb-0">Gestión de Ingredientes</h5>
                </div>
                <div class="card-body">
                    <form id="form">
                        <input type="hidden" name="listar" id="listar" value="cargar">
                        <input type="hidden" name="idingredientes" id="idingredientes">
                        <div class="mb-3">
                            <label class="form-label"><b>Nombre</b></label>
                            <input type="text" class="form-control" id="ingre_nombre" name="ingre_nombre" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><b>Stock</b></label>
                            <input type="number" class="form-control" id="ingre_stock" name="ingre_stock" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><b>Stock Mínimo</b></label>
                            <input type="number" class="form-control" id="ingre_stockmin" name="ingre_stockmin" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><b>Impuesto</b></label>
                            <select class="form-select" id="impuesto" name="impuesto" required>
                                <option value="5">5</option>
                                <option value="10">10</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><b>Unidad De Medida</b></label>
                            <select class="selectpicker" id="unidad_de_medida_id" name="unidad_de_medida_id" required data-live-search="true" data-dropup-auto="false">
                                <!-- Opciones dinámicas se cargarán aquí -->
                            </select>
                        </div>
                        <div class="mb-3 text-end">
                            <button type="button" class="btn btn-success" id="boton">Guardar</button>
                            <button type="button" class="btn btn-secondary" id="btn-cancelar">Cancelar</button>
                        </div>
                        <div id="mensaje"></div>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-xl-8">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center" style="background-color: #ff007b; color: white;">
                    <h5 class="mb-0">Lista De Ingredientes</h5>
                    <a href="${pageContext.request.contextPath}/ReportesJSP/ListadoIngredientes.jsp" target="_blank" style="color: black;" title="Generar Reporte"><i class="fa-solid fa-print" style="color: black; font-size: 1.5rem;"></i></a>
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
                                    <th>Stock</th>
                                    <th>Stock Mínimo</th>
                                    <th>Unidad De Medida</th>
                                    <th>Impuesto</th>
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
    </div>
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
    $("#ingre_nombre, #buscador").on("input", preventInvalidInput);
});
    $("#boton").on('click', function () {
        ingre_nombre = $("#ingre_nombre").val().trim();
        ingre_stock = $("#ingre_stock").val().trim();
        ingre_stockmin = $("#ingre_stockmin").val().trim();
        unidad_de_medida_id = $("#unidad_de_medida_id").val().trim();
        impuesto = $("#impuesto").val().trim();
        if (!ingre_nombre.match(/^[A-Za-zÁÉÍÓÚáéíóúñÑ\s]+$/) || ingre_nombre.trim() === "") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El nombre solo debe contener letras y acentos. No se permiten espacios en blanco.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 2000);
            return;
        } else if (ingre_nombre.trim().length < 3) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El nombre del Ingrediente debe contener al menos 3 letras.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 2000);
            return;
        } else if (ingre_stock === "" || isNaN(ingre_stock) || ingre_stock < 0 || ingre_stock.trim() === "") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El stock debe ser un número positivo. No se permiten espacios en blanco.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 2000);
            return;
        } else if (ingre_stockmin === "" || isNaN(ingre_stockmin) || ingre_stockmin < 0 || ingre_stockmin.trim() === "") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El stock mínimo debe ser un número positivo. No se permiten espacios en blanco.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 2000);
            return;
        } else if (unidad_de_medida_id === "selectuni" || unidad_de_medida_id.trim() === "") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Seleccione una unidad de medida. No se permiten espacios en blanco.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 2000);
            return;
        }
        formdata = $("#form").serialize();
        $.ajax({
            data: formdata,
            url: 'JSP/Ingredientes.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                $("#mensaje").fadeIn();
                rellenardatos();
                cargarUnidades();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 2000);
                resetForm();
                $("#buscador").val("");
            }
        });
    });

    $("#unidad_de_medida_id").on('keydown', function (event) {
        if (event.key === "Enter") {
            event.preventDefault();
            $("#boton").click();
        }
    });

    $("#btn-cancelar").on('click', function () {
        resetForm();
        $("#buscador").val('');
        $("#unidad_de_medida_id").selectpicker('refresh');
        rellenardatos();
    });

    $("#btn-eliminar").on('click', function () {
        listar_delete = $("#listar_delete").val();
        id_delete = $("#id_delete").val();
        $.ajax({
            data: {listar: listar_delete, id_delete: id_delete},
            url: 'JSP/Ingredientes.jsp',
            success: function (response) {
                $("#mensaje").html(response);
                $("#mensaje").fadeIn();
                rellenardatos();
                cargarUnidades();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 2000);
                $("#buscador").val("");
            }
        });
    });

    $("#buscador").on('keyup', function () {
        buscador = $(this).val();
        $.ajax({
            data: {listar: 'buscador', buscador: buscador},
            url: 'JSP/Ingredientes.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
            }
        });
    });

    function resetForm() {
        $("#form")[0].reset();
        $("#listar").val("cargar");
        $("#ingre_nombre").focus();
    }

    function rellenardatos() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'JSP/Ingredientes.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
                $("#ingre_nombre").focus();
                $("#buscador").val("");
            }
        });
    }

    function cargarUnidades() {
        $.ajax({
            data: {listar: 'cargarUnidades'},
            url: 'JSP/Ingredientes.jsp',
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

    function rellenarjs(idingredientes, ingre_nombre, ingre_stock, ingre_stockmin, unidad_de_medida_id, impuesto) {
        $("#idingredientes").val(idingredientes);
        $("#ingre_nombre").val(ingre_nombre);
        $("#ingre_stock").val(ingre_stock);
        $("#ingre_stockmin").val(ingre_stockmin);
        $("#unidad_de_medida_id").val(unidad_de_medida_id).selectpicker('refresh');
        $("#listar").val("modificar");
        $("#impuesto option").filter(function () {
            return $(this).text() === impuesto;
        }).prop('selected', true);

    }
</script>


<%@include file="footer.jsp"%>

