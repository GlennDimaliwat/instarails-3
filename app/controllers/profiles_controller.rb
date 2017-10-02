class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy] # Still allow users to see page if not signed in except for edit, update, delete
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    redirect_to edit_profile_url if @profile.nil?
  end

  # GET /profiles/1/edit
  def edit
    # Perform new profile creation if it doesn't exist. Otherwise, edits the profile
    # @profile = Profile.find_or_initialize_by(user: current_user)

    # Have blank profile if the user hasn't created one yet for their account
    @profile = Profile.new(user: current_user) if @profile.nil?
  end

  # POST /profiles
  # POST /profiles.json
  def create
    @profile = Profile.new(profile_params)
    @profile.user = current_user

    respond_to do |format|
      if @profile.save
        format.html { redirect_to @profile, notice: 'Profile was successfully created.' }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1
  # PATCH/PUT /profiles/1.json
  def update
    respond_to do |format|

      # User performs follow / unfollow
      if performing_follow?
        @profile.user.toggle_followed_by(current_user)
        format.html { redirect_to @profile.user }
        format.json { render :show, status: :ok, location: @profile }

      # One does not simply edit the profile of another user
      elsif @profile.nil? || @profile.user != current_user
        redirect_to root_url

      # User updates his profile
      elsif @profile.update(profile_params)
        format.html { redirect_to profile_path, notice: 'Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @profile }

      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    @profile.destroy
    respond_to do |format|
      format.html { redirect_to profiles_url, notice: 'Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      # Looking at someone else’s profile
      if params[:id]
        # @profile = Profile.find(params[:id])
        @profile = Profile.find_by!(user_id: params[:id])
      # Current user’s profile
      else
        @profile = Profile.find_by(user: current_user)
        # @profile = Profile.find_by!(user: current_user)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def profile_params
      params.require(:profile).permit(:username, :name, :bio)
    end

    def performing_follow?
      # params.require(:user)[:follow].present?
      # if params[:user]
      #   params.require(:user)[:follow].present?
      # else
      #   params.require(:profile)[:follow].present?
      # end

      # params[:user] ? params.require(:user)[:follow].present? : params.require(:profile)[:follow].present?
      # params.require( params[:user] ? :user : :profile )[:toggle_follow].present?
      params.dig(:user, :toggle_follow).present?
    end
end
