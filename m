Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB0C4D387F
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 06:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfJKEaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 00:30:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34029 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726088AbfJKEaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 00:30:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id EEB762223C;
        Fri, 11 Oct 2019 00:30:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 11 Oct 2019 00:30:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=T0hRE8
        6KY7bSSg6QWOhJdK2/tPx81VrTCvp50Wn+dMc=; b=vDfAmO0l/Rp5ex/MW1mSHT
        Lzecb7PFJLYfIHTVLdp+rkNfYIgHzpUgRPakY2/SMUmWHOEfF4d1kIXUE/kybGUW
        eLgxbPEh2190Xp8WpPC22UbzzJL3eMWA86tONA/1GH13juJ+u4szhHTxxiJYSSEz
        /kPaUAV/s9eL4k6jOmK15r1bzop+U7NKxFis+2jB/fFlaQrJ5nHhAEw4It1piGWK
        U3uqsU30m3vZ0g5C8QvxQTJJhXYTmOdNjT9j/WlSvD7GnNYssxRITXQRNdD2emJF
        YOsRogqbNn6a0DxGwW5+AWY30Q0Cfcy4pDyWU4KW8/ljhc8YdTy18JbyhuOev9RQ
        ==
X-ME-Sender: <xms:dAWgXcZtXZhfSMupkTWqDuLxNXf4akEVuD0dl3LlBDpjbQViOO-bVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrieeggdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:dAWgXVFaWzKtKxwfcmbviircfUl2Y_rjP2YjxpiT2ma0qT4Kg4qCpw>
    <xmx:dAWgXRbREcW5TE1A3BgImEhwgOryeO7q11PBsVgwOTLYCwwebhdLPw>
    <xmx:dAWgXe3rgcjjpSlfHmhnejl7bI1__6dJBXoB5sw6Crv_QZBqDZ3cEQ>
    <xmx:dAWgXQsbj9Ta8YAV23-cCeLMyt4W9_q1YxnFVoBiz4OXLeWZXT_dzQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1729AD6005F;
        Fri, 11 Oct 2019 00:30:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] MIPS: Treat Loongson Extensions as ASEs" failed to apply to 4.14-stable tree
To:     jiaxun.yang@flygoat.com, chenhc@lemote.com, paul.burton@mips.com,
        ysu@wavecomp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Oct 2019 06:30:42 +0200
Message-ID: <15707682422036@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d2f965549006acb865c4638f1f030ebcefdc71f6 Mon Sep 17 00:00:00 2001
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
Date: Wed, 29 May 2019 16:42:59 +0800
Subject: [PATCH] MIPS: Treat Loongson Extensions as ASEs

Recently, binutils had split Loongson-3 Extensions into four ASEs:
MMI, CAM, EXT, EXT2. This patch do the samething in kernel and expose
them in cpuinfo so applications can probe supported ASEs at runtime.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Huacai Chen <chenhc@lemote.com>
Cc: Yunqiang Su <ysu@wavecomp.com>
Cc: stable@vger.kernel.org # v4.14+
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: linux-mips@vger.kernel.org

diff --git a/arch/mips/include/asm/cpu-features.h b/arch/mips/include/asm/cpu-features.h
index 6998a9796499..4e2bea8875f5 100644
--- a/arch/mips/include/asm/cpu-features.h
+++ b/arch/mips/include/asm/cpu-features.h
@@ -397,6 +397,22 @@
 #define cpu_has_dsp3		__ase(MIPS_ASE_DSP3)
 #endif
 
+#ifndef cpu_has_loongson_mmi
+#define cpu_has_loongson_mmi		__ase(MIPS_ASE_LOONGSON_MMI)
+#endif
+
+#ifndef cpu_has_loongson_cam
+#define cpu_has_loongson_cam		__ase(MIPS_ASE_LOONGSON_CAM)
+#endif
+
+#ifndef cpu_has_loongson_ext
+#define cpu_has_loongson_ext		__ase(MIPS_ASE_LOONGSON_EXT)
+#endif
+
+#ifndef cpu_has_loongson_ext2
+#define cpu_has_loongson_ext2		__ase(MIPS_ASE_LOONGSON_EXT2)
+#endif
+
 #ifndef cpu_has_mipsmt
 #define cpu_has_mipsmt		__isa_lt_and_ase(6, MIPS_ASE_MIPSMT)
 #endif
diff --git a/arch/mips/include/asm/cpu.h b/arch/mips/include/asm/cpu.h
index 6826f0a657fb..7fddcb8350c6 100644
--- a/arch/mips/include/asm/cpu.h
+++ b/arch/mips/include/asm/cpu.h
@@ -428,5 +428,9 @@ enum cpu_type_enum {
 #define MIPS_ASE_MSA		0x00000100 /* MIPS SIMD Architecture */
 #define MIPS_ASE_DSP3		0x00000200 /* Signal Processing ASE Rev 3*/
 #define MIPS_ASE_MIPS16E2	0x00000400 /* MIPS16e2 */
+#define MIPS_ASE_LOONGSON_MMI	0x00000800 /* Loongson MultiMedia extensions Instructions */
+#define MIPS_ASE_LOONGSON_CAM	0x00001000 /* Loongson CAM */
+#define MIPS_ASE_LOONGSON_EXT	0x00002000 /* Loongson EXTensions */
+#define MIPS_ASE_LOONGSON_EXT2	0x00004000 /* Loongson EXTensions R2 */
 
 #endif /* _ASM_CPU_H */
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 93b46be14688..c2eb392597bf 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1547,6 +1547,8 @@ static inline void cpu_probe_legacy(struct cpuinfo_mips *c, unsigned int cpu)
 			__cpu_name[cpu] = "ICT Loongson-3";
 			set_elf_platform(cpu, "loongson3a");
 			set_isa(c, MIPS_CPU_ISA_M64R1);
+			c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
+				MIPS_ASE_LOONGSON_EXT);
 			break;
 		case PRID_REV_LOONGSON3B_R1:
 		case PRID_REV_LOONGSON3B_R2:
@@ -1554,6 +1556,8 @@ static inline void cpu_probe_legacy(struct cpuinfo_mips *c, unsigned int cpu)
 			__cpu_name[cpu] = "ICT Loongson-3";
 			set_elf_platform(cpu, "loongson3b");
 			set_isa(c, MIPS_CPU_ISA_M64R1);
+			c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
+				MIPS_ASE_LOONGSON_EXT);
 			break;
 		}
 
@@ -1920,6 +1924,8 @@ static inline void cpu_probe_loongson(struct cpuinfo_mips *c, unsigned int cpu)
 		decode_configs(c);
 		c->options |= MIPS_CPU_FTLB | MIPS_CPU_TLBINV | MIPS_CPU_LDPTE;
 		c->writecombine = _CACHE_UNCACHED_ACCELERATED;
+		c->ases |= (MIPS_ASE_LOONGSON_MMI | MIPS_ASE_LOONGSON_CAM |
+			MIPS_ASE_LOONGSON_EXT | MIPS_ASE_LOONGSON_EXT2);
 		break;
 	default:
 		panic("Unknown Loongson Processor ID!");
diff --git a/arch/mips/kernel/proc.c b/arch/mips/kernel/proc.c
index b2de408a259e..f8d36710cd58 100644
--- a/arch/mips/kernel/proc.c
+++ b/arch/mips/kernel/proc.c
@@ -124,6 +124,10 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 	if (cpu_has_eva)	seq_printf(m, "%s", " eva");
 	if (cpu_has_htw)	seq_printf(m, "%s", " htw");
 	if (cpu_has_xpa)	seq_printf(m, "%s", " xpa");
+	if (cpu_has_loongson_mmi)	seq_printf(m, "%s", " loongson-mmi");
+	if (cpu_has_loongson_cam)	seq_printf(m, "%s", " loongson-cam");
+	if (cpu_has_loongson_ext)	seq_printf(m, "%s", " loongson-ext");
+	if (cpu_has_loongson_ext2)	seq_printf(m, "%s", " loongson-ext2");
 	seq_printf(m, "\n");
 
 	if (cpu_has_mmips) {

