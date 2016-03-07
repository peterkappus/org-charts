# org-charts
Some tools to make dynamic org charts with D3.

## Hosting locally

Fire up the simple python server to serve the pages (you'll need to be serving via http and not the local file system so you can fetch data, external libs, etc)

```
python -m SimpleHTTPServer 8000
```

## Generating the data.json file

```
$ ruby csv_to_flare.rb > data.json
```
