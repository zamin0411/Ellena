<%@page import="store.shopping.OrderStatusDTO"%>
<%@page import="store.shopping.OrderDetailDTO"%>
<%@page import="store.shopping.OrderDetailDAO"%>
<%@page import="store.shopping.OrderDAO"%>
<%@page import="store.shopping.OrderDTO"%>
<%@page import="java.util.List"%>
<%@page import="store.user.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lí đơn hàng | Manager</title>
        <jsp:include page="meta.jsp" flush="true"/>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    </head>
    <body>

        <%
            UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");
            String search = request.getParameter("search");
            if (search == null) {
                search = "";
            }
            if (loginUser == null || !"MN".equals(loginUser.getRoleID())) {
                response.sendRedirect("login.jsp");
                return;
            }

            String message = (String) request.getAttribute("MESSAGE");
            if (message != null) {
        %>
        <!-- Pop-up thông báo cập nhật thành công -->
        <div class="modal fade" id="myModal" role="dialog">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Thông báo</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>

                    </div>
                    <div class="modal-body">
                        <p><%=message%></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                    </div>
                </div>

            </div>
        </div>
        <%
            }
        %>

        <div class="sidenav">
            <a href="manager-statistic.jsp" style="color: #873e23; "><i class=""></i>Số liệu thống kê</a>
            <a href="manager-product.jsp" style="color: #873e23;"><i class=""></i>Quản lí sản phẩm</a>
            <a href="ShowOrderController" style="color: #873e23; font-weight: bold;"><i class=""></i>Quản lí đơn hàng</a>
        </div> 

        <div class="main">
            Xin chào, <a href="my-profile.jsp"><%= loginUser.getFullName()%></a>

            <form action="MainController" method="POST" style="margin-left: 65%;">                
                <input type="submit" name="action" value="Logout" style="margin-left: 4%;">
            </form>

            <form action="MainController" method="POST">
                <input type="text" name="search" value="<%= search%>" placeholder="Tìm kiếm đơn hàng">
                Trạng thái
                <select name="statusID">
                    <option value="%" selected hidden>Chọn một trạng thái</option>
                    <option value="1">Chưa xác nhận</option>
                    <option value="2">Đã xác nhận</option>
                    <option value="3">Đang giao</option>
                    <option value="4">Đã giao</option>
                    <option value="5">Đã hủy</option>
                </select>
                Thời gian
                <select name="numberOfWeek">
                    <option value="%" selected hidden>Chọn khoảng thời gian</option>
                    <option value="3">3 tuần trước</option>
                    <option value="2">2 tuần trước</option>
                    <option value="1">Tuần trước</option>
                    <option value="0">Tuần này</option>
                </select>
                <button type="submit" name="action" value="SearchOrder" class="btn-outline-dark" style="width: 15%; padding: 0.5% 0.1%;"><i class="fa fa-search fa-lg"></i>Search</button>
            </form>   
            ${requestScope.EMPTY_LIST_MESSAGE}
            <%
                List<OrderDTO> listOrder = (List<OrderDTO>) request.getAttribute("LIST_ORDER");
                OrderDetailDAO orderDetailDAO = new OrderDetailDAO();

                if (listOrder != null) {
                    if (listOrder.size() > 0) {
            %>    



            <table class="table table-hover table-bordered">
                <tr style="background-color: #b57c68">
                    <th>ID</th>
                    <th>Ngày đặt hàng</th>                
                    <th>Tổng tiền</th>
                    <th>Tên khách hàng</th>
                    <th>Trạng thái</th>
                    <th>Cập nhật trạng thái</th>
                    <th>Trạng thái đơn hàng</th>

                </tr>
                <%
                    int id = 1;

                    for (OrderDTO order : listOrder) {
                %>
                <tr>
                    <td style="font-weight: bold"><%= order.getOrderID()%></td>
                    <td><%= order.getOrderDate()%></td>
                    <td><%= order.getTotal()%></td>
                    <td><%= order.getUserName()%></td>
                    <td><%= order.getStatusName()%></td>


                    <!--pop-up xem chi tiết và chỉnh trạng thái đơn hàng-->
                    <td>
                        <div class="modal fade" id="myModal<%=id%>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                            <div class="modal-dialog" id="<%=id%>" >
                                <div class="modal-content" >
                                    <div class="modal-header">
                                        <h4 class="modal-title" id="myModalLabel">Chỉnh sửa đơn hàng</h4>
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                                    </div>
                                    <form action="MainController">
                                        <div class="modal-body">

                                            <div class="row">
                                                <div class="col-md-6 mb-4 pb-2">

                                                    <div class="form-outline">
                                                        <label class="form-label" for="orderID">Order ID</label>
                                                        <input type="text" readonly="" name="orderID" value="<%= order.getOrderID()%>" id="orderID" class="form-control form-control-lg" />
                                                    </div>

                                                </div>


                                                <div class="col-md-6 mb-4 pb-2">

                                                    <div class="form-outline">
                                                        <label class="form-label" for="statusID">Status</label>
                                                        <select class="form-control form-control-lg" name="statusID">
                                                            <option value="1" <%if (order.getStatusID() == 1) {%>selected <%}%>>Chưa xác nhận</option>
                                                            <option value="2" <%if (order.getStatusID() == 2) {%>selected <%}%>>Đã xác nhận</option>  
                                                            <option value="3" <%if (order.getStatusID() == 3) {%>selected <%}%>>Đang giao</option>
                                                            <option value="4" <%if (order.getStatusID() == 4) {%>selected <%}%>>Đã giao</option>
                                                            <option value="5" <%if (order.getStatusID() == 5) {%>selected <%}%>>Đã hủy</option>
                                                        </select> 
                                                    </div>

                                                </div>

                                            </div>

                                            <div class="row">
                                                <div class="col-md-12 mb-4">

                                                    <div class="form-outline">
                                                        <label class="form-label" for="fullName">Full name</label>
                                                        <input type="text" name="fullName" value="<%= order.getUserName()%>" readonly="" id="userID" class="form-control form-control-lg" />
                                                    </div>

                                                </div>

                                            </div>


                                            <div class="row">
                                                <div class="col-md-6 mb-4 pb-2">

                                                    <div class="form-outline">
                                                        <label class="form-label" for="orderDate">Order date</label>
                                                        <input type="date" readonly="" name="orderDate" value="<%= order.getOrderDate()%>" id="orderDate" class="form-control form-control-lg" />

                                                    </div>

                                                </div>


                                                <div class="col-md-6 mb-4 pb-2">

                                                    <div class="form-outline">
                                                        <label class="form-label" for="total">Total</label>
                                                        <input type="text" readonly="" name="total" value="<%= order.getTotal()%>" id="total" class="form-control form-control-lg" />

                                                    </div>

                                                </div>

                                            </div>

                                            <div class="row">
                                                <div class="col-md-12 mb-4">
                                                    <label class="form-label" for="">Chi tiết đơn hàng</label>
                                                    <table border="1">
                                                        <thead>
                                                            <tr>
                                                                <th>Product name</th>
                                                                <th>Price</th>
                                                                <th>Quantity</th>
                                                                <th>Size</th>
                                                                <th>Color</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <%
                                                                List<OrderDetailDTO> orderDetailList = orderDetailDAO.getOrderDetail(order.getOrderID());
                                                                for (OrderDetailDTO orderDetail : orderDetailList) {


                                                            %>


                                                            <tr>
                                                                <td><%= orderDetail.getProductName()%></td>
                                                                <td><%= orderDetail.getPrice()%></td>
                                                                <td><%= orderDetail.getQuantity()%></td>
                                                                <td><%= orderDetail.getSize()%></td>
                                                                <td><%= orderDetail.getColor()%></td>
                                                            </tr>

                                                            <%
                                                                }
                                                            %>
                                                        </tbody>
                                                    </table>

                                                </div>

                                            </div>

                                        </div>
                                        <div class="modal-footer">
                                            <button class="btn btn-default" type="submit" name="action" value="UpdateOrder">Cập nhật</button>
                                            <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                                        </div>
                                    </form>

                                </div>
                            </div>
                        </div>
                        <button type="button" data-toggle="modal" data-target="#myModal<%=id++%>">Chỉnh sửa</button>

                    </td>
                    <!--Pop-up lịch sử trạng thái đơn hàng-->
                    <td>
                        <div class="modal fade" id="myModal<%=id%>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                            <div class="modal-dialog" id="<%=id%>" >
                                <div class="modal-content" >
                                    <div class="modal-header">
                                        <h4 class="modal-title" id="myModalLabel">Trạng thái đơn hàng</h4>
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                                    </div>
                                    <div>
                                        <table class="table table-hover table-bordered">
                                            <thead>
                                                <tr>
                                                    <th>Trạng thái</th>
                                                    <th>Ngày</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <%
                                                    List<OrderStatusDTO> orderStatusList = orderDetailDAO.getUpdateStatusHistory(order.getOrderID());
                                                    for (OrderStatusDTO orderStatus : orderStatusList) {
                                                %>
                                                <tr>
                                                    <td><%= orderStatus.getStatusName()%></td>
                                                    <td><%= orderStatus.getUpdateDate()%></td>
                                                </tr>
                                                <%
                                                    }
                                                %>
                                            </tbody>
                                        </table>

                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                                    </div>

                                </div>
                            </div>
                        </div>
                        <button type="button" data-toggle="modal" data-target="#myModal<%=id++%>">Chi tiết</button>
                    </td>
                    <% }
                            }
                        }%>
            </table>
        </div>
        <script>
            $(document).ready(function () {
                $("#myModal").modal();
            });
        </script>
    </body>
</html>
