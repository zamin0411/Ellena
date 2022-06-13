<%@page import="store.user.UserDAO"%>
<%@page import="java.util.List"%>
<%@page import="store.user.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Trang chủ | Administrator</title>
        <jsp:include page="meta.jsp" flush="true"/>
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
            List<UserDTO> listUser = (List<UserDTO>) request.getAttribute("LIST_USER");
            String roleID = request.getParameter("roleID");
            if (roleID == null) {
                roleID = "%";
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
                        <a href="MainController?action=SearchAccount&search=<%=search%>&roleID=<%= roleID %>"><button type="button" class="btn btn-default">Đóng</button></a>
                    </div>
                </div>

            </div>
        </div> <%}%>
        
        <div class="sidenav">
            <a href="ShowAccountController" style="color: #873e23; font-weight: bold;"><i class="fa fa-address-card fa-lg"></i>Quản lý tài khoản</a>
            <a href="ShowManagerController"><i class="fa fa-group fa-lg"></i>Quản lý manager</a>
            <a href="ShowCategoryController"><i class="fa fa-cart-plus fa-lg"></i>Quản lý loại sản phẩm</a>
        </div>

        <div class="main">
        
            <form action="MainController" method="POST" style="margin-left: 65%;">                
                Xin chào, <a href="my-profile.jsp"><%= loginUser.getFullName()%></a>
                <input type="submit" name="action" value="Logout" style="margin-left: 4%;">
            </form>
                
            <form action="MainController" method="POST">
                <input type="text" name="search" value="<%= search%>" placeholder="Tìm kiếm tài khoản">
                Quyền
                <select name="roleID">
                    <option value="%" selected hidden>Chọn một quyền</option>
                    <option value="AD">Quản trị viên</option>
                    <option value="MN">Người quản lý</option>
                    <option value="EM">Nhân viên</option>
                    <option value="CM">Khách hàng</option>
                </select>
                Trạng thái
                <select name="status">
                    <option value="all" selected hidden>Chọn trạng thái</option>
                    <option value="true">Active</option>
                    <option value="false">Inactive</option>
                </select>
                <button type="submit" name="action" value="SearchAccount" class="btn-outline-dark" style="width: 15%; padding: 0.5% 0.1%;"><i class="fa fa-search fa-lg"></i>Search</button>
            </form>   
            <a href="add-account.jsp">Tạo tài khoản mới</a>
            <%               
                if (listUser != null) {
                    if (listUser.size() > 0) {
            %>      
            <table class="table table-hover table-bordered">
                <tr style="background-color: #b57c68">
                    <th>Tên tài khoản</th>
                    <th>Họ và tên</th>                
                    <th>Số điện thoại</th>
                    <th>Quyền</th>
                    <th>Trạng thái</th>
                    <th>Chỉnh sửa</th>
                </tr>
                <%
                    int id = 1;
                    for (UserDTO user : listUser) {
                %>
                <tr>
                    <td style="font-weight: bold"><%= user.getUserID()%></td>
                    <td><%= user.getFullName()%></td>
                    <td><%= user.getPhone()%></td>
                    <td><%= user.getRoleID()%></td>
                    <td>
                        <%
                            if (user.isStatus()) {
                        %>
                             <a href="MainController?action=DeactivateAccount&userID=<%=user.getUserID()%>&search=<%= search %>&roleID=<%= roleID %>&from=ShowAccount">Vô hiệu hoá</a>
                        <%} else {
                        %>
                             <a href="MainController?action=ActivateAccount&userID=<%=user.getUserID()%>&search=<%= search %>&roleID=<%= roleID %>&from=ShowAccount">Kích hoạt</a>
                        <%
                            }
                        %>
                    </td>
                
                <!-- Chỉnh sửa chi tiết account-->
                <td>
                    <div class="modal fade" id="myModal<%=id%>" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                        <div class="modal-dialog" id="<%=id%>" >
                            <div class="modal-content" >
                                <div class="modal-header">
                                    <h4 class="modal-title" id="myModalLabel">Chỉnh sửa tài khoản</h4>
                                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>

                                </div>
                                <div class="modal-body">
                                    <form action="MainController">
                                        <div class="row">
                                            <div class="col-md-12 mb-4">

                                                <div class="form-outline">
                                                    <label class="form-label" for="email">Email</label>
                                                    <input type="email" name="userID" value="<%= user.getUserID()%>" readonly="" id="userID" class="form-control form-control-lg" />
                                                </div>

                                            </div>

                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-4 pb-2">

                                                <div class="form-outline">
                                                    <label class="form-label" for="fullName">Họ và tên</label>
                                                    <input type="text" name="fullName" value="<%= user.getFullName()%>" id="fullName" class="form-control form-control-lg" />

                                                </div>

                                            </div>
                                            <div class="col-md-6 mb-4 pb-2">

                                                <div class="form-outline">
                                                    <label class="form-label" required="" for="roleID">Quyền</label>
                                                    <% if (user.getRoleID().equals("CM")) {%><input type="text" name="roleID" readonly="" value="<%=user.getRoleID()%>" class="form-control form-control-lg"><%} else {%>
                                                    <select class="form-control form-control-lg" <%if (user.getRoleID().equals("AD")) {%> style="background: #eee; /*Simular campo inativo - Sugestão @GabrielRodrigues*/
                                                            pointer-events: none;
                                                            touch-action: none;" tabindex="-1" aria-disabled="true"<%}%> name="roleID">
                                                        <option value="AD" <%if (user.getRoleID().equals("AD")) {%>selected <%}%>>AD</option>
                                                        <option value="MN" <%if (user.getRoleID().equals("MN")) {%>selected <%}%>>MN</option>  
                                                        <option value="EM" <%if (user.getRoleID().equals("EM")) {%>selected <%}%>>EM</option>
                                                    </select> 
                                                    <%}%>
                                                </div>
                                            </div>        

                                        </div>
                                        <div class="row">
                                            <div class="col-md-6 mb-4 d-flex align-items-center">

                                                <div class="form-outline datepicker w-100">
                                                    <label for="birthdayDate" class="form-label">Ngày sinh</label>
                                                    <input type="date" name="birthday" value="<%= user.getBirthday()%>" class="form-control form-control-lg" id="birthdayDate" />

                                                </div>

                                            </div>
                                            <div class="col-md-6 mb-4">

                                                <h6 class="mb-2 pb-1">Giới tính: </h6>

                                                <div class="form-check form-check-inline">
                                                    
                                                    <input class="form-check-input" type="radio" name="sex" id="maleGender"
                                                           value="true" <% if (user.getSex() == true) {%> checked <% }%>/>
                                                    <label class="form-check-label" for="maleGender">Nam</label>
                                                </div>

                                                <div class="form-check form-check-inline">
                                                    <input class="form-check-input" type="radio" name="sex" id="femaleGender"
                                                           value="false" <% if (user.getSex() == false) {%> checked <% } %>/>
                                                    <label class="form-check-label" for="femaleGender">Nữ</label>
                                                </div>



                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-md-6 mb-4 pb-2">

                                                <div class="form-outline">
                                                    <label class="form-label" for="address">Địa chỉ</label>
                                                    <input type="text" name="address" value="<%=user.getAddress()%>" id="address" class="form-control form-control-lg" />
                                                </div>

                                            </div>
                                            <div class="col-md-6 mb-4 pb-2">

                                                <div class="form-outline">
                                                    <label class="form-label" required="" for="phoneNumber">Số điện thoại</label>
                                                    <input type="tel" id="phoneNumber" value="<%=user.getPhone()%>" name="phone" class="form-control form-control-lg" />
                                                </div>
                                            </div>
                                        </div>

                                            

                                </div>
                                <div class="modal-footer">
                                    <button class="btn btn-default" type="submit" name="action" value="UpdateAccount">Cập nhật</button>
                                    <button type="button" class="btn btn-default" data-dismiss="modal">Đóng</button>
                                    <!--<button type="button" class="btn btn-primary">Save changes</button>-->
                                </div>
                                </form>

                            </div>
                        </div>
                    </div>
                    <button type="button" data-toggle="modal" data-target="#myModal<%=id++%>">Chỉnh sửa</button>

                </td>

                </tr>
                <%         }
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