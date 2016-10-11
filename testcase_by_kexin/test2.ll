; ModuleID = 'test2.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32* @f() #0 {
  %x = alloca i32, align 4
  %ptr_x = alloca i32*, align 8
  %ptr_y = alloca i32*, align 8
  call void @llvm.dbg.declare(metadata !{i32* %x}, metadata !20), !dbg !21
  store i32 0, i32* %x, align 4, !dbg !21
  call void @llvm.dbg.declare(metadata !{i32** %ptr_x}, metadata !22), !dbg !23
  store i32* %x, i32** %ptr_x, align 8, !dbg !23
  call void @llvm.dbg.declare(metadata !{i32** %ptr_y}, metadata !24), !dbg !25
  %1 = call noalias i8* @malloc(i64 4) #4, !dbg !25
  %2 = bitcast i8* %1 to i32*, !dbg !25
  store i32* %2, i32** %ptr_y, align 8, !dbg !25
  %3 = load i32** %ptr_y, align 8, !dbg !26
  store i32* %3, i32** %ptr_x, align 8, !dbg !26
  %4 = load i32** %ptr_x, align 8, !dbg !27
  ret i32* %4, !dbg !27
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #2

; Function Attrs: nounwind uwtable
define i32* @g() #0 {
  %array = alloca [100 x i32], align 16
  %p = alloca i32*, align 8
  %i = alloca i32, align 4
  call void @llvm.dbg.declare(metadata !{[100 x i32]* %array}, metadata !28), !dbg !32
  call void @llvm.dbg.declare(metadata !{i32** %p}, metadata !33), !dbg !34
  %1 = getelementptr inbounds [100 x i32]* %array, i32 0, i32 0, !dbg !34
  store i32* %1, i32** %p, align 8, !dbg !34
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !35), !dbg !36
  store i32 0, i32* %i, align 4, !dbg !37
  br label %2, !dbg !37

; <label>:2                                       ; preds = %10, %0
  %3 = load i32* %i, align 4, !dbg !37
  %4 = icmp slt i32 %3, 10, !dbg !37
  br i1 %4, label %5, label %13, !dbg !37

; <label>:5                                       ; preds = %2
  %6 = load i32* %i, align 4, !dbg !39
  %7 = icmp sgt i32 %6, 10, !dbg !39
  br i1 %7, label %8, label %9, !dbg !39

; <label>:8                                       ; preds = %5
  store i32* null, i32** %p, align 8, !dbg !42
  br label %9, !dbg !44

; <label>:9                                       ; preds = %8, %5
  br label %10, !dbg !45

; <label>:10                                      ; preds = %9
  %11 = load i32* %i, align 4, !dbg !37
  %12 = add nsw i32 %11, 1, !dbg !37
  store i32 %12, i32* %i, align 4, !dbg !37
  br label %2, !dbg !37

; <label>:13                                      ; preds = %2
  %14 = load i32** %p, align 8, !dbg !46
  ret i32* %14, !dbg !46
}

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i8**, align 8
  store i32 %argc, i32* %1, align 4
  call void @llvm.dbg.declare(metadata !{i32* %1}, metadata !47), !dbg !48
  store i8** %argv, i8*** %2, align 8
  call void @llvm.dbg.declare(metadata !{i8*** %2}, metadata !49), !dbg !48
  %3 = call i32* @f(), !dbg !50
  %4 = load i32* %3, align 4, !dbg !50
  %5 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str, i32 0, i32 0), i32 %4), !dbg !50
  %6 = call i32* @g(), !dbg !51
  %7 = load i32* %6, align 4, !dbg !51
  %8 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str, i32 0, i32 0), i32 %7), !dbg !51
  ret i32 0, !dbg !52
}

declare i32 @printf(i8*, ...) #3

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!17, !18}
!llvm.ident = !{!19}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !2, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test2.c] [DW_LANG_C99]
!1 = metadata !{metadata !"test2.c", metadata !"/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4, metadata !10, metadata !11}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"f", metadata !"f", metadata !"", i32 4, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32* ()* @f, null, null, metadata !2, i32 4} ; [ DW_TAG_subprogram ] [line 4] [def] [f]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test2.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8}
!8 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !9} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from int]
!9 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!10 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"g", metadata !"g", metadata !"", i32 12, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32* ()* @g, null, null, metadata !2, i32 12} ; [ DW_TAG_subprogram ] [line 12] [def] [g]
!11 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"main", metadata !"main", metadata !"", i32 25, metadata !12, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, i8**)* @main, null, null, metadata !2, i32 25} ; [ DW_TAG_subprogram ] [line 25] [def] [main]
!12 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !13, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!13 = metadata !{metadata !9, metadata !9, metadata !14}
!14 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !15} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!15 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !16} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!16 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!17 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!18 = metadata !{i32 1, metadata !"Debug Info Version", i32 1}
!19 = metadata !{metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)"}
!20 = metadata !{i32 786688, metadata !4, metadata !"x", metadata !5, i32 5, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [x] [line 5]
!21 = metadata !{i32 5, i32 0, metadata !4, null}
!22 = metadata !{i32 786688, metadata !4, metadata !"ptr_x", metadata !5, i32 6, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ptr_x] [line 6]
!23 = metadata !{i32 6, i32 0, metadata !4, null}
!24 = metadata !{i32 786688, metadata !4, metadata !"ptr_y", metadata !5, i32 7, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ptr_y] [line 7]
!25 = metadata !{i32 7, i32 0, metadata !4, null}
!26 = metadata !{i32 8, i32 0, metadata !4, null} ; [ DW_TAG_imported_declaration ]
!27 = metadata !{i32 9, i32 0, metadata !4, null}
!28 = metadata !{i32 786688, metadata !10, metadata !"array", metadata !5, i32 13, metadata !29, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [array] [line 13]
!29 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 3200, i64 32, i32 0, i32 0, metadata !9, metadata !30, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 3200, align 32, offset 0] [from int]
!30 = metadata !{metadata !31}
!31 = metadata !{i32 786465, i64 0, i64 100}      ; [ DW_TAG_subrange_type ] [0, 99]
!32 = metadata !{i32 13, i32 0, metadata !10, null}
!33 = metadata !{i32 786688, metadata !10, metadata !"p", metadata !5, i32 14, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 14]
!34 = metadata !{i32 14, i32 0, metadata !10, null}
!35 = metadata !{i32 786688, metadata !10, metadata !"i", metadata !5, i32 15, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 15]
!36 = metadata !{i32 15, i32 0, metadata !10, null}
!37 = metadata !{i32 16, i32 0, metadata !38, null}
!38 = metadata !{i32 786443, metadata !1, metadata !10, i32 16, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test2.c]
!39 = metadata !{i32 17, i32 0, metadata !40, null}
!40 = metadata !{i32 786443, metadata !1, metadata !41, i32 17, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test2.c]
!41 = metadata !{i32 786443, metadata !1, metadata !38, i32 16, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test2.c]
!42 = metadata !{i32 18, i32 0, metadata !43, null}
!43 = metadata !{i32 786443, metadata !1, metadata !40, i32 17, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test2.c]
!44 = metadata !{i32 19, i32 0, metadata !43, null}
!45 = metadata !{i32 20, i32 0, metadata !41, null}
!46 = metadata !{i32 21, i32 0, metadata !10, null}
!47 = metadata !{i32 786689, metadata !11, metadata !"argc", metadata !5, i32 16777241, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [argc] [line 25]
!48 = metadata !{i32 25, i32 0, metadata !11, null}
!49 = metadata !{i32 786689, metadata !11, metadata !"argv", metadata !5, i32 33554457, metadata !14, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [argv] [line 25]
!50 = metadata !{i32 26, i32 0, metadata !11, null}
!51 = metadata !{i32 27, i32 0, metadata !11, null}
!52 = metadata !{i32 28, i32 0, metadata !11, null}
