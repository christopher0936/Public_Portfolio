For Task 1, the program runs as expected and matches the output format of the PDF exactly. In the event of a tiebreaker decision, where a new task arrives during the same tick in which a task that has been processing is returned to the ready queue, the program favours the arriving application over the task being suspended.

Task 2 is also fully completed, with both graphs included in the repository. I completed Task 2 by creating a python script that employs matplotlib and the defauly python subprocess library to call simgen to randomly generate a dataset and then rrsim to simulate it. The resulting output is then filtered and the relevant numbers extracted, averaged, and plotted via matplotlib directly to PDFs.