<%-- 
    Document   : FormUsuarios
    Created on : 30 may. 2024, 20:29:15
    Author     : Maria
--%>

<%@include file="header.jsp"%>
<style>
    .card:hover {
        transform: none;
        transition: none;
    }

    /* Opcionalmente, desactiva cualquier transici�n en general */
    .card {
        transition: none;
    }
    .weak { color: red; }
    .medium { color: orange; }
    .strong { color: green; }
</style>
<br>
<div class="container-fluid">
    <div class="row">
        <!-- Formulario -->
        <div class="col-xl-4">
            <div class="card">
                <div class="card-header" style="background-color: #ff007b; color: white;">
                    <h5 class="mb-0">Gesti�n de Usuarios</h5>
                </div>
                <div class="card-body">
                    <form id="form">
                        <input type="hidden" name="listar" id="listar" value="cargar">
                        <input type="hidden" name="idusuario" id="idusuario">
                        <div class="mb-3">
                            <label for="usu_nombre" class="form-label"><b>Nombre del Usuario</b></label>
                            <input type="text" class="form-control" id="usu_nombre" name="usu_nombre" required>
                        </div>
                        <div class="mb-3">
                            <label for="usu_contrase�a" class="form-label"><b>Contrase�a (De 8 a 10 Car�cteres)</b></label>
                            <br>
                            <span id="indicio" style="display: none; color: gray;">La contrase�a debe tener al menos una letra may�scula, una letra min�scula, un n�mero y un car�cter especial.</span>
                            <input type="password" class="form-control" id="usu_contrase�a" name="usu_contrase�a" required>
                            <span id="fuerzacontrase�a" style="display: none;"></span>
                        </div>
                        <div class="mb-3">
                            <label for="usu_estado" class="form-label"><b>Estado</b></label>
                            <select class="form-select" id="usu_estado" name="usu_estado" required>
                                <option value="select">Seleccione un Estado</option>
                                <option value="Activo">Activo</option>
                                <option value="Inactivo">Inactivo</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="rol" class="form-label"><b>Rol</b></label>
                            <br>
                            <select class="selectpicker" id="rol_idrol" name="rol_idrol" required data-live-search="true" data-dropup-auto="false">
                                <!-- Opciones din�micas se cargar�n aqu� -->
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
        <!-- Tabla de Usuarios -->
        <div class="col-xl-8">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center" style="background-color: #ff007b; color: white;">
                    <h5 class="mb-0">Lista De Usuarios</h5>
                    <a href="${pageContext.request.contextPath}/ReportesJSP/ListadoUsuarios.jsp" target="_blank" style="color: black;" title="Generar Reporte"><i class="fa-solid fa-print" style="color: black; font-size: 1.5rem;"></i></a>
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
                                    <th>Contrase�a</th>
                                    <th class="text-center">Estado</th>
                                    <th>Rol</th>
                                    <th class="text-center">Acci�n</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Aqu� se cargar�n los datos din�micamente -->
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
                <p><b>�Est� seguro que desea eliminar el registro?</b></p>
            </div>
            <div class="modal-footer" style="background-color: #f8f9fa; border-top: 1px solid #e9ecef; display: flex; justify-content: center;">
                <button type="button" class="btn btn-danger" id="btn-eliminar" data-bs-dismiss="modal" style="background-color: #ff007b; border-color: #ff007b; color: #000000; min-width: 100px;">S�</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="color: #000000; border-color: #6c757d; min-width: 100px;">No</button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        rellenardatos();
        cargarRoles();
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
        $("#usu_nombre, #usu_contrase�a, #buscador").on("input", preventInvalidInput);
    });
    $("#usu_contrase�a").on('focus', function () {
        $("#indicio").show();
    });
    $("#usu_contrase�a").on('blur', function () {
        $("#indicio").hide();
    });
    $("#usu_contrase�a").on('input', function () {
        this.value = this.value.slice(0, 10);
        password = $(this).val();
        fuerzacontrase�a = $("#fuerzacontrase�a");


        if (password.length >= 8 && /[a-z]/.test(password) && /[A-Z]/.test(password) && /\d/.test(password) && /[@$!%*?&]/.test(password)) {
            fuerzacontrase�a.text("Fuerte").removeClass().addClass("strong");
        } else if (password.length >= 6 && ((/[a-z]/.test(password) && /[A-Z]/.test(password)) || (/\d/.test(password) && /[@$!%*?&]/.test(password)))) {
            fuerzacontrase�a.text("Media").removeClass().addClass("medium");
        } else {
            fuerzacontrase�a.text("D�bil").removeClass().addClass("weak");
        }

        if (password.length > 0) {
            fuerzacontrase�a.show();
        } else {
            fuerzacontrase�a.hide();
        }
    });
    $("#boton").on('click', function () {
        usu_nombre = $("#usu_nombre").val();
        usu_contrase�a = $("#usu_contrase�a").val();
        usu_estado = $("#usu_estado").val();
        rol_idrol = $("#rol_idrol").val();
        if (usu_nombre.trim() === "" || usu_contrase�a.trim() === "" || usu_estado === "select" || rol_idrol === "") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Rellene todos los campos, por favor.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else {
            if (usu_nombre.trim().length < 3) {
                $("#mensaje").html("<div class='alert alert-danger' role='alert'>El nombre del usuario debe contener al menos 3 caracteres.</div>");
                $("#mensaje").fadeIn();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 3000);
                $("#usu_nombre").focus();
                return;
            }
            if (usu_nombre.trim() === "") {
                $("#mensaje").html("<div class='alert alert-danger' role='alert'>El nombre del usuario no puede estar vac�o.</div>");
                $("#mensaje").fadeIn();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 3000);
                return;
            } else if (usu_contrase�a.length < 8 || usu_contrase�a.length > 10) {
                $("#mensaje").html("<div class='alert alert-danger' role='alert'>La contrase�a debe tener entre 8 y 10 caracteres.</div>");
                $("#mensaje").fadeIn();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 3000);
                return;
            } else if (!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,10}$/.test(usu_contrase�a)) {
                $("#mensaje").html("<div class='alert alert-danger' role='alert'>La contrase�a debe tener al menos una letra may�scula, una letra min�scula, un n�mero y un car�cter especial.</div>");
                $("#mensaje").fadeIn();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 3000);
                $("#usu_contrase�a").focus();
                return;
            } else if (usu_estado === "select") {
                $("#mensaje").html("<div class='alert alert-danger' role='alert'>Seleccione un Estado V�lido.</div>");
                $("#mensaje").fadeIn();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 3000);
                return;
            } else if (!/^[a-zA-Z0-9]+$/.test(usu_nombre.trim())) {
                $("#mensaje").html("<div class='alert alert-danger' role='alert'>El nombre de usuario solo puede contener letras y n�meros.</div>");
                $("#mensaje").fadeIn();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 3000);
                $("#usu_nombre").focus();
                return;
            } else if (/\s/.test(usu_contrase�a)) {
                $("#mensaje").html("<div class='alert alert-danger' role='alert'>La contrase�a no puede contener espacios en blanco.</div>");
                $("#mensaje").fadeIn();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 3000);
                $("#usu_contrase�a").focus();
                return;
            } else if (rol_idrol === "selectrol") {
                $("#mensaje").html("<div class='alert alert-danger' role='alert'>Seleccione un Rol V�lido.</div>");
                $("#mensaje").fadeIn();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 3000);
                return;
            }
        }
        formdata = $("#form").serialize();
        $.ajax({
            data: formdata,
            url: 'JSP/Usuario.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                $("#mensaje").fadeIn();
                rellenardatos();
                cargarRoles();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 2000);
                resetForm();
                $("#buscador").val('');
            }
        });
    });

    $("#btn-cancelar").on('click', function () {
        resetForm();
        $("#buscador").val('');
        $("#rol_idrol").selectpicker('refresh');
        rellenardatos();
    });


    $("#btn-eliminar").on('click', function () {
        listar_delete = $("#listar_delete").val();
        id_delete = $("#id_delete").val();
        $.ajax({
            data: {listar: listar_delete, id_delete: id_delete},
            url: 'JSP/Usuario.jsp',
            type: 'post',
            success: function (response) {
                $("#mensaje").html(response);
                $("#mensaje").fadeIn();
                rellenardatos();
                cargarRoles();
                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 2000);
                $("#buscador").val('');
            }
        });
    });

    $("#buscador").on('keyup', function () {
        buscador = $(this).val();
        $.ajax({
            data: {listar: 'buscador', buscador: buscador},
            url: 'JSP/Usuario.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
            }
        });
    });

    function resetForm() {
        $("#form")[0].reset();
        $("#listar").val("cargar");
        $("#usu_nombre").focus();
    }

    function rellenardatos() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'JSP/Usuario.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
                $("#usu_nombre").focus();
                $("#buscador").val('');
            }
        });
    }

    function cargarRoles() {
        $.ajax({
            data: {listar: 'cargarRoles'},
            url: 'JSP/Usuario.jsp',
            type: 'post',
            success: function (response) {
                $("#rol_idrol").html(response);
                $("#rol_idrol").selectpicker('refresh');
            }
        });
    }
    $.fn.selectpicker.Constructor.DEFAULTS.liveSearchStyle = 'startsWith';
    $.fn.selectpicker.Constructor.DEFAULTS.liveSearchFilter = function (searchValue, option) {
        return option.toLowerCase().startsWith(searchValue.toLowerCase());
    };



    function rellenarjs(idusuario, usu_nombre, usu_contrase�a, usu_estado, rol_idrol) {
        $("#idusuario").val(idusuario);
        $("#usu_nombre").val(usu_nombre);
        //$("#usu_contrase�a").val(usu_contrase�a);
        $("#usu_estado").val(usu_estado);
        $("#rol_idrol").val(rol_idrol).selectpicker('refresh');
        $("#listar").val("modificar");
    }
</script>

<%@include file="footer.jsp"%>

