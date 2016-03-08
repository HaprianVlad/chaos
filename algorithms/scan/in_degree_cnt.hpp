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

#ifndef _IN_DEGREE_CNT_
#define _IN_DEGREE_CNT__

#include "../../core/x-lib.hpp"
#include "../../utils/options_utils.h"
#include "../../utils/boost_log_wrapper.h"
#include<errno.h>
#include<string>

namespace algorithm {
    namespace sg_simple {

        // Not relevant for this project
        class in_degree_per_processor_data : public per_processor_data {
        public:


            in_degree_per_processor_data(unsigned long machines_in)  {}

            bool reduce(per_processor_data **per_cpu_array,
                        unsigned long processors) {
                return false;
            }
        }  __attribute__((__aligned__(64)));


        // Algorithm definition
        template<typename F>
        class in_degree_cnt {
        public:

            // Struct definition vertex state
            struct __attribute__((__packed__)) degree_cnts_vertex {
                unsigned long degree;
            };

            // Struct definition vertex state
            struct __attribute__((__packed__)) degree_cnts_update {
                vertex_t parent;
                vertex_t child;
            };


            // Not relevant for this project
            static unsigned long checkpoint_size() {
                return 2 * sizeof(unsigned long);
            }

            // Not relevant for this project
            static void take_checkpoint(unsigned char *buffer,
                                        per_processor_data **per_cpu_array,
                                        unsigned long processors) {}

            // Not relevant for this project
            static void restore_checkpoint(unsigned char *buffer,
                                           per_processor_data **per_cpu_array,
                                           unsigned long processors) {}


            // Where to split updates
            // Can set to 0 if no gather phase is expected.
            // Caveat: if set to 0 and gather runs, will cause infinite loops ;-)
            // Needs to be set to the size of degree_cnts_update structure
            static unsigned long split_size_bytes() {
                return sizeof(struct degree_cnts_update);
            }

            // Not relevant for our algorithms
            static unsigned long split_key(unsigned char *buffer,
                                           unsigned long jump) {
                return 0;
            }

            // Size of vertex state
            static unsigned long vertex_state_bytes() {
                return sizeof(struct degree_cnts_vertex);
            }


            // Gather user function
            static bool apply_one_update(unsigned char *vertex_state,
                                          unsigned char *update_stream,
                                          per_processor_data *per_cpu_data,
                                          bool local_tile,
                                          unsigned long bsp_phase) {
                struct degree_cnts_update *update = (struct degree_cnts_update *) update_stream;

                unsigned long vindex = x_lib::configuration::map_offset(update->child);

                // update the counter at each destination vertex
                struct degree_cnts_vertex *vertices = (struct degree_cnts_vertex *) vertex_state;
                vertices[vindex].degree++;

                return true;
            }

            // Scatter user function
            static bool generate_update(unsigned char *vertex_state,
                                        unsigned char *edge_format,
                                        unsigned char *update_stream,
                                        per_processor_data *per_cpu_data,
                                        bool local_tile,
                                        unsigned long bsp_phase) {
                vertex_t src, dst;
                F::read_edge(edge_format, src, dst);

                // Sends update from source to destination
                struct degree_cnts_update *update = (struct degree_cnts_update *) update_stream;
                update->parent = src;
                update->child = dst;


                return true;
            }

            // Apply user function
            static void vertex_apply(unsigned char *v,
                                     unsigned char *copy,
                                     unsigned long copy_machine,
                                     per_processor_data *per_cpu_data,
                                     unsigned long bsp_phase) {
                struct bfs_vertex *vtx = (struct bfs_vertex *) v;
                struct bfs_vertex *vtx_cpy = (struct bfs_vertex *) copy;
                vtx->degree += vtx_cpy->degree;
            }


            // Initialization of state
            static bool init(unsigned char *vertex_state,
                             unsigned long vertex_index,
                             unsigned long bsp_phase,
                             per_processor_data *cpu_state) {

                struct degree_cnts_vertex *dc = (struct degree_cnts_vertex *) vertex_state;
                dc->degree = 0;
                return true;

            }

            // When to initialize state
            static bool need_init(unsigned long bsp_phase) {
                return (bsp_phase == 0);
            }


            static
            bool need_data_barrier() {
                return false;
            }

            // Not relevant for this project
            class db_sync {

                unsigned long machines;
            public:
                void prep_db_data(per_processor_data **pcpu_array,
                                  unsigned long me,
                                  unsigned long processors) {}

                void finalize_db_data(per_processor_data **pcpu_array,
                                      unsigned long me,
                                      unsigned long processors) {}

                unsigned char *db_buffer() { return 0; }

                unsigned long db_size() { return 0; }

                void db_generate() { }

                void db_merge() {}

                void db_absorb() {}
                ~db_sync() {}
            };

            static db_sync *get_db_sync() { return NULL; }


            // Whether to write state back at the end of the scatter
            // Normaly we don't need it because we run also an update phase
            static bool need_scatter_merge(unsigned long bsp_phase) {
                return false;
            }



            static void preprocessing() { }

            static void postprocessing() {
            }

            static per_processor_data *
            create_per_processor_data(unsigned long processor_id,
                                      unsigned long machines) {
                return new in_degree_per_processor_data(machines);
            }

            // Lower bound on number of phases (if no one voted to continue)
            static unsigned long min_super_phases() {
                return 1;
            }

        };
    }
}

#endif
