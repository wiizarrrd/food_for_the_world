<html>

<head>
  <title>Kuche</title>
  <link type="text/css" rel="stylesheet" href="styles/kuche.css">
  <script src="cookiemonster.js"></script>
  <%@ page import="java.text.SimpleDateFormat"%>

  <%@ include file="j_db_connect.jsp"%>
    <script>
    function deactivateOrder(page){ //deactivates given order
      window.open("kuche.jsp?id="+page,"_self");
      cookiemonster.set("text","",-1);
      cookiemonster.set("page","",-1);
    //  window.location.reload();
    }
     function wr(page,text){ //write bestellung on div and saves it in a cookie
       cookiemonster.set("text",text,30);
       cookiemonster.set("page",page,30);
       document.getElementById('bestellung').innerHTML = text;
       var input = document.createElement("input");
       input.type = "button";
       input.value = "Fertig!";
       input.setAttribute("onclick","deactivateOrder("+page+")");
       document.getElementById('bestellung').appendChild(input);
    };
    setInterval(function() { // reloads page every minute
      window.location.reload();}, 60000);
    </script>
</head>

<body>

  <div id="seite">
    <%  stmt = conn.createStatement();
    if(request.getParameter("id")!=null){ //deactive order when parameter is given
      String sql = "UPDATE ordertable SET active=0 WHERE BESTELLNR = "+request.getParameter("id");
      int r = stmt.executeUpdate(sql);
    }

    //create element on "seite" and insert all data to show it in div "bestellung" when clicked
    String sql = "SELECT * FROM ordertable,positiontable,gerichte WHERE G_NR=GERICHTNR AND ordertable.BESTELLNR=positiontable.BESTELLNR AND active=1 ORDER BY ordertable.BESTELLNR ASC";
    ResultSet rs=stmt.executeQuery(sql);
    int top_id=-1;
    String s;
    String top_s="";
    boolean b=true;
    int count=0;
    String gericht="";
    if(rs.next()){
      top_id  = rs.getInt("bestellnr");
      s="wr("+top_id+",'";
      while(b||rs.next()){
         b=false;
         if(top_id==rs.getInt("BESTELLNR")){
           if(!gericht.equals(rs.getString("Name"))){
              if(gericht!=""){
                s+=" x"+count+"<br>";
              }
              gericht=rs.getString("Name");
              s+=gericht;
              count=1;
           }else{
             count++;
           }
         }else{
           b=true;
            break;
         }
      }
      s+=" x"+count+"<br>')";
      top_s=s;
       %>
            <br>
            <a class="btn main" onclick="<%=s%>">#<%=top_id%></a> <br>
    <%

    }
    if (top_id==-1){
      out.print("Keine Bestellungen vorhanden");
    }
    //STEP 5: Extract data from result set
    while(top_id!=-1 && b||rs.next()){
      gericht="";
       //Retrieve by column name
      int id  = rs.getInt("bestellnr");
      int age = rs.getInt("tischnr");
      s="wr("+id+",'";
      while(b||rs.next()){
        b=false;
        if(id==rs.getInt("BESTELLNR")){
          if(!gericht.equals(rs.getString("Name"))){
             if(gericht!=""){
               s+=" x"+count+"<br>";
             }
             gericht=rs.getString("Name");
             s+=gericht;
             count=1;
          }else{
            count++;
          }
        }else{
          b=true;
          break;
        }
      }
      s+=" x"+count+"<br>')";
      %><a class="btn" onclick="<%=s%>">#<%=id%></a><%
      // out.print(", Age: " + age);
      %> <br> <%
    //   System.out.print(", First: " + first);
    //   System.out.println(", Last: " + last);
    }%>

  </div>

  <div id="bestellung" class="bestellung">
    <%//String a="I am Working!";%>
    <%//=a%>
    <%//out.println("hallo");%>
    <script>
      var str=cookiemonster.get("page");
      if(str!=null){
        wr(str,cookiemonster.get("text"));
      } else{
      <%=top_s%>
      }
    </script>
  </div>
  <div id="uhrzeit">
    Letzte Aktualisierung:
    <%  SimpleDateFormat sdf = new SimpleDateFormat("d.M.y HH:mm:ss");
        out.println( sdf.format(System.currentTimeMillis()) );%>
  </div>
  <div id="temp">
    <a href="http://localhost:81/index.php">zuruck</a>
  </div>


  <%@ include file="j_db_disconnect_1.jsp"%>
      <%  //finally block used to close resources
        if(conn==null){
        %>
        <div id="seite">
        </div>
        <div id="bestellung">
          <%="Die Verbindung zur Datenbank konnte nicht hergestellt werden"%>
        </div>
        <div id="uhrzeit">
          Letzte Aktualisierung:
          <%  SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
              out.println( sdf.format(System.currentTimeMillis()) );%>
        </div>
        <div id="temp">
          <a href="http://localhost:81/index.php">zuruck</a>
        </div>
        <%
      }%>
      <%@ include file="j_db_disconnect_2.jsp"%>
</body>

</html>
