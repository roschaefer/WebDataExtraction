Good news first:

-> Everything runs on Michael's machine in a single batch job!
A sample output of the overall extraction can be found in \sample_output\integrated_data.html

Now the "bad news"...

Running and integrating the wrappers into a batch job is highly platform-dependant.

The following things are required:
- Java >= 6
- Oxpath (and probably xulrunner, as explained in the oxpath documentation)
- ruby (and the gem mechanize)
- some xslt processor, preferrably saxon9

Moreover, there are certain ugly hacks needed.
For example, oxpath produces strange strings before the actual <?xml... code.
They have to be stripped somehow, etc.

To get an idea of what is going on, I added my (dirty) .bat script.

BUT THIS SCRIPT WILL CERTAINLY NOT WORK ON ANY OTHER MACHINE OUT OF THE BOX!

The sample_output folder is just there to test the xslt stylesheet.