#!/usr/bin/env python                                                                                                           1 ↵
"""
Quick script to add lat/long to metadata
"""

from geopy.geocoders import Nominatim
import argparse

def get_lat_long(country, geolocator):
    """
    Use geolocator to get lat/long from country name

    Params
    ------
    country: str
        country name and or address

    geolocator: geopy.geocoders
        initialised geopy geolocation class

    Returns
    -------

    lat: float
        latitude of country
    long: flat
        lontitude of country
    """
    location = geolocator.geocode(country)
    return location.latitude, location.longitude




if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Add lat and long to metadata')
    parser.add_argument('csv', help='Path to CSV')
    parser.add_argument('field', help='Field containing country', type=int)
    args = parser.parse_args()

    geolocator = Nominatim()

    with open(args.csv) as fh:
        # write header
        header = next(fh).strip()
        print(header)

        for line in fh:
            line = line.strip().split(',')
            loc = get_lat_long(line[args.field], geolocator)
            line = line + list(map(str, loc))
            print(",".join(line))


