; ModuleID = 'multi-return.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind uwtable
define i8* @escape() #0 {
  %1 = alloca i8*, align 8
  %local_char = alloca i8, align 1
  %array = alloca [10 x i8], align 1
  %p2 = alloca i8*, align 8
  %p3 = alloca i8*, align 8
  %p4 = alloca i8*, align 8
  %p = alloca i8*, align 8
  %i = alloca i32, align 4
  call void @llvm.dbg.declare(metadata !{i8* %local_char}, metadata !13), !dbg !14
  store i8 97, i8* %local_char, align 1, !dbg !14
  call void @llvm.dbg.declare(metadata !{[10 x i8]* %array}, metadata !15), !dbg !19
  call void @llvm.dbg.declare(metadata !{i8** %p2}, metadata !20), !dbg !21
  store i8* %local_char, i8** %p2, align 8, !dbg !21
  call void @llvm.dbg.declare(metadata !{i8** %p3}, metadata !22), !dbg !23
  call void @llvm.dbg.declare(metadata !{i8** %p4}, metadata !24), !dbg !25
  call void @llvm.dbg.declare(metadata !{i8** %p}, metadata !26), !dbg !27
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !28), !dbg !30
  store i32 0, i32* %i, align 4, !dbg !30
  %2 = load i32* %i, align 4, !dbg !31
  %3 = icmp ne i32 %2, 0, !dbg !31
  br i1 %3, label %4, label %7, !dbg !31

; <label>:4                                       ; preds = %0
  %5 = load i8** %p2, align 8, !dbg !33
  store i8* %5, i8** %p3, align 8, !dbg !33
  %6 = load i8** %p3, align 8, !dbg !35
  store i8* %6, i8** %1, !dbg !35
  br label %16, !dbg !35

; <label>:7                                       ; preds = %0
  br label %8, !dbg !36

; <label>:8                                       ; preds = %7
  %9 = load i32* %i, align 4, !dbg !36
  %10 = icmp ne i32 %9, 0, !dbg !36
  br i1 %10, label %11, label %13, !dbg !36

; <label>:11                                      ; preds = %8
  %12 = load i8** %p3, align 8, !dbg !37
  store i8* %12, i8** %p4, align 8, !dbg !37
  store i8* %local_char, i8** %1, !dbg !39
  br label %16, !dbg !39

; <label>:13                                      ; preds = %8
  %14 = load i8** %p4, align 8, !dbg !40
  store i8* %14, i8** %p, align 8, !dbg !40
  %15 = load i8** %p, align 8, !dbg !41
  store i8* %15, i8** %1, !dbg !41
  br label %16, !dbg !41

; <label>:16                                      ; preds = %13, %11, %4
  %17 = load i8** %1, !dbg !42
  ret i8* %17, !dbg !42
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!10, !11}
!llvm.ident = !{!12}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !2, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/multi-return.c] [DW_LANG_C99]
!1 = metadata !{metadata !"multi-return.c", metadata !"/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"escape", metadata !"escape", metadata !"", i32 1, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i8* ()* @escape, null, null, metadata !2, i32 1} ; [ DW_TAG_subprogram ] [line 1] [def] [escape]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/multi-return.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8}
!8 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !9} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!9 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!10 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!11 = metadata !{i32 1, metadata !"Debug Info Version", i32 1}
!12 = metadata !{metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)"}
!13 = metadata !{i32 786688, metadata !4, metadata !"local_char", metadata !5, i32 2, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [local_char] [line 2]
!14 = metadata !{i32 2, i32 0, metadata !4, null}
!15 = metadata !{i32 786688, metadata !4, metadata !"array", metadata !5, i32 3, metadata !16, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [array] [line 3]
!16 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 80, i64 8, i32 0, i32 0, metadata !9, metadata !17, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 80, align 8, offset 0] [from char]
!17 = metadata !{metadata !18}
!18 = metadata !{i32 786465, i64 0, i64 10}       ; [ DW_TAG_subrange_type ] [0, 9]
!19 = metadata !{i32 3, i32 0, metadata !4, null}
!20 = metadata !{i32 786688, metadata !4, metadata !"p2", metadata !5, i32 4, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p2] [line 4]
!21 = metadata !{i32 4, i32 0, metadata !4, null}
!22 = metadata !{i32 786688, metadata !4, metadata !"p3", metadata !5, i32 5, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p3] [line 5]
!23 = metadata !{i32 5, i32 0, metadata !4, null}
!24 = metadata !{i32 786688, metadata !4, metadata !"p4", metadata !5, i32 6, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p4] [line 6]
!25 = metadata !{i32 6, i32 0, metadata !4, null}
!26 = metadata !{i32 786688, metadata !4, metadata !"p", metadata !5, i32 7, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 7]
!27 = metadata !{i32 7, i32 0, metadata !4, null}
!28 = metadata !{i32 786688, metadata !4, metadata !"i", metadata !5, i32 8, metadata !29, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 8]
!29 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!30 = metadata !{i32 8, i32 0, metadata !4, null} ; [ DW_TAG_imported_declaration ]
!31 = metadata !{i32 9, i32 0, metadata !32, null}
!32 = metadata !{i32 786443, metadata !1, metadata !4, i32 9, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/multi-return.c]
!33 = metadata !{i32 10, i32 0, metadata !34, null}
!34 = metadata !{i32 786443, metadata !1, metadata !32, i32 9, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/multi-return.c]
!35 = metadata !{i32 11, i32 0, metadata !34, null}
!36 = metadata !{i32 13, i32 0, metadata !4, null}
!37 = metadata !{i32 14, i32 0, metadata !38, null}
!38 = metadata !{i32 786443, metadata !1, metadata !4, i32 13, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/multi-return.c]
!39 = metadata !{i32 15, i32 0, metadata !38, null}
!40 = metadata !{i32 17, i32 0, metadata !4, null}
!41 = metadata !{i32 18, i32 0, metadata !4, null}
!42 = metadata !{i32 19, i32 0, metadata !4, null}
