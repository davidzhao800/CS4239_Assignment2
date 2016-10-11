; ModuleID = 'test3.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@global = global i32 1, align 4
@.str = private unnamed_addr constant [12 x i8] c"Hello World\00", align 1
@g.str = private unnamed_addr constant [20 x i8] c"Hello World\00\00\00\00\00\00\00\00\00", align 16
@h.str = private unnamed_addr constant [20 x i8] c"Hello World\00\00\00\00\00\00\00\00\00", align 16
@global_char_ptr = common global i8* null, align 8
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@global_int_ptr = common global i32* null, align 8
@global_int_ptr2 = common global i32* null, align 8
@.str2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1
@.str3 = private unnamed_addr constant [3 x i8] c"1\0A\00", align 1
@.str4 = private unnamed_addr constant [3 x i8] c"2\0A\00", align 1
@.str5 = private unnamed_addr constant [3 x i8] c"3\0A\00", align 1
@.str6 = private unnamed_addr constant [7 x i8] c"%d %d\0A\00", align 1

; Function Attrs: nounwind uwtable
define i8* @f() #0 {
  %str = alloca i8*, align 8
  call void @llvm.dbg.declare(metadata !{i8** %str}, metadata !31), !dbg !32
  store i8* getelementptr inbounds ([12 x i8]* @.str, i32 0, i32 0), i8** %str, align 8, !dbg !32
  %1 = load i8** %str, align 8, !dbg !33
  ret i8* %1, !dbg !33
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata) #1

; Function Attrs: nounwind uwtable
define i8* @g() #0 {
  %str = alloca [20 x i8], align 16
  call void @llvm.dbg.declare(metadata !{[20 x i8]* %str}, metadata !34), !dbg !38
  %1 = bitcast [20 x i8]* %str to i8*, !dbg !38
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %1, i8* getelementptr inbounds ([20 x i8]* @g.str, i32 0, i32 0), i64 20, i32 16, i1 false), !dbg !38
  %2 = getelementptr inbounds [20 x i8]* %str, i32 0, i32 0, !dbg !39
  ret i8* %2, !dbg !39
}

; Function Attrs: nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #2

; Function Attrs: nounwind uwtable
define i8* @h(i32* %n) #0 {
  %1 = alloca i32*, align 8
  %str = alloca [20 x i8], align 16
  %i = alloca i32, align 4
  %str2 = alloca i8*, align 8
  store i32* %n, i32** %1, align 8
  call void @llvm.dbg.declare(metadata !{i32** %1}, metadata !40), !dbg !41
  call void @llvm.dbg.declare(metadata !{[20 x i8]* %str}, metadata !42), !dbg !43
  %2 = bitcast [20 x i8]* %str to i8*, !dbg !43
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %2, i8* getelementptr inbounds ([20 x i8]* @h.str, i32 0, i32 0), i64 20, i32 16, i1 false), !dbg !43
  %3 = getelementptr inbounds [20 x i8]* %str, i32 0, i32 0, !dbg !44
  store i8* %3, i8** @global_char_ptr, align 8, !dbg !44
  call void @llvm.dbg.declare(metadata !{i32* %i}, metadata !45), !dbg !46
  %4 = call i32 (i8*, ...)* @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8]* @.str1, i32 0, i32 0), i32* %i), !dbg !47
  %5 = load i32* %i, align 4, !dbg !48
  %6 = icmp sge i32 %5, 0, !dbg !48
  br i1 %6, label %7, label %8, !dbg !48

; <label>:7                                       ; preds = %0
  store i32* @global, i32** %1, align 8, !dbg !50
  br label %9, !dbg !52

; <label>:8                                       ; preds = %0
  store i32* %i, i32** %1, align 8, !dbg !53
  br label %9

; <label>:9                                       ; preds = %8, %7
  br label %10, !dbg !55

; <label>:10                                      ; preds = %13, %9
  %11 = load i32* %i, align 4, !dbg !55
  %12 = icmp ne i32 %11, 0, !dbg !55
  br i1 %12, label %13, label %14, !dbg !55

; <label>:13                                      ; preds = %10
  store i32* null, i32** %1, align 8, !dbg !56
  store i32 0, i32* %i, align 4, !dbg !58
  br label %10, !dbg !59

; <label>:14                                      ; preds = %10
  call void @llvm.dbg.declare(metadata !{i8** %str2}, metadata !60), !dbg !61
  %15 = getelementptr inbounds [20 x i8]* %str, i32 0, i32 0, !dbg !61
  store i8* %15, i8** %str2, align 8, !dbg !61
  %16 = load i8** %str2, align 8, !dbg !62
  ret i8* %16, !dbg !62
}

declare i32 @__isoc99_scanf(i8*, ...) #3

; Function Attrs: nounwind uwtable
define void @foobar(i32* %ptr1, i32* %ptr2) #0 {
  %1 = alloca i32*, align 8
  %2 = alloca i32*, align 8
  %arr = alloca [20 x i32], align 16
  %arr2 = alloca i32*, align 8
  store i32* %ptr1, i32** %1, align 8
  call void @llvm.dbg.declare(metadata !{i32** %1}, metadata !63), !dbg !64
  store i32* %ptr2, i32** %2, align 8
  call void @llvm.dbg.declare(metadata !{i32** %2}, metadata !65), !dbg !64
  call void @llvm.dbg.declare(metadata !{[20 x i32]* %arr}, metadata !66), !dbg !68
  %3 = bitcast [20 x i32]* %arr to i8*, !dbg !68
  call void @llvm.memset.p0i8.i64(i8* %3, i8 0, i64 80, i32 16, i1 false), !dbg !68
  %4 = bitcast i8* %3 to [20 x i32]*, !dbg !68
  %5 = getelementptr [20 x i32]* %4, i32 0, i32 0, !dbg !68
  store i32 1, i32* %5, !dbg !68
  %6 = getelementptr [20 x i32]* %4, i32 0, i32 1, !dbg !68
  store i32 2, i32* %6, !dbg !68
  %7 = getelementptr [20 x i32]* %4, i32 0, i32 2, !dbg !68
  store i32 3, i32* %7, !dbg !68
  %8 = getelementptr [20 x i32]* %4, i32 0, i32 3, !dbg !68
  store i32 4, i32* %8, !dbg !68
  %9 = getelementptr [20 x i32]* %4, i32 0, i32 4, !dbg !68
  store i32 5, i32* %9, !dbg !68
  %10 = getelementptr [20 x i32]* %4, i32 0, i32 5, !dbg !68
  store i32 6, i32* %10, !dbg !68
  call void @llvm.dbg.declare(metadata !{i32** %arr2}, metadata !69), !dbg !70
  store i32* inttoptr (i64 1 to i32*), i32** %arr2, align 8, !dbg !70
  %11 = getelementptr inbounds [20 x i32]* %arr, i32 0, i32 0, !dbg !71
  store i32* %11, i32** @global_int_ptr, align 8, !dbg !71
  %12 = load i32** %arr2, align 8, !dbg !72
  store i32* %12, i32** @global_int_ptr2, align 8, !dbg !72
  %13 = getelementptr inbounds [20 x i32]* %arr, i32 0, i32 0, !dbg !73
  store i32* %13, i32** %1, align 8, !dbg !73
  %14 = load i32** %arr2, align 8, !dbg !74
  store i32* %14, i32** %2, align 8, !dbg !74
  ret void, !dbg !75
}

; Function Attrs: nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1) #2

; Function Attrs: nounwind uwtable
define i32 @main(i32 %argc, i8** %argv) #0 {
  %1 = alloca i32, align 4
  %2 = alloca i8**, align 8
  %ptr1 = alloca i32*, align 8
  %ptr2 = alloca i32*, align 8
  store i32 %argc, i32* %1, align 4
  call void @llvm.dbg.declare(metadata !{i32* %1}, metadata !76), !dbg !77
  store i8** %argv, i8*** %2, align 8
  call void @llvm.dbg.declare(metadata !{i8*** %2}, metadata !78), !dbg !77
  %3 = call i8* @f(), !dbg !79
  %4 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str2, i32 0, i32 0), i8* %3), !dbg !79
  %5 = call i8* @g(), !dbg !80
  %6 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([4 x i8]* @.str2, i32 0, i32 0), i8* %5), !dbg !80
  %7 = call i8* @h(i32* %1), !dbg !81
  %8 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str3, i32 0, i32 0)), !dbg !82
  call void @llvm.dbg.declare(metadata !{i32** %ptr1}, metadata !83), !dbg !84
  call void @llvm.dbg.declare(metadata !{i32** %ptr2}, metadata !85), !dbg !84
  %9 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str4, i32 0, i32 0)), !dbg !86
  %10 = load i32** %ptr1, align 8, !dbg !87
  %11 = load i32** %ptr2, align 8, !dbg !87
  call void @foobar(i32* %10, i32* %11), !dbg !87
  %12 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str5, i32 0, i32 0)), !dbg !88
  %13 = load i32** %ptr1, align 8, !dbg !89
  %14 = load i32* %13, align 4, !dbg !89
  %15 = load i32** %ptr2, align 8, !dbg !89
  %16 = load i32* %15, align 4, !dbg !89
  %17 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([7 x i8]* @.str6, i32 0, i32 0), i32 %14, i32 %16), !dbg !89
  ret i32 0, !dbg !90
}

declare i32 @printf(i8*, ...) #3

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { nounwind }
attributes #3 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!28, !29}
!llvm.ident = !{!30}

!0 = metadata !{i32 786449, metadata !1, i32 12, metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)", i1 false, metadata !"", i32 0, metadata !2, metadata !2, metadata !3, metadata !23, metadata !2, metadata !""} ; [ DW_TAG_compile_unit ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test3.c] [DW_LANG_C99]
!1 = metadata !{metadata !"test3.c", metadata !"/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin"}
!2 = metadata !{i32 0}
!3 = metadata !{metadata !4, metadata !10, metadata !11, metadata !16, metadata !19}
!4 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"f", metadata !"f", metadata !"", i32 8, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i8* ()* @f, null, null, metadata !2, i32 8} ; [ DW_TAG_subprogram ] [line 8] [def] [f]
!5 = metadata !{i32 786473, metadata !1}          ; [ DW_TAG_file_type ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test3.c]
!6 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !7, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!7 = metadata !{metadata !8}
!8 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !9} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from char]
!9 = metadata !{i32 786468, null, null, metadata !"char", i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ] [char] [line 0, size 8, align 8, offset 0, enc DW_ATE_signed_char]
!10 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"g", metadata !"g", metadata !"", i32 13, metadata !6, i1 false, i1 true, i32 0, i32 0, null, i32 0, i1 false, i8* ()* @g, null, null, metadata !2, i32 13} ; [ DW_TAG_subprogram ] [line 13] [def] [g]
!11 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"h", metadata !"h", metadata !"", i32 18, metadata !12, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i8* (i32*)* @h, null, null, metadata !2, i32 18} ; [ DW_TAG_subprogram ] [line 18] [def] [h]
!12 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !13, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!13 = metadata !{metadata !8, metadata !14}
!14 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !15} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from int]
!15 = metadata !{i32 786468, null, null, metadata !"int", i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ] [int] [line 0, size 32, align 32, offset 0, enc DW_ATE_signed]
!16 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"foobar", metadata !"foobar", metadata !"", i32 41, metadata !17, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, void (i32*, i32*)* @foobar, null, null, metadata !2, i32 41} ; [ DW_TAG_subprogram ] [line 41] [def] [foobar]
!17 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !18, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!18 = metadata !{null, metadata !14, metadata !14}
!19 = metadata !{i32 786478, metadata !1, metadata !5, metadata !"main", metadata !"main", metadata !"", i32 50, metadata !20, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 false, i32 (i32, i8**)* @main, null, null, metadata !2, i32 50} ; [ DW_TAG_subprogram ] [line 50] [def] [main]
!20 = metadata !{i32 786453, i32 0, null, metadata !"", i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !21, i32 0, null, null, null} ; [ DW_TAG_subroutine_type ] [line 0, size 0, align 0, offset 0] [from ]
!21 = metadata !{metadata !15, metadata !15, metadata !22}
!22 = metadata !{i32 786447, null, null, metadata !"", i32 0, i64 64, i64 64, i64 0, i32 0, metadata !8} ; [ DW_TAG_pointer_type ] [line 0, size 64, align 64, offset 0] [from ]
!23 = metadata !{metadata !24, metadata !25, metadata !26, metadata !27}
!24 = metadata !{i32 786484, i32 0, null, metadata !"global", metadata !"global", metadata !"", metadata !5, i32 6, metadata !15, i32 0, i32 1, i32* @global, null} ; [ DW_TAG_variable ] [global] [line 6] [def]
!25 = metadata !{i32 786484, i32 0, null, metadata !"global_char_ptr", metadata !"global_char_ptr", metadata !"", metadata !5, i32 3, metadata !8, i32 0, i32 1, i8** @global_char_ptr, null} ; [ DW_TAG_variable ] [global_char_ptr] [line 3] [def]
!26 = metadata !{i32 786484, i32 0, null, metadata !"global_int_ptr", metadata !"global_int_ptr", metadata !"", metadata !5, i32 4, metadata !14, i32 0, i32 1, i32** @global_int_ptr, null} ; [ DW_TAG_variable ] [global_int_ptr] [line 4] [def]
!27 = metadata !{i32 786484, i32 0, null, metadata !"global_int_ptr2", metadata !"global_int_ptr2", metadata !"", metadata !5, i32 5, metadata !14, i32 0, i32 1, i32** @global_int_ptr2, null} ; [ DW_TAG_variable ] [global_int_ptr2] [line 5] [def]
!28 = metadata !{i32 2, metadata !"Dwarf Version", i32 4}
!29 = metadata !{i32 1, metadata !"Debug Info Version", i32 1}
!30 = metadata !{metadata !"Ubuntu clang version 3.4.2- (branches/release_34) (based on LLVM 3.4.2)"}
!31 = metadata !{i32 786688, metadata !4, metadata !"str", metadata !5, i32 9, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [str] [line 9]
!32 = metadata !{i32 9, i32 0, metadata !4, null}
!33 = metadata !{i32 10, i32 0, metadata !4, null}
!34 = metadata !{i32 786688, metadata !10, metadata !"str", metadata !5, i32 14, metadata !35, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [str] [line 14]
!35 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 160, i64 8, i32 0, i32 0, metadata !9, metadata !36, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 160, align 8, offset 0] [from char]
!36 = metadata !{metadata !37}
!37 = metadata !{i32 786465, i64 0, i64 20}       ; [ DW_TAG_subrange_type ] [0, 19]
!38 = metadata !{i32 14, i32 0, metadata !10, null}
!39 = metadata !{i32 15, i32 0, metadata !10, null}
!40 = metadata !{i32 786689, metadata !11, metadata !"n", metadata !5, i32 16777234, metadata !14, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [n] [line 18]
!41 = metadata !{i32 18, i32 0, metadata !11, null}
!42 = metadata !{i32 786688, metadata !11, metadata !"str", metadata !5, i32 19, metadata !35, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [str] [line 19]
!43 = metadata !{i32 19, i32 0, metadata !11, null}
!44 = metadata !{i32 20, i32 0, metadata !11, null}
!45 = metadata !{i32 786688, metadata !11, metadata !"i", metadata !5, i32 21, metadata !15, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [i] [line 21]
!46 = metadata !{i32 21, i32 0, metadata !11, null}
!47 = metadata !{i32 22, i32 0, metadata !11, null}
!48 = metadata !{i32 24, i32 0, metadata !49, null}
!49 = metadata !{i32 786443, metadata !1, metadata !11, i32 24, i32 0, i32 0} ; [ DW_TAG_lexical_block ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test3.c]
!50 = metadata !{i32 25, i32 0, metadata !51, null}
!51 = metadata !{i32 786443, metadata !1, metadata !49, i32 24, i32 0, i32 1} ; [ DW_TAG_lexical_block ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test3.c]
!52 = metadata !{i32 26, i32 0, metadata !51, null}
!53 = metadata !{i32 29, i32 0, metadata !54, null}
!54 = metadata !{i32 786443, metadata !1, metadata !49, i32 28, i32 0, i32 2} ; [ DW_TAG_lexical_block ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test3.c]
!55 = metadata !{i32 32, i32 0, metadata !11, null}
!56 = metadata !{i32 33, i32 0, metadata !57, null}
!57 = metadata !{i32 786443, metadata !1, metadata !11, i32 32, i32 0, i32 3} ; [ DW_TAG_lexical_block ] [/home/cs4239/Documents/CS4239_Assignment2/testcase_by_kexin/test3.c]
!58 = metadata !{i32 34, i32 0, metadata !57, null}
!59 = metadata !{i32 35, i32 0, metadata !57, null}
!60 = metadata !{i32 786688, metadata !11, metadata !"str2", metadata !5, i32 37, metadata !8, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [str2] [line 37]
!61 = metadata !{i32 37, i32 0, metadata !11, null}
!62 = metadata !{i32 38, i32 0, metadata !11, null}
!63 = metadata !{i32 786689, metadata !16, metadata !"ptr1", metadata !5, i32 16777257, metadata !14, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [ptr1] [line 41]
!64 = metadata !{i32 41, i32 0, metadata !16, null}
!65 = metadata !{i32 786689, metadata !16, metadata !"ptr2", metadata !5, i32 33554473, metadata !14, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [ptr2] [line 41]
!66 = metadata !{i32 786688, metadata !16, metadata !"arr", metadata !5, i32 42, metadata !67, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [arr] [line 42]
!67 = metadata !{i32 786433, null, null, metadata !"", i32 0, i64 640, i64 32, i32 0, i32 0, metadata !15, metadata !36, i32 0, null, null, null} ; [ DW_TAG_array_type ] [line 0, size 640, align 32, offset 0] [from int]
!68 = metadata !{i32 42, i32 0, metadata !16, null}
!69 = metadata !{i32 786688, metadata !16, metadata !"arr2", metadata !5, i32 43, metadata !14, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [arr2] [line 43]
!70 = metadata !{i32 43, i32 0, metadata !16, null}
!71 = metadata !{i32 44, i32 0, metadata !16, null}
!72 = metadata !{i32 45, i32 0, metadata !16, null}
!73 = metadata !{i32 46, i32 0, metadata !16, null}
!74 = metadata !{i32 47, i32 0, metadata !16, null}
!75 = metadata !{i32 48, i32 0, metadata !16, null}
!76 = metadata !{i32 786689, metadata !19, metadata !"argc", metadata !5, i32 16777266, metadata !15, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [argc] [line 50]
!77 = metadata !{i32 50, i32 0, metadata !19, null}
!78 = metadata !{i32 786689, metadata !19, metadata !"argv", metadata !5, i32 33554482, metadata !22, i32 0, i32 0} ; [ DW_TAG_arg_variable ] [argv] [line 50]
!79 = metadata !{i32 51, i32 0, metadata !19, null}
!80 = metadata !{i32 52, i32 0, metadata !19, null}
!81 = metadata !{i32 53, i32 0, metadata !19, null}
!82 = metadata !{i32 54, i32 0, metadata !19, null}
!83 = metadata !{i32 786688, metadata !19, metadata !"ptr1", metadata !5, i32 55, metadata !14, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ptr1] [line 55]
!84 = metadata !{i32 55, i32 0, metadata !19, null}
!85 = metadata !{i32 786688, metadata !19, metadata !"ptr2", metadata !5, i32 55, metadata !14, i32 0, i32 0} ; [ DW_TAG_auto_variable ] [ptr2] [line 55]
!86 = metadata !{i32 56, i32 0, metadata !19, null}
!87 = metadata !{i32 57, i32 0, metadata !19, null}
!88 = metadata !{i32 58, i32 0, metadata !19, null} ; [ DW_TAG_imported_module ]
!89 = metadata !{i32 59, i32 0, metadata !19, null}
!90 = metadata !{i32 60, i32 0, metadata !19, null}
