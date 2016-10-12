; ModuleID = 'escape_global_loop.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@globalptr = common global i8* null, align 8

; Function Attrs: nounwind uwtable
define void @escape_local2(i8** %argptr, i8* %aChar, i32 %aInt) #0 {
  %1 = alloca i8**, align 8
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %local_char = alloca i8, align 1
  %i = alloca i32, align 4
  store i8** %argptr, i8*** %1, align 8
  call void @llvm.dbg.declare(metadata !{i8*** %1}, metadata !17), !dbg !18
  store i8* %aChar, i8** %2, align 8
  call void @llvm.dbg.declare(metadata !{i8** %2}, metadata !19), !dbg !18
  store i32 %aInt, i32* %3, align 4
  call void @llvm.dbg.declare(metadata !{i32* %3}, metadata !20), !dbg !18
  call void @llvm.dbg.declare(metadata !{i8* %local_char}, metadata !21), !dbg !22
  store i8 97, i8* %local_char, align 1, !dbg !22
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !23), !dbg !24
  br label %4, !dbg !25

; <label>:4                                       ; preds = %7, %0
  %5 = load i32* %i, align 4, !dbg !25
  %6 = icmp ne i32 %5, 0, !dbg !25
  br i1 %6, label %7, label %8, !dbg !25

; <label>:7                                       ; preds = %4
  store i8* %local_char, i8** @globalptr, align 8, !dbg !26
  br label %4, !dbg !28

; <label>:8                                       ; preds = %4
  %9 = load i8*** %1, align 8, !dbg !29
  store i8* %local_char, i8** %9, align 8, !dbg !29
  ret void, !dbg !30
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!14, !15}
!llvm.ident = !{!16}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !12, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/cs4239/Documents/CS4239_Assignment2/test/escape_global_loop.c] [DW_LANG_C99]
!1 = metadata !{metadata !"escape_global_loop.c", metadata !"/home/cs4239/Documents/CS4239_Assignment2/test"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"escape_local2", metadata !"escape_local2", metadata !"", i32 2, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i8**, i8*, i32)* @escape_local2, null, null, metadata !2, i32 2} ; [ DW_TAG_subprogram ] [line 2] [def] [escape_local2]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/cs4239/Documents/CS4239_Assignment2/test/escape_global_loop.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{null, metadata !8, metadata !9, metadata !11}
!8 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !9} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!9 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !10} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!10 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!11 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!12 = metadata !{metadata !13}
!13 = metadata !{i32 786484, i32 0, null, metadata !"globalptr", metadata !"globalptr", metadata !"", metadata !5, i32 1, metadata !9, i32 0, i32 1, i8** @globalptr, null} ; [ DW_TAG_variable ] [globalptr] [line 1] [def]
!14 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!15 = metadata !{i32 1, metadata !"Debug Info Version", i32 1}
!16 = metadata !{metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)"}
!17 = metadata !{i32 786689, metadata !4, metadata !"argptr", metadata !5, i32 16777218, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [argptr] [line 2]
!18 = metadata !{i32 2, i32 0, metadata !4, null}
!19 = metadata !{i32 786689, metadata !4, metadata !"aChar", metadata !5, i32 33554434, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [aChar] [line 2]
!20 = metadata !{i32 786689, metadata !4, metadata !"aInt", metadata !5, i32 50331650, metadata !11, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [aInt] [line 2]
!21 = metadata !{i32 786688, metadata !4, metadata !"local_char", metadata !5, i32 3, metadata !10, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [local_char] [line 3]
!22 = metadata !{i32 3, i32 0, metadata !4, null}
!23 = metadata !{i32 786688, metadata !4, metadata !"i", metadata !5, i32 4, metadata !11, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 4]
!24 = metadata !{i32 4, i32 0, metadata !4, null}
!25 = metadata !{i32 5, i32 0, metadata !4, null}
!26 = metadata !{i32 6, i32 0, metadata !27, null}
!27 = metadata !{i32 786443, metadata !1, metadata !4, i32 5, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/cs4239/Documents/CS4239_Assignment2/test/escape_global_loop.c]
!28 = metadata !{i32 7, i32 0, metadata !27, null}
!29 = metadata !{i32 8, i32 0, metadata !4, null} ; [ DW_TAG_imported_declaration ]
!30 = metadata !{i32 9, i32 0, metadata !4, null}
