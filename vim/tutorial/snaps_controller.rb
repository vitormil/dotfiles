class SnapsController < ApplicationController
  
  def show
    render :text => "Hello, world #{Time.now}"
  end
  
  ##
  # Post to this with:
  #
  #   resp = RestClient.post("http://localhost:3000/snap.xml",
  #                          :source_id    => "32",
  #                          :url          => "http://peepcode.com", 
  #                          :callback_url => "http://localhost:3000/callback.xml")
  
  def create
    @snap = Snap.add_job(params[:url], params[:callback_url], params[:source_id])

    respond_to do |format|
      if @snap
        format.xml  { render :xml => @snap, :status => :created } # :location => @snap
      else
        format.xml  { render :xml => @snap.errors, :status => :unprocessable_entity }
      end
    end
  end

end
