(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*         Fabrice Le Fessant, projet Gallium, INRIA Rocquencourt      *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)


(** Definitions shared between the 32 and 64 bit Intel backends. *)

open Intel_ast

(** Helpers for textual emitters *)

val string_of_register8: register8 -> string
val string_of_register16: register16 -> string
val string_of_register32: register32 -> string
val string_of_register64: register64 -> string
val string_of_registerf: registerf -> string
val string_of_string_literal: string -> string
val string_of_condition: condition -> string
val string_of_datatype: data_type -> string
val string_of_symbol: (*prefix*) string -> string -> string

(** Buffer of assembly code *)

val emit: instruction -> unit
val directive: asm_line -> unit
val reset_asm_code: unit -> unit

(** Code emission *)

val generate_code: (out_channel * (Buffer.t -> Intel_ast.asm_line -> unit)) option -> unit
  (** Post-process the stream of instructions.  Dump it (using
      the provided syntax emitter) in a file (if provided) and
      compile it with an internal assembler (if registered
      through [register_internal_assembler]). *)

val assemble_file: (*infile*) string -> (*outfile*) string -> (*retcode*) int
(** Generate an object file corresponding to the last call to
    [generate_code].  An internal assembler is used if available (and
    the input file is ignored). Otherwise, the source asm file with an
    external assembler. *)

(** System detection *)

type system =
  (* 32 bits and 64 bits *)
  | S_macosx
  | S_gnu
  | S_cygwin

  (* 32 bits only *)
  | S_solaris
  | S_win32
  | S_linux_elf
  | S_bsd_elf
  | S_beos
  | S_mingw

  (* 64 bits only *)
  | S_win64
  | S_linux
  | S_mingw64

  | S_unknown

val system: system
val masm: bool


(** Support for plumbing a binary code emitter *)

val register_internal_assembler: (asm_program -> string -> unit) -> unit


(** Hooks for rewriting the assembly code *)

val assembler_passes: (asm_program -> asm_program) list ref


(** Misc *)

val reg_low_32: register64 -> register32