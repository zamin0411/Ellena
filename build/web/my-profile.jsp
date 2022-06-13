<%@page import="store.user.UserError"%>
<%@page import="store.user.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Profile của tôi</title>
        <jsp:include page="meta.jsp" flush="true"/>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    </head>
    <body>
        <%
            UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");
            if ("AD".equalsIgnoreCase(loginUser.getRoleID())) {
        %>
        <div class="sidenav">
            <a href="ShowAccountController"><i class="fa fa-address-card fa-lg"></i>Quản lý tài khoản</a>
            <a href="ShowManagerController"><i class="fa fa-group fa-lg"></i>Quản lý manager</a>
            <a href="ShowCategoryController"><i class="fa fa-cart-plus fa-lg"></i>Quản lý loại sản phẩm</a>
        </div>
        <% } else if ("MN".equalsIgnoreCase(loginUser.getRoleID())) {%>
        <div class="sidenav">
            <a href="ManagerStatisticController"><i class="fa fa-bar-chart fa-lg"></i>Số liệu thống kê</a>
            <a href="ManagerShowProductController"><i class="fa fa-archive fa-lg"></i>Quản lí sản phẩm</a>
            <a href="manager-order.jsp"><i class="fa fa-cart-plus fa-lg"></i>Quản lí đơn hàng</a>
        </div>
        <%}%>
        <div class="main">
            <h3>Profile của tôi</h3>
            <br>
            <table class="profile">
                <tr>
                    <th>Tên tài khoản</th>
                    <td><%= loginUser.getUserID()%></td>
                </tr>
                <tr>
                    <th>Họ và tên</th>   
                    <td><%= loginUser.getFullName()%>
                        <div class="modal fade" id="myModal3" role="dialog" aria-labelledby="myModalLabel">
                            <div class="modal-dialog">
                                <div class="modal-content" >
                                    <div class="modal-header">
                                        <h4 class="modal-title" id="myModalLabel">Thay đổi tên</h4>
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                                    </div>
                                    <div class="modal-body">
                                        <form action="MainController" method="POST">
                                            <div class="row">
                                                <div class="col-md-12 mb-4">

                                                    <div class="form-outline">
                                                        <label class="form-label" for="newName">Tên mới</label>
                                                        <input type="text" name="newName" required="" id="newName" maxlength="100" value="<%= loginUser.getFullName() %>" class="form-control form-control-lg" />
                                                    </div>

                                                </div>

                                            </div>

                                    </div>
                                    <div class="modal-footer">
                                        <button class="btn btn-default" type="submit" name="action" value="UpdateName">Cập nhật</button>
                                        <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <i class="fa fa-edit fa-2x" data-toggle="modal" data-target="#myModal3" style="margin-left: 12px;"></i>
                    </td>
                </tr>
                <tr>   
                    <th>Mật khẩu</th>
                    <td>************ 
                        <div class="modal fade" id="myModal1" role="dialog" aria-labelledby="myModalLabel">
                            <div class="modal-dialog">
                                <div class="modal-content" >
                                    <div class="modal-header">
                                        <h4 class="modal-title" id="myModalLabel">Thay đổi mật khẩu</h4>
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                                    </div>
                                    <div class="modal-body">
                                        <form action="MainController">
                                            <div class="row">
                                                <div class="col-md-12 mb-4">

                                                    <div class="form-outline">
                                                        <label class="form-label" for="currentPassword">Mật khẩu hiện tại</label>
                                                        <input type="password" name="currentPassword" required="" id="currentPassword" maxlength="100" class="form-control form-control-lg" />
                                                        <p style="color: red">${requestScope.USER_ERROR.password}</p>
                                                    </div>

                                                </div>

                                            </div>
                                            <div class="row">
                                                <div class="col-md-12 mb-4">

                                                    <div class="form-outline">
                                                        <label class="form-label" for="newPassword">Mật khẩu mới</label>
                                                        <input type="password" name="newPassword" required="" id="newPassword" class="form-control form-control-lg" />
                                                        <p style="color: red">${requestScope.USER_ERROR.confirm}</p>
                                                    </div>

                                                </div>

                                            </div>
                                            <div class="row">
                                                <div class="col-md-12 mb-4">

                                                    <div class="form-outline">
                                                        <label class="form-label" for="confirmNewPassword">Nhập lại mật khẩu mới</label>
                                                        <input type="password" name="confirmNewPassword" required="" id="confirmNewPassword" class="form-control form-control-lg" />
                                                    </div>

                                                </div>

                                            </div>
                                    </div>
                                    <div class="modal-footer">
                                        <button class="btn btn-default" type="submit" name="action" value="UpdatePassword">Cập nhật</button>
                                        <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <i class="fa fa-edit fa-2x" data-toggle="modal" data-target="#myModal1" style="margin-left: 12px;"></i>
                    </td>
                </tr>
                <tr>   
                    <th>Số điện thoại</th>
                    <td><%= loginUser.getPhone()%>
                        <div class="modal fade" id="myModal4" role="dialog" aria-labelledby="myModalLabel">
                            <div class="modal-dialog">
                                <div class="modal-content" >
                                    <div class="modal-header">
                                        <h4 class="modal-title" id="myModalLabel">Thay đổi số điện thoại</h4>
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                                    </div>
                                    <div class="modal-body">
                                        <form action="MainController" method="POST">
                                            <div class="row">
                                                <div class="col-md-12 mb-4">

                                                    <div class="form-outline">
                                                        <label class="form-label" for="newPhone">Số điện thoại mới</label>
                                                        <input type="text" name="newPhone" id="newPhone" required="" maxlength="20" value="<%= loginUser.getPhone() %>" class="form-control form-control-lg" />
                                                    </div>

                                                </div>

                                            </div>

                                    </div>
                                    <div class="modal-footer">
                                        <button class="btn btn-default" type="submit" name="action" value="UpdatePhone">Cập nhật</button>
                                        <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <i class="fa fa-edit fa-2x" data-toggle="modal" data-target="#myModal4" style="margin-left: 12px;"></i>
                    </td>
                </tr>
                <tr>
                    <th>Địa chỉ</th>
                    <td><%= loginUser.getAddress()%>
                        <div class="modal fade" id="myModal2" role="dialog" aria-labelledby="myModalLabel">
                            <div class="modal-dialog">
                                <div class="modal-content" >
                                    <div class="modal-header">
                                        <h4 class="modal-title" id="myModalLabel">Thay đổi địa chỉ</h4>
                                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                                    </div>
                                    <div class="modal-body">
                                        <form action="MainController">
                                            <div class="row">
                                                <div class="col-md-12 mb-4">

                                                    <div class="form-outline">
                                                        <label class="form-label" for="newAddress">Địa chỉ mới</label>
                                                        <input type="text" name="newAddress" required="" id="newAddress" value="<%= loginUser.getAddress() %>" class="form-control form-control-lg" />                                                    
                                                    </div>

                                                </div>

                                            </div>

                                    </div>
                                    <div class="modal-footer">
                                        <button class="btn btn-default" type="submit" name="action" value="UpdateAddress">Cập nhật</button>
                                        <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <i class="fa fa-edit fa-2x" data-toggle="modal" data-target="#myModal2" style="margin-left: 12px;"></i>
                    </td>
                </tr>
        </div>

        <% UserError userError = (UserError) request.getAttribute("USER_ERROR");
            if (userError != null) { %>
        <script>

            $(document).ready(function () {
                $("#myModal1").modal();
            });

        </script>                                                
        <% }%>                             

    </body>
</html>