# OffersHelper

## Continents grouping

```
$ mix run scripts/group_offers.exs
```
Output example:
```
%{
  "Africa" => %{
    "Admin" => 1,
    "Business" => 3,
    "Marketing / Comm'" => 1,
    "Retail" => 1,
    "Tech" => 3
  }
}
```

## Scaling
If we would have 100 000 000 job offers in our database, and 1000 new job offers per second, 
it would be reasonably to predefine offer continent and save it to database along with other properties 
so we don't have to define it for every row in real-time.

Also it's not pointless to split this database into partitions by the most normally distributed property like profession_id,
so we will write to physically different tables and there will be reduced load on each.

## API implementation
Run server:
```
mix run --no-halt
```
Go to localhost:4000/offers with example parameters: [Example](http://localhost:4000/offers?latitude=48.8659387&longitude=2.34532&radius=10)

The response will be a list of job offers, sorted by closeness to request coordinates.

Example response:
```
[
    {
        "office_longitude":"2.3432057",
        "office_latitude":"48.8660458",
        "name":"Consultant(e) Transformation Digitale Junior ",
        "distance":0.16,
        "contract_type":"FULL_TIME",
        "category":"Conseil"
    }
]
```