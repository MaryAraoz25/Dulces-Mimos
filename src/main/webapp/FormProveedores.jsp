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
                        <h5 class="mb-0">Gestión De Proveedores</h5>
                    </div>
                    <div class="card-body">
                        <input type="hidden" name="listar" id="listar" value="cargar">
                        <input type="hidden" name="idproveedores" id="idproveedores">
                        <div class="mb-3">
                            <label for="prov_nombre" class="form-label"><b>Nombre del Proveedor</b></label>
                            <input type="text" class="form-control" id="prov_nombre" name="prov_nombre" required>
                        </div>
                        <div class="mb-3">
                            <label for="prov_dirección" class="form-label"><b>Dirección</b></label>
                            <input type="text" class="form-control" id="prov_direccion" name="prov_direccion" required>
                        </div>
                        <div class="mb-3">
                            <label for="prov_correo" class="form-label"><b>Correo</b></label>
                            <input type="email" class="form-control" id="prov_correo" name="prov_correo" required>
                        </div>
                        <div class="mb-3">
                            <label for="prov_telefono" class="form-label"><b>Teléfono</b></label>
                            <input type="tel" class="form-control" id="prov_telefono" name="prov_telefono" required>
                        </div>
                        <div class="mb-3">
                            <label for="prov_ruc" class="form-label"><b>RUC</b></label>
                            <input type="text" class="form-control" id="prov_ruc" name="prov_ruc" required>
                        </div>
                        <div class="mb-3">
                            <label for="prov_ruc" class="form-label"><b>Número De Timbrado</b></label>
                            <input type="text" class="form-control" id="prov_timbrado" name="prov_timbrado" required>
                        </div><!-- comment -->
                        <div class="mb-3">
                            <label for="prov_ruc" class="form-label"><b>Fecha Inicio Vigencia</b></label>
                            <input type="date" class="form-control" id="prov_inicio" name="prov_inicio" required>
                        </div>
                        <div class="mb-3">
                            <label for="prov_ruc" class="form-label"><b>Fecha Fin Vigencia</b></label>
                            <input type="date" class="form-control" id="prov_fin" name="prov_fin" readonly>
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
                        <h5 class="mb-0">Lista De Proveedores</h5>
                        <a href="${pageContext.request.contextPath}/ReportesJSP/ListadoProveedores.jsp" target="_blank" style="color: black;" title="Generar Reporte"><i class="fa-solid fa-print" style="color: black; font-size: 1.5rem;"></i></a>
                    </div>
                    <div class="card-body">
                        <div class="input-group mb-3">
                            <input type="text" class="form-control" placeholder="Buscar" id="buscador" name="buscador">
                        </div>
                        <div class="table-responsive"> <!-- Agregar esta clase -->
                            <table class="table table-bordered table-hover" id="resultado">
                                <thead class="text-center">
                                    <tr>
                                        <th>Id</th>
                                        <th>Nombre</th>
                                        <th>Dirección</th>
                                        <th>Correo</th>
                                        <th>Teléfono</th>
                                        <th>RUC</th>
                                        <th>Timbrado</th>
                                        <th>Fecha Inicio Vigencia</th>
                                        <th>Fecha Fin Vigencia</th>
                                        <th>Acción</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- Aquí se cargarán los datos dinámicamente -->
                                </tbody>
                            </table>
                        </div> <!-- Cierre de la clase table-responsive -->
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
    $("#prov_inicio").on("change", function () {
        startDate = new Date($(this).val());
        if (startDate) {
            endDate = new Date(startDate);
            endDate.setFullYear(endDate.getFullYear() + 1);
            formattedDate = endDate.toISOString().split('T')[0];
            $("#prov_fin").val(formattedDate);
        }
    });
    $("#prov_timbrado").on('input', function () {
        this.value = this.value.replace(/[^0-9]/g, '').slice(0, 8);
    });
invalidChars = /[><"'()]/;
    function preventInvalidInput(event) {
        input = $(this).val();
        if (invalidChars.test(input)) {
            $(this).val(input.replace(invalidChars, ''));
        }
    }
    $("#prov_nombre, #prov_direccion, #prov_correo, #prov_telefono, #prov_ruc, #prov_timbrado, #buscador").on("input", preventInvalidInput);
});
    $("#prov_inicio").on("keypress", function (event) {
        if (event.which === 13) {
            event.preventDefault();
            $("#boton").click();
        }
    });

    $("#boton").on('click', function () {
        //alert("Hola");
        prov_nombre = $("#prov_nombre").val().trim();
        prov_direccion = $("#prov_direccion").val().trim();
        prov_correo = $("#prov_correo").val().trim();
        prov_telefono = $("#prov_telefono").val().trim();
        prov_ruc = $("#prov_ruc").val().trim();
        prov_timbrado = $("#prov_timbrado").val().trim();
        prov_inicio = $("#prov_inicio").val().trim();
        prov_fin = $("#prov_fin").val().trim();
        if (prov_nombre.trim().length < 3) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El nombre del Proveedor debe contener al menos 4 letras.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (prov_timbrado === "" || prov_inicio === "" || prov_fin === "") {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>Rellena Los Campos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (prov_telefono.length < 10 || prov_telefono.length > 20) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El campo Teléfono debe tener entre 7 y 10 dígitos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (prov_correo.length < 11 || !/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(prov_correo)) {
    $("#mensaje").html("<div class='alert alert-danger' role='alert'>Por favor, ingrese un correo válido (ejemplo@dominio.com).</div>");
    $("#mensaje").fadeIn();
    setTimeout(function () {
        $("#mensaje").fadeOut();
    }, 3000);
    return;
} else if (prov_timbrado.length !== 8) {
    $("#mensaje").html("<div class='alert alert-danger' role='alert'>El timbrado debe tener exactamente 8 dígitos.</div>");
    $("#mensaje").fadeIn();
    setTimeout(function () {
        $("#mensaje").fadeOut();
    }, 3000);
    return;
}else if (prov_direccion.trim().length < 3) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>La dirección debe contener al menos 3 caracteres (letras, números o espacios).</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        } else if (prov_ruc.length < 9 || prov_ruc.length > 10) {
            $("#mensaje").html("<div class='alert alert-danger' role='alert'>El ruc debe tener entre 7 y 10 dígitos.</div>");
            $("#mensaje").fadeIn();
            setTimeout(function () {
                $("#mensaje").fadeOut();
            }, 3000);
            return;
        }
        prov_ruc = formatRUC(prov_ruc);
        prov_telefono = formatPhoneNumber(prov_telefono);
        formdata = $("#form").serialize();
        $.ajax({
            data: formdata,
            url: 'JSP/Proveedores.jsp',
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
            url: 'JSP/Proveedores.jsp',
            type: 'post',
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
    $('#buscador').on('keyup', function () {
        buscador = $(this).val();
        $.ajax({
            data: {listar: 'buscador', buscador: buscador},
            url: 'JSP/Proveedores.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
            }
        });
    });

    $("#prov_telefono").on('input', function () {
        this.value = formatPhoneNumber(this.value.replace(/\D/g, ''));
    });


    function rellenardatos() {
        $.ajax({
            data: {listar: 'listar'},
            url: 'JSP/Proveedores.jsp',
            type: 'post',
            success: function (response) {
                $("#resultado tbody").html(response);
                $("#prov_nombre").focus();
            }
        });
    }

    function rellenarjs(idproveedores, prov_nombre, prov_direccion, prov_correo, prov_telefono, prov_ruc, prov_timbrado, prov_inicio, prov_fin) {
        $("#idproveedores").val(idproveedores);
        $("#prov_nombre").val(prov_nombre);
        $("#prov_direccion").val(prov_direccion);
        $("#prov_correo").val(prov_correo);
        $("#prov_telefono").val(prov_telefono);
        $("#prov_ruc").val(prov_ruc);
        $("#prov_timbrado").val(prov_timbrado);
        $("#prov_inicio").val(prov_inicio);
        $("#prov_fin").val(prov_fin);
        $("#listar").val("modificar");
    }
    $("#prov_ruc").on('input', function () {
        this.value = formatRUC(this.value.replace(/\D/g, ''));
    });
    function resetForm() {
        $("#form")[0].reset();
        $("#listar").val("cargar");
        $("#prov_nombre").focus();
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
</script>

<%@include file="footer.jsp"%>

