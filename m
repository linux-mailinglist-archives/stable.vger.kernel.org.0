Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C41A554A134
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 23:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243381AbiFMVS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 17:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352576AbiFMVSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 17:18:41 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC00FFD
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 14:01:55 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id k19so8580214wrd.8
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 14:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=rqwcA7EmUCuoOS5UBpMHVAhIsEPoy5t7c6/3quJMsH8=;
        b=kxz4FW0+E5oPmwqbLWkyheIFud+6kmlfoTmmSib1u5dejG837uG5nXJ48eSWvfA8sm
         R5FESQRm6VD3Kmuf7BRaGqPIjvpPKxq7HB+WleFX0AYioelfainD3jTbM+3LCJWqqBGW
         QpruAE67LWR2P2Th4GLRehKTXBLOUn8PLcPWEo366EUkY+R23qibiSGeNN73YcRckiSN
         ormCMXQiV0NqaGfDZppu9alLAdeUwSBVbk01qfZ2QYjy7jplFSHhKNtZtDNLhJ96uCsG
         uBULOrP7dvg9ySQGpWcimk5tSl/7n0O3xaDhk8qoxNnqpQtm8/d6I3Djn70QJp+NounZ
         6COQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=rqwcA7EmUCuoOS5UBpMHVAhIsEPoy5t7c6/3quJMsH8=;
        b=tRLN/AtyBEJ1J7qSsLto+3IN4X7+w3rXXDZz6B8/Hc171mZ/94ietl+OR00gt/ajDw
         ldfNXOxFx9FF9hb0/6xiIuGrH45zLYQKEk3jfiKwTRlZchv3e+IJhYJSQqVzfT2woxud
         LLrgx5WJuaApsX8VZTc33SERO7mdkekyc8bEoPTTiCfjXGN8XY3GrWmKqexgFRdCsLQh
         ncHVroCCFlMbog+yfU6HewWasCgZv/u8S0asGGoAhdR3H62K+UbTtVrVI6BIOz96F7RS
         Ub3nAUramP6FEwuG5IXXlWlmA60vZZduycSnsk9KvOQM5vArt4X12sazeJnr5NLfth46
         FVpw==
X-Gm-Message-State: AJIora9G3pI/AhylHV/HtEUVAk5LhqPmUL2vqreSuQ1d1CWEH1D6RZ3V
        nD45QNByDKZuX3KwsgDFXMKCApAyAj4=
X-Google-Smtp-Source: AGRyM1v7Y4CZH493DcjA9kvpzjKwqSBIxSif3SqyqQsoSTiYCy+nR3+LBnQTwVlqRyiln9BhkIKtsQ==
X-Received: by 2002:adf:e688:0:b0:210:3362:17b1 with SMTP id r8-20020adfe688000000b00210336217b1mr1478876wrm.19.1655154113478;
        Mon, 13 Jun 2022 14:01:53 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id w4-20020adfcd04000000b0021863a560f6sm9593832wrm.3.2022.06.13.14.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 14:01:52 -0700 (PDT)
Date:   Mon, 13 Jun 2022 22:01:50 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: backport of d51f86cfd8e3 ("powerpc/mm: Switch obsolete dssall to
 .long")
Message-ID: <Yqelvu3VN/Y53YIq@debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dPa1ZCj3sT5J8z27"
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


--dPa1ZCj3sT5J8z27
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

The stable branches 4.19-stable and 5.4-stable will also need
d51f86cfd8e3 ("powerpc/mm: Switch obsolete dssall to .long") for powerpc
allmodconfig failure.

The backport for both is in the attached mbox.


--
Regards
Sudip

--dPa1ZCj3sT5J8z27
Content-Type: application/mbox
Content-Disposition: attachment; filename="backport_5.4-stable.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 31612a4f9e0d8d479133e1bc89a58aac753f6eed Mon Sep 17 00:00:00 2001=0A=
=46rom: Alexey Kardashevskiy <aik@ozlabs.ru>=0ADate: Tue, 21 Dec 2021 16:59=
:03 +1100=0ASubject: [PATCH] powerpc/mm: Switch obsolete dssall to .long=0A=
=0Acommit d51f86cfd8e378d4907958db77da3074f6dce3ba upstream.=0A=0AThe dssal=
l ("Data Stream Stop All") instruction is obsolete altogether=0Awith other =
Data Cache Instructions since ISA 2.03 (year 2006).=0A=0ALLVM IAS does not =
support it but PPC970 seems to be using it.=0AThis switches dssall to .long=
 as there is no much point in fixing LLVM.=0A=0ASigned-off-by: Alexey Karda=
shevskiy <aik@ozlabs.ru>=0ASigned-off-by: Michael Ellerman <mpe@ellerman.id=
=2Eau>=0ALink: https://lore.kernel.org/r/20211221055904.555763-6-aik@ozlabs=
=2Eru=0A[sudip: adjust context]=0ASigned-off-by: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0A---=0A arch/powerpc/include/asm/ppc-opcode.h   | 2 ++=
=0A arch/powerpc/kernel/idle_6xx.S          | 2 +-=0A arch/powerpc/kernel/l=
2cr_6xx.S          | 6 +++---=0A arch/powerpc/kernel/swsusp_32.S         | =
2 +-=0A arch/powerpc/kernel/swsusp_asm64.S      | 2 +-=0A arch/powerpc/mm/m=
mu_context.c           | 2 +-=0A arch/powerpc/platforms/powermac/cache.S | =
4 ++--=0A 7 files changed, 11 insertions(+), 9 deletions(-)=0A=0Adiff --git=
 a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opc=
ode.h=0Aindex c1df75edde44..a9af63bd430f 100644=0A--- a/arch/powerpc/includ=
e/asm/ppc-opcode.h=0A+++ b/arch/powerpc/include/asm/ppc-opcode.h=0A@@ -204,=
6 +204,7 @@=0A #define PPC_INST_ICBT			0x7c00002c=0A #define PPC_INST_ICSWX=
			0x7c00032d=0A #define PPC_INST_ICSWEPX		0x7c00076d=0A+#define PPC_INST_D=
SSALL			0x7e00066c=0A #define PPC_INST_ISEL			0x7c00001e=0A #define PPC_INS=
T_ISEL_MASK		0xfc00003e=0A #define PPC_INST_LDARX			0x7c0000a8=0A@@ -439,6 =
+440,7 @@=0A 					__PPC_RA(a) | __PPC_RB(b))=0A #define	PPC_DCBZL(a, b)		st=
ringify_in_c(.long PPC_INST_DCBZL | \=0A 					__PPC_RA(a) | __PPC_RB(b))=0A=
+#define PPC_DSSALL		stringify_in_c(.long PPC_INST_DSSALL)=0A #define PPC_L=
QARX(t, a, b, eh)	stringify_in_c(.long PPC_INST_LQARX | \=0A 					___PPC_RT=
(t) | ___PPC_RA(a) | \=0A 					___PPC_RB(b) | __PPC_EH(eh))=0Adiff --git a/=
arch/powerpc/kernel/idle_6xx.S b/arch/powerpc/kernel/idle_6xx.S=0Aindex 0ff=
dd18b9f26..acb8215c5a01 100644=0A--- a/arch/powerpc/kernel/idle_6xx.S=0A+++=
 b/arch/powerpc/kernel/idle_6xx.S=0A@@ -129,7 +129,7 @@ BEGIN_FTR_SECTION=
=0A END_FTR_SECTION_IFCLR(CPU_FTR_NO_DPM)=0A 	mtspr	SPRN_HID0,r4=0A BEGIN_F=
TR_SECTION=0A-	DSSALL=0A+	PPC_DSSALL=0A 	sync=0A END_FTR_SECTION_IFSET(CPU_=
FTR_ALTIVEC)=0A 	lwz	r8,TI_LOCAL_FLAGS(r2)	/* set napping bit */=0Adiff --g=
it a/arch/powerpc/kernel/l2cr_6xx.S b/arch/powerpc/kernel/l2cr_6xx.S=0Ainde=
x 2020d255585f..7684f644e93e 100644=0A--- a/arch/powerpc/kernel/l2cr_6xx.S=
=0A+++ b/arch/powerpc/kernel/l2cr_6xx.S=0A@@ -96,7 +96,7 @@ END_FTR_SECTION=
_IFCLR(CPU_FTR_L2CR)=0A =0A 	/* Stop DST streams */=0A BEGIN_FTR_SECTION=0A=
-	DSSALL=0A+	PPC_DSSALL=0A 	sync=0A END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)=
=0A =0A@@ -293,7 +293,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_L3CR)=0A 	isync=0A=
 =0A 	/* Stop DST streams */=0A-	DSSALL=0A+	PPC_DSSALL=0A 	sync=0A =0A 	/* =
Get the current enable bit of the L3CR into r4 */=0A@@ -402,7 +402,7 @@ END=
_FTR_SECTION_IFSET(CPU_FTR_L3CR)=0A _GLOBAL(__flush_disable_L1)=0A 	/* Stop=
 pending alitvec streams and memory accesses */=0A BEGIN_FTR_SECTION=0A-	DS=
SALL=0A+	PPC_DSSALL=0A END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)=0A  	sync=0A =
=0Adiff --git a/arch/powerpc/kernel/swsusp_32.S b/arch/powerpc/kernel/swsus=
p_32.S=0Aindex cbdf86228eaa..54c44aea338c 100644=0A--- a/arch/powerpc/kerne=
l/swsusp_32.S=0A+++ b/arch/powerpc/kernel/swsusp_32.S=0A@@ -181,7 +181,7 @@=
 _GLOBAL(swsusp_arch_resume)=0A #ifdef CONFIG_ALTIVEC=0A 	/* Stop pending a=
litvec streams and memory accesses */=0A BEGIN_FTR_SECTION=0A-	DSSALL=0A+	P=
PC_DSSALL=0A END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)=0A #endif=0A  	sync=0Ad=
iff --git a/arch/powerpc/kernel/swsusp_asm64.S b/arch/powerpc/kernel/swsusp=
_asm64.S=0Aindex 6d3189830dd3..068a268a8013 100644=0A--- a/arch/powerpc/ker=
nel/swsusp_asm64.S=0A+++ b/arch/powerpc/kernel/swsusp_asm64.S=0A@@ -142,7 +=
142,7 @@ END_FW_FTR_SECTION_IFCLR(FW_FEATURE_LPAR)=0A _GLOBAL(swsusp_arch_r=
esume)=0A 	/* Stop pending alitvec streams and memory accesses */=0A BEGIN_=
FTR_SECTION=0A-	DSSALL=0A+	PPC_DSSALL=0A END_FTR_SECTION_IFSET(CPU_FTR_ALTI=
VEC)=0A 	sync=0A =0Adiff --git a/arch/powerpc/mm/mmu_context.c b/arch/power=
pc/mm/mmu_context.c=0Aindex 18f20da0d348..64290d343b55 100644=0A--- a/arch/=
powerpc/mm/mmu_context.c=0A+++ b/arch/powerpc/mm/mmu_context.c=0A@@ -79,7 +=
79,7 @@ void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *n=
ext,=0A 	 * context=0A 	 */=0A 	if (cpu_has_feature(CPU_FTR_ALTIVEC))=0A-		=
asm volatile ("dssall");=0A+		asm volatile (PPC_DSSALL);=0A =0A 	if (new_on=
_cpu)=0A 		radix_kvm_prefetch_workaround(next);=0Adiff --git a/arch/powerpc=
/platforms/powermac/cache.S b/arch/powerpc/platforms/powermac/cache.S=0Aind=
ex da69e0fcb4f1..9b85b030cbeb 100644=0A--- a/arch/powerpc/platforms/powerma=
c/cache.S=0A+++ b/arch/powerpc/platforms/powermac/cache.S=0A@@ -48,7 +48,7 =
@@ flush_disable_75x:=0A =0A 	/* Stop DST streams */=0A BEGIN_FTR_SECTION=
=0A-	DSSALL=0A+	PPC_DSSALL=0A 	sync=0A END_FTR_SECTION_IFSET(CPU_FTR_ALTIVE=
C)=0A =0A@@ -196,7 +196,7 @@ flush_disable_745x:=0A 	isync=0A =0A 	/* Stop =
prefetch streams */=0A-	DSSALL=0A+	PPC_DSSALL=0A 	sync=0A =0A 	/* Disable L=
2 prefetching */=0A-- =0A2.30.2=0A=0A
--dPa1ZCj3sT5J8z27
Content-Type: application/mbox
Content-Disposition: attachment; filename="backport_4.19-stable.mbox"
Content-Transfer-Encoding: quoted-printable

=46rom 6af13d6458ded03a1e0028f7cf83f05774ef83aa Mon Sep 17 00:00:00 2001=0A=
=46rom: Alexey Kardashevskiy <aik@ozlabs.ru>=0ADate: Tue, 21 Dec 2021 16:59=
:03 +1100=0ASubject: [PATCH] powerpc/mm: Switch obsolete dssall to .long=0A=
=0Acommit d51f86cfd8e378d4907958db77da3074f6dce3ba upstream.=0A=0AThe dssal=
l ("Data Stream Stop All") instruction is obsolete altogether=0Awith other =
Data Cache Instructions since ISA 2.03 (year 2006).=0A=0ALLVM IAS does not =
support it but PPC970 seems to be using it.=0AThis switches dssall to .long=
 as there is no much point in fixing LLVM.=0A=0ASigned-off-by: Alexey Karda=
shevskiy <aik@ozlabs.ru>=0ASigned-off-by: Michael Ellerman <mpe@ellerman.id=
=2Eau>=0ALink: https://lore.kernel.org/r/20211221055904.555763-6-aik@ozlabs=
=2Eru=0A[sudip: adjust context]=0ASigned-off-by: Sudip Mukherjee <sudipm.mu=
kherjee@gmail.com>=0A---=0A arch/powerpc/include/asm/ppc-opcode.h   | 2 ++=
=0A arch/powerpc/kernel/idle_6xx.S          | 2 +-=0A arch/powerpc/kernel/l=
2cr_6xx.S          | 6 +++---=0A arch/powerpc/kernel/swsusp_32.S         | =
2 +-=0A arch/powerpc/kernel/swsusp_asm64.S      | 2 +-=0A arch/powerpc/mm/m=
mu_context.c           | 2 +-=0A arch/powerpc/platforms/powermac/cache.S | =
4 ++--=0A 7 files changed, 11 insertions(+), 9 deletions(-)=0A=0Adiff --git=
 a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opc=
ode.h=0Aindex d9d5391b2af6..d0d3dab56225 100644=0A--- a/arch/powerpc/includ=
e/asm/ppc-opcode.h=0A+++ b/arch/powerpc/include/asm/ppc-opcode.h=0A@@ -207,=
6 +207,7 @@=0A #define PPC_INST_ICBT			0x7c00002c=0A #define PPC_INST_ICSWX=
			0x7c00032d=0A #define PPC_INST_ICSWEPX		0x7c00076d=0A+#define PPC_INST_D=
SSALL			0x7e00066c=0A #define PPC_INST_ISEL			0x7c00001e=0A #define PPC_INS=
T_ISEL_MASK		0xfc00003e=0A #define PPC_INST_LDARX			0x7c0000a8=0A@@ -424,6 =
+425,7 @@=0A 					__PPC_RA(a) | __PPC_RB(b))=0A #define	PPC_DCBZL(a, b)		st=
ringify_in_c(.long PPC_INST_DCBZL | \=0A 					__PPC_RA(a) | __PPC_RB(b))=0A=
+#define PPC_DSSALL		stringify_in_c(.long PPC_INST_DSSALL)=0A #define PPC_L=
QARX(t, a, b, eh)	stringify_in_c(.long PPC_INST_LQARX | \=0A 					___PPC_RT=
(t) | ___PPC_RA(a) | \=0A 					___PPC_RB(b) | __PPC_EH(eh))=0Adiff --git a/=
arch/powerpc/kernel/idle_6xx.S b/arch/powerpc/kernel/idle_6xx.S=0Aindex ff0=
26c9d3cab..75de66acc3d1 100644=0A--- a/arch/powerpc/kernel/idle_6xx.S=0A+++=
 b/arch/powerpc/kernel/idle_6xx.S=0A@@ -133,7 +133,7 @@ BEGIN_FTR_SECTION=
=0A END_FTR_SECTION_IFCLR(CPU_FTR_NO_DPM)=0A 	mtspr	SPRN_HID0,r4=0A BEGIN_F=
TR_SECTION=0A-	DSSALL=0A+	PPC_DSSALL=0A 	sync=0A END_FTR_SECTION_IFSET(CPU_=
FTR_ALTIVEC)=0A 	CURRENT_THREAD_INFO(r9, r1)=0Adiff --git a/arch/powerpc/ke=
rnel/l2cr_6xx.S b/arch/powerpc/kernel/l2cr_6xx.S=0Aindex 6e7dbb7d527c..9d4b=
42d115cd 100644=0A--- a/arch/powerpc/kernel/l2cr_6xx.S=0A+++ b/arch/powerpc=
/kernel/l2cr_6xx.S=0A@@ -108,7 +108,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_L2CR=
)=0A =0A 	/* Stop DST streams */=0A BEGIN_FTR_SECTION=0A-	DSSALL=0A+	PPC_DS=
SALL=0A 	sync=0A END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)=0A =0A@@ -305,7 +30=
5,7 @@ END_FTR_SECTION_IFCLR(CPU_FTR_L3CR)=0A 	isync=0A =0A 	/* Stop DST st=
reams */=0A-	DSSALL=0A+	PPC_DSSALL=0A 	sync=0A =0A 	/* Get the current enab=
le bit of the L3CR into r4 */=0A@@ -414,7 +414,7 @@ END_FTR_SECTION_IFSET(C=
PU_FTR_L3CR)=0A _GLOBAL(__flush_disable_L1)=0A 	/* Stop pending alitvec str=
eams and memory accesses */=0A BEGIN_FTR_SECTION=0A-	DSSALL=0A+	PPC_DSSALL=
=0A END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)=0A  	sync=0A =0Adiff --git a/arc=
h/powerpc/kernel/swsusp_32.S b/arch/powerpc/kernel/swsusp_32.S=0Aindex cbdf=
86228eaa..54c44aea338c 100644=0A--- a/arch/powerpc/kernel/swsusp_32.S=0A+++=
 b/arch/powerpc/kernel/swsusp_32.S=0A@@ -181,7 +181,7 @@ _GLOBAL(swsusp_arc=
h_resume)=0A #ifdef CONFIG_ALTIVEC=0A 	/* Stop pending alitvec streams and =
memory accesses */=0A BEGIN_FTR_SECTION=0A-	DSSALL=0A+	PPC_DSSALL=0A END_FT=
R_SECTION_IFSET(CPU_FTR_ALTIVEC)=0A #endif=0A  	sync=0Adiff --git a/arch/po=
werpc/kernel/swsusp_asm64.S b/arch/powerpc/kernel/swsusp_asm64.S=0Aindex f8=
3bf6f72cb0..0af06f3dbb25 100644=0A--- a/arch/powerpc/kernel/swsusp_asm64.S=
=0A+++ b/arch/powerpc/kernel/swsusp_asm64.S=0A@@ -143,7 +143,7 @@ END_FW_FT=
R_SECTION_IFCLR(FW_FEATURE_LPAR)=0A _GLOBAL(swsusp_arch_resume)=0A 	/* Stop=
 pending alitvec streams and memory accesses */=0A BEGIN_FTR_SECTION=0A-	DS=
SALL=0A+	PPC_DSSALL=0A END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)=0A 	sync=0A =
=0Adiff --git a/arch/powerpc/mm/mmu_context.c b/arch/powerpc/mm/mmu_context=
=2Ec=0Aindex f84e14f23e50..78a638ccc70f 100644=0A--- a/arch/powerpc/mm/mmu_=
context.c=0A+++ b/arch/powerpc/mm/mmu_context.c=0A@@ -83,7 +83,7 @@ void sw=
itch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *next,=0A 	 * con=
text=0A 	 */=0A 	if (cpu_has_feature(CPU_FTR_ALTIVEC))=0A-		asm volatile ("=
dssall");=0A+		asm volatile (PPC_DSSALL);=0A =0A 	if (new_on_cpu)=0A 		radi=
x_kvm_prefetch_workaround(next);=0Adiff --git a/arch/powerpc/platforms/powe=
rmac/cache.S b/arch/powerpc/platforms/powermac/cache.S=0Aindex 27862feee4a5=
=2E.0dde4a7a6016 100644=0A--- a/arch/powerpc/platforms/powermac/cache.S=0A+=
++ b/arch/powerpc/platforms/powermac/cache.S=0A@@ -53,7 +53,7 @@ flush_disa=
ble_75x:=0A =0A 	/* Stop DST streams */=0A BEGIN_FTR_SECTION=0A-	DSSALL=0A+=
	PPC_DSSALL=0A 	sync=0A END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)=0A =0A@@ -20=
1,7 +201,7 @@ flush_disable_745x:=0A 	isync=0A =0A 	/* Stop prefetch stream=
s */=0A-	DSSALL=0A+	PPC_DSSALL=0A 	sync=0A =0A 	/* Disable L2 prefetching *=
/=0A-- =0A2.30.2=0A=0A
--dPa1ZCj3sT5J8z27--
