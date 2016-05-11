/*
 * Chaos 
 *
 * Copyright 2015 Operating Systems Laboratory EPFL
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef _AUTOTUNER_
#define _AUTOTUNER_

#include <sstream>

#include "../utils/boost_log_wrapper.h"
#include "../utils/memory_utils.h"
#include "../utils/options_utils.h"
#include "../utils/desc_utils.h"

#define RAM_ADJUST (0.9)
#define MIN(a, b) ((b) < (a) ? (b):(a))
#define MAX(a, b) ((a) < (b) ? (b):(a))

namespace x_lib {
    struct configuration {
        /* Independent variables */

        unsigned long processors;
        unsigned long vertices;
        unsigned long edges;
        unsigned long vertex_size;
        unsigned long vertex_footprint;
        unsigned long llc_size;
        unsigned long llc_line_size;
        unsigned long available_ram;
        unsigned long max_streams;
        unsigned long max_buffers;
        unsigned long memory_buffer_object_size;
        unsigned long disk_stream_object_size;

        /* Dependent variables */
        static unsigned long machines;
        static unsigned long cached_partitions;
        static unsigned long tiles;
        unsigned long fanout;
        static unsigned long super_partitions;
        unsigned long buffer_size;
        unsigned long vertex_state_buffer_size;

        /* New partitioning variables */
        static bool old_partitioning_mode;
        static bool balanced_partitions;

        static unsigned long new_super_partitions;

        static unsigned long sum_out_degrees_for_new_super_partition;
        static unsigned long max_edges_per_new_super_partition;

        static unsigned long max_vertices_per_new_super_partition;

        static unsigned long * new_super_partition_offsets;
        static unsigned long * new_partition_offsets;
        static unsigned long * vertices_per_new_super_partition;
        static unsigned long * vertices_per_new_partition;

        static unsigned long partitions_per_super_partition;
        static unsigned long total_partitions;

        static bool first_phase;
        static bool work_stealing;
        static bool optimized_state_load_store;
        static bool not_cached_super_partitions;
        static bool linear_search_super_partition;

        // used to cache the super partition id while scatter phase in order to do not compute it at each map_offset call
        static long cached_super_partition;
        static bool init_phase;

        /* GRID PARTITIONING */

        static bool grid_partitioning;
        static unsigned long machine_id;


        /* Mapping */
        static unsigned long partition_shift;
        static unsigned long tile_shift;
        static unsigned long super_partition_shift;
        static unsigned long ext_mem_bits;
        static unsigned long ext_fanout_bits;



        void setup_mapping() {
            partition_shift = 0;
            unsigned long temp = cached_partitions - 1;
            while (temp) {
                partition_shift++;
                temp = temp >> 1;
            }
            tile_shift = 0;
            temp = (cached_partitions / tiles) - 1;
            while (temp) {
                tile_shift++;
                temp = temp >> 1;
            }
            super_partition_shift = 0;
            temp = super_partitions - 1;
            while (temp) {
                super_partition_shift++;
                temp = temp >> 1;
            }
            temp = super_partitions * tiles - 1;
            ext_mem_bits = 0;
            while (temp) {
                ext_mem_bits++;
                temp = temp >> 1;
            }
            temp = vm["ext_fanout"].as < unsigned
            long > () - 1;
            ext_fanout_bits = 0;
            while (temp) {
                ext_fanout_bits++;
                temp = temp >> 1;
            }
        }

        unsigned long state_bufsize(unsigned long superp) {
            if (old_partitioning_mode) {
                if (superp == (super_partitions - 1)) {
                    return vertices * vertex_size - (superp * vertex_state_buffer_size);
                }
            }
            return vertex_state_buffer_size;
        }

        unsigned long max_state_bufsize() {
            return vertex_state_buffer_size;
        }

        unsigned long state_count(unsigned long superp,
                                  unsigned long partition) {

            return old_partitioning_mode ? old_state_count(superp, partition) : new_state_count(superp, partition);
        }

        unsigned  long old_state_count(unsigned long superp, unsigned long partition) {
            unsigned long base = (partition << super_partition_shift) | superp;
            unsigned long count = (vertices - 1) &
                                  ~((1UL << (partition_shift + super_partition_shift)) - 1);
            BOOST_ASSERT_MSG((base & count) == 0, "Error in state count calculation");
            if ((count | base) < vertices) {
                count = count >> (partition_shift + super_partition_shift);
            }
            else {
                count = (count >> (partition_shift + super_partition_shift)) - 1;
            }
            count++;
            return count;
        }

        // Should return the number of vertices in a given partition of a super partition
        unsigned  long new_state_count(unsigned long superp, unsigned long partition) {
            unsigned long new_count = vertices_per_new_partition[get_id(superp, partition % partitions_per_super_partition)];
            return new_count;
        }

        unsigned long calculate_ram_budget() {
            unsigned long ram_budget = 0;
            if (old_partitioning_mode) {
                // Loaded vertices
                vertex_state_buffer_size =
                        ((vertices + super_partitions - 1) / super_partitions) * vertex_size;
            } else {
                vertex_state_buffer_size = max_vertices_per_new_super_partition * vertex_size;
            }

            ram_budget += vertex_state_buffer_size;
            // Indexes [+1 for the aux]
            unsigned long aux_cnt = ((vm.count("qsort") > 0) ? 0 : 1);
            ram_budget += (max_buffers + aux_cnt) * cached_partitions * sizeof(unsigned long);
            ram_budget += (max_buffers + aux_cnt) * processors * sizeof(unsigned long);
            // Filters
            ram_budget += max_buffers * cached_partitions * sizeof(unsigned long);
            ram_budget += max_buffers * processors * sizeof(unsigned long);
            // Buffers occupy the rest
            ram_budget += max_buffers * memory_buffer_object_size;
            buffer_size = (available_ram - ram_budget) / (max_buffers + 1);
            return ram_budget;
        }

    public:
        void dump_config() {
            BOOST_LOG_TRIVIAL(info) << "PARTITIONING::OLD " << old_partitioning_mode;
            BOOST_LOG_TRIVIAL(info) << "PARTITIONING::BALANCED_PARTITIONS " << balanced_partitions;
            BOOST_LOG_TRIVIAL(info) << "CORE::CONFIG::PROCESSORS " << processors;
            BOOST_LOG_TRIVIAL(info) << "CORE::CONFIG::PHYSICAL_MEMORY " <<
            available_ram;
            BOOST_LOG_TRIVIAL(info) << "CORE::CONFIG::VERTICES " << vertices;
            BOOST_LOG_TRIVIAL(info) << "CORE::CONFIG::VERTEX_SIZE " << vertex_size;
            BOOST_LOG_TRIVIAL(info) << "CORE::CONFIG::VERTEX_BUFFER " <<
            vertex_state_buffer_size;
            BOOST_LOG_TRIVIAL(info) << "CORE::CONFIG::EDGES " << edges;
            BOOST_LOG_TRIVIAL(info) << "CORE::CONFIG::PARTITIONS " <<
            cached_partitions;
            BOOST_LOG_TRIVIAL(info) << "CORE::CONFIG::FANOUT " << fanout;
            BOOST_LOG_TRIVIAL(info) << "CORE::CONFIG::SUPER_PARTITIONS " <<
            super_partitions;
            BOOST_LOG_TRIVIAL(info) << "CORE::CONFIG::MACHINE_ID " <<
            machine_id;
            BOOST_LOG_TRIVIAL(info) << "CORE::CONFIG::TILES " <<
            tiles;
            BOOST_LOG_TRIVIAL(info) << "CORE::CONFIG::BUFFER_SIZE " <<
            buffer_size;
            BOOST_LOG_TRIVIAL(info) << "CORE::CONFIG::MAX_BUFFERS " <<
            max_buffers;
            BOOST_LOG_TRIVIAL(info) << "CORE::CONFIG::MAX_STREAMS " <<
            max_streams;
            BOOST_LOG_TRIVIAL(info) << "CORE::CONFIG::SUM_OF_OUT_DEGREES_FOR_NEW_PARTITIONS::FIRST_CONSTRAINT " <<
            sum_out_degrees_for_new_super_partition;
            BOOST_LOG_TRIVIAL(info) << "CORE::CONFIG::MAX_EDGES_PER_NEW_PARTITION::SECOND_CONSTRAINT " <<
            max_edges_per_new_super_partition;
            if (vm.count("ext_mem_shuffle") > 0) {
                BOOST_LOG_TRIVIAL(info) << "SLIPSTREAM::EXT_MEM_SHUFFLE ON";
                BOOST_LOG_TRIVIAL(info) << "SLIPSTREAM::EXT_MEM_FANOUT_BITS "
                << ext_fanout_bits;
            }
            else {
                BOOST_LOG_TRIVIAL(info) << "SLIPSTREAM::EXT_MEM_SHUFFLE OFF";
            }

        }

        static bool should_recompute_super_partition(unsigned long key) {
            return (init_phase || not_cached_super_partitions || cached_super_partition == -1);
        }

        static void reset_init_phase() {
            init_phase = false;
        }

        static void reset_cache_super_partititon() {
            cached_super_partition = -1;
        }

        static void set_cache_super_partititon(unsigned long superp) {
            cached_super_partition = superp;
        }

        static bool should_do_final_state_store() {
            if (!optimized_state_load_store) {
                return false;
            }
            return !(work_stealing  || new_super_partitions != machines);
        }

        static bool should_load_state() {
            if (!optimized_state_load_store) {
                return true;
            }

            bool result = work_stealing || first_phase  || new_super_partitions != machines;
            first_phase = false;
            return result;
        }

        static bool should_store_state() {
            if (!optimized_state_load_store) {
                return true;
            }

            return work_stealing  || new_super_partitions != machines;
        }

        // returns the vertex offset within a partition (its index in the partition)
        static unsigned long map_offset(unsigned long key) {
            return old_partitioning_mode ? map_offset_old(key) : map_offset_new(key);
        }

        static unsigned long map_offset_old(unsigned long key) {
            return key >> (super_partition_shift + partition_shift);
        }


        // problem. this function is also called for updates. For updates during scatter we don't need to cache the super_partition, but it seems that we don't use this function
        static unsigned long map_offset_new(unsigned long key) {
            unsigned long superp = map_new_super_partition(key);

            if (grid_partitioning) {
                superp = superp / new_super_partitions;
            }

            return balanced_partitions ? map_offset_new_balanced(key, superp) : map_offset_new_unbalanced(key, superp);
        }

        static unsigned long map_offset_new_unbalanced(unsigned long key, unsigned long superp) {
            unsigned long start = new_super_partition_offsets[superp];
            unsigned long v_id_in_super_partition = key - start;

            return v_id_in_super_partition / partitions_per_super_partition;
        }

        static unsigned long map_offset_new_balanced(unsigned long key, unsigned long superp) {
            unsigned long partition = map_new_partition_balanced(key, superp);
            return key - new_partition_offsets[get_id(superp, partition)];
        }

        static unsigned long map_cached_partition(unsigned long key) {
            return (key >> super_partition_shift) & (cached_partitions - 1);
        }

        static unsigned long map_super_partition(unsigned long key) {
            return key & (super_partitions - 1);
        }


        // computes the vertex id based on its position: super_partition, partition and offset within partition
        static unsigned long map_inverse(unsigned long super_partition,
                                             unsigned long partition,
                                             unsigned long offset) {
            return  old_partitioning_mode ? map_inverse_old(super_partition, partition, offset) :map_inverse_new(super_partition, partition, offset);

        }

        static unsigned long map_inverse_new(unsigned long super_partition,
                                            unsigned long partition,
                                            unsigned long offset) {

            return balanced_partitions ? map_inverse_new_balanced(super_partition, partition, offset) : map_inverse_new_unbalanced(super_partition, partition, offset);
        }

        static unsigned long map_inverse_new_unbalanced(unsigned long super_partition,
                                             unsigned long partition,
                                             unsigned long offset) {

            unsigned long start = new_super_partition_offsets[super_partition];
            return start + offset * partitions_per_super_partition + partition;
        }

        static unsigned long map_inverse_new_balanced(unsigned long superp,
                                             unsigned long partition,
                                             unsigned long offset) {

            return new_partition_offsets[get_id(superp, partition)] + offset;
        }

        static unsigned long map_inverse_old(unsigned long super_partition,
                                         unsigned long partition,
                                         unsigned long offset) {
            return
                    (((offset << partition_shift) | partition) << super_partition_shift)
                    | super_partition;
        }

        void set_cache(unsigned long partitions) {
            cached_partitions = partitions / super_partitions;
            fanout = cached_partitions;
            unsigned long cache_lines = llc_size / llc_line_size;
            while (fanout > cache_lines) {
                fanout = fanout / 2;
            }
        }

        // Returns true iff autotuning successful
        bool autotune() {
            // Cache <-> MM tuning
            unsigned long partitions;
            unsigned long vertices_per_partition = llc_size / vertex_footprint;

            partitions = 1;
            while ((vertices_per_partition * partitions) < vertices) {
                partitions = partitions * 2;
            }
            if (partitions < processors) {
                partitions = processors;
            }
            if (partitions < tiles) {
                partitions = tiles;
            }
            if (partitions < machines) {
                partitions = machines;
            }

            // MM <-> Disk tuning
            unsigned long ram_budget;
            // Try for 16MB buffers but settle for 4K
            unsigned long stream_unit = 16 * 1024 * 1024;
            while (stream_unit > 4096) {
                super_partitions = 1;
                while (super_partitions < machines) {
                    super_partitions = super_partitions * 2;
                }
                while (super_partitions <= partitions &&
                       ((super_partitions * tiles) <= partitions)) {
                    set_cache(partitions);
                    ram_budget = calculate_ram_budget();
                    if (ram_budget <= RAM_ADJUST * available_ram &&
                        buffer_size >= stream_unit * tiles * super_partitions) {
                        setup_mapping();
                        if (old_partitioning_mode) {
                            createConstraintsForNewPartitions();
                        }
                        return true;
                    }
                    super_partitions = super_partitions * 2;
                }
                stream_unit = stream_unit / 2;
            }
            return false;
        }

        void createConstraintsForNewPartitions() {
            // set sum to this value in order to be sure that the vertex set for the new partitions
            // does not exceed the memory
            sum_out_degrees_for_new_super_partition = vertices / super_partitions ;

            // this ensures that we have at least as many new partitions as machines.
            max_edges_per_new_super_partition = edges / super_partitions;
        }


        void manual() {
            unsigned long total_partitions;
            if (old_partitioning_mode) {
                total_partitions = vm["partitions"].as < unsigned
                long > ();
                super_partitions = vm["super_partitions"].as < unsigned
                long > ();
                cached_partitions = total_partitions / super_partitions;
                fanout = vm["fanout"].as < unsigned
                long > ();

                createConstraintsForNewPartitions();
            }


            unsigned long ram_budget = calculate_ram_budget();
            if (ram_budget > RAM_ADJUST * available_ram) {
                BOOST_LOG_TRIVIAL(fatal) << "Too little physical memory, try autotune.";
                exit(-1);
            }
            setup_mapping();
        }

        unsigned long tile2partition(unsigned long superp, unsigned long tile) {
            return tile * (cached_partitions / tiles);
        }

        void init() {
            processors = vm["processors"].as < unsigned
            long > ();
            vertices = pt.get < unsigned
            long > ("graph.vertices");
            edges = pt.get < unsigned
            long > ("graph.edges");
            llc_size = vm["cpu_cache_size"].as < unsigned
            long > ();
            llc_line_size = vm["cpu_line_size"].as < unsigned
            long > ();
            available_ram = vm["physical_memory"].as < unsigned
            long > ();
            machines = pt_slipstore.get < unsigned
            long > ("machines.count");
            work_stealing = !(vm.count("policy_help_none") > 0);
            optimized_state_load_store =  (vm.count("optimized_state_load_store") > 0);
            not_cached_super_partitions = vm.count("not_cached_super_partition") > 0;
            linear_search_super_partition = vm.count("linear_search_super_partition") > 0;
            grid_partitioning = vm.count("grid_partitioning") > 0;
            machine_id = pt_slipstore.get < unsigned
            long > ("machines.me");

            tiles = 1;

            new_super_partitions = pt_partitions.get < unsigned
            long > ("partitions_offsets_file.number_of_new_super_partitions");
            if (new_super_partitions == 0) {
                // The splitting file for the new partitions is not yet computed so we need to do an out_degree_cnt with the old_partitioning mode
                old_partitioning_mode = true;
            } else {
                old_partitioning_mode = false;
                balanced_partitions = pt_partitions.get < unsigned
                long > ("partitions_offsets_file.same_size_edge_sets_per_partition") == 1;

                init_partitioning_details();
                readPartitioningFile();
            }
        }


        void init_partitioning_details() {
            super_partitions = new_super_partitions;
            total_partitions = super_partitions * super_partitions * machines;
            cached_partitions = total_partitions / super_partitions;
            partitions_per_super_partition = cached_partitions;

            if (grid_partitioning) {
                super_partitions = super_partitions * super_partitions;
                cached_partitions = super_partitions * machines;
                not_cached_super_partitions = true;

            }
            fanout = cached_partitions;
            BOOST_ASSERT_MSG(partitions_per_super_partition > 0, "Partitions per super partition is 0");

            vertices_per_new_partition = new unsigned long [total_partitions];
            new_partition_offsets = new unsigned long [total_partitions];
        }

        void readPartitioningFile() {
            read_new_partitioning_constraints();

            init_read_in_data_structures();

            for (unsigned long i=0; i < new_super_partitions; i++) {
                read_super_partition_start_offset(i);
            }

            for (unsigned long i=0; i < new_super_partitions; i++) {
                update_vertices_per_super_partition(i);
                update_vertices_per_partition(i);
                update_max_vertices_per_super_partition(i);
            }

            check_vertex_consistency();
        }

        // checks if the sum of vertices in all the partitions is the total number of vertices
        void check_vertex_consistency() {
            unsigned long sum = 0;
            for (unsigned long i=0; i < total_partitions; i++) {
                sum += vertices_per_new_partition[i];
            }

            BOOST_ASSERT_MSG(vertices == sum, "Vertices where lost while putting them in partitions");

        }

        void read_new_partitioning_constraints() {
            sum_out_degrees_for_new_super_partition = pt_partitions.get < unsigned
            long > ("partitions_offsets_file.sum_out_degrees_for_new_super_partition");
            max_edges_per_new_super_partition =  pt_partitions.get < unsigned
            long > ("partitions_offsets_file.max_edges_per_new_super_partition");
        }

        void init_read_in_data_structures() {
            new_super_partition_offsets = new unsigned long[new_super_partitions];
            vertices_per_new_super_partition = new unsigned long[new_super_partitions];
            max_vertices_per_new_super_partition = 0;
        }

        void read_super_partition_start_offset(unsigned long superp) {
            new_super_partition_offsets[superp] = pt_partitions.get < unsigned
            long > ("partitions_offsets_file.P" +  to_string(superp));
        }

        // computes the number of vertices in a super partition
        void update_vertices_per_super_partition(unsigned long superp) {
            if ((superp+1) < new_super_partitions) {
                vertices_per_new_super_partition[superp] = new_super_partition_offsets[superp+1] - new_super_partition_offsets[superp];
            } else {
                vertices_per_new_super_partition[superp] = vertices - new_super_partition_offsets[superp];
            }
        }


        void update_vertices_per_partition(unsigned long superp) {
          if (balanced_partitions) {
              update_vertices_per_partition_balanced(superp);
          } else {
              update_vertices_per_partition_unbalanced(superp);
          }
        }

        // computes the number of vertices in each partition of a super partition
        // Ex: if each super_partition has 8 partitions and the partition has 13 vertices
        // we will have 2 vertices in partitions: 0, 1, 2, 3, 4 and 1 vertex in the rest
        void update_vertices_per_partition_unbalanced(unsigned long superp) {
            unsigned long vertices = vertices_per_new_super_partition[superp];
            unsigned long partitions = partitions_per_super_partition;

            unsigned long vertices_per_partition = vertices/ partitions;
            unsigned long rest = vertices % partitions;

            for (unsigned long i=0; i < partitions; i++) {
                unsigned  long total = vertices_per_partition;
                if (rest > 0) {
                    total++;
                    rest--;
                }
                vertices_per_new_partition[get_id(superp,i)] = total;
            }

        }

        void update_vertices_per_partition_balanced(unsigned long superp) {
            unsigned long partitions = partitions_per_super_partition;
            for (unsigned long i=0; i < partitions; i++) {
                unsigned long start;
                unsigned long end;
                if ((i + 1 ) < partitions) {
                    start = pt_partitions.get < unsigned
                    long > ("partitions_offsets_file.P" +  to_string(superp) + "pp" + to_string(i));
                    end = pt_partitions.get < unsigned
                    long > ("partitions_offsets_file.P" +  to_string(superp) + "pp" + to_string(i+1));
                } else {
                    start = pt_partitions.get < unsigned
                    long > ("partitions_offsets_file.P" +  to_string(superp) + "pp" + to_string(i));
                    end = (superp + 1) < new_super_partitions ? new_super_partition_offsets[superp + 1] : vertices;
                }

                new_partition_offsets[get_id(superp,i)] = start;
                vertices_per_new_partition[get_id(superp,i)] = end - start;
            }
        }

        void update_max_vertices_per_super_partition(unsigned long superp) {
            if (vertices_per_new_super_partition[superp] > max_vertices_per_new_super_partition) {
                max_vertices_per_new_super_partition = vertices_per_new_super_partition[superp];
            }
        }

        template <class T>
        inline std::string to_string (const T & t) {
            std::stringstream ss;
            ss << t;
            return ss.str();
        }

        static unsigned long map_new_super_partition(unsigned long key) {
            unsigned long superp;
            if (should_recompute_super_partition(key)) {
                superp = compute_new_super_partition(key);
                cached_super_partition = superp;
            } else {
                superp = cached_super_partition;
            }

            return superp;
        }

        static unsigned long get_correct_superp(unsigned long superp) {
            if (grid_partitioning) {
                return machine_id + new_super_partitions * superp;
            }
            return superp;
        }

        // returns the new partitions on which the key (vertex_id) will be based on the partition offset file
        static unsigned  long compute_new_super_partition(unsigned long key) {
            unsigned long superp;
            if (linear_search_super_partition) {
                superp = linear_search_new_super_partition(key);
            } else {
                superp = binary_interval_search(new_super_partition_offsets, key, 0, new_super_partitions-1);
            }

            return get_correct_superp(superp);

        }

        static unsigned long linear_search_new_super_partition(unsigned long key) {
            for (unsigned long i = 0; i < new_super_partitions - 1; i++) {
                if (key >= new_super_partition_offsets[i] &&
                    key < new_super_partition_offsets[i+1]) {
                    return i;
                }
            }
            return (new_super_partitions - 1);
        }

        static unsigned long binary_interval_search(unsigned long * array, unsigned long key, unsigned long start, unsigned long end) {
            if (start >= end) {
                return end;
            }
            unsigned long mid = (start + end) / 2;

            if (key >= array[mid] &&
                key < array[mid+1]) {
                return mid;
            }

            if (key >= array[mid+1]) {
                return binary_interval_search(array, key, mid+1, end);
            } else {
                return  binary_interval_search(array, key, start, mid-1);
            }
        }

        // returns the partition within a super partition in which we map a vertex
        static unsigned long map_new_partition(unsigned long v_id, unsigned long superp) {
            unsigned long sp = superp;
            if (grid_partitioning) {
                sp = superp / new_super_partitions;
            }
            return balanced_partitions ? map_new_partition_balanced(v_id, sp) : map_new_partition_unbalanced(v_id, sp);
        }

        static unsigned long map_new_partition_unbalanced(unsigned long v_id, unsigned long superp) {
            unsigned long start = new_super_partition_offsets[superp];
            unsigned long v_id_in_super_partition = v_id - start;

            return v_id_in_super_partition % partitions_per_super_partition;
        }

        static unsigned long map_new_partition_balanced(unsigned long v_id, unsigned long superp) {
            unsigned long start = get_id(superp, 0);
            unsigned long end = get_id(superp, partitions_per_super_partition - 1);
            unsigned long partition = binary_interval_search(new_partition_offsets, v_id, start, end);

            return partition - start;
        }

        // returns the [superp][p] entry in vertices_per_new_partition array.
        static unsigned long get_id(unsigned long superp, unsigned long p) {
            return superp * partitions_per_super_partition + p;
        }

    };


    class map_cached_partition_wrap {
    public:
        static unsigned long map_internal_old(unsigned long key) {
            return configuration::map_cached_partition(key);
        }

        static unsigned long map_internal_new(unsigned long key) {
            unsigned long superp = configuration::compute_new_super_partition(key);
            unsigned long partition = configuration::map_new_partition(key, superp);

            return partition;
        }

        // should return the partition within a super_partition where the vertex key is
        static unsigned long map(unsigned long key) {
            return configuration::old_partitioning_mode ? map_internal_old(key) : map_internal_new(key) ;
        }

        static unsigned long get_start_id(unsigned long superp) {
            return 1;
        }

        static unsigned long get_number_of_vertices(unsigned long superp) {
            return 0;
        }
    };

    struct map_spshift_wrap {
        static unsigned long map_spshift;

        static unsigned long map_internal_old(unsigned long key) {
            unsigned long superp = configuration::map_super_partition(key);
            unsigned long p =  configuration::map_cached_partition(key);
            unsigned long tile = p >> configuration::tile_shift;
            return (superp * configuration::tiles + tile)>> map_spshift;
        }


        static unsigned long map_internal_new(unsigned long key) {
            unsigned long superp = configuration::compute_new_super_partition(key);
            return superp;
        }

        // should return the super_partition where the vertex key is
        static unsigned long map(unsigned long key) {
            return configuration::old_partitioning_mode ? map_internal_old(key) : map_internal_new(key) ;
        }

        static unsigned long get_start_id(unsigned long superp) {
            if (configuration::old_partitioning_mode || configuration::not_cached_super_partitions) {
                return 1;
            }

            return configuration::new_super_partition_offsets[superp] ;
        }

        static unsigned long get_number_of_vertices(unsigned long superp) {
            if (configuration::old_partitioning_mode || configuration::not_cached_super_partitions) {
                return 0;
            }

            return configuration::vertices_per_new_super_partition[superp];
        }
    };

}
#endif
