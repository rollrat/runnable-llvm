; RUN: llc -mtriple x86_64-pc-linux -use-ctors -enable-structor-comdat < %s | FileCheck --check-prefix=CTOR-COMDAT %s
; RUN: llc -mtriple x86_64-pc-linux  -enable-structor-comdat < %s | FileCheck --check-prefix=INIT-ARRAY-COMDAT %s
; RUN: llc -mtriple x86_64-pc-linux -use-ctors < %s | FileCheck --check-prefix=CTOR %s
; RUN: llc -mtriple x86_64-pc-linux < %s | FileCheck --check-prefix=INIT-ARRAY %s

@llvm.global_ctors = appending global [2 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 65535, void ()* @f, i8* null}, { i32, void ()*, i8* } { i32 15, void ()* @g, i8* @v }]

@v = weak_odr global i8 0

define void @f() {
entry:
  ret void
}

define void @g() {
entry:
  ret void
}

; CTOR:		.section	.ctors.65520,"aw",@progbits
; CTOR-NEXT:	.align	8
; CTOR-NEXT:	.quad	g
; CTOR-NEXT:	.section	.ctors,"aw",@progbits
; CTOR-NEXT:	.align	8
; CTOR-NEXT:	.quad	f

; INIT-ARRAY:		.section	.init_array.15,"aw",@init_array
; INIT-ARRAY-NEXT:	.align	8
; INIT-ARRAY-NEXT:	.quad	g
; INIT-ARRAY-NEXT:	.section	.init_array,"aw",@init_array
; INIT-ARRAY-NEXT:	.align	8
; INIT-ARRAY-NEXT:	.quad	f

; CTOR-COMDAT:		.section	.ctors.65520,"aGw",@progbits,v,comdat
; CTOR-COMDAT-NEXT:	.align	8
; CTOR-COMDAT-NEXT:	.quad	g
; CTOR-COMDAT-NEXT:	.section	.ctors,"aw",@progbits
; CTOR-COMDAT-NEXT:	.align	8
; CTOR-COMDAT-NEXT:	.quad	f

; INIT-ARRAY-COMDAT:		.section	.init_array.15,"aGw",@init_array,v,comdat
; INIT-ARRAY-COMDAT-NEXT:	.align	8
; INIT-ARRAY-COMDAT-NEXT:	.quad	g
; INIT-ARRAY-COMDAT-NEXT:	.section	.init_array,"aw",@init_array
; INIT-ARRAY-COMDAT-NEXT:	.align	8
; INIT-ARRAY-COMDAT-NEXT:	.quad	f
