package store.shopping;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import store.utils.DBUtils;

public class ProductDAO {

    private static final String ACTIVATE_PRODUCT = "UPDATE tblProduct SET status=1 WHERE productID=?";
    private static final String DEACTIVATE_PRODUCT = "UPDATE tblProduct SET status=0 WHERE productID=?";
    private static final String SEARCH_ALL_PRODUCT = "SELECT productID, productName, price, categoryName, discount, lowStockLimit, p.status  FROM tblProduct p JOIN tblCategory c ON p.categoryID=c.categoryID";
    private static final String SEARCH_PRODUCT = "SELECT productID, productName, price, categoryName, discount, lowStockLimit, p.status  FROM tblProduct p JOIN tblCategory c ON p.categoryID=c.categoryID HAVING dbo.fuChuyenCoDauThanhKhongDau(productName) LIKE ?";
    private static final String GET_PRODUCT = "SELECT productID, productName, price, description, categoryName, discount, lowStockLimit, p.status  FROM tblProduct p JOIN tblCategory c ON p.categoryID=c.categoryID AND productID=?";
    private static final String SEARCH_PRODUCT_WITH_STATUS = "SELECT * FROM tblProduct WHERE dbo.fuChuyenCoDauThanhKhongDau(productName) LIKE ? AND status=?";
    private static final String GET_PRODUCT_COLOR_IMAGES = "SELECT color, image\n"
            + "FROM tblProduct p JOIN tblProductColors pc\n"
            + "ON p.productID = pc.productID \n"
            + "AND p.productID = ?\n"
            + "JOIN tblColorImage ci\n"
            + "ON ci.productColorID = pc.productColorID"; //-------------------------------
    private static final String GET_PRODUCT_COLOR_SIZES = "SELECT color, size, quantity\n"
            + "FROM tblProduct p JOIN tblProductColors pc \n"
            + "ON p.productID = pc.productID \n"
            + "AND p.productID = ?\n"
            + "JOIN tblColorSizes cs\n"
            + "ON cs.productColorID = pc.productColorID";

    private int numberOfProduct;

    public int getNumberOfProduct() {
        return numberOfProduct;
    }

    public List<ProductDTO> getAllProduct() throws SQLException {
        List<ProductDTO> listProduct = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(SEARCH_ALL_PRODUCT);
                rs = ptm.executeQuery();
                while (rs.next()) {
                    int productID = rs.getInt("productID");
                    String productName = rs.getString("productName");
                    int price = rs.getInt("price");
                    float discount = rs.getFloat("discount");
                    String categoryName = rs.getString("categoryName");
                    int lowStockLimit = rs.getInt("lowStockLimit");
                    boolean status = rs.getBoolean("status");
                    listProduct.add(new ProductDTO(productID, productName, price, discount, lowStockLimit, categoryName, status));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }

        return listProduct;
    }

    public List<ProductDTO> getListProduct(String search, String Status) throws SQLException {
        List<ProductDTO> listProduct = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;

        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                if ("true".equalsIgnoreCase(Status) || "false".equalsIgnoreCase(Status)) {
                    ptm = conn.prepareStatement(SEARCH_PRODUCT_WITH_STATUS);
                    ptm.setString(1, "%" + search + "%");
                    ptm.setString(2, Status);
                } else {
                    ptm = conn.prepareStatement(SEARCH_PRODUCT);
                    ptm.setString(1, "%" + search + "%");
                }
                rs = ptm.executeQuery();
                while (rs.next()) {
                    int productID = rs.getInt("productID");
                    String productName = rs.getString("productName");

                    int price = rs.getInt("price");
                    float discount = rs.getFloat("discount");
                    String categoryName = rs.getString("categoryName");
                    int lowStockLimit = rs.getInt("lowStockLimit");
                    boolean status = rs.getBoolean("status");
                    listProduct.add(new ProductDTO(productID, productName, price, discount, lowStockLimit, categoryName, status));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }

        return listProduct;
    }

    public boolean activateProduct(int productID) throws SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(ACTIVATE_PRODUCT);
            ptm.setInt(1, productID);

            check = ptm.executeUpdate() > 0 ? true : false;
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return check;
    }

    public boolean deactivateProduct(int productID) throws SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(DEACTIVATE_PRODUCT);
            ptm.setInt(1, productID);

            check = ptm.executeUpdate() > 0 ? true : false;
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }
        return check;
    }

    public ProductDTO getProductDetail(int productID) throws SQLException {
        ProductDTO product = null;
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(GET_PRODUCT);
                ptm.setInt(1, productID);
                rs = ptm.executeQuery();
                String productName = "";
                String description = "";
                int price = 0;
                Map<String, List<String>> colorImage = new HashMap<>();
                Map<List<String>, Integer> colorSizeQuantity = new HashMap<>();
                float discount = 0;
                String categoryName = "";
                int lowStockLimit = 0;
                boolean status = true;
                if (rs.next()) {
                    productName = rs.getString("productName");
                    description = rs.getString("description");
                    price = rs.getInt("price");
                    discount = rs.getFloat("discount");
                    categoryName = rs.getString("categoryName");
                    lowStockLimit = rs.getInt("lowStockLimit");
                    status = rs.getBoolean("status");
                }

                ptm = conn.prepareStatement(GET_PRODUCT_COLOR_IMAGES);
                ptm.setInt(1, productID);
                rs = ptm.executeQuery();
                while (rs.next()) {
                    String color = rs.getString("color");
                    String image = rs.getString("image");
                    if (!colorImage.keySet().contains(color)) {
                        colorImage.put(color, new ArrayList<>());
                        colorImage.get(color).add(image);
                    } else {
                        colorImage.get(color).add(image);
                    }
                }

                ptm = conn.prepareStatement(GET_PRODUCT_COLOR_SIZES);
                ptm.setInt(1, productID);
                rs = ptm.executeQuery();
                while (rs.next()) {
                    String color = rs.getString("color");
                    String size = rs.getString("size");
                    int quantity = rs.getInt("quantity");
                    boolean check = false;
                    if (colorSizeQuantity.isEmpty()) {
                        check = true;
                    } else {
                        if (!colorSizeQuantity.keySet().contains(Arrays.asList(color, size))) {
                            check = true;
                        }
                        

                    }
                    if (check) {
                            colorSizeQuantity.put(Arrays.asList(color, size), quantity);
                        }
                    
                }
                product = new ProductDTO(productID, productName, description, colorImage, colorSizeQuantity, price, price, discount, lowStockLimit, categoryName, status);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (ptm != null) {
                ptm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }

        return product;
    }

}
