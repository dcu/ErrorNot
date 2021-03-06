class UsersController < ApplicationController

  before_filter :authenticate_user!, :only => [:edit, :update, :destroy]

  def new
    @user = User.new
    @user.email = params[:email]
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = t('devise.confirmations.send_instructions')
      redirect_to(new_user_session_url)
    else
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    # Could be splitted in two actions
    method = params[:user][:password] ? :update_with_password : :update_attributes
    if @user.send(method, params[:user])
      flash[:notice] = t('flash.users.update.success') #'Updated successfully'
      redirect_to root_path
    else
      render :edit
    end
  end

  def update_notify
    current_user.update_notify(:email => params[:notify_by_email],
                               :removal => params[:notify_removal_by_email],
                               :digest => params[:notify_by_digest])
    flash[:notify_me] = t('flash.users.update.success_update_notify')
    redirect_to(edit_user_path)
  end

  def destroy
    current_user.destroy
    sign_out current_user
    flash[:notice] = t('flash.users.destroy.notice', :default => 'User was successfully destroyed.')
    redirect_to root_path
  end
end
