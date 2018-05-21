module BootstrapFlashHelper
  def bootstrap_flash
    capture do
      flash.each do |type, messages|
        bootstrap_alerts_for_type(bootstrap_flash_type(type), messages)
      end
    end
  end

  def bootstrap_alerts_for_type(type, messages)
    return if type.blank?
    Array(messages).each do |msg|
      alert_body = simple_format(msg, {}, wrapper_tag: 'span')
      concat send("bootstrap_#{type}_alert") { alert_body }
    end
  end

  def bootstrap_flash_type(type)
    { notice: :success, alert: :warning, error: :danger }[type.to_sym]
  end

  def bootstrap_alert(css_class, alert)
    content_tag('div', class: "alert alert-#{css_class}", role: 'alert') do
      concat bootstrap_alert_close_button
      concat content_tag('strong', alert)
      concat(capture { yield })
    end
  end

  def bootstrap_alert_close_button
    span = content_tag('span', '×', aria: { hidden: true })
    button_tag(span, class: 'close', data: { dismiss: 'alert' },
               aria: { label: 'Close' })
  end

  def bootstrap_success_alert
    bootstrap_alert('success', 'Success! ') { yield }
  end

  def bootstrap_info_alert
    bootstrap_alert('info', 'Hint: ') { yield }
  end

  def bootstrap_warning_alert
    bootstrap_alert('warning', 'Warning: ') { yield }
  end

  def bootstrap_danger_alert
    bootstrap_alert('danger', 'Error: ') { yield }
  end
end
