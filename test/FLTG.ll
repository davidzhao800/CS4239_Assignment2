; ModuleID = 'FLTG.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@global_array = common global [10 x i8] zeroinitializer, align 1

; Function Attrs: nounwind uwtable
define i8* @init_array() #0 {
  %heap = alloca i8*, align 8
  %array = alloca [10 x i8], align 1
  %p = alloca i8*, align 8
  %i = alloca i32, align 4
  call void @llvm.dbg.declare(metadata !{i8** %heap}, metadata !18), !dbg !19
  %1 = call noalias i8* @malloc(i64 10) #3, !dbg !19
  store i8* %1, i8** %heap, align 8, !dbg !19
  call void @llvm.dbg.declare(metadata !{[10 x i8]* %array}, metadata !20), !dbg !21
  call void @llvm.dbg.declare(metadata !{i8** %p}, metadata !22), !dbg !23
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !24), !dbg !26
  store i32 1, i32* %i, align 4, !dbg !26
  %2 = getelementptr inbounds [10 x i8]* %array, i32 0, i32 0, !dbg !27
  store i8* %2, i8** %p, align 8, !dbg !27
  store i8* getelementptr inbounds ([10 x i8]* @global_array, i32 0, i32 0), i8** %p, align 8, !dbg !28
  %3 = load i8** %p, align 8, !dbg !29
  ret i8* %3, !dbg !29
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #2

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!15, !16}
!llvm.ident = !{!17}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !10, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/cs4239/Documents/CS4239_Assignment2/test/FLTG.c] [DW_LANG_C99]
!1 = metadata !{metadata !"FLTG.c", metadata !"/home/cs4239/Documents/CS4239_Assignment2/test"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"init_array", metadata !"init_array", metadata !"", i32 3, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* ()* @init_array, null, null, metadata !2, i32 3} ; [ DW_TAG_subprogram ] [line 3] [def] [init_array]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/cs4239/Documents/CS4239_Assignment2/test/FLTG.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8}
!8 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !9} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!9 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!10 = metadata !{metadata !11}
!11 = metadata !{i32 786484, i32 0, null, metadata !"global_array", metadata !"global_array", metadata !"", metadata !5, i32 2, metadata !12, i32 0, i32 1, [10 x i8]* @global_array, null} ; [ DW_TAG_variable ] [global_array] [line 2] [def]
!12 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 80, i64 8, i32 0, i32 0, metadata !9, metadata !13, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 80, align 8, offset 0] [from char]
!13 = metadata !{metadata !14}
!14 = metadata !{i32 786465, i64 0, i64 10}       ; [ DW_TAG_subrange_type ] [0, 9]
!15 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!16 = metadata !{i32 1, metadata !"Debug Info Version", i32 1}
!17 = metadata !{metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)"}
!18 = metadata !{i32 786688, metadata !4, metadata !"heap", metadata !5, i32 4, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [heap] [line 4]
!19 = metadata !{i32 4, i32 0, metadata !4, null}
!20 = metadata !{i32 786688, metadata !4, metadata !"array", metadata !5, i32 5, metadata !12, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [array] [line 5]
!21 = metadata !{i32 5, i32 0, metadata !4, null}
!22 = metadata !{i32 786688, metadata !4, metadata !"p", metadata !5, i32 6, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 6]
!23 = metadata !{i32 6, i32 0, metadata !4, null}
!24 = metadata !{i32 786688, metadata !4, metadata !"i", metadata !5, i32 7, metadata !25, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 7]
!25 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!26 = metadata !{i32 7, i32 0, metadata !4, null}
!27 = metadata !{i32 8, i32 0, metadata !4, null} ; [ DW_TAG_imported_declaration ]
!28 = metadata !{i32 9, i32 0, metadata !4, null}
!29 = metadata !{i32 10, i32 0, metadata !4, null}
