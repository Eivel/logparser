# LogParser

LogParser is a simple tool for parsing logs. Version 0.1 is dedicated to simple logs that consist of lines in the following format:

[webpage] [ip]

The tool is an effect of practice for TDD development of a clean and readable Ruby application.

## Requirements

- Ruby 2.6.3

## Usage

```bash
$ ./app.rb logfile
```

## Implementation details

Ruby is not the best tool for parsing significant amounts of text data because of its performance.

I used hashes as the main structures for data storage and processing. They provide quick access to their keys and are a native data structure without duplicates. The one downside is code readability, especially in `app/metrics/page_views_for_ip_metric.rb` but for this particular use case, performance is more important.

A careful reader may notice that I also used `sort_by` with `reverse` a lot. To my surprise, the performance is quite good. I used the following [benchmarks](https://stackoverflow.com/a/2651028) as a reference.

For the whole development, I tried to keep to the standard TDD process. I've been more familiar with writing specs along with the features before but must say that TDD helps with the design process much.
