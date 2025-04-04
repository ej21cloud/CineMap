package pack.index;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pack.cookie.CookieManager;

import java.io.IOException;

@WebServlet("/ThemeCookie")
public class ThemeCookie extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		CookieManager cm = CookieManager.getInstance();
				
				try {
		            // "mode" 쿠키 생성
		            response.addCookie(cm.createCookie("mode", "dark"));
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
	}
}