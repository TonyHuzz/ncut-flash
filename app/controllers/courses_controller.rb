class CoursesController < ApplicationController
    layout 'admin/layouts/admin'

    def index
        @courses = Course.is_published.order("id") #搜尋 :status = 1 的情境

        @deleted_courses = Course.is_hidden  #搜尋 :status = 0 的情境
    end

    def create
        course = Course.create({
                                   name: params[:name],
                                   inserted_at: Time.zone.now,
                               })
        if course.valid?
            dir_url = Rails.root.join("public", "data/#{course.id}")
            FileUtils.mkdir_p(dir_url) unless File.directory?(dir_url)  #新增情境時在public/data資料夾底下新增資料夾
            redirect_to action: :index
            return
        end
    end

    def update
        course = Course.find(params[:id])
        course.update({
                          status: 1  #將 status 設回1
                      })
        redirect_to action: :index
        return
    end

    def destroy
        course = Course.find(params[:id])
        course.update({
                           status: 0    #刪除並不是真的刪掉，而是把 status 改成0
                       })
        redirect_to action: :index
        return
    end

end
