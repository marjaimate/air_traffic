$('form[data-remote] button').on('click', function(e) {
  e.preventDefault();
  const form = $(e.target).parents('form');
  let csrf = form.find("input[name=_csrf_token]").val();

  $.ajax({
    url: "/send_planes",
    type: "post",
    data: {
      number_of_planes: $(form).find('input#number_of_planes').val()
    },
    headers: {
      "X-CSRF-TOKEN": csrf
    },
    dataType: "json",
    success: function (data) {
      console.log(data);
    }
  });
});
