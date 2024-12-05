<%-- 
    Document   : FormListadoVentas
    Created on : 8 jul. 2024, 09:12:08
    Author     : Maria
--%>

<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="header.jsp"%>
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
<div class="container-fluid">
    <div class="row">
        <div class="col-11 mx-auto d-block mt-3">
            <button class="btn btn-primary btn-lg float-end mt-3" type="button" onclick="location.href = 'FormVentas.jsp'">
                Nueva Venta
            </button>
        </div>
        <div class="col-11 mx-auto d-block mt-3">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center" style="background-color: #ff007b; color: white;">
                    <h5 class="mb-0">Lista De Ventas</h5>
                </div>
                <div class="search-bar" style="background-color: #ff007b; color: white; padding: 10px;">
                    <input type="text" class="form-control" placeholder="Buscar Ventas" style="color: #000000; background-color: white;" id="buscador" name="buscador">
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead class="text-center">
                            <tr>
                                <th scope="col">ID</th>
                                <th scope="col">Fecha</th>
                                <th scope="col">Estado</th>
                                <th scope="col">Tipo De Pago</th>
                                <th scope="col">Cliente</th>
                                <th scope="col">Total Venta</th>
                                <th scope="col">Acción</th>
                            </tr>
                        </thead>
                        <tbody id="resultadoventas">
                            <!-- Las compras se cargarán dinámicamente aquí -->
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
                <h1 class="modal-title fs-5" id="staticBackdropLabel" style="color: #ffffff;"><b>Anular Venta</b></h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="color: #ffffff; opacity: 0.5;"></button>
            </div>
            <div class="modal-body" style="padding: 2rem; font-size: 1.1rem;">
                <input type="hidden" name="pkdelete" id="pkdelete">
                <p><b>¿Está seguro que desea anular la venta?</b></p>
            </div>
            <div class="modal-footer" style="background-color: #f8f9fa; border-top: 1px solid #e9ecef; display: flex; justify-content: center;">
                <button type="button" class="btn btn-danger" id="btn-anularventas" data-bs-dismiss="modal" style="background-color: #ff007b; border-color: #ff007b; color: #000000; min-width: 100px;">Sí</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="color: #000000; border-color: #6c757d; min-width: 100px;">No</button>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        mostrardetalles();
        invalidChars = /[><"'()]/;
        function preventInvalidInput(event) {
            input = $(this).val();
            if (invalidChars.test(input)) {
                $(this).val(input.replace(invalidChars, ''));
            }
        }
        $("#buscador").on("input", preventInvalidInput);
    });
    function mostrardetalles() {
        $.ajax({
            data: {listar: 'mostrarventas'},
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                $("#resultadoventas").html(response);
                //mostrartotales();
            }
        });
    }

    $("#btn-anularventas").click(function () {
        pkdelete = $("#pkdelete").val();
        $.ajax({
            data: {listar: 'anularventas', pkdelete: pkdelete},
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                $("#resultadoventas").html(response);
                mostrardetalles();
            }
        });
    });

    $('#buscador').on('keyup', function () {
        buscador = $(this).val().trim();

        $.ajax({
            data: {listar: 'buscador', buscador: buscador},
            url: 'JSP/Ventas.jsp',
            type: 'post',
            success: function (response) {
                $("#resultadoventas").html(response);
            },
            error: function (xhr, status, error) {
                console.error("Error en la solicitud AJAX: " + error);
            }
        });
    });
</script>

<%@include file="footer.jsp" %>