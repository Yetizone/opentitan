// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

// Test advance state and generate output at StWipe state
class keymgr_op_at_wipe_state_vseq extends keymgr_sanity_vseq;
  `uvm_object_utils(keymgr_op_at_wipe_state_vseq)
  `uvm_object_new

  virtual task keymgr_init();
    `uvm_info(`gfn, "Initializating key manager", UVM_MEDIUM)
    ral.control.init.set(1'b1);
    csr_update(.csr(ral.control));
    ral.control.init.set(1'b0); // don't program init again

    current_state = keymgr_pkg::StWipe;
    // it's StWipe now, but only last for several cycles, during this period, any OP will be
    // ignored
    randcase
      1: keymgr_operations(.advance_state(1), .num_gen_op(0), .wait_done(0), .clr_output(0));
      1: keymgr_operations(.advance_state(0), .num_gen_op(1), .wait_done(0), .clr_output(0));
    endcase
    csr_spinwait(.ptr(ral.working_state), .exp_data(keymgr_pkg::StInit));
    current_state = keymgr_pkg::StInit;
  endtask : keymgr_init

endclass : keymgr_op_at_wipe_state_vseq
