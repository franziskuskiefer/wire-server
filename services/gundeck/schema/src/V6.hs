-- This file is part of the Wire Server implementation.
--
-- Copyright (C) 2020 Wire Swiss GmbH <opensource@wire.com>
--
-- This program is free software: you can redistribute it and/or modify it under
-- the terms of the GNU Affero General Public License as published by the Free
-- Software Foundation, either version 3 of the License, or (at your option) any
-- later version.
--
-- This program is distributed in the hope that it will be useful, but WITHOUT
-- ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
-- FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
-- details.
--
-- You should have received a copy of the GNU Affero General Public License along
-- with this program. If not, see <https://www.gnu.org/licenses/>.

module V6
  ( migration,
  )
where

import Cassandra.Schema
import Imports
import Text.RawString.QQ

migration :: Migration
migration = Migration 6 "Add fallback_cancel table" $ do
  schema'
    [r|
        -- Column family for keeping track of cancelled
        -- fallback notifications.
        create columnfamily if not exists fallback_cancel
            ( user uuid     -- user id
            , id   timeuuid -- notification id
            , primary key (user, id)
            ) with compaction = { 'class' : 'LeveledCompactionStrategy' }
               and gc_grace_seconds = 0;
        |]

-- TODO: fallback is deprecated as of https://github.com/wireapp/wire-server/pull/531
