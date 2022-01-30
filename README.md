# LogWars Agent

Create custom probes by creating a sh file in `/etc/nqnext/probes`.  
Output of script will be ignored except lines prefixed with underscore.  
You will still be able to see the entire output in your probes dashboard.

See default probes in `agent/probes` for reference.

### Installation
Create new server in LogWars and follow instructions.
https://logwars.com

### Reference
#### \_stamp__{id}
- **_level** decides the color and order of the stamps
  - **info** (default)
  - **warn** 
  - **error** 
- **_value** text displayed on the stamp, should be short, might be trimmed
- **_preview** 
  - **true** show stamp on server card in list of servers

#### \_metric__{id}
- **_unit** unit of _value for conversion to human readable
  - **none** (default) this will display value as is
  - **kb** kilobytes
  - **s** seconds
  - **ms** milliseconds
- **_value** numeric value
- **_max** maximum value, used for computing percentages
- **_preview**
  - **true** show metric preview on server card in list of servers


#### \_log__{id}
Short log, may be trimmed. Usable for short list of running services etc.

