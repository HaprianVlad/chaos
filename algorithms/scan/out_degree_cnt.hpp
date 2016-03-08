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

#ifndef _OUT_DEGREE_CNT_
#define _OUT_DEGREE_CNT_

#include "../../core/x-lib.hpp"
#include "../../utils/options_utils.h"
#include "../../utils/boost_log_wrapper.h"
#include<errno.h>
#include<string>

namespace algorithm {
    namespace sg_simple {

        // Not relevant for this project
        class out_degree_per_processor_data : public per_processor_data {
        public:

            out_degree_per_processor_data(unsigned long machines_in) {}

            bool reduce(per_processor_data **per_cpu_array,
                        unsigned long processors) {
                return false;
            }

        }  __attribute__((__aligned__(64)));

        // Algorithm definition
        template<typename F>
        class out_degree_cnt {
        public:

            // Struct definitions (vertex state and updates)
            struct __attribute__((__packed__)) degree_cnts {
                unsigned long degree;
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
                BOOST_ASSERT_MSG(false, "Should not be called !");
                return false;
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
                unsigned long vindex = x_lib::configuration::map_offset(src);
                struct degree_cnts *v = (struct degree_cnts *) vertex_state;
                v[vindex].degree++;
                return false;
            }


            // Apply user function
            static void vertex_apply(unsigned char *v,
                                     unsigned char *copy,
                                     unsigned long copy_machine,
                                     per_processor_data *per_cpu_data,
                                     unsigned long bsp_phase) {
                BOOST_ASSERT_MSG(false, "Should not be called !");
            }

            // Initialization of state
            static bool init(unsigned char *vertex_state,
                             unsigned long vertex_index,
                             unsigned long bsp_phase,
                             per_processor_data *cpu_state) {
                struct degree_cnts *dc = (struct degree_cnts *) vertex_state;
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
            // Very relevant for our algorithm since we only run a scatter pass ;-)
            static bool need_scatter_merge(unsigned long bsp_phase) {
                return bsp_phase == 0;
            }




            static void preprocessing() {}

            static void postprocessing() {}

            static per_processor_data *
            create_per_processor_data(unsigned long processor_id,
                                      unsigned long machines) {
                return new out_degree_per_processor_data(machines);
            }


            // Lower bound on number of phases (if no one voted to continue)
            static unsigned long min_super_phases() {
                return 0;
            }

        };
    }
}

#endif
