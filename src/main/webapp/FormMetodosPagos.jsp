<%-- 
    Document   : FormMetodosPagos
    Created on : 30 may. 2024, 20:31:29
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
                    <h5 class="mb-0">Gestión de Métodos De Pago</h5>
                </div>
                <div class="card-body">
                    <form id="form">
                        <input type="hidden" name="listar" id="listar" value="cargar">
                        <input type="hidden" name="idmetodos_pago" id="idmetodos_pago">
                        <div class="mb-3">
                            <label class="form-label"><b>Nombre</b></label>
                            <input type="text" class="form-control" id="metpag_nombre" name="metpag_nombre" required>
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
        <!-- Tabla de Métodos de Pago -->
        <div class="col-xl-8">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center" style="background-color: #ff007b; color: white;">
                    <h5 class="mb-0">Lista De Métodos De Pagos</h5>
                    <a href="${pageContext.request.contextPath}/ReportesJSP/ListadoMetodosPagos.jsp" target="_blank" style="color: black;" title="Generar Reporte"><i class="fa-solid fa-print" style="color: black; font-size: 1.5rem;"></i></a>
                </div>
                <div class="card-body">
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" placeholder="Buscar" id="buscador" name="buscador">
                    </div>
                    <div class="table-responsive"> <!-- Agregado para hacer la tabla responsive -->
                        <table class="table table-bordered table-hover" id="resultado">
                            <thead class="text-center">
                                <tr>
                                    <th>Id</th>
                                    <th>Nombre</th>             
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
        invalidChars = /[><"'()]/;
        function preventInvalidInput(event) {
            input = $(this).val();
            if (invalidChars.test(input)) {
                $(this).val(input.replace(invalidChars, ''));
            }
        }
        $("#metpag_nombre, #buscador").on("input", preventInvalidInput);
    });

    $("#boton").on('click', function () {
        metpag_nombre = $("#metpag_nombre").val();

        regex = /^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$/;

        if (metpag_nombre.trim() === "") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El nombre no puede estar vacío.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (!regex.test(metpag_nombre)) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El nombre no puede contener números ni símbolos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (metpag_nombre.trim().length < 6) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El método de pago debe contener al menos 6 letras.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (metpag_nombre.trim() === " ") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El nombre no puede ser un espacio en blanco.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        }
        formdata = $("#form").serialize();
        $.ajax({
            data: formdata,
            url: 'JSP/MetodoPago.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                $("#mensaje").fadeIn();
                rellenardatos();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 3000);
                resetForm();
                $("#buscador").val('');
            }
        });
    });


    $("#metpag_nombre").on('keydown', function (event) {
        if (event.key === "Enter") {
            event.preventDefault();
            $("#boton").click();
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
            url: 'JSP/MetodoPago.jsp',
            success: function (response) {
                $("#mensaje").html(response);
                $("#mensaje").fadeIn();
                rellenardatos();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 3000);
                $("#buscador").val('');
            }
        });
    });


    $("#buscador").on('keyup', function () {
        buscador = $(this).val();
        $.ajax({
            data: {listar: 'buscador', buscador: buscador},
            url: 'JSP/MetodoPago.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
            }
        });
    });
    function resetForm() {
        $("#form")[0].reset();
        $("#listar").val("cargar");
        $("#metpag_nombre").focus();
    }
    function rellenardatos() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'JSP/MetodoPago.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
                $("#metpag_nombre").focus();
                $("#buscador").val('');
            }
        });
    }


    function rellenarjs(idmetodos_pago, metpag_nombre) {
        $("#idmetodos_pago").val(idmetodos_pago);
        $("#metpag_nombre").val(metpag_nombre);
        $("#listar").val("modificar");
    }
</script>

<%@include file="footer.jsp"%>
