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

        class out_degree_per_processor_data : public per_processor_data {
        public:

            static unsigned long edges_explored;
            unsigned long local_edges_explored;

            out_degree_per_processor_data(unsigned long machines_in) : local_edges_explored(0)  {}


            bool reduce(per_processor_data **per_cpu_array,
                        unsigned long processors) {

                for (unsigned long i = 0; i < processors; i++) {
                    out_degree_per_processor_data *data =
                            static_cast<out_degree_per_processor_data *>(per_cpu_array[i]);
                    edges_explored += data->local_edges_explored;
                    data->local_edges_explored = 0;
                }
                return false;

            }
        }  __attribute__((__aligned__(64)));

        template<typename F>
        class out_degree_cnt {
        public:

            struct __attribute__((__packed__)) degree_cnts_vertex {
                unsigned long degree;
            };

            struct __attribute__((__packed__)) degree_cnts_update {
                vertex_t parent;
                vertex_t child;
            };


            static unsigned long checkpoint_size() {
                return 3 * sizeof(unsigned long);
            }

            static void take_checkpoint(unsigned char *buffer,
                                        per_processor_data **per_cpu_array,
                                        unsigned long processors) {}

            static void restore_checkpoint(unsigned char *buffer,
                                           per_processor_data **per_cpu_array,
                                           unsigned long processors) {}

            static unsigned long split_size_bytes() {
                return sizeof(struct degree_cnts_update);
            }

            static unsigned long split_key(unsigned char *buffer,
                                           unsigned long jump) {
                return 0;
            }

            static unsigned long vertex_state_bytes() {
                return sizeof(struct degree_cnts_vertex);
            }

            static bool apply_one_update(unsigned char *vertex_state,
                                          unsigned char *update_stream,
                                          per_processor_data *per_cpu_data,
                                          bool local_tile,
                                          unsigned long bsp_phase) {
                struct degree_cnts_update *update = (struct degree_cnts_update *) update_stream;

                unsigned long vindex =
                        x_lib::configuration::map_offset(update->parent);

                struct degree_cnts_vertex *vertices = (struct degree_cnts_vertex *) vertex_state;
                vertices[vindex].degree++;

                return true;
            }

            static bool generate_update(unsigned char *vertex_state,
                                        unsigned char *edge_format,
                                        unsigned char *update_stream,
                                        per_processor_data *per_cpu_data,
                                        bool local_tile,
                                        unsigned long bsp_phase) {
                vertex_t src, dst;
                F::read_edge(edge_format, src, dst);

                struct degree_cnts_update *update = (struct degree_cnts_update *) update_stream;
                update->parent = src;
                update->child = dst;

                static_cast
                        <out_degree_per_processor_data *>(per_cpu_data)->local_edges_explored++;

                return true;
            }


            static bool init(unsigned char *vertex_state,
                             unsigned long vertex_index,
                             unsigned long bsp_phase,
                             per_processor_data *cpu_state) {
                if (bsp_phase == 0) {
                    struct degree_cnts_vertex *dc = (struct degree_cnts_vertex *) vertex_state;
                    dc->degree = 0;
                    return true;
                }

                return false;

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

            static void postprocessing() {
                BOOST_LOG_TRIVIAL(info) << "ALGORITHM::OUT_DEGREE_COUNT::EDGES_EXPLORED "
                << out_degree_per_processor_data::edges_explored;
            }

            static per_processor_data *
            create_per_processor_data(unsigned long processor_id,
                                      unsigned long machines) {
                return new out_degree_per_processor_data(machines);
            }


            static unsigned long min_super_phases() {
                return 1;
            }

        };
    }
}

#endif
