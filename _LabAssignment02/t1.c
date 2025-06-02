#include <stdio.h>
struct MenuItem {
    int quantity;
    float price_per_unit;
};

float calculateTotalBill(struct MenuItem paratha, struct MenuItem vegetable, struct MenuItem water) {
    float total = (paratha.quantity * paratha.price_per_unit) +
                  (vegetable.quantity * vegetable.price_per_unit) +
                  (water.quantity * water.price_per_unit);
    return total;
}


float calculateIndividualShare(float total_bill, int num_people) {
    return total_bill / num_people;
}

int main() {
    struct MenuItem paratha, vegetable, water;
    int num_people;

  
    printf("Enter quantity of Paratha: ");
    scanf("%d", &paratha.quantity);
    printf("Enter unit price of Paratha: ");
    scanf("%f", &paratha.price_per_unit);

    
    printf("Enter quantity of Vegetable: ");
    scanf("%d", &vegetable.quantity);
    printf("Enter unit price of Vegetable: ");
    scanf("%f", &vegetable.price_per_unit);

    
    printf("Enter quantity of Mineral Water: ");
    scanf("%d", &water.quantity);
    printf("Enter unit price of Mineral Water: ");
    scanf("%f", &water.price_per_unit);

   
    printf("Enter the number of people: ");
    scanf("%d", &num_people);

    
    float total_bill = calculateTotalBill(paratha, vegetable, water);
    float share_per_person = calculateIndividualShare(total_bill, num_people);

    
    printf("Each person should pay: %.2f tk\n", share_per_person);

    return 0;
}
