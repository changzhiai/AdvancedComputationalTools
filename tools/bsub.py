#!/usr/bin/env python3
"""GPAW-wrapper for qsub."""

import argparse
import subprocess
import numpy as np

description = 'Submit a GPAW Python script via bsub.'
# Nodes are either with 20 or 24 cores
nodesizes = [20, 24]


def main():
    """Submit a gpaw script using bsub."""
    parser = argparse.ArgumentParser(description=description)
    parser.add_argument('-p', '--processes', type=int, default=20,
                        help='Number of processes.')
    parser.add_argument('-t', '--time', type=int, default=1,
                        help='Max running time in hours.')
    parser.add_argument('-m', '--minimum-memory-per-core', type=int, default=6,
                        help='Minimum available memory per core.')
    parser.add_argument('-z', '--dry-run', action='store_true',
                        help='Don\'t actually submit script.')
    parser.add_argument('script', help='Python script')
    parser.add_argument('argument', nargs='*',
                        help='Command-line argument for Python script.')
    args = parser.parse_args()
    arguments = ' '.join(args.argument)
    cmd = f'gpaw python {args.script} {arguments}'
    nodes_list, rest_list = np.divmod(args.processes, nodesizes)
    # Take the minimum of rest_list and use that nodesize as ppn
    ppn = nodesizes[np.argmin(rest_list)]
    # Get number of nodes
    # no_nodes = nodes_list[np.argmin(rest_list)]
    # if np.min(rest_list) > 0:
    #     no_nodes += 1
    # if nodes > 0:
    #     ppn = maxcores
    #     if rest > 0:
    #         print((f'Job should be a multiple of {maxcores} which is'
    #                'the number of CPU\'s per node.'))
    # else:
    #     nodes = 1
    #     ppn = args.processes
    lines = [
        '#!/bin/sh',
        '#BSUB -q hpc',
        f'#BSUB -J {args.script}',
        # f'# -l nodes={nodes}:ppn={ppn}',
        f'#BSUB -n {args.processes}',
        # f'#BSUB -R "span[ptile={ppn}]"',
        f'#BSUB -R "span[block={ppn}]"',
        # f'#BSUB -R "span[hosts={no_nodes}]"',
        f'#BSUB -R "rusage[mem={args.minimum_memory_per_core}GB]"',
        f'#BSUB -W {args.time}:00',
        '#BSUB -o %J.out',
        '#BSUB -e %J.err',
        f'OMP_NUM_THREADS=1 mpiexec {cmd}']
    script = '\n'.join(lines) + '\n'
    if args.dry_run:
        print(script)
    else:
        p = subprocess.Popen(['bsub'], stdin=subprocess.PIPE)
        p.communicate(script.encode())


if __name__ == '__main__':
    main()
