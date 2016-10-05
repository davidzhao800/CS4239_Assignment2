; ModuleID = 'Sample.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"Hello World\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @g() #0 {
  ret i32 0, !dbg !16
}

; Function Attrs: nounwind uwtable
define void @f() #0 {
  %1 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([13 x i8]* @.str, i32 0, i32 0)), !dbg !17
  %2 = call i32 @g(), !dbg !18
  ret void, !dbg !19
}

declare i32 @printf(i8*, ...) #1

; Function Attrs: nounwind uwtable
define i32 @h() #0 {
  ret i32 1, !dbg !20
}

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!13, !14}
!llvm.ident = !{!15}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !2, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/student/Desktop/CS4239_Assignment2/1/llvm-examples/Sample.c] [DW_LANG_C99]
!1 = metadata !{metadata !"Sample.c", metadata !"/home/student/Desktop/CS4239_Assignment2/1/llvm-examples"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4, metadata !9, metadata !12}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"g", metadata !"g", metadata !"", i32 3, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32 ()* @g, null, null, metadata !2, i32 3} ; [ DW_TAG_subprogram ] [line 3] [def] [g]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/student/Desktop/CS4239_Assignment2/1/llvm-examples/Sample.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8}
!8 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!9 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"f", metadata !"f", metadata !"", i32 7, metadata !10, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, void ()* @f, null, null, metadata !2, i32 7} ; [ DW_TAG_subprogram ] [line 7] [def] [f]
!10 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !11, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!11 = metadata !{null}
!12 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"h", metadata !"h", metadata !"", i32 25, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32 ()* @h, null, null, metadata !2, i32 25} ; [ DW_TAG_subprogram ] [line 25] [def] [h]
!13 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!14 = metadata !{i32 1, metadata !"Debug Info Version", i32 1}
!15 = metadata !{metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)"}
!16 = metadata !{i32 4, i32 0, metadata !4, null}
!17 = metadata !{i32 8, i32 0, metadata !9, null} ; [ DW_TAG_imported_declaration ]
!18 = metadata !{i32 9, i32 0, metadata !9, null}
!19 = metadata !{i32 10, i32 0, metadata !9, null}
!20 = metadata !{i32 26, i32 0, metadata !12, null}
