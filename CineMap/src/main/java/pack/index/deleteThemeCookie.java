package pack.index;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pack.cookie.CookieManager;

import java.io.IOException;

@WebServlet("/deleteThemeCookie")
public class deleteThemeCookie extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 		CookieManager cm = CookieManager.getInstance();
	        try {
	            response.addCookie( cm.deleteCookie("mode"));
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	}
}