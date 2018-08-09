/*
 * Copyright (C) 2017 - present Instructure, Inc.
 *
 * This file is part of Canvas.
 *
 * Canvas is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, version 3 of the License.
 *
 * Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Affero General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

// translate a strftime style format string into a datepicker style format string
// Examples:
// %a %b %-d, %Y %-l:%M%P
// %a %b %-d, %Y %-k:%M
// %b %-d, %Y
import tz from 'timezone'

export default function datePickerFormat (format) {
  return tz.adjustFormat(format)
    .replace(/%y/, 'y') // Year (two digit, eg. 17)
    .replace(/%Y/, 'yy') // Year (four digit, eg. 2017)
    .replace(/%b/, 'M') // Month name (short, eg. May)
    .replace(/%B/, 'MM') // Month name (long, eg. January)
    .replace(/%-m/, 'm') // Month of year (no leading zero)
    .replace(/%m/, 'mm') // Month of year (two digit)
    .replace(/%-d/, 'd') // Day of month (no leading zero)
    .replace(/%d/, 'dd') // Day of Month (two digit)
    .replace(/%a/, 'D') // Day of week (short, eg. Wed)
    .replace(/%A/, 'DD') // Day of week (long, eg. Wednesday)
    .replace(/%-?[lk]|:|%M|%P/g, '') // Remove time info*
    .trim()
  // *Time info removed because it's already added by the datetime picker
}
