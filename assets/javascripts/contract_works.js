// # plugins/redmine_auto_report/assets/javascripts/contract_works.js
$(document).ready(function() {
    var selectedWorks = [];

    $('.contract-works').on('click', 'tr.work', function(e) {
        if ($(e.target).is('a') || $(e.target).closest('a').length) return;

        $(this).toggleClass('selected');
        var workId = $(this).data('id');

        var index = selectedWorks.indexOf(workId);
        if (index === -1) {
            selectedWorks.push(workId);
        } else {
            selectedWorks.splice(index, 1);
        }

        updateButtons();
    });

    function updateButtons() {
        if (selectedWorks.length >= 2) {
            $('.merge-hours').show();
            $('.unmerge-hours').hide();
        } else if (selectedWorks.length === 1) {
            $('.merge-hours').hide();
            var $work = $('.work[data-id="' + selectedWorks[0] + '"]');
            $('.unmerge-hours').toggle($work.hasClass('merged'));
        } else {
            $('.merge-hours').hide();
            $('.unmerge-hours').hide();
        }
    }

    $('.merge-hours').click(function(e) {
        e.preventDefault();
        $.post($(this).data('url'), { work_ids: selectedWorks });
    });

    $('.unmerge-hours').click(function(e) {
        e.preventDefault();
        $.post($(this).data('url'), { work_id: selectedWorks[0] });
    });
});