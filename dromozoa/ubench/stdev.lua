-- Copyright (C) 2015,2017 Tomoyuki Fujimori <moyu@dromozoa.com>
--
-- This file is part of dromozoa-ubench.
--
-- dromozoa-ubench is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- dromozoa-ubench is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with dromozoa-ubench.  If not, see <http://www.gnu.org/licenses/>.

local translate_range = require "dromozoa.commons.translate_range"

local function average(data, i, j)
  local u = 0
  for i = i, j do
    u = u + data[i]
  end
  return u / (j - i + 1)
end

local function stdev(data, i, j, n)
  local a = average(data, i, j)
  local u = 0
  for i = i, j do
    local v = data[i] - a
    u = u + v * v
  end
  return (u / n) ^ 0.5, a
end

local class = {}

-- sample
function class.s(data, i, j)
  local min, max = translate_range(#data, i, j)
  return stdev(data, min, max, max - min)
end

-- population
function class.p(data, i, j)
  local min, max = translate_range(#data, i, j)
  return stdev(data, min, max, max - min + 1)
end

return setmetatable(class, {
  __call = function (_, data, i, j)
    return class.s(data, i, j)
  end;
})
