<%-- 
    Document   : order-history
    Created on : Jun 27, 2022, 5:45:04 PM
    Author     : giama
--%>

<%@page import="store.shopping.OrderDetailDTO"%>
<%@page import="store.shopping.OrderDTO"%>
<%@page import="javafx.util.Pair"%>
<%@page import="store.shopping.CartProduct"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="ie=edge">
        <title>Order History Page</title>

        <!-- Google Font -->
        <link href="https://fonts.googleapis.com/css2?family=Cookie&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

        <jsp:include page="meta.jsp" flush="true"/>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp" flush="true"/>
        <%
            // get cart message
            String message = (String) request.getAttribute("MESSAGE");
            if (message == null) {
                message = "";
            }
        %>


        <!-- Breadcrumb Begin -->
        <div class="breadcrumb-option">
            <div class="container">
                <!--Message row-->
                <div class="row">
                    <div class="col-12" style="text-align: center; color: red">
                        <%= message%>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="breadcrumb__links">
                            <a href="./"><i class="fa fa-home"></i> Home</a>
                            <span>Order History</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Breadcrumb End -->
        <% List<Pair<OrderDTO, List<OrderDetailDTO>>> list = (List<Pair<OrderDTO, List<OrderDetailDTO>>>) request.getAttribute("ORDER_HISTORY");
        %>
        <!-- Shop Cart Section Begin -->
        <%
            if (list != null) {
                if (list.size() > 0) {
        %>
        <section class="shop-cart spad">
            
                        <% for (Pair<OrderDTO, List<OrderDetailDTO>> order : list) {%>
                        <div class="container" style="margin-bottom: 20px">
                            <article class="card">
                                <h5 class="card-header">
                                    Mã đơn hàng: <%=order.getKey().getOrderID()%>
                                    <% if ("Chưa xác nhận".equalsIgnoreCase(order.getKey().getStatusName())) {%>
                                    <button type="button" class="btn btn-danger" style="float: right; padding: 12px 15px 8px; text-align: center; font-weight: 600" data-toggle="modal" data-target="#<%=order.getKey().getOrderID()%>Modal">HUỶ ĐƠN HÀNG</button>
                                    <div class="modal fade" id="<%=order.getKey().getOrderID()%>Modal" role="dialog">
                                        <div class="modal-dialog">
                                            <!-- Modal content-->
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h4 class="modal-title">Huỷ đơn hàng</h4>
                                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                                </div>
                                                <div class="modal-body">
                                                    <p>Bạn có chắc muốn huỷ đơn hàng này?</p>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type='button' class='btn btn-default' data-dismiss="modal">Huỷ</button>
                                                    <a href="MainController?action=CancelOrder&orderID=<%=order.getKey().getOrderID()%>&payType=<%=order.getKey().getPayType()%>"><button type="button" class="btn btn-danger">Xác nhận</button></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <%}%>
                                    <a style="float: right" class="mr-2" href="MainController?action=CustomerViewOrderDetail&orderID=<%=order.getKey().getOrderID()%>"><button class="primary-btn">Chi tiết</button></a>

                                    
                                </h5>
                                <div class="card-body">
                                    <%
                                        for (int i = 0; i < order.getValue().size(); i++) {
                                            if (i % 4 == 0 || i == 0) {
                                    %>
                                    <div class="d-flex flex-row" style="justify-content: flex-start">
                                        <%}%>
                                        <div class="order__product__item p-5">
                                            <img src="<%= order.getValue().get(i).getImage()%>" alt="product-image" style="width: 80px; float: left">
                                            <div class="order__product__item__title">
                                                <a href="ProductRouteController?productID=<%= order.getValue().get(i).getProductID()%>">
                                                    <h6 class="mb-3"><%= order.getValue().get(i).getProductName()%></h6>
                                                </a>
                                                <%= order.getValue().get(i).getColor()%>, <%= order.getValue().get(i).getSize()%> x <%= order.getValue().get(i).getQuantity()%><br>
                                                <p style="font-weight: 500; color: black"><%= order.getValue().get(i).getPrice() / 1000%>.000</p>

                                            </div>
                                        </div>
                                        <%if ((i % 3 == 0 & i != 0) || i == order.getValue().size() - 1) {%>
                                            </div>
                                        <%}
                                    }%>  
                                </div>
                                <div class="d-flex flex-row-reverse order__total mr-2" style="font-size: 20px">
                                    Tổng: <%= (int) (order.getKey().getTotal()) / 1000%>.000
                                </div>  
                                <%if(order.getKey().getStatusName().equalsIgnoreCase("ĐÃ GIAO")) {%>
                                <div class="d-flex flex-row-reverse mr-2">
                                    <button class="primary-btn"><i class="fa fa-star"></i>Ðánh giá</button>
                                </div> 
                                <%}%>
                            </article>
                        </div>
                            <hr/>
                        <%}%>
                    
        </section>
        <!-- Shop Cart Section End -->

        <%      }
            }%>
        <!-- Search Begin -->
        <div class="search-model">
            <div class="h-100 d-flex align-items-center justify-content-center">
                <div class="search-close-switch">+</div>
                <form class="search-model-form">
                    <input type="text" id="search-input" placeholder="Search here.....">
                </form>
            </div>
        </div>
        <!-- Search End -->

        <jsp:include page="footer.jsp" flush="true" />
    </script>
    <!-- Js Plugins -->
    <jsp:include page="js-plugins.jsp" flush="true" />
</body>
</html>