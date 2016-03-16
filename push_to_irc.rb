#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Copyright (C) 2016 Harald Sitter <sitter@kde.org>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) version 3, or any
# later version accepted by the membership of KDE e.V. (or its
# successor approved by the membership of KDE e.V.), which shall
# act as a proxy defined in Section 6 of version 3 of the license.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library.  If not, see <http://www.gnu.org/licenses/>.

require 'cinch'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = 'irc.freenode.org'
    c.nick = 'pangea-monitor'
  end

  on :connect do |m|
    to, subject, _body = ARGV
    default_channels = m.bot.config.channels || []
    ([to] + default_channels).each do |channel|
      m.bot.join(channel)
      if subject
        Channel(channel)
          .send(subject)
      else
        Channel(channel)
          .send("Received no subject in ARGV: #{ARGV.inspect}")
      end
    end
    bot.quit
  end
end

bot.start
