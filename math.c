/**
 * Welcome to Seashell!
 */

#include <stdio.h>
#include <assert.h>
#include <math.h>
#include <stdlib.h>
#include <stdbool.h>

int function(int x) {
  return sqrt(abs(x));
}

//graphs function over the domeain x_min to x_max and range from y_min to y_max
void grapher(int x_min, int y_min, int x_max, int y_max) {
  assert(x_min <= x_max && y_min <= y_max);
  int i;
  int j;
  for (j = y_max; j >= y_min; j--) {
    for (i = x_min; i <= x_max; i++) {
      if (function(i)==j) {
        printf("O");
      } else if (i == 0) {
        printf("|");
      } else if (j == 0) {
        printf("_");
      } else {
        printf(" ");
      }
    }
    printf("\n");
  }
}

struct llnode {
	int item;
	struct llnode *next;
};

struct llist {
	struct llnode *first;  // points to first node in the list
	struct llnode *last;   // points to the last node in the list
	int len;
};

// see list.h for documentation
struct llist *create_list(void) {
	struct llist *lst = malloc(sizeof(struct llist));
	lst->first = NULL;
	lst->last = NULL;
	lst->len=0;
 	return lst;
}

// see list.h for documentation
void destroy_list(struct llist *lst) {
	assert(lst);
	struct llnode *current = lst->first; 
	struct llnode *next;
	while (current != NULL) {
		next = current->next; // note the next pointer
		free(current); // delete the node
		current = next; // advance to the next node
	}
	free(lst); 
}


// see list.h for documentation
int list_length(struct llist *lst) {
  	assert(lst);
	return lst->len;
}




// see list.h for documentation
void print_list(struct llist *lst) {
  	assert(lst);
	struct llnode *current;
	for (current = lst->first; current != NULL; current = current->next)
		printf("  %d", current->item);
	printf("\n");
}
	

// see list.h for documentation
void add_first(int n, struct llist *lst) {
  assert(lst);
  struct llnode *new = malloc(sizeof(struct llnode));
  new->item = n;
  new->next = lst->first;
  lst->first = new;
  if (lst->len == 0) {
    lst->last = new;
  }
  ++lst->len;
}

// see list.h for documentation
void add_last(int n, struct llist *lst) {
  assert(lst);
  struct llnode *new = malloc(sizeof(struct llnode));
  new->item = n;
  new->next = NULL;
  if (lst->len == 0) {
    lst->first = new;
  } else {
    lst->last->next = new;
  }
  lst->last = new;
  lst->len++;
}

// see list.h for documentation
int delete_first(struct llist *lst) {
  assert(lst->len>0);
  struct llnode *front = lst->first;
  int val = front->item;
  lst->first = front->next;
  free(front);
  --lst->len;
  if (lst->len == 0) {
    lst->last = NULL;
  }
  return val;
}

// see list.h for documentation
int get_ith(struct llist *lst, int index) {
	assert(index >= 0 && index < lst->len);
  struct llnode *cur = lst->first;
  for(int i = 0; i < index; ++i) {
    cur = cur->next;
  }
  return cur->item;
}

int indivisible(int n, struct llist *lst) {
  int len = lst->len;
  for (int i = 0; i < len; i++) {
    if(n%get_ith(lst, i) == 0) {return 0;}
  }
  return 1;
}

// primes(n) prints the first n prime numbers
void primes(int n) {
  struct llist *myprimes = create_list();
  int cur = 2;
  if (n > 0) {
    printf("%d\n", cur);
    cur++;
    n--;
  }
  while (n > 0) {
    if(indivisible(cur, myprimes)) {
      printf("%d\n", cur);
      n--;
      add_first(cur,myprimes);
    }
    cur += 2;
  }
  destroy_list(myprimes);
}

int main(void) {
  primes(1000); // prints first 1000 prime numbers
  grapher(-30,-10,30,10); // graphs the function sqrt(abs(x))
}
