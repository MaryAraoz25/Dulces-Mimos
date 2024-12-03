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
                    <h5 class="mb-0">Lista De Cobros</h5>
                </div>
                <div class="search-bar" style="background-color: #ff007b; color: white; padding: 10px;">
                    <input type="text" class="form-control" placeholder="Buscar Cobros" style="color: #000000; background-color: white;" id="buscador" name="buscador">
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover">
                            <thead class="text-center">
                                <tr>
                                    <th scope="col">ID</th>
                                    <th scope="col">Fecha</th>
                                    <th scope="col">Cliente</th>
                                    <th scope="col">Método De Pago</th>
                                    <th scope="col">Estado Cobro</th>
                                    <th scope="col">Empleado</th>
                                    <th scope="col">Total a Cobrar</th>
                                    <th scope="col">A cuántos días</th>
                                    <th scope="col">Acción</th>
                                </tr>
                            </thead>
                            <tbody id="resultadocobros">
                                <!-- Los cobros se cargarán dinámicamente aquí -->
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
                <h1 class="modal-title fs-5" id="staticBackdropLabel" style="color: #ffffff;"><b>Realizar Cobro</b></h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" style="color: #ffffff; opacity: 0.5;"></button>
            </div>
            <div class="modal-body" style="padding: 2rem; font-size: 1.1rem;">
                <input type="hidden" name="pkcheck" id="pkcheck">
                <p><b>¿Está seguro que desea realizar el cobro?</b></p>
            </div>
            <div class="modal-footer" style="background-color: #f8f9fa; border-top: 1px solid #e9ecef; display: flex; justify-content: center;">
                <button type="button" class="btn btn-danger" id="btn-cobrar" data-bs-dismiss="modal" style="background-color: #ff007b; border-color: #ff007b; color: #000000; min-width: 100px;">Sí</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" style="color: #000000; border-color: #6c757d; min-width: 100px;">No</button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
    mostrarCobros();
invalidChars = /[><"'()]/;
    function preventInvalidInput(event) {
        input = $(this).val();
        if (invalidChars.test(input)) {
            $(this).val(input.replace(invalidChars, ''));
        }
    }
    $("#buscador").on("input", preventInvalidInput);
});
function setCobroId(id) {
        $("#pkcheck").val(id);
    }
    function mostrarCobros() {
        $.ajax({
            data: {listar: 'mostrarcobros'},
            url: 'JSP/Cobros.jsp',
            type: 'POST',
            success: function (response) {
                $("#resultadocobros").html(response);
                $('#resultadocobros tr').each(function () {
                });
            },
            error: function (xhr, status, error) {
                console.error("Error al mostrar cobros: " + error);
            }
        });
    }

    $('#buscador').on('keyup', function () {
        buscador = $(this).val();
        $.ajax({
            data: {listar: 'buscador', buscador: buscador},
            url: 'JSP/Cobros.jsp',
            type: 'POST',
            success: function (response) {
                $("#resultadocobros").html(response);
               
                $('#resultadocobros tr').each(function () {
                    
                });
            },
            error: function (xhr, status, error) {
                console.error("Error al buscar cobros: " + error);
            }
        });
    });

    $("#btn-cobrar").click(function () {
        
        $("#resultadocobros").find(".alert").remove();

        pkcheck = $("#pkcheck").val();

        if (!pkcheck) {
            $("#resultadocobros").append("<div class='alert alert-warning'>Cobro no encontrado o parámetro inválido.</div>");
            return;
        }

        $.ajax({
            data: {
                listar: 'cobrar',
                pkcheck: pkcheck
            },
            url: 'JSP/Cobros.jsp',
            type: 'POST',
            success: function (response) {
                $("#resultadocobros").append(response);
                mostrarCobros(); 
                $("#staticBackdrop").modal('hide');
            },
            error: function (xhr, status, error) {
                $("#resultadocobros").append("<div class='alert alert-danger'>Error al realizar el cobro: " + error + "</div>");
            }
        });
    });

</script>


<%@include file="footer.jsp" %>
