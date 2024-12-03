<%-- 
    Document   : FormListadoPedidos
    Created on : 8 jul. 2024, 09:11:56
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
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center" style="background-color: #ff007b; color: white;">
                    <h5 class="mb-0">Lista De Pagos</h5>
                    
                </div>
                <div class="search-bar" style="background-color: #ff007b; color: white; padding: 10px;">
                    <input type="text" class="form-control" placeholder="Buscar Pagos" style="color: #000000; background-color: white;" id="buscador" name="buscador">
                    
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead class="text-center">
                            <tr>
                                <th scope="col">ID</th>
                                <th scope="col">Fecha</th>
                                <th scope="col">Proveedor</th>
                                <th scope="col">Método De Pago</th>
                                <th scope="col">Estado Pago</th>
                                <th scope="col">Empleado</th>
                                <th scope="col">Total a Pagar</th>
                                <th scope="col">A cuántos días</th>
                                <th scope="col">Acción</th>
                            </tr>
                        </thead>
                        <tbody id="resultadopagos">
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
                <h1 class="modal-title fs-5" id="staticBackdropLabel" style="color: #ffffff;"><b>Realizar Pago</b></h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="color: #ffffff; opacity: 0.5;"></button>
            </div>
            <div class="modal-body" style="padding: 2rem; font-size: 1.1rem;">
                <input type="hidden" name="pkcheck" id="pkcheck">
                <p><b>¿Está seguro que desea realizar el pago?</b></p>
            </div>
            <div class="modal-footer" style="background-color: #f8f9fa; border-top: 1px solid #e9ecef; display: flex; justify-content: center;">
                <button type="button" class="btn btn-danger" id="btn-pagar" data-bs-dismiss="modal" style="background-color: #ff007b; border-color: #ff007b; color: #000000; min-width: 100px;">Sí</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="color: #000000; border-color: #6c757d; min-width: 100px;">No</button>
            </div>
        </div>
    </div>
</div>


<script>
$(document).ready(function () {
    mostrarpagos();
});

function setPagoId(id) {
    $("#pkcheck").val(id);
}

function mostrarpagos() {
    $.ajax({
        data: {listar: 'mostrarpagos'},
        url: 'JSP/Pagos.jsp',
        type: 'POST',
        success: function (response) {
            $("#resultadopagos").html(response);
            $('#resultadopagos tr').each(function () {
            });
        },
        error: function (xhr, status, error) {
            console.error("Error al mostrar pagos: " + error);
        }
    });
}

$("#btn-pagar").click(function () {
    pkcheck = $("#pkcheck").val();
    if (!pkcheck) {
        $("#resultadopagos").append("<div class='alert alert-warning'>Pago no encontrado o parámetro inválido.</div>");
        return;
    }

    $.ajax({
        data: {
            listar: 'pagar',
            pkcheck: pkcheck
        },
        url: 'JSP/Pagos.jsp',
        type: 'POST',
        success: function (response) {
            $("#resultadopagos").append(response);
            mostrarpagos(); 
            $("#staticBackdrop").modal('hide');
        },
        error: function (xhr, status, error) {
            $("#resultadopagos").append("<div class='alert alert-danger'>Error al realizar el pago: " + error + "</div>");
        }
    });
});

$('#buscador').on('keyup', function () {
    buscador = $(this).val();
    $.ajax({
        data: {listar: 'buscador', buscador: buscador},
        url: 'JSP/Pagos.jsp',
        type: 'POST',
        success: function (response) {
            $("#resultadopagos").html(response);
            $('#resultadopagos tr').each(function () {
            });
        },
        error: function (xhr, status, error) {
            console.error("Error al buscar pagos: " + error);
        }
    });
});
</script>
<%@include file="footer.jsp" %>
