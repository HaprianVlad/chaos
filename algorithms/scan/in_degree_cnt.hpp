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
#define _IN_DEGREE_CNT_

#include "../../core/x-lib.hpp"
#include "../../utils/options_utils.h"
#include "../../utils/boost_log_wrapper.h"
#include<errno.h>
#include<string>

namespace algorithm {
    namespace sg_simple {
        template<typename F>
        class in_degree_cnt {
        public:
            struct __attribute__((__packed__)) degree_cnts {
                unsigned long degree;
            };

            static unsigned long split_size_bytes() {
                return 0;
            }

            static unsigned long checkpoint_size() {
                return 3 * sizeof(unsigned long);
            }

            static void take_checkpoint(unsigned char *buffer,
                                        per_processor_data **per_cpu_array,
                                        unsigned long processors) {}

            static void restore_checkpoint(unsigned char *buffer,
                                           per_processor_data **per_cpu_array,
                                           unsigned long processors) {}

            static unsigned long split_key(unsigned char *buffer,
                                           unsigned long jump) {
                return 0;
            }

            static unsigned long vertex_state_bytes() {
                return sizeof(struct degree_cnts);
            }

            static bool apply_one_update(unsigned char *vertex_state,
                                         unsigned char *update_stream,
                                         per_processor_data *per_cpu_data,
                                         unsigned long bsp_phase) {
                BOOST_ASSERT_MSG(false, "Should not be called !");
                return false;
            }

            static bool generate_update(unsigned char *vertex_state,
                                        unsigned char *edge_format,
                                        unsigned char *update_stream,
                                        per_processor_data *per_cpu_data,
                                        unsigned long bsp_phase) {
                vertex_t src, dst;
                F::read_edge(edge_format, src, dst);
                unsigned long vindex = x_lib::configuration::map_offset(dst);
                struct degree_cnts *v = (struct degree_cnts *) vertex_state;
                v[vindex].degree++;
                return false;
            }

            static bool init(unsigned char *vertex_state,
                             unsigned long vertex_index,
                             unsigned long bsp_phase,
                             per_processor_data *cpu_state) {
                struct degree_cnts *dc = (struct degree_cnts *) vertex_state;
                dc->degree = 0;
                return true;
            }

            static bool need_init(unsigned long bsp_phase) {
                return (bsp_phase == 0);
            }

            static
            bool need_data_barrier() {
                return false;
            }

            class db_sync {

                unsigned long machines;
            public:
                void prep_db_data(per_processor_data **pcpu_array,
                                  unsigned long me,
                                  unsigned long processors) {

                }

                void finalize_db_data(per_processor_data **pcpu_array,
                                      unsigned long me,
                                      unsigned long processors) {

                }

                unsigned char *db_buffer() { return 0; }

                unsigned long db_size() { return 0; }

                void db_generate() { }

                void db_merge() {

                }

                void db_absorb() {

                }

                ~db_sync() {
                }

            };

            static db_sync *get_db_sync() { return NULL; }

            static bool need_scatter_merge(unsigned long bsp_phase) {
                return false;
            }
            
            static void vertex_apply(unsigned char *v,
                                     unsigned char *copy,
                                     unsigned long copy_machine,
                                     per_processor_data *per_cpu_data,
                                     unsigned long bsp_phase) {
                // Nothing
            }


            static void preprocessing() { }

            static void postprocessing() { }

            static per_processor_data *
            create_per_processor_data(unsigned long processor_id,
                                      unsigned long machines) {
                return NULL;
            }

            static unsigned long min_super_phases() {
                return 0;
            }

        };
    }
}

#endif
