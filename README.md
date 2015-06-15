# Lazy log backup

I'm lazy to make backups. Logs are usually most crucial thing when investigating what went wrong.
This scripts is lazy man solution to log collection.

All you need is rsync and SSH public keys set on target machines.
One can easily define multiple target machines, logs and rotation intervals.
Note that rotation here means changing destination folder.

## Usage

This usage information might change. For up to date usage please do:

    lazy.sh --help


Current options:

    Usage: lazy.sh [options]
        -d|--default  Default logs
                         syslog
                         messages
                         auth
                         nginx
        -l|--log      Log file to fetch
        -s|--server   Server to connect
        -r|--rotate   Rotate interval
                         always
                         minutely
                         hourly
                         daily
                         weekly
                         monthly
        -t|--target   Target folder
                      Default: current


## Examples

    lazy.sh --default -s my.com -s www.other.net -s root@123.56.44.77 --target /store/logs --rotate always

    lazy.sh --log syslog --log auth -s my.com -s www.other.net -s root@123.56.44.77 --target /store/logs --rotate minutely


## License

MIT, see COPYING
