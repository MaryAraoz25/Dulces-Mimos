<%-- 
    Document   : FormListadoProduccion
    Created on : 8 jul. 2024, 09:11:34
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
            <button class="btn btn-primary btn-lg float-end mt-3" type="button" onclick="location.href = 'FormProduccion.jsp'">
                Nueva Producción
            </button>
        </div>
        <div class="col-11 mx-auto d-block mt-3">
            <div class="card">
                <input type="hidden" name="listar" id="listar" value="cargar">
                <div class="card-header d-flex justify-content-between align-items-center" style="background-color: #ff007b; color: white;">
                    <h5 class="mb-0">Lista De Producción</h5>

                </div>
                <div class="search-bar" style="background-color: #ff007b; color: white; padding: 10px;">
                    <input type="text" class="form-control" placeholder="Buscar Produccción" style="color: #000000; background-color: white;" id="buscador" name="buscador">
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                    <table class="table table-bordered table-hover" id="resultado">
                        <thead class="text-center">
                            <tr>
                                <th scope="col">ID</th>
                                <th scope="col">Fecha Elaboración</th>
                                <th scope="col">Fecha De Vencimiento</th>
                                <th scope="col">Producto</th>
                                <th scope="col">Empleado</th>
                                <th scope="col">Cantidad Producida</th>
                                <th scope="col">Estado</th>
                                <th scope="col">Acción</th>
                            </tr>
                        </thead>
                        <tbody id="resultadoproduccion">
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
                <h1 class="modal-title fs-5" id="staticBackdropLabel" style="color: #ffffff;"><b>Anular Producción</b></h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="color: #ffffff; opacity: 0.5;"></button>
            </div>
            <div class="modal-body" style="padding: 2rem; font-size: 1.1rem;">
                <input type="hidden" name="pkdelete" id="pkdelete">
                <p><b>¿Está seguro que desea anular la producción?</b></p>
            </div>
            <div class="modal-footer" style="background-color: #f8f9fa; border-top: 1px solid #e9ecef; display: flex; justify-content: center;">
                <button type="button" class="btn btn-danger" id="btn-anular" data-bs-dismiss="modal" style="background-color: #ff007b; border-color: #ff007b; color: #000000; min-width: 100px;">Sí</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="color: #000000; border-color: #6c757d; min-width: 100px;">No</button>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {
        mostrardetalles();
        $("#buscador").focus();
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
            data: {listar: 'mostrarproduccion'},
            url: 'JSP/Produccion.jsp',
            type: 'post',
            success: function (response) {
                $("#resultadoproduccion").html(response);
                //mostrartotales();
            }
        });
    }
    $("#btn-anular").click(function () {
        pkdelete = $("#pkdelete").val();
        $.ajax({
            data: {listar: 'anular', pkdelete: pkdelete},
            url: 'JSP/Produccion.jsp',
            type: 'post',
            success: function (response) {
                $("#resultadoproduccion").html(response);
                mostrardetalles();
            }
        });
    });

    $('#buscador').on('keyup', function () {
        buscador = $(this).val();
        $.ajax({
            data: {listar: 'buscador', buscador: buscador},
            url: 'JSP/Produccion.jsp',
            type: 'post',
            success: function (response) {
                $("#resultadoproduccion").html(response);

            }
        });
    });


</script>

<%@include file="footer.jsp" %>
