1- Download the inputTable.txt and epochToDate.sh under the same directory
2- Setup execution privileges: chmod +x epochToDate.sh
3- Usage: ./epochToDate.sh
4- Requires a file called epochTable.txt with the output of your SQL query
5- Expected format of the epochTable.txt

 fileid |    startet    |     endet     |  receipttime  | mineventendtime | maxeventendtime
--------+---------------+---------------+---------------+-----------------+-----------------
  14462 | 1605684111120 | 1605684112222 | 1605684112529 |   1605684111120 |   1605684112222
  14462 | 1605684112227 | 1605684113310 | 1605684113588 |   1605684112227 |   1605684113310
  14462 | 1605684113316 | 1605684113352 | 1605684113588 |   1605684113316 |   1605684113352
(3 rows)

6- Expected output: parsed_file.out

  | fileid |         startet               |           endet               |         receipttime           |        mineventendtime        |       maxeventendtime         |
  +        +                               +                               +                               +                               +                               +
  | 14462  | Tue Nov 17 23:21:51 PST 2020  | Tue Nov 17 23:21:52 PST 2020  | Tue Nov 17 23:21:52 PST 2020  | Tue Nov 17 23:21:51 PST 2020  | Tue Nov 17 23:21:52 PST 2020  |
  +        +                               +                               +                               +                               +                               +
  +        +                               +                               +                               +                               +                               +
  | 14462  | Tue Nov 17 23:21:52 PST 2020  | Tue Nov 17 23:21:53 PST 2020  | Tue Nov 17 23:21:53 PST 2020  | Tue Nov 17 23:21:52 PST 2020  | Tue Nov 17 23:21:53 PST 2020  |
  +        +                               +                               +                               +                               +                               +
  +        +                               +                               +                               +                               +                               +
  | 14462  | Tue Nov 17 23:21:53 PST 2020  | Tue Nov 17 23:21:53 PST 2020  | Tue Nov 17 23:21:53 PST 2020  | Tue Nov 17 23:21:53 PST 2020  | Tue Nov 17 23:21:53 PST 2020  |
  +        +                               +                               +                               +                               +                               +



/opt/local/pgsql/bin/psql rwdb web -c "select fileid,startet,endet,receipttime,mineventendtime,maxeventendtime from data.chunk"
