; ModuleID = 'test1.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i8**, align 8
  store i32 %argc, i32* %1, align 4
  call void @llvm.dbg.declare(metadata !{i32* %1}, metadata !19), !dbg !20
  store i8** %argv, i8*** %2, align 8
  call void @llvm.dbg.declare(metadata !{i8*** %2}, metadata !21), !dbg !20
  %3 = call i32* @f(), !dbg !22
  %4 = load i32* %3, align 4, !dbg !22
  %5 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str, i32 0, i32 0), i32 %4), !dbg !22
  ret i32 0, !dbg !23
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

declare i32 @printf(i8*, ...) #2

; Function Attrs: nounwind uwtable
define i32* @f() #0 {
  %num = alloca i32*, align 8
  %p = alloca i32**, align 8
  call void @llvm.dbg.declare(metadata !{i32** %num}, metadata !24), !dbg !25
  %1 = call noalias i8* @malloc(i64 4) #4, !dbg !25
  %2 = bitcast i8* %1 to i32*, !dbg !25
  store i32* %2, i32** %num, align 8, !dbg !25
  %3 = load i32** %num, align 8, !dbg !26
  store i32 1, i32* %3, align 4, !dbg !26
  call void @llvm.dbg.declare(metadata !{i32*** %p}, metadata !27), !dbg !29
  store i32** %num, i32*** %p, align 8, !dbg !29
  %4 = load i32*** %p, align 8, !dbg !30
  %5 = load i32** %4, align 8, !dbg !30
  ret i32* %5, !dbg !30
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #3

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!16, !17}
!llvm.ident = !{!18}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !2, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test1.c] [DW_LANG_C99]
!1 = metadata !{metadata !"test1.c", metadata !"/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4, metadata !12}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"main", metadata !"main", metadata !"", i32 6, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, i8**)* @main, null, null, metadata !2, i32 6} ; [ DW_TAG_subprogram ] [line 6] [def] [main]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test1.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8, metadata !8, metadata !9}
!8 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!9 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !10} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!10 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!11 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!12 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"f", metadata !"f", metadata !"", i32 10, metadata !13, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32* ()* @f, null, null, metadata !2, i32 10} ; [ DW_TAG_subprogram ] [line 10] [def] [f]
!13 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !14, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!14 = metadata !{metadata !15}
!15 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !8} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from int]
!16 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!17 = metadata !{i32 1, metadata !"Debug Info Version", i32 1}
!18 = metadata !{metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)"}
!19 = metadata !{i32 786689, metadata !4, metadata !"argc", metadata !5, i32 16777222, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [argc] [line 6]
!20 = metadata !{i32 6, i32 0, metadata !4, null}
!21 = metadata !{i32 786689, metadata !4, metadata !"argv", metadata !5, i32 33554438, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [argv] [line 6]
!22 = metadata !{i32 7, i32 0, metadata !4, null}
!23 = metadata !{i32 8, i32 0, metadata !4, null} ; [ DW_TAG_imported_declaration ]
!24 = metadata !{i32 786688, metadata !12, metadata !"num", metadata !5, i32 11, metadata !15, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [num] [line 11]
!25 = metadata !{i32 11, i32 0, metadata !12, null}
!26 = metadata !{i32 12, i32 0, metadata !12, null}
!27 = metadata !{i32 786688, metadata !12, metadata !"p", metadata !5, i32 13, metadata !28, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 13]
!28 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !15} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!29 = metadata !{i32 13, i32 0, metadata !12, null}
!30 = metadata !{i32 14, i32 0, metadata !12, null}
