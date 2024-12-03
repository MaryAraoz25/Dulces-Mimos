<%-- 
    Document   : FormRecetas
    Created on : 24 jun. 2024, 21:05:36
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
<div class="container-fluid mt-4">
    <div class="card shadow-lg">
        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Gestión De Recetas</h5>
        </div>
        <div class="card-body">
            <form id="form">
                <!-- Datos de la Receta -->
                <div class="row">
                    <div class="col-md-6">
                        <input type="hidden" name="listar" id="listar" value="cargar">
                        <input type="hidden" name="idrecetas_productos" id="idrecetas_productos">
                        <div class="mb-3">
                            <label for="productos_id" class="form-label"><b>Producto</b></label>
                            <select class="selectpicker form-control" id="productos_id" name="productos_id" required data-live-search="true" data-dropup-auto="false">
                                <!-- Opciones dinámicas se cargarán aquí -->
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="nombre_receta" class="form-label"><b>Nombre De La Receta</b></label>
                            <input type="text" class="form-control form-control-sm" id="nombre_receta" name="nombre_receta" readonly>
                        </div>
                        <div class="mb-3">
                            <label for="empleados_id" class="form-label"><b>Empleado</b></label>
                            <input type="text" class="form-control form-control-sm" id="empleados_id" name="empleados_id" value="<%= emple_nombre%>" readonly>
                        </div>
                        <div class="mb-3">
                            <label for="recetaspro_estado" class="form-label"><b>Estado</b></label>
                            <input type="text" class="form-control form-control-sm" id="recetaspro_estado" name="recetaspro_estado" required value="Pendiente" readonly>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="tipo_preparacion" class="form-label"><b>Preparación</b></label>
                            <textarea id="tipo_preparacion" class="form-control" name="tipo_preparacion" rows="10" required></textarea>
                        </div>
                    </div>
                </div>

                <!-- Detalle de Recetas -->
                <div class="card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">Detalle de Recetas</h5>
                    </div>
                    <div class="card-body">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label for="ingredientes_id" class="form-label"><b>Ingrediente</b></label>
                                <select class="selectpicker form-control" id="ingredientes_id" name="ingredientes_id" required data-live-search="true" data-dropup-auto="false">
                                    <!-- Opciones dinámicas se cargarán aquí -->
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label for="unidad_medida" class="form-label"><b>Unidad de Medida</b></label>
                                <input type="text" class="form-control form-control-sm" id="unidad_medida" name="unidad_medida" readonly>
                            </div>
                            <div class="col-md-4">
                                <label for="detcompras_cantidad" class="form-label"><b>Cantidad</b></label>
                                <input type="number" class="form-control form-control-sm" id="detcompras_cantidad" name="detcompras_cantidad" value="1" required>
                            </div>
                        </div>
                        <div class="table-responsive mt-3">
                            <table class="table table-bordered table-hover">
                                <thead class="text-center bg-light">
                                    <tr>
                                        <th>Ingrediente</th>
                                        <th>Unidad De Medida</th>
                                        <th>Cantidad</th>
                                        <th>Acción</th>
                                    </tr>
                                </thead>
                                <tbody id="resultados">
                                    <!-- Aquí se agregarán los detalles dinámicamente -->
                                </tbody>
                            </table>
                        </div>

                        <!-- Mensaje y Botones -->
                        <div class="row mt-4">
                            <div class="col-md-12">
                                <div class="mb-3">
                                    <div id="mensaje" class="text-end"></div>
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
                <!-- Fin del Detalle de Recetas -->
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
        cargarIngredientes();
        cargarProductos();
        $('.selectpicker').selectpicker({
            dropupAuto: false,
            width: '100%'
        });
        $('#btn-registrar').hide();
        $('#btn-cancelar').hide();
        invalidChars = /[><"'()]/;
        function preventInvalidInput(event) {
            input = $(this).val();
            if (invalidChars.test(input)) {
                $(this).val(input.replace(invalidChars, ''));
            }
        }
        $("#tipo_preparacion").on("input", preventInvalidInput);
    });

    $("#ingredientes_id").change(function () {
        selectedIngrediente = $(this).val();
        selectedOption = $(this).find("option:selected");
        $("#unidad_medida").val(selectedOption.data("unidad"));
    });

    function cargarIngredientes() {
        $.ajax({
            data: {listar: 'cargarIngredientes'},
            url: 'JSP/Recetas.jsp',
            type: 'post',
            success: function (response) {
                $("#ingredientes_id").html(response);
                $("#ingredientes_id").selectpicker('refresh');
            }
        });
    }

    function cargarProductos() {
        $.ajax({
            data: {listar: 'cargarProductos'},
            url: 'JSP/Recetas.jsp',
            type: 'post',
            success: function (response) {
                $("#productos_id").html(response);
                $("#productos_id").selectpicker('refresh');
                $("#productos_id").change(function () {
                    selectedOption = $(this).find("option:selected");
                    productoNombre = selectedOption.text();
                    $('#nombre_receta').val(productoNombre);

                });
            }
        });
    }


    function resetForm() {
        $("#form")[0].reset();
        $("#listar").val("cargar");
        $("#productos_id").focus();
        $("#productos_id").selectpicker('refresh');
    }
    $("#btn-agregar").click(function () {

        $('#btn-registrar').show();
        $('#btn-cancelar').show();


        productos = $("#productos_id").val();
        nombreReceta = $("#nombre_receta").val();
        empleadosId = $("#empleados_id").val();
        recetasproEstado = $("#recetaspro_estado").val();
        tipoPreparacion = $("#tipo_preparacion").val();
        ingredientesId = $("#ingredientes_id").val();
        unidadMedida = $("#unidad_medida").val();
        detComprasCantidad = $("#detcompras_cantidad").val();

        if (!productos || !nombreReceta || !empleadosId || !recetasproEstado ||
                !tipoPreparacion || !ingredientesId || !unidadMedida || !detComprasCantidad) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Rellene Todos Los Campos</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (detComprasCantidad <= 0) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>No se permiten números negativos</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        }
        formdata = $("#form").serialize();
        $.ajax({
            data: formdata,
            url: 'JSP/Recetas.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 4000);
                mostrardetalles();
                if (!$("#productos_id").prop("disabled")) {
                    $("#productos_id").prop("disabled", true);
                    $('#productos_id').selectpicker('refresh');
                    $("#nombre_receta").prop("readonly", true);
                    $("#empleados_id").prop("readonly", true);
                    $("#recetaspro_estado").prop("readonly", true);
                    $("#tipo_preparacion").prop("readonly", true);
                }
                $("#ingredientes_id").val('').selectpicker('refresh');
                $("#unidad_medida").val('');
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
    $("#btn-eliminar").click(function () {
        listar_delete = $("#listar_delete").val();
        id_delete = $("#id_delete").val();
        $.ajax({
            data: {listar: listar_delete, id_delete: id_delete},
            url: 'JSP/Recetas.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                mostrardetalles();

            }
        });
    });
    $("#btn-registrar").click(function () {
        form = $("#form").serialize();
        $.ajax({
            data: {listar: 'finalizar'},
            url: 'JSP/Recetas.jsp',
            type: 'post',
            success: function (response) {
                location.href = 'FormListadoRecetas.jsp';
                resetForm();
            }
        });
    });

    function mostrardetalles() {
        $.ajax({
            data: {listar: 'mostrardetalle'},
            url: 'JSP/Recetas.jsp',
            type: 'post',
            success: function (response) {
                $("#resultados").html(response);
            }
        });
    }
    $("#btn-cancelar").click(function () {
        $.ajax({
            data: {listar: 'cancelar'},
            url: 'JSP/Recetas.jsp',
            type: 'post',
            success: function (response) {
                location.href = 'FormListadoRecetas.jsp';
                resetForm();
            }
        });
    });
    $.fn.selectpicker.Constructor.DEFAULTS.liveSearchStyle = 'startsWith';
    $.fn.selectpicker.Constructor.DEFAULTS.liveSearchFilter = function (searchValue, option) {
        return option.toLowerCase().startsWith(searchValue.toLowerCase());
    };
</script>
<%@include file="footer.jsp"%>
