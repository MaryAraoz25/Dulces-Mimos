<%-- 
    Document   : FormClientes
    Created on : 30 may. 2024, 20:30:39
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
        <div class="col-xl-4" style="padding-right: 8px;">
            <div class="card">
                <div class="card-header" style="background-color: #ff007b; color: white;">
                    <h5 class="mb-0">Gestión de Clientes</h5>
                </div>
                <div class="card-body">
                    <form id="form">
                        <input type="hidden" name="listar" id="listar" value="cargar">
                        <input type="hidden" name="idclientes" id="idclientes">
                        <div class="mb-3">
                            <label class="form-label"><b>Nombre</b></label>
                            <input type="text" class="form-control" id="cli_nombre" name="cli_nombre" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><b>Apellido</b></label>
                            <input type="text" class="form-control" id="cli_apellido" name="cli_apellido" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><b>Dirección</b></label>
                            <input type="text" class="form-control" id="cli_direccion" name="cli_direccion" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><b>Cédula</b></label>
                            <input type="text" class="form-control" id="cli_ci" name="cli_ci" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><b>Teléfono</b></label>
                            <input type="text" class="form-control" id="cli_telefono" name="cli_telefono" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><b>RUC</b></label>
                            <input type="text" class="form-control" id="cli_ruc" name="cli_ruc" required>
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
        <!-- Tabla de Clientes -->
        <div class="col-xl-8"  style="padding-left: 4px;">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center" style="background-color: #ff007b; color: white;">
                    <h5 class="mb-0">Lista De Clientes</h5>
                    <a href="${pageContext.request.contextPath}/ReportesJSP/ListadoClientes.jsp" target="_blank" style="color: black;" title="Generar Reporte"><i class="fa-solid fa-print" style="color: black; font-size: 1.5rem;"></i></a>
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
                                    <th>Apellido</th>
                                    <th>Dirección</th>
                                    <th>Cédula</th>               
                                    <th>Teléfono</th>
                                    <th>RUC</th>
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
        $("#cli_nombre, #buscador, #cli_apellido, #cli_direccion, #cli_ci, #cli_telefono, #cli_ruc").on("input", preventInvalidInput);
    });
    $("#boton").on('click', function () {
        cli_nombre = $("#cli_nombre").val();
        cli_apellido = $("#cli_apellido").val();
        cli_ci = $("#cli_ci").val().replace(/\D/g, '');
        cli_direccion = $("#cli_direccion").val();
        cli_telefono = $("#cli_telefono").val().replace(/\D/g, '');
        cli_ruc = $("#cli_ruc").val();

        validarNombreApellido = /^[A-Za-zÁÉÍÓÚáéíóú\s]+$/;
        validarTelefonoCedula = /^[0-9]+$/;
        validarRuc = /^80000000\d{1}-\d{1}$/;
        if (
                cli_nombre === "" ||
                cli_apellido === "" ||
                cli_ci === "" ||
                cli_direccion === "" ||
                cli_telefono === ""

                ) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Rellene Todos Los Campos, Por favor.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (!validarNombreApellido.test(cli_nombre)) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El campo Nombre solo debe contener letras y acentos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (/\s{2,}/.test(cli_nombre)) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El campo Nombre no debe contener múltiples espacios consecutivos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (!validarNombreApellido.test(cli_apellido)) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El campo Apellido solo debe contener letras y acentos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (/\s{2,}/.test(cli_apellido)) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El campo Apellido no debe contener múltiples espacios consecutivos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (/\s{2,}/.test(cli_direccion)) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El campo Dirección no debe contener múltiples espacios consecutivos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (cli_telefono.length < 10 || cli_telefono.length > 20) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El campo Teléfono debe tener entre 7 y 10 dígitos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (!/^[A-Za-z0-9\s]{3,}$/.test(cli_direccion)) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>La dirección debe contener al menos 3 caracteres (letras, números o espacios).</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (cli_ci.slice(0, 7) !== cli_ruc.slice(0, 7)) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Los primeros 7 dígitos de la cédula deben coincidir con los del RUC.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (cli_ci.length < 7 || cli_ci.length > 10) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>La cédula debe tener entre 7 y 10 dígitos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else {
            cli_ci = formatNumber(cli_ci);
            cli_ruc = formatRUC(cli_ruc);
            cli_telefono = formatPhoneNumber(cli_telefono);
            formdata = $("#form").serialize();
            $.ajax({
                data: formdata,
                url: 'JSP/Cliente.jsp',
                type: 'post',
                success: function (response) {
                    $("#mensaje").html(response);
                    $("#mensaje").fadeIn();
                    rellenardatos();
                    setTimeout(function () {
                        $("#mensaje").fadeOut();
                    }, 3000);
                    resetForm();
                    $("#buscador").val("");
                }
            });
        }
    });

    $("#cli_nombre").on('keydown', function (event) {
        if (event.key === "Enter") {
            event.preventDefault();
            $("#boton").click();
        }
    });

    $("#btn-cancelar").on('click', function () {
        resetForm();
        $("#buscador").val("");
        rellenardatos();
    });

    $("#btn-eliminar").on('click', function () {
        listar_delete = $("#listar_delete").val();
        id_delete = $("#id_delete").val();
        $.ajax({
            data: {listar: listar_delete, id_delete: id_delete},
            url: 'JSP/Cliente.jsp',
            success: function (response) {
                $("#mensaje").html(response);
                $("#mensaje").fadeIn();
                rellenardatos();

                setTimeout(function () {
                    $("#mensaje").fadeOut();
                }, 3000);
                $("#buscador").val("");
            }
        });
    });

    $("#buscador").on('keyup', function () {
        buscador = $(this).val();
        $.ajax({
            data: {listar: 'buscador', buscador: buscador},
            url: 'JSP/Cliente.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
            }
        });
    });
    $("#cli_telefono").on('input', function () {
        this.value = formatPhoneNumber(this.value.replace(/\D/g, ''));
    });
    $("#cli_ci").on('input', function () {
        this.value = formatNumber(this.value.replace(/\D/g, ''));
    });
    $("#cli_ruc").on('input', function () {
        this.value = formatRUC(this.value.replace(/\D/g, ''));
    });
    function resetForm() {
        $("#form")[0].reset();
        $("#listar").val("cargar");
        $("#cli_nombre").focus();
    }

    function rellenardatos() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'JSP/Cliente.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
                $("#cli_nombre").focus();
                $("#buscador").val("");
            }
        });
    }


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
    function formatRUC(ruc) {
        if (ruc.length > 7) {
            return ruc.slice(0, 7) + "-" + ruc.slice(7, 8);
        }
        return ruc;
    }
    $.fn.selectpicker.Constructor.DEFAULTS.liveSearchStyle = 'startsWith';
    $.fn.selectpicker.Constructor.DEFAULTS.liveSearchFilter = function (searchValue, option) {
        return option.toLowerCase().startsWith(searchValue.toLowerCase());
    };

    function rellenarjs(idclientes, cli_nombre, cli_apellido, cli_direccion, cli_ci, cli_telefono, cli_ruc) {
        $("#idclientes").val(idclientes);
        $("#cli_nombre").val(cli_nombre);
        $("#cli_apellido").val(cli_apellido);
        $("#cli_direccion").val(cli_direccion);
        $("#cli_ci").val(cli_ci);
        $("#cli_telefono").val(cli_telefono);
        $("#cli_ruc").val(cli_ruc);
        //$("#usuario_id").val(usuario_id).selectpicker('refresh');
        $("#listar").val("modificar");
    }
</script>

<%@include file="footer.jsp"%>


