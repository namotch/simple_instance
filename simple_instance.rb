# -*- coding: utf-8 -*-

Plugin.create :simple_instance do

  # 設定画面
  settings _("インスタンス形式") do
    settings _("インスタンスの表示形式") do
      select("", :simple_instance) do
        option 0, _("@social.mikutter.hachune.net（デフォルト)")
        option 1, _("@s25t")
        option 2, _("@s4l.m6r.h5e.n1t")
        option 3, _("@s.m.h.n")
      end
    end
  end
end

class ::Gdk::MiraclePainter

  def header_left_markup
    user = message.user
    if user.respond_to?(:idname)
      Pango.parse_markup("<b>#{Pango.escape(instance(user.idname, UserConfig[:simple_instance]))}</b> #{Pango.escape(user.name || '')}")
    else
      Pango.parse_markup(Pango.escape(user.name || ''))
    end
  end

  # インスタンス表示形式
  def instance(user, instance_id = 0)
    idname = user.split("@")
    if idname[1].nil?
      #インスタンスがないもの
      user
    else
      instance = idname[1]
      case instance_id
      when 1 then
        # @s25t
        idname[0] << "@" << s25t(instance)
      when 2 then
        # @s4l.m6r.h5e.n1t
        idname[0] << "@" << instance.split('.').collect{|s| s25t(s)}.join('.')
      when 3 then
        # @s.m.h.n
        idname[0] << "@" << instance.split('.').collect{|s| s[0,1]}.join('.')
      else
        # @social.mikutter.hachune.net
        user
      end
    end
  end

  # 表示形式共通処理
  def s25t(domain)
    # 文字列の間を数値にかえる
    domain[0,1] << (domain.size - 2).to_s << domain[-1, 1]
  end
end
