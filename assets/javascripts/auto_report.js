$(function() {
    console.log('Auto Report JS loaded');

    // Обработка клика по кнопке отмены
    $(document).on('click', '.js-cancel-form', function(e) {
        e.preventDefault();
        var $form = $(this).closest('form');

        if ($form.attr('id').startsWith('edit-work-form')) {
            // Для формы редактирования - восстанавливаем строку таблицы
            var workId = $form.attr('id').replace('edit-work-form-', '');
            $.get(window.location.pathname, function(data) {
                var $row = $(data).find('#work-' + workId);
                $form.closest('tr').replaceWith($row);
            });
        } else {
            // Для новой формы - просто удаляем форму
            $form.closest('#work-form').remove();
        }
    });

    // Сортировка
    var sortableOptions = {
        update: function(event, ui) {
            console.log('Sortable update triggered');
            var url = $(this).data('url');
            var data = $(this).sortable('serialize');

            $.ajax({
                url: url,
                type: 'post',
                data: data,
                dataType: 'script'
            }).fail(function(jqXHR, textStatus, errorThrown) {
                console.error('Sort failed:', errorThrown);
            });
        }
    };

    $('.contract-works tbody.sortable').sortable(sortableOptions);
});