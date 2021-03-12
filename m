Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634DA338E1A
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 14:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhCLNA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 08:00:56 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:35045 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231597AbhCLNAl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 08:00:41 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id D987A1942C36;
        Fri, 12 Mar 2021 08:00:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 12 Mar 2021 08:00:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mNmKMM
        RApw3ZjjjOhIwWwYA0GPV02PyFoRLqMF2IY6Q=; b=rrVDL9yV9OBdU9bSs0E2k0
        f1R+sRvQc5EVv6K2LhfDfjzYBtJyzfKd3uNgxR9/WyMveq/sjsDDagiAL6vsIpqd
        uJgOcb07BMv0rBb/s1lT/HLySDUN6XPzYXm7iaF1jKZbJrji7niAEvOZ4sm20gNQ
        b7DEAtLYFONnDDAw7FcHMYMRBE6WdBroAeHUxHDM6N15W+T1GOJKVaP12vWaa1Br
        gF+WvZGVFkWL05J5fF41FDXeT/5mCbpzwC2UYjKNC7bDz6njPnK3FwdI7bP9Z9Oj
        3R7552SmS4luuVgVgZOm/0LEcz57RSCaHgQO1EHeyN405ESnWIMLRWCfbDkOLpUw
        ==
X-ME-Sender: <xms:-GVLYLrGQPX4WhDMT9HrD-z5lMaySraS2Ce0-bweAGtjErUd6--UQQ>
    <xme:-GVLYDAiWLLPPDBtvRSX-wLLFp90OKaxRQuSg3U8N8KZASBRIhaCbIC97LLacYYrT
    erMxbWR-iCiMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvvddggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:-GVLYBu_7wSTF5YGa_FMqvx5oyn8s15gUQLxwqnaJQ-HSg6mvOXHWA>
    <xmx:-GVLYKJiJaApFtg3855xcWZrlQL6-yT6bSJF4832VG7QaqNcYwn7MA>
    <xmx:-GVLYAYRWZJ74WOZzix9FD7QnM76I_YK5-SNPB7-RVm0zPVawF3Cog>
    <xmx:-GVLYJxoUEKMYeu_ZLRwQz7iLpRqb1sVwTueFjguat566cfg_ISxjw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 828BB1080054;
        Fri, 12 Mar 2021 08:00:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] MIPS: kernel: Reserve exception base early to prevent" failed to apply to 4.14-stable tree
To:     tsbogend@alpha.franken.de, Sergey.Semin@baikalelectronics.ru,
        f.fainelli@gmail.com, fancer.lancer@gmail.com,
        kdasu.kdev@gmail.com, rppt@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Mar 2021 14:00:33 +0100
Message-ID: <16155540338122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From bd67b711bfaa02cf19e88aa2d9edae5c1c1d2739 Mon Sep 17 00:00:00 2001
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Date: Mon, 8 Mar 2021 10:24:47 +0100
Subject: [PATCH] MIPS: kernel: Reserve exception base early to prevent
 corruption

BMIPS is one of the few platforms that do change the exception base.
After commit 2dcb39645441 ("memblock: do not start bottom-up allocations
with kernel_end") we started seeing BMIPS boards fail to boot with the
built-in FDT being corrupted.

Before the cited commit, early allocations would be in the [kernel_end,
RAM_END] range, but after commit they would be within [RAM_START +
PAGE_SIZE, RAM_END].

The custom exception base handler that is installed by
bmips_ebase_setup() done for BMIPS5000 CPUs ends-up trampling on the
memory region allocated by unflatten_and_copy_device_tree() thus
corrupting the FDT used by the kernel.

To fix this, we need to perform an early reservation of the custom
exception space. Additional we reserve the first 4k (1k for R3k) for
either normal exception vector space (legacy CPUs) or special vectors
like cache exceptions.

Huge thanks to Serge for analysing and proposing a solution to this
issue.

Fixes: 2dcb39645441 ("memblock: do not start bottom-up allocations with kernel_end")
Reported-by: Kamal Dasu <kdasu.kdev@gmail.com>
Debugged-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

diff --git a/arch/mips/include/asm/traps.h b/arch/mips/include/asm/traps.h
index 6aa8f126a43d..b710e76c9c65 100644
--- a/arch/mips/include/asm/traps.h
+++ b/arch/mips/include/asm/traps.h
@@ -24,8 +24,11 @@ extern void (*board_ebase_setup)(void);
 extern void (*board_cache_error_setup)(void);
 
 extern int register_nmi_notifier(struct notifier_block *nb);
+extern void reserve_exception_space(phys_addr_t addr, unsigned long size);
 extern char except_vec_nmi[];
 
+#define VECTORSPACING 0x100	/* for EI/VI mode */
+
 #define nmi_notifier(fn, pri)						\
 ({									\
 	static struct notifier_block fn##_nb = {			\
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 9a89637b4ecf..b71892064f27 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -26,6 +26,7 @@
 #include <asm/elf.h>
 #include <asm/pgtable-bits.h>
 #include <asm/spram.h>
+#include <asm/traps.h>
 #include <linux/uaccess.h>
 
 #include "fpu-probe.h"
@@ -1628,6 +1629,7 @@ static inline void cpu_probe_broadcom(struct cpuinfo_mips *c, unsigned int cpu)
 		c->cputype = CPU_BMIPS3300;
 		__cpu_name[cpu] = "Broadcom BMIPS3300";
 		set_elf_platform(cpu, "bmips3300");
+		reserve_exception_space(0x400, VECTORSPACING * 64);
 		break;
 	case PRID_IMP_BMIPS43XX: {
 		int rev = c->processor_id & PRID_REV_MASK;
@@ -1638,6 +1640,7 @@ static inline void cpu_probe_broadcom(struct cpuinfo_mips *c, unsigned int cpu)
 			__cpu_name[cpu] = "Broadcom BMIPS4380";
 			set_elf_platform(cpu, "bmips4380");
 			c->options |= MIPS_CPU_RIXI;
+			reserve_exception_space(0x400, VECTORSPACING * 64);
 		} else {
 			c->cputype = CPU_BMIPS4350;
 			__cpu_name[cpu] = "Broadcom BMIPS4350";
@@ -1654,6 +1657,7 @@ static inline void cpu_probe_broadcom(struct cpuinfo_mips *c, unsigned int cpu)
 			__cpu_name[cpu] = "Broadcom BMIPS5000";
 		set_elf_platform(cpu, "bmips5000");
 		c->options |= MIPS_CPU_ULRI | MIPS_CPU_RIXI;
+		reserve_exception_space(0x1000, VECTORSPACING * 64);
 		break;
 	}
 }
@@ -2133,6 +2137,8 @@ void cpu_probe(void)
 	if (cpu == 0)
 		__ua_limit = ~((1ull << cpu_vmbits) - 1);
 #endif
+
+	reserve_exception_space(0, 0x1000);
 }
 
 void cpu_report(void)
diff --git a/arch/mips/kernel/cpu-r3k-probe.c b/arch/mips/kernel/cpu-r3k-probe.c
index abdbbe8c5a43..af654771918c 100644
--- a/arch/mips/kernel/cpu-r3k-probe.c
+++ b/arch/mips/kernel/cpu-r3k-probe.c
@@ -21,6 +21,7 @@
 #include <asm/fpu.h>
 #include <asm/mipsregs.h>
 #include <asm/elf.h>
+#include <asm/traps.h>
 
 #include "fpu-probe.h"
 
@@ -158,6 +159,8 @@ void cpu_probe(void)
 		cpu_set_fpu_opts(c);
 	else
 		cpu_set_nofpu_opts(c);
+
+	reserve_exception_space(0, 0x400);
 }
 
 void cpu_report(void)
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index e0352958e2f7..808b8b61ded1 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -2009,13 +2009,16 @@ void __noreturn nmi_exception_handler(struct pt_regs *regs)
 	nmi_exit();
 }
 
-#define VECTORSPACING 0x100	/* for EI/VI mode */
-
 unsigned long ebase;
 EXPORT_SYMBOL_GPL(ebase);
 unsigned long exception_handlers[32];
 unsigned long vi_handlers[64];
 
+void reserve_exception_space(phys_addr_t addr, unsigned long size)
+{
+	memblock_reserve(addr, size);
+}
+
 void __init *set_except_vector(int n, void *addr)
 {
 	unsigned long handler = (unsigned long) addr;
@@ -2367,10 +2370,7 @@ void __init trap_init(void)
 
 	if (!cpu_has_mips_r2_r6) {
 		ebase = CAC_BASE;
-		ebase_pa = virt_to_phys((void *)ebase);
 		vec_size = 0x400;
-
-		memblock_reserve(ebase_pa, vec_size);
 	} else {
 		if (cpu_has_veic || cpu_has_vint)
 			vec_size = 0x200 + VECTORSPACING*64;

