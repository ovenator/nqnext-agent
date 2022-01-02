# NQNext Agent

Create custom probes by creating a sh file in `/etc/nqnext/probes`.  
Output of script will be ignored except lines prefixed with underscore.  
You will still be able to see the entire output in your probes dashboard.

See default probes in `agent/probes` for reference.

### Reference
#### \_stamp__{id}
- **_level** decides the color and order of the stamps
  - **info** (default)
  - **warn** 
  - **error** 
- **_value** text displayed on the stamp, should be short, might be trimmed

#### \_metric__{id}
- **_unit** the unit of _value, so it might be converted to human readable value
  - **none** (default) this will display value as is
  - **kb** kilobytes
  - **s** seconds
  - **ms** milliseconds
- **_value** numeric value
- **_max** maximum value, used for computing percentages


#### \_log__{id}
Short log, may be trimmed. Usable for short list of running services etc.


#### \_disk__{id}
This is a shortcut to collect metrics on disks