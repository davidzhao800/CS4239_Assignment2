; ModuleID = 'example/exp36-1.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [9 x i8] c"cp == &c\00", align 1
@.str1 = private unnamed_addr constant [18 x i8] c"example/exp36-1.c\00", align 1
@__PRETTY_FUNCTION__.func = private unnamed_addr constant [12 x i8] c"void func()\00", align 1

; Function Attrs: nounwind uwtable
define void @func() #0 {
  %c = alloca i8, align 1
  %ip = alloca i32*, align 8
  %cp = alloca i8*, align 8
  call void @llvm.dbg.declare(metadata !{i8* %c}, metadata !11), !dbg !13
  store i8 120, i8* %c, align 1, !dbg !13
  call void @llvm.dbg.declare(metadata !{i32** %ip}, metadata !14), !dbg !17
  %1 = bitcast i8* %c to i32*, !dbg !17
  store i32* %1, i32** %ip, align 8, !dbg !17
  call void @llvm.dbg.declare(metadata !{i8** %cp}, metadata !18), !dbg !20
  %2 = load i32** %ip, align 8, !dbg !20
  %3 = bitcast i32* %2 to i8*, !dbg !20
  store i8* %3, i8** %cp, align 8, !dbg !20
  %4 = load i8** %cp, align 8, !dbg !21
  %5 = icmp eq i8* %4, %c, !dbg !21
  br i1 %5, label %6, label %7, !dbg !21

; <label>:6                                       ; preds = %0
  br label %9, !dbg !21

; <label>:7                                       ; preds = %0
  call void @__assert_fail(i8* getelementptr inbounds ([9 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([18 x i8]* @.str1, i32 0, i32 0), i32 9, i8* getelementptr inbounds ([12 x i8]* @__PRETTY_FUNCTION__.func, i32 0, i32 0)) #3, !dbg !21
  unreachable, !dbg !21
                                                  ; No predecessors!
  br label %9, !dbg !21

; <label>:9                                       ; preds = %8, %6
  ret void, !dbg !22
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8*, i8*, i32, i8*) #2

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { noreturn nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noreturn nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!8, !9}
!llvm.ident = !{!10}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !2, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/cs4239/Downloads/llvm-examples/example/exp36-1.c] [DW_LANG_C99]
!1 = metadata !{metadata !"example/exp36-1.c", metadata !"/home/cs4239/Downloads/llvm-examples"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"func", metadata !"func", metadata !"", i32 3, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void ()* @func, null, null, metadata !2, i32 3} ; [ DW_TAG_subprogram ] [line 3] [def] [func]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/cs4239/Downloads/llvm-examples/example/exp36-1.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{null}
!8 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!9 = metadata !{i32 1, metadata !"Debug Info Version", i32 1}
!10 = metadata !{metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)"}
!11 = metadata !{i32 786688, metadata !4, metadata !"c", metadata !5, i32 4, metadata !12, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [c] [line 4]
!12 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!13 = metadata !{i32 4, i32 0, metadata !4, null}
!14 = metadata !{i32 786688, metadata !4, metadata !"ip", metadata !5, i32 5, metadata !15, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ip] [line 5]
!15 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !16} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from int]
!16 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!17 = metadata !{i32 5, i32 0, metadata !4, null}
!18 = metadata !{i32 786688, metadata !4, metadata !"cp", metadata !5, i32 6, metadata !19, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [cp] [line 6]
!19 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !12} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!20 = metadata !{i32 6, i32 0, metadata !4, null}
!21 = metadata !{i32 9, i32 0, metadata !4, null}
!22 = metadata !{i32 10, i32 0, metadata !4, null}
