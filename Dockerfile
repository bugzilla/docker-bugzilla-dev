# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.

FROM bugzilla/bugzilla-ci
MAINTAINER David Lawrence <dkl@mozilla.com>

# Distribution package installation
COPY conf/rpm_list /
RUN yum -y -q install `cat /rpm_list` && yum clean all

# Sudoers setup
COPY conf/sudoers /etc/sudoers
RUN chown root.root /etc/sudoers && chmod 440 /etc/sudoers

# Supervisor setup
COPY conf/supervisord.conf /etc/supervisord.conf
RUN chmod 700 /etc/supervisord.conf

# Copy setup scripts
COPY scripts/* /usr/local/bin/
RUN chmod 755 /usr/local/bin/*

# Development environment setup
RUN git clone $GITHUB_BASE_GIT --single-branch --depth 1 --branch $GITHUB_BASE_BRANCH $BUGZILLA_WWW \
    && ln -sf $BUGZILLA_LIB $BUGZILLA_WWW/local
COPY conf/checksetup_answers.txt $BUGZILLA_WWW/checksetup_answers.txt
RUN bugzilla_config.sh
RUN su - $BUGZILLA_USER -c dev_config.sh

RUN chown -R $BUGZILLA_USER.$BUGZILLA_USER $BUGZILLA_WWW /home/$BUGZILLA_USER

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
