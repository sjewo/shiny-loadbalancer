shiny-loadbalancer
==================

Shiny App for Load Balancing using a completely fair (random) scheduler. 
This shiny apps redirects at random to a shiny app sharing the same basename.

Example
-------

If the app folder for the load balancer is "histogram",  the users will be redirected to one of the folders "histogram_1", "histogram_2", ... which contain the usable app.
