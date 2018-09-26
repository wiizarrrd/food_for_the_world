<%@ page import="java.awt.*" %>
<HTML>
<BODY>
<%
    // This scriptlet declares and initializes "date"
    System.out.println( "Evaluating date now" );
    java.util.Date date = new java.util.Date();
%>
Hello!  The time is now
<%
    out.println( date );
    out.println( "<br>Your machine's<br> address is " );
    out.println( request.getRemoteHost());
%>
<TABLE BORDER=2>
<%
    for ( int i = 0; i < 10; i++ ) {
        %>
        <TR>
        <TD>Number</TD>
        <TD><%= i+1 %></TD>
        <TD><%= i++ %></TD>
        <TD><%= i %></TD>
        </TR>
        <%
    }
%>
<%
boolean hello=!true ;
    if ( hello ) {
        %>
        <P>Hello, world
        <%
    } else {
        %>
        <P>Goodbye, world
        <%
    }
%>

</TABLE>
<script language="javascript" type="text/javascript">
function windowClose(){
  var myWindow = window.open("spiel.jsp","","status").close();
}
</script>
<button value="Open Window" onclick="windowClose()">Snake</button>
</BODY>
</HTML>
