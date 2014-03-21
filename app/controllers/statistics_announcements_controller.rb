class StatisticsAnnouncementsController < PublicFacingController
  def index
    @filter = Frontend::StatisticsAnnouncementsFilter.new(filter_params)
    expire_cache_for_index_on_next_announcement_expiry(@filter.results)
  end

  def show
    @announcement = Frontend::StatisticsAnnouncementProvider.find_by_slug(params[:id])
    if @announcement.nil?
      render text: "Not found", status: :not_found
    elsif @announcement.publication.try :published?
      redirect_to publication_path(@announcement.publication)
    else
      expire_cache_for_show_on_release(@announcement)
    end
  end

private
  def filter_params
    params.slice(:page, :keywords, :from_date, :to_date, :organisations, :topics)
  end

  def expire_cache_for_index_on_next_announcement_expiry(announcements)
    time_to_releases = announcements.map {|ann| ann.release_date - Time.zone.now }.reject {|time_span| time_span <= 0 }
    expires_in((time_to_releases << Whitehall.default_cache_max_age).min)
  end

  def expire_cache_for_show_on_release(announcement)
    times = [ announcement.release_date - Time.zone.now ]
    times << announcement.publication.scheduled_publication - Time.zone.now if announcement.publication.present? && announcement.publication.scheduled_publication.present?
    times << Whitehall.default_cache_max_age
    times.reject! { |time_span| time_span <= 0 }
    expires_in(times.min)
  end
end