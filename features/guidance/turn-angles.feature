@routing  @guidance @turn-angles
Feature: Simple Turns

    Background:
        Given the profile "car"
        Given a grid size of 1 meters

    Scenario: Offset Turn
        Given the node map
            | a |   |   |   |   |   |   |   |   | b |   |   |   |   |   |   |   |   |   | c |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   | d |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | e |   |

        And the ways
            | nodes  | highway | name | lanes |
            | abc    | primary | road | 4     |
            | bde    | primary | turn | 2     |

       When I route I should get
            | waypoints | route          | turns                           |
            | a,c       | road,road      | depart,arrive                   |
            | a,e       | road,turn,turn | depart,turn slight right,arrive |
            | e,a       | turn,road,road | depart,turn slight left,arrive  |
            | e,c       | turn,road,road | depart,turn sharp right,arrive  |

    Scenario: Road Taking a Turn after Intersection
        Given the node map
            | a |   |   |   |   |   |   |   |   | b |   |   |   |   |   |   |   |   |   | c |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   | d |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | e |   |

        And the ways
            | nodes  | highway | name | lanes |
            | abc    | primary | road | 4     |
            | bde    | primary | turn | 2     |

       When I route I should get
            | waypoints | route          | turns                    |
            | a,c       | road,road      | depart,arrive            |
            | a,e       | road,turn,turn | depart,turn right,arrive |
            | e,a       | turn,road,road | depart,turn left,arrive  |
            | e,c       | turn,road,road | depart,turn right,arrive |

    Scenario: U-Turn Lane
        Given the node map
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | j |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            | i |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | g |   | h |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | f |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   | d |   |   |   |   |   |   |   |   | e |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   | c |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            | a |   | k |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | b |

        And the ways
            | nodes   | highway      | name | lanes | oneway |
            | akb     | primary      | road | 4     | yes    |
            | hgi     | primary      | road | 4     | yes    |
            | akcdefg | primary_link |      | 1     | yes    |
            | gj      | tertiary     | turn | 1     |        |

       When I route I should get
            | waypoints | route          | turns                        |
            | a,b       | road,road      | depart,arrive                |
            | a,i       | road,road,road | depart,continue uturn,arrive |
            | a,j       | road,turn,turn | depart,turn left,arrive      |

    #http://www.openstreetmap.org/#map=19/52.50871/13.26127
    Scenario: Curved Turn
        Given the node map
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            | f |   |   |   |   | e |   |   |   |   |   |   |   |   |   |   |   |   |   |   | d |
            |   |   |   |   |   |   |   |   | l |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   | k |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | j |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | i |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | h |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            | a |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | b |   | c |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |
            |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | g |   |   |

        And the ways
            | nodes   | highway      | name | lanes | oneway |
            | abc     | primary      | road | 5     | no     |
            | gb      | secondary    | turn | 3     | yes    |
            | bhijkle | unclassified | turn | 2     | yes    |
            | de      | residential  | road |       | yes    |
            | ef      | residential  | road | 2     | yes    |

       When I route I should get
            | waypoints | route               | turns                              |
            | a,c       | road,road           | depart,arrive                      |
            | c,a       | road,road           | depart,arrive                      |
            | g,a       | turn,road,road      | depart,turn left,arrive            |
            | g,c       | turn,road,road      | depart,turn right,arrive           |
            | g,f       | turn,road,road      | depart,turn left,arrive            |
            | c,f       | road,turn,road,road | depart,turn right,turn left,arrive |
