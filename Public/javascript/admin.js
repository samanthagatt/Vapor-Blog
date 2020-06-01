function confirmDelete(path, id) {
  let isConfirmed = confirm("Press ok to delete");
  if (isConfirmed) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.onreadystatechange = function () {
      if (xmlHttp.readyState != 4 || xmlHttp.status != 200) {
        console.log(xmlHttp.status);
        return;
      }
      // Get deleted element and remove it from view
      var element = document.getElementById(id);
      console.log(element);
      
    }
    xmlHttp.open("POST", path + id + "/delete", true);
    xmlHttp.send(null);
  }
}