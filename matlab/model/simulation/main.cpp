#include <iostream>
#include <vector>
#include <random>
#include <chrono>
#include <string>

int randomInteger(int min, int max) {
    return min + (rand() % static_cast<int>(max - min + 1));
};

class Person {
public:
    std::vector<int> infectSchedule;
    int index = 0;
    int infectionDay = 0;
    int deathDay = 0;
    int removalDay = 0;
//    std::default_random_engine generator;
    unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();


    Person(int day, double R, int infecter, int idx) {

        index = idx;
        std::default_random_engine generator(seed);

        int period = 10;
        std::poisson_distribution<int> distribution(R);
        infectionDay = day;
        removalDay = day+period+1+randomInteger(-2,2);
        deathDay = day+20+randomInteger(-2,2);

        int nInfections = distribution(generator);
//        int nInfections = 2;

//        infectSchedule.push_back(day + 1);
//        infectSchedule.push_back(day + 1);
        for (int i = 0; i<nInfections; i++) {
            int dayToInfect = randomInteger(2,10);
            infectSchedule.push_back(day + dayToInfect);
        }

        std::string infectScheduleString = "";
        for (int id: infectSchedule) {
            infectScheduleString += (" " + std::to_string(id));
        }
//        std::cout << day << ": person " << idx << " infected by " << infecter << ", infects" << " " <<  nInfections << " on days" << infectScheduleString << std::endl;//" " <<  removalDay << " " <<  deathDay << std::endl;
//        std::cout << "" << infectScheduleString << std::endl;

    }
};

int main() {
//    std::cout << "Hello, World!" << std::endl;

    int index = 0;
    double R0 = 3.0;

//    std::default_random_engine generator;
//    std::poisson_distribution<int> distribution(R0);
//    for (int day=1; day<50; day++) {
//        std::cout << "......" << " " << distribution(generator) << std::endl;
//    }

    std::vector<Person> infecteds;
    std::vector<int> nInfecteds;

    std::cout << "DAY .... : " << 0 << std::endl;
    Person patientZero(0, R0, -1, index);
    std::cout << "adding person " << index << std::endl;
    index++;
    infecteds.push_back(patientZero);

    for (int day=1; day<60; day++) {

        nInfecteds.push_back(infecteds.size());

        std::cout << "DAY .... : " << day << " infected: " << infecteds.size() << " " << index << std::endl;

        for(int ip = 0; ip<infecteds.size(); ip++) {

            Person infected = infecteds[ip];
//            int dayToInfect = infected.infectionDay + find(infected.infectSchedule);
//            int nToInfect = infected.infectSchedule(find(infected.infectSchedule));

//            std::cout << "person" << infected.index << " found" << std::endl;

            for(int daysToInfectDay: infected.infectSchedule) {
                if (day == daysToInfectDay) {
                    Person newInfected(day, R0, infected.index, index);
//                    std::cout << "adding person " << index << std::endl;
                    index++;
                    infecteds.push_back(newInfected);
                }
            }

            if(day == infected.removalDay) {
                infecteds.erase(infecteds.begin() + infected.index);
            }
        }
    }

    std::cout << "........" << " " << infecteds.size() << std::endl;

    return 0;
}
