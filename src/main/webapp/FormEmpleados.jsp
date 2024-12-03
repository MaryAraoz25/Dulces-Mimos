<%-- 
    Document   : FormEmpleados
    Created on : 30 may. 2024, 20:30:25
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
                    <h5 class="mb-0">Gestión de Empleados</h5>
                </div>
                <div class="card-body">
                    <form id="form">
                        <input type="hidden" name="listar" id="listar" value="cargar">
                        <input type="hidden" name="idempleados" id="idempleados">
                        <div class="mb-3">
                            <label class="form-label"><b>Nombre</b></label>
                            <input type="text" class="form-control" id="emple_nombre" name="emple_nombre" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><b>Apellido</b></label>
                            <input type="text" class="form-control" id="emple_apellido" name="emple_apellido" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><b>Cédula</b></label>
                            <input type="text" class="form-control" id="emple_ci" name="emple_ci" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><b>Dirección</b></label>
                            <input type="text" class="form-control" id="emple_direccion" name="emple_direccion" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><b>Estado</b></label>
                            <select class="form-select" id="emple_estado" name="emple_estado" required>
                                <option value="select">Seleccione un Estado</option>
                                <option value="Activo">Activo</option>
                                <option value="Inactivo">Inactivo</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><b>Teléfono</b></label>
                            <input type="tel" class="form-control" id="emple_telefono" name="emple_telefono" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><b>Correo</b></label>
                            <input type="email" class="form-control" id="emple_correo" name="emple_correo" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><b>Usuario</b></label>
                            <select class="selectpicker custom-select-style" id="usuarios_id" name="usuarios_id" required data-live-search="true" data-dropup-auto="false">
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
        <!-- Tabla de Empleados -->
        <div class="col-xl-8">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center" style="background-color: #ff007b; color: white;">
                    <h5 class="mb-0">Lista De Empleados</h5>
                    <a href="${pageContext.request.contextPath}/ReportesJSP/ListadoEmpleados.jsp" target="_blank" style="color: black;" title="Generar Reporte"><i class="fa-solid fa-print" style="color: black; font-size: 1.5rem;"></i></a>
                </div>
                <div class="card-body">
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" placeholder="Buscar Empleado" id="buscador" name="buscador">
                    </div>
                    <div class="table-responsive"> 
                        <table class="table table-bordered table-hover" id="resultado">
                            <thead class="text-center">
                                <tr>
                                    <th>Id</th>
                                    <th>Nombre</th>
                                    <th>Apellido</th>
                                    <th>Cédula</th>
                                    <th>Dirección</th>
                                    <th>Estado</th>
                                    <th>Teléfono</th>
                                    <th>Correo</th>
                                    <th>Usuario</th>
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
        cargarUsuarios();
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
        $("#emple_nombre, #emple_apellido, #emple_ci, #emple_direccion, #emple_correo, #emple_telefono, #buscador").on("input", preventInvalidInput);
    });
    $("#boton").on('click', function () {
        emple_nombre = $("#emple_nombre").val();
        emple_apellido = $("#emple_apellido").val();
        emple_ci = $("#emple_ci").val().replace(/\D/g, '');
        emple_direccion = $("#emple_direccion").val();
        emple_estado = $("#emple_estado").val();
        emple_telefono = $("#emple_telefono").val().replace(/\D/g, '');
        emple_correo = $("#emple_correo").val();
        usuarios_id = $("#usuarios_id").val();

        validarNombreApellido = /^[A-Za-záéíóúÁÉÍÓÚñÑ\s]+$/;

        if (emple_nombre === "") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Rellene El Campo Nombre, Por favor.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (!validarNombreApellido.test(emple_nombre)) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El campo Nombre no debe contener números ni símbolos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (/\s{2,}/.test(emple_nombre)) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El campo Nombre no debe contener múltiples espacios consecutivos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (emple_apellido === "") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Rellene El Campo Apellido, Por favor.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (!validarNombreApellido.test(emple_apellido)) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El campo Apellido no debe contener números ni símbolos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (/\s{2,}/.test(emple_apellido)) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El campo Apellido no debe contener múltiples espacios consecutivos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (emple_ci === "") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Rellene El Campo Cédula, Por favor.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (emple_ci.length < 7 || emple_ci.length > 10) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>La cédula debe tener entre 7 y 10 dígitos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (emple_direccion === "") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Rellene El Campo Dirección, Por favor.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (!/^[A-Za-z0-9\s]{3,}$/.test(emple_direccion)) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>La dirección debe contener al menos 3 caracteres (letras, números o espacios).</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (emple_telefono === "") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Rellene El Campo Teléfono, Por favor.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (isNaN(emple_telefono.replace(/\s/g, ''))) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El campo Teléfono solo debe contener números.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (emple_telefono.length < 10 || emple_telefono.length > 20) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El campo Teléfono debe tener entre 7 y 10 dígitos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (emple_correo === "") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Rellene El Campo Correo, Por favor.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (emple_correo.length < 11 || !/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(emple_correo)) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Por favor, ingrese un correo válido (ejemplo@dominio.com).</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (emple_estado === "select") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Seleccione un estado válido.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (usuarios_id === "selectusu") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Seleccione un usuario válido.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        }
        emple_ci = formatNumber(emple_ci);
        emple_telefono = formatPhoneNumber(emple_telefono);
        formdata = $("#form").serialize();
        $.ajax({
            data: formdata,
            url: 'JSP/Empleado.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                $("#mensaje").fadeIn();
                rellenardatos();
                cargarUsuarios();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 2000);
                resetForm();
                $("#buscador").val("");
            },
            error: function (error) {
                console.log("Error AJAX: ", error);
            }
        });
    });

    $("#usuarios_id").on('keydown', function (event) {
        if (event.key === "Enter") {
            event.preventDefault();
            $("#boton").click();
        }
    });

    $("#btn-cancelar").on('click', function () {
        resetForm();
        $("#buscador").val("");
        $("#usuarios_id").selectpicker('refresh');
        rellenardatos();
    });

    $("#btn-eliminar").on('click', function () {
        listar_delete = $("#listar_delete").val();
        id_delete = $("#id_delete").val();
        $.ajax({
            data: {listar: listar_delete, id_delete: id_delete},
            url: 'JSP/Empleado.jsp',
            success: function (response) {
                $("#mensaje").html(response);
                $("#mensaje").fadeIn();
                rellenardatos();
                cargarUsuarios();
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
            url: 'JSP/Empleado.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
            }
        });
    });

    $("#emple_telefono").on('input', function () {
        this.value = formatPhoneNumber(this.value.replace(/\D/g, ''));
    });
    $("#emple_ci").on('input', function () {
        this.value = formatNumber(this.value.replace(/\D/g, ''));
    });
    function resetForm() {
        $("#form")[0].reset();
        $("#listar").val("cargar");
        $("#emple_nombre").focus();
    }

    function rellenardatos() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'JSP/Empleado.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
                $("#emple_nombre").focus();
                $("#buscador").val("");
            }
        });
    }

    function cargarUsuarios() {
        $.ajax({
            data: {listar: 'cargarUsuarios'},
            url: 'JSP/Empleado.jsp',
            type: 'post',
            success: function (response) {
                $("#usuarios_id").html(response);
                $("#usuarios_id").selectpicker('refresh');
            }
        });
    }
    $.fn.selectpicker.Constructor.DEFAULTS.liveSearchStyle = 'startsWith';
    $.fn.selectpicker.Constructor.DEFAULTS.liveSearchFilter = function (searchValue, option) {
        return option.toLowerCase().startsWith(searchValue.toLowerCase());
    };

    function formatNumber(number) {
        return number.replace(/\D/g, "")
                .replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    }

    function formatPhoneNumber(phoneNumber) {
        if (phoneNumber.length > 7) {
            return phoneNumber.replace(/(\d{4})(\d{3})(\d{0,3})/, "$1-$2-$3").replace(/-$/, '');
        } else if (phoneNumber.length > 4) {
            return phoneNumber.replace(/(\d{4})(\d{0,3})/, "$1-$2");
        } else {
            return phoneNumber;
        }
    }



    function rellenarjs(idempleados, emple_nombre, emple_apellido, emple_ci, emple_direccion, emple_estado, emple_telefono, emple_correo, usuarios_id) {
        $("#idempleados").val(idempleados);
        $("#emple_nombre").val(emple_nombre);
        $("#emple_apellido").val(emple_apellido);
        $("#emple_ci").val(emple_ci);
        $("#emple_direccion").val(emple_direccion);
        $("#emple_estado").val(emple_estado);
        $("#emple_telefono").val(emple_telefono);
        $("#emple_correo").val(emple_correo);
        $("#usuarios_id").val(usuarios_id).selectpicker('refresh');
        $("#listar").val("modificar");
    }
</script>

<%@include file="footer.jsp"%>


