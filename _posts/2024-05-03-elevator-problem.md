---
layout: post
title: "The Elevator Problem"
keywords: "algorithms"
tags:
    - nerd
---

![img](http://www.batesville.k12.in.us/physics/phynet/mechanics/newton2/Images/Elevator1.GIF)

Like the start of every problem let us assume two totally absurd things
- You want to build elevators that can talk throught a central server?!
- There are weighing machines inside the elevators?!

Now these elevators work and are designed like a normal ones (i promise). People request it to their floor along with the direction they want to go in and use the buttons inside to take it to the floor that they want to go, we can also assume that if the lift is going in a direction it will finish all the stops in that direction before heading in the other direction.

Neat.

Let us consider this scenario

- You are in floor 5 and want to go down
- Lift 1 is in floor 8 and is idle i.e it has to come 3 floors down to pick
- Lift 2 is in floor 2 and has stops in floor 3 and 4 before it picks you up

If we want to **optimise on the time** then the best choice here would be to get the Lift 1 cause even tho it has to cover one floor more it does not have any stops in between

Let us consider a variation of the earlier scenario

- You are in floor 5 and want to go down
- Lift 1 is in floor 7 and has 15 people heading to floor 0
- Lift 2 is in floor 8 and is idle

If we want to **optimise on space** then the best choice here would be to get the Lift 2 cause even tho lift 1 can reach sooner it would surely be crunched for space

Now these two elevators can publish their status to a central server that they also subscribe to make these optimisation choices

- Total weight of the number of people in the elevator
- Direction of movement if there is movement
- All the current stops while going up & going down if there are stops

As the philosophical plebs say, like literally everything in life an elevator has two sides, one is inside and the other is outside

A request can be sent to the elevator from the outside and the central server depending on the elevator status will choose which elevator should service the request and send request to the elevator to add a stop.


```python
class Elevator:
    def __init__(self, lift_id, current_floor):
        self.lift_id = lift_id
        self.current_floor = current_floor # current_floor
        self.direction = None # up, down
        self.to_heaven = [] # up floors
        self.to_hell = [] # down floors
        self.weight = 0
```

Now let us start processing some of the requests coming from inside or outside the lift

- Outside the lift: We know the requestors current floor and direction
- Inside the lift: We know the floor we need to stop at

Based on this information along with the inherent knowledge of the direction/ movement the lift we can decide how the requests can be fulfilled


```python
def request_lift(self, floor, direction=None):

    # pressing button from inside (No direction)
    if direction is None:
        if floor > self.current_floor:
            # lift needs to go up to reach the floor
            direction = "up"
        else:
            # lift needs to go down to reach the floor
            direction = "down"

    # pressing button from outisde
    # someone wants to go up
    elif direction == "up":
         # Max heap of up_floors
        floors_tuple = (floor, self.current_floor)
        heappush(self.to_heaven, floors_tuple)
    # someone wants to go down
    elif direction == "down":
         # Min Heap of down_floors
        floors_tuple = (-floor, self.current_floor)
        heappush(self.to_hell, floors_tuple)

```

Now onto processing the requests! we are just gonna give more priority to request going up rather than down cause i elevators hate cognitive dissonance more than going to hell.

Well now we just check the list of stops going up and start processing them and once we are done we move onto the list going down and do the same until we are left with the lift in idle state.


```python
def run(self):
    print(f"Starting at floor {abs(self.current_floor)}")

    # while there are floors left to cover
    while self.to_heaven or self.to_hell:

        # process all the UP stops
        while self.to_heaven:
            going_to_floor, coming_from_floor = heappop(self.to_heaven)
            self.current_floor = going_to_floor
            self.weight = calulate_weight()
            print(f"Lift is at floor {target}")

        # After processing all Up requests check if someone has to go down
        self.direction = "down" if self.to_hell else None

        # process all DOWN stops
        while self.to_hell:
            going_to_floor, coming_from_floor = heappop(self.to_hell)
            self.current_floor = going_to_floor
            self.weight = calulate_weight()
            print(f"Lift is at floor {abs(target)}")

        # After processing all Down requests check if someone has to go up
        self.direction = "up" if self.to_heaven else None
```

This is how individual lifts are gonna operate, For requests from outside, A central server will select the lift that it chooses to send the request to by validating a few things

- The floor of requestor + direction they want to go in aligns with the lift movement
- Number of stops between the current floor and the requestor floor is minimum
- Weight of the lift < Weight Limit


```python
def lift_manager(request_floor, direction):
    lift_heap = []

    # Someone pressed elevator from outside
    for lift in all_lifts:
        # lift is not be too full
        if lift.weight < THRESHOLD_WEIGHT:
            lift_floor = lift.current_floor
            lift_direction = lift.direction

            # lift direction aligns with user direction
            if (
                request_floor > lift_floor
            ) and (
                lift_direction in ("up", None)
            ):
                heappush(
                    lift_heap,
                    (len(lift.to_heaven),lift.lift_id)
                )
            elif(
                request_floor < lift_floor
            ) and (
                lift_direction in ("down", None)
            ):
                heappush(
                    lift_heap,
                    (len(lift.to_hell),lift.lift_id)
                )
            else:
                print("Lift is going opposite direction")
                heappush(
                    lift_heap,
                    (max_floor_number-1, lift.lift_id)
                )

        else:
            print("Lift is overweight")
                heappush(
                    lift_heap,
                    (max_floor_number, lift.lift_id)
                )

    return heappop(lift_heap)[1]
```

And for the next problem we are gonna assume that i do infact have a social life.
