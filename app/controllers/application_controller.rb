class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  def test
    render json: { hello: 'world' }, status: :ok
  end

  def file
    case params[:type]
      when 'created'
        download_file
      when 'updated'
        File.open("files/#{params[:path]}", "w") {}
        download_file
      when 'deleted'
        delete_file
    end
    render json: {}, status: :ok
  end

  def download_file
    File.open('files/pipe.msg', "w+") do |f|
      f.write('0')
    end
    path = "files/#{params[:path]}"
    File.open(path, 'wb') { |f| f.write(params[:file].read) }
    File.open('files/pipe.msg', 'w+') do |f|
      f.write('1')
    end
  end

  def delete_file
    File.open('files/pipe.msg', 'w+') do |f|
      f.write('0')
    end
    File.delete("files/#{params[:path]}")
    File.open('files/pipe.msg', 'w+') do |f|
      f.write('1')
    end
  end
end
