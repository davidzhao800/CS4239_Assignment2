; ModuleID = 'test_pointer_assign.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@b = global i8 99, align 1

; Function Attrs: nounwind uwtable
define i8* @escape() #0 {
  %local_char = alloca i8, align 1
  %p2 = alloca i8*, align 8
  %p3 = alloca i8*, align 8
  %p4 = alloca i8*, align 8
  %p = alloca i8*, align 8
  %i = alloca i32, align 4
  call void @llvm.dbg.declare(metadata !{i8* %local_char}, metadata !15), !dbg !16
  store i8 97, i8* %local_char, align 1, !dbg !16
  call void @llvm.dbg.declare(metadata !{i8** %p2}, metadata !17), !dbg !18
  store i8* %local_char, i8** %p2, align 8, !dbg !18
  call void @llvm.dbg.declare(metadata !{i8** %p3}, metadata !19), !dbg !20
  call void @llvm.dbg.declare(metadata !{i8** %p4}, metadata !21), !dbg !22
  call void @llvm.dbg.declare(metadata !{i8** %p}, metadata !23), !dbg !24
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !25), !dbg !27
  store i32 0, i32* %i, align 4, !dbg !27
  %1 = load i32* %i, align 4, !dbg !28
  %2 = icmp ne i32 %1, 0, !dbg !28
  br i1 %2, label %3, label %5, !dbg !28

; <label>:3                                       ; preds = %0
  %4 = load i8** %p2, align 8, !dbg !30
  store i8* %4, i8** %p3, align 8, !dbg !30
  br label %5, !dbg !32

; <label>:5                                       ; preds = %3, %0
  br label %6, !dbg !33

; <label>:6                                       ; preds = %9, %5
  %7 = load i32* %i, align 4, !dbg !33
  %8 = icmp ne i32 %7, 0, !dbg !33
  br i1 %8, label %9, label %11, !dbg !33

; <label>:9                                       ; preds = %6
  %10 = load i8** %p3, align 8, !dbg !34
  store i8* %10, i8** %p4, align 8, !dbg !34
  br label %6, !dbg !36

; <label>:11                                      ; preds = %6
  %12 = load i8** %p4, align 8, !dbg !37
  store i8* %12, i8** %p, align 8, !dbg !37
  %13 = load i8** %p, align 8, !dbg !38
  ret i8* %13, !dbg !38
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!12, !13}
!llvm.ident = !{!14}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !10, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test_pointer_assign.c] [DW_LANG_C99]
!1 = metadata !{metadata !"test_pointer_assign.c", metadata !"/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"escape", metadata !"escape", metadata !"", i32 3, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i8* ()* @escape, null, null, metadata !2, i32 3} ; [ DW_TAG_subprogram ] [line 3] [def] [escape]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test_pointer_assign.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8}
!8 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !9} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!9 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!10 = metadata !{metadata !11}
!11 = metadata !{i32 786484, i32 0, null, metadata !"b", metadata !"b", metadata !"", metadata !5, i32 1, metadata !9, i32 0, i32 1, i8* @b, null} ; [ DW_TAG_variable ] [b] [line 1] [def]
!12 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!13 = metadata !{i32 1, metadata !"Debug Info Version", i32 1}
!14 = metadata !{metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)"}
!15 = metadata !{i32 786688, metadata !4, metadata !"local_char", metadata !5, i32 4, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [local_char] [line 4]
!16 = metadata !{i32 4, i32 0, metadata !4, null}
!17 = metadata !{i32 786688, metadata !4, metadata !"p2", metadata !5, i32 5, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p2] [line 5]
!18 = metadata !{i32 5, i32 0, metadata !4, null}
!19 = metadata !{i32 786688, metadata !4, metadata !"p3", metadata !5, i32 6, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p3] [line 6]
!20 = metadata !{i32 6, i32 0, metadata !4, null}
!21 = metadata !{i32 786688, metadata !4, metadata !"p4", metadata !5, i32 7, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p4] [line 7]
!22 = metadata !{i32 7, i32 0, metadata !4, null}
!23 = metadata !{i32 786688, metadata !4, metadata !"p", metadata !5, i32 8, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 8]
!24 = metadata !{i32 8, i32 0, metadata !4, null} ; [ DW_TAG_imported_declaration ]
!25 = metadata !{i32 786688, metadata !4, metadata !"i", metadata !5, i32 9, metadata !26, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 9]
!26 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!27 = metadata !{i32 9, i32 0, metadata !4, null}
!28 = metadata !{i32 10, i32 0, metadata !29, null}
!29 = metadata !{i32 786443, metadata !1, metadata !4, i32 10, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test_pointer_assign.c]
!30 = metadata !{i32 11, i32 0, metadata !31, null}
!31 = metadata !{i32 786443, metadata !1, metadata !29, i32 10, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test_pointer_assign.c]
!32 = metadata !{i32 12, i32 0, metadata !31, null}
!33 = metadata !{i32 13, i32 0, metadata !4, null}
!34 = metadata !{i32 14, i32 0, metadata !35, null}
!35 = metadata !{i32 786443, metadata !1, metadata !4, i32 13, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test_pointer_assign.c]
!36 = metadata !{i32 15, i32 0, metadata !35, null}
!37 = metadata !{i32 16, i32 0, metadata !4, null}
!38 = metadata !{i32 17, i32 0, metadata !4, null}
