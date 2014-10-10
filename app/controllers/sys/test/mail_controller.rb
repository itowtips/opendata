class Sys::Test::MailController < ApplicationController
  include Sys::BaseFilter
  include Sys::CrudFilter

  menu_view "sys/test/menu"

  private
    def set_crumbs
      @crumbs << ["MAIL Test", sys_test_mail_path]
    end

    def permit_fields
      [:to, :subject, :body]
    end

  public
    def index
      raise "403" unless Sys::User.allowed?(:edit, @cur_user)

      @item = OpenStruct.new to: @cur_user.email, subject: "TEST MAIL", body: ""
    end

    def create
      @item = OpenStruct.new to: "", subject: "", body: ""

      prm = get_params
      @item.to      = prm[:to]
      @item.subject = prm[:subject]
      @item.body    = prm[:body]

      if @item.to.present? && @item.subject.present? && @item.body.present?
        Sys::Mailer.test_mail(to: @item.to, subject: @item.subject, body: @item.body).deliver
        redirect_to({ action: :index }, { notice: "Sent." })
      else
        render action: :index
      end
    end
end
