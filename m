Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F777549FAF
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 22:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344931AbiFMUpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 16:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351453AbiFMUoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 16:44:07 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B8E13E32
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 12:51:48 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id s12so13158784ejx.3
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 12:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=4JdrATQx3rV2A5UBqaMzqBXG8qRim4/ObNTA/zRa1l8=;
        b=Rpa670g4XZp/5fbnRsIzS1mJDMoHnVs8iZ2zFMrIl4OS6KfFk07vVc9q5HM5s/Rjcd
         6bWzOQYVGXOOkiBIddW8AT2N7hSeWqYFxnoDtL/Sk8h3+hngFeTzPpHoLa4BGZJS/kIY
         cyX6v8sScwYr+jHsK7CtbfaM5Bozl6d0/h/6SuiHFZ5QRSnUX3R4wySVP40jp4RJUntj
         QztgNICCAVBb74kYqt95zbLYLzRTzc//jt4QYVB08q2xxaBRu475w72i4pkF7d0DVSii
         vUwdCxzLMwoP37MspmpJMVg63g3qDhVtcXiDMFeqcD6xEYYkBi+Kf0BIrXSZ5JyqzqYK
         VOsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=4JdrATQx3rV2A5UBqaMzqBXG8qRim4/ObNTA/zRa1l8=;
        b=GaED4vMB0sNipxHj9H9ZLR6ahz+InCwn9vXux6Akq7Jl1ynDyJ2Mly0wNWEhduUQOx
         dm35rYJwn/SzmmijvQKATRDOfu/yGzPKD4tHGL4f/Yr/EJXcKG5BaqYlDtmBMZxhpjdT
         MAOiyLvIjc2Zisuw8wsK+dzGhOktQ4lWM2GmrUHCOLwFIC/GSaLbRL49RA6GUN2gChQr
         klsFp9wfzKQg760srIPAF9r11G7ZY25+GwQ7iQSUnrNA5sX12UsKHRDlB4/K5AedUYDZ
         a251vXY6DAkoTtzDxW+4JDap0DrvK0hwEVzsAlUM6ExWDOyqhcudDITxuyIkFNGTpSH4
         YWfw==
X-Gm-Message-State: AOAM533dgCuNRmuml+8GLzMYI8s8WY0B0nDyOLSfshZywECXwrH2l/GV
        fTGOhK4ySWSdIvW3YLIOyf7XrS5r73Y=
X-Google-Smtp-Source: ABdhPJxzw1FLzveZzKlZAc+GgrqzKNPUrHp0sEiWYk/e/TLEemg7V1tjzAHJEBNp5fkfyjkoUeXZpg==
X-Received: by 2002:a17:906:d82:b0:70d:84d3:b6df with SMTP id m2-20020a1709060d8200b0070d84d3b6dfmr1244652eji.464.1655149907308;
        Mon, 13 Jun 2022 12:51:47 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id hh14-20020a170906a94e00b00703e09dd2easm4248518ejb.147.2022.06.13.12.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 12:51:46 -0700 (PDT)
Date:   Mon, 13 Jun 2022 20:51:45 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: backport of patches to fix riscv build failure in 4.19-stable and
 5.4-stable
Message-ID: <YqeVUUsqCf9WPQ2S@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xPnGHc1wEKH4DRrq"
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--xPnGHc1wEKH4DRrq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

The build of riscv allmodconfig fails in 4.19-stable and 5.4-stable.

4.19-stable will need:
	30aca1bacb39 ("RISC-V: fix barrier() use in <vdso/processor.h>")

and 5.4-stable needs:
	30aca1bacb39 ("RISC-V: fix barrier() use in <vdso/processor.h>")
	fc585d4a5cf6 ("riscv: Less inefficient gcc tishift helpers (and export their symbols)")

Backport of all are in the attached mbox.


--
Regards
Sudip

--xPnGHc1wEKH4DRrq
Content-Type: application/mbox
Content-Disposition: attachment; filename="backport_4.19-stable.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom a5fefd64cd4795b715d3269bcd7ef7463e7138b4 Mon Sep 17 00:00:00 2001=0A=
=46rom: Randy Dunlap <rdunlap@infradead.org>=0ADate: Mon, 16 Nov 2020 17:39=
:51 -0800=0ASubject: [PATCH] RISC-V: fix barrier() use in <vdso/processor.h=
>=0A=0Acommit 30aca1bacb398dec6c1ed5eeca33f355bd7b6203 upstream.=0A=0Ariscv=
's <vdso/processor.h> uses barrier() so it should include=0A<asm/barrier.h>=
=0A=0AFixes this build error:=0A  CC [M]  drivers/net/ethernet/emulex/benet=
/be_main.o=0AIn file included from ./include/vdso/processor.h:10,=0A       =
          from ./arch/riscv/include/asm/processor.h:11,=0A                 =
=66rom ./include/linux/prefetch.h:15,=0A                 from drivers/net/e=
thernet/emulex/benet/be_main.c:14:=0A./arch/riscv/include/asm/vdso/processo=
r.h: In function 'cpu_relax':=0A./arch/riscv/include/asm/vdso/processor.h:1=
4:2: error: implicit declaration of function 'barrier' [-Werror=3Dimplicit-=
function-declaration]=0A   14 |  barrier();=0A=0AThis happens with a total =
of 5 networking drivers -- they all use=0A<linux/prefetch.h>.=0A=0Arv64 all=
modconfig now builds cleanly after this patch.=0A=0AFixes fallout from:=0A8=
15f0ddb346c ("include/linux/compiler*.h: make compiler-*.h mutually exclusi=
ve")=0A=0AFixes: ad5d1122b82f ("riscv: use vDSO common flow to reduce the l=
atency of the time-related functions")=0AReported-by: Andreas Schwab <schwa=
b@linux-m68k.org>=0ASigned-off-by: Randy Dunlap <rdunlap@infradead.org>=0AA=
cked-by: Arvind Sankar <nivedita@alum.mit.edu>=0ASigned-off-by: Palmer Dabb=
elt <palmerdabbelt@google.com>=0AReviewed-by: Nick Desaulniers <ndesaulnier=
s@google.com>=0ASigned-off-by: Palmer Dabbelt <palmerdabbelt@google.com>=0A=
[sudip: change in old path]=0ASigned-off-by: Sudip Mukherjee <sudipm.mukher=
jee@gmail.com>=0A---=0A arch/riscv/include/asm/processor.h | 2 ++=0A 1 file=
 changed, 2 insertions(+)=0A=0Adiff --git a/arch/riscv/include/asm/processo=
r.h b/arch/riscv/include/asm/processor.h=0Aindex c23578a37b44..fdcc34b4f65b=
 100644=0A--- a/arch/riscv/include/asm/processor.h=0A+++ b/arch/riscv/inclu=
de/asm/processor.h=0A@@ -30,6 +30,8 @@=0A =0A #ifndef __ASSEMBLY__=0A =0A+#=
include <asm/barrier.h>=0A+=0A struct task_struct;=0A struct pt_regs;=0A =
=0A-- =0A2.30.2=0A=0A
--xPnGHc1wEKH4DRrq
Content-Type: application/mbox
Content-Disposition: attachment; filename="backport_5.4-stable.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom d0a42b9714f30d4455ce41911e2bf463e0d8c450 Mon Sep 17 00:00:00 2001=0A=
=46rom: Randy Dunlap <rdunlap@infradead.org>=0ADate: Mon, 16 Nov 2020 17:39=
:51 -0800=0ASubject: [PATCH 1/2] RISC-V: fix barrier() use in <vdso/process=
or.h>=0A=0Acommit 30aca1bacb398dec6c1ed5eeca33f355bd7b6203 upstream.=0A=0Ar=
iscv's <vdso/processor.h> uses barrier() so it should include=0A<asm/barrie=
r.h>=0A=0AFixes this build error:=0A  CC [M]  drivers/net/ethernet/emulex/b=
enet/be_main.o=0AIn file included from ./include/vdso/processor.h:10,=0A   =
              from ./arch/riscv/include/asm/processor.h:11,=0A             =
    from ./include/linux/prefetch.h:15,=0A                 from drivers/net=
/ethernet/emulex/benet/be_main.c:14:=0A./arch/riscv/include/asm/vdso/proces=
sor.h: In function 'cpu_relax':=0A./arch/riscv/include/asm/vdso/processor.h=
:14:2: error: implicit declaration of function 'barrier' [-Werror=3Dimplici=
t-function-declaration]=0A   14 |  barrier();=0A=0AThis happens with a tota=
l of 5 networking drivers -- they all use=0A<linux/prefetch.h>.=0A=0Arv64 a=
llmodconfig now builds cleanly after this patch.=0A=0AFixes fallout from:=
=0A815f0ddb346c ("include/linux/compiler*.h: make compiler-*.h mutually exc=
lusive")=0A=0AFixes: ad5d1122b82f ("riscv: use vDSO common flow to reduce t=
he latency of the time-related functions")=0AReported-by: Andreas Schwab <s=
chwab@linux-m68k.org>=0ASigned-off-by: Randy Dunlap <rdunlap@infradead.org>=
=0AAcked-by: Arvind Sankar <nivedita@alum.mit.edu>=0ASigned-off-by: Palmer =
Dabbelt <palmerdabbelt@google.com>=0AReviewed-by: Nick Desaulniers <ndesaul=
niers@google.com>=0ASigned-off-by: Palmer Dabbelt <palmerdabbelt@google.com=
>=0A[sudip: change in old path]=0ASigned-off-by: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0A---=0A arch/riscv/include/asm/processor.h | 2 ++=0A 1 =
file changed, 2 insertions(+)=0A=0Adiff --git a/arch/riscv/include/asm/proc=
essor.h b/arch/riscv/include/asm/processor.h=0Aindex f539149d04c2..8c5b11a6=
40dd 100644=0A--- a/arch/riscv/include/asm/processor.h=0A+++ b/arch/riscv/i=
nclude/asm/processor.h=0A@@ -22,6 +22,8 @@=0A =0A #ifndef __ASSEMBLY__=0A =
=0A+#include <asm/barrier.h>=0A+=0A struct task_struct;=0A struct pt_regs;=
=0A =0A-- =0A2.30.2=0A=0A=0AFrom 44560d34e7d1ab52956965ab94e73e13505f4b79 M=
on Sep 17 00:00:00 2001=0AFrom: Olof Johansson <olof@lixom.net>=0ADate: Mon=
, 16 Dec 2019 20:06:31 -0800=0ASubject: [PATCH 2/2] riscv: Less inefficient=
 gcc tishift helpers (and export=0A their symbols)=0A=0Acommit fc585d4a5cf6=
14727f64d86550b794bcad29d5c3 upstream.=0A=0AThe existing __lshrti3 was real=
ly inefficient, and the other two helpers=0Aare also needed to compile some=
 modules.=0A=0AAdd the missing versions, and export all of the symbols like=
 arm64=0Aalready does.=0A=0AThis code is based on the assembly generated by=
 libgcc builds.=0A=0AThis fixes a build break triggered by ubsan:=0A=0Arisc=
v64-unknown-linux-gnu-ld: lib/ubsan.o: in function `.L2':=0Aubsan.c:(.text.=
unlikely+0x38): undefined reference to `__ashlti3'=0Ariscv64-unknown-linux-=
gnu-ld: ubsan.c:(.text.unlikely+0x42): undefined reference to `__ashrti3'=
=0A=0ASigned-off-by: Olof Johansson <olof@lixom.net>=0A[paul.walmsley@sifiv=
e.com: use SYM_FUNC_{START,END} instead of=0A ENTRY/ENDPROC; note libgcc or=
igin]=0ASigned-off-by: Paul Walmsley <paul.walmsley@sifive.com>=0ASigned-of=
f-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>=0A---=0A arch/riscv/incl=
ude/asm/asm-prototypes.h |  4 ++=0A arch/riscv/lib/tishift.S               =
 | 75 +++++++++++++++++++------=0A 2 files changed, 61 insertions(+), 18 de=
letions(-)=0A=0Adiff --git a/arch/riscv/include/asm/asm-prototypes.h b/arch=
/riscv/include/asm/asm-prototypes.h=0Aindex c9fecd120d18..8ae9708a8eee 1006=
44=0A--- a/arch/riscv/include/asm/asm-prototypes.h=0A+++ b/arch/riscv/inclu=
de/asm/asm-prototypes.h=0A@@ -4,4 +4,8 @@=0A #include <linux/ftrace.h>=0A #=
include <asm-generic/asm-prototypes.h>=0A =0A+long long __lshrti3(long long=
 a, int b);=0A+long long __ashrti3(long long a, int b);=0A+long long __ashl=
ti3(long long a, int b);=0A+=0A #endif /* _ASM_RISCV_PROTOTYPES_H */=0Adiff=
 --git a/arch/riscv/lib/tishift.S b/arch/riscv/lib/tishift.S=0Aindex 15f9d5=
4c7db6..ef90075c4b0a 100644=0A--- a/arch/riscv/lib/tishift.S=0A+++ b/arch/r=
iscv/lib/tishift.S=0A@@ -4,34 +4,73 @@=0A  */=0A =0A #include <linux/linkag=
e.h>=0A+#include <asm-generic/export.h>=0A =0A-ENTRY(__lshrti3)=0A+SYM_FUNC=
_START(__lshrti3)=0A 	beqz	a2, .L1=0A 	li	a5,64=0A 	sub	a5,a5,a2=0A-	addi	s=
p,sp,-16=0A 	sext.w	a4,a5=0A 	blez	a5, .L2=0A 	sext.w	a2,a2=0A-	sll	a4,a1,a=
4=0A 	srl	a0,a0,a2=0A-	srl	a1,a1,a2=0A+	sll	a4,a1,a4=0A+	srl	a2,a1,a2=0A 	o=
r	a0,a0,a4=0A-	sd	a1,8(sp)=0A-	sd	a0,0(sp)=0A-	ld	a0,0(sp)=0A-	ld	a1,8(sp)=
=0A-	addi	sp,sp,16=0A-	ret=0A+	mv	a1,a2=0A .L1:=0A 	ret=0A .L2:=0A-	negw	a4=
,a4=0A-	srl	a1,a1,a4=0A-	sd	a1,0(sp)=0A-	sd	zero,8(sp)=0A-	ld	a0,0(sp)=0A-	=
ld	a1,8(sp)=0A-	addi	sp,sp,16=0A+	negw	a0,a4=0A+	li	a2,0=0A+	srl	a0,a1,a0=
=0A+	mv	a1,a2=0A+	ret=0A+SYM_FUNC_END(__lshrti3)=0A+EXPORT_SYMBOL(__lshrti3=
)=0A+=0A+SYM_FUNC_START(__ashrti3)=0A+	beqz	a2, .L3=0A+	li	a5,64=0A+	sub	a5=
,a5,a2=0A+	sext.w	a4,a5=0A+	blez	a5, .L4=0A+	sext.w	a2,a2=0A+	srl	a0,a0,a2=
=0A+	sll	a4,a1,a4=0A+	sra	a2,a1,a2=0A+	or	a0,a0,a4=0A+	mv	a1,a2=0A+.L3:=0A+=
	ret=0A+.L4:=0A+	negw	a0,a4=0A+	srai	a2,a1,0x3f=0A+	sra	a0,a1,a0=0A+	mv	a1,=
a2=0A+	ret=0A+SYM_FUNC_END(__ashrti3)=0A+EXPORT_SYMBOL(__ashrti3)=0A+=0A+SY=
M_FUNC_START(__ashlti3)=0A+	beqz	a2, .L5=0A+	li	a5,64=0A+	sub	a5,a5,a2=0A+	=
sext.w	a4,a5=0A+	blez	a5, .L6=0A+	sext.w	a2,a2=0A+	sll	a1,a1,a2=0A+	srl	a4,=
a0,a4=0A+	sll	a2,a0,a2=0A+	or	a1,a1,a4=0A+	mv	a0,a2=0A+.L5:=0A+	ret=0A+.L6:=
=0A+	negw	a1,a4=0A+	li	a2,0=0A+	sll	a1,a0,a1=0A+	mv	a0,a2=0A 	ret=0A-ENDPRO=
C(__lshrti3)=0A+SYM_FUNC_END(__ashlti3)=0A+EXPORT_SYMBOL(__ashlti3)=0A-- =
=0A2.30.2=0A=0A
--xPnGHc1wEKH4DRrq--
