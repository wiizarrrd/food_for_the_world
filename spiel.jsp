<HTML>
<BODY>
  <a href="test.jsp">back</a>
  <%@ include file="Snake.jsp" %>
  <%
  //Thread thread = new Thread(){
  //    	public void run(){
          Snake_v001 spiel = new Snake_v001();
          try{
            spiel.gameLoop();
          }
          catch(Exception e){
            e.printStackTrace();
          }
//        }
//    };
//    thread.start();
    %>
</BODY>
</HTML>
