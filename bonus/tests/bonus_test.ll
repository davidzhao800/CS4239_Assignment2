; ModuleID = 'bonus_test.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@b = global i8 99, align 1
@global = global i32 1, align 4
@globalptr = common global i8* null, align 8
@h.str = private unnamed_addr constant [20 x i8] c"Hello World\00\00\00\00\00\00\00\00\00", align 16
@global_char_ptr = common global i8* null, align 8
@.str = private unnamed_addr constant [3 x i8] c"%d\00", align 1

; Function Attrs: nounwind uwtable
define void @sample_test(i8** %argptr) #0 {
  %1 = alloca i8**, align 8
  %local_char = alloca i8, align 1
  %array = alloca [10 x i8], align 1
  store i8** %argptr, i8*** %1, align 8
  call void @llvm.dbg.declare(metadata !{i8*** %1}, metadata !35), !dbg !36
  call void @llvm.dbg.declare(metadata !{i8* %local_char}, metadata !37), !dbg !38
  store i8 97, i8* %local_char, align 1, !dbg !38
  call void @llvm.dbg.declare(metadata !{[10 x i8]* %array}, metadata !39), !dbg !43
  %2 = load i8*** %1, align 8, !dbg !44
  store i8* %local_char, i8** %2, align 8, !dbg !44
  %3 = getelementptr inbounds [10 x i8]* %array, i32 0, i32 0, !dbg !45
  store i8* %3, i8** @globalptr, align 8, !dbg !45
  ret void, !dbg !46
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: nounwind uwtable
define void @sample_test2(i8** %argptr, i8* %aChar, i32 %aInt) #0 {
  %1 = alloca i8**, align 8
  %2 = alloca i8*, align 8
  %3 = alloca i32, align 4
  %local_char = alloca i8, align 1
  %array = alloca [10 x i8], align 1
  store i8** %argptr, i8*** %1, align 8
  call void @llvm.dbg.declare(metadata !{i8*** %1}, metadata !47), !dbg !48
  store i8* %aChar, i8** %2, align 8
  call void @llvm.dbg.declare(metadata !{i8** %2}, metadata !49), !dbg !48
  store i32 %aInt, i32* %3, align 4
  call void @llvm.dbg.declare(metadata !{i32* %3}, metadata !50), !dbg !48
  call void @llvm.dbg.declare(metadata !{i8* %local_char}, metadata !51), !dbg !52
  store i8 97, i8* %local_char, align 1, !dbg !52
  call void @llvm.dbg.declare(metadata !{[10 x i8]* %array}, metadata !53), !dbg !54
  %4 = getelementptr inbounds [10 x i8]* %array, i32 0, i32 0, !dbg !55
  %5 = load i8*** %1, align 8, !dbg !55
  store i8* %4, i8** %5, align 8, !dbg !55
  store i8* %local_char, i8** @globalptr, align 8, !dbg !56
  ret void, !dbg !57
}

; Function Attrs: nounwind uwtable
define void @global_local_pointer_same() #0 {
  %local_char = alloca i8, align 1
  %p2 = alloca i8*, align 8
  %p3 = alloca i8*, align 8
  %p4 = alloca i8*, align 8
  %p = alloca i8*, align 8
  %i = alloca i32, align 4
  call void @llvm.dbg.declare(metadata !{i8* %local_char}, metadata !58), !dbg !59
  store i8 97, i8* %local_char, align 1, !dbg !59
  call void @llvm.dbg.declare(metadata !{i8** %p2}, metadata !60), !dbg !61
  store i8* %local_char, i8** %p2, align 8, !dbg !61
  call void @llvm.dbg.declare(metadata !{i8** %p3}, metadata !62), !dbg !63
  call void @llvm.dbg.declare(metadata !{i8** %p4}, metadata !64), !dbg !65
  call void @llvm.dbg.declare(metadata !{i8** %p}, metadata !66), !dbg !67
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !68), !dbg !69
  store i32 0, i32* %i, align 4, !dbg !69
  %1 = load i32* %i, align 4, !dbg !70
  %2 = icmp ne i32 %1, 0, !dbg !70
  br i1 %2, label %3, label %5, !dbg !70

; <label>:3                                       ; preds = %0
  %4 = load i8** %p2, align 8, !dbg !72
  store i8* %4, i8** %p3, align 8, !dbg !72
  br label %5, !dbg !74

; <label>:5                                       ; preds = %3, %0
  br label %6, !dbg !75

; <label>:6                                       ; preds = %9, %5
  %7 = load i32* %i, align 4, !dbg !75
  %8 = icmp ne i32 %7, 0, !dbg !75
  br i1 %8, label %9, label %11, !dbg !75

; <label>:9                                       ; preds = %6
  %10 = load i8** %p3, align 8, !dbg !76
  store i8* %10, i8** %p4, align 8, !dbg !76
  br label %6, !dbg !78

; <label>:11                                      ; preds = %6
  %12 = load i8** %p4, align 8, !dbg !79
  store i8* %12, i8** %p, align 8, !dbg !79
  %13 = load i8** %p, align 8, !dbg !80
  store i8* %13, i8** @globalptr, align 8, !dbg !80
  ret void, !dbg !81
}

; Function Attrs: nounwind uwtable
define void @something_realated_to_switch_array(i8** %argptr) #0 {
  %1 = alloca i8**, align 8
  %local_array = alloca [10 x i8], align 1
  %i = alloca i32, align 4
  store i8** %argptr, i8*** %1, align 8
  call void @llvm.dbg.declare(metadata !{i8*** %1}, metadata !82), !dbg !83
  call void @llvm.dbg.declare(metadata !{[10 x i8]* %local_array}, metadata !84), !dbg !85
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !86), !dbg !87
  %2 = load i32* %i, align 4, !dbg !88
  switch i32 %2, label %9 [
    i32 1, label %3
    i32 2, label %5
  ], !dbg !88

; <label>:3                                       ; preds = %0
  %4 = getelementptr inbounds [10 x i8]* %local_array, i32 0, i64 2, !dbg !89
  store i8* %4, i8** @globalptr, align 8, !dbg !89
  br label %10, !dbg !91

; <label>:5                                       ; preds = %0
  %6 = getelementptr inbounds [10 x i8]* %local_array, i32 0, i32 0, !dbg !92
  %7 = getelementptr inbounds i8* %6, i64 1, !dbg !92
  %8 = load i8*** %1, align 8, !dbg !92
  store i8* %7, i8** %8, align 8, !dbg !92
  br label %10, !dbg !93

; <label>:9                                       ; preds = %0
  br label %10, !dbg !94

; <label>:10                                      ; preds = %9, %5, %3
  ret void, !dbg !95
}

; Function Attrs: nounwind uwtable
define i32* @f() #0 {
  %x = alloca i32, align 4
  %ptr_x = alloca i32*, align 8
  %ptr_y = alloca i32*, align 8
  call void @llvm.dbg.declare(metadata !{i32* %x}, metadata !96), !dbg !97
  store i32 0, i32* %x, align 4, !dbg !97
  call void @llvm.dbg.declare(metadata !{i32** %ptr_x}, metadata !98), !dbg !99
  store i32* %x, i32** %ptr_x, align 8, !dbg !99
  call void @llvm.dbg.declare(metadata !{i32** %ptr_y}, metadata !100), !dbg !101
  %1 = call noalias i8* @malloc(i64 4) #3, !dbg !101
  %2 = bitcast i8* %1 to i32*, !dbg !101
  store i32* %2, i32** %ptr_y, align 8, !dbg !101
  %3 = load i32** %ptr_y, align 8, !dbg !102
  store i32* %3, i32** %ptr_x, align 8, !dbg !102
  %4 = load i32** %ptr_x, align 8, !dbg !103
  ret i32* %4, !dbg !103
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #2

; Function Attrs: nounwind uwtable
define i32* @g() #0 {
  %array = alloca [100 x i32], align 16
  %p = alloca i32*, align 8
  %i = alloca i32, align 4
  call void @llvm.dbg.declare(metadata !{[100 x i32]* %array}, metadata !104), !dbg !108
  call void @llvm.dbg.declare(metadata !{i32** %p}, metadata !109), !dbg !110
  %1 = getelementptr inbounds [100 x i32]* %array, i32 0, i32 0, !dbg !110
  store i32* %1, i32** %p, align 8, !dbg !110
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !111), !dbg !112
  store i32 0, i32* %i, align 4, !dbg !113
  br label %2, !dbg !113

; <label>:2                                       ; preds = %10, %0
  %3 = load i32* %i, align 4, !dbg !113
  %4 = icmp slt i32 %3, 10, !dbg !113
  br i1 %4, label %5, label %13, !dbg !113

; <label>:5                                       ; preds = %2
  %6 = load i32* %i, align 4, !dbg !115
  %7 = icmp sgt i32 %6, 10, !dbg !115
  br i1 %7, label %8, label %9, !dbg !115

; <label>:8                                       ; preds = %5
  store i32* null, i32** %p, align 8, !dbg !118
  br label %9, !dbg !120

; <label>:9                                       ; preds = %8, %5
  br label %10, !dbg !121

; <label>:10                                      ; preds = %9
  %11 = load i32* %i, align 4, !dbg !113
  %12 = add nsw i32 %11, 1, !dbg !113
  store i32 %12, i32* %i, align 4, !dbg !113
  br label %2, !dbg !113

; <label>:13                                      ; preds = %2
  %14 = load i32** %p, align 8, !dbg !122
  ret i32* %14, !dbg !122
}

; Function Attrs: nounwind uwtable
define i8* @h(i32* %n) #0 {
  %1 = alloca i32*, align 8
  %str = alloca [20 x i8], align 16
  %i = alloca i32, align 4
  %str2 = alloca i8*, align 8
  store i32* %n, i32** %1, align 8
  call void @llvm.dbg.declare(metadata !{i32** %1}, metadata !123), !dbg !124
  call void @llvm.dbg.declare(metadata !{[20 x i8]* %str}, metadata !125), !dbg !129
  %2 = bitcast [20 x i8]* %str to i8*, !dbg !129
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %2, i8* getelementptr inbounds ([20 x i8]* @h.str, i32 0, i32 0), i64 20, i32 16, i1 false), !dbg !129
  %3 = getelementptr inbounds [20 x i8]* %str, i32 0, i32 0, !dbg !130
  store i8* %3, i8** @global_char_ptr, align 8, !dbg !130
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !131), !dbg !132
  %4 = call i32 (i8*, ...)* @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8]* @.str, i32 0, i32 0), i32* %i), !dbg !133
  %5 = load i32* %i, align 4, !dbg !134
  %6 = icmp sge i32 %5, 0, !dbg !134
  br i1 %6, label %7, label %8, !dbg !134

; <label>:7                                       ; preds = %0
  store i32* @global, i32** %1, align 8, !dbg !136
  br label %9, !dbg !138

; <label>:8                                       ; preds = %0
  store i32* %i, i32** %1, align 8, !dbg !139
  br label %9

; <label>:9                                       ; preds = %8, %7
  br label %10, !dbg !141

; <label>:10                                      ; preds = %13, %9
  %11 = load i32* %i, align 4, !dbg !141
  %12 = icmp ne i32 %11, 0, !dbg !141
  br i1 %12, label %13, label %14, !dbg !141

; <label>:13                                      ; preds = %10
  store i32* null, i32** %1, align 8, !dbg !142
  store i32 0, i32* %i, align 4, !dbg !144
  br label %10, !dbg !145

; <label>:14                                      ; preds = %10
  call void @llvm.dbg.declare(metadata !{i8** %str2}, metadata !146), !dbg !147
  %15 = getelementptr inbounds [20 x i8]* %str, i32 0, i32 0, !dbg !147
  store i8* %15, i8** %str2, align 8, !dbg !147
  %16 = load i8** %str2, align 8, !dbg !148
  ret i8* %16, !dbg !148
}

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #3

declare i32 @__isoc99_scanf(i8*, ...) #4

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }
attributes #4 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!32, !33}
!llvm.ident = !{!34}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !27, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/student/Desktop/CS4239_Assignment2/bonus/tests/bonus_test.c] [DW_LANG_C99]
!1 = metadata !{metadata !"bonus_test.c", metadata !"/home/student/Desktop/CS4239_Assignment2/bonus/tests"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4, metadata !11, metadata !15, metadata !18, metadata !19, metadata !23, metadata !24}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"sample_test", metadata !"sample_test", metadata !"", i32 9, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i8**)* @sample_test, null, null, metadata !2, i32 9} ; [ DW_TAG_subprogram ] [line 9] [def] [sample_test]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/student/Desktop/CS4239_Assignment2/bonus/tests/bonus_test.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{null, metadata !8}
!8 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !9} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!9 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !10} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!10 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!11 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"sample_test2", metadata !"sample_test2", metadata !"", i32 16, metadata !12, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i8**, i8*, i32)* @sample_test2, null, null, metadata !2, i32 16} ; [ DW_TAG_subprogram ] [line 16] [def] [sample_test2]
!12 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !13, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!13 = metadata !{null, metadata !8, metadata !9, metadata !14}
!14 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!15 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"global_local_pointer_same", metadata !"global_local_pointer_same", metadata !"", i32 23, metadata !16, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, void ()* @global_local_pointer_same, null, null, metadata !2, i32 23} ; [ DW_TAG_subprogram ] [line 23] [def] [global_local_pointer_same]
!16 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !17, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!17 = metadata !{null}
!18 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"something_realated_to_switch_array", metadata !"something_realated_to_switch_array", metadata !"", i32 40, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i8**)* @something_realated_to_switch_array, null, null, metadata !2, i32 40} ; [ DW_TAG_subprogram ] [line 40] [def] [something_realated_to_switch_array]
!19 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"f", metadata !"f", metadata !"", i32 56, metadata !20, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32* ()* @f, null, null, metadata !2, i32 56} ; [ DW_TAG_subprogram ] [line 56] [def] [f]
!20 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !21, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!21 = metadata !{metadata !22}
!22 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !14} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from int]
!23 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"g", metadata !"g", metadata !"", i32 64, metadata !20, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i32* ()* @g, null, null, metadata !2, i32 64} ; [ DW_TAG_subprogram ] [line 64] [def] [g]
!24 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"h", metadata !"h", metadata !"", i32 76, metadata !25, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i32*)* @h, null, null, metadata !2, i32 76} ; [ DW_TAG_subprogram ] [line 76] [def] [h]
!25 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !26, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!26 = metadata !{metadata !9, metadata !22}
!27 = metadata !{metadata !28, metadata !29, metadata !30, metadata !31}
!28 = metadata !{i32 786484, i32 0, null, metadata !"b", metadata !"b", metadata !"", metadata !5, i32 4, metadata !10, i32 0, i32 1, i8* @b, null} ; [ DW_TAG_variable ] [b] [line 4] [def]
!29 = metadata !{i32 786484, i32 0, null, metadata !"global", metadata !"global", metadata !"", metadata !5, i32 7, metadata !14, i32 0, i32 1, i32* @global, null} ; [ DW_TAG_variable ] [global] [line 7] [def]
!30 = metadata !{i32 786484, i32 0, null, metadata !"globalptr", metadata !"globalptr", metadata !"", metadata !5, i32 5, metadata !9, i32 0, i32 1, i8** @globalptr, null} ; [ DW_TAG_variable ] [globalptr] [line 5] [def]
!31 = metadata !{i32 786484, i32 0, null, metadata !"global_char_ptr", metadata !"global_char_ptr", metadata !"", metadata !5, i32 6, metadata !9, i32 0, i32 1, i8** @global_char_ptr, null} ; [ DW_TAG_variable ] [global_char_ptr] [line 6] [def]
!32 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!33 = metadata !{i32 1, metadata !"Debug Info Version", i32 1}
!34 = metadata !{metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)"}
!35 = metadata !{i32 786689, metadata !4, metadata !"argptr", metadata !5, i32 16777225, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [argptr] [line 9]
!36 = metadata !{i32 9, i32 0, metadata !4, null}
!37 = metadata !{i32 786688, metadata !4, metadata !"local_char", metadata !5, i32 10, metadata !10, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [local_char] [line 10]
!38 = metadata !{i32 10, i32 0, metadata !4, null}
!39 = metadata !{i32 786688, metadata !4, metadata !"array", metadata !5, i32 11, metadata !40, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [array] [line 11]
!40 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 80, i64 8, i32 0, i32 0, metadata !10, metadata !41, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 80, align 8, offset 0] [from char]
!41 = metadata !{metadata !42}
!42 = metadata !{i32 786465, i64 0, i64 10}       ; [ DW_TAG_subrange_type ] [0, 9]
!43 = metadata !{i32 11, i32 0, metadata !4, null}
!44 = metadata !{i32 12, i32 0, metadata !4, null}
!45 = metadata !{i32 13, i32 0, metadata !4, null}
!46 = metadata !{i32 14, i32 0, metadata !4, null}
!47 = metadata !{i32 786689, metadata !11, metadata !"argptr", metadata !5, i32 16777232, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [argptr] [line 16]
!48 = metadata !{i32 16, i32 0, metadata !11, null}
!49 = metadata !{i32 786689, metadata !11, metadata !"aChar", metadata !5, i32 33554448, metadata !9, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [aChar] [line 16]
!50 = metadata !{i32 786689, metadata !11, metadata !"aInt", metadata !5, i32 50331664, metadata !14, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [aInt] [line 16]
!51 = metadata !{i32 786688, metadata !11, metadata !"local_char", metadata !5, i32 17, metadata !10, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [local_char] [line 17]
!52 = metadata !{i32 17, i32 0, metadata !11, null}
!53 = metadata !{i32 786688, metadata !11, metadata !"array", metadata !5, i32 18, metadata !40, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [array] [line 18]
!54 = metadata !{i32 18, i32 0, metadata !11, null}
!55 = metadata !{i32 19, i32 0, metadata !11, null}
!56 = metadata !{i32 20, i32 0, metadata !11, null}
!57 = metadata !{i32 21, i32 0, metadata !11, null}
!58 = metadata !{i32 786688, metadata !15, metadata !"local_char", metadata !5, i32 24, metadata !10, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [local_char] [line 24]
!59 = metadata !{i32 24, i32 0, metadata !15, null}
!60 = metadata !{i32 786688, metadata !15, metadata !"p2", metadata !5, i32 25, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p2] [line 25]
!61 = metadata !{i32 25, i32 0, metadata !15, null}
!62 = metadata !{i32 786688, metadata !15, metadata !"p3", metadata !5, i32 26, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p3] [line 26]
!63 = metadata !{i32 26, i32 0, metadata !15, null}
!64 = metadata !{i32 786688, metadata !15, metadata !"p4", metadata !5, i32 27, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p4] [line 27]
!65 = metadata !{i32 27, i32 0, metadata !15, null}
!66 = metadata !{i32 786688, metadata !15, metadata !"p", metadata !5, i32 28, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 28]
!67 = metadata !{i32 28, i32 0, metadata !15, null}
!68 = metadata !{i32 786688, metadata !15, metadata !"i", metadata !5, i32 29, metadata !14, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 29]
!69 = metadata !{i32 29, i32 0, metadata !15, null}
!70 = metadata !{i32 30, i32 0, metadata !71, null}
!71 = metadata !{i32 786443, metadata !1, metadata !15, i32 30, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/student/Desktop/CS4239_Assignment2/bonus/tests/bonus_test.c]
!72 = metadata !{i32 31, i32 0, metadata !73, null}
!73 = metadata !{i32 786443, metadata !1, metadata !71, i32 30, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/student/Desktop/CS4239_Assignment2/bonus/tests/bonus_test.c]
!74 = metadata !{i32 32, i32 0, metadata !73, null}
!75 = metadata !{i32 33, i32 0, metadata !15, null}
!76 = metadata !{i32 34, i32 0, metadata !77, null}
!77 = metadata !{i32 786443, metadata !1, metadata !15, i32 33, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/student/Desktop/CS4239_Assignment2/bonus/tests/bonus_test.c]
!78 = metadata !{i32 35, i32 0, metadata !77, null}
!79 = metadata !{i32 36, i32 0, metadata !15, null}
!80 = metadata !{i32 37, i32 0, metadata !15, null}
!81 = metadata !{i32 38, i32 0, metadata !15, null}
!82 = metadata !{i32 786689, metadata !18, metadata !"argptr", metadata !5, i32 16777256, metadata !8, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [argptr] [line 40]
!83 = metadata !{i32 40, i32 0, metadata !18, null}
!84 = metadata !{i32 786688, metadata !18, metadata !"local_array", metadata !5, i32 41, metadata !40, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [local_array] [line 41]
!85 = metadata !{i32 41, i32 0, metadata !18, null}
!86 = metadata !{i32 786688, metadata !18, metadata !"i", metadata !5, i32 42, metadata !14, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 42]
!87 = metadata !{i32 42, i32 0, metadata !18, null}
!88 = metadata !{i32 43, i32 0, metadata !18, null}
!89 = metadata !{i32 45, i32 0, metadata !90, null}
!90 = metadata !{i32 786443, metadata !1, metadata !18, i32 43, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/home/student/Desktop/CS4239_Assignment2/bonus/tests/bonus_test.c]
!91 = metadata !{i32 46, i32 0, metadata !90, null}
!92 = metadata !{i32 48, i32 0, metadata !90, null}
!93 = metadata !{i32 49, i32 0, metadata !90, null}
!94 = metadata !{i32 51, i32 0, metadata !90, null}
!95 = metadata !{i32 53, i32 0, metadata !18, null}
!96 = metadata !{i32 786688, metadata !19, metadata !"x", metadata !5, i32 57, metadata !14, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [x] [line 57]
!97 = metadata !{i32 57, i32 0, metadata !19, null}
!98 = metadata !{i32 786688, metadata !19, metadata !"ptr_x", metadata !5, i32 58, metadata !22, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ptr_x] [line 58]
!99 = metadata !{i32 58, i32 0, metadata !19, null} ; [ DW_TAG_imported_module ]
!100 = metadata !{i32 786688, metadata !19, metadata !"ptr_y", metadata !5, i32 59, metadata !22, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ptr_y] [line 59]
!101 = metadata !{i32 59, i32 0, metadata !19, null}
!102 = metadata !{i32 60, i32 0, metadata !19, null}
!103 = metadata !{i32 61, i32 0, metadata !19, null}
!104 = metadata !{i32 786688, metadata !23, metadata !"array", metadata !5, i32 65, metadata !105, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [array] [line 65]
!105 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 3200, i64 32, i32 0, i32 0, metadata !14, metadata !106, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 3200, align 32, offset 0] [from int]
!106 = metadata !{metadata !107}
!107 = metadata !{i32 786465, i64 0, i64 100}     ; [ DW_TAG_subrange_type ] [0, 99]
!108 = metadata !{i32 65, i32 0, metadata !23, null}
!109 = metadata !{i32 786688, metadata !23, metadata !"p", metadata !5, i32 66, metadata !22, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [p] [line 66]
!110 = metadata !{i32 66, i32 0, metadata !23, null}
!111 = metadata !{i32 786688, metadata !23, metadata !"i", metadata !5, i32 67, metadata !14, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 67]
!112 = metadata !{i32 67, i32 0, metadata !23, null}
!113 = metadata !{i32 68, i32 0, metadata !114, null}
!114 = metadata !{i32 786443, metadata !1, metadata !23, i32 68, i32 0, i32 4} ; [ DW_TAG_lexical_block ] [/home/student/Desktop/CS4239_Assignment2/bonus/tests/bonus_test.c]
!115 = metadata !{i32 69, i32 0, metadata !116, null}
!116 = metadata !{i32 786443, metadata !1, metadata !117, i32 69, i32 0, i32 6} ; [ DW_TAG_lexical_block ] [/home/student/Desktop/CS4239_Assignment2/bonus/tests/bonus_test.c]
!117 = metadata !{i32 786443, metadata !1, metadata !114, i32 68, i32 0, i32 5} ; [ DW_TAG_lexical_block ] [/home/student/Desktop/CS4239_Assignment2/bonus/tests/bonus_test.c]
!118 = metadata !{i32 70, i32 0, metadata !119, null}
!119 = metadata !{i32 786443, metadata !1, metadata !116, i32 69, i32 0, i32 7} ; [ DW_TAG_lexical_block ] [/home/student/Desktop/CS4239_Assignment2/bonus/tests/bonus_test.c]
!120 = metadata !{i32 71, i32 0, metadata !119, null}
!121 = metadata !{i32 72, i32 0, metadata !117, null}
!122 = metadata !{i32 73, i32 0, metadata !23, null}
!123 = metadata !{i32 786689, metadata !24, metadata !"n", metadata !5, i32 16777292, metadata !22, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [n] [line 76]
!124 = metadata !{i32 76, i32 0, metadata !24, null}
!125 = metadata !{i32 786688, metadata !24, metadata !"str", metadata !5, i32 77, metadata !126, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [str] [line 77]
!126 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 160, i64 8, i32 0, i32 0, metadata !10, metadata !127, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 160, align 8, offset 0] [from char]
!127 = metadata !{metadata !128}
!128 = metadata !{i32 786465, i64 0, i64 20}      ; [ DW_TAG_subrange_type ] [0, 19]
!129 = metadata !{i32 77, i32 0, metadata !24, null}
!130 = metadata !{i32 78, i32 0, metadata !24, null}
!131 = metadata !{i32 786688, metadata !24, metadata !"i", metadata !5, i32 79, metadata !14, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 79]
!132 = metadata !{i32 79, i32 0, metadata !24, null}
!133 = metadata !{i32 80, i32 0, metadata !24, null}
!134 = metadata !{i32 82, i32 0, metadata !135, null}
!135 = metadata !{i32 786443, metadata !1, metadata !24, i32 82, i32 0, i32 8} ; [ DW_TAG_lexical_block ] [/home/student/Desktop/CS4239_Assignment2/bonus/tests/bonus_test.c]
!136 = metadata !{i32 83, i32 0, metadata !137, null}
!137 = metadata !{i32 786443, metadata !1, metadata !135, i32 82, i32 0, i32 9} ; [ DW_TAG_lexical_block ] [/home/student/Desktop/CS4239_Assignment2/bonus/tests/bonus_test.c]
!138 = metadata !{i32 84, i32 0, metadata !137, null}
!139 = metadata !{i32 87, i32 0, metadata !140, null}
!140 = metadata !{i32 786443, metadata !1, metadata !135, i32 86, i32 0, i32 10} ; [ DW_TAG_lexical_block ] [/home/student/Desktop/CS4239_Assignment2/bonus/tests/bonus_test.c]
!141 = metadata !{i32 90, i32 0, metadata !24, null}
!142 = metadata !{i32 91, i32 0, metadata !143, null}
!143 = metadata !{i32 786443, metadata !1, metadata !24, i32 90, i32 0, i32 11} ; [ DW_TAG_lexical_block ] [/home/student/Desktop/CS4239_Assignment2/bonus/tests/bonus_test.c]
!144 = metadata !{i32 92, i32 0, metadata !143, null}
!145 = metadata !{i32 93, i32 0, metadata !143, null}
!146 = metadata !{i32 786688, metadata !24, metadata !"str2", metadata !5, i32 95, metadata !9, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [str2] [line 95]
!147 = metadata !{i32 95, i32 0, metadata !24, null}
!148 = metadata !{i32 96, i32 0, metadata !24, null}
