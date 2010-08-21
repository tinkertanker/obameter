class PromisesController < ApplicationController

  # GET /promises
  # GET /promises.xml
  def index
    @people = Person.find(:all)

    for person in @people
      person.promises_kept = Promise.find(:all, :conditions => ["person_id = ? and implementation_date IS NOT NULL", person.id])
      person.promises_broken = Promise.find(:all, :conditions => ["person_id = ? and implementation_date is NULL and expiry_date < ?", person.id, DateTime.now.new_offset()])
      person.promises_in_the_works = Promise.find(:all, :conditions => ["person_id = ? and implementation_date is NULL and expiry_date > ?", person.id, DateTime.now.new_offset()])
      person.latest_closed_promises = Promise.find(:all, :conditions => ["person_id = ? and (expiry_date < ? OR implementation_date IS NOT NULL)", person.id, DateTime.now.new_offset()], :order => "created_at DESC", :limit => 5) 
    end
  end

  # GET /promise/mark_complete
  # GET /promise/mark_complete.xml
  def mark_complete
    if params[:id]
      @promise = Promise.find_by_id(params[:id])
      if @promise
        @promise.implementation_date = DateTime.now
      end
    end

    respond_to do |format|
      if @promise.save
        flash[:notice] = 'Promise has been marked complete.'
        format.html { redirect_to(:action => "index") }
        format.xml  { render :xml => @promise, :status => :created, :location => @promise }
      else
        flash[:notice] = 'There was a problem marking the promise complete.'
        format.html { redirect_to(:action => "index") }
        format.xml  { render :xml => 'There was an error here', :status => :unprocessable_entity }
      end
    end
  end

  def create_reminder
    @people = Person.find(:all)

    for person in @people
      if !person.e_mail.nil?

        person.promises_in_the_works = Promise.find(:all, :conditions => ["person_id = ? and implementation_date is NULL and expiry_date > ?", person.id, DateTime.now.new_offset()])
        person.promises_close_to_expiry = Promise.find(:all, :conditions => ["person_id = ? and implementation_date is NULL and expiry_date > ? and expiry_date < ?", person.id, DateTime.now.new_offset(), DateTime.now.new_offset()+1])

        if person.promises_in_the_works.size == 0 and (DateTime.now.wday == 5)
          email = ReminderMailer.create_remind_no_promise(person)
          ReminderMailer.deliver(email)
        elsif  person.promises_close_to_expiry.size > 0
          email = ReminderMailer.create_remind(person)
          ReminderMailer.deliver(email)
        end

      end
    end

    if email
      render(:text => "<pre>"+email.encoded+"</pre>")
    else
      render(:text => "<pre>No email sent</pre>")
    end

  end

  # GET /promises/list
  # GET /promises/list.xml
  def list
    @promises = Promise.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @promises }
    end
  end

  # GET /promises/1
  # GET /promises/1.xml
  def show
    @promise = Promise.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @promise }
    end
  end

  # GET /promises/new
  # GET /promises/new.xml
  def new
    if params[:id]
      @person = Person.find_by_id(params[:id])
      if @person
        @promise = Promise.new
        @promise.person_id = @person.id
      end
    end

    respond_to do |format|
      if @promise
        format.html # new.html.erb
        format.xml  { render :xml => @promise }
      else 
        flash[:notice] = 'You probably got here by accident. We don\'t know who is the promissor.'
        format.html { redirect_to(:action => 'index') }
        format.xml  { render :xml => 'You got here by accident', :status => :unprocessable_entity }
      end
    end
  end

  # GET /promises/1/edit
  def edit
    @promise = Promise.find(params[:id])
  end

  # POST /promises
  # POST /promises.xml
  def create
   
    end_of_day = DateTime.civil(params[:date][:year].to_i,params[:date][:month].to_i,params[:date][:day].to_i,15,59,59)
    params[:promise][:expiry_date] = end_of_day.new_offset(DateTime.now.offset())

    @promise = Promise.new(params[:promise])

    respond_to do |format|
      if @promise.save
        flash[:notice] = 'Promise was successfully created.'
        format.html { redirect_to(:action => "index") }
        format.xml  { render :xml => @promise, :status => :created, :location => @promise }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @promise.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /promises/1
  # PUT /promises/1.xml
  def update
    @promise = Promise.find(params[:id])

    respond_to do |format|
      if @promise.update_attributes(params[:promise])
        flash[:notice] = 'Promise was successfully updated.'
        format.html { redirect_to(:action => "index") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @promise.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /promises/1
  # DELETE /promises/1.xml
  def destroy
    @promise = Promise.find(params[:id])
    @promise.destroy

    respond_to do |format|
      format.html { redirect_to(promises_url) }
      format.xml  { head :ok }
    end
  end

end
