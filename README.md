# Wolt Senior Flutter Developer Assignment

## Concept
A user is walking around Helsinki city center looking for a place to eat. Your task is to create an application that helps them find nearby venues dynamically.

## Flutter Project Setup

1. To build a solution run following:
   ```bash
   flutter clean
   flutter pub get
   flutter build apk
2. Solution was tested on Android API v35
3. To run the tests, use the following command:
   ```bash
   flutter test --coverage
The coverage file will be saved in: ./coverage/Icov.info

## Notes and room for improvement 
### "Based on tech interview"
This solution works and meets all feature requirement, but following notes should be taken into account:
   - Project is based on Riverpod architecture (you should be able to talk about its pros and cons)
   - Some usages of Riverpod concepts (providers, services, datasources) are used incorrectly, so has to be revised
   - Or new Flutter Architecture Guideline can be checked and modules swapped
   - Some services use Flutter packages and libraries wo any wrapping (di - interface-implementation), that breaks di approach
   - Abstarct classes should be replaced with interfaces, this is current Flutter standard
   - Service dependencies should be passed in class constructors
   - Location service has stream subscription implementation (async*), type of stream should be rewised (broadcase vs single sub)
   - And generally there should be a revision of which object must exist as singleton and which can have multiple instances
   - venue_screen - StreamBuilder x FutureBuilder - FutureBuilder must always exist in single exemplar to prevent backend api ddos
   - json to objects serialization can be rewised and found best place to do it

---

## Task Description

### Core Requirements
1. **Venue List Display**:
   - Show a list of up to 15 venues near the user’s current location.
   - If the API returns more than 15 venues, only display the first 15.

2. **Dynamic Location Updates**:
   - Update the user’s location every 10 seconds, cycling through a predefined list of coordinates.
   - After the last location in the list, loop back to the first coordinate and repeat the sequence.

3. **Venue List Refresh**:
   - Automatically refresh the venue list when the location updates.
   - Use smooth transition animations for enhanced visual appeal.

4. **Favourite Venues**:
   - Allow users to mark/unmark venues as favourites.
   - Display a different icon based on the favourite state.
   - Persist the favourite states and reapply them when a venue reappears.

---

### Location Update Timeline

| Time Elapsed | Current Location       |
|--------------|-------------------------|
| 0 seconds    | `locations[0]`          |
| 10 seconds   | `locations[1]`          |
| 20 seconds   | `locations[2]`          |
| ...          | ...                     |
| End of list  | Loop back to `locations[0]` |

---

### API Endpoint

**GET**: `https://restaurant-api.wolt.com/v1/pages/restaurants?lat=<latitude>&lon=<longitude>`

#### Key Response Fields
- **`sections -> items -> venue -> id`**: Unique ID of the venue.
- **`sections -> items -> venue -> name`**: Name of the venue.
- **`sections -> items -> venue -> short_description`**: Description of the venue.
- **`sections -> items -> image -> url`**: Image URL for the venue.

---

### Coordinate List
1. `60.170187, 24.930599`
2. `60.169418, 24.931618`
3. `60.169818, 24.932906`
4. `60.170005, 24.935105`
5. `60.169108, 24.936210`
6. `60.168355, 24.934869`
7. `60.167560, 24.932562`
8. `60.168254, 24.931532`
9. `60.169012, 24.930341`
10. `60.170085, 24.929569`

---

### Design Guidelines

#### Icons
- **Favourite (true)**: [Favorite Icon](https://material.io/tools/icons/?icon=favorite&style=baseline)
- **Favourite (false)**: [Favorite Border Icon](https://material.io/tools/icons/?icon=favorite_border&style=baseline)

#### Example of Minimal Design
Feel free to explore your own UI approach as long as the necessary information is present. Use the provided examples as inspiration.

---

### FAQ

#### 1. What will you review in the code I submit?
Your submission will be treated as a production-ready feature. We'll evaluate:
- **Code Quality**: Clean, maintainable, and well-structured.
- **Functionality**: Fully functional and meets the described requirements.
- **User Interface**: Professional and visually appealing.

#### 2. Does my app need to support different screen orientations?
No, only portrait mode is required.

#### 3. Do I need to strictly follow the design example?
No, the mockup is a suggestion. You can design the UI in your own way, ensuring all required details are included.

---

### Example Assets
- **Favorite (True)**: [Favorite Icon](https://material.io/tools/icons/?icon=favorite&style=baseline)
- **Favorite (False)**: [Favorite Border Icon](https://material.io/tools/icons/?icon=favorite_border&style=baseline)
