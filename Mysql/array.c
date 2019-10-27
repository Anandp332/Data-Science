#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ostream stdout
#define istream stdin
#define estream stderr

void exitaftershamingtheuser()
{
   fprintf (estream, "arrrgh - an error, it seems your damn computer has run out of memory\n");
   fprintf (estream, "first go and add few more gigabytes of memory to your pc.\n");
   fprintf (estream, "shame on you, for running this great program with such low memory.\n");
   exit(1);
}

typedef struct dtuple dtuple;

struct dtuple {
  char *word;
  char **meanings;
  int len;
};

void display(dtuple *p, int n)
{
 int i,j;
 for (i = 0; i < n; ++i)
 {
   fprintf (ostream, "\n%d...\n",i);
   fprintf (ostream, "%s - %d:\t", p[i].word, p[i].len);
   for (j = 0; j < p[i].len; ++j)
     fprintf (ostream, "%s, ", p[i].meanings[j]);
 }
}
/* sample use of array */
int main(int argc, char **argv)
{
 int n,tn,i,j,cnt;
 char buf[256];
 dtuple *p;
 fprintf (ostream, "enter number of records -");
 fscanf  (istream, "%d", &n);
 if(p = (dtuple *) malloc(sizeof(dtuple)*n) == NULL) exitaftershamingtheuser();
 fprintf (ostream, "now enter the records one by one -\n");
 for (i = 0; i < n; ++i)
 {
   fprintf (ostream, " word - ");
   fscanf  (istream, "%s", buf);
   if(p[i].word = (char *) malloc(sizeof(char)*strlen(buf)) == NULL) exitaftershamingtheuser();
   strcpy(p[i].word, buf);
   fprintf (ostream, " number of meanings - ");
   fscanf  (istream, "%d", &tn);
   p[i].len = tn;
   if(p[i].meanings = (char **) malloc(sizeof(char*)*tn) == NULL) exitaftershamingtheuser();
   for (j = 0; j < tn; ++j)
   {
     fprintf (ostream, "meaning number %d - ", j+1);
     fscanf  (istream, "%s", buf);
     if(p[i].meanings[j] = (char *) malloc(sizeof(char)*strlen(buf)) == NULL) exitaftershamingtheuser();
     strcpy(p[i].meanings[j], buf);
   }
   fprintf (ostream, "Successful...\n");
   display(p, n);
   fprintf (ostream, "Successful...\n");
 return 0;
}
}

