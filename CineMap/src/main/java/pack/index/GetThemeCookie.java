package pack.index;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pack.cookie.CookieManager;

import java.io.IOException;

@WebServlet("/getThemeCookie")
public class GetThemeCookie extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        CookieManager cm = CookieManager.getInstance();
        String mode = "light"; // 기본값

        try {
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("mode".equals(cookie.getName())) {
                        mode = cm.readCookie(cookie);
                        break;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.setContentType("application/json");
        response.getWriter().write("{\"mode\":\"" + mode + "\"}");
    }
}