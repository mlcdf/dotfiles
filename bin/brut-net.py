#!/usr/bin/env python3
"""Converti un salaire brut annuel en un salaire net mensuel."""

import optparse


def main():
    p = optparse.OptionParser(description=__doc__)
    options, arguments = p.parse_args()
    annuel_brut = int(arguments[0])
    mensuel_net = (annuel_brut - (annuel_brut * 23 / 100)) / 12
    print('%d €' % round(mensuel_net))


if __name__ == '__main__':
    main()
