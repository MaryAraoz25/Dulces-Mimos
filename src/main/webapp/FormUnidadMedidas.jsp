<%-- 
    Document   : FormUnidadMedidas
    Created on : 30 may. 2024, 20:32:16
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
    <form id="form">
        <div class="row">
            <!-- Div del Formulario -->
            <div class="col-xl-4">
                <div class="card">
                    <div class="card-header" style="background-color: #ff007b; color: white;">
                        <h5 class="mb-0">Gestión De Unidad De Medida</h5>
                    </div>
                    <div class="card-body">
                        <input type="hidden" name="listar" id="listar" value="cargar">
                        <input type="hidden" name="idunidad_medida" id="idunidad_medida">
                        <div class="mb-3">
                            <label for="descripcion" class="form-label"><b>Descripción</b></label>
                            <input type="text" class="form-control" id="descripcion" name="descripcion" required>
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
            <div class="col-xl-8">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center" style="background-color: #ff007b; color: white;">
                        <h5 class="mb-0">Lista De Unidad De Medidas</h5>
                        <a href="${pageContext.request.contextPath}/ReportesJSP/ListadoUnidadMedidas.jsp" target="_blank" style="color: black;" title="Generar Reporte"><i class="fa-solid fa-print" style="color: black; font-size: 1.5rem;"></i></a>
                    </div>
                    <div class="card-body">
                        <div class="input-group mb-3">
                            <input type="text" class="form-control" placeholder="Buscar" id="buscador" name="buscador">
                        </div>
                        <table class="table table-bordered table-hover" id="resultado">
                            <thead class="text-center">
                                <tr>
                                    <th>Id</th>
                                    <th>Descripción</th>
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

        $("#descripcion").on("keypress", function (event) {
            if (event.which === 13) {
                event.preventDefault();
                $("#boton").click();
            }
        });
        invalidChars = /[><"'()]/;
        function preventInvalidInput(event) {
            input = $(this).val();
            if (invalidChars.test(input)) {
                $(this).val(input.replace(invalidChars, ''));
            }
        }
        $("#descripcion, #buscador").on("input", preventInvalidInput);
    });
    $("#boton").on('click', function () {
        validar = /^[A-Za-záéíóúüÜñÑ\s]+$/;
        descripcion = $("#descripcion").val().trim();
        if (descripcion === "") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Rellene el campo, por favor.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 2000);
            return;
        } else if (descripcion.length < 4) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>La descripción debe tener como máximo 4 letras.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 2000);
            return;
        } else if (!validar.test(descripcion)) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El campo no debe contener números ni símbolos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 2000);
            return;
        } else if (!/^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]+$/.test(descripcion) || descripcion.trim().length === 0) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>La Descripción no debe contener números, caracteres especiales, ni estar vacío o solo contener espacios.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 2000);
            return;
        } else {
            formdata = $("#form").serialize();
            $.ajax({
                data: formdata,
                url: 'JSP/UnidadMedida.jsp',
                type: 'post',
                success: function (response) {
                    $("#mensaje").html(response);
                    $("#mensaje").fadeIn();
                    rellenardatos();
                    setTimeout(function () {
                        $("#mensaje").fadeOut();
                    }, 2000);
                    resetForm();
                    $("#buscador").val('');
                }
            });
        }
    });

    $("#btn-cancelar").on('click', function () {
        resetForm();
        $("#buscador").val('');
        rellenardatos();
    });

    $("#btn-eliminar").on('click', function () {
        listar_delete = $("#listar_delete").val();
        id_delete = $("#id_delete").val();
        $.ajax({
            data: {listar: listar_delete, id_delete: id_delete},
            url: 'JSP/UnidadMedida.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                $("#mensaje").fadeIn();
                rellenardatos();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 2000);
                $("#buscador").val('');
            }
        });
    });

    $('#buscador').on('keyup', function () {
        buscador = $(this).val();
        $.ajax({
            data: {listar: 'buscador', buscador: buscador},
            url: 'JSP/UnidadMedida.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
            }
        });
    });


    function rellenardatos() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'JSP/UnidadMedida.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
                $("#descripcion").focus();
                $("#buscador").val('');
            }
        });
    }

    function rellenarjs(idunidad_medida, descripcion) {
        $("#idunidad_medida").val(idunidad_medida);
        $("#descripcion").val(descripcion);
        $("#listar").val("modificar");
    }

    function resetForm() {
        $("#form")[0].reset();
        $("#listar").val("cargar");
        $("#descripcion").focus();
    }
</script>

<%@include file="footer.jsp"%>


