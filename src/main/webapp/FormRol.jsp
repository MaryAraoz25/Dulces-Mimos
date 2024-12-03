<%-- 
    Document   : FormRol
    Created on : 21 may. 2024, 11:49:01
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
        <!-- Formulario de Roles -->
        <div class="col-xl-6">
            <div class="card">
                <div class="card-header" style="background-color: #ff007b; color: white;">
                    <h5 class="mb-0">Gestión de Roles</h5>

                </div>
                <div class="card-body">
                    <form id="form">
                        <input type="hidden" name="listar" id="listar" value="cargar">
                        <input type="hidden" name="id_rol" id="id_rol">
                        <div class="mb-3">
                            <label for="rol_nombre" class="form-label"><b>Nombre del Rol</b></label>
                            <input type="text" class="form-control" id="rol_nombre" name="rol_nombre" required>
                        </div>
                        <div class="mb-3 text-end">

                            <button type="button" class="btn btn-success" id="btn-guardar">Guardar</button>
                            <button type="button" class="btn btn-secondary" id="btn-cancelar">Cancelar</button>
                        </div>
                        <div id="mensaje"></div>
                </div>
            </div>
        </div>
        <!-- Tabla de Roles -->
        <div class="col-xl-6">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center" style="background-color: #ff007b; color: white;">
                    <h5 class="mb-0">Lista De Roles</h5>
                    <a href="${pageContext.request.contextPath}/ReportesJSP/ListadoRoles.jsp" target="_blank" style="color: black;" title="Generar Reporte"><i class="fa-solid fa-print" style="color: black; font-size: 1.5rem;"></i></a>
                </div>
                <div class="card-body">
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" placeholder="Buscar" id="buscador" name="buscador">
                    </div>
                    <div>
                        <table class="table table-bordered table-hover" id="resultado">
                            <thead class="text-center">
                                <tr>
                                    <th class="text-center">Id</th>
                                    <th>Nombre</th>
                                    <th class="text-center">Acción</th>
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
        $("#rol_nombre, #buscador").on("input", preventInvalidInput);
    });

    $("#rol_nombre").on("keypress", function (event) {
        if (event.which === 13) {
            event.preventDefault();
            $("#btn-guardar").click();
        }
    });

    $("#btn-guardar").on('click', function () {
        rolNombre = $("#rol_nombre").val();
        if (rolNombre === "") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Rellene el campo, Por favor.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            $("#rol_nombre").focus();
            return;
        } else if (!/^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]+$/.test(rolNombre) || rolNombre.trim().length === 0) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El nombre del rol no debe contener números, caracteres especiales, ni estar vacío o solo contener espacios.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (rolNombre.trim().length < 4) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El nombre del rol debe contener al menos 4 letras.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else {
            formdata = $("#form").serialize();
            $.ajax({
                data: formdata,
                url: 'JSP/Rol.jsp',
                type: 'post',
                success: function (response) {
                    $("#mensaje").html(response);
                    $("#mensaje").fadeIn();
                    setTimeout(function () {
                        $("#mensaje").fadeOut();
                    }, 3000);
                    rellenardatos();
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
            url: 'JSP/Rol.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                $("#mensaje").fadeIn();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 3000);
                rellenardatos();
                $("#buscador").val('');
            }
        });
    });

    $('#buscador').on('keyup', function () {
        buscador = $(this).val();
        $.ajax({
            data: {listar: 'buscador', buscador: buscador},
            url: 'JSP/Rol.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);

            }
        });
    });


    function rellenardatos() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'JSP/Rol.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
                $("#rol_nombre").focus();
                $("#buscador").val('');
            }
        });
    }

    function rellenarjs(id_rol, rol_nombre) {
        $("#id_rol").val(id_rol);
        $("#rol_nombre").val(rol_nombre);
        $("#listar").val("modificar");
    }
    function resetForm() {
        $("#form")[0].reset();
        $("#listar").val("cargar");
        $("#rol_nombre").focus();
    }

</script>

<%@include file="footer.jsp"%>
