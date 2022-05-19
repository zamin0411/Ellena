/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package store.user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import store.utils.DBUtils;

/**
 *
 * @author giama
 */
public class UserDAO {

    private static final String LOGIN = "SELECT fullName, sex, roleID, address, birthday, phone, status FROM tblUsers WHERE userID=? AND password=?";
    private static final String CHECK_DUPLICATE = "SELECT fullName FROM tblUsers WHERE userID=?";
    private static final String SEARCH_PRODUCT = "SELECT userID, fullName, sex, roleID, address, birthday, phone, status FROM tblUsers WHERE userID LIKE ? AND roleID LIKE ? AND status=?";
    private static final String SEARCH_PRODUCT_ALL = "SELECT userID, fullName, sex, roleID, address, birthday, phone, status FROM tblUsers";
    private static final String INSERT = "INSERT tblUsers(userID, fullName, password, sex, roleID, address, birthday, phone, status) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
    private static final String SEARCH_USER = "SELECT userID, fullName, sex, roleID, address, birthday, phone, status FROM tblUsers WHERE userID LIKE ? AND roleID LIKE ? AND status=?";
    private static final String SEARCH_USER_ALL = "SELECT userID, fullName, sex, roleID, address, birthday, phone, status FROM tblUsers";


    public UserDTO checkLogin(String userID, String password) throws SQLException {
        UserDTO user = null;
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                stm = conn.prepareStatement(LOGIN);
                stm.setString(1, userID);
                stm.setString(2, password);
                rs = stm.executeQuery();
                if (rs.next()) {
                    String fullName = rs.getString("fullName");
                    boolean sex = rs.getBoolean("sex");
                    String roleID = rs.getString("roleID");
                    String address = rs.getString("address");
                    Date birthday = rs.getDate("birthday");
                    String phone = rs.getString("phone");
                    boolean status = rs.getBoolean("status");
                    user = new UserDTO(userID, fullName, "*******", sex, roleID, address, birthday, phone, status);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (stm != null) {
                stm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }

        return user;
    }

    public boolean checkDuplicate(String userID) throws SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement stm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                stm = conn.prepareStatement(CHECK_DUPLICATE);
                stm.setString(1, userID);
                rs = stm.executeQuery();
                if (rs.next()) {
                    check = true;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) {
                rs.close();
            }
            if (stm != null) {
                stm.close();
            }
            if (conn != null) {
                conn.close();
            }
        }

        return check;
    }
    

    public boolean addUser(UserDTO user) throws SQLException {
        boolean check = false;
        Connection conn = null;
        PreparedStatement ptm = null;
        try {
            conn = DBUtils.getConnection();
            ptm = conn.prepareStatement(INSERT);
            String id = user.getUserID();
            String name = "N" + user.getFullName();
            String password = user.getPassword();
            boolean sex = user.getSex();
            String roleID = user.getRoleID();
            String address = user.getAddress();
            Date date = user.getBirthday();
            String phone = user.getPhone();
            boolean status = user.isStatus();
            ptm.setString(1, id);
            ptm.setString(2, name);
            ptm.setString(3, password);
            ptm.setBoolean(4, sex);
            ptm.setString(5, roleID);
            ptm.setString(6, address);
            ptm.setDate(7, new java.sql.Date(date.getTime()));
            ptm.setString(8, phone);
            ptm.setBoolean(9, status);
            check = ptm.executeUpdate() > 0 ? true : false;

        } catch (Exception e) {
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

    public List<UserDTO> getListUsers(String search, String roleID, String Status) throws SQLException {
        List<UserDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(SEARCH_PRODUCT);
                ptm = conn.prepareStatement(SEARCH_USER);
                ptm.setString(1, "%" + search + "%");
                ptm.setString(2, roleID);
                ptm.setString(3, Status);
                rs = ptm.executeQuery();
                while (rs.next()) {
                    String userID = rs.getString("userID");
                    String fullName = rs.getString("fullName");
                    boolean sex = rs.getBoolean("sex");
                    roleID = rs.getString("roleID");
                    String address = rs.getString("address");
                    Date birthday = rs.getDate("birthday");
                    String phone = rs.getString("phone");
                    boolean status = rs.getBoolean("status");
                    list.add(new UserDTO(userID, fullName, "*******", sex, roleID, address, birthday, phone, status));
                }
            }
        } catch (Exception e) {
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
        return list;
    }
    
    public List<UserDTO> getAllUsers() throws SQLException {
        List<UserDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ptm = null;
        ResultSet rs = null;
        try {
            conn = DBUtils.getConnection();
            if (conn != null) {
                ptm = conn.prepareStatement(SEARCH_PRODUCT_ALL);
                rs = ptm.executeQuery();
                while (rs.next()) {
                    String userID = rs.getString("userID");
                    String fullName = rs.getString("fullName");
                    boolean sex = rs.getBoolean("sex");
                    String roleID = rs.getString("roleID");
                    String address = rs.getString("address");
                    Date birthday = rs.getDate("birthday");
                    String phone = rs.getString("phone");
                    boolean status = rs.getBoolean("status");
                    list.add(new UserDTO(userID, fullName, "*******", sex, roleID, address, birthday, phone, status));
                }
            }
        } catch (Exception e) {
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
        return list;
    }

}
