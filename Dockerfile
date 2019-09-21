ARG RUBY_VERSION

FROM ruby:$RUBY_VERSION-stretch

ARG LOCAL_BUILD

ENV BUNDLE_JOBS=4 BUNDLE_PATH=/vendor/bundle/$RUBY_VERSION LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN gem install bundler

RUN useradd --create-home --user-group --uid 1000 appuser
RUN mkdir -p /appuser/gather-vdot $BUNDLE_PATH
RUN chown -R appuser /appuser /vendor

WORKDIR /appuser/gather-vdot

USER appuser

COPY --chown=appuser Gemfile Gemfile.lock ./

RUN if [ -z "$LOCAL_BUILD" ]; then \
  bundle install --frozen --without development test \
  ;fi

COPY --chown=appuser . .
