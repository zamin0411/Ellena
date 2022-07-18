<%@page import="store.shopping.ProductDTO"%>
<%@page import="java.util.List"%>
<%@page import="store.user.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý sản phẩm</title>
        <jsp:include page="meta.jsp" flush="true"/>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    </head>
    <body>
        <%
            UserDTO loginUser = (UserDTO) session.getAttribute("LOGIN_USER");

//            checking if using ShowController or SearchController page count
            boolean searchAll = false;
            String status = request.getParameter("status");//For storing request param for pagnation            

            String search = request.getParameter("search");
            if (search == null) {
                search = "";
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
        </div> <%}%>




        <div class="sidenav">
            <a href="ManagerStatisticController"><i class="fa fa-bar-chart fa-lg"></i>Số liệu thống kê</a>
            <a href="ManagerShowProductController" style="color: #873e23; font-weight: bold;"><i class="fa fa-archive fa-lg"></i>Quản lí sản phẩm</a>
            <a href="ShowOrderController"><i class="fa fa-cart-plus fa-lg"></i>Quản lí đơn hàng</a>
            <a href="manager-customer-return-history.jsp"><span>CHO XIN CÁI ICON :V</span>Lịch sử đổi/trả</a>
        </div>

        <div class="main">
            <form action="MainController" method="POST" style="margin-left: 65%;">                
                Xin chào, <a href="my-profile.jsp"><%= loginUser.getFullName()%></a>
                <input type="submit" name="action" value="Logout" style="margin-left: 4%;">
            </form>

            <div class="row" style="margin: 0;">
                <h1>Danh sách sản phẩm</h1>
            </div>

            <!--search bar and add product row-->
            <div class="row">
                <!--search bar-->
                <div class="col-9">
                    <form action="MainController">
                        <input type="text" name="search" value="<%= search%>" placeholder="Tìm kiếm sản phẩm">

                        Trạng thái
                        <select name="status">
                            <option value="all">Chọn trạng thái</option>
                            <option value="true">Active</option>
                            <option value="false">Inactive</option>
                        </select>

                        <button type="submit" name="action" value="ManagerSearchProduct" class="btn-outline-dark" style="width: 15%; padding: 0.5% 0.1%;"><i class="fa fa-search fa-lg"></i>Search</button>
                        <!--switch to SearchController page count after submit form-->
                        <%
                            searchAll = (boolean) request.getAttribute("SWITCH_SEARCH");
                        %>

                    </form>
                </div>



            </div>
            <a href="add-product.jsp">Thêm sản phẩm mới</a>

            <%  List<ProductDTO> listProduct = (List<ProductDTO>) request.getAttribute("LIST_PRODUCT");
                if (listProduct != null) {
                    if (listProduct.size() > 0) {
            %>  
            <table class="table table-hover table-bordered">
                <tr style="background-color: #b57c68">
                    <th>ID Sản phẩm</th>
                    <th>Tên Sản phẩm</th>                
                    <th>Loại sản phẩm</th>
                    <th>Giá</th>
                    <th>Giảm giá (%)</th>
                    <th>Trạng thái</th>
                    <th>Chỉnh sửa</th>
                </tr>
                <%
                    for (ProductDTO list : listProduct) {
                %>
                <tr>
                    <td style="font-weight: bold"><%= list.getProductID()%></td>
                    <td><%= list.getProductName()%></td>
                    <td><%= list.getCategoryName()%></td>
                    <td><%= list.getPrice()%></td>
                    <td><%= Math.round(list.getDiscount() * 100 / list.getPrice())%></td>
                    <td>
                        <%
                            if (list.isStatus()) {
                        %>
                        <a href="MainController?action=DeactivateProduct&productID=<%=list.getProductID()%>">Vô hiệu hoá</a> 
                        <%} else {
                        %>
                        <a href="MainController?action=ActivateProduct&productID=<%=list.getProductID()%>">Kích hoạt</a> 
                        <%
                            }
                        %>
                    </td>

                    <!-- Chỉnh sửa chi tiết product-->
                    <td>
                        <a href="ManagerShowProductDetailController?productID=<%=list.getProductID()%>">Chi tiết</a>
                    </td>

                </tr>
                <%         }
                        }
                    }%>
            </table>



            <!--page nav-->
            <%
                if (listProduct != null) { // if no product in list, page nav won't display
            %>
            <div class="row pagination__option" style="justify-content: center; align-items: center; text-align: center;">

                <%
                    int currentPage = (int) request.getAttribute("currentPage");
                    int noOfPages = (int) request.getAttribute("noOfPages");
                    int noOfPageLinks = 5; // amount of page links to be displayed
                    int minLinkRange = noOfPageLinks / 2; // minimum link range ahead/behind

//                    -------------------------------Calculating the begin and end of pageNav for loop-------------------------------
                    //  int begin = ((currentPage - minLinkRange) > 0 ? ((currentPage - minLinkRange) < (noOfPages - noOfPageLinks + 1) ? (currentPage - minLinkRange) : (noOfPages - noOfPageLinks)) : 0) + 1; (referance)
                    int begin = 0;
                    if ((currentPage - minLinkRange) > 0) {
                        if ((currentPage - minLinkRange) < (noOfPages - noOfPageLinks + 1) || (noOfPages < noOfPageLinks)) { // add in (noOfPages < noOfPageLinks) in order to prevent negative page link
                            begin = (currentPage - minLinkRange);
                        } else {
                            begin = (noOfPages - noOfPageLinks + 1);
                        }
                    } else {
                        begin = 1;
                    }

                    //  int end = (currentPage + minLinkRange) < noOfPages ? ((currentPage + minLinkRange) > noOfPageLinks ? (currentPage + minLinkRange) : noOfPageLinks) : noOfPages; (referance)
                    int end = 0;
                    if ((currentPage + minLinkRange) < noOfPages) {
                        if ((currentPage + minLinkRange) > noOfPageLinks) {
                            end = (currentPage + minLinkRange);
                        } else {
                            end = noOfPageLinks;
                        }
                    } else {
                        end = noOfPages;
                    }
//                    -----------------------------------------------------------------------------------------------------------------------------

                    if (searchAll) { //Currently at ShowController

                        //start of pageNav
                        if (currentPage != 1) {
                %>

                <!-- For displaying Previous link except for the 1st page -->
                <a href="ManagerShowProductController?page=<%= currentPage - 1%>"><i class="glyphicon glyphicon-menu-left"></i></a>
                    <%
                        }
                    %>
                <!--For displaying Page numbers. The when condition does not display a link for the current page-->

                <%  for (int i = begin; i <= end; i++) {
                        if (currentPage == i) {
                %>
                <a class="active" style="background: #000000; color: #ffffff"><%= i%></a>  <!-- There is no active class for pagination (currenly hard code) -->
                <%
                } else {
                %>
                <a href="ManagerShowProductController?page=<%= i%>" style="text-decoration: none;"><%= i%></a>
                <%
                        }
                    }
                %>


                <!--For displaying Next link -->
                <%
                    if (currentPage < noOfPages) {
                %>
                <a href="ManagerShowProductController?page=<%= currentPage + 1%>"><i class="glyphicon glyphicon-menu-right"></i></a>
                    <%
                        }

                        //                end of pageNav
                    %>



                <%            } else {//Currently at SearchController
                    //                    start of pageNav
                    if (currentPage != 1) {
                %>

                <!-- For displaying Previous link except for the 1st page -->
                <a href="ManagerSearchProductController?search=<%= search%>&status=<%= status%>&page=<%= currentPage - 1%>" style="text-decoration: none;"><i class="glyphicon glyphicon-menu-left"></i></a>
                    <%
                        }
                    %>

                <!--For displaying Page numbers. The when condition does not display a link for the current page--> 

                <%  for (int i = begin; i <= end; i++) {
                        if (currentPage == i) {
                %>
                <a class="active" style="background: #000000; color: #ffffff"><%= i%></a>  <!-- There is no active class for pagination (currenly hard code) -->
                <%
                } else {
                %>
                <a href="ManagerSearchProductController?search=<%= search%>&status=<%= status%>&page=<%= i%>"><%= i%></a>
                <%
                        }
                    }
                %>


                <!--For displaying Next link -->
                <%
                    if (currentPage < noOfPages) {
                %>
                <a href="ManagerSearchProductController?search=<%= search%>&status=<%= status%>&page=<%= currentPage + 1%>"><i class="glyphicon glyphicon-menu-right"></i></a>
                    <%
                            }

                        }
                        //                end of pageNav

                    %>

            </div>
            <%                
                } //end of the "No product" if statement
            %>







        </div>

        <script>
            $(document).ready(function () {
                $("#myModal").modal();
            });
        </script> 


    </body>
</html>
