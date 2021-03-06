// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Package partition metadata.
//
// DO NOT EDIT THIS FILE DIRECTLY.
// It has been generated with hw/ip/otp_ctrl/util/translate-mmap.py
<%
  def PascalCase(inp):
    oup = ''
    upper = True
    for k in inp.lower():
      if k == '_':
        upper = True
      else:
        oup += k.upper() if upper else k
        upper = False
    return oup
%>
package otp_ctrl_part_pkg;

  import otp_ctrl_reg_pkg::*;
  import otp_ctrl_pkg::*;

  localparam part_info_t PartInfo [NumPart] = '{
% for part in config["partitions"]:
    // ${part["name"]}
    '{
      variant:    ${part["variant"]},
      offset:     ${config["otp"]["byte_addr_width"]}'d${part["offset"]},
      size:       ${part["size"]},
      key_sel:    ${part["key_sel"] if part["key_sel"] != "NoKey" else "key_sel_e'('0)"},
      secret:     1'b${"1" if part["secret"] else "0"},
      hw_digest:  1'b${"1" if part["hw_digest"] else "0"},
      write_lock: 1'b${"1" if part["write_lock"].lower() == "digest" else "0"},
      read_lock:  1'b${"1" if part["read_lock"].lower() == "digest" else "0"}
    }${"" if loop.last else ","}
% endfor
  };

  typedef enum {
% for part in config["partitions"]:
    ${PascalCase(part["name"])}Idx,
% endfor
    // These are not "real partitions", but in terms of implementation it is convenient to
    // add these at the end of certain arrays.
    DaiIdx,
    LciIdx,
    KdiIdx,
    // Number of agents is the last idx+1.
    NumAgentsIdx
  } part_idx_e;

  parameter int NumAgents = int'(NumAgentsIdx);

endpackage : otp_ctrl_part_pkg
