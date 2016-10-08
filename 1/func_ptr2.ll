; ModuleID = 'func_ptr2.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1

; Function Attrs: nounwind uwtable
define i32 @f(i32 %i) #0 {
  %1 = alloca i32, align 4
  store i32 %i, i32* %1, align 4
  call void @llvm.dbg.declare(metadata !{i32* %1}, metadata !20), !dbg !21
  %2 = load i32* %1, align 4, !dbg !22
  %3 = add nsw i32 %2, 1, !dbg !22
  store i32 %3, i32* %1, align 4, !dbg !22
  ret i32 %2, !dbg !22
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: nounwind uwtable
define i32 @g(i32 %i) #0 {
  %1 = alloca i32, align 4
  store i32 %i, i32* %1, align 4
  call void @llvm.dbg.declare(metadata !{i32* %1}, metadata !23), !dbg !24
  %2 = load i32* %1, align 4, !dbg !25
  %3 = add nsw i32 %2, 1, !dbg !25
  store i32 %3, i32* %1, align 4, !dbg !25
  ret i32 %3, !dbg !25
}

; Function Attrs: nounwind uwtable
define i32 @h(i8 signext %c) #0 {
  %1 = alloca i8, align 1
  store i8 %c, i8* %1, align 1
  call void @llvm.dbg.declare(metadata !{i8* %1}, metadata !26), !dbg !27
  %2 = load i8* %1, align 1, !dbg !28
  %3 = sext i8 %2 to i32, !dbg !28
  ret i32 %3, !dbg !28
}

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %i = alloca i32, align 4
  %ptr = alloca i32 (i32)*, align 8
  store i32 0, i32* %1
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !29), !dbg !30
  store i32 0, i32* %i, align 4, !dbg !30
  call void @llvm.dbg.declare(metadata !{i32 (i32)** %ptr}, metadata !31), !dbg !33
  %2 = call i32 (i8*, ...)* @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8]* @.str, i32 0, i32 0), i32* %i), !dbg !34
  %3 = load i32* %i, align 4, !dbg !35
  %4 = icmp sgt i32 %3, 0, !dbg !35
  br i1 %4, label %5, label %6, !dbg !35

; <label>:5                                       ; preds = %0
  store i32 (i32)* @f, i32 (i32)** %ptr, align 8, !dbg !37
  br label %7, !dbg !39

; <label>:6                                       ; preds = %0
  store i32 (i32)* @g, i32 (i32)** %ptr, align 8, !dbg !40
  br label %7

; <label>:7                                       ; preds = %6, %5
  %8 = load i32 (i32)** %ptr, align 8, !dbg !42
  %9 = call i32 %8(i32 256), !dbg !42
  %10 = load i32* %1, !dbg !43
  ret i32 %10, !dbg !43
}

declare i32 @__isoc99_scanf(i8*, ...) #2

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!17, !18}
!llvm.ident = !{!19}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !2, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/student/Desktop/CS4239_Assignment2/1/func_ptr2.c] [DW_LANG_C99]
!1 = metadata !{metadata !"func_ptr2.c", metadata !"/home/student/Desktop/CS4239_Assignment2/1"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4, metadata !9, metadata !10, metadata !14}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"f", metadata !"f", metadata !"", i32 3, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32)* @f, null, null, metadata !2, i32 3} ; [ DW_TAG_subprogram ] [line 3] [def] [f]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/student/Desktop/CS4239_Assignment2/1/func_ptr2.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8, metadata !8}
!8 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!9 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"g", metadata !"g", metadata !"", i32 7, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32)* @g, null, null, metadata !2, i32 7} ; [ DW_TAG_subprogram ] [line 7] [def] [g]
!10 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"h", metadata !"h", metadata !"", i32 11, metadata !11, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i8)* @h, null, null, metadata !2, i32 11} ; [ DW_TAG_subprogram ] [line 11] [def] [h]
!11 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !12, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!12 = metadata !{metadata !8, metadata !13}
!13 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!14 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"main", metadata !"main", metadata !"", i32 15, metadata !15, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32 ()* @main, null, null, metadata !2, i32 15} ; [ DW_TAG_subprogram ] [line 15] [def] [main]
!15 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !16, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!16 = metadata !{metadata !8}
!17 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!18 = metadata !{i32 1, metadata !"Debug Info Version", i32 1}
!19 = metadata !{metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)"}
!20 = metadata !{i32 786689, metadata !4, metadata !"i", metadata !5, i32 16777219, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [i] [line 3]
!21 = metadata !{i32 3, i32 0, metadata !4, null}
!22 = metadata !{i32 4, i32 0, metadata !4, null}
!23 = metadata !{i32 786689, metadata !9, metadata !"i", metadata !5, i32 16777223, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [i] [line 7]
!24 = metadata !{i32 7, i32 0, metadata !9, null}
!25 = metadata !{i32 8, i32 0, metadata !9, null} ; [ DW_TAG_imported_declaration ]
!26 = metadata !{i32 786689, metadata !10, metadata !"c", metadata !5, i32 16777227, metadata !13, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [c] [line 11]
!27 = metadata !{i32 11, i32 0, metadata !10, null}
!28 = metadata !{i32 12, i32 0, metadata !10, null}
!29 = metadata !{i32 786688, metadata !14, metadata !"i", metadata !5, i32 16, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 16]
!30 = metadata !{i32 16, i32 0, metadata !14, null}
!31 = metadata !{i32 786688, metadata !14, metadata !"ptr", metadata !5, i32 17, metadata !32, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ptr] [line 17]
!32 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !6} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!33 = metadata !{i32 17, i32 0, metadata !14, null}
!34 = metadata !{i32 19, i32 0, metadata !14, null}
!35 = metadata !{i32 20, i32 0, metadata !36, null}
!36 = metadata !{i32 786443, metadata !1, metadata !14, i32 20, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/student/Desktop/CS4239_Assignment2/1/func_ptr2.c]
!37 = metadata !{i32 21, i32 0, metadata !38, null}
!38 = metadata !{i32 786443, metadata !1, metadata !36, i32 20, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/student/Desktop/CS4239_Assignment2/1/func_ptr2.c]
!39 = metadata !{i32 22, i32 0, metadata !38, null}
!40 = metadata !{i32 25, i32 0, metadata !41, null}
!41 = metadata !{i32 786443, metadata !1, metadata !36, i32 24, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/student/Desktop/CS4239_Assignment2/1/func_ptr2.c]
!42 = metadata !{i32 28, i32 0, metadata !14, null}
!43 = metadata !{i32 29, i32 0, metadata !14, null}
