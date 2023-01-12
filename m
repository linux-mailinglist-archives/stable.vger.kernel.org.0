Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C456670D8
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 12:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233590AbjALL2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 06:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbjALL1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 06:27:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB0513F71;
        Thu, 12 Jan 2023 03:18:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42112B81E23;
        Thu, 12 Jan 2023 11:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4329DC433EF;
        Thu, 12 Jan 2023 11:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673522302;
        bh=3fcAX27K0EsPO93nYOzgptrzpBKRhBdGp3yJeZIWGHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjbP0Zc1yxZaAA7gFtQpZviCO/sYl84iw8CMNbx4L3QRMEYvXhaBNVkmOmBuadv3H
         oTissb5HcYtJH+UmZs/pDGKG1m37pI0seI1OSc7Emgl1HxSFboAOdfKKx4sEfgbHYn
         A3CQUDD0LWwII7Uiocf7ZvMcFHbmKrPHOObV4ekc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.87
Date:   Thu, 12 Jan 2023 12:18:07 +0100
Message-Id: <167352228521048@kroah.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <167352228525119@kroah.com>
References: <167352228525119@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 9f5d2e87150e..6a9589c7b1bc 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 86
+SUBLEVEL = 87
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index 9a18da3e10cc..b682189a2b5d 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -129,15 +129,16 @@ extern int vfp_restore_user_hwstate(struct user_vfp *,
 #define TIF_NEED_RESCHED	1	/* rescheduling necessary */
 #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
 #define TIF_UPROBE		3	/* breakpointed or singlestepping */
-#define TIF_SYSCALL_TRACE	4	/* syscall trace active */
-#define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
-#define TIF_SYSCALL_TRACEPOINT	6	/* syscall tracepoint instrumentation */
-#define TIF_SECCOMP		7	/* seccomp syscall filtering active */
-#define TIF_NOTIFY_SIGNAL	8	/* signal notifications exist */
+#define TIF_NOTIFY_SIGNAL	4	/* signal notifications exist */
 
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
-#define TIF_RESTORE_SIGMASK	20
+#define TIF_RESTORE_SIGMASK	19
+#define TIF_SYSCALL_TRACE	20	/* syscall trace active */
+#define TIF_SYSCALL_AUDIT	21	/* syscall auditing active */
+#define TIF_SYSCALL_TRACEPOINT	22	/* syscall tracepoint instrumentation */
+#define TIF_SECCOMP		23	/* seccomp syscall filtering active */
+
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
diff --git a/arch/arm/nwfpe/Makefile b/arch/arm/nwfpe/Makefile
index 303400fa2cdf..2aec85ab1e8b 100644
--- a/arch/arm/nwfpe/Makefile
+++ b/arch/arm/nwfpe/Makefile
@@ -11,3 +11,9 @@ nwfpe-y				+= fpa11.o fpa11_cpdo.o fpa11_cpdt.o \
 				   entry.o
 
 nwfpe-$(CONFIG_FPE_NWFPE_XP)	+= extended_cpdo.o
+
+# Try really hard to avoid generating calls to __aeabi_uldivmod() from
+# float64_rem() due to loop elision.
+ifdef CONFIG_CC_IS_CLANG
+CFLAGS_softfloat.o	+= -mllvm -replexitval=never
+endif
diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index 2d5533dd4ec2..146d3cd3f1b3 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -1045,7 +1045,10 @@ &wifi {
 
 /* PINCTRL - additions to nodes defined in sdm845.dtsi */
 &qup_spi2_default {
-	drive-strength = <16>;
+	pinconf {
+		pins = "gpio27", "gpio28", "gpio29", "gpio30";
+		drive-strength = <16>;
+	};
 };
 
 &qup_uart3_default{
diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index 617a634ac905..834fb463f99e 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -475,8 +475,10 @@ pinconf {
 };
 
 &qup_i2c12_default {
-	drive-strength = <2>;
-	bias-disable;
+	pinmux {
+		drive-strength = <2>;
+		bias-disable;
+	};
 };
 
 &qup_uart6_default {
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 7834ce3aa7f1..2dae702e7a5a 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -788,6 +788,7 @@ void __noreturn rtas_halt(void)
 
 /* Must be in the RMO region, so we place it here */
 static char rtas_os_term_buf[2048];
+static s32 ibm_os_term_token = RTAS_UNKNOWN_SERVICE;
 
 void rtas_os_term(char *str)
 {
@@ -799,16 +800,20 @@ void rtas_os_term(char *str)
 	 * this property may terminate the partition which we want to avoid
 	 * since it interferes with panic_timeout.
 	 */
-	if (RTAS_UNKNOWN_SERVICE == rtas_token("ibm,os-term") ||
-	    RTAS_UNKNOWN_SERVICE == rtas_token("ibm,extended-os-term"))
+	if (ibm_os_term_token == RTAS_UNKNOWN_SERVICE)
 		return;
 
 	snprintf(rtas_os_term_buf, 2048, "OS panic: %s", str);
 
+	/*
+	 * Keep calling as long as RTAS returns a "try again" status,
+	 * but don't use rtas_busy_delay(), which potentially
+	 * schedules.
+	 */
 	do {
-		status = rtas_call(rtas_token("ibm,os-term"), 1, 1, NULL,
+		status = rtas_call(ibm_os_term_token, 1, 1, NULL,
 				   __pa(rtas_os_term_buf));
-	} while (rtas_busy_delay(status));
+	} while (rtas_busy_delay_time(status));
 
 	if (status != 0)
 		printk(KERN_EMERG "ibm,os-term call failed %d\n", status);
@@ -1167,6 +1172,13 @@ void __init rtas_initialize(void)
 	no_entry = of_property_read_u32(rtas.dev, "linux,rtas-entry", &entry);
 	rtas.entry = no_entry ? rtas.base : entry;
 
+	/*
+	 * Discover these now to avoid device tree lookups in the
+	 * panic path.
+	 */
+	if (of_property_read_bool(rtas.dev, "ibm,extended-os-term"))
+		ibm_os_term_token = rtas_token("ibm,os-term");
+
 	/* If RTAS was found, allocate the RMO buffer for it and look for
 	 * the stop-self token if any
 	 */
diff --git a/arch/riscv/include/asm/mmu.h b/arch/riscv/include/asm/mmu.h
index 0099dc116168..5ff1f19fd45c 100644
--- a/arch/riscv/include/asm/mmu.h
+++ b/arch/riscv/include/asm/mmu.h
@@ -19,6 +19,8 @@ typedef struct {
 #ifdef CONFIG_SMP
 	/* A local icache flush is needed before user execution can resume. */
 	cpumask_t icache_stale_mask;
+	/* A local tlb flush is needed before user execution can resume. */
+	cpumask_t tlb_stale_mask;
 #endif
 } mm_context_t;
 
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 39b550310ec6..799c16e06525 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -386,7 +386,7 @@ static inline void update_mmu_cache(struct vm_area_struct *vma,
 	 * Relying on flush_tlb_fix_spurious_fault would suffice, but
 	 * the extra traps reduce performance.  So, eagerly SFENCE.VMA.
 	 */
-	local_flush_tlb_page(address);
+	flush_tlb_page(vma, address);
 }
 
 static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,
diff --git a/arch/riscv/include/asm/tlbflush.h b/arch/riscv/include/asm/tlbflush.h
index 801019381dea..907b9efd39a8 100644
--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -22,6 +22,24 @@ static inline void local_flush_tlb_page(unsigned long addr)
 {
 	ALT_FLUSH_TLB_PAGE(__asm__ __volatile__ ("sfence.vma %0" : : "r" (addr) : "memory"));
 }
+
+static inline void local_flush_tlb_all_asid(unsigned long asid)
+{
+	__asm__ __volatile__ ("sfence.vma x0, %0"
+			:
+			: "r" (asid)
+			: "memory");
+}
+
+static inline void local_flush_tlb_page_asid(unsigned long addr,
+		unsigned long asid)
+{
+	__asm__ __volatile__ ("sfence.vma %0, %1"
+			:
+			: "r" (addr), "r" (asid)
+			: "memory");
+}
+
 #else /* CONFIG_MMU */
 #define local_flush_tlb_all()			do { } while (0)
 #define local_flush_tlb_page(addr)		do { } while (0)
diff --git a/arch/riscv/include/asm/uaccess.h b/arch/riscv/include/asm/uaccess.h
index f314ff44c48d..d4d628af21a4 100644
--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -216,7 +216,7 @@ do {								\
 	might_fault();						\
 	access_ok(__p, sizeof(*__p)) ?		\
 		__get_user((x), __p) :				\
-		((x) = 0, -EFAULT);				\
+		((x) = (__force __typeof__(x))0, -EFAULT);	\
 })
 
 #define __put_user_asm(insn, x, ptr, err)			\
diff --git a/arch/riscv/kernel/probes/simulate-insn.h b/arch/riscv/kernel/probes/simulate-insn.h
index cb6ff7dccb92..de8474146a9b 100644
--- a/arch/riscv/kernel/probes/simulate-insn.h
+++ b/arch/riscv/kernel/probes/simulate-insn.h
@@ -31,9 +31,9 @@ __RISCV_INSN_FUNCS(fence,	0x7f, 0x0f);
 	} while (0)
 
 __RISCV_INSN_FUNCS(c_j,		0xe003, 0xa001);
-__RISCV_INSN_FUNCS(c_jr,	0xf007, 0x8002);
+__RISCV_INSN_FUNCS(c_jr,	0xf07f, 0x8002);
 __RISCV_INSN_FUNCS(c_jal,	0xe003, 0x2001);
-__RISCV_INSN_FUNCS(c_jalr,	0xf007, 0x9002);
+__RISCV_INSN_FUNCS(c_jalr,	0xf07f, 0x9002);
 __RISCV_INSN_FUNCS(c_beqz,	0xe003, 0xc001);
 __RISCV_INSN_FUNCS(c_bnez,	0xe003, 0xe001);
 __RISCV_INSN_FUNCS(c_ebreak,	0xffff, 0x9002);
diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index c2601150b91c..811e837a8c4e 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -60,7 +60,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 		} else {
 			fp = frame->fp;
 			pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
-						   (unsigned long *)(fp - 8));
+						   &frame->ra);
 		}
 
 	}
diff --git a/arch/riscv/mm/context.c b/arch/riscv/mm/context.c
index ee3459cb6750..cc4a47bda82a 100644
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -196,6 +196,16 @@ static void set_mm_asid(struct mm_struct *mm, unsigned int cpu)
 
 	if (need_flush_tlb)
 		local_flush_tlb_all();
+#ifdef CONFIG_SMP
+	else {
+		cpumask_t *mask = &mm->context.tlb_stale_mask;
+
+		if (cpumask_test_cpu(cpu, mask)) {
+			cpumask_clear_cpu(cpu, mask);
+			local_flush_tlb_all_asid(cntx & asid_mask);
+		}
+	}
+#endif
 }
 
 static void set_mm_noasid(struct mm_struct *mm)
diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index 64f8201237c2..efefc3986c48 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -5,23 +5,7 @@
 #include <linux/sched.h>
 #include <asm/sbi.h>
 #include <asm/mmu_context.h>
-
-static inline void local_flush_tlb_all_asid(unsigned long asid)
-{
-	__asm__ __volatile__ ("sfence.vma x0, %0"
-			:
-			: "r" (asid)
-			: "memory");
-}
-
-static inline void local_flush_tlb_page_asid(unsigned long addr,
-		unsigned long asid)
-{
-	__asm__ __volatile__ ("sfence.vma %0, %1"
-			:
-			: "r" (addr), "r" (asid)
-			: "memory");
-}
+#include <asm/tlbflush.h>
 
 void flush_tlb_all(void)
 {
@@ -31,6 +15,7 @@ void flush_tlb_all(void)
 static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long start,
 				  unsigned long size, unsigned long stride)
 {
+	struct cpumask *pmask = &mm->context.tlb_stale_mask;
 	struct cpumask *cmask = mm_cpumask(mm);
 	struct cpumask hmask;
 	unsigned int cpuid;
@@ -45,6 +30,15 @@ static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long start,
 	if (static_branch_unlikely(&use_asid_allocator)) {
 		unsigned long asid = atomic_long_read(&mm->context.id);
 
+		/*
+		 * TLB will be immediately flushed on harts concurrently
+		 * executing this MM context. TLB flush on other harts
+		 * is deferred until this MM context migrates there.
+		 */
+		cpumask_setall(pmask);
+		cpumask_clear_cpu(cpuid, pmask);
+		cpumask_andnot(pmask, pmask, cmask);
+
 		if (broadcast) {
 			riscv_cpuid_to_hartid_mask(cmask, &hmask);
 			sbi_remote_sfence_vma_asid(cpumask_bits(&hmask),
diff --git a/arch/x86/events/intel/uncore.h b/arch/x86/events/intel/uncore.h
index b9687980aab6..d6f7c6c1a930 100644
--- a/arch/x86/events/intel/uncore.h
+++ b/arch/x86/events/intel/uncore.h
@@ -2,6 +2,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <asm/apicdef.h>
+#include <asm/intel-family.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 
 #include <linux/perf_event.h>
diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index fcd95e93f479..8f371f3cbbd2 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -3804,6 +3804,21 @@ static const struct attribute_group *skx_iio_attr_update[] = {
 	NULL,
 };
 
+static void pmu_clear_mapping_attr(const struct attribute_group **groups,
+				   struct attribute_group *ag)
+{
+	int i;
+
+	for (i = 0; groups[i]; i++) {
+		if (groups[i] == ag) {
+			for (i++; groups[i]; i++)
+				groups[i - 1] = groups[i];
+			groups[i - 1] = NULL;
+			break;
+		}
+	}
+}
+
 static int
 pmu_iio_set_mapping(struct intel_uncore_type *type, struct attribute_group *ag)
 {
@@ -3852,7 +3867,7 @@ pmu_iio_set_mapping(struct intel_uncore_type *type, struct attribute_group *ag)
 clear_topology:
 	kfree(type->topology);
 clear_attr_update:
-	type->attr_update = NULL;
+	pmu_clear_mapping_attr(type->attr_update, ag);
 	return ret;
 }
 
@@ -5144,6 +5159,11 @@ static int icx_iio_get_topology(struct intel_uncore_type *type)
 
 static int icx_iio_set_mapping(struct intel_uncore_type *type)
 {
+	/* Detect ICX-D system. This case is not supported */
+	if (boot_cpu_data.x86_model == INTEL_FAM6_ICELAKE_D) {
+		pmu_clear_mapping_attr(type->attr_update, &icx_iio_mapping_group);
+		return -EPERM;
+	}
 	return pmu_iio_set_mapping(type, &icx_iio_mapping_group);
 }
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 8961f1031180..544e6c61e17d 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1951,6 +1951,8 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 		if (ctrl == PR_SPEC_FORCE_DISABLE)
 			task_set_spec_ib_force_disable(task);
 		task_update_spec_tif(task);
+		if (task == current)
+			indirect_branch_prediction_barrier();
 		break;
 	default:
 		return -ERANGE;
diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index a873577e49dc..6469d3135d26 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -526,7 +526,7 @@ static u32 get_block_address(u32 current_addr, u32 low, u32 high,
 	/* Fall back to method we used for older processors: */
 	switch (block) {
 	case 0:
-		addr = msr_ops.misc(bank);
+		addr = mca_msr_reg(bank, MCA_MISC);
 		break;
 	case 1:
 		offset = ((low & MASK_BLKPTR_LO) >> 21);
@@ -965,6 +965,24 @@ _log_error_bank(unsigned int bank, u32 msr_stat, u32 msr_addr, u64 misc)
 	return status & MCI_STATUS_DEFERRED;
 }
 
+static bool _log_error_deferred(unsigned int bank, u32 misc)
+{
+	if (!_log_error_bank(bank, mca_msr_reg(bank, MCA_STATUS),
+			     mca_msr_reg(bank, MCA_ADDR), misc))
+		return false;
+
+	/*
+	 * Non-SMCA systems don't have MCA_DESTAT/MCA_DEADDR registers.
+	 * Return true here to avoid accessing these registers.
+	 */
+	if (!mce_flags.smca)
+		return true;
+
+	/* Clear MCA_DESTAT if the deferred error was logged from MCA_STATUS. */
+	wrmsrl(MSR_AMD64_SMCA_MCx_DESTAT(bank), 0);
+	return true;
+}
+
 /*
  * We have three scenarios for checking for Deferred errors:
  *
@@ -976,19 +994,8 @@ _log_error_bank(unsigned int bank, u32 msr_stat, u32 msr_addr, u64 misc)
  */
 static void log_error_deferred(unsigned int bank)
 {
-	bool defrd;
-
-	defrd = _log_error_bank(bank, msr_ops.status(bank),
-					msr_ops.addr(bank), 0);
-
-	if (!mce_flags.smca)
-		return;
-
-	/* Clear MCA_DESTAT if we logged the deferred error from MCA_STATUS. */
-	if (defrd) {
-		wrmsrl(MSR_AMD64_SMCA_MCx_DESTAT(bank), 0);
+	if (_log_error_deferred(bank, 0))
 		return;
-	}
 
 	/*
 	 * Only deferred errors are logged in MCA_DE{STAT,ADDR} so just check
@@ -1009,7 +1016,7 @@ static void amd_deferred_error_interrupt(void)
 
 static void log_error_thresholding(unsigned int bank, u64 misc)
 {
-	_log_error_bank(bank, msr_ops.status(bank), msr_ops.addr(bank), misc);
+	_log_error_deferred(bank, misc);
 }
 
 static void log_and_reset_block(struct threshold_block *block)
@@ -1397,7 +1404,7 @@ static int threshold_create_bank(struct threshold_bank **bp, unsigned int cpu,
 		}
 	}
 
-	err = allocate_threshold_blocks(cpu, b, bank, 0, msr_ops.misc(bank));
+	err = allocate_threshold_blocks(cpu, b, bank, 0, mca_msr_reg(bank, MCA_MISC));
 	if (err)
 		goto out_kobj;
 
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 773037e5fd76..5ee82fd386dd 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -176,53 +176,27 @@ void mce_unregister_decode_chain(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(mce_unregister_decode_chain);
 
-static inline u32 ctl_reg(int bank)
+u32 mca_msr_reg(int bank, enum mca_msr reg)
 {
-	return MSR_IA32_MCx_CTL(bank);
-}
-
-static inline u32 status_reg(int bank)
-{
-	return MSR_IA32_MCx_STATUS(bank);
-}
-
-static inline u32 addr_reg(int bank)
-{
-	return MSR_IA32_MCx_ADDR(bank);
-}
-
-static inline u32 misc_reg(int bank)
-{
-	return MSR_IA32_MCx_MISC(bank);
-}
-
-static inline u32 smca_ctl_reg(int bank)
-{
-	return MSR_AMD64_SMCA_MCx_CTL(bank);
-}
-
-static inline u32 smca_status_reg(int bank)
-{
-	return MSR_AMD64_SMCA_MCx_STATUS(bank);
-}
+	if (mce_flags.smca) {
+		switch (reg) {
+		case MCA_CTL:	 return MSR_AMD64_SMCA_MCx_CTL(bank);
+		case MCA_ADDR:	 return MSR_AMD64_SMCA_MCx_ADDR(bank);
+		case MCA_MISC:	 return MSR_AMD64_SMCA_MCx_MISC(bank);
+		case MCA_STATUS: return MSR_AMD64_SMCA_MCx_STATUS(bank);
+		}
+	}
 
-static inline u32 smca_addr_reg(int bank)
-{
-	return MSR_AMD64_SMCA_MCx_ADDR(bank);
-}
+	switch (reg) {
+	case MCA_CTL:	 return MSR_IA32_MCx_CTL(bank);
+	case MCA_ADDR:	 return MSR_IA32_MCx_ADDR(bank);
+	case MCA_MISC:	 return MSR_IA32_MCx_MISC(bank);
+	case MCA_STATUS: return MSR_IA32_MCx_STATUS(bank);
+	}
 
-static inline u32 smca_misc_reg(int bank)
-{
-	return MSR_AMD64_SMCA_MCx_MISC(bank);
+	return 0;
 }
 
-struct mca_msr_regs msr_ops = {
-	.ctl	= ctl_reg,
-	.status	= status_reg,
-	.addr	= addr_reg,
-	.misc	= misc_reg
-};
-
 static void __print_mce(struct mce *m)
 {
 	pr_emerg(HW_ERR "CPU %d: Machine Check%s: %Lx Bank %d: %016Lx\n",
@@ -371,11 +345,11 @@ static int msr_to_offset(u32 msr)
 
 	if (msr == mca_cfg.rip_msr)
 		return offsetof(struct mce, ip);
-	if (msr == msr_ops.status(bank))
+	if (msr == mca_msr_reg(bank, MCA_STATUS))
 		return offsetof(struct mce, status);
-	if (msr == msr_ops.addr(bank))
+	if (msr == mca_msr_reg(bank, MCA_ADDR))
 		return offsetof(struct mce, addr);
-	if (msr == msr_ops.misc(bank))
+	if (msr == mca_msr_reg(bank, MCA_MISC))
 		return offsetof(struct mce, misc);
 	if (msr == MSR_IA32_MCG_STATUS)
 		return offsetof(struct mce, mcgstatus);
@@ -676,10 +650,10 @@ static struct notifier_block mce_default_nb = {
 static noinstr void mce_read_aux(struct mce *m, int i)
 {
 	if (m->status & MCI_STATUS_MISCV)
-		m->misc = mce_rdmsrl(msr_ops.misc(i));
+		m->misc = mce_rdmsrl(mca_msr_reg(i, MCA_MISC));
 
 	if (m->status & MCI_STATUS_ADDRV) {
-		m->addr = mce_rdmsrl(msr_ops.addr(i));
+		m->addr = mce_rdmsrl(mca_msr_reg(i, MCA_ADDR));
 
 		/*
 		 * Mask the reported address by the reported granularity.
@@ -749,7 +723,7 @@ bool machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		m.bank = i;
 
 		barrier();
-		m.status = mce_rdmsrl(msr_ops.status(i));
+		m.status = mce_rdmsrl(mca_msr_reg(i, MCA_STATUS));
 
 		/* If this entry is not valid, ignore it */
 		if (!(m.status & MCI_STATUS_VAL))
@@ -817,7 +791,7 @@ bool machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		/*
 		 * Clear state for this bank.
 		 */
-		mce_wrmsrl(msr_ops.status(i), 0);
+		mce_wrmsrl(mca_msr_reg(i, MCA_STATUS), 0);
 	}
 
 	/*
@@ -842,7 +816,7 @@ static int mce_no_way_out(struct mce *m, char **msg, unsigned long *validp,
 	int i;
 
 	for (i = 0; i < this_cpu_read(mce_num_banks); i++) {
-		m->status = mce_rdmsrl(msr_ops.status(i));
+		m->status = mce_rdmsrl(mca_msr_reg(i, MCA_STATUS));
 		if (!(m->status & MCI_STATUS_VAL))
 			continue;
 
@@ -1143,7 +1117,7 @@ static void mce_clear_state(unsigned long *toclear)
 
 	for (i = 0; i < this_cpu_read(mce_num_banks); i++) {
 		if (test_bit(i, toclear))
-			mce_wrmsrl(msr_ops.status(i), 0);
+			mce_wrmsrl(mca_msr_reg(i, MCA_STATUS), 0);
 	}
 }
 
@@ -1202,7 +1176,7 @@ static void __mc_scan_banks(struct mce *m, struct pt_regs *regs, struct mce *fin
 		m->addr = 0;
 		m->bank = i;
 
-		m->status = mce_rdmsrl(msr_ops.status(i));
+		m->status = mce_rdmsrl(mca_msr_reg(i, MCA_STATUS));
 		if (!(m->status & MCI_STATUS_VAL))
 			continue;
 
@@ -1699,8 +1673,8 @@ static void __mcheck_cpu_init_clear_banks(void)
 
 		if (!b->init)
 			continue;
-		wrmsrl(msr_ops.ctl(i), b->ctl);
-		wrmsrl(msr_ops.status(i), 0);
+		wrmsrl(mca_msr_reg(i, MCA_CTL), b->ctl);
+		wrmsrl(mca_msr_reg(i, MCA_STATUS), 0);
 	}
 }
 
@@ -1726,7 +1700,7 @@ static void __mcheck_cpu_check_banks(void)
 		if (!b->init)
 			continue;
 
-		rdmsrl(msr_ops.ctl(i), msrval);
+		rdmsrl(mca_msr_reg(i, MCA_CTL), msrval);
 		b->init = !!msrval;
 	}
 }
@@ -1883,13 +1857,6 @@ static void __mcheck_cpu_init_early(struct cpuinfo_x86 *c)
 		mce_flags.succor	 = !!cpu_has(c, X86_FEATURE_SUCCOR);
 		mce_flags.smca		 = !!cpu_has(c, X86_FEATURE_SMCA);
 		mce_flags.amd_threshold	 = 1;
-
-		if (mce_flags.smca) {
-			msr_ops.ctl	= smca_ctl_reg;
-			msr_ops.status	= smca_status_reg;
-			msr_ops.addr	= smca_addr_reg;
-			msr_ops.misc	= smca_misc_reg;
-		}
 	}
 }
 
@@ -2265,7 +2232,7 @@ static void mce_disable_error_reporting(void)
 		struct mce_bank *b = &mce_banks[i];
 
 		if (b->init)
-			wrmsrl(msr_ops.ctl(i), 0);
+			wrmsrl(mca_msr_reg(i, MCA_CTL), 0);
 	}
 	return;
 }
@@ -2617,7 +2584,7 @@ static void mce_reenable_cpu(void)
 		struct mce_bank *b = &mce_banks[i];
 
 		if (b->init)
-			wrmsrl(msr_ops.ctl(i), b->ctl);
+			wrmsrl(mca_msr_reg(i, MCA_CTL), b->ctl);
 	}
 }
 
diff --git a/arch/x86/kernel/cpu/mce/internal.h b/arch/x86/kernel/cpu/mce/internal.h
index 80dc94313bcf..760b57814760 100644
--- a/arch/x86/kernel/cpu/mce/internal.h
+++ b/arch/x86/kernel/cpu/mce/internal.h
@@ -168,14 +168,14 @@ struct mce_vendor_flags {
 
 extern struct mce_vendor_flags mce_flags;
 
-struct mca_msr_regs {
-	u32 (*ctl)	(int bank);
-	u32 (*status)	(int bank);
-	u32 (*addr)	(int bank);
-	u32 (*misc)	(int bank);
+enum mca_msr {
+	MCA_CTL,
+	MCA_STATUS,
+	MCA_ADDR,
+	MCA_MISC,
 };
 
-extern struct mca_msr_regs msr_ops;
+u32 mca_msr_reg(int bank, enum mca_msr reg);
 
 /* Decide whether to add MCE record to MCE event pool or filter it out. */
 extern bool filter_mce(struct mce *m);
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 7e8e07bddd5f..1ba590e6ef7b 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -659,7 +659,6 @@ void load_ucode_intel_ap(void)
 	else
 		iup = &intel_ucode_patch;
 
-reget:
 	if (!*iup) {
 		patch = __load_ucode_intel(&uci);
 		if (!patch)
@@ -670,12 +669,7 @@ void load_ucode_intel_ap(void)
 
 	uci.mc = *iup;
 
-	if (apply_microcode_early(&uci, true)) {
-		/* Mixed-silicon system? Try to refetch the proper patch: */
-		*iup = NULL;
-
-		goto reget;
-	}
+	apply_microcode_early(&uci, true);
 }
 
 static struct microcode_intel *find_patch(struct ucode_cpu_info *uci)
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index e8326a8d1c5d..03a454d427c3 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -401,10 +401,8 @@ int crash_load_segments(struct kimage *image)
 	kbuf.buf_align = ELF_CORE_HEADER_ALIGN;
 	kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
 	ret = kexec_add_buffer(&kbuf);
-	if (ret) {
-		vfree((void *)image->elf_headers);
+	if (ret)
 		return ret;
-	}
 	image->elf_load_addr = kbuf.mem;
 	pr_debug("Loaded ELF headers at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
 		 image->elf_load_addr, kbuf.bufsz, kbuf.bufsz);
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index b3c9ef01d6c0..4017da3a4c70 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -219,7 +219,9 @@ void ftrace_replace_code(int enable)
 
 		ret = ftrace_verify_code(rec->ip, old);
 		if (ret) {
+			ftrace_expected = old;
 			ftrace_bug(ret, rec);
+			ftrace_expected = NULL;
 			return;
 		}
 	}
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 6872f3834668..c4b618d0b16a 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -37,6 +37,7 @@
 #include <linux/extable.h>
 #include <linux/kdebug.h>
 #include <linux/kallsyms.h>
+#include <linux/kgdb.h>
 #include <linux/ftrace.h>
 #include <linux/kasan.h>
 #include <linux/moduleloader.h>
@@ -289,12 +290,15 @@ static int can_probe(unsigned long paddr)
 		if (ret < 0)
 			return 0;
 
+#ifdef CONFIG_KGDB
 		/*
-		 * Another debugging subsystem might insert this breakpoint.
-		 * In that case, we can't recover it.
+		 * If there is a dynamically installed kgdb sw breakpoint,
+		 * this function should not be probed.
 		 */
-		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE)
+		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE &&
+		    kgdb_has_hit_break(addr))
 			return 0;
+#endif
 		addr += insn.length;
 	}
 
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index 71425ebba98a..a9121073d951 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -15,6 +15,7 @@
 #include <linux/extable.h>
 #include <linux/kdebug.h>
 #include <linux/kallsyms.h>
+#include <linux/kgdb.h>
 #include <linux/ftrace.h>
 #include <linux/objtool.h>
 #include <linux/pgtable.h>
@@ -272,19 +273,6 @@ static int insn_is_indirect_jump(struct insn *insn)
 	return ret;
 }
 
-static bool is_padding_int3(unsigned long addr, unsigned long eaddr)
-{
-	unsigned char ops;
-
-	for (; addr < eaddr; addr++) {
-		if (get_kernel_nofault(ops, (void *)addr) < 0 ||
-		    ops != INT3_INSN_OPCODE)
-			return false;
-	}
-
-	return true;
-}
-
 /* Decode whole function to ensure any instructions don't jump into target */
 static int can_optimize(unsigned long paddr)
 {
@@ -327,15 +315,15 @@ static int can_optimize(unsigned long paddr)
 		ret = insn_decode_kernel(&insn, (void *)recovered_insn);
 		if (ret < 0)
 			return 0;
-
+#ifdef CONFIG_KGDB
 		/*
-		 * In the case of detecting unknown breakpoint, this could be
-		 * a padding INT3 between functions. Let's check that all the
-		 * rest of the bytes are also INT3.
+		 * If there is a dynamically installed kgdb sw breakpoint,
+		 * this function should not be probed.
 		 */
-		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE)
-			return is_padding_int3(addr, paddr - offset + size) ? 1 : 0;
-
+		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE &&
+		    kgdb_has_hit_break(addr))
+			return 0;
+#endif
 		/* Recover address */
 		insn.kaddr = (void *)addr;
 		insn.next_byte = (void *)(addr + insn.length);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 817632d5a118..cdebeceedbd0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4970,24 +4970,35 @@ static int handle_vmon(struct kvm_vcpu *vcpu)
 		| FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
 
 	/*
-	 * Note, KVM cannot rely on hardware to perform the CR0/CR4 #UD checks
-	 * that have higher priority than VM-Exit (see Intel SDM's pseudocode
-	 * for VMXON), as KVM must load valid CR0/CR4 values into hardware while
-	 * running the guest, i.e. KVM needs to check the _guest_ values.
+	 * Manually check CR4.VMXE checks, KVM must force CR4.VMXE=1 to enter
+	 * the guest and so cannot rely on hardware to perform the check,
+	 * which has higher priority than VM-Exit (see Intel SDM's pseudocode
+	 * for VMXON).
 	 *
-	 * Rely on hardware for the other two pre-VM-Exit checks, !VM86 and
-	 * !COMPATIBILITY modes.  KVM may run the guest in VM86 to emulate Real
-	 * Mode, but KVM will never take the guest out of those modes.
+	 * Rely on hardware for the other pre-VM-Exit checks, CR0.PE=1, !VM86
+	 * and !COMPATIBILITY modes.  For an unrestricted guest, KVM doesn't
+	 * force any of the relevant guest state.  For a restricted guest, KVM
+	 * does force CR0.PE=1, but only to also force VM86 in order to emulate
+	 * Real Mode, and so there's no need to check CR0.PE manually.
 	 */
-	if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
-	    !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
+	if (!kvm_read_cr4_bits(vcpu, X86_CR4_VMXE)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
 
 	/*
-	 * CPL=0 and all other checks that are lower priority than VM-Exit must
-	 * be checked manually.
+	 * The CPL is checked for "not in VMX operation" and for "in VMX root",
+	 * and has higher priority than the VM-Fail due to being post-VMXON,
+	 * i.e. VMXON #GPs outside of VMX non-root if CPL!=0.  In VMX non-root,
+	 * VMXON causes VM-Exit and KVM unconditionally forwards VMXON VM-Exits
+	 * from L2 to L1, i.e. there's no need to check for the vCPU being in
+	 * VMX non-root.
+	 *
+	 * Forwarding the VM-Exit unconditionally, i.e. without performing the
+	 * #UD checks (see above), is functionally ok because KVM doesn't allow
+	 * L1 to run L2 without CR4.VMXE=0, and because KVM never modifies L2's
+	 * CR0 or CR4, i.e. it's L2's responsibility to emulate #UDs that are
+	 * missed by hardware due to shadowing CR0 and/or CR4.
 	 */
 	if (vmx_get_cpl(vcpu)) {
 		kvm_inject_gp(vcpu, 0);
@@ -4997,6 +5008,17 @@ static int handle_vmon(struct kvm_vcpu *vcpu)
 	if (vmx->nested.vmxon)
 		return nested_vmx_fail(vcpu, VMXERR_VMXON_IN_VMX_ROOT_OPERATION);
 
+	/*
+	 * Invalid CR0/CR4 generates #GP.  These checks are performed if and
+	 * only if the vCPU isn't already in VMX operation, i.e. effectively
+	 * have lower priority than the VM-Fail above.
+	 */
+	if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
+	    !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
 	if ((vmx->msr_ia32_feature_control & VMXON_NEEDED_FEATURES)
 			!= VMXON_NEEDED_FEATURES) {
 		kvm_inject_gp(vcpu, 0);
@@ -6644,7 +6666,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		SECONDARY_EXEC_ENABLE_INVPCID |
 		SECONDARY_EXEC_RDSEED_EXITING |
 		SECONDARY_EXEC_XSAVES |
-		SECONDARY_EXEC_TSC_SCALING;
+		SECONDARY_EXEC_TSC_SCALING |
+		SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
 
 	/*
 	 * We can emulate "VMCS shadowing," even if the hardware
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 6693ebdc0770..b8cf9a59c145 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -188,8 +188,10 @@ static int __handle_encls_ecreate(struct kvm_vcpu *vcpu,
 	/* Enforce CPUID restriction on max enclave size. */
 	max_size_log2 = (attributes & SGX_ATTR_MODE64BIT) ? sgx_12_0->edx >> 8 :
 							    sgx_12_0->edx;
-	if (size >= BIT_ULL(max_size_log2))
+	if (size >= BIT_ULL(max_size_log2)) {
 		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
 
 	/*
 	 * sgx_virt_ecreate() returns:
diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index b8b6e9eae94b..85120d7b5cf0 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -5251,8 +5251,8 @@ static void bfq_exit_icq_bfqq(struct bfq_io_cq *bic, bool is_sync)
 		unsigned long flags;
 
 		spin_lock_irqsave(&bfqd->lock, flags);
-		bfq_exit_bfqq(bfqd, bfqq);
 		bic_set_bfqq(bic, NULL, is_sync);
+		bfq_exit_bfqq(bfqd, bfqq);
 		spin_unlock_irqrestore(&bfqd->lock, flags);
 	}
 }
diff --git a/block/blk-merge.c b/block/blk-merge.c
index bbe66a9010bf..bb26db93ad1d 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -279,6 +279,16 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
 	*segs = nsegs;
 	return NULL;
 split:
+	/*
+	 * We can't sanely support splitting for a REQ_NOWAIT bio. End it
+	 * with EAGAIN if splitting is required and return an error pointer.
+	 */
+	if (bio->bi_opf & REQ_NOWAIT) {
+		bio->bi_status = BLK_STS_AGAIN;
+		bio_endio(bio);
+		return ERR_PTR(-EAGAIN);
+	}
+
 	*segs = nsegs;
 
 	/*
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index cd2342d29704..950c46332a76 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -153,6 +153,20 @@ static u8 dd_rq_ioclass(struct request *rq)
 	return IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
 }
 
+/*
+ * get the request before `rq' in sector-sorted order
+ */
+static inline struct request *
+deadline_earlier_request(struct request *rq)
+{
+	struct rb_node *node = rb_prev(&rq->rb_node);
+
+	if (node)
+		return rb_entry_rq(node);
+
+	return NULL;
+}
+
 /*
  * get the request after `rq' in sector-sorted order
  */
@@ -288,6 +302,39 @@ static inline int deadline_check_fifo(struct dd_per_prio *per_prio,
 	return 0;
 }
 
+/*
+ * Check if rq has a sequential request preceding it.
+ */
+static bool deadline_is_seq_writes(struct deadline_data *dd, struct request *rq)
+{
+	struct request *prev = deadline_earlier_request(rq);
+
+	if (!prev)
+		return false;
+
+	return blk_rq_pos(prev) + blk_rq_sectors(prev) == blk_rq_pos(rq);
+}
+
+/*
+ * Skip all write requests that are sequential from @rq, even if we cross
+ * a zone boundary.
+ */
+static struct request *deadline_skip_seq_writes(struct deadline_data *dd,
+						struct request *rq)
+{
+	sector_t pos = blk_rq_pos(rq);
+	sector_t skipped_sectors = 0;
+
+	while (rq) {
+		if (blk_rq_pos(rq) != pos + skipped_sectors)
+			break;
+		skipped_sectors += blk_rq_sectors(rq);
+		rq = deadline_latter_request(rq);
+	}
+
+	return rq;
+}
+
 /*
  * For the specified data direction, return the next request to
  * dispatch using arrival ordered lists.
@@ -308,11 +355,16 @@ deadline_fifo_request(struct deadline_data *dd, struct dd_per_prio *per_prio,
 
 	/*
 	 * Look for a write request that can be dispatched, that is one with
-	 * an unlocked target zone.
+	 * an unlocked target zone. For some HDDs, breaking a sequential
+	 * write stream can lead to lower throughput, so make sure to preserve
+	 * sequential write streams, even if that stream crosses into the next
+	 * zones and these zones are unlocked.
 	 */
 	spin_lock_irqsave(&dd->zone_lock, flags);
 	list_for_each_entry(rq, &per_prio->fifo_list[DD_WRITE], queuelist) {
-		if (blk_req_can_dispatch_to_zone(rq))
+		if (blk_req_can_dispatch_to_zone(rq) &&
+		    (blk_queue_nonrot(rq->q) ||
+		     !deadline_is_seq_writes(dd, rq)))
 			goto out;
 	}
 	rq = NULL;
@@ -342,13 +394,19 @@ deadline_next_request(struct deadline_data *dd, struct dd_per_prio *per_prio,
 
 	/*
 	 * Look for a write request that can be dispatched, that is one with
-	 * an unlocked target zone.
+	 * an unlocked target zone. For some HDDs, breaking a sequential
+	 * write stream can lead to lower throughput, so make sure to preserve
+	 * sequential write streams, even if that stream crosses into the next
+	 * zones and these zones are unlocked.
 	 */
 	spin_lock_irqsave(&dd->zone_lock, flags);
 	while (rq) {
 		if (blk_req_can_dispatch_to_zone(rq))
 			break;
-		rq = deadline_latter_request(rq);
+		if (blk_queue_nonrot(rq->q))
+			rq = deadline_latter_request(rq);
+		else
+			rq = deadline_skip_seq_writes(dd, rq);
 	}
 	spin_unlock_irqrestore(&dd->zone_lock, flags);
 
@@ -733,6 +791,18 @@ static void dd_prepare_request(struct request *rq)
 	rq->elv.priv[0] = NULL;
 }
 
+static bool dd_has_write_work(struct blk_mq_hw_ctx *hctx)
+{
+	struct deadline_data *dd = hctx->queue->elevator->elevator_data;
+	enum dd_prio p;
+
+	for (p = 0; p <= DD_PRIO_MAX; p++)
+		if (!list_empty_careful(&dd->per_prio[p].fifo_list[DD_WRITE]))
+			return true;
+
+	return false;
+}
+
 /*
  * Callback from inside blk_mq_free_request().
  *
@@ -755,7 +825,6 @@ static void dd_finish_request(struct request *rq)
 	struct deadline_data *dd = q->elevator->elevator_data;
 	const u8 ioprio_class = dd_rq_ioclass(rq);
 	const enum dd_prio prio = ioprio_class_to_prio[ioprio_class];
-	struct dd_per_prio *per_prio = &dd->per_prio[prio];
 
 	/*
 	 * The block layer core may call dd_finish_request() without having
@@ -771,9 +840,10 @@ static void dd_finish_request(struct request *rq)
 
 		spin_lock_irqsave(&dd->zone_lock, flags);
 		blk_req_zone_write_unlock(rq);
-		if (!list_empty(&per_prio->fifo_list[DD_WRITE]))
-			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
 		spin_unlock_irqrestore(&dd->zone_lock, flags);
+
+		if (dd_has_write_work(rq->mq_hctx))
+			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
 	}
 }
 
diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 19358a641610..33921949bd8f 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -399,16 +399,68 @@ static const struct dmi_system_id medion_laptop[] = {
 	{ }
 };
 
+static const struct dmi_system_id asus_laptop[] = {
+	{
+		.ident = "Asus Vivobook K3402ZA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "K3402ZA"),
+		},
+	},
+	{
+		.ident = "Asus Vivobook K3502ZA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "K3502ZA"),
+		},
+	},
+	{ }
+};
+
+static const struct dmi_system_id lenovo_laptop[] = {
+	{
+		.ident = "LENOVO IdeaPad Flex 5 14ALC7",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82R9"),
+		},
+	},
+	{
+		.ident = "LENOVO IdeaPad Flex 5 16ALC7",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82RA"),
+		},
+	},
+	{ }
+};
+
+static const struct dmi_system_id schenker_gm_rg[] = {
+	{
+		.ident = "XMG CORE 15 (M22)",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SchenkerTechnologiesGmbH"),
+			DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
+		},
+	},
+	{ }
+};
+
 struct irq_override_cmp {
 	const struct dmi_system_id *system;
 	unsigned char irq;
 	unsigned char triggering;
 	unsigned char polarity;
 	unsigned char shareable;
+	bool override;
 };
 
-static const struct irq_override_cmp skip_override_table[] = {
-	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
+static const struct irq_override_cmp override_table[] = {
+	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
+	{ asus_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
+	{ lenovo_laptop, 6, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
+	{ lenovo_laptop, 10, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
+	{ schenker_gm_rg, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
 };
 
 static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
@@ -416,6 +468,17 @@ static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
 {
 	int i;
 
+	for (i = 0; i < ARRAY_SIZE(override_table); i++) {
+		const struct irq_override_cmp *entry = &override_table[i];
+
+		if (dmi_check_system(entry->system) &&
+		    entry->irq == gsi &&
+		    entry->triggering == triggering &&
+		    entry->polarity == polarity &&
+		    entry->shareable == shareable)
+			return entry->override;
+	}
+
 #ifdef CONFIG_X86
 	/*
 	 * IRQ override isn't needed on modern AMD Zen systems and
@@ -426,17 +489,6 @@ static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
 		return false;
 #endif
 
-	for (i = 0; i < ARRAY_SIZE(skip_override_table); i++) {
-		const struct irq_override_cmp *entry = &skip_override_table[i];
-
-		if (dmi_check_system(entry->system) &&
-		    entry->irq == gsi &&
-		    entry->triggering == triggering &&
-		    entry->polarity == polarity &&
-		    entry->shareable == shareable)
-			return false;
-	}
-
 	return true;
 }
 
diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index e0185e841b2a..2af1ae172102 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -378,16 +378,13 @@ static int lps0_device_attach(struct acpi_device *adev,
 		 * AMDI0006:
 		 * - should use rev_id 0x0
 		 * - function mask = 0x3: Should use Microsoft method
-		 * AMDI0007:
-		 * - Should use rev_id 0x2
-		 * - Should only use AMD method
 		 */
 		const char *hid = acpi_device_hid(adev);
-		rev_id = strcmp(hid, "AMDI0007") ? 0 : 2;
+		rev_id = 0;
 		lps0_dsm_func_mask = validate_dsm(adev->handle,
 					ACPI_LPS0_DSM_UUID_AMD, rev_id, &lps0_dsm_guid);
 		lps0_dsm_func_mask_microsoft = validate_dsm(adev->handle,
-					ACPI_LPS0_DSM_UUID_MICROSOFT, 0,
+					ACPI_LPS0_DSM_UUID_MICROSOFT, rev_id,
 					&lps0_dsm_guid_microsoft);
 		if (lps0_dsm_func_mask > 0x3 && (!strcmp(hid, "AMD0004") ||
 						 !strcmp(hid, "AMD0005") ||
@@ -395,9 +392,6 @@ static int lps0_device_attach(struct acpi_device *adev,
 			lps0_dsm_func_mask = (lps0_dsm_func_mask << 1) | 0x1;
 			acpi_handle_debug(adev->handle, "_DSM UUID %s: Adjusted function mask: 0x%x\n",
 					  ACPI_LPS0_DSM_UUID_AMD, lps0_dsm_func_mask);
-		} else if (lps0_dsm_func_mask_microsoft > 0 && !strcmp(hid, "AMDI0007")) {
-			lps0_dsm_func_mask_microsoft = -EINVAL;
-			acpi_handle_debug(adev->handle, "_DSM Using AMD method\n");
 		}
 	} else {
 		rev_id = 1;
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index c1bf7117a9ff..149ee16fd022 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -83,6 +83,7 @@ enum board_ids {
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
 static void ahci_remove_one(struct pci_dev *dev);
 static void ahci_shutdown_one(struct pci_dev *dev);
+static void ahci_intel_pcs_quirk(struct pci_dev *pdev, struct ahci_host_priv *hpriv);
 static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 				 unsigned long deadline);
 static int ahci_avn_hardreset(struct ata_link *link, unsigned int *class,
@@ -668,6 +669,25 @@ static void ahci_pci_save_initial_config(struct pci_dev *pdev,
 	ahci_save_initial_config(&pdev->dev, hpriv);
 }
 
+static int ahci_pci_reset_controller(struct ata_host *host)
+{
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	struct ahci_host_priv *hpriv = host->private_data;
+	int rc;
+
+	rc = ahci_reset_controller(host);
+	if (rc)
+		return rc;
+
+	/*
+	 * If platform firmware failed to enable ports, try to enable
+	 * them here.
+	 */
+	ahci_intel_pcs_quirk(pdev, hpriv);
+
+	return 0;
+}
+
 static void ahci_pci_init_controller(struct ata_host *host)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
@@ -869,7 +889,7 @@ static int ahci_pci_device_runtime_resume(struct device *dev)
 	struct ata_host *host = pci_get_drvdata(pdev);
 	int rc;
 
-	rc = ahci_reset_controller(host);
+	rc = ahci_pci_reset_controller(host);
 	if (rc)
 		return rc;
 	ahci_pci_init_controller(host);
@@ -904,7 +924,7 @@ static int ahci_pci_device_resume(struct device *dev)
 		ahci_mcp89_apple_enable(pdev);
 
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
-		rc = ahci_reset_controller(host);
+		rc = ahci_pci_reset_controller(host);
 		if (rc)
 			return rc;
 
@@ -1789,12 +1809,6 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* save initial config */
 	ahci_pci_save_initial_config(pdev, hpriv);
 
-	/*
-	 * If platform firmware failed to enable ports, try to enable
-	 * them here.
-	 */
-	ahci_intel_pcs_quirk(pdev, hpriv);
-
 	/* prepare host */
 	if (hpriv->cap & HOST_CAP_NCQ) {
 		pi.flags |= ATA_FLAG_NCQ;
@@ -1904,7 +1918,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	rc = ahci_reset_controller(host);
+	rc = ahci_pci_reset_controller(host);
 	if (rc)
 		return rc;
 
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 63cc01118810..060348125635 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1127,7 +1127,11 @@ static int __driver_attach(struct device *dev, void *data)
 		return 0;
 	} else if (ret < 0) {
 		dev_dbg(dev, "Bus failed to match device: %d\n", ret);
-		return ret;
+		/*
+		 * Driver could not match with device, but may match with
+		 * another device on the bus.
+		 */
+		return 0;
 	} /* ret > 0 means positive match */
 
 	if (driver_allows_async_probing(drv)) {
diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 8dbc349a2edd..15c211c5d6f4 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -1273,6 +1273,7 @@ static void _ipmi_destroy_user(struct ipmi_user *user)
 	unsigned long    flags;
 	struct cmd_rcvr  *rcvr;
 	struct cmd_rcvr  *rcvrs = NULL;
+	struct module    *owner;
 
 	if (!acquire_ipmi_user(user, &i)) {
 		/*
@@ -1334,8 +1335,9 @@ static void _ipmi_destroy_user(struct ipmi_user *user)
 		kfree(rcvr);
 	}
 
+	owner = intf->owner;
 	kref_put(&intf->refcount, intf_free);
-	module_put(intf->owner);
+	module_put(owner);
 }
 
 int ipmi_destroy_user(struct ipmi_user *user)
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 6f3272b58ced..17255e705cb0 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2152,6 +2152,20 @@ static int __init init_ipmi_si(void)
 }
 module_init(init_ipmi_si);
 
+static void wait_msg_processed(struct smi_info *smi_info)
+{
+	unsigned long jiffies_now;
+	long time_diff;
+
+	while (smi_info->curr_msg || (smi_info->si_state != SI_NORMAL)) {
+		jiffies_now = jiffies;
+		time_diff = (((long)jiffies_now - (long)smi_info->last_timeout_jiffies)
+		     * SI_USEC_PER_JIFFY);
+		smi_event_handler(smi_info, time_diff);
+		schedule_timeout_uninterruptible(1);
+	}
+}
+
 static void shutdown_smi(void *send_info)
 {
 	struct smi_info *smi_info = send_info;
@@ -2186,16 +2200,13 @@ static void shutdown_smi(void *send_info)
 	 * in the BMC.  Note that timers and CPU interrupts are off,
 	 * so no need for locks.
 	 */
-	while (smi_info->curr_msg || (smi_info->si_state != SI_NORMAL)) {
-		poll(smi_info);
-		schedule_timeout_uninterruptible(1);
-	}
+	wait_msg_processed(smi_info);
+
 	if (smi_info->handlers)
 		disable_si_irq(smi_info);
-	while (smi_info->curr_msg || (smi_info->si_state != SI_NORMAL)) {
-		poll(smi_info);
-		schedule_timeout_uninterruptible(1);
-	}
+
+	wait_msg_processed(smi_info);
+
 	if (smi_info->handlers)
 		smi_info->handlers->cleanup(smi_info->si_sm);
 
diff --git a/drivers/char/tpm/eventlog/acpi.c b/drivers/char/tpm/eventlog/acpi.c
index 1b18ce5ebab1..0913d3eb8d51 100644
--- a/drivers/char/tpm/eventlog/acpi.c
+++ b/drivers/char/tpm/eventlog/acpi.c
@@ -90,16 +90,21 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
 			return -ENODEV;
 
 		if (tbl->header.length <
-				sizeof(*tbl) + sizeof(struct acpi_tpm2_phy))
+				sizeof(*tbl) + sizeof(struct acpi_tpm2_phy)) {
+			acpi_put_table((struct acpi_table_header *)tbl);
 			return -ENODEV;
+		}
 
 		tpm2_phy = (void *)tbl + sizeof(*tbl);
 		len = tpm2_phy->log_area_minimum_length;
 
 		start = tpm2_phy->log_area_start_address;
-		if (!start || !len)
+		if (!start || !len) {
+			acpi_put_table((struct acpi_table_header *)tbl);
 			return -ENODEV;
+		}
 
+		acpi_put_table((struct acpi_table_header *)tbl);
 		format = EFI_TCG2_EVENT_LOG_FORMAT_TCG_2;
 	} else {
 		/* Find TCPA entry in RSDT (ACPI_LOGICAL_ADDRESSING) */
@@ -120,8 +125,10 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
 			break;
 		}
 
+		acpi_put_table((struct acpi_table_header *)buff);
 		format = EFI_TCG2_EVENT_LOG_FORMAT_TCG_1_2;
 	}
+
 	if (!len) {
 		dev_warn(&chip->dev, "%s: TCPA log area empty\n", __func__);
 		return -EIO;
@@ -156,5 +163,4 @@ int tpm_read_log_acpi(struct tpm_chip *chip)
 	kfree(log->bios_event_log);
 	log->bios_event_log = NULL;
 	return ret;
-
 }
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 65f8f179a27f..16fc481d6095 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -676,12 +676,16 @@ static int crb_acpi_add(struct acpi_device *device)
 
 	/* Should the FIFO driver handle this? */
 	sm = buf->start_method;
-	if (sm == ACPI_TPM2_MEMORY_MAPPED)
-		return -ENODEV;
+	if (sm == ACPI_TPM2_MEMORY_MAPPED) {
+		rc = -ENODEV;
+		goto out;
+	}
 
 	priv = devm_kzalloc(dev, sizeof(struct crb_priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	if (!priv) {
+		rc = -ENOMEM;
+		goto out;
+	}
 
 	if (sm == ACPI_TPM2_COMMAND_BUFFER_WITH_ARM_SMC) {
 		if (buf->header.length < (sizeof(*buf) + sizeof(*crb_smc))) {
@@ -689,7 +693,8 @@ static int crb_acpi_add(struct acpi_device *device)
 				FW_BUG "TPM2 ACPI table has wrong size %u for start method type %d\n",
 				buf->header.length,
 				ACPI_TPM2_COMMAND_BUFFER_WITH_ARM_SMC);
-			return -EINVAL;
+			rc = -EINVAL;
+			goto out;
 		}
 		crb_smc = ACPI_ADD_PTR(struct tpm2_crb_smc, buf, sizeof(*buf));
 		priv->smc_func_id = crb_smc->smc_func_id;
@@ -700,17 +705,23 @@ static int crb_acpi_add(struct acpi_device *device)
 
 	rc = crb_map_io(device, priv, buf);
 	if (rc)
-		return rc;
+		goto out;
 
 	chip = tpmm_chip_alloc(dev, &tpm_crb);
-	if (IS_ERR(chip))
-		return PTR_ERR(chip);
+	if (IS_ERR(chip)) {
+		rc = PTR_ERR(chip);
+		goto out;
+	}
 
 	dev_set_drvdata(&chip->dev, priv);
 	chip->acpi_dev_handle = device->handle;
 	chip->flags = TPM_CHIP_FLAG_TPM2;
 
-	return tpm_chip_register(chip);
+	rc = tpm_chip_register(chip);
+
+out:
+	acpi_put_table((struct acpi_table_header *)buf);
+	return rc;
 }
 
 static int crb_acpi_remove(struct acpi_device *device)
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index d3f2e5364c27..e53164c82808 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -125,6 +125,7 @@ static int check_acpi_tpm2(struct device *dev)
 	const struct acpi_device_id *aid = acpi_match_device(tpm_acpi_tbl, dev);
 	struct acpi_table_tpm2 *tbl;
 	acpi_status st;
+	int ret = 0;
 
 	if (!aid || aid->driver_data != DEVICE_IS_TPM2)
 		return 0;
@@ -132,8 +133,7 @@ static int check_acpi_tpm2(struct device *dev)
 	/* If the ACPI TPM2 signature is matched then a global ACPI_SIG_TPM2
 	 * table is mandatory
 	 */
-	st =
-	    acpi_get_table(ACPI_SIG_TPM2, 1, (struct acpi_table_header **)&tbl);
+	st = acpi_get_table(ACPI_SIG_TPM2, 1, (struct acpi_table_header **)&tbl);
 	if (ACPI_FAILURE(st) || tbl->header.length < sizeof(*tbl)) {
 		dev_err(dev, FW_BUG "failed to get TPM2 ACPI table\n");
 		return -EINVAL;
@@ -141,9 +141,10 @@ static int check_acpi_tpm2(struct device *dev)
 
 	/* The tpm2_crb driver handles this device */
 	if (tbl->start_method != ACPI_TPM2_MEMORY_MAPPED)
-		return -ENODEV;
+		ret = -ENODEV;
 
-	return 0;
+	acpi_put_table((struct acpi_table_header *)tbl);
+	return ret;
 }
 #else
 static int check_acpi_tpm2(struct device *dev)
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 799431d287ee..b998b5083953 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1212,6 +1212,7 @@ static struct cpufreq_policy *cpufreq_policy_alloc(unsigned int cpu)
 	if (!zalloc_cpumask_var(&policy->real_cpus, GFP_KERNEL))
 		goto err_free_rcpumask;
 
+	init_completion(&policy->kobj_unregister);
 	ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
 				   cpufreq_global_kobject, "policy%u", cpu);
 	if (ret) {
@@ -1250,7 +1251,6 @@ static struct cpufreq_policy *cpufreq_policy_alloc(unsigned int cpu)
 	init_rwsem(&policy->rwsem);
 	spin_lock_init(&policy->transition_lock);
 	init_waitqueue_head(&policy->transition_wait);
-	init_completion(&policy->kobj_unregister);
 	INIT_WORK(&policy->update, handle_update);
 
 	policy->cpu = cpu;
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 88c672ad27e4..9470a9a19f29 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -320,6 +320,15 @@ static const struct psp_vdata pspv3 = {
 	.inten_reg		= 0x10690,
 	.intsts_reg		= 0x10694,
 };
+
+static const struct psp_vdata pspv4 = {
+	.sev			= &sevv2,
+	.tee			= &teev1,
+	.feature_reg		= 0x109fc,
+	.inten_reg		= 0x10690,
+	.intsts_reg		= 0x10694,
+};
+
 #endif
 
 static const struct sp_dev_vdata dev_vdata[] = {
@@ -365,7 +374,7 @@ static const struct sp_dev_vdata dev_vdata[] = {
 	{	/* 5 */
 		.bar = 2,
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
-		.psp_vdata = &pspv2,
+		.psp_vdata = &pspv4,
 #endif
 	},
 };
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 3b0bf6fea491..b4db560105a9 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1229,6 +1229,7 @@ struct n2_hash_tmpl {
 	const u8	*hash_init;
 	u8		hw_op_hashsz;
 	u8		digest_size;
+	u8		statesize;
 	u8		block_size;
 	u8		auth_type;
 	u8		hmac_type;
@@ -1260,6 +1261,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_HMAC_MD5,
 	  .hw_op_hashsz	= MD5_DIGEST_SIZE,
 	  .digest_size	= MD5_DIGEST_SIZE,
+	  .statesize	= sizeof(struct md5_state),
 	  .block_size	= MD5_HMAC_BLOCK_SIZE },
 	{ .name		= "sha1",
 	  .hash_zero	= sha1_zero_message_hash,
@@ -1268,6 +1270,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA1,
 	  .hw_op_hashsz	= SHA1_DIGEST_SIZE,
 	  .digest_size	= SHA1_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha1_state),
 	  .block_size	= SHA1_BLOCK_SIZE },
 	{ .name		= "sha256",
 	  .hash_zero	= sha256_zero_message_hash,
@@ -1276,6 +1279,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA256,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA256_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha256_state),
 	  .block_size	= SHA256_BLOCK_SIZE },
 	{ .name		= "sha224",
 	  .hash_zero	= sha224_zero_message_hash,
@@ -1284,6 +1288,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_RESERVED,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA224_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha256_state),
 	  .block_size	= SHA224_BLOCK_SIZE },
 };
 #define NUM_HASH_TMPLS ARRAY_SIZE(hash_tmpls)
@@ -1424,6 +1429,7 @@ static int __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 
 	halg = &ahash->halg;
 	halg->digestsize = tmpl->digest_size;
+	halg->statesize = tmpl->statesize;
 
 	base = &halg->base;
 	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "%s", tmpl->name);
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 85faa7a5c7d1..a473b640c40a 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -775,8 +775,7 @@ static void remove_sysfs_files(struct devfreq *devfreq,
  * @dev:	the device to add devfreq feature.
  * @profile:	device-specific profile to run devfreq.
  * @governor_name:	name of the policy to choose frequency.
- * @data:	private data for the governor. The devfreq framework does not
- *		touch this value.
+ * @data:	devfreq driver pass to governors, governor should not change it.
  */
 struct devfreq *devfreq_add_device(struct device *dev,
 				   struct devfreq_dev_profile *profile,
@@ -1003,8 +1002,7 @@ static void devm_devfreq_dev_release(struct device *dev, void *res)
  * @dev:	the device to add devfreq feature.
  * @profile:	device-specific profile to run devfreq.
  * @governor_name:	name of the policy to choose frequency.
- * @data:	private data for the governor. The devfreq framework does not
- *		touch this value.
+ * @data:	 devfreq driver pass to governors, governor should not change it.
  *
  * This function manages automatically the memory of devfreq device using device
  * resource management and simplify the free operation for memory of devfreq
diff --git a/drivers/devfreq/governor_userspace.c b/drivers/devfreq/governor_userspace.c
index ab9db7adb3ad..d69672ccacc4 100644
--- a/drivers/devfreq/governor_userspace.c
+++ b/drivers/devfreq/governor_userspace.c
@@ -21,7 +21,7 @@ struct userspace_data {
 
 static int devfreq_userspace_func(struct devfreq *df, unsigned long *freq)
 {
-	struct userspace_data *data = df->data;
+	struct userspace_data *data = df->governor_data;
 
 	if (data->valid)
 		*freq = data->user_frequency;
@@ -40,7 +40,7 @@ static ssize_t set_freq_store(struct device *dev, struct device_attribute *attr,
 	int err = 0;
 
 	mutex_lock(&devfreq->lock);
-	data = devfreq->data;
+	data = devfreq->governor_data;
 
 	sscanf(buf, "%lu", &wanted);
 	data->user_frequency = wanted;
@@ -60,7 +60,7 @@ static ssize_t set_freq_show(struct device *dev,
 	int err = 0;
 
 	mutex_lock(&devfreq->lock);
-	data = devfreq->data;
+	data = devfreq->governor_data;
 
 	if (data->valid)
 		err = sprintf(buf, "%lu\n", data->user_frequency);
@@ -91,7 +91,7 @@ static int userspace_init(struct devfreq *devfreq)
 		goto out;
 	}
 	data->valid = false;
-	devfreq->data = data;
+	devfreq->governor_data = data;
 
 	err = sysfs_create_group(&devfreq->dev.kobj, &dev_attr_group);
 out:
@@ -107,8 +107,8 @@ static void userspace_exit(struct devfreq *devfreq)
 	if (devfreq->dev.kobj.sd)
 		sysfs_remove_group(&devfreq->dev.kobj, &dev_attr_group);
 
-	kfree(devfreq->data);
-	devfreq->data = NULL;
+	kfree(devfreq->governor_data);
+	devfreq->governor_data = NULL;
 }
 
 static int devfreq_userspace_handler(struct devfreq *devfreq,
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 70be9c87fb67..ba03f5a4b30c 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -590,7 +590,7 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 
 		seed = early_memremap(efi_rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = min(seed->size, EFI_RANDOM_SEED_SIZE);
+			size = min_t(u32, seed->size, SZ_1K); // sanity check
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
@@ -599,8 +599,8 @@ int __init efi_config_parse_tables(const efi_config_table_t *config_tables,
 			seed = early_memremap(efi_rng_seed,
 					      sizeof(*seed) + size);
 			if (seed != NULL) {
-				pr_notice("seeding entropy pool\n");
 				add_bootloader_randomness(seed->bits, size);
+				memzero_explicit(seed->bits, size);
 				early_memunmap(seed, sizeof(*seed) + size);
 			} else {
 				pr_err("Could not map UEFI random seed!\n");
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index cde0a2ef507d..fbffdd7290a3 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -766,6 +766,8 @@ efi_status_t efi_get_random_bytes(unsigned long size, u8 *out);
 efi_status_t efi_random_alloc(unsigned long size, unsigned long align,
 			      unsigned long *addr, unsigned long random_seed);
 
+efi_status_t efi_random_get_seed(void);
+
 efi_status_t check_platform_features(void);
 
 void *get_efi_config_table(efi_guid_t guid);
diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index 33ab56769595..f85d2c066877 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -67,27 +67,43 @@ efi_status_t efi_random_get_seed(void)
 	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
 	efi_guid_t rng_algo_raw = EFI_RNG_ALGORITHM_RAW;
 	efi_guid_t rng_table_guid = LINUX_EFI_RANDOM_SEED_TABLE_GUID;
+	struct linux_efi_random_seed *prev_seed, *seed = NULL;
+	int prev_seed_size = 0, seed_size = EFI_RANDOM_SEED_SIZE;
 	efi_rng_protocol_t *rng = NULL;
-	struct linux_efi_random_seed *seed = NULL;
 	efi_status_t status;
 
 	status = efi_bs_call(locate_protocol, &rng_proto, NULL, (void **)&rng);
 	if (status != EFI_SUCCESS)
 		return status;
 
+	/*
+	 * Check whether a seed was provided by a prior boot stage. In that
+	 * case, instead of overwriting it, let's create a new buffer that can
+	 * hold both, and concatenate the existing and the new seeds.
+	 * Note that we should read the seed size with caution, in case the
+	 * table got corrupted in memory somehow.
+	 */
+	prev_seed = get_efi_config_table(LINUX_EFI_RANDOM_SEED_TABLE_GUID);
+	if (prev_seed && prev_seed->size <= 512U) {
+		prev_seed_size = prev_seed->size;
+		seed_size += prev_seed_size;
+	}
+
 	/*
 	 * Use EFI_ACPI_RECLAIM_MEMORY here so that it is guaranteed that the
 	 * allocation will survive a kexec reboot (although we refresh the seed
 	 * beforehand)
 	 */
 	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
-			     sizeof(*seed) + EFI_RANDOM_SEED_SIZE,
+			     struct_size(seed, bits, seed_size),
 			     (void **)&seed);
-	if (status != EFI_SUCCESS)
-		return status;
+	if (status != EFI_SUCCESS) {
+		efi_warn("Failed to allocate memory for RNG seed.\n");
+		goto err_warn;
+	}
 
 	status = efi_call_proto(rng, get_rng, &rng_algo_raw,
-				 EFI_RANDOM_SEED_SIZE, seed->bits);
+				EFI_RANDOM_SEED_SIZE, seed->bits);
 
 	if (status == EFI_UNSUPPORTED)
 		/*
@@ -100,14 +116,28 @@ efi_status_t efi_random_get_seed(void)
 	if (status != EFI_SUCCESS)
 		goto err_freepool;
 
-	seed->size = EFI_RANDOM_SEED_SIZE;
+	seed->size = seed_size;
+	if (prev_seed_size)
+		memcpy(seed->bits + EFI_RANDOM_SEED_SIZE, prev_seed->bits,
+		       prev_seed_size);
+
 	status = efi_bs_call(install_configuration_table, &rng_table_guid, seed);
 	if (status != EFI_SUCCESS)
 		goto err_freepool;
 
+	if (prev_seed_size) {
+		/* wipe and free the old seed if we managed to install the new one */
+		memzero_explicit(prev_seed->bits, prev_seed_size);
+		efi_bs_call(free_pool, prev_seed);
+	}
 	return EFI_SUCCESS;
 
 err_freepool:
+	memzero_explicit(seed, struct_size(seed, bits, seed_size));
 	efi_bs_call(free_pool, seed);
+	efi_warn("Failed to obtain seed from EFI_RNG_PROTOCOL\n");
+err_warn:
+	if (prev_seed)
+		efi_warn("Retaining bootloader-supplied seed only");
 	return status;
 }
diff --git a/drivers/gpio/gpio-sifive.c b/drivers/gpio/gpio-sifive.c
index 7d82388b4ab7..f50236e68e88 100644
--- a/drivers/gpio/gpio-sifive.c
+++ b/drivers/gpio/gpio-sifive.c
@@ -209,6 +209,7 @@ static int sifive_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 	parent = irq_find_host(irq_parent);
+	of_node_put(irq_parent);
 	if (!parent) {
 		dev_err(dev, "no IRQ parent domain\n");
 		return -ENODEV;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index 28dea2eb61c7..cabbf02eb054 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2008,6 +2008,15 @@ static int amdgpu_pci_probe(struct pci_dev *pdev,
 			 "See modparam exp_hw_support\n");
 		return -ENODEV;
 	}
+	/* differentiate between P10 and P11 asics with the same DID */
+	if (pdev->device == 0x67FF &&
+	    (pdev->revision == 0xE3 ||
+	     pdev->revision == 0xE7 ||
+	     pdev->revision == 0xF3 ||
+	     pdev->revision == 0xF7)) {
+		flags &= ~AMD_ASIC_MASK;
+		flags |= CHIP_POLARIS10;
+	}
 
 	/* Due to hardware bugs, S/G Display on raven requires a 1:1 IOMMU mapping,
 	 * however, SME requires an indirect IOMMU mapping because the encryption
@@ -2081,12 +2090,12 @@ static int amdgpu_pci_probe(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, ddev);
 
-	ret = amdgpu_driver_load_kms(adev, ent->driver_data);
+	ret = amdgpu_driver_load_kms(adev, flags);
 	if (ret)
 		goto err_pci;
 
 retry_init:
-	ret = drm_dev_register(ddev, ent->driver_data);
+	ret = drm_dev_register(ddev, flags);
 	if (ret == -EAGAIN && ++retry <= 3) {
 		DRM_INFO("retry init %d\n", retry);
 		/* Don't request EX mode too frequently which is attacking */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index a0b1bf17cb74..b1d0cad00b2e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1510,7 +1510,8 @@ u64 amdgpu_bo_gpu_offset_no_check(struct amdgpu_bo *bo)
 uint32_t amdgpu_bo_get_preferred_domain(struct amdgpu_device *adev,
 					    uint32_t domain)
 {
-	if (domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) {
+	if ((domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) &&
+	    ((adev->asic_type == CHIP_CARRIZO) || (adev->asic_type == CHIP_STONEY))) {
 		domain = AMDGPU_GEM_DOMAIN_VRAM;
 		if (adev->gmc.real_vram_size <= AMDGPU_SG_THRESHOLD)
 			domain = AMDGPU_GEM_DOMAIN_GTT;
diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index e9b7926d9b66..cfe163103cfd 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -487,6 +487,9 @@ void drm_connector_cleanup(struct drm_connector *connector)
 	mutex_destroy(&connector->mutex);
 
 	memset(connector, 0, sizeof(*connector));
+
+	if (dev->registered)
+		drm_sysfs_hotplug_event(dev);
 }
 EXPORT_SYMBOL(drm_connector_cleanup);
 
diff --git a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
index 0a88088a11e8..55dd02a01f1a 100644
--- a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
+++ b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
@@ -133,9 +133,9 @@ static enum port intel_dsi_seq_port_to_port(struct intel_dsi *intel_dsi,
 		return ffs(intel_dsi->ports) - 1;
 
 	if (seq_port) {
-		if (intel_dsi->ports & PORT_B)
+		if (intel_dsi->ports & BIT(PORT_B))
 			return PORT_B;
-		else if (intel_dsi->ports & PORT_C)
+		else if (intel_dsi->ports & BIT(PORT_C))
 			return PORT_C;
 	}
 
diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c b/drivers/gpu/drm/i915/gt/intel_migrate.c
index 1dac21aa7e5c..5b59a6effc20 100644
--- a/drivers/gpu/drm/i915/gt/intel_migrate.c
+++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
@@ -13,7 +13,6 @@
 
 struct insert_pte_data {
 	u64 offset;
-	bool is_lmem;
 };
 
 #define CHUNK_SZ SZ_8M /* ~1ms at 8GiB/s preemption delay */
@@ -40,7 +39,7 @@ static void insert_pte(struct i915_address_space *vm,
 	struct insert_pte_data *d = data;
 
 	vm->insert_page(vm, px_dma(pt), d->offset, I915_CACHE_NONE,
-			d->is_lmem ? PTE_LM : 0);
+			i915_gem_object_is_lmem(pt->base) ? PTE_LM : 0);
 	d->offset += PAGE_SIZE;
 }
 
@@ -134,8 +133,7 @@ static struct i915_address_space *migrate_vm(struct intel_gt *gt)
 			goto err_vm;
 
 		/* Now allow the GPU to rewrite the PTE via its own ppGTT */
-		d.is_lmem = i915_gem_object_is_lmem(vm->vm.scratch[0]);
-		vm->vm.foreach(&vm->vm, base, base + sz, insert_pte, &d);
+		vm->vm.foreach(&vm->vm, base, d.offset - base, insert_pte, &d);
 	}
 
 	return &vm->vm;
@@ -281,10 +279,10 @@ static int emit_pte(struct i915_request *rq,
 	GEM_BUG_ON(GRAPHICS_VER(rq->engine->i915) < 8);
 
 	/* Compute the page directory offset for the target address range */
-	offset += (u64)rq->engine->instance << 32;
 	offset >>= 12;
 	offset *= sizeof(u64);
 	offset += 2 * CHUNK_SZ;
+	offset += (u64)rq->engine->instance << 32;
 
 	cs = intel_ring_begin(rq, 6);
 	if (IS_ERR(cs))
diff --git a/drivers/gpu/drm/i915/gvt/debugfs.c b/drivers/gpu/drm/i915/gvt/debugfs.c
index 9f1c209d9251..e08ed0e9f165 100644
--- a/drivers/gpu/drm/i915/gvt/debugfs.c
+++ b/drivers/gpu/drm/i915/gvt/debugfs.c
@@ -175,8 +175,13 @@ void intel_gvt_debugfs_add_vgpu(struct intel_vgpu *vgpu)
  */
 void intel_gvt_debugfs_remove_vgpu(struct intel_vgpu *vgpu)
 {
-	debugfs_remove_recursive(vgpu->debugfs);
-	vgpu->debugfs = NULL;
+	struct intel_gvt *gvt = vgpu->gvt;
+	struct drm_minor *minor = gvt->gt->i915->drm.primary;
+
+	if (minor->debugfs_root && gvt->debugfs_root) {
+		debugfs_remove_recursive(vgpu->debugfs);
+		vgpu->debugfs = NULL;
+	}
 }
 
 /**
@@ -199,6 +204,10 @@ void intel_gvt_debugfs_init(struct intel_gvt *gvt)
  */
 void intel_gvt_debugfs_clean(struct intel_gvt *gvt)
 {
-	debugfs_remove_recursive(gvt->debugfs_root);
-	gvt->debugfs_root = NULL;
+	struct drm_minor *minor = gvt->gt->i915->drm.primary;
+
+	if (minor->debugfs_root) {
+		debugfs_remove_recursive(gvt->debugfs_root);
+		gvt->debugfs_root = NULL;
+	}
 }
diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/gvt/scheduler.c
index 1bb1be5c48c8..0291d42cfba8 100644
--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -694,6 +694,7 @@ intel_vgpu_shadow_mm_pin(struct intel_vgpu_workload *workload)
 
 	if (workload->shadow_mm->type != INTEL_GVT_MM_PPGTT ||
 	    !workload->shadow_mm->ppgtt_mm.shadowed) {
+		intel_vgpu_unpin_mm(workload->shadow_mm);
 		gvt_vgpu_err("workload shadow ppgtt isn't ready\n");
 		return -EINVAL;
 	}
diff --git a/drivers/gpu/drm/imx/ipuv3-plane.c b/drivers/gpu/drm/imx/ipuv3-plane.c
index 846c1aae69c8..924a66f53951 100644
--- a/drivers/gpu/drm/imx/ipuv3-plane.c
+++ b/drivers/gpu/drm/imx/ipuv3-plane.c
@@ -619,6 +619,11 @@ static void ipu_plane_atomic_update(struct drm_plane *plane,
 		break;
 	}
 
+	if (ipu_plane->dp_flow == IPU_DP_FLOW_SYNC_BG)
+		width = ipu_src_rect_width(new_state);
+	else
+		width = drm_rect_width(&new_state->src) >> 16;
+
 	eba = drm_plane_state_to_eba(new_state, 0);
 
 	/*
@@ -627,8 +632,7 @@ static void ipu_plane_atomic_update(struct drm_plane *plane,
 	 */
 	if (ipu_state->use_pre) {
 		axi_id = ipu_chan_assign_axi_id(ipu_plane->dma);
-		ipu_prg_channel_configure(ipu_plane->ipu_ch, axi_id,
-					  ipu_src_rect_width(new_state),
+		ipu_prg_channel_configure(ipu_plane->ipu_ch, axi_id, width,
 					  drm_rect_height(&new_state->src) >> 16,
 					  fb->pitches[0], fb->format->format,
 					  fb->modifier, &eba);
@@ -683,9 +687,8 @@ static void ipu_plane_atomic_update(struct drm_plane *plane,
 		break;
 	}
 
-	ipu_dmfc_config_wait4eot(ipu_plane->dmfc, ALIGN(drm_rect_width(dst), 8));
+	ipu_dmfc_config_wait4eot(ipu_plane->dmfc, width);
 
-	width = ipu_src_rect_width(new_state);
 	height = drm_rect_height(&new_state->src) >> 16;
 	info = drm_format_info(fb->format->format);
 	ipu_calculate_bursts(width, info->cpp[0], fb->pitches[0],
@@ -749,8 +752,7 @@ static void ipu_plane_atomic_update(struct drm_plane *plane,
 		ipu_cpmem_set_burstsize(ipu_plane->ipu_ch, 16);
 
 		ipu_cpmem_zero(ipu_plane->alpha_ch);
-		ipu_cpmem_set_resolution(ipu_plane->alpha_ch,
-					 ipu_src_rect_width(new_state),
+		ipu_cpmem_set_resolution(ipu_plane->alpha_ch, width,
 					 drm_rect_height(&new_state->src) >> 16);
 		ipu_cpmem_set_format_passthrough(ipu_plane->alpha_ch, 8);
 		ipu_cpmem_set_high_priority(ipu_plane->alpha_ch);
diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index a5df1c8d34cd..d9231b89d73e 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -1326,7 +1326,11 @@ static int ingenic_drm_init(void)
 			return err;
 	}
 
-	return platform_driver_register(&ingenic_drm_driver);
+	err = platform_driver_register(&ingenic_drm_driver);
+	if (IS_ENABLED(CONFIG_DRM_INGENIC_IPU) && err)
+		platform_driver_unregister(ingenic_ipu_driver_ptr);
+
+	return err;
 }
 module_init(ingenic_drm_init);
 
diff --git a/drivers/gpu/drm/meson/meson_viu.c b/drivers/gpu/drm/meson/meson_viu.c
index d4b907889a21..cd399b0b7181 100644
--- a/drivers/gpu/drm/meson/meson_viu.c
+++ b/drivers/gpu/drm/meson/meson_viu.c
@@ -436,15 +436,14 @@ void meson_viu_init(struct meson_drm *priv)
 
 	/* Initialize OSD1 fifo control register */
 	reg = VIU_OSD_DDR_PRIORITY_URGENT |
-		VIU_OSD_HOLD_FIFO_LINES(31) |
 		VIU_OSD_FIFO_DEPTH_VAL(32) | /* fifo_depth_val: 32*8=256 */
 		VIU_OSD_WORDS_PER_BURST(4) | /* 4 words in 1 burst */
 		VIU_OSD_FIFO_LIMITS(2);      /* fifo_lim: 2*16=32 */
 
 	if (meson_vpu_is_compatible(priv, VPU_COMPATIBLE_G12A))
-		reg |= VIU_OSD_BURST_LENGTH_32;
+		reg |= (VIU_OSD_BURST_LENGTH_32 | VIU_OSD_HOLD_FIFO_LINES(31));
 	else
-		reg |= VIU_OSD_BURST_LENGTH_64;
+		reg |= (VIU_OSD_BURST_LENGTH_64 | VIU_OSD_HOLD_FIFO_LINES(4));
 
 	writel_relaxed(reg, priv->io_base + _REG(VIU_OSD1_FIFO_CTRL_STAT));
 	writel_relaxed(reg, priv->io_base + _REG(VIU_OSD2_FIFO_CTRL_STAT));
diff --git a/drivers/gpu/drm/mgag200/mgag200_pll.c b/drivers/gpu/drm/mgag200/mgag200_pll.c
index 52be08b744ad..87f9846b9b4f 100644
--- a/drivers/gpu/drm/mgag200/mgag200_pll.c
+++ b/drivers/gpu/drm/mgag200/mgag200_pll.c
@@ -268,7 +268,8 @@ static void mgag200_pixpll_update_g200se_04(struct mgag200_pll *pixpll,
 	pixpllcp = pixpllc->p - 1;
 	pixpllcs = pixpllc->s;
 
-	xpixpllcm = pixpllcm | ((pixpllcn & BIT(8)) >> 1);
+	// For G200SE A, BIT(7) should be set unconditionally.
+	xpixpllcm = BIT(7) | pixpllcm;
 	xpixpllcn = pixpllcn;
 	xpixpllcp = (pixpllcs << 3) | pixpllcp;
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index e48e357ea4f1..4c271244092b 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -82,6 +82,7 @@ static int panfrost_ioctl_create_bo(struct drm_device *dev, void *data,
 	struct panfrost_gem_object *bo;
 	struct drm_panfrost_create_bo *args = data;
 	struct panfrost_gem_mapping *mapping;
+	int ret;
 
 	if (!args->size || args->pad ||
 	    (args->flags & ~(PANFROST_BO_NOEXEC | PANFROST_BO_HEAP)))
@@ -92,21 +93,29 @@ static int panfrost_ioctl_create_bo(struct drm_device *dev, void *data,
 	    !(args->flags & PANFROST_BO_NOEXEC))
 		return -EINVAL;
 
-	bo = panfrost_gem_create_with_handle(file, dev, args->size, args->flags,
-					     &args->handle);
+	bo = panfrost_gem_create(dev, args->size, args->flags);
 	if (IS_ERR(bo))
 		return PTR_ERR(bo);
 
+	ret = drm_gem_handle_create(file, &bo->base.base, &args->handle);
+	if (ret)
+		goto out;
+
 	mapping = panfrost_gem_mapping_get(bo, priv);
-	if (!mapping) {
-		drm_gem_object_put(&bo->base.base);
-		return -EINVAL;
+	if (mapping) {
+		args->offset = mapping->mmnode.start << PAGE_SHIFT;
+		panfrost_gem_mapping_put(mapping);
+	} else {
+		/* This can only happen if the handle from
+		 * drm_gem_handle_create() has already been guessed and freed
+		 * by user space
+		 */
+		ret = -EINVAL;
 	}
 
-	args->offset = mapping->mmnode.start << PAGE_SHIFT;
-	panfrost_gem_mapping_put(mapping);
-
-	return 0;
+out:
+	drm_gem_object_put(&bo->base.base);
+	return ret;
 }
 
 /**
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index 6d9bdb9180cb..55e3a68ed28a 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -234,12 +234,8 @@ struct drm_gem_object *panfrost_gem_create_object(struct drm_device *dev, size_t
 }
 
 struct panfrost_gem_object *
-panfrost_gem_create_with_handle(struct drm_file *file_priv,
-				struct drm_device *dev, size_t size,
-				u32 flags,
-				uint32_t *handle)
+panfrost_gem_create(struct drm_device *dev, size_t size, u32 flags)
 {
-	int ret;
 	struct drm_gem_shmem_object *shmem;
 	struct panfrost_gem_object *bo;
 
@@ -255,16 +251,6 @@ panfrost_gem_create_with_handle(struct drm_file *file_priv,
 	bo->noexec = !!(flags & PANFROST_BO_NOEXEC);
 	bo->is_heap = !!(flags & PANFROST_BO_HEAP);
 
-	/*
-	 * Allocate an id of idr table where the obj is registered
-	 * and handle has the id what user can see.
-	 */
-	ret = drm_gem_handle_create(file_priv, &shmem->base, handle);
-	/* drop reference from allocate - handle holds it now. */
-	drm_gem_object_put(&shmem->base);
-	if (ret)
-		return ERR_PTR(ret);
-
 	return bo;
 }
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h b/drivers/gpu/drm/panfrost/panfrost_gem.h
index 8088d5fd8480..ad2877eeeccd 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.h
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
@@ -69,10 +69,7 @@ panfrost_gem_prime_import_sg_table(struct drm_device *dev,
 				   struct sg_table *sgt);
 
 struct panfrost_gem_object *
-panfrost_gem_create_with_handle(struct drm_file *file_priv,
-				struct drm_device *dev, size_t size,
-				u32 flags,
-				uint32_t *handle);
+panfrost_gem_create(struct drm_device *dev, size_t size, u32 flags);
 
 int panfrost_gem_open(struct drm_gem_object *obj, struct drm_file *file_priv);
 void panfrost_gem_close(struct drm_gem_object *obj,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 171e90c4b9f3..01d5a01af259 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -186,7 +186,8 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
 	if (cmd->dma.guest.ptr.offset % PAGE_SIZE ||
 	    box->x != 0    || box->y != 0    || box->z != 0    ||
 	    box->srcx != 0 || box->srcy != 0 || box->srcz != 0 ||
-	    box->d != 1    || box_count != 1) {
+	    box->d != 1    || box_count != 1 ||
+	    box->w > 64 || box->h > 64) {
 		/* TODO handle none page aligned offsets */
 		/* TODO handle more dst & src != 0 */
 		/* TODO handle more then one copy */
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 78b55f845d2d..8698d49edaa3 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -966,7 +966,10 @@
 #define USB_DEVICE_ID_ORTEK_IHOME_IMAC_A210S	0x8003
 
 #define USB_VENDOR_ID_PLANTRONICS	0x047f
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3210_SERIES	0xc055
 #define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3220_SERIES	0xc056
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3215_SERIES	0xc057
+#define USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3225_SERIES	0xc058
 
 #define USB_VENDOR_ID_PANASONIC		0x04da
 #define USB_DEVICE_ID_PANABOARD_UBT780	0x1044
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 08462ac72b89..6b86d368d5e7 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1965,6 +1965,10 @@ static const struct hid_device_id mt_devices[] = {
 		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
 			USB_VENDOR_ID_ELAN, 0x313a) },
 
+	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_ELAN, 0x3148) },
+
 	/* Elitegroup panel */
 	{ .driver_data = MT_CLS_SERIAL,
 		MT_USB_DEVICE(USB_VENDOR_ID_ELITEGROUP,
diff --git a/drivers/hid/hid-plantronics.c b/drivers/hid/hid-plantronics.c
index e81b7cec2d12..3d414ae194ac 100644
--- a/drivers/hid/hid-plantronics.c
+++ b/drivers/hid/hid-plantronics.c
@@ -198,9 +198,18 @@ static int plantronics_probe(struct hid_device *hdev,
 }
 
 static const struct hid_device_id plantronics_devices[] = {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
+					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3210_SERIES),
+		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
 					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3220_SERIES),
 		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
+					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3215_SERIES),
+		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS,
+					 USB_DEVICE_ID_PLANTRONICS_BLACKWIRE_3225_SERIES),
+		.driver_data = PLT_QUIRK_DOUBLE_VOLUME_KEYS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PLANTRONICS, HID_ANY_ID) },
 	{ }
 };
diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 224ba36f2946..1a0ecf439c09 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -249,7 +249,6 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	const struct mlx5_ib_counters *cnts = get_counters(dev, port_num - 1);
 	struct mlx5_core_dev *mdev;
 	int ret, num_counters;
-	u32 mdev_port_num;
 
 	if (!stats)
 		return -EINVAL;
@@ -270,8 +269,9 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	}
 
 	if (MLX5_CAP_GEN(dev->mdev, cc_query_allowed)) {
-		mdev = mlx5_ib_get_native_port_mdev(dev, port_num,
-						    &mdev_port_num);
+		if (!port_num)
+			port_num = 1;
+		mdev = mlx5_ib_get_native_port_mdev(dev, port_num, NULL);
 		if (!mdev) {
 			/* If port is not affiliated yet, its in down state
 			 * which doesn't have any counters yet, so it would be
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index e5abbcfc1d57..55b05a3e31b8 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -4499,6 +4499,40 @@ static bool mlx5_ib_modify_qp_allowed(struct mlx5_ib_dev *dev,
 	return false;
 }
 
+static int validate_rd_atomic(struct mlx5_ib_dev *dev, struct ib_qp_attr *attr,
+			      int attr_mask, enum ib_qp_type qp_type)
+{
+	int log_max_ra_res;
+	int log_max_ra_req;
+
+	if (qp_type == MLX5_IB_QPT_DCI) {
+		log_max_ra_res = 1 << MLX5_CAP_GEN(dev->mdev,
+						   log_max_ra_res_dc);
+		log_max_ra_req = 1 << MLX5_CAP_GEN(dev->mdev,
+						   log_max_ra_req_dc);
+	} else {
+		log_max_ra_res = 1 << MLX5_CAP_GEN(dev->mdev,
+						   log_max_ra_res_qp);
+		log_max_ra_req = 1 << MLX5_CAP_GEN(dev->mdev,
+						   log_max_ra_req_qp);
+	}
+
+	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
+	    attr->max_rd_atomic > log_max_ra_res) {
+		mlx5_ib_dbg(dev, "invalid max_rd_atomic value %d\n",
+			    attr->max_rd_atomic);
+		return false;
+	}
+
+	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC &&
+	    attr->max_dest_rd_atomic > log_max_ra_req) {
+		mlx5_ib_dbg(dev, "invalid max_dest_rd_atomic value %d\n",
+			    attr->max_dest_rd_atomic);
+		return false;
+	}
+	return true;
+}
+
 int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		      int attr_mask, struct ib_udata *udata)
 {
@@ -4586,21 +4620,8 @@ int mlx5_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		goto out;
 	}
 
-	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
-	    attr->max_rd_atomic >
-	    (1 << MLX5_CAP_GEN(dev->mdev, log_max_ra_res_qp))) {
-		mlx5_ib_dbg(dev, "invalid max_rd_atomic value %d\n",
-			    attr->max_rd_atomic);
-		goto out;
-	}
-
-	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC &&
-	    attr->max_dest_rd_atomic >
-	    (1 << MLX5_CAP_GEN(dev->mdev, log_max_ra_req_qp))) {
-		mlx5_ib_dbg(dev, "invalid max_dest_rd_atomic value %d\n",
-			    attr->max_dest_rd_atomic);
+	if (!validate_rd_atomic(dev, attr, attr_mask, qp_type))
 		goto out;
-	}
 
 	if (cur_state == new_state && cur_state == IB_QPS_RESET) {
 		err = 0;
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 9a7742732d73..ce91a6d8532f 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3226,6 +3226,13 @@ static int __init parse_ivrs_acpihid(char *str)
 		return 1;
 	}
 
+	/*
+	 * Ignore leading zeroes after ':', so e.g., AMDI0095:00
+	 * will match AMDI0095:0 in the second strcmp in acpi_dev_hid_uid_match
+	 */
+	while (*uid == '0' && *(uid + 1))
+		uid++;
+
 	i = early_acpihid_map_size++;
 	memcpy(early_acpihid_map[i].hid, hid, strlen(hid));
 	memcpy(early_acpihid_map[i].uid, uid, strlen(uid));
diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 89a73204dbf4..0f6f74e3030f 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -551,11 +551,13 @@ static int __create_persistent_data_objects(struct dm_cache_metadata *cmd,
 	return r;
 }
 
-static void __destroy_persistent_data_objects(struct dm_cache_metadata *cmd)
+static void __destroy_persistent_data_objects(struct dm_cache_metadata *cmd,
+					      bool destroy_bm)
 {
 	dm_sm_destroy(cmd->metadata_sm);
 	dm_tm_destroy(cmd->tm);
-	dm_block_manager_destroy(cmd->bm);
+	if (destroy_bm)
+		dm_block_manager_destroy(cmd->bm);
 }
 
 typedef unsigned long (*flags_mutator)(unsigned long);
@@ -826,7 +828,7 @@ static struct dm_cache_metadata *lookup_or_open(struct block_device *bdev,
 		cmd2 = lookup(bdev);
 		if (cmd2) {
 			mutex_unlock(&table_lock);
-			__destroy_persistent_data_objects(cmd);
+			__destroy_persistent_data_objects(cmd, true);
 			kfree(cmd);
 			return cmd2;
 		}
@@ -874,7 +876,7 @@ void dm_cache_metadata_close(struct dm_cache_metadata *cmd)
 		mutex_unlock(&table_lock);
 
 		if (!cmd->fail_io)
-			__destroy_persistent_data_objects(cmd);
+			__destroy_persistent_data_objects(cmd, true);
 		kfree(cmd);
 	}
 }
@@ -1808,14 +1810,52 @@ int dm_cache_metadata_needs_check(struct dm_cache_metadata *cmd, bool *result)
 
 int dm_cache_metadata_abort(struct dm_cache_metadata *cmd)
 {
-	int r;
+	int r = -EINVAL;
+	struct dm_block_manager *old_bm = NULL, *new_bm = NULL;
+
+	/* fail_io is double-checked with cmd->root_lock held below */
+	if (unlikely(cmd->fail_io))
+		return r;
+
+	/*
+	 * Replacement block manager (new_bm) is created and old_bm destroyed outside of
+	 * cmd root_lock to avoid ABBA deadlock that would result (due to life-cycle of
+	 * shrinker associated with the block manager's bufio client vs cmd root_lock).
+	 * - must take shrinker_rwsem without holding cmd->root_lock
+	 */
+	new_bm = dm_block_manager_create(cmd->bdev, DM_CACHE_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
+					 CACHE_MAX_CONCURRENT_LOCKS);
 
 	WRITE_LOCK(cmd);
-	__destroy_persistent_data_objects(cmd);
-	r = __create_persistent_data_objects(cmd, false);
+	if (cmd->fail_io) {
+		WRITE_UNLOCK(cmd);
+		goto out;
+	}
+
+	__destroy_persistent_data_objects(cmd, false);
+	old_bm = cmd->bm;
+	if (IS_ERR(new_bm)) {
+		DMERR("could not create block manager during abort");
+		cmd->bm = NULL;
+		r = PTR_ERR(new_bm);
+		goto out_unlock;
+	}
+
+	cmd->bm = new_bm;
+	r = __open_or_format_metadata(cmd, false);
+	if (r) {
+		cmd->bm = NULL;
+		goto out_unlock;
+	}
+	new_bm = NULL;
+out_unlock:
 	if (r)
 		cmd->fail_io = true;
 	WRITE_UNLOCK(cmd);
+	dm_block_manager_destroy(old_bm);
+out:
+	if (new_bm && !IS_ERR(new_bm))
+		dm_block_manager_destroy(new_bm);
 
 	return r;
 }
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index bdd500447dea..abfe7e37b76f 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -915,16 +915,16 @@ static void abort_transaction(struct cache *cache)
 	if (get_cache_mode(cache) >= CM_READ_ONLY)
 		return;
 
-	if (dm_cache_metadata_set_needs_check(cache->cmd)) {
-		DMERR("%s: failed to set 'needs_check' flag in metadata", dev_name);
-		set_cache_mode(cache, CM_FAIL);
-	}
-
 	DMERR_LIMIT("%s: aborting current metadata transaction", dev_name);
 	if (dm_cache_metadata_abort(cache->cmd)) {
 		DMERR("%s: failed to abort metadata transaction", dev_name);
 		set_cache_mode(cache, CM_FAIL);
 	}
+
+	if (dm_cache_metadata_set_needs_check(cache->cmd)) {
+		DMERR("%s: failed to set 'needs_check' flag in metadata", dev_name);
+		set_cache_mode(cache, CM_FAIL);
+	}
 }
 
 static void metadata_operation_failed(struct cache *cache, const char *op, int r)
@@ -1895,6 +1895,7 @@ static void destroy(struct cache *cache)
 	if (cache->prison)
 		dm_bio_prison_destroy_v2(cache->prison);
 
+	cancel_delayed_work_sync(&cache->waker);
 	if (cache->wq)
 		destroy_workqueue(cache->wq);
 
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index edd22e4d65df..ec4f2487ef10 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -1959,6 +1959,7 @@ static void clone_dtr(struct dm_target *ti)
 
 	mempool_exit(&clone->hydration_pool);
 	dm_kcopyd_client_destroy(clone->kcopyd_client);
+	cancel_delayed_work_sync(&clone->waker);
 	destroy_workqueue(clone->wq);
 	hash_table_exit(clone);
 	dm_clone_metadata_close(clone->cmd);
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 9705f3c358dd..508e81bfef2c 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4539,6 +4539,8 @@ static void dm_integrity_dtr(struct dm_target *ti)
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 	BUG_ON(!list_empty(&ic->wait_list));
 
+	if (ic->mode == 'B')
+		cancel_delayed_work_sync(&ic->bitmap_flush_work);
 	if (ic->metadata_wq)
 		destroy_workqueue(ic->metadata_wq);
 	if (ic->wait_wq)
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 0ada99572b68..3ce7017bf9d5 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -724,6 +724,15 @@ static int __open_metadata(struct dm_pool_metadata *pmd)
 		goto bad_cleanup_data_sm;
 	}
 
+	/*
+	 * For pool metadata opening process, root setting is redundant
+	 * because it will be set again in __begin_transaction(). But dm
+	 * pool aborting process really needs to get last transaction's
+	 * root to avoid accessing broken btree.
+	 */
+	pmd->root = le64_to_cpu(disk_super->data_mapping_root);
+	pmd->details_root = le64_to_cpu(disk_super->device_details_root);
+
 	__setup_btree_details(pmd);
 	dm_bm_unlock(sblock);
 
@@ -776,13 +785,15 @@ static int __create_persistent_data_objects(struct dm_pool_metadata *pmd, bool f
 	return r;
 }
 
-static void __destroy_persistent_data_objects(struct dm_pool_metadata *pmd)
+static void __destroy_persistent_data_objects(struct dm_pool_metadata *pmd,
+					      bool destroy_bm)
 {
 	dm_sm_destroy(pmd->data_sm);
 	dm_sm_destroy(pmd->metadata_sm);
 	dm_tm_destroy(pmd->nb_tm);
 	dm_tm_destroy(pmd->tm);
-	dm_block_manager_destroy(pmd->bm);
+	if (destroy_bm)
+		dm_block_manager_destroy(pmd->bm);
 }
 
 static int __begin_transaction(struct dm_pool_metadata *pmd)
@@ -989,7 +1000,7 @@ int dm_pool_metadata_close(struct dm_pool_metadata *pmd)
 	}
 	pmd_write_unlock(pmd);
 	if (!pmd->fail_io)
-		__destroy_persistent_data_objects(pmd);
+		__destroy_persistent_data_objects(pmd, true);
 
 	kfree(pmd);
 	return 0;
@@ -1888,19 +1899,52 @@ static void __set_abort_with_changes_flags(struct dm_pool_metadata *pmd)
 int dm_pool_abort_metadata(struct dm_pool_metadata *pmd)
 {
 	int r = -EINVAL;
+	struct dm_block_manager *old_bm = NULL, *new_bm = NULL;
+
+	/* fail_io is double-checked with pmd->root_lock held below */
+	if (unlikely(pmd->fail_io))
+		return r;
+
+	/*
+	 * Replacement block manager (new_bm) is created and old_bm destroyed outside of
+	 * pmd root_lock to avoid ABBA deadlock that would result (due to life-cycle of
+	 * shrinker associated with the block manager's bufio client vs pmd root_lock).
+	 * - must take shrinker_rwsem without holding pmd->root_lock
+	 */
+	new_bm = dm_block_manager_create(pmd->bdev, THIN_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
+					 THIN_MAX_CONCURRENT_LOCKS);
 
 	pmd_write_lock(pmd);
-	if (pmd->fail_io)
+	if (pmd->fail_io) {
+		pmd_write_unlock(pmd);
 		goto out;
+	}
 
 	__set_abort_with_changes_flags(pmd);
-	__destroy_persistent_data_objects(pmd);
-	r = __create_persistent_data_objects(pmd, false);
+	__destroy_persistent_data_objects(pmd, false);
+	old_bm = pmd->bm;
+	if (IS_ERR(new_bm)) {
+		DMERR("could not create block manager during abort");
+		pmd->bm = NULL;
+		r = PTR_ERR(new_bm);
+		goto out_unlock;
+	}
+
+	pmd->bm = new_bm;
+	r = __open_or_format_metadata(pmd, false);
+	if (r) {
+		pmd->bm = NULL;
+		goto out_unlock;
+	}
+	new_bm = NULL;
+out_unlock:
 	if (r)
 		pmd->fail_io = true;
-
-out:
 	pmd_write_unlock(pmd);
+	dm_block_manager_destroy(old_bm);
+out:
+	if (new_bm && !IS_ERR(new_bm))
+		dm_block_manager_destroy(new_bm);
 
 	return r;
 }
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 0a85e4cd607c..cce26f46ded5 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2907,6 +2907,8 @@ static void __pool_destroy(struct pool *pool)
 	dm_bio_prison_destroy(pool->prison);
 	dm_kcopyd_client_destroy(pool->copier);
 
+	cancel_delayed_work_sync(&pool->waker);
+	cancel_delayed_work_sync(&pool->no_space_timeout);
 	if (pool->wq)
 		destroy_workqueue(pool->wq);
 
@@ -3566,20 +3568,28 @@ static int pool_preresume(struct dm_target *ti)
 	 */
 	r = bind_control_target(pool, ti);
 	if (r)
-		return r;
+		goto out;
 
 	r = maybe_resize_data_dev(ti, &need_commit1);
 	if (r)
-		return r;
+		goto out;
 
 	r = maybe_resize_metadata_dev(ti, &need_commit2);
 	if (r)
-		return r;
+		goto out;
 
 	if (need_commit1 || need_commit2)
 		(void) commit(pool);
+out:
+	/*
+	 * When a thin-pool is PM_FAIL, it cannot be rebuilt if
+	 * bio is in deferred list. Therefore need to return 0
+	 * to allow pool_resume() to flush IO.
+	 */
+	if (r && get_pool_mode(pool) == PM_FAIL)
+		r = 0;
 
-	return 0;
+	return r;
 }
 
 static void pool_suspend_active_thins(struct pool *pool)
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 650bfccd066f..062142559caa 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -486,7 +486,7 @@ void md_bitmap_print_sb(struct bitmap *bitmap)
 	sb = kmap_atomic(bitmap->storage.sb_page);
 	pr_debug("%s: bitmap file superblock:\n", bmname(bitmap));
 	pr_debug("         magic: %08x\n", le32_to_cpu(sb->magic));
-	pr_debug("       version: %d\n", le32_to_cpu(sb->version));
+	pr_debug("       version: %u\n", le32_to_cpu(sb->version));
 	pr_debug("          uuid: %08x.%08x.%08x.%08x\n",
 		 le32_to_cpu(*(__le32 *)(sb->uuid+0)),
 		 le32_to_cpu(*(__le32 *)(sb->uuid+4)),
@@ -497,11 +497,11 @@ void md_bitmap_print_sb(struct bitmap *bitmap)
 	pr_debug("events cleared: %llu\n",
 		 (unsigned long long) le64_to_cpu(sb->events_cleared));
 	pr_debug("         state: %08x\n", le32_to_cpu(sb->state));
-	pr_debug("     chunksize: %d B\n", le32_to_cpu(sb->chunksize));
-	pr_debug("  daemon sleep: %ds\n", le32_to_cpu(sb->daemon_sleep));
+	pr_debug("     chunksize: %u B\n", le32_to_cpu(sb->chunksize));
+	pr_debug("  daemon sleep: %us\n", le32_to_cpu(sb->daemon_sleep));
 	pr_debug("     sync size: %llu KB\n",
 		 (unsigned long long)le64_to_cpu(sb->sync_size)/2);
-	pr_debug("max write behind: %d\n", le32_to_cpu(sb->write_behind));
+	pr_debug("max write behind: %u\n", le32_to_cpu(sb->write_behind));
 	kunmap_atomic(sb);
 }
 
@@ -2106,7 +2106,8 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 			bytes = DIV_ROUND_UP(chunks, 8);
 			if (!bitmap->mddev->bitmap_info.external)
 				bytes += sizeof(bitmap_super_t);
-		} while (bytes > (space << 9));
+		} while (bytes > (space << 9) && (chunkshift + BITMAP_BLOCK_SHIFT) <
+			(BITS_PER_BYTE * sizeof(((bitmap_super_t *)0)->chunksize) - 1));
 	} else
 		chunkshift = ffz(~chunksize) - BITMAP_BLOCK_SHIFT;
 
@@ -2151,7 +2152,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	bitmap->counts.missing_pages = pages;
 	bitmap->counts.chunkshift = chunkshift;
 	bitmap->counts.chunks = chunks;
-	bitmap->mddev->bitmap_info.chunksize = 1 << (chunkshift +
+	bitmap->mddev->bitmap_info.chunksize = 1UL << (chunkshift +
 						     BITMAP_BLOCK_SHIFT);
 
 	blocks = min(old_counts.chunks << old_counts.chunkshift,
@@ -2177,8 +2178,8 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 				bitmap->counts.missing_pages = old_counts.pages;
 				bitmap->counts.chunkshift = old_counts.chunkshift;
 				bitmap->counts.chunks = old_counts.chunks;
-				bitmap->mddev->bitmap_info.chunksize = 1 << (old_counts.chunkshift +
-									     BITMAP_BLOCK_SHIFT);
+				bitmap->mddev->bitmap_info.chunksize =
+					1UL << (old_counts.chunkshift + BITMAP_BLOCK_SHIFT);
 				blocks = old_counts.chunks << old_counts.chunkshift;
 				pr_warn("Could not pre-allocate in-memory bitmap for cluster raid\n");
 				break;
@@ -2519,6 +2520,9 @@ chunksize_store(struct mddev *mddev, const char *buf, size_t len)
 	if (csize < 512 ||
 	    !is_power_of_2(csize))
 		return -EINVAL;
+	if (BITS_PER_LONG > 32 && csize >= (1ULL << (BITS_PER_BYTE *
+		sizeof(((bitmap_super_t *)0)->chunksize))))
+		return -EOVERFLOW;
 	mddev->bitmap_info.chunksize = csize;
 	return len;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 04e1e294b4b1..59ab99844df8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -526,13 +526,14 @@ static void md_end_flush(struct bio *bio)
 	struct md_rdev *rdev = bio->bi_private;
 	struct mddev *mddev = rdev->mddev;
 
+	bio_put(bio);
+
 	rdev_dec_pending(rdev, mddev);
 
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
 		/* The pre-request flush has finished */
 		queue_work(md_wq, &mddev->flush_work);
 	}
-	bio_put(bio);
 }
 
 static void md_submit_flush_data(struct work_struct *ws);
@@ -935,10 +936,12 @@ static void super_written(struct bio *bio)
 	} else
 		clear_bit(LastDev, &rdev->flags);
 
+	bio_put(bio);
+
+	rdev_dec_pending(rdev, mddev);
+
 	if (atomic_dec_and_test(&mddev->pending_writes))
 		wake_up(&mddev->sb_wait);
-	rdev_dec_pending(rdev, mddev);
-	bio_put(bio);
 }
 
 void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 01f288fa37e0..8abf7f44d96b 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -800,6 +800,11 @@ static int dvb_demux_open(struct inode *inode, struct file *file)
 	if (mutex_lock_interruptible(&dmxdev->mutex))
 		return -ERESTARTSYS;
 
+	if (dmxdev->exit) {
+		mutex_unlock(&dmxdev->mutex);
+		return -ENODEV;
+	}
+
 	for (i = 0; i < dmxdev->filternum; i++)
 		if (dmxdev->filter[i].state == DMXDEV_STATE_FREE)
 			break;
@@ -1458,7 +1463,10 @@ EXPORT_SYMBOL(dvb_dmxdev_init);
 
 void dvb_dmxdev_release(struct dmxdev *dmxdev)
 {
+	mutex_lock(&dmxdev->mutex);
 	dmxdev->exit = 1;
+	mutex_unlock(&dmxdev->mutex);
+
 	if (dmxdev->dvbdev->users > 1) {
 		wait_event(dmxdev->dvbdev->wait_queue,
 				dmxdev->dvbdev->users == 1);
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 828a0069a296..6e2b7e97da17 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -345,6 +345,7 @@ static int dvb_create_media_entity(struct dvb_device *dvbdev,
 				       GFP_KERNEL);
 		if (!dvbdev->pads) {
 			kfree(dvbdev->entity);
+			dvbdev->entity = NULL;
 			return -ENOMEM;
 		}
 	}
diff --git a/drivers/media/dvb-frontends/stv0288.c b/drivers/media/dvb-frontends/stv0288.c
index 3d54a0ec86af..3ae1f3a2f142 100644
--- a/drivers/media/dvb-frontends/stv0288.c
+++ b/drivers/media/dvb-frontends/stv0288.c
@@ -440,9 +440,8 @@ static int stv0288_set_frontend(struct dvb_frontend *fe)
 	struct stv0288_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	char tm;
-	unsigned char tda[3];
-	u8 reg, time_out = 0;
+	u8 tda[3], reg, time_out = 0;
+	s8 tm;
 
 	dprintk("%s : FE_SET_FRONTEND\n", __func__);
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index da138c314963..58822ec5370e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -468,8 +468,10 @@ void s5p_mfc_close_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
 	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	/* Wait until instance is returned or timeout occurred */
 	if (s5p_mfc_wait_for_done_ctx(ctx,
-				S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0))
+				S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0)){
+		clear_work_bit_irqsave(ctx);
 		mfc_err("Err returning instance\n");
+	}
 
 	/* Free resources */
 	s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers, ctx);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 1fad99edb091..3da1775a65f1 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1218,6 +1218,7 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 	unsigned long mb_y_addr, mb_c_addr;
 	int slice_type;
 	unsigned int strm_size;
+	bool src_ready;
 
 	slice_type = s5p_mfc_hw_call(dev->mfc_ops, get_enc_slice_type, dev);
 	strm_size = s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size, dev);
@@ -1257,7 +1258,8 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 			}
 		}
 	}
-	if ((ctx->src_queue_cnt > 0) && (ctx->state == MFCINST_RUNNING)) {
+	if (ctx->src_queue_cnt > 0 && (ctx->state == MFCINST_RUNNING ||
+				       ctx->state == MFCINST_FINISHING)) {
 		mb_entry = list_entry(ctx->src_queue.next, struct s5p_mfc_buf,
 									list);
 		if (mb_entry->flags & MFC_BUF_FLAG_USED) {
@@ -1288,7 +1290,13 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 		vb2_set_plane_payload(&mb_entry->b->vb2_buf, 0, strm_size);
 		vb2_buffer_done(&mb_entry->b->vb2_buf, VB2_BUF_STATE_DONE);
 	}
-	if ((ctx->src_queue_cnt == 0) || (ctx->dst_queue_cnt == 0))
+
+	src_ready = true;
+	if (ctx->state == MFCINST_RUNNING && ctx->src_queue_cnt == 0)
+		src_ready = false;
+	if (ctx->state == MFCINST_FINISHING && ctx->ref_queue_cnt == 0)
+		src_ready = false;
+	if (!src_ready || ctx->dst_queue_cnt == 0)
 		clear_work_bit(ctx);
 
 	return 0;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index a1453053e31a..ef8169f6c428 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1060,7 +1060,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	}
 
 	/* aspect ratio VUI */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 5);
 	reg |= ((p_h264->vui_sar & 0x1) << 5);
 	writel(reg, mfc_regs->e_h264_options);
@@ -1083,7 +1083,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 
 	/* intra picture period for H.264 open GOP */
 	/* control */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 4);
 	reg |= ((p_h264->open_gop & 0x1) << 4);
 	writel(reg, mfc_regs->e_h264_options);
@@ -1097,23 +1097,23 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	}
 
 	/* 'WEIGHTED_BI_PREDICTION' for B is disable */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x3 << 9);
 	writel(reg, mfc_regs->e_h264_options);
 
 	/* 'CONSTRAINED_INTRA_PRED_ENABLE' is disable */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 14);
 	writel(reg, mfc_regs->e_h264_options);
 
 	/* ASO */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 6);
 	reg |= ((p_h264->aso & 0x1) << 6);
 	writel(reg, mfc_regs->e_h264_options);
 
 	/* hier qp enable */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 8);
 	reg |= ((p_h264->open_gop & 0x1) << 8);
 	writel(reg, mfc_regs->e_h264_options);
@@ -1134,7 +1134,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	writel(reg, mfc_regs->e_h264_num_t_layer);
 
 	/* frame packing SEI generation */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 25);
 	reg |= ((p_h264->sei_frame_packing & 0x1) << 25);
 	writel(reg, mfc_regs->e_h264_options);
diff --git a/drivers/mfd/mt6360-core.c b/drivers/mfd/mt6360-core.c
index 6eaa6775b888..d3b32eb79837 100644
--- a/drivers/mfd/mt6360-core.c
+++ b/drivers/mfd/mt6360-core.c
@@ -402,7 +402,7 @@ static int mt6360_regmap_read(void *context, const void *reg, size_t reg_size,
 	struct mt6360_ddata *ddata = context;
 	u8 bank = *(u8 *)reg;
 	u8 reg_addr = *(u8 *)(reg + 1);
-	struct i2c_client *i2c = ddata->i2c[bank];
+	struct i2c_client *i2c;
 	bool crc_needed = false;
 	u8 *buf;
 	int buf_len = MT6360_ALLOC_READ_SIZE(val_size);
@@ -410,6 +410,11 @@ static int mt6360_regmap_read(void *context, const void *reg, size_t reg_size,
 	u8 crc;
 	int ret;
 
+	if (bank >= MT6360_SLAVE_MAX)
+		return -EINVAL;
+
+	i2c = ddata->i2c[bank];
+
 	if (bank == MT6360_SLAVE_PMIC || bank == MT6360_SLAVE_LDO) {
 		crc_needed = true;
 		ret = mt6360_xlate_pmicldo_addr(&reg_addr, val_size);
@@ -453,13 +458,18 @@ static int mt6360_regmap_write(void *context, const void *val, size_t val_size)
 	struct mt6360_ddata *ddata = context;
 	u8 bank = *(u8 *)val;
 	u8 reg_addr = *(u8 *)(val + 1);
-	struct i2c_client *i2c = ddata->i2c[bank];
+	struct i2c_client *i2c;
 	bool crc_needed = false;
 	u8 *buf;
 	int buf_len = MT6360_ALLOC_WRITE_SIZE(val_size);
 	int write_size = val_size - MT6360_REGMAP_REG_BYTE_SIZE;
 	int ret;
 
+	if (bank >= MT6360_SLAVE_MAX)
+		return -EINVAL;
+
+	i2c = ddata->i2c[bank];
+
 	if (bank == MT6360_SLAVE_PMIC || bank == MT6360_SLAVE_LDO) {
 		crc_needed = true;
 		ret = mt6360_xlate_pmicldo_addr(&reg_addr, val_size - MT6360_REGMAP_REG_BYTE_SIZE);
diff --git a/drivers/mmc/host/sdhci-sprd.c b/drivers/mmc/host/sdhci-sprd.c
index e85c95f3a868..256260339f69 100644
--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -224,13 +224,15 @@ static inline void _sdhci_sprd_set_clock(struct sdhci_host *host,
 	div = ((div & 0x300) >> 2) | ((div & 0xFF) << 8);
 	sdhci_enable_clk(host, div);
 
-	/* enable auto gate sdhc_enable_auto_gate */
-	val = sdhci_readl(host, SDHCI_SPRD_REG_32_BUSY_POSI);
-	mask = SDHCI_SPRD_BIT_OUTR_CLK_AUTO_EN |
-	       SDHCI_SPRD_BIT_INNR_CLK_AUTO_EN;
-	if (mask != (val & mask)) {
-		val |= mask;
-		sdhci_writel(host, val, SDHCI_SPRD_REG_32_BUSY_POSI);
+	/* Enable CLK_AUTO when the clock is greater than 400K. */
+	if (clk > 400000) {
+		val = sdhci_readl(host, SDHCI_SPRD_REG_32_BUSY_POSI);
+		mask = SDHCI_SPRD_BIT_OUTR_CLK_AUTO_EN |
+			SDHCI_SPRD_BIT_INNR_CLK_AUTO_EN;
+		if (mask != (val & mask)) {
+			val |= mask;
+			sdhci_writel(host, val, SDHCI_SPRD_REG_32_BUSY_POSI);
+		}
 	}
 }
 
diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index ab36ec479747..72f65f32abbc 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2049,6 +2049,7 @@ static void vub300_enable_sdio_irq(struct mmc_host *mmc, int enable)
 		return;
 	kref_get(&vub300->kref);
 	if (enable) {
+		set_current_state(TASK_RUNNING);
 		mutex_lock(&vub300->irq_mutex);
 		if (vub300->irqs_queued) {
 			vub300->irqs_queued -= 1;
@@ -2064,6 +2065,7 @@ static void vub300_enable_sdio_irq(struct mmc_host *mmc, int enable)
 			vub300_queue_poll_work(vub300, 0);
 		}
 		mutex_unlock(&vub300->irq_mutex);
+		set_current_state(TASK_INTERRUPTIBLE);
 	} else {
 		vub300->irq_enabled = 0;
 	}
diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index aad7076ae020..d5dcc74a625e 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1409,6 +1409,8 @@ spi_nor_find_best_erase_type(const struct spi_nor_erase_map *map,
 			continue;
 
 		erase = &map->erase_type[i];
+		if (!erase->size)
+			continue;
 
 		/* Alignment is not mandatory for overlaid regions */
 		if (region->offset & SNOR_OVERLAID_REGION &&
diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index 8ad095c19f27..ff6d4e74a186 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1539,6 +1539,7 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
 			slave_err(bond->dev, port->slave->dev,
 				  "Port %d did not find a suitable aggregator\n",
 				  port->actor_port_number);
+			return;
 		}
 	}
 	/* if all aggregator's ports are READY_N == TRUE, set ready=TRUE
diff --git a/drivers/net/dsa/mv88e6xxx/Kconfig b/drivers/net/dsa/mv88e6xxx/Kconfig
index 7a2445a34eb7..e3181d5471df 100644
--- a/drivers/net/dsa/mv88e6xxx/Kconfig
+++ b/drivers/net/dsa/mv88e6xxx/Kconfig
@@ -2,7 +2,6 @@
 config NET_DSA_MV88E6XXX
 	tristate "Marvell 88E6xxx Ethernet switch fabric support"
 	depends on NET_DSA
-	depends on PTP_1588_CLOCK_OPTIONAL
 	select IRQ_DOMAIN
 	select NET_DSA_TAG_EDSA
 	select NET_DSA_TAG_DSA
@@ -13,7 +12,8 @@ config NET_DSA_MV88E6XXX
 config NET_DSA_MV88E6XXX_PTP
 	bool "PTP support for Marvell 88E6xxx"
 	default n
-	depends on NET_DSA_MV88E6XXX && PTP_1588_CLOCK
+	depends on (NET_DSA_MV88E6XXX = y && PTP_1588_CLOCK = y) || \
+	           (NET_DSA_MV88E6XXX = m && PTP_1588_CLOCK)
 	help
 	  Say Y to enable PTP hardware timestamping on Marvell 88E6xxx switch
 	  chips that support it.
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index ab413fc1f68e..f0faad149a3b 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2392,29 +2392,18 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 		return -EOPNOTSUPP;
 	}
 
-	switch (func) {
-	case ENA_ADMIN_TOEPLITZ:
-		if (key) {
-			if (key_len != sizeof(hash_key->key)) {
-				netdev_err(ena_dev->net_device,
-					   "key len (%u) doesn't equal the supported size (%zu)\n",
-					   key_len, sizeof(hash_key->key));
-				return -EINVAL;
-			}
-			memcpy(hash_key->key, key, key_len);
-			rss->hash_init_val = init_val;
-			hash_key->key_parts = key_len / sizeof(hash_key->key[0]);
+	if ((func == ENA_ADMIN_TOEPLITZ) && key) {
+		if (key_len != sizeof(hash_key->key)) {
+			netdev_err(ena_dev->net_device,
+				   "key len (%u) doesn't equal the supported size (%zu)\n",
+				   key_len, sizeof(hash_key->key));
+			return -EINVAL;
 		}
-		break;
-	case ENA_ADMIN_CRC32:
-		rss->hash_init_val = init_val;
-		break;
-	default:
-		netdev_err(ena_dev->net_device, "Invalid hash function (%d)\n",
-			   func);
-		return -EINVAL;
+		memcpy(hash_key->key, key, key_len);
+		hash_key->key_parts = key_len / sizeof(hash_key->key[0]);
 	}
 
+	rss->hash_init_val = init_val;
 	old_func = rss->hash_func;
 	rss->hash_func = func;
 	rc = ena_com_set_hash_function(ena_dev);
diff --git a/drivers/net/ethernet/amazon/ena/ena_ethtool.c b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
index 13e745cf3781..413082f10dc1 100644
--- a/drivers/net/ethernet/amazon/ena/ena_ethtool.c
+++ b/drivers/net/ethernet/amazon/ena/ena_ethtool.c
@@ -880,11 +880,7 @@ static int ena_set_tunable(struct net_device *netdev,
 	switch (tuna->id) {
 	case ETHTOOL_RX_COPYBREAK:
 		len = *(u32 *)data;
-		if (len > adapter->netdev->mtu) {
-			ret = -EINVAL;
-			break;
-		}
-		adapter->rx_copybreak = len;
+		ret = ena_set_rx_copybreak(adapter, len);
 		break;
 	default:
 		ret = -EINVAL;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index f032e58a4c3c..23c9750850e9 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -378,9 +378,9 @@ static int ena_xdp_xmit(struct net_device *dev, int n,
 
 static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 {
+	u32 verdict = ENA_XDP_PASS;
 	struct bpf_prog *xdp_prog;
 	struct ena_ring *xdp_ring;
-	u32 verdict = XDP_PASS;
 	struct xdp_frame *xdpf;
 	u64 *xdp_stat;
 
@@ -397,7 +397,7 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 		if (unlikely(!xdpf)) {
 			trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
 			xdp_stat = &rx_ring->rx_stats.xdp_aborted;
-			verdict = XDP_ABORTED;
+			verdict = ENA_XDP_DROP;
 			break;
 		}
 
@@ -413,29 +413,35 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 
 		spin_unlock(&xdp_ring->xdp_tx_lock);
 		xdp_stat = &rx_ring->rx_stats.xdp_tx;
+		verdict = ENA_XDP_TX;
 		break;
 	case XDP_REDIRECT:
 		if (likely(!xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog))) {
 			xdp_stat = &rx_ring->rx_stats.xdp_redirect;
+			verdict = ENA_XDP_REDIRECT;
 			break;
 		}
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
 		xdp_stat = &rx_ring->rx_stats.xdp_aborted;
-		verdict = XDP_ABORTED;
+		verdict = ENA_XDP_DROP;
 		break;
 	case XDP_ABORTED:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, verdict);
 		xdp_stat = &rx_ring->rx_stats.xdp_aborted;
+		verdict = ENA_XDP_DROP;
 		break;
 	case XDP_DROP:
 		xdp_stat = &rx_ring->rx_stats.xdp_drop;
+		verdict = ENA_XDP_DROP;
 		break;
 	case XDP_PASS:
 		xdp_stat = &rx_ring->rx_stats.xdp_pass;
+		verdict = ENA_XDP_PASS;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(verdict);
 		xdp_stat = &rx_ring->rx_stats.xdp_invalid;
+		verdict = ENA_XDP_DROP;
 	}
 
 	ena_increase_stat(xdp_stat, 1, &rx_ring->syncp);
@@ -516,16 +522,18 @@ static void ena_xdp_exchange_program_rx_in_range(struct ena_adapter *adapter,
 						 struct bpf_prog *prog,
 						 int first, int count)
 {
+	struct bpf_prog *old_bpf_prog;
 	struct ena_ring *rx_ring;
 	int i = 0;
 
 	for (i = first; i < count; i++) {
 		rx_ring = &adapter->rx_ring[i];
-		xchg(&rx_ring->xdp_bpf_prog, prog);
-		if (prog) {
+		old_bpf_prog = xchg(&rx_ring->xdp_bpf_prog, prog);
+
+		if (!old_bpf_prog && prog) {
 			ena_xdp_register_rxq_info(rx_ring);
 			rx_ring->rx_headroom = XDP_PACKET_HEADROOM;
-		} else {
+		} else if (old_bpf_prog && !prog) {
 			ena_xdp_unregister_rxq_info(rx_ring);
 			rx_ring->rx_headroom = NET_SKB_PAD;
 		}
@@ -676,6 +684,7 @@ static void ena_init_io_rings_common(struct ena_adapter *adapter,
 	ring->ena_dev = adapter->ena_dev;
 	ring->per_napi_packets = 0;
 	ring->cpu = 0;
+	ring->numa_node = 0;
 	ring->no_interrupt_event_cnt = 0;
 	u64_stats_init(&ring->syncp);
 }
@@ -779,6 +788,7 @@ static int ena_setup_tx_resources(struct ena_adapter *adapter, int qid)
 	tx_ring->next_to_use = 0;
 	tx_ring->next_to_clean = 0;
 	tx_ring->cpu = ena_irq->cpu;
+	tx_ring->numa_node = node;
 	return 0;
 
 err_push_buf_intermediate_buf:
@@ -911,6 +921,7 @@ static int ena_setup_rx_resources(struct ena_adapter *adapter,
 	rx_ring->next_to_clean = 0;
 	rx_ring->next_to_use = 0;
 	rx_ring->cpu = ena_irq->cpu;
+	rx_ring->numa_node = node;
 
 	return 0;
 }
@@ -1629,12 +1640,12 @@ static int ena_xdp_handle_buff(struct ena_ring *rx_ring, struct xdp_buff *xdp)
 	 * we expect, then we simply drop it
 	 */
 	if (unlikely(rx_ring->ena_bufs[0].len > ENA_XDP_MAX_MTU))
-		return XDP_DROP;
+		return ENA_XDP_DROP;
 
 	ret = ena_xdp_execute(rx_ring, xdp);
 
 	/* The xdp program might expand the headers */
-	if (ret == XDP_PASS) {
+	if (ret == ENA_XDP_PASS) {
 		rx_info->page_offset = xdp->data - xdp->data_hard_start;
 		rx_ring->ena_bufs[0].len = xdp->data_end - xdp->data;
 	}
@@ -1673,7 +1684,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 	xdp_init_buff(&xdp, ENA_PAGE_SIZE, &rx_ring->xdp_rxq);
 
 	do {
-		xdp_verdict = XDP_PASS;
+		xdp_verdict = ENA_XDP_PASS;
 		skb = NULL;
 		ena_rx_ctx.ena_bufs = rx_ring->ena_bufs;
 		ena_rx_ctx.max_bufs = rx_ring->sgl_size;
@@ -1701,7 +1712,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 			xdp_verdict = ena_xdp_handle_buff(rx_ring, &xdp);
 
 		/* allocate skb and fill it */
-		if (xdp_verdict == XDP_PASS)
+		if (xdp_verdict == ENA_XDP_PASS)
 			skb = ena_rx_skb(rx_ring,
 					 rx_ring->ena_bufs,
 					 ena_rx_ctx.descs,
@@ -1719,14 +1730,15 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 				/* Packets was passed for transmission, unmap it
 				 * from RX side.
 				 */
-				if (xdp_verdict == XDP_TX || xdp_verdict == XDP_REDIRECT) {
+				if (xdp_verdict & ENA_XDP_FORWARDED) {
 					ena_unmap_rx_buff(rx_ring,
 							  &rx_ring->rx_buffer_info[req_id]);
 					rx_ring->rx_buffer_info[req_id].page = NULL;
 				}
 			}
-			if (xdp_verdict != XDP_PASS) {
+			if (xdp_verdict != ENA_XDP_PASS) {
 				xdp_flags |= xdp_verdict;
+				total_len += ena_rx_ctx.ena_bufs[0].len;
 				res_budget--;
 				continue;
 			}
@@ -1770,7 +1782,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 		ena_refill_rx_bufs(rx_ring, refill_required);
 	}
 
-	if (xdp_flags & XDP_REDIRECT)
+	if (xdp_flags & ENA_XDP_REDIRECT)
 		xdp_do_flush_map();
 
 	return work_done;
@@ -1827,8 +1839,9 @@ static void ena_adjust_adaptive_rx_intr_moderation(struct ena_napi *ena_napi)
 static void ena_unmask_interrupt(struct ena_ring *tx_ring,
 					struct ena_ring *rx_ring)
 {
+	u32 rx_interval = tx_ring->smoothed_interval;
 	struct ena_eth_io_intr_reg intr_reg;
-	u32 rx_interval = 0;
+
 	/* Rx ring can be NULL when for XDP tx queues which don't have an
 	 * accompanying rx_ring pair.
 	 */
@@ -1866,20 +1879,27 @@ static void ena_update_ring_numa_node(struct ena_ring *tx_ring,
 	if (likely(tx_ring->cpu == cpu))
 		goto out;
 
+	tx_ring->cpu = cpu;
+	if (rx_ring)
+		rx_ring->cpu = cpu;
+
 	numa_node = cpu_to_node(cpu);
+
+	if (likely(tx_ring->numa_node == numa_node))
+		goto out;
+
 	put_cpu();
 
 	if (numa_node != NUMA_NO_NODE) {
 		ena_com_update_numa_node(tx_ring->ena_com_io_cq, numa_node);
-		if (rx_ring)
+		tx_ring->numa_node = numa_node;
+		if (rx_ring) {
+			rx_ring->numa_node = numa_node;
 			ena_com_update_numa_node(rx_ring->ena_com_io_cq,
 						 numa_node);
+		}
 	}
 
-	tx_ring->cpu = cpu;
-	if (rx_ring)
-		rx_ring->cpu = cpu;
-
 	return;
 out:
 	put_cpu();
@@ -2000,11 +2020,10 @@ static int ena_io_poll(struct napi_struct *napi, int budget)
 			if (ena_com_get_adaptive_moderation_enabled(rx_ring->ena_dev))
 				ena_adjust_adaptive_rx_intr_moderation(ena_napi);
 
+			ena_update_ring_numa_node(tx_ring, rx_ring);
 			ena_unmask_interrupt(tx_ring, rx_ring);
 		}
 
-		ena_update_ring_numa_node(tx_ring, rx_ring);
-
 		ret = rx_work_done;
 	} else {
 		ret = budget;
@@ -2391,7 +2410,7 @@ static int ena_create_io_tx_queue(struct ena_adapter *adapter, int qid)
 	ctx.mem_queue_type = ena_dev->tx_mem_queue_type;
 	ctx.msix_vector = msix_vector;
 	ctx.queue_size = tx_ring->ring_size;
-	ctx.numa_node = cpu_to_node(tx_ring->cpu);
+	ctx.numa_node = tx_ring->numa_node;
 
 	rc = ena_com_create_io_queue(ena_dev, &ctx);
 	if (rc) {
@@ -2459,7 +2478,7 @@ static int ena_create_io_rx_queue(struct ena_adapter *adapter, int qid)
 	ctx.mem_queue_type = ENA_ADMIN_PLACEMENT_POLICY_HOST;
 	ctx.msix_vector = msix_vector;
 	ctx.queue_size = rx_ring->ring_size;
-	ctx.numa_node = cpu_to_node(rx_ring->cpu);
+	ctx.numa_node = rx_ring->numa_node;
 
 	rc = ena_com_create_io_queue(ena_dev, &ctx);
 	if (rc) {
@@ -2820,6 +2839,24 @@ int ena_update_queue_sizes(struct ena_adapter *adapter,
 	return dev_was_up ? ena_up(adapter) : 0;
 }
 
+int ena_set_rx_copybreak(struct ena_adapter *adapter, u32 rx_copybreak)
+{
+	struct ena_ring *rx_ring;
+	int i;
+
+	if (rx_copybreak > min_t(u16, adapter->netdev->mtu, ENA_PAGE_SIZE))
+		return -EINVAL;
+
+	adapter->rx_copybreak = rx_copybreak;
+
+	for (i = 0; i < adapter->num_io_queues; i++) {
+		rx_ring = &adapter->rx_ring[i];
+		rx_ring->rx_copybreak = rx_copybreak;
+	}
+
+	return 0;
+}
+
 int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count)
 {
 	struct ena_com_dev *ena_dev = adapter->ena_dev;
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index 0c39fc2fa345..bf2a39c91c00 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -273,9 +273,11 @@ struct ena_ring {
 	bool disable_meta_caching;
 	u16 no_interrupt_event_cnt;
 
-	/* cpu for TPH */
+	/* cpu and NUMA for TPH */
 	int cpu;
-	 /* number of tx/rx_buffer_info's entries */
+	int numa_node;
+
+	/* number of tx/rx_buffer_info's entries */
 	int ring_size;
 
 	enum ena_admin_placement_policy_type tx_mem_queue_type;
@@ -404,6 +406,8 @@ int ena_update_queue_sizes(struct ena_adapter *adapter,
 
 int ena_update_queue_count(struct ena_adapter *adapter, u32 new_channel_count);
 
+int ena_set_rx_copybreak(struct ena_adapter *adapter, u32 rx_copybreak);
+
 int ena_get_sset_count(struct net_device *netdev, int sset);
 
 enum ena_xdp_errors_t {
@@ -412,6 +416,15 @@ enum ena_xdp_errors_t {
 	ENA_XDP_NO_ENOUGH_QUEUES,
 };
 
+enum ENA_XDP_ACTIONS {
+	ENA_XDP_PASS		= 0,
+	ENA_XDP_TX		= BIT(0),
+	ENA_XDP_REDIRECT	= BIT(1),
+	ENA_XDP_DROP		= BIT(2)
+};
+
+#define ENA_XDP_FORWARDED (ENA_XDP_TX | ENA_XDP_REDIRECT)
+
 static inline bool ena_xdp_present(struct ena_adapter *adapter)
 {
 	return !!adapter->xdp_bpf_prog;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index e6883d52d230..555db1871ec9 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1064,6 +1064,9 @@ static void xgbe_free_irqs(struct xgbe_prv_data *pdata)
 
 	devm_free_irq(pdata->dev, pdata->dev_irq, pdata);
 
+	tasklet_kill(&pdata->tasklet_dev);
+	tasklet_kill(&pdata->tasklet_ecc);
+
 	if (pdata->vdata->ecc_support && (pdata->dev_irq != pdata->ecc_irq))
 		devm_free_irq(pdata->dev, pdata->ecc_irq, pdata);
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c b/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
index 22d4fc547a0a..a9ccc4258ee5 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
@@ -447,8 +447,10 @@ static void xgbe_i2c_stop(struct xgbe_prv_data *pdata)
 	xgbe_i2c_disable(pdata);
 	xgbe_i2c_clear_all_interrupts(pdata);
 
-	if (pdata->dev_irq != pdata->i2c_irq)
+	if (pdata->dev_irq != pdata->i2c_irq) {
 		devm_free_irq(pdata->dev, pdata->i2c_irq, pdata);
+		tasklet_kill(&pdata->tasklet_i2c);
+	}
 }
 
 static int xgbe_i2c_start(struct xgbe_prv_data *pdata)
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 4e97b4869522..0c5c1b155683 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1390,8 +1390,10 @@ static void xgbe_phy_stop(struct xgbe_prv_data *pdata)
 	/* Disable auto-negotiation */
 	xgbe_an_disable_all(pdata);
 
-	if (pdata->dev_irq != pdata->an_irq)
+	if (pdata->dev_irq != pdata->an_irq) {
 		devm_free_irq(pdata->dev, pdata->an_irq, pdata);
+		tasklet_kill(&pdata->tasklet_an);
+	}
 
 	pdata->phy_if.phy_impl.stop(pdata);
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 818a028703c6..dc835f316d47 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1005,9 +1005,7 @@ static bool hns3_can_use_tx_bounce(struct hns3_enet_ring *ring,
 		return false;
 
 	if (ALIGN(len, dma_get_cache_alignment()) > space) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.tx_spare_full++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, tx_spare_full);
 		return false;
 	}
 
@@ -1024,9 +1022,7 @@ static bool hns3_can_use_tx_sgl(struct hns3_enet_ring *ring,
 		return false;
 
 	if (space < HNS3_MAX_SGL_SIZE) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.tx_spare_full++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, tx_spare_full);
 		return false;
 	}
 
@@ -1554,9 +1550,7 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 
 	ret = hns3_handle_vtags(ring, skb);
 	if (unlikely(ret < 0)) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.tx_vlan_err++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, tx_vlan_err);
 		return ret;
 	} else if (ret == HNS3_INNER_VLAN_TAG) {
 		inner_vtag = skb_vlan_tag_get(skb);
@@ -1591,9 +1585,7 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 
 		ret = hns3_get_l4_protocol(skb, &ol4_proto, &il4_proto);
 		if (unlikely(ret < 0)) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.tx_l4_proto_err++;
-			u64_stats_update_end(&ring->syncp);
+			hns3_ring_stats_update(ring, tx_l4_proto_err);
 			return ret;
 		}
 
@@ -1601,18 +1593,14 @@ static int hns3_fill_skb_desc(struct hns3_enet_ring *ring,
 				      &type_cs_vlan_tso,
 				      &ol_type_vlan_len_msec);
 		if (unlikely(ret < 0)) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.tx_l2l3l4_err++;
-			u64_stats_update_end(&ring->syncp);
+			hns3_ring_stats_update(ring, tx_l2l3l4_err);
 			return ret;
 		}
 
 		ret = hns3_set_tso(skb, &paylen_ol4cs, &mss_hw_csum,
 				   &type_cs_vlan_tso, &desc_cb->send_bytes);
 		if (unlikely(ret < 0)) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.tx_tso_err++;
-			u64_stats_update_end(&ring->syncp);
+			hns3_ring_stats_update(ring, tx_tso_err);
 			return ret;
 		}
 	}
@@ -1705,9 +1693,7 @@ static int hns3_map_and_fill_desc(struct hns3_enet_ring *ring, void *priv,
 	}
 
 	if (unlikely(dma_mapping_error(dev, dma))) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.sw_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, sw_err_cnt);
 		return -ENOMEM;
 	}
 
@@ -1853,9 +1839,7 @@ static int hns3_skb_linearize(struct hns3_enet_ring *ring,
 	 * recursion level of over HNS3_MAX_RECURSION_LEVEL.
 	 */
 	if (bd_num == UINT_MAX) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.over_max_recursion++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, over_max_recursion);
 		return -ENOMEM;
 	}
 
@@ -1864,16 +1848,12 @@ static int hns3_skb_linearize(struct hns3_enet_ring *ring,
 	 */
 	if (skb->len > HNS3_MAX_TSO_SIZE ||
 	    (!skb_is_gso(skb) && skb->len > HNS3_MAX_NON_TSO_SIZE)) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.hw_limitation++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, hw_limitation);
 		return -ENOMEM;
 	}
 
 	if (__skb_linearize(skb)) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.sw_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, sw_err_cnt);
 		return -ENOMEM;
 	}
 
@@ -1903,9 +1883,7 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 
 		bd_num = hns3_tx_bd_count(skb->len);
 
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.tx_copy++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, tx_copy);
 	}
 
 out:
@@ -1925,9 +1903,7 @@ static int hns3_nic_maybe_stop_tx(struct hns3_enet_ring *ring,
 		return bd_num;
 	}
 
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.tx_busy++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, tx_busy);
 
 	return -EBUSY;
 }
@@ -2012,9 +1988,7 @@ static void hns3_tx_doorbell(struct hns3_enet_ring *ring, int num,
 	ring->pending_buf += num;
 
 	if (!doorbell) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.tx_more++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, tx_more);
 		return;
 	}
 
@@ -2064,9 +2038,7 @@ static int hns3_handle_tx_bounce(struct hns3_enet_ring *ring,
 	ret = skb_copy_bits(skb, 0, buf, size);
 	if (unlikely(ret < 0)) {
 		hns3_tx_spare_rollback(ring, cb_len);
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.copy_bits_err++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, copy_bits_err);
 		return ret;
 	}
 
@@ -2089,9 +2061,8 @@ static int hns3_handle_tx_bounce(struct hns3_enet_ring *ring,
 	dma_sync_single_for_device(ring_to_dev(ring), dma, size,
 				   DMA_TO_DEVICE);
 
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.tx_bounce++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, tx_bounce);
+
 	return bd_num;
 }
 
@@ -2121,9 +2092,7 @@ static int hns3_handle_tx_sgl(struct hns3_enet_ring *ring,
 	nents = skb_to_sgvec(skb, sgt->sgl, 0, skb->len);
 	if (unlikely(nents < 0)) {
 		hns3_tx_spare_rollback(ring, cb_len);
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.skb2sgl_err++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, skb2sgl_err);
 		return -ENOMEM;
 	}
 
@@ -2132,9 +2101,7 @@ static int hns3_handle_tx_sgl(struct hns3_enet_ring *ring,
 				DMA_TO_DEVICE);
 	if (unlikely(!sgt->nents)) {
 		hns3_tx_spare_rollback(ring, cb_len);
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.map_sg_err++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, map_sg_err);
 		return -ENOMEM;
 	}
 
@@ -2146,10 +2113,7 @@ static int hns3_handle_tx_sgl(struct hns3_enet_ring *ring,
 	for (i = 0; i < sgt->nents; i++)
 		bd_num += hns3_fill_desc(ring, sg_dma_address(sgt->sgl + i),
 					 sg_dma_len(sgt->sgl + i));
-
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.tx_sgl++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, tx_sgl);
 
 	return bd_num;
 }
@@ -2188,9 +2152,7 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	if (skb_put_padto(skb, HNS3_MIN_TX_LEN)) {
 		hns3_tx_doorbell(ring, 0, !netdev_xmit_more());
 
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.sw_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, sw_err_cnt);
 
 		return NETDEV_TX_OK;
 	}
@@ -3522,17 +3484,13 @@ static bool hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 	for (i = 0; i < cleand_count; i++) {
 		desc_cb = &ring->desc_cb[ring->next_to_use];
 		if (desc_cb->reuse_flag) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.reuse_pg_cnt++;
-			u64_stats_update_end(&ring->syncp);
+			hns3_ring_stats_update(ring, reuse_pg_cnt);
 
 			hns3_reuse_buffer(ring, ring->next_to_use);
 		} else {
 			ret = hns3_alloc_and_map_buffer(ring, &res_cbs);
 			if (ret) {
-				u64_stats_update_begin(&ring->syncp);
-				ring->stats.sw_err_cnt++;
-				u64_stats_update_end(&ring->syncp);
+				hns3_ring_stats_update(ring, sw_err_cnt);
 
 				hns3_rl_err(ring_to_netdev(ring),
 					    "alloc rx buffer failed: %d\n",
@@ -3544,9 +3502,7 @@ static bool hns3_nic_alloc_rx_buffers(struct hns3_enet_ring *ring,
 			}
 			hns3_replace_buffer(ring, ring->next_to_use, &res_cbs);
 
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.non_reuse_pg++;
-			u64_stats_update_end(&ring->syncp);
+			hns3_ring_stats_update(ring, non_reuse_pg);
 		}
 
 		ring_ptr_move_fw(ring, next_to_use);
@@ -3561,6 +3517,34 @@ static bool hns3_can_reuse_page(struct hns3_desc_cb *cb)
 	return page_count(cb->priv) == cb->pagecnt_bias;
 }
 
+static int hns3_handle_rx_copybreak(struct sk_buff *skb, int i,
+				    struct hns3_enet_ring *ring,
+				    int pull_len,
+				    struct hns3_desc_cb *desc_cb)
+{
+	struct hns3_desc *desc = &ring->desc[ring->next_to_clean];
+	u32 frag_offset = desc_cb->page_offset + pull_len;
+	int size = le16_to_cpu(desc->rx.size);
+	u32 frag_size = size - pull_len;
+	void *frag = napi_alloc_frag(frag_size);
+
+	if (unlikely(!frag)) {
+		hns3_ring_stats_update(ring, frag_alloc_err);
+
+		hns3_rl_err(ring_to_netdev(ring),
+			    "failed to allocate rx frag\n");
+		return -ENOMEM;
+	}
+
+	desc_cb->reuse_flag = 1;
+	memcpy(frag, desc_cb->buf + frag_offset, frag_size);
+	skb_add_rx_frag(skb, i, virt_to_page(frag),
+			offset_in_page(frag), frag_size, frag_size);
+
+	hns3_ring_stats_update(ring, frag_alloc);
+	return 0;
+}
+
 static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 				struct hns3_enet_ring *ring, int pull_len,
 				struct hns3_desc_cb *desc_cb)
@@ -3570,6 +3554,7 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 	int size = le16_to_cpu(desc->rx.size);
 	u32 truesize = hns3_buf_size(ring);
 	u32 frag_size = size - pull_len;
+	int ret = 0;
 	bool reused;
 
 	if (ring->page_pool) {
@@ -3604,27 +3589,9 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 		desc_cb->page_offset = 0;
 		desc_cb->reuse_flag = 1;
 	} else if (frag_size <= ring->rx_copybreak) {
-		void *frag = napi_alloc_frag(frag_size);
-
-		if (unlikely(!frag)) {
-			u64_stats_update_begin(&ring->syncp);
-			ring->stats.frag_alloc_err++;
-			u64_stats_update_end(&ring->syncp);
-
-			hns3_rl_err(ring_to_netdev(ring),
-				    "failed to allocate rx frag\n");
-			goto out;
-		}
-
-		desc_cb->reuse_flag = 1;
-		memcpy(frag, desc_cb->buf + frag_offset, frag_size);
-		skb_add_rx_frag(skb, i, virt_to_page(frag),
-				offset_in_page(frag), frag_size, frag_size);
-
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.frag_alloc++;
-		u64_stats_update_end(&ring->syncp);
-		return;
+		ret = hns3_handle_rx_copybreak(skb, i, ring, pull_len, desc_cb);
+		if (!ret)
+			return;
 	}
 
 out:
@@ -3700,20 +3667,16 @@ static int hns3_gro_complete(struct sk_buff *skb, u32 l234info)
 	return 0;
 }
 
-static bool hns3_checksum_complete(struct hns3_enet_ring *ring,
+static void hns3_checksum_complete(struct hns3_enet_ring *ring,
 				   struct sk_buff *skb, u32 ptype, u16 csum)
 {
 	if (ptype == HNS3_INVALID_PTYPE ||
 	    hns3_rx_ptype_tbl[ptype].ip_summed != CHECKSUM_COMPLETE)
-		return false;
+		return;
 
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.csum_complete++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, csum_complete);
 	skb->ip_summed = CHECKSUM_COMPLETE;
 	skb->csum = csum_unfold((__force __sum16)csum);
-
-	return true;
 }
 
 static void hns3_rx_handle_csum(struct sk_buff *skb, u32 l234info,
@@ -3773,8 +3736,7 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 		ptype = hnae3_get_field(ol_info, HNS3_RXD_PTYPE_M,
 					HNS3_RXD_PTYPE_S);
 
-	if (hns3_checksum_complete(ring, skb, ptype, csum))
-		return;
+	hns3_checksum_complete(ring, skb, ptype, csum);
 
 	/* check if hardware has done checksum */
 	if (!(bd_base_info & BIT(HNS3_RXD_L3L4P_B)))
@@ -3783,9 +3745,8 @@ static void hns3_rx_checksum(struct hns3_enet_ring *ring, struct sk_buff *skb,
 	if (unlikely(l234info & (BIT(HNS3_RXD_L3E_B) | BIT(HNS3_RXD_L4E_B) |
 				 BIT(HNS3_RXD_OL3E_B) |
 				 BIT(HNS3_RXD_OL4E_B)))) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.l3l4_csum_err++;
-		u64_stats_update_end(&ring->syncp);
+		skb->ip_summed = CHECKSUM_NONE;
+		hns3_ring_stats_update(ring, l3l4_csum_err);
 
 		return;
 	}
@@ -3876,10 +3837,7 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 	skb = ring->skb;
 	if (unlikely(!skb)) {
 		hns3_rl_err(netdev, "alloc rx skb fail\n");
-
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.sw_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, sw_err_cnt);
 
 		return -ENOMEM;
 	}
@@ -3910,9 +3868,7 @@ static int hns3_alloc_skb(struct hns3_enet_ring *ring, unsigned int length,
 	if (ring->page_pool)
 		skb_mark_for_recycle(skb);
 
-	u64_stats_update_begin(&ring->syncp);
-	ring->stats.seg_pkt_cnt++;
-	u64_stats_update_end(&ring->syncp);
+	hns3_ring_stats_update(ring, seg_pkt_cnt);
 
 	ring->pull_len = eth_get_headlen(netdev, va, HNS3_RX_HEAD_SIZE);
 	__skb_put(skb, ring->pull_len);
@@ -4104,9 +4060,7 @@ static int hns3_handle_bdinfo(struct hns3_enet_ring *ring, struct sk_buff *skb)
 	ret = hns3_set_gro_and_checksum(ring, skb, l234info,
 					bd_base_info, ol_info, csum);
 	if (unlikely(ret)) {
-		u64_stats_update_begin(&ring->syncp);
-		ring->stats.rx_err_cnt++;
-		u64_stats_update_end(&ring->syncp);
+		hns3_ring_stats_update(ring, rx_err_cnt);
 		return ret;
 	}
 
@@ -5318,9 +5272,7 @@ static int hns3_clear_rx_ring(struct hns3_enet_ring *ring)
 		if (!ring->desc_cb[ring->next_to_use].reuse_flag) {
 			ret = hns3_alloc_and_map_buffer(ring, &res_cbs);
 			if (ret) {
-				u64_stats_update_begin(&ring->syncp);
-				ring->stats.sw_err_cnt++;
-				u64_stats_update_end(&ring->syncp);
+				hns3_ring_stats_update(ring, sw_err_cnt);
 				/* if alloc new buffer fail, exit directly
 				 * and reclear in up flow.
 				 */
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index f09a61d9c626..91b656adaacb 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -654,6 +654,13 @@ static inline bool hns3_nic_resetting(struct net_device *netdev)
 
 #define hns3_buf_size(_ring) ((_ring)->buf_size)
 
+#define hns3_ring_stats_update(ring, cnt) do { \
+	typeof(ring) (tmp) = (ring); \
+	u64_stats_update_begin(&(tmp)->syncp); \
+	((tmp)->stats.cnt)++; \
+	u64_stats_update_end(&(tmp)->syncp); \
+} while (0) \
+
 static inline unsigned int hns3_page_order(struct hns3_enet_ring *ring)
 {
 #if (PAGE_SIZE < 8192)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 2102b38b9c35..f4d58fcdba27 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -12825,60 +12825,71 @@ static int hclge_gro_en(struct hnae3_handle *handle, bool enable)
 	return ret;
 }
 
-static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
+static int hclge_sync_vport_promisc_mode(struct hclge_vport *vport)
 {
-	struct hclge_vport *vport = &hdev->vport[0];
 	struct hnae3_handle *handle = &vport->nic;
+	struct hclge_dev *hdev = vport->back;
+	bool uc_en = false;
+	bool mc_en = false;
 	u8 tmp_flags;
+	bool bc_en;
 	int ret;
-	u16 i;
 
 	if (vport->last_promisc_flags != vport->overflow_promisc_flags) {
 		set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state);
 		vport->last_promisc_flags = vport->overflow_promisc_flags;
 	}
 
-	if (test_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state)) {
+	if (!test_and_clear_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
+				&vport->state))
+		return 0;
+
+	/* for PF */
+	if (!vport->vport_id) {
 		tmp_flags = handle->netdev_flags | vport->last_promisc_flags;
 		ret = hclge_set_promisc_mode(handle, tmp_flags & HNAE3_UPE,
 					     tmp_flags & HNAE3_MPE);
-		if (!ret) {
-			clear_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
-				  &vport->state);
+		if (!ret)
 			set_bit(HCLGE_VPORT_STATE_VLAN_FLTR_CHANGE,
 				&vport->state);
-		}
+		else
+			set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
+				&vport->state);
+		return ret;
 	}
 
-	for (i = 1; i < hdev->num_alloc_vport; i++) {
-		bool uc_en = false;
-		bool mc_en = false;
-		bool bc_en;
+	/* for VF */
+	if (vport->vf_info.trusted) {
+		uc_en = vport->vf_info.request_uc_en > 0 ||
+			vport->overflow_promisc_flags & HNAE3_OVERFLOW_UPE;
+		mc_en = vport->vf_info.request_mc_en > 0 ||
+			vport->overflow_promisc_flags & HNAE3_OVERFLOW_MPE;
+	}
+	bc_en = vport->vf_info.request_bc_en > 0;
 
-		vport = &hdev->vport[i];
+	ret = hclge_cmd_set_promisc_mode(hdev, vport->vport_id, uc_en,
+					 mc_en, bc_en);
+	if (ret) {
+		set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE, &vport->state);
+		return ret;
+	}
+	hclge_set_vport_vlan_fltr_change(vport);
 
-		if (!test_and_clear_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
-					&vport->state))
-			continue;
+	return 0;
+}
 
-		if (vport->vf_info.trusted) {
-			uc_en = vport->vf_info.request_uc_en > 0 ||
-				vport->overflow_promisc_flags &
-				HNAE3_OVERFLOW_UPE;
-			mc_en = vport->vf_info.request_mc_en > 0 ||
-				vport->overflow_promisc_flags &
-				HNAE3_OVERFLOW_MPE;
-		}
-		bc_en = vport->vf_info.request_bc_en > 0;
+static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
+{
+	struct hclge_vport *vport;
+	int ret;
+	u16 i;
 
-		ret = hclge_cmd_set_promisc_mode(hdev, vport->vport_id, uc_en,
-						 mc_en, bc_en);
-		if (ret) {
-			set_bit(HCLGE_VPORT_STATE_PROMISC_CHANGE,
-				&vport->state);
+	for (i = 0; i < hdev->num_alloc_vport; i++) {
+		vport = &hdev->vport[i];
+
+		ret = hclge_sync_vport_promisc_mode(vport);
+		if (ret)
 			return;
-		}
-		hclge_set_vport_vlan_fltr_change(vport);
 	}
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 21678c12afa2..3c1ff3313221 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3258,7 +3258,8 @@ static int hclgevf_pci_reset(struct hclgevf_dev *hdev)
 	struct pci_dev *pdev = hdev->pdev;
 	int ret = 0;
 
-	if (hdev->reset_type == HNAE3_VF_FULL_RESET &&
+	if ((hdev->reset_type == HNAE3_VF_FULL_RESET ||
+	     hdev->reset_type == HNAE3_FLR_RESET) &&
 	    test_bit(HCLGEVF_STATE_IRQ_INITED, &hdev->state)) {
 		hclgevf_misc_irq_uninit(hdev);
 		hclgevf_uninit_msi(hdev);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index e14624caddc6..f6306eedd59b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -962,6 +962,7 @@ static void otx2_pool_refill_task(struct work_struct *work)
 	rbpool = cq->rbpool;
 	free_ptrs = cq->pool_ptrs;
 
+	get_cpu();
 	while (cq->pool_ptrs) {
 		if (otx2_alloc_rbuf(pfvf, rbpool, &bufptr)) {
 			/* Schedule a WQ if we fails to free atleast half of the
@@ -981,6 +982,7 @@ static void otx2_pool_refill_task(struct work_struct *work)
 		pfvf->hw_ops->aura_freeptr(pfvf, qidx, bufptr + OTX2_HEAD_ROOM);
 		cq->pool_ptrs--;
 	}
+	put_cpu();
 	cq->refill_task_sched = false;
 }
 
@@ -1314,6 +1316,7 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 	if (err)
 		goto fail;
 
+	get_cpu();
 	/* Allocate pointers and free them to aura/pool */
 	for (qidx = 0; qidx < hw->tx_queues; qidx++) {
 		pool_id = otx2_get_pool_idx(pfvf, AURA_NIX_SQ, qidx);
@@ -1322,18 +1325,24 @@ int otx2_sq_aura_pool_init(struct otx2_nic *pfvf)
 		sq = &qset->sq[qidx];
 		sq->sqb_count = 0;
 		sq->sqb_ptrs = kcalloc(num_sqbs, sizeof(*sq->sqb_ptrs), GFP_KERNEL);
-		if (!sq->sqb_ptrs)
-			return -ENOMEM;
+		if (!sq->sqb_ptrs) {
+			err = -ENOMEM;
+			goto err_mem;
+		}
 
 		for (ptr = 0; ptr < num_sqbs; ptr++) {
-			if (otx2_alloc_rbuf(pfvf, pool, &bufptr))
-				return -ENOMEM;
+			err = otx2_alloc_rbuf(pfvf, pool, &bufptr);
+			if (err)
+				goto err_mem;
 			pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr);
 			sq->sqb_ptrs[sq->sqb_count++] = (u64)bufptr;
 		}
 	}
 
-	return 0;
+err_mem:
+	put_cpu();
+	return err ? -ENOMEM : 0;
+
 fail:
 	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
 	otx2_aura_pool_free(pfvf);
@@ -1372,18 +1381,21 @@ int otx2_rq_aura_pool_init(struct otx2_nic *pfvf)
 	if (err)
 		goto fail;
 
+	get_cpu();
 	/* Allocate pointers and free them to aura/pool */
 	for (pool_id = 0; pool_id < hw->rqpool_cnt; pool_id++) {
 		pool = &pfvf->qset.pool[pool_id];
 		for (ptr = 0; ptr < num_ptrs; ptr++) {
-			if (otx2_alloc_rbuf(pfvf, pool, &bufptr))
-				return -ENOMEM;
+			err = otx2_alloc_rbuf(pfvf, pool, &bufptr);
+			if (err)
+				goto err_mem;
 			pfvf->hw_ops->aura_freeptr(pfvf, pool_id,
 						   bufptr + OTX2_HEAD_ROOM);
 		}
 	}
-
-	return 0;
+err_mem:
+	put_cpu();
+	return err ? -ENOMEM : 0;
 fail:
 	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
 	otx2_aura_pool_free(pfvf);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 700c463ea367..a8d7f07ee2ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -188,12 +188,19 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 	int err;
 
 	list_for_each_entry(flow, flow_list, tmp_list) {
-		if (!mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, SLOW))
+		if (!mlx5e_is_offloaded_flow(flow))
 			continue;
 		attr = flow->attr;
 		esw_attr = attr->esw_attr;
 		spec = &attr->parse_attr->spec;
 
+		/* Clear pkt_reformat before checking slow path flag. Because
+		 * in next iteration, the same flow is already set slow path
+		 * flag, but still need to clear the pkt_reformat.
+		 */
+		if (flow_flag_test(flow, SLOW))
+			continue;
+
 		/* update from encap rule to slow path rule */
 		rule = mlx5e_tc_offload_to_slow_path(esw, flow, spec);
 		/* mark the flow's encap dest as non-valid */
@@ -1342,7 +1349,7 @@ static void mlx5e_reoffload_encap(struct mlx5e_priv *priv,
 			continue;
 		}
 
-		err = mlx5e_tc_add_flow_mod_hdr(priv, parse_attr, flow);
+		err = mlx5e_tc_add_flow_mod_hdr(priv, flow, attr);
 		if (err) {
 			mlx5_core_warn(priv->mdev, "Failed to update flow mod_hdr err=%d",
 				       err);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c1c4f380803a..be19f5cf9d15 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -977,7 +977,7 @@ static int mlx5e_alloc_xdpsq(struct mlx5e_channel *c,
 	sq->channel   = c;
 	sq->uar_map   = mdev->mlx5e_res.hw_objs.bfreg.map;
 	sq->min_inline_mode = params->tx_min_inline_mode;
-	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu);
+	sq->hw_mtu    = MLX5E_SW2HW_MTU(params, params->sw_mtu) - ETH_FCS_LEN;
 	sq->xsk_pool  = xsk_pool;
 
 	sq->stats = sq->xsk_pool ?
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 843c8435387f..8f2f99689aba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1342,10 +1342,10 @@ int mlx5e_tc_query_route_vport(struct net_device *out_dev, struct net_device *ro
 }
 
 int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
-			      struct mlx5e_tc_flow_parse_attr *parse_attr,
-			      struct mlx5e_tc_flow *flow)
+			      struct mlx5e_tc_flow *flow,
+			      struct mlx5_flow_attr *attr)
 {
-	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts = &parse_attr->mod_hdr_acts;
+	struct mlx5e_tc_mod_hdr_acts *mod_hdr_acts = &attr->parse_attr->mod_hdr_acts;
 	struct mlx5_modify_hdr *mod_hdr;
 
 	mod_hdr = mlx5_modify_header_alloc(priv->mdev,
@@ -1355,8 +1355,8 @@ int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
 	if (IS_ERR(mod_hdr))
 		return PTR_ERR(mod_hdr);
 
-	WARN_ON(flow->attr->modify_hdr);
-	flow->attr->modify_hdr = mod_hdr;
+	WARN_ON(attr->modify_hdr);
+	attr->modify_hdr = mod_hdr;
 
 	return 0;
 }
@@ -1457,7 +1457,7 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	if (attr->action & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
 	    !(attr->ct_attr.ct_action & TCA_CT_ACT_CLEAR)) {
 		if (vf_tun) {
-			err = mlx5e_tc_add_flow_mod_hdr(priv, parse_attr, flow);
+			err = mlx5e_tc_add_flow_mod_hdr(priv, flow, attr);
 			if (err)
 				goto err_out;
 		} else {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 1a4cd882f0fb..f48af82781f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -241,8 +241,8 @@ int mlx5e_tc_match_to_reg_set_and_get_id(struct mlx5_core_dev *mdev,
 					 u32 data);
 
 int mlx5e_tc_add_flow_mod_hdr(struct mlx5e_priv *priv,
-			      struct mlx5e_tc_flow_parse_attr *parse_attr,
-			      struct mlx5e_tc_flow *flow);
+			      struct mlx5e_tc_flow *flow,
+			      struct mlx5_flow_attr *attr);
 
 int alloc_mod_hdr_actions(struct mlx5_core_dev *mdev,
 			  int namespace,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
index 60a73990017c..6b4c9ffad95b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/egress_lgcy.c
@@ -67,6 +67,7 @@ static void esw_acl_egress_lgcy_groups_destroy(struct mlx5_vport *vport)
 int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 			      struct mlx5_vport *vport)
 {
+	bool vst_mode_steering = esw_vst_mode_is_steering(esw);
 	struct mlx5_flow_destination drop_ctr_dst = {};
 	struct mlx5_flow_destination *dst = NULL;
 	struct mlx5_fc *drop_counter = NULL;
@@ -77,6 +78,7 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 	 */
 	int table_size = 2;
 	int dest_num = 0;
+	int actions_flag;
 	int err = 0;
 
 	if (vport->egress.legacy.drop_counter) {
@@ -119,8 +121,11 @@ int esw_acl_egress_lgcy_setup(struct mlx5_eswitch *esw,
 		  vport->vport, vport->info.vlan, vport->info.qos);
 
 	/* Allowed vlan rule */
+	actions_flag = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+	if (vst_mode_steering)
+		actions_flag |= MLX5_FLOW_CONTEXT_ACTION_VLAN_POP;
 	err = esw_egress_acl_vlan_create(esw, vport, NULL, vport->info.vlan,
-					 MLX5_FLOW_CONTEXT_ACTION_ALLOW);
+					 actions_flag);
 	if (err)
 		goto out;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
index b1a5199260f6..093ed86a0acd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_lgcy.c
@@ -139,11 +139,14 @@ static void esw_acl_ingress_lgcy_groups_destroy(struct mlx5_vport *vport)
 int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 			       struct mlx5_vport *vport)
 {
+	bool vst_mode_steering = esw_vst_mode_is_steering(esw);
 	struct mlx5_flow_destination drop_ctr_dst = {};
 	struct mlx5_flow_destination *dst = NULL;
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_spec *spec = NULL;
 	struct mlx5_fc *counter = NULL;
+	bool vst_check_cvlan = false;
+	bool vst_push_cvlan = false;
 	/* The ingress acl table contains 4 groups
 	 * (2 active rules at the same time -
 	 *      1 allow rule from one of the first 3 groups.
@@ -203,7 +206,26 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 		goto out;
 	}
 
-	if (vport->info.vlan || vport->info.qos)
+	if ((vport->info.vlan || vport->info.qos)) {
+		if (vst_mode_steering)
+			vst_push_cvlan = true;
+		else if (!MLX5_CAP_ESW(esw->dev, vport_cvlan_insert_always))
+			vst_check_cvlan = true;
+	}
+
+	if (vst_check_cvlan || vport->info.spoofchk)
+		spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
+
+	/* Create ingress allow rule */
+	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+	if (vst_push_cvlan) {
+		flow_act.action |= MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH;
+		flow_act.vlan[0].prio = vport->info.qos;
+		flow_act.vlan[0].vid = vport->info.vlan;
+		flow_act.vlan[0].ethtype = ETH_P_8021Q;
+	}
+
+	if (vst_check_cvlan)
 		MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
 				 outer_headers.cvlan_tag);
 
@@ -218,9 +240,6 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 		ether_addr_copy(smac_v, vport->info.mac);
 	}
 
-	/* Create ingress allow rule */
-	spec->match_criteria_enable = MLX5_MATCH_OUTER_HEADERS;
-	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_ALLOW;
 	vport->ingress.allow_rule = mlx5_add_flow_rules(vport->ingress.acl, spec,
 							&flow_act, NULL, 0);
 	if (IS_ERR(vport->ingress.allow_rule)) {
@@ -232,6 +251,9 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 		goto out;
 	}
 
+	if (!vst_check_cvlan && !vport->info.spoofchk)
+		goto out;
+
 	memset(&flow_act, 0, sizeof(flow_act));
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
 	/* Attach drop flow counter */
@@ -257,7 +279,8 @@ int esw_acl_ingress_lgcy_setup(struct mlx5_eswitch *esw,
 	return 0;
 
 out:
-	esw_acl_ingress_lgcy_cleanup(esw, vport);
+	if (err)
+		esw_acl_ingress_lgcy_cleanup(esw, vport);
 	kvfree(spec);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 51a8cecc4a7c..2b9278002354 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -160,10 +160,17 @@ static int modify_esw_vport_cvlan(struct mlx5_core_dev *dev, u16 vport,
 			 esw_vport_context.vport_cvlan_strip, 1);
 
 	if (set_flags & SET_VLAN_INSERT) {
-		/* insert only if no vlan in packet */
-		MLX5_SET(modify_esw_vport_context_in, in,
-			 esw_vport_context.vport_cvlan_insert, 1);
-
+		if (MLX5_CAP_ESW(dev, vport_cvlan_insert_always)) {
+			/* insert either if vlan exist in packet or not */
+			MLX5_SET(modify_esw_vport_context_in, in,
+				 esw_vport_context.vport_cvlan_insert,
+				 MLX5_VPORT_CVLAN_INSERT_ALWAYS);
+		} else {
+			/* insert only if no vlan in packet */
+			MLX5_SET(modify_esw_vport_context_in, in,
+				 esw_vport_context.vport_cvlan_insert,
+				 MLX5_VPORT_CVLAN_INSERT_WHEN_NO_CVLAN);
+		}
 		MLX5_SET(modify_esw_vport_context_in, in,
 			 esw_vport_context.cvlan_pcp, qos);
 		MLX5_SET(modify_esw_vport_context_in, in,
@@ -773,6 +780,7 @@ static void esw_vport_cleanup_acl(struct mlx5_eswitch *esw,
 
 static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 {
+	bool vst_mode_steering = esw_vst_mode_is_steering(esw);
 	u16 vport_num = vport->vport;
 	int flags;
 	int err;
@@ -802,8 +810,9 @@ static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 
 	flags = (vport->info.vlan || vport->info.qos) ?
 		SET_VLAN_STRIP | SET_VLAN_INSERT : 0;
-	modify_esw_vport_cvlan(esw->dev, vport_num, vport->info.vlan,
-			       vport->info.qos, flags);
+	if (esw->mode == MLX5_ESWITCH_OFFLOADS || !vst_mode_steering)
+		modify_esw_vport_cvlan(esw->dev, vport_num, vport->info.vlan,
+				       vport->info.qos, flags);
 
 	return 0;
 }
@@ -1846,6 +1855,7 @@ int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 				  u16 vport, u16 vlan, u8 qos, u8 set_flags)
 {
 	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
+	bool vst_mode_steering = esw_vst_mode_is_steering(esw);
 	int err = 0;
 
 	if (IS_ERR(evport))
@@ -1853,9 +1863,11 @@ int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 	if (vlan > 4095 || qos > 7)
 		return -EINVAL;
 
-	err = modify_esw_vport_cvlan(esw->dev, vport, vlan, qos, set_flags);
-	if (err)
-		return err;
+	if (esw->mode == MLX5_ESWITCH_OFFLOADS || !vst_mode_steering) {
+		err = modify_esw_vport_cvlan(esw->dev, vport, vlan, qos, set_flags);
+		if (err)
+			return err;
+	}
 
 	evport->info.vlan = vlan;
 	evport->info.qos = qos;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 2c7444101bb9..0e2c9e6fccb6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -505,6 +505,12 @@ static inline bool mlx5_esw_qos_enabled(struct mlx5_eswitch *esw)
 	return esw->qos.enabled;
 }
 
+static inline bool esw_vst_mode_is_steering(struct mlx5_eswitch *esw)
+{
+	return (MLX5_CAP_ESW_EGRESS_ACL(esw->dev, pop_vlan) &&
+		MLX5_CAP_ESW_INGRESS_ACL(esw->dev, push_vlan));
+}
+
 static inline bool mlx5_eswitch_vlan_actions_supported(struct mlx5_core_dev *dev,
 						       u8 vlan_depth)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 037e18dd4be0..3dceab45986d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -614,6 +614,12 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 	priv = container_of(health, struct mlx5_priv, health);
 	dev = container_of(priv, struct mlx5_core_dev, priv);
 
+	mutex_lock(&dev->intf_state_mutex);
+	if (test_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags)) {
+		mlx5_core_err(dev, "health works are not permitted at this stage\n");
+		return;
+	}
+	mutex_unlock(&dev->intf_state_mutex);
 	enter_error_state(dev, false);
 	if (IS_ERR_OR_NULL(health->fw_fatal_reporter)) {
 		if (mlx5_health_try_recover(dev))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index cfde0a45b8b8..10940b8dc83e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -70,6 +70,10 @@ static void mlx5i_build_nic_params(struct mlx5_core_dev *mdev,
 	params->packet_merge.type = MLX5E_PACKET_MERGE_NONE;
 	params->hard_mtu = MLX5_IB_GRH_BYTES + MLX5_IPOIB_HARD_LEN;
 	params->tunneled_offload_en = false;
+
+	/* CQE compression is not supported for IPoIB */
+	params->rx_cqe_compress_def = false;
+	MLX5E_SET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS, params->rx_cqe_compress_def);
 }
 
 /* Called directly after IPoIB netdevice was created to initialize SW structs */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 19c11d33f4b6..145e56f5eeee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -928,6 +928,8 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 err_tables_cleanup:
 	mlx5_geneve_destroy(dev->geneve);
 	mlx5_vxlan_destroy(dev->vxlan);
+	mlx5_cleanup_clock(dev);
+	mlx5_cleanup_reserved_gids(dev);
 	mlx5_cq_debugfs_cleanup(dev);
 	mlx5_fw_reset_cleanup(dev);
 err_events_cleanup:
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 0463f20da17b..174d89ee6374 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -779,7 +779,7 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 	if (err)
 		goto cleanup_config;
 
-	if (!of_get_mac_address(np, sparx5->base_mac)) {
+	if (of_get_mac_address(np, sparx5->base_mac)) {
 		dev_info(sparx5->dev, "MAC addr was not set, use random MAC\n");
 		eth_random_addr(sparx5->base_mac);
 		sparx5->base_mac[5] = 0;
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
index 27dffa299ca6..7c3cf9ad4563 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c
@@ -2505,7 +2505,13 @@ int qlcnic_83xx_init(struct qlcnic_adapter *adapter, int pci_using_dac)
 		goto disable_mbx_intr;
 
 	qlcnic_83xx_clear_function_resources(adapter);
-	qlcnic_dcb_enable(adapter->dcb);
+
+	err = qlcnic_dcb_enable(adapter->dcb);
+	if (err) {
+		qlcnic_dcb_free(adapter->dcb);
+		goto disable_mbx_intr;
+	}
+
 	qlcnic_83xx_initialize_nic(adapter, 1);
 	qlcnic_dcb_get_info(adapter->dcb);
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
index 7519773eaca6..22afa2be85fd 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h
@@ -41,11 +41,6 @@ struct qlcnic_dcb {
 	unsigned long			state;
 };
 
-static inline void qlcnic_clear_dcb_ops(struct qlcnic_dcb *dcb)
-{
-	kfree(dcb);
-}
-
 static inline int qlcnic_dcb_get_hw_capability(struct qlcnic_dcb *dcb)
 {
 	if (dcb && dcb->ops->get_hw_capability)
@@ -112,9 +107,8 @@ static inline void qlcnic_dcb_init_dcbnl_ops(struct qlcnic_dcb *dcb)
 		dcb->ops->init_dcbnl_ops(dcb);
 }
 
-static inline void qlcnic_dcb_enable(struct qlcnic_dcb *dcb)
+static inline int qlcnic_dcb_enable(struct qlcnic_dcb *dcb)
 {
-	if (dcb && qlcnic_dcb_attach(dcb))
-		qlcnic_clear_dcb_ops(dcb);
+	return dcb ? qlcnic_dcb_attach(dcb) : 0;
 }
 #endif
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 75960a29f80e..cec07d5bbe67 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2616,7 +2616,13 @@ qlcnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			 "Device does not support MSI interrupts\n");
 
 	if (qlcnic_82xx_check(adapter)) {
-		qlcnic_dcb_enable(adapter->dcb);
+		err = qlcnic_dcb_enable(adapter->dcb);
+		if (err) {
+			qlcnic_dcb_free(adapter->dcb);
+			dev_err(&pdev->dev, "Failed to enable DCB\n");
+			goto err_out_free_hw;
+		}
+
 		qlcnic_dcb_get_info(adapter->dcb);
 		err = qlcnic_setup_intr(adapter);
 
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 77a19336abec..c89bcdd15f16 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2378,11 +2378,11 @@ static int ravb_remove(struct platform_device *pdev)
 			  priv->desc_bat_dma);
 	/* Set reset mode */
 	ravb_write(ndev, CCC_OPC_RESET, CCC);
-	pm_runtime_put_sync(&pdev->dev);
 	unregister_netdev(ndev);
 	netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
 	ravb_mdio_release(priv);
+	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	reset_control_assert(priv->rstc);
 	free_netdev(ndev);
diff --git a/drivers/net/phy/xilinx_gmii2rgmii.c b/drivers/net/phy/xilinx_gmii2rgmii.c
index 8dcb49ed1f3d..7fd9fe6a602b 100644
--- a/drivers/net/phy/xilinx_gmii2rgmii.c
+++ b/drivers/net/phy/xilinx_gmii2rgmii.c
@@ -105,6 +105,7 @@ static int xgmiitorgmii_probe(struct mdio_device *mdiodev)
 
 	if (!priv->phy_dev->drv) {
 		dev_info(dev, "Attached phy not ready\n");
+		put_device(&priv->phy_dev->mdio.dev);
 		return -EPROBE_DEFER;
 	}
 
diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index bedd36ab5cf0..e5f6614da5ac 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -255,7 +255,8 @@ static int rndis_query(struct usbnet *dev, struct usb_interface *intf,
 
 	off = le32_to_cpu(u.get_c->offset);
 	len = le32_to_cpu(u.get_c->len);
-	if (unlikely((8 + off + len) > CONTROL_BUFFER_SIZE))
+	if (unlikely((off > CONTROL_BUFFER_SIZE - 8) ||
+		     (len > CONTROL_BUFFER_SIZE - 8 - off)))
 		goto response_error;
 
 	if (*reply_len != -1 && len != *reply_len)
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 64fa8e9c0a22..41cb9179e8b7 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -916,6 +916,9 @@ static int veth_poll(struct napi_struct *napi, int budget)
 	xdp_set_return_frame_no_direct();
 	done = veth_xdp_rcv(rq, budget, &bq, &stats);
 
+	if (stats.xdp_redirect > 0)
+		xdp_do_flush();
+
 	if (done < budget && napi_complete_done(napi, done)) {
 		/* Write rx_notify_masked before reading ptr_ring */
 		smp_store_mb(rq->rx_notify_masked, false);
@@ -929,8 +932,6 @@ static int veth_poll(struct napi_struct *napi, int budget)
 
 	if (stats.xdp_tx > 0)
 		veth_xdp_flush(rq, &bq);
-	if (stats.xdp_redirect > 0)
-		xdp_do_flush();
 	xdp_clear_return_frame_no_direct();
 
 	return done;
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 21896e221300..b88092a6bc85 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1242,6 +1242,10 @@ vmxnet3_rx_csum(struct vmxnet3_adapter *adapter,
 		    (le32_to_cpu(gdesc->dword[3]) &
 		     VMXNET3_RCD_CSUM_OK) == VMXNET3_RCD_CSUM_OK) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			if ((le32_to_cpu(gdesc->dword[0]) &
+				     (1UL << VMXNET3_RCD_HDR_INNER_SHIFT))) {
+				skb->csum_level = 1;
+			}
 			WARN_ON_ONCE(!(gdesc->rcd.tcp || gdesc->rcd.udp) &&
 				     !(le32_to_cpu(gdesc->dword[0]) &
 				     (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
@@ -1251,6 +1255,10 @@ vmxnet3_rx_csum(struct vmxnet3_adapter *adapter,
 		} else if (gdesc->rcd.v6 && (le32_to_cpu(gdesc->dword[3]) &
 					     (1 << VMXNET3_RCD_TUC_SHIFT))) {
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			if ((le32_to_cpu(gdesc->dword[0]) &
+				     (1UL << VMXNET3_RCD_HDR_INNER_SHIFT))) {
+				skb->csum_level = 1;
+			}
 			WARN_ON_ONCE(!(gdesc->rcd.tcp || gdesc->rcd.udp) &&
 				     !(le32_to_cpu(gdesc->dword[0]) &
 				     (1UL << VMXNET3_RCD_HDR_INNER_SHIFT)));
diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index 6c0727fc4abd..cb4efbfd0811 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -20,6 +20,7 @@ static const struct sdio_device_id wilc_sdio_ids[] = {
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_MICROCHIP_WILC, SDIO_DEVICE_ID_MICROCHIP_WILC1000) },
 	{ },
 };
+MODULE_DEVICE_TABLE(sdio, wilc_sdio_ids);
 
 #define WILC_SDIO_BLOCK_SIZE 512
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2d5b5e0fb66a..672f53d5651a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1113,6 +1113,18 @@ static u32 nvme_known_admin_effects(u8 opcode)
 	return 0;
 }
 
+static u32 nvme_known_nvm_effects(u8 opcode)
+{
+	switch (opcode) {
+	case nvme_cmd_write:
+	case nvme_cmd_write_zeroes:
+	case nvme_cmd_write_uncor:
+		 return NVME_CMD_EFFECTS_LBCC;
+	default:
+		return 0;
+	}
+}
+
 u32 nvme_command_effects(struct nvme_ctrl *ctrl, struct nvme_ns *ns, u8 opcode)
 {
 	u32 effects = 0;
@@ -1120,16 +1132,24 @@ u32 nvme_command_effects(struct nvme_ctrl *ctrl, struct nvme_ns *ns, u8 opcode)
 	if (ns) {
 		if (ns->head->effects)
 			effects = le32_to_cpu(ns->head->effects->iocs[opcode]);
+		if (ns->head->ids.csi == NVME_CAP_CSS_NVM)
+			effects |= nvme_known_nvm_effects(opcode);
 		if (effects & ~(NVME_CMD_EFFECTS_CSUPP | NVME_CMD_EFFECTS_LBCC))
 			dev_warn_once(ctrl->device,
-				"IO command:%02x has unhandled effects:%08x\n",
+				"IO command:%02x has unusual effects:%08x\n",
 				opcode, effects);
-		return 0;
-	}
 
-	if (ctrl->effects)
-		effects = le32_to_cpu(ctrl->effects->acs[opcode]);
-	effects |= nvme_known_admin_effects(opcode);
+		/*
+		 * NVME_CMD_EFFECTS_CSE_MASK causes a freeze all I/O queues,
+		 * which would deadlock when done on an I/O command.  Note that
+		 * We already warn about an unusual effect above.
+		 */
+		effects &= ~NVME_CMD_EFFECTS_CSE_MASK;
+	} else {
+		if (ctrl->effects)
+			effects = le32_to_cpu(ctrl->effects->acs[opcode]);
+		effects |= nvme_known_admin_effects(opcode);
+	}
 
 	return effects;
 }
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 7f52b2b179b8..39ca48babbe8 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -799,7 +799,7 @@ static inline void nvme_trace_bio_complete(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
 
-	if (req->cmd_flags & REQ_NVME_MPATH)
+	if ((req->cmd_flags & REQ_NVME_MPATH) && req->bio)
 		trace_block_bio_complete(ns->head->disk->queue, req->bio);
 }
 
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d49df7123677..0165e65cf548 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -33,7 +33,7 @@
 #define SQ_SIZE(q)	((q)->q_depth << (q)->sqes)
 #define CQ_SIZE(q)	((q)->q_depth * sizeof(struct nvme_completion))
 
-#define SGES_PER_PAGE	(PAGE_SIZE / sizeof(struct nvme_sgl_desc))
+#define SGES_PER_PAGE	(NVME_CTRL_PAGE_SIZE / sizeof(struct nvme_sgl_desc))
 
 /*
  * These can be higher, but we need to ensure that any command doesn't
@@ -142,9 +142,9 @@ struct nvme_dev {
 	mempool_t *iod_mempool;
 
 	/* shadow doorbell buffer support: */
-	u32 *dbbuf_dbs;
+	__le32 *dbbuf_dbs;
 	dma_addr_t dbbuf_dbs_dma_addr;
-	u32 *dbbuf_eis;
+	__le32 *dbbuf_eis;
 	dma_addr_t dbbuf_eis_dma_addr;
 
 	/* host memory buffer support: */
@@ -208,10 +208,10 @@ struct nvme_queue {
 #define NVMEQ_SQ_CMB		1
 #define NVMEQ_DELETE_ERROR	2
 #define NVMEQ_POLLED		3
-	u32 *dbbuf_sq_db;
-	u32 *dbbuf_cq_db;
-	u32 *dbbuf_sq_ei;
-	u32 *dbbuf_cq_ei;
+	__le32 *dbbuf_sq_db;
+	__le32 *dbbuf_cq_db;
+	__le32 *dbbuf_sq_ei;
+	__le32 *dbbuf_cq_ei;
 	struct completion delete_done;
 };
 
@@ -332,11 +332,11 @@ static inline int nvme_dbbuf_need_event(u16 event_idx, u16 new_idx, u16 old)
 }
 
 /* Update dbbuf and return true if an MMIO is required */
-static bool nvme_dbbuf_update_and_check_event(u16 value, u32 *dbbuf_db,
-					      volatile u32 *dbbuf_ei)
+static bool nvme_dbbuf_update_and_check_event(u16 value, __le32 *dbbuf_db,
+					      volatile __le32 *dbbuf_ei)
 {
 	if (dbbuf_db) {
-		u16 old_value;
+		u16 old_value, event_idx;
 
 		/*
 		 * Ensure that the queue is written before updating
@@ -344,8 +344,8 @@ static bool nvme_dbbuf_update_and_check_event(u16 value, u32 *dbbuf_db,
 		 */
 		wmb();
 
-		old_value = *dbbuf_db;
-		*dbbuf_db = value;
+		old_value = le32_to_cpu(*dbbuf_db);
+		*dbbuf_db = cpu_to_le32(value);
 
 		/*
 		 * Ensure that the doorbell is updated before reading the event
@@ -355,7 +355,8 @@ static bool nvme_dbbuf_update_and_check_event(u16 value, u32 *dbbuf_db,
 		 */
 		mb();
 
-		if (!nvme_dbbuf_need_event(*dbbuf_ei, value, old_value))
+		event_idx = le32_to_cpu(*dbbuf_ei);
+		if (!nvme_dbbuf_need_event(event_idx, value, old_value))
 			return false;
 	}
 
@@ -369,9 +370,9 @@ static bool nvme_dbbuf_update_and_check_event(u16 value, u32 *dbbuf_db,
  */
 static int nvme_pci_npages_prp(void)
 {
-	unsigned nprps = DIV_ROUND_UP(NVME_MAX_KB_SZ + NVME_CTRL_PAGE_SIZE,
-				      NVME_CTRL_PAGE_SIZE);
-	return DIV_ROUND_UP(8 * nprps, PAGE_SIZE - 8);
+	unsigned max_bytes = (NVME_MAX_KB_SZ * 1024) + NVME_CTRL_PAGE_SIZE;
+	unsigned nprps = DIV_ROUND_UP(max_bytes, NVME_CTRL_PAGE_SIZE);
+	return DIV_ROUND_UP(8 * nprps, NVME_CTRL_PAGE_SIZE - 8);
 }
 
 /*
@@ -381,7 +382,7 @@ static int nvme_pci_npages_prp(void)
 static int nvme_pci_npages_sgl(void)
 {
 	return DIV_ROUND_UP(NVME_MAX_SEGS * sizeof(struct nvme_sgl_desc),
-			PAGE_SIZE);
+			NVME_CTRL_PAGE_SIZE);
 }
 
 static size_t nvme_pci_iod_alloc_size(void)
@@ -731,7 +732,7 @@ static void nvme_pci_sgl_set_seg(struct nvme_sgl_desc *sge,
 		sge->length = cpu_to_le32(entries * sizeof(*sge));
 		sge->type = NVME_SGL_FMT_LAST_SEG_DESC << 4;
 	} else {
-		sge->length = cpu_to_le32(PAGE_SIZE);
+		sge->length = cpu_to_le32(NVME_CTRL_PAGE_SIZE);
 		sge->type = NVME_SGL_FMT_SEG_DESC << 4;
 	}
 }
diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 52bb262d267a..bf78c58ed41d 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -164,26 +164,29 @@ static void nvmet_execute_get_log_page_smart(struct nvmet_req *req)
 
 static void nvmet_get_cmd_effects_nvm(struct nvme_effects_log *log)
 {
-	log->acs[nvme_admin_get_log_page]	= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_identify]		= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_abort_cmd]		= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_set_features]	= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_get_features]	= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_async_event]	= cpu_to_le32(1 << 0);
-	log->acs[nvme_admin_keep_alive]		= cpu_to_le32(1 << 0);
-
-	log->iocs[nvme_cmd_read]		= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_write]		= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_flush]		= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_dsm]			= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_write_zeroes]	= cpu_to_le32(1 << 0);
+	log->acs[nvme_admin_get_log_page] =
+	log->acs[nvme_admin_identify] =
+	log->acs[nvme_admin_abort_cmd] =
+	log->acs[nvme_admin_set_features] =
+	log->acs[nvme_admin_get_features] =
+	log->acs[nvme_admin_async_event] =
+	log->acs[nvme_admin_keep_alive] =
+		cpu_to_le32(NVME_CMD_EFFECTS_CSUPP);
+
+	log->iocs[nvme_cmd_read] =
+	log->iocs[nvme_cmd_write] =
+	log->iocs[nvme_cmd_flush] =
+	log->iocs[nvme_cmd_dsm]	=
+	log->iocs[nvme_cmd_write_zeroes] =
+		cpu_to_le32(NVME_CMD_EFFECTS_CSUPP);
 }
 
 static void nvmet_get_cmd_effects_zns(struct nvme_effects_log *log)
 {
-	log->iocs[nvme_cmd_zone_append]		= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_zone_mgmt_send]	= cpu_to_le32(1 << 0);
-	log->iocs[nvme_cmd_zone_mgmt_recv]	= cpu_to_le32(1 << 0);
+	log->iocs[nvme_cmd_zone_append] =
+	log->iocs[nvme_cmd_zone_mgmt_send] =
+	log->iocs[nvme_cmd_zone_mgmt_recv] =
+		cpu_to_le32(NVME_CMD_EFFECTS_CSUPP);
 }
 
 static void nvmet_execute_get_log_cmd_effects_ns(struct nvmet_req *req)
diff --git a/drivers/nvme/target/passthru.c b/drivers/nvme/target/passthru.c
index 6220e1dd961a..9b5929754195 100644
--- a/drivers/nvme/target/passthru.c
+++ b/drivers/nvme/target/passthru.c
@@ -271,14 +271,13 @@ static void nvmet_passthru_execute_cmd(struct nvmet_req *req)
 	}
 
 	/*
-	 * If there are effects for the command we are about to execute, or
-	 * an end_req function we need to use nvme_execute_passthru_rq()
-	 * synchronously in a work item seeing the end_req function and
-	 * nvme_passthru_end() can't be called in the request done callback
-	 * which is typically in interrupt context.
+	 * If a command needs post-execution fixups, or there are any
+	 * non-trivial effects, make sure to execute the command synchronously
+	 * in a workqueue so that nvme_passthru_end gets called.
 	 */
 	effects = nvme_command_effects(ctrl, ns, req->cmd->common.opcode);
-	if (req->p.use_workqueue || effects) {
+	if (req->p.use_workqueue ||
+	    (effects & ~(NVME_CMD_EFFECTS_CSUPP | NVME_CMD_EFFECTS_LBCC))) {
 		INIT_WORK(&req->p.work, nvmet_passthru_execute_cmd_work);
 		req->p.rq = rq;
 		queue_work(nvmet_wq, &req->p.work);
diff --git a/drivers/of/kexec.c b/drivers/of/kexec.c
index 8f9dba11873c..52bb68fb2216 100644
--- a/drivers/of/kexec.c
+++ b/drivers/of/kexec.c
@@ -284,7 +284,7 @@ void *of_kexec_alloc_and_setup_fdt(const struct kimage *image,
 				   const char *cmdline, size_t extra_fdt_size)
 {
 	void *fdt;
-	int ret, chosen_node;
+	int ret, chosen_node, len;
 	const void *prop;
 	size_t fdt_size;
 
@@ -327,19 +327,19 @@ void *of_kexec_alloc_and_setup_fdt(const struct kimage *image,
 		goto out;
 
 	/* Did we boot using an initrd? */
-	prop = fdt_getprop(fdt, chosen_node, "linux,initrd-start", NULL);
+	prop = fdt_getprop(fdt, chosen_node, "linux,initrd-start", &len);
 	if (prop) {
 		u64 tmp_start, tmp_end, tmp_size;
 
-		tmp_start = fdt64_to_cpu(*((const fdt64_t *) prop));
+		tmp_start = of_read_number(prop, len / 4);
 
-		prop = fdt_getprop(fdt, chosen_node, "linux,initrd-end", NULL);
+		prop = fdt_getprop(fdt, chosen_node, "linux,initrd-end", &len);
 		if (!prop) {
 			ret = -EINVAL;
 			goto out;
 		}
 
-		tmp_end = fdt64_to_cpu(*((const fdt64_t *) prop));
+		tmp_end = of_read_number(prop, len / 4);
 
 		/*
 		 * kexec reserves exact initrd size, while firmware may
diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index cf91cb024be3..4c0551f89c44 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -137,6 +137,9 @@ static int start_task(void)
 
 	/* Create the work queue and queue the LED task */
 	led_wq = create_singlethread_workqueue("led_wq");	
+	if (!led_wq)
+		return -ENOMEM;
+
 	queue_delayed_work(led_wq, &led_task, 0);
 
 	return 0;
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 7fb5cd17cc98..f2909ae93f2f 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1179,11 +1179,9 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 
 	sysfs_bin_attr_init(res_attr);
 	if (write_combine) {
-		pdev->res_attr_wc[num] = res_attr;
 		sprintf(res_attr_name, "resource%d_wc", num);
 		res_attr->mmap = pci_mmap_resource_wc;
 	} else {
-		pdev->res_attr[num] = res_attr;
 		sprintf(res_attr_name, "resource%d", num);
 		if (pci_resource_flags(pdev, num) & IORESOURCE_IO) {
 			res_attr->read = pci_read_resource_io;
@@ -1201,10 +1199,17 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 	res_attr->size = pci_resource_len(pdev, num);
 	res_attr->private = (void *)(unsigned long)num;
 	retval = sysfs_create_bin_file(&pdev->dev.kobj, res_attr);
-	if (retval)
+	if (retval) {
 		kfree(res_attr);
+		return retval;
+	}
+
+	if (write_combine)
+		pdev->res_attr_wc[num] = res_attr;
+	else
+		pdev->res_attr[num] = res_attr;
 
-	return retval;
+	return 0;
 }
 
 /**
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 2bfff2328cf8..a0c6a9eeb7c6 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6383,6 +6383,8 @@ bool pci_device_is_present(struct pci_dev *pdev)
 {
 	u32 v;
 
+	/* Check PF if pdev is a VF, since VF Vendor/Device IDs are 0xffff */
+	pdev = pci_physfn(pdev);
 	if (pci_dev_is_disconnected(pdev))
 		return false;
 	return pci_bus_read_dev_vendor_id(pdev->bus, pdev->devfn, &v, 0);
diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index ed69d455ac0e..a9687e040960 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -3417,8 +3417,8 @@ static const struct qmp_phy_cfg sc7180_dpphy_cfg = {
 
 	.clk_list		= qmp_v3_phy_clk_l,
 	.num_clks		= ARRAY_SIZE(qmp_v3_phy_clk_l),
-	.reset_list		= sc7180_usb3phy_reset_l,
-	.num_resets		= ARRAY_SIZE(sc7180_usb3phy_reset_l),
+	.reset_list		= msm8996_usb3phy_reset_l,
+	.num_resets		= ARRAY_SIZE(msm8996_usb3phy_reset_l),
 	.vreg_list		= qmp_phy_vreg_l,
 	.num_vregs		= ARRAY_SIZE(qmp_phy_vreg_l),
 	.regs			= qmp_v3_usb3phy_regs_layout,
@@ -3805,8 +3805,8 @@ static const struct qmp_phy_cfg sm8250_dpphy_cfg = {
 	.serdes_tbl_hbr3	= qmp_v4_dp_serdes_tbl_hbr3,
 	.serdes_tbl_hbr3_num	= ARRAY_SIZE(qmp_v4_dp_serdes_tbl_hbr3),
 
-	.clk_list		= qmp_v4_phy_clk_l,
-	.num_clks		= ARRAY_SIZE(qmp_v4_phy_clk_l),
+	.clk_list		= qmp_v4_sm8250_usbphy_clk_l,
+	.num_clks		= ARRAY_SIZE(qmp_v4_sm8250_usbphy_clk_l),
 	.reset_list		= msm8996_usb3phy_reset_l,
 	.num_resets		= ARRAY_SIZE(msm8996_usb3phy_reset_l),
 	.vreg_list		= qmp_phy_vreg_l,
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 775df165eb45..97e59f746126 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1955,12 +1955,18 @@ static void rproc_crash_handler_work(struct work_struct *work)
 
 	mutex_lock(&rproc->lock);
 
-	if (rproc->state == RPROC_CRASHED || rproc->state == RPROC_OFFLINE) {
+	if (rproc->state == RPROC_CRASHED) {
 		/* handle only the first crash detected */
 		mutex_unlock(&rproc->lock);
 		return;
 	}
 
+	if (rproc->state == RPROC_OFFLINE) {
+		/* Don't recover if the remote processor was stopped */
+		mutex_unlock(&rproc->lock);
+		goto out;
+	}
+
 	rproc->state = RPROC_CRASHED;
 	dev_err(dev, "handling crash #%u in %s\n", ++rproc->crash_cnt,
 		rproc->name);
@@ -1970,6 +1976,7 @@ static void rproc_crash_handler_work(struct work_struct *work)
 	if (!rproc->recovery_disabled)
 		rproc_trigger_recovery(rproc);
 
+out:
 	pm_relax(rproc->dev.parent);
 }
 
diff --git a/drivers/rtc/rtc-ds1347.c b/drivers/rtc/rtc-ds1347.c
index 157bf5209ac4..a40c1a52df65 100644
--- a/drivers/rtc/rtc-ds1347.c
+++ b/drivers/rtc/rtc-ds1347.c
@@ -112,7 +112,7 @@ static int ds1347_set_time(struct device *dev, struct rtc_time *dt)
 		return err;
 
 	century = (dt->tm_year / 100) + 19;
-	err = regmap_write(map, DS1347_CENTURY_REG, century);
+	err = regmap_write(map, DS1347_CENTURY_REG, bin2bcd(century));
 	if (err)
 		return err;
 
diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 499718e131d7..6a97e8af9390 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -63,6 +63,7 @@ config QCOM_GSBI
 config QCOM_LLCC
 	tristate "Qualcomm Technologies, Inc. LLCC driver"
 	depends on ARCH_QCOM || COMPILE_TEST
+	select REGMAP_MMIO
 	help
 	  Qualcomm Technologies, Inc. platform specific
 	  Last Level Cache Controller(LLCC) driver for platforms such as,
diff --git a/drivers/soc/ux500/ux500-soc-id.c b/drivers/soc/ux500/ux500-soc-id.c
index a9472e0e5d61..27d6e25a0115 100644
--- a/drivers/soc/ux500/ux500-soc-id.c
+++ b/drivers/soc/ux500/ux500-soc-id.c
@@ -167,20 +167,18 @@ ATTRIBUTE_GROUPS(ux500_soc);
 static const char *db8500_read_soc_id(struct device_node *backupram)
 {
 	void __iomem *base;
-	void __iomem *uid;
 	const char *retstr;
+	u32 uid[5];
 
 	base = of_iomap(backupram, 0);
 	if (!base)
 		return NULL;
-	uid = base + 0x1fc0;
+	memcpy_fromio(uid, base + 0x1fc0, sizeof(uid));
 
 	/* Throw these device-specific numbers into the entropy pool */
-	add_device_randomness(uid, 0x14);
+	add_device_randomness(uid, sizeof(uid));
 	retstr = kasprintf(GFP_KERNEL, "%08x%08x%08x%08x%08x",
-			 readl((u32 *)uid+0),
-			 readl((u32 *)uid+1), readl((u32 *)uid+2),
-			 readl((u32 *)uid+3), readl((u32 *)uid+4));
+			   uid[0], uid[1], uid[2], uid[3], uid[4]);
 	iounmap(base);
 	return retstr;
 }
diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 747983743a14..2bf534632f64 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -71,6 +71,14 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)intel_tgl_bios,
 	},
+	{
+		/* quirk used for NUC15 LAPBC710 skew */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "LAPBC710"),
+		},
+		.driver_data = (void *)intel_tgl_bios,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index bbb57b9f6e01..90e0bf8ca37d 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1065,8 +1065,8 @@ static const struct snd_soc_dai_ops intel_pcm_dai_ops = {
 	.prepare = intel_prepare,
 	.hw_free = intel_hw_free,
 	.shutdown = intel_shutdown,
-	.set_sdw_stream = intel_pcm_set_sdw_stream,
-	.get_sdw_stream = intel_get_sdw_stream,
+	.set_stream = intel_pcm_set_sdw_stream,
+	.get_stream = intel_get_sdw_stream,
 };
 
 static const struct snd_soc_dai_ops intel_pdm_dai_ops = {
@@ -1075,8 +1075,8 @@ static const struct snd_soc_dai_ops intel_pdm_dai_ops = {
 	.prepare = intel_prepare,
 	.hw_free = intel_hw_free,
 	.shutdown = intel_shutdown,
-	.set_sdw_stream = intel_pdm_set_sdw_stream,
-	.get_sdw_stream = intel_get_sdw_stream,
+	.set_stream = intel_pdm_set_sdw_stream,
+	.get_stream = intel_get_sdw_stream,
 };
 
 static const struct snd_soc_component_driver dai_component = {
diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index f88c5d451f09..500035a1fd46 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -1032,8 +1032,8 @@ static int qcom_swrm_startup(struct snd_pcm_substream *substream,
 	ctrl->sruntime[dai->id] = sruntime;
 
 	for_each_rtd_codec_dais(rtd, i, codec_dai) {
-		ret = snd_soc_dai_set_sdw_stream(codec_dai, sruntime,
-						 substream->stream);
+		ret = snd_soc_dai_set_stream(codec_dai, sruntime,
+					     substream->stream);
 		if (ret < 0 && ret != -ENOTSUPP) {
 			dev_err(dai->dev, "Failed to set sdw stream on %s\n",
 				codec_dai->name);
@@ -1059,8 +1059,8 @@ static const struct snd_soc_dai_ops qcom_swrm_pdm_dai_ops = {
 	.hw_free = qcom_swrm_hw_free,
 	.startup = qcom_swrm_startup,
 	.shutdown = qcom_swrm_shutdown,
-	.set_sdw_stream = qcom_swrm_set_sdw_stream,
-	.get_sdw_stream = qcom_swrm_get_sdw_stream,
+	.set_stream = qcom_swrm_set_sdw_stream,
+	.get_stream = qcom_swrm_get_sdw_stream,
 };
 
 static const struct snd_soc_component_driver qcom_swrm_dai_component = {
diff --git a/drivers/soundwire/stream.c b/drivers/soundwire/stream.c
index ebbe138a5626..2a900aa302a3 100644
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -1880,7 +1880,7 @@ static int set_stream(struct snd_pcm_substream *substream,
 
 	/* Set stream pointer on all DAIs */
 	for_each_rtd_dais(rtd, i, dai) {
-		ret = snd_soc_dai_set_sdw_stream(dai, sdw_stream, substream->stream);
+		ret = snd_soc_dai_set_stream(dai, sdw_stream, substream->stream);
 		if (ret < 0) {
 			dev_err(rtd->dev, "failed to set stream pointer on dai %s\n", dai->name);
 			break;
@@ -1951,7 +1951,7 @@ void sdw_shutdown_stream(void *sdw_substream)
 	/* Find stream from first CPU DAI */
 	dai = asoc_rtd_to_cpu(rtd, 0);
 
-	sdw_stream = snd_soc_dai_get_sdw_stream(dai, substream->stream);
+	sdw_stream = snd_soc_dai_get_stream(dai, substream->stream);
 
 	if (IS_ERR(sdw_stream)) {
 		dev_err(rtd->dev, "no stream found for DAI %s\n", dai->name);
diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
index f0e61c1b6ffd..ed091418f7e7 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -188,6 +188,28 @@ static int imgu_subdev_set_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static struct v4l2_rect *
+imgu_subdev_get_crop(struct imgu_v4l2_subdev *sd,
+		     struct v4l2_subdev_state *sd_state, unsigned int pad,
+		     enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_crop(&sd->subdev, sd_state, pad);
+	else
+		return &sd->rect.eff;
+}
+
+static struct v4l2_rect *
+imgu_subdev_get_compose(struct imgu_v4l2_subdev *sd,
+			struct v4l2_subdev_state *sd_state, unsigned int pad,
+			enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_compose(&sd->subdev, sd_state, pad);
+	else
+		return &sd->rect.bds;
+}
+
 static int imgu_subdev_get_selection(struct v4l2_subdev *sd,
 				     struct v4l2_subdev_state *sd_state,
 				     struct v4l2_subdev_selection *sel)
@@ -200,18 +222,12 @@ static int imgu_subdev_get_selection(struct v4l2_subdev *sd,
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
-		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-			sel->r = *v4l2_subdev_get_try_crop(sd, sd_state,
-							   sel->pad);
-		else
-			sel->r = imgu_sd->rect.eff;
+		sel->r = *imgu_subdev_get_crop(imgu_sd, sd_state, sel->pad,
+					       sel->which);
 		return 0;
 	case V4L2_SEL_TGT_COMPOSE:
-		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-			sel->r = *v4l2_subdev_get_try_compose(sd, sd_state,
-							      sel->pad);
-		else
-			sel->r = imgu_sd->rect.bds;
+		sel->r = *imgu_subdev_get_compose(imgu_sd, sd_state, sel->pad,
+						  sel->which);
 		return 0;
 	default:
 		return -EINVAL;
@@ -223,10 +239,9 @@ static int imgu_subdev_set_selection(struct v4l2_subdev *sd,
 				     struct v4l2_subdev_selection *sel)
 {
 	struct imgu_device *imgu = v4l2_get_subdevdata(sd);
-	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
-							struct imgu_v4l2_subdev,
-							subdev);
-	struct v4l2_rect *rect, *try_sel;
+	struct imgu_v4l2_subdev *imgu_sd =
+		container_of(sd, struct imgu_v4l2_subdev, subdev);
+	struct v4l2_rect *rect;
 
 	dev_dbg(&imgu->pci_dev->dev,
 		 "set subdev %u sel which %u target 0x%4x rect [%ux%u]",
@@ -238,22 +253,18 @@ static int imgu_subdev_set_selection(struct v4l2_subdev *sd,
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
-		try_sel = v4l2_subdev_get_try_crop(sd, sd_state, sel->pad);
-		rect = &imgu_sd->rect.eff;
+		rect = imgu_subdev_get_crop(imgu_sd, sd_state, sel->pad,
+					    sel->which);
 		break;
 	case V4L2_SEL_TGT_COMPOSE:
-		try_sel = v4l2_subdev_get_try_compose(sd, sd_state, sel->pad);
-		rect = &imgu_sd->rect.bds;
+		rect = imgu_subdev_get_compose(imgu_sd, sd_state, sel->pad,
+					       sel->which);
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-		*try_sel = sel->r;
-	else
-		*rect = sel->r;
-
+	*rect = sel->r;
 	return 0;
 }
 
diff --git a/drivers/staging/media/tegra-video/csi.c b/drivers/staging/media/tegra-video/csi.c
index b26e44adb2be..426e653bd55d 100644
--- a/drivers/staging/media/tegra-video/csi.c
+++ b/drivers/staging/media/tegra-video/csi.c
@@ -433,7 +433,7 @@ static int tegra_csi_channel_alloc(struct tegra_csi *csi,
 	for (i = 0; i < chan->numgangports; i++)
 		chan->csi_port_nums[i] = port_num + i * CSI_PORTS_PER_BRICK;
 
-	chan->of_node = node;
+	chan->of_node = of_node_get(node);
 	chan->numpads = num_pads;
 	if (num_pads & 0x2) {
 		chan->pads[0].flags = MEDIA_PAD_FL_SINK;
@@ -448,6 +448,7 @@ static int tegra_csi_channel_alloc(struct tegra_csi *csi,
 	chan->mipi = tegra_mipi_request(csi->dev, node);
 	if (IS_ERR(chan->mipi)) {
 		ret = PTR_ERR(chan->mipi);
+		chan->mipi = NULL;
 		dev_err(csi->dev, "failed to get mipi device: %d\n", ret);
 	}
 
@@ -640,6 +641,7 @@ static void tegra_csi_channels_cleanup(struct tegra_csi *csi)
 			media_entity_cleanup(&subdev->entity);
 		}
 
+		of_node_put(chan->of_node);
 		list_del(&chan->list);
 		kfree(chan);
 	}
diff --git a/drivers/staging/media/tegra-video/csi.h b/drivers/staging/media/tegra-video/csi.h
index 4ee05a1785cf..6960ea2e3d36 100644
--- a/drivers/staging/media/tegra-video/csi.h
+++ b/drivers/staging/media/tegra-video/csi.h
@@ -56,7 +56,7 @@ struct tegra_csi;
  * @framerate: active framerate for TPG
  * @h_blank: horizontal blanking for TPG active format
  * @v_blank: vertical blanking for TPG active format
- * @mipi: mipi device for corresponding csi channel pads
+ * @mipi: mipi device for corresponding csi channel pads, or NULL if not applicable (TPG, error)
  * @pixel_rate: active pixel rate from the sensor on this channel
  */
 struct tegra_csi_channel {
diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
index 8c42e7662033..92ed1213fe37 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
@@ -172,6 +172,7 @@ static const struct attribute_group fivr_attribute_group = {
 RFIM_SHOW(rfi_restriction_run_busy, 1)
 RFIM_SHOW(rfi_restriction_err_code, 1)
 RFIM_SHOW(rfi_restriction_data_rate, 1)
+RFIM_SHOW(rfi_restriction_data_rate_base, 1)
 RFIM_SHOW(ddr_data_rate_point_0, 1)
 RFIM_SHOW(ddr_data_rate_point_1, 1)
 RFIM_SHOW(ddr_data_rate_point_2, 1)
@@ -181,11 +182,13 @@ RFIM_SHOW(rfi_disable, 1)
 RFIM_STORE(rfi_restriction_run_busy, 1)
 RFIM_STORE(rfi_restriction_err_code, 1)
 RFIM_STORE(rfi_restriction_data_rate, 1)
+RFIM_STORE(rfi_restriction_data_rate_base, 1)
 RFIM_STORE(rfi_disable, 1)
 
 static DEVICE_ATTR_RW(rfi_restriction_run_busy);
 static DEVICE_ATTR_RW(rfi_restriction_err_code);
 static DEVICE_ATTR_RW(rfi_restriction_data_rate);
+static DEVICE_ATTR_RW(rfi_restriction_data_rate_base);
 static DEVICE_ATTR_RO(ddr_data_rate_point_0);
 static DEVICE_ATTR_RO(ddr_data_rate_point_1);
 static DEVICE_ATTR_RO(ddr_data_rate_point_2);
@@ -248,6 +251,7 @@ static struct attribute *dvfs_attrs[] = {
 	&dev_attr_rfi_restriction_run_busy.attr,
 	&dev_attr_rfi_restriction_err_code.attr,
 	&dev_attr_rfi_restriction_data_rate.attr,
+	&dev_attr_rfi_restriction_data_rate_base.attr,
 	&dev_attr_ddr_data_rate_point_0.attr,
 	&dev_attr_ddr_data_rate_point_1.attr,
 	&dev_attr_ddr_data_rate_point_2.attr,
diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index d0352daab012..ec1de6f6c290 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -258,7 +258,8 @@ static int dwc3_qcom_interconnect_init(struct dwc3_qcom *qcom)
 	if (IS_ERR(qcom->icc_path_apps)) {
 		dev_err(dev, "failed to get apps-usb path: %ld\n",
 				PTR_ERR(qcom->icc_path_apps));
-		return PTR_ERR(qcom->icc_path_apps);
+		ret = PTR_ERR(qcom->icc_path_apps);
+		goto put_path_ddr;
 	}
 
 	if (usb_get_maximum_speed(&qcom->dwc3->dev) >= USB_SPEED_SUPER ||
@@ -271,17 +272,23 @@ static int dwc3_qcom_interconnect_init(struct dwc3_qcom *qcom)
 
 	if (ret) {
 		dev_err(dev, "failed to set bandwidth for usb-ddr path: %d\n", ret);
-		return ret;
+		goto put_path_apps;
 	}
 
 	ret = icc_set_bw(qcom->icc_path_apps,
 		APPS_USB_AVG_BW, APPS_USB_PEAK_BW);
 	if (ret) {
 		dev_err(dev, "failed to set bandwidth for apps-usb path: %d\n", ret);
-		return ret;
+		goto put_path_apps;
 	}
 
 	return 0;
+
+put_path_apps:
+	icc_put(qcom->icc_path_apps);
+put_path_ddr:
+	icc_put(qcom->icc_path_ddr);
+	return ret;
 }
 
 /**
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index 2faf3bd1c3ba..4d9e3fdae5f6 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -66,8 +66,7 @@ static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
 {
 	struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
 
-	vringh_init_iotlb(&vq->vring, vdpasim->dev_attr.supported_features,
-			  VDPASIM_QUEUE_MAX, false,
+	vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, false,
 			  (struct vring_desc *)(uintptr_t)vq->desc_addr,
 			  (struct vring_avail *)
 			  (uintptr_t)vq->driver_addr,
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
index a790903f243e..22b812c32bee 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_blk.c
@@ -308,8 +308,10 @@ static int __init vdpasim_blk_init(void)
 	int ret;
 
 	ret = device_register(&vdpasim_blk_mgmtdev);
-	if (ret)
+	if (ret) {
+		put_device(&vdpasim_blk_mgmtdev);
 		return ret;
+	}
 
 	ret = vdpa_mgmtdev_register(&mgmt_dev);
 	if (ret)
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
index a1ab6163f7d1..f1c420c5e26e 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
@@ -194,8 +194,10 @@ static int __init vdpasim_net_init(void)
 	}
 
 	ret = device_register(&vdpasim_net_mgmtdev);
-	if (ret)
+	if (ret) {
+		put_device(&vdpasim_net_mgmtdev);
 		return ret;
+	}
 
 	ret = vdpa_mgmtdev_register(&mgmt_dev);
 	if (ret)
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 6942472cffb0..0a9746bc9228 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2048,7 +2048,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 	struct vhost_dev *dev = vq->dev;
 	struct vhost_iotlb *umem = dev->iotlb ? dev->iotlb : dev->umem;
 	struct iovec *_iov;
-	u64 s = 0;
+	u64 s = 0, last = addr + len - 1;
 	int ret = 0;
 
 	while ((u64)len > s) {
@@ -2058,7 +2058,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
 			break;
 		}
 
-		map = vhost_iotlb_itree_first(umem, addr, addr + len - 1);
+		map = vhost_iotlb_itree_first(umem, addr, last);
 		if (map == NULL || map->start > addr) {
 			if (umem != dev->iotlb) {
 				ret = -EFAULT;
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index eab55accf381..786876af0a73 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -1101,7 +1101,7 @@ static int iotlb_translate(const struct vringh *vrh,
 	struct vhost_iotlb_map *map;
 	struct vhost_iotlb *iotlb = vrh->iotlb;
 	int ret = 0;
-	u64 s = 0;
+	u64 s = 0, last = addr + len - 1;
 
 	spin_lock(vrh->iotlb_lock);
 
@@ -1113,8 +1113,7 @@ static int iotlb_translate(const struct vringh *vrh,
 			break;
 		}
 
-		map = vhost_iotlb_itree_first(iotlb, addr,
-					      addr + len - 1);
+		map = vhost_iotlb_itree_first(iotlb, addr, last);
 		if (!map || map->start > addr) {
 			ret = -EINVAL;
 			break;
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 97bfe499222b..74ac0c28fe43 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -968,7 +968,14 @@ static int __init vhost_vsock_init(void)
 				  VSOCK_TRANSPORT_F_H2G);
 	if (ret < 0)
 		return ret;
-	return misc_register(&vhost_vsock_misc);
+
+	ret = misc_register(&vhost_vsock_misc);
+	if (ret) {
+		vsock_core_unregister(&vhost_transport.transport);
+		return ret;
+	}
+
+	return 0;
 };
 
 static void __exit vhost_vsock_exit(void)
diff --git a/drivers/video/fbdev/matrox/matroxfb_base.c b/drivers/video/fbdev/matrox/matroxfb_base.c
index 236521b19daf..e7348d657e18 100644
--- a/drivers/video/fbdev/matrox/matroxfb_base.c
+++ b/drivers/video/fbdev/matrox/matroxfb_base.c
@@ -1377,8 +1377,8 @@ static struct video_board vbG200 = {
 	.lowlevel = &matrox_G100
 };
 static struct video_board vbG200eW = {
-	.maxvram = 0x100000,
-	.maxdisplayable = 0x800000,
+	.maxvram = 0x1000000,
+	.maxdisplayable = 0x0800000,
 	.accelID = FB_ACCEL_MATROX_MGAG200,
 	.lowlevel = &matrox_G100
 };
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 830a6a876ffe..c316931fc99c 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -434,8 +434,9 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 	current->mm->start_stack = current->mm->start_brk + stack_size;
 #endif
 
-	if (create_elf_fdpic_tables(bprm, current->mm,
-				    &exec_params, &interp_params) < 0)
+	retval = create_elf_fdpic_tables(bprm, current->mm, &exec_params,
+					 &interp_params);
+	if (retval < 0)
 		goto error;
 
 	kdebug("- start_code  %lx", current->mm->start_code);
diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 1ff527bbe54c..cd9202867d98 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -433,6 +433,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 	u64 wanted_disk_byte = ref->wanted_disk_byte;
 	u64 count = 0;
 	u64 data_offset;
+	u8 type;
 
 	if (level != 0) {
 		eb = path->nodes[level];
@@ -487,6 +488,9 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 			continue;
 		}
 		fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
+		type = btrfs_file_extent_type(eb, fi);
+		if (type == BTRFS_FILE_EXTENT_INLINE)
+			goto next;
 		disk_byte = btrfs_file_extent_disk_bytenr(eb, fi);
 		data_offset = btrfs_file_extent_offset(eb, fi);
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2fd46093e5bb..2c80fc902f59 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -202,11 +202,9 @@ static bool btrfs_supported_super_csum(u16 csum_type)
  * Return 0 if the superblock checksum type matches the checksum value of that
  * algorithm. Pass the raw disk superblock data.
  */
-static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
-				  char *raw_disk_sb)
+int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
+			   const struct btrfs_super_block *disk_sb)
 {
-	struct btrfs_super_block *disk_sb =
-		(struct btrfs_super_block *)raw_disk_sb;
 	char result[BTRFS_CSUM_SIZE];
 	SHASH_DESC_ON_STACK(shash, fs_info->csum_shash);
 
@@ -217,7 +215,7 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
 	 * BTRFS_SUPER_INFO_SIZE range, we expect that the unused space is
 	 * filled with zeros and is included in the checksum.
 	 */
-	crypto_shash_digest(shash, raw_disk_sb + BTRFS_CSUM_SIZE,
+	crypto_shash_digest(shash, (const u8 *)disk_sb + BTRFS_CSUM_SIZE,
 			    BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE, result);
 
 	if (memcmp(disk_sb->csum, result, fs_info->csum_size))
@@ -2491,8 +2489,8 @@ static int btrfs_read_roots(struct btrfs_fs_info *fs_info)
  * 		1, 2	2nd and 3rd backup copy
  * 	       -1	skip bytenr check
  */
-static int validate_super(struct btrfs_fs_info *fs_info,
-			    struct btrfs_super_block *sb, int mirror_num)
+int btrfs_validate_super(struct btrfs_fs_info *fs_info,
+			 struct btrfs_super_block *sb, int mirror_num)
 {
 	u64 nodesize = btrfs_super_nodesize(sb);
 	u64 sectorsize = btrfs_super_sectorsize(sb);
@@ -2675,7 +2673,7 @@ static int validate_super(struct btrfs_fs_info *fs_info,
  */
 static int btrfs_validate_mount_super(struct btrfs_fs_info *fs_info)
 {
-	return validate_super(fs_info, fs_info->super_copy, 0);
+	return btrfs_validate_super(fs_info, fs_info->super_copy, 0);
 }
 
 /*
@@ -2689,7 +2687,7 @@ static int btrfs_validate_write_super(struct btrfs_fs_info *fs_info,
 {
 	int ret;
 
-	ret = validate_super(fs_info, sb, -1);
+	ret = btrfs_validate_super(fs_info, sb, -1);
 	if (ret < 0)
 		goto out;
 	if (!btrfs_supported_super_csum(btrfs_super_csum_type(sb))) {
@@ -3210,7 +3208,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	 * We want to check superblock checksum, the type is stored inside.
 	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
 	 */
-	if (btrfs_check_super_csum(fs_info, (u8 *)disk_super)) {
+	if (btrfs_check_super_csum(fs_info, disk_super)) {
 		btrfs_err(fs_info, "superblock checksum mismatch");
 		err = -EINVAL;
 		btrfs_release_disk_super(disk_super);
@@ -3703,7 +3701,7 @@ static void btrfs_end_super_write(struct bio *bio)
 }
 
 struct btrfs_super_block *btrfs_read_dev_one_super(struct block_device *bdev,
-						   int copy_num)
+						   int copy_num, bool drop_cache)
 {
 	struct btrfs_super_block *super;
 	struct page *page;
@@ -3721,6 +3719,19 @@ struct btrfs_super_block *btrfs_read_dev_one_super(struct block_device *bdev,
 	if (bytenr + BTRFS_SUPER_INFO_SIZE >= i_size_read(bdev->bd_inode))
 		return ERR_PTR(-EINVAL);
 
+	if (drop_cache) {
+		/* This should only be called with the primary sb. */
+		ASSERT(copy_num == 0);
+
+		/*
+		 * Drop the page of the primary superblock, so later read will
+		 * always read from the device.
+		 */
+		invalidate_inode_pages2_range(mapping,
+				bytenr >> PAGE_SHIFT,
+				(bytenr + BTRFS_SUPER_INFO_SIZE) >> PAGE_SHIFT);
+	}
+
 	page = read_cache_page_gfp(mapping, bytenr >> PAGE_SHIFT, GFP_NOFS);
 	if (IS_ERR(page))
 		return ERR_CAST(page);
@@ -3752,7 +3763,7 @@ struct btrfs_super_block *btrfs_read_dev_super(struct block_device *bdev)
 	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
 	 */
 	for (i = 0; i < 1; i++) {
-		super = btrfs_read_dev_one_super(bdev, i);
+		super = btrfs_read_dev_one_super(bdev, i, false);
 		if (IS_ERR(super))
 			continue;
 
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 1b8fd3deafc9..718787dfdb8e 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -52,14 +52,18 @@ struct extent_buffer *btrfs_find_create_tree_block(
 void btrfs_clean_tree_block(struct extent_buffer *buf);
 void btrfs_clear_oneshot_options(struct btrfs_fs_info *fs_info);
 int btrfs_start_pre_rw_mount(struct btrfs_fs_info *fs_info);
+int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
+			   const struct btrfs_super_block *disk_sb);
 int __cold open_ctree(struct super_block *sb,
 	       struct btrfs_fs_devices *fs_devices,
 	       char *options);
 void __cold close_ctree(struct btrfs_fs_info *fs_info);
+int btrfs_validate_super(struct btrfs_fs_info *fs_info,
+			 struct btrfs_super_block *sb, int mirror_num);
 int write_all_supers(struct btrfs_fs_info *fs_info, int max_mirrors);
 struct btrfs_super_block *btrfs_read_dev_super(struct block_device *bdev);
 struct btrfs_super_block *btrfs_read_dev_one_super(struct block_device *bdev,
-						   int copy_num);
+						   int copy_num, bool drop_cache);
 int btrfs_commit_super(struct btrfs_fs_info *fs_info);
 struct btrfs_root *btrfs_read_tree_root(struct btrfs_root *tree_root,
 					struct btrfs_key *key);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 391a4af9c5e5..ed9c715d2579 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3415,13 +3415,10 @@ static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
 	di_args->bytes_used = btrfs_device_get_bytes_used(dev);
 	di_args->total_bytes = btrfs_device_get_total_bytes(dev);
 	memcpy(di_args->uuid, dev->uuid, sizeof(di_args->uuid));
-	if (dev->name) {
-		strncpy(di_args->path, rcu_str_deref(dev->name),
-				sizeof(di_args->path) - 1);
-		di_args->path[sizeof(di_args->path) - 1] = 0;
-	} else {
+	if (dev->name)
+		strscpy(di_args->path, rcu_str_deref(dev->name), sizeof(di_args->path));
+	else
 		di_args->path[0] = '\0';
-	}
 
 out:
 	rcu_read_unlock();
diff --git a/fs/btrfs/rcu-string.h b/fs/btrfs/rcu-string.h
index 5c1a617eb25d..5c2b66d155ef 100644
--- a/fs/btrfs/rcu-string.h
+++ b/fs/btrfs/rcu-string.h
@@ -18,7 +18,11 @@ static inline struct rcu_string *rcu_string_strdup(const char *src, gfp_t mask)
 					 (len * sizeof(char)), mask);
 	if (!ret)
 		return ret;
-	strncpy(ret->str, src, len);
+	/* Warn if the source got unexpectedly truncated. */
+	if (WARN_ON(strscpy(ret->str, src, len) < 0)) {
+		kfree(ret);
+		return NULL;
+	}
 	return ret;
 }
 
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 61b84391be58..4ff55457f902 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2497,11 +2497,87 @@ static int btrfs_freeze(struct super_block *sb)
 	return btrfs_commit_transaction(trans);
 }
 
+static int check_dev_super(struct btrfs_device *dev)
+{
+	struct btrfs_fs_info *fs_info = dev->fs_info;
+	struct btrfs_super_block *sb;
+	u16 csum_type;
+	int ret = 0;
+
+	/* This should be called with fs still frozen. */
+	ASSERT(test_bit(BTRFS_FS_FROZEN, &fs_info->flags));
+
+	/* Missing dev, no need to check. */
+	if (!dev->bdev)
+		return 0;
+
+	/* Only need to check the primary super block. */
+	sb = btrfs_read_dev_one_super(dev->bdev, 0, true);
+	if (IS_ERR(sb))
+		return PTR_ERR(sb);
+
+	/* Verify the checksum. */
+	csum_type = btrfs_super_csum_type(sb);
+	if (csum_type != btrfs_super_csum_type(fs_info->super_copy)) {
+		btrfs_err(fs_info, "csum type changed, has %u expect %u",
+			  csum_type, btrfs_super_csum_type(fs_info->super_copy));
+		ret = -EUCLEAN;
+		goto out;
+	}
+
+	if (btrfs_check_super_csum(fs_info, sb)) {
+		btrfs_err(fs_info, "csum for on-disk super block no longer matches");
+		ret = -EUCLEAN;
+		goto out;
+	}
+
+	/* Btrfs_validate_super() includes fsid check against super->fsid. */
+	ret = btrfs_validate_super(fs_info, sb, 0);
+	if (ret < 0)
+		goto out;
+
+	if (btrfs_super_generation(sb) != fs_info->last_trans_committed) {
+		btrfs_err(fs_info, "transid mismatch, has %llu expect %llu",
+			btrfs_super_generation(sb),
+			fs_info->last_trans_committed);
+		ret = -EUCLEAN;
+		goto out;
+	}
+out:
+	btrfs_release_disk_super(sb);
+	return ret;
+}
+
 static int btrfs_unfreeze(struct super_block *sb)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
+	struct btrfs_device *device;
+	int ret = 0;
 
+	/*
+	 * Make sure the fs is not changed by accident (like hibernation then
+	 * modified by other OS).
+	 * If we found anything wrong, we mark the fs error immediately.
+	 *
+	 * And since the fs is frozen, no one can modify the fs yet, thus
+	 * we don't need to hold device_list_mutex.
+	 */
+	list_for_each_entry(device, &fs_info->fs_devices->devices, dev_list) {
+		ret = check_dev_super(device);
+		if (ret < 0) {
+			btrfs_handle_fs_error(fs_info, ret,
+				"super block on devid %llu got modified unexpectedly",
+				device->devid);
+			break;
+		}
+	}
 	clear_bit(BTRFS_FS_FROZEN, &fs_info->flags);
+
+	/*
+	 * We still return 0, to allow VFS layer to unfreeze the fs even the
+	 * above checks failed. Since the fs is either fine or read-only, we're
+	 * safe to continue, without causing further damage.
+	 */
 	return 0;
 }
 
diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index 7c45d960b53c..259a3b5f9303 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -39,8 +39,10 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 		goto out;
 
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	level = btrfs_header_level(root->node);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index c886ec81c5d0..f01549b8c7c5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2074,7 +2074,7 @@ void btrfs_scratch_superblocks(struct btrfs_fs_info *fs_info,
 		struct page *page;
 		int ret;
 
-		disk_super = btrfs_read_dev_one_super(bdev, copy_num);
+		disk_super = btrfs_read_dev_one_super(bdev, copy_num, false);
 		if (IS_ERR(disk_super))
 			continue;
 
@@ -7043,6 +7043,27 @@ static void warn_32bit_meta_chunk(struct btrfs_fs_info *fs_info,
 }
 #endif
 
+static struct btrfs_device *handle_missing_device(struct btrfs_fs_info *fs_info,
+						  u64 devid, u8 *uuid)
+{
+	struct btrfs_device *dev;
+
+	if (!btrfs_test_opt(fs_info, DEGRADED)) {
+		btrfs_report_missing_device(fs_info, devid, uuid, true);
+		return ERR_PTR(-ENOENT);
+	}
+
+	dev = add_missing_dev(fs_info->fs_devices, devid, uuid);
+	if (IS_ERR(dev)) {
+		btrfs_err(fs_info, "failed to init missing device %llu: %ld",
+			  devid, PTR_ERR(dev));
+		return dev;
+	}
+	btrfs_report_missing_device(fs_info, devid, uuid, false);
+
+	return dev;
+}
+
 static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 			  struct btrfs_chunk *chunk)
 {
@@ -7130,28 +7151,18 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 				   BTRFS_UUID_SIZE);
 		args.uuid = uuid;
 		map->stripes[i].dev = btrfs_find_device(fs_info->fs_devices, &args);
-		if (!map->stripes[i].dev &&
-		    !btrfs_test_opt(fs_info, DEGRADED)) {
-			free_extent_map(em);
-			btrfs_report_missing_device(fs_info, devid, uuid, true);
-			return -ENOENT;
-		}
 		if (!map->stripes[i].dev) {
-			map->stripes[i].dev =
-				add_missing_dev(fs_info->fs_devices, devid,
-						uuid);
+			map->stripes[i].dev = handle_missing_device(fs_info,
+								    devid, uuid);
 			if (IS_ERR(map->stripes[i].dev)) {
+				ret = PTR_ERR(map->stripes[i].dev);
 				free_extent_map(em);
-				btrfs_err(fs_info,
-					"failed to init missing dev %llu: %ld",
-					devid, PTR_ERR(map->stripes[i].dev));
-				return PTR_ERR(map->stripes[i].dev);
+				return ret;
 			}
-			btrfs_report_missing_device(fs_info, devid, uuid, false);
 		}
+
 		set_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
 				&(map->stripes[i].dev->dev_state));
-
 	}
 
 	write_lock(&map_tree->lock);
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index be96fe615bec..67b782b0a90a 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2872,7 +2872,7 @@ int ceph_get_caps(struct file *filp, int need, int want, loff_t endoff, int *got
 
 	while (true) {
 		flags &= CEPH_FILE_MODE_MASK;
-		if (atomic_read(&fi->num_locks))
+		if (vfs_inode_has_locks(inode))
 			flags |= CHECK_FILELOCK;
 		_got = 0;
 		ret = try_get_cap_refs(inode, need, want, endoff,
diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
index bdeb271f47d9..3e3b8be76b21 100644
--- a/fs/ceph/locks.c
+++ b/fs/ceph/locks.c
@@ -32,18 +32,14 @@ void __init ceph_flock_init(void)
 
 static void ceph_fl_copy_lock(struct file_lock *dst, struct file_lock *src)
 {
-	struct ceph_file_info *fi = dst->fl_file->private_data;
 	struct inode *inode = file_inode(dst->fl_file);
 	atomic_inc(&ceph_inode(inode)->i_filelock_ref);
-	atomic_inc(&fi->num_locks);
 }
 
 static void ceph_fl_release_lock(struct file_lock *fl)
 {
-	struct ceph_file_info *fi = fl->fl_file->private_data;
 	struct inode *inode = file_inode(fl->fl_file);
 	struct ceph_inode_info *ci = ceph_inode(inode);
-	atomic_dec(&fi->num_locks);
 	if (atomic_dec_and_test(&ci->i_filelock_ref)) {
 		/* clear error when all locks are released */
 		spin_lock(&ci->i_ceph_lock);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 14f951cd5b61..8c9021d0f837 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -773,7 +773,6 @@ struct ceph_file_info {
 	struct list_head rw_contexts;
 
 	u32 filp_gen;
-	atomic_t num_locks;
 };
 
 struct ceph_dir_file_info {
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 668dd6a86295..fc736ced6f4a 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -656,9 +656,15 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	seq_printf(s, ",echo_interval=%lu",
 			tcon->ses->server->echo_interval / HZ);
 
-	/* Only display max_credits if it was overridden on mount */
+	/* Only display the following if overridden on mount */
 	if (tcon->ses->server->max_credits != SMB2_MAX_CREDITS_AVAILABLE)
 		seq_printf(s, ",max_credits=%u", tcon->ses->server->max_credits);
+	if (tcon->ses->server->tcp_nodelay)
+		seq_puts(s, ",tcpnodelay");
+	if (tcon->ses->server->noautotune)
+		seq_puts(s, ",noautotune");
+	if (tcon->ses->server->noblocksnd)
+		seq_puts(s, ",noblocksend");
 
 	if (tcon->snapshot_time)
 		seq_printf(s, ",snapshot=%llu", tcon->snapshot_time);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 1ab72c3d0bff..0f1b9c48838c 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -13,6 +13,8 @@
 #include <linux/in6.h>
 #include <linux/inet.h>
 #include <linux/slab.h>
+#include <linux/scatterlist.h>
+#include <linux/mm.h>
 #include <linux/mempool.h>
 #include <linux/workqueue.h>
 #include "cifs_fs_sb.h"
@@ -21,6 +23,7 @@
 #include <linux/scatterlist.h>
 #include <uapi/linux/cifs/cifs_mount.h>
 #include "smb2pdu.h"
+#include "smb2glob.h"
 
 #define CIFS_MAGIC_NUMBER 0xFF534D42      /* the first four bytes of SMB PDUs */
 
@@ -1972,4 +1975,70 @@ static inline bool cifs_is_referral_server(struct cifs_tcon *tcon,
 	return is_tcon_dfs(tcon) || (ref && (ref->flags & DFSREF_REFERRAL_SERVER));
 }
 
+static inline unsigned int cifs_get_num_sgs(const struct smb_rqst *rqst,
+					    int num_rqst,
+					    const u8 *sig)
+{
+	unsigned int len, skip;
+	unsigned int nents = 0;
+	unsigned long addr;
+	int i, j;
+
+	/* Assumes the first rqst has a transform header as the first iov.
+	 * I.e.
+	 * rqst[0].rq_iov[0]  is transform header
+	 * rqst[0].rq_iov[1+] data to be encrypted/decrypted
+	 * rqst[1+].rq_iov[0+] data to be encrypted/decrypted
+	 */
+	for (i = 0; i < num_rqst; i++) {
+		/*
+		 * The first rqst has a transform header where the
+		 * first 20 bytes are not part of the encrypted blob.
+		 */
+		for (j = 0; j < rqst[i].rq_nvec; j++) {
+			struct kvec *iov = &rqst[i].rq_iov[j];
+
+			skip = (i == 0) && (j == 0) ? 20 : 0;
+			addr = (unsigned long)iov->iov_base + skip;
+			if (unlikely(is_vmalloc_addr((void *)addr))) {
+				len = iov->iov_len - skip;
+				nents += DIV_ROUND_UP(offset_in_page(addr) + len,
+						      PAGE_SIZE);
+			} else {
+				nents++;
+			}
+		}
+		nents += rqst[i].rq_npages;
+	}
+	nents += DIV_ROUND_UP(offset_in_page(sig) + SMB2_SIGNATURE_SIZE, PAGE_SIZE);
+	return nents;
+}
+
+/* We can not use the normal sg_set_buf() as we will sometimes pass a
+ * stack object as buf.
+ */
+static inline struct scatterlist *cifs_sg_set_buf(struct scatterlist *sg,
+						  const void *buf,
+						  unsigned int buflen)
+{
+	unsigned long addr = (unsigned long)buf;
+	unsigned int off = offset_in_page(addr);
+
+	addr &= PAGE_MASK;
+	if (unlikely(is_vmalloc_addr((void *)addr))) {
+		do {
+			unsigned int len = min_t(unsigned int, buflen, PAGE_SIZE - off);
+
+			sg_set_page(sg++, vmalloc_to_page((void *)addr), len, off);
+
+			off = 0;
+			addr += PAGE_SIZE;
+			buflen -= len;
+		} while (buflen);
+	} else {
+		sg_set_page(sg++, virt_to_page(addr), buflen, off);
+	}
+	return sg;
+}
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index b2697356b5e7..50844d51da5d 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -590,8 +590,8 @@ int cifs_alloc_hash(const char *name, struct crypto_shash **shash,
 		    struct sdesc **sdesc);
 void cifs_free_hash(struct crypto_shash **shash, struct sdesc **sdesc);
 
-extern void rqst_page_get_length(struct smb_rqst *rqst, unsigned int page,
-				unsigned int *len, unsigned int *offset);
+void rqst_page_get_length(const struct smb_rqst *rqst, unsigned int page,
+			  unsigned int *len, unsigned int *offset);
 struct cifs_chan *
 cifs_ses_find_chan(struct cifs_ses *ses, struct TCP_Server_Info *server);
 int cifs_try_adding_channels(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a4284c4d7e03..555bd386a24d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1948,7 +1948,7 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx __attribute__((unused)),
 struct cifs_ses *
 cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 {
-	int rc = -ENOMEM;
+	int rc = 0;
 	unsigned int xid;
 	struct cifs_ses *ses;
 	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
@@ -1990,6 +1990,8 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 		return ses;
 	}
 
+	rc = -ENOMEM;
+
 	cifs_dbg(FYI, "Existing smb sess not found\n");
 	ses = sesInfoAlloc();
 	if (ses == NULL)
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 94143d7f58c7..3a90ee314ed7 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1134,8 +1134,8 @@ cifs_free_hash(struct crypto_shash **shash, struct sdesc **sdesc)
  * @len: Where to store the length for this page:
  * @offset: Where to store the offset for this page
  */
-void rqst_page_get_length(struct smb_rqst *rqst, unsigned int page,
-				unsigned int *len, unsigned int *offset)
+void rqst_page_get_length(const struct smb_rqst *rqst, unsigned int page,
+			  unsigned int *len, unsigned int *offset)
 {
 	*len = rqst->rq_pagesz;
 	*offset = (page == 0) ? rqst->rq_offset : 0;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 5e6526c201fe..817d78129bd2 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4416,69 +4416,82 @@ fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
 	memcpy(&tr_hdr->SessionId, &shdr->SessionId, 8);
 }
 
-/* We can not use the normal sg_set_buf() as we will sometimes pass a
- * stack object as buf.
- */
-static inline void smb2_sg_set_buf(struct scatterlist *sg, const void *buf,
-				   unsigned int buflen)
+static void *smb2_aead_req_alloc(struct crypto_aead *tfm, const struct smb_rqst *rqst,
+				 int num_rqst, const u8 *sig, u8 **iv,
+				 struct aead_request **req, struct scatterlist **sgl,
+				 unsigned int *num_sgs)
 {
-	void *addr;
-	/*
-	 * VMAP_STACK (at least) puts stack into the vmalloc address space
-	 */
-	if (is_vmalloc_addr(buf))
-		addr = vmalloc_to_page(buf);
-	else
-		addr = virt_to_page(buf);
-	sg_set_page(sg, addr, buflen, offset_in_page(buf));
+	unsigned int req_size = sizeof(**req) + crypto_aead_reqsize(tfm);
+	unsigned int iv_size = crypto_aead_ivsize(tfm);
+	unsigned int len;
+	u8 *p;
+
+	*num_sgs = cifs_get_num_sgs(rqst, num_rqst, sig);
+
+	len = iv_size;
+	len += crypto_aead_alignmask(tfm) & ~(crypto_tfm_ctx_alignment() - 1);
+	len = ALIGN(len, crypto_tfm_ctx_alignment());
+	len += req_size;
+	len = ALIGN(len, __alignof__(struct scatterlist));
+	len += *num_sgs * sizeof(**sgl);
+
+	p = kmalloc(len, GFP_ATOMIC);
+	if (!p)
+		return NULL;
+
+	*iv = (u8 *)PTR_ALIGN(p, crypto_aead_alignmask(tfm) + 1);
+	*req = (struct aead_request *)PTR_ALIGN(*iv + iv_size,
+						crypto_tfm_ctx_alignment());
+	*sgl = (struct scatterlist *)PTR_ALIGN((u8 *)*req + req_size,
+					       __alignof__(struct scatterlist));
+	return p;
 }
 
-/* Assumes the first rqst has a transform header as the first iov.
- * I.e.
- * rqst[0].rq_iov[0]  is transform header
- * rqst[0].rq_iov[1+] data to be encrypted/decrypted
- * rqst[1+].rq_iov[0+] data to be encrypted/decrypted
- */
-static struct scatterlist *
-init_sg(int num_rqst, struct smb_rqst *rqst, u8 *sign)
+static void *smb2_get_aead_req(struct crypto_aead *tfm, const struct smb_rqst *rqst,
+			       int num_rqst, const u8 *sig, u8 **iv,
+			       struct aead_request **req, struct scatterlist **sgl)
 {
-	unsigned int sg_len;
+	unsigned int off, len, skip;
 	struct scatterlist *sg;
-	unsigned int i;
-	unsigned int j;
-	unsigned int idx = 0;
-	int skip;
-
-	sg_len = 1;
-	for (i = 0; i < num_rqst; i++)
-		sg_len += rqst[i].rq_nvec + rqst[i].rq_npages;
+	unsigned int num_sgs;
+	unsigned long addr;
+	int i, j;
+	void *p;
 
-	sg = kmalloc_array(sg_len, sizeof(struct scatterlist), GFP_KERNEL);
-	if (!sg)
+	p = smb2_aead_req_alloc(tfm, rqst, num_rqst, sig, iv, req, sgl, &num_sgs);
+	if (!p)
 		return NULL;
 
-	sg_init_table(sg, sg_len);
+	sg_init_table(*sgl, num_sgs);
+	sg = *sgl;
+
+	/* Assumes the first rqst has a transform header as the first iov.
+	 * I.e.
+	 * rqst[0].rq_iov[0]  is transform header
+	 * rqst[0].rq_iov[1+] data to be encrypted/decrypted
+	 * rqst[1+].rq_iov[0+] data to be encrypted/decrypted
+	 */
 	for (i = 0; i < num_rqst; i++) {
+		/*
+		 * The first rqst has a transform header where the
+		 * first 20 bytes are not part of the encrypted blob.
+		 */
 		for (j = 0; j < rqst[i].rq_nvec; j++) {
-			/*
-			 * The first rqst has a transform header where the
-			 * first 20 bytes are not part of the encrypted blob
-			 */
-			skip = (i == 0) && (j == 0) ? 20 : 0;
-			smb2_sg_set_buf(&sg[idx++],
-					rqst[i].rq_iov[j].iov_base + skip,
-					rqst[i].rq_iov[j].iov_len - skip);
-			}
+			struct kvec *iov = &rqst[i].rq_iov[j];
 
+			skip = (i == 0) && (j == 0) ? 20 : 0;
+			addr = (unsigned long)iov->iov_base + skip;
+			len = iov->iov_len - skip;
+			sg = cifs_sg_set_buf(sg, (void *)addr, len);
+		}
 		for (j = 0; j < rqst[i].rq_npages; j++) {
-			unsigned int len, offset;
-
-			rqst_page_get_length(&rqst[i], j, &len, &offset);
-			sg_set_page(&sg[idx++], rqst[i].rq_pages[j], len, offset);
+			rqst_page_get_length(&rqst[i], j, &len, &off);
+			sg_set_page(sg++, rqst[i].rq_pages[j], len, off);
 		}
 	}
-	smb2_sg_set_buf(&sg[idx], sign, SMB2_SIGNATURE_SIZE);
-	return sg;
+	cifs_sg_set_buf(sg, sig, SMB2_SIGNATURE_SIZE);
+
+	return p;
 }
 
 static int
@@ -4522,11 +4535,11 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	u8 sign[SMB2_SIGNATURE_SIZE] = {};
 	u8 key[SMB3_ENC_DEC_KEY_SIZE];
 	struct aead_request *req;
-	char *iv;
-	unsigned int iv_len;
+	u8 *iv;
 	DECLARE_CRYPTO_WAIT(wait);
 	struct crypto_aead *tfm;
 	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
+	void *creq;
 
 	rc = smb2_get_enc_key(server, tr_hdr->SessionId, enc, key);
 	if (rc) {
@@ -4561,32 +4574,15 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 		return rc;
 	}
 
-	req = aead_request_alloc(tfm, GFP_KERNEL);
-	if (!req) {
-		cifs_server_dbg(VFS, "%s: Failed to alloc aead request\n", __func__);
+	creq = smb2_get_aead_req(tfm, rqst, num_rqst, sign, &iv, &req, &sg);
+	if (unlikely(!creq))
 		return -ENOMEM;
-	}
 
 	if (!enc) {
 		memcpy(sign, &tr_hdr->Signature, SMB2_SIGNATURE_SIZE);
 		crypt_len += SMB2_SIGNATURE_SIZE;
 	}
 
-	sg = init_sg(num_rqst, rqst, sign);
-	if (!sg) {
-		cifs_server_dbg(VFS, "%s: Failed to init sg\n", __func__);
-		rc = -ENOMEM;
-		goto free_req;
-	}
-
-	iv_len = crypto_aead_ivsize(tfm);
-	iv = kzalloc(iv_len, GFP_KERNEL);
-	if (!iv) {
-		cifs_server_dbg(VFS, "%s: Failed to alloc iv\n", __func__);
-		rc = -ENOMEM;
-		goto free_sg;
-	}
-
 	if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
 	    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
 		memcpy(iv, (char *)tr_hdr->Nonce, SMB3_AES_GCM_NONCE);
@@ -4595,6 +4591,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 		memcpy(iv + 1, (char *)tr_hdr->Nonce, SMB3_AES_CCM_NONCE);
 	}
 
+	aead_request_set_tfm(req, tfm);
 	aead_request_set_crypt(req, sg, sg, crypt_len, iv);
 	aead_request_set_ad(req, assoc_data_len);
 
@@ -4607,11 +4604,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	if (!rc && enc)
 		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
 
-	kfree(iv);
-free_sg:
-	kfree(sg);
-free_req:
-	kfree(req);
+	kfree_sensitive(creq);
 	return rc;
 }
 
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 9d7078a1dc8b..d56a8f88a385 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1520,7 +1520,11 @@ static void process_recv_sockets(struct work_struct *work)
 
 static void process_listen_recv_socket(struct work_struct *work)
 {
-	accept_from_sock(&listen_con);
+	int ret;
+
+	do {
+		ret = accept_from_sock(&listen_con);
+	} while (!ret);
 }
 
 static void dlm_connect(struct connection *con)
@@ -1797,7 +1801,7 @@ static int dlm_listen_for_all(void)
 	result = sock->ops->listen(sock, 5);
 	if (result < 0) {
 		dlm_close_sock(&listen_con.sock);
-		goto out;
+		return result;
 	}
 
 	return 0;
@@ -2000,7 +2004,6 @@ int dlm_lowcomms_start(void)
 	dlm_proto_ops = NULL;
 fail_proto_ops:
 	dlm_allow_conn = 0;
-	dlm_close_sock(&listen_con.sock);
 	work_stop();
 fail_local:
 	deinit_local();
diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index a0fb0c4bdc7c..f9a79053f03a 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -665,7 +665,7 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
 	 * it's possible we've just missed a transaction commit here,
 	 * so ignore the returned status
 	 */
-	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
+	ext4_debug("%s: retrying operation after ENOSPC\n", sb->s_id);
 	(void) jbd2_journal_force_commit_nested(sbi->s_journal);
 	return 1;
 }
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 2d84030d7b7f..bc209f303327 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -559,7 +559,7 @@ enum {
  *
  * It's not paranoia if the Murphy's Law really *is* out to get you.  :-)
  */
-#define TEST_FLAG_VALUE(FLAG) (EXT4_##FLAG##_FL == (1 << EXT4_INODE_##FLAG))
+#define TEST_FLAG_VALUE(FLAG) (EXT4_##FLAG##_FL == (1U << EXT4_INODE_##FLAG))
 #define CHECK_FLAG_VALUE(FLAG) BUILD_BUG_ON(!TEST_FLAG_VALUE(FLAG))
 
 static inline void ext4_check_flag_values(void)
@@ -2996,7 +2996,8 @@ int do_journal_get_write_access(handle_t *handle, struct inode *inode,
 typedef enum {
 	EXT4_IGET_NORMAL =	0,
 	EXT4_IGET_SPECIAL =	0x0001, /* OK to iget a system inode */
-	EXT4_IGET_HANDLE = 	0x0002	/* Inode # is from a handle */
+	EXT4_IGET_HANDLE = 	0x0002,	/* Inode # is from a handle */
+	EXT4_IGET_BAD =		0x0004  /* Allow to iget a bad inode */
 } ext4_iget_flags;
 
 extern struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
@@ -3646,8 +3647,8 @@ extern void ext4_initialize_dirent_tail(struct buffer_head *bh,
 					unsigned int blocksize);
 extern int ext4_handle_dirty_dirblock(handle_t *handle, struct inode *inode,
 				      struct buffer_head *bh);
-extern int __ext4_unlink(handle_t *handle, struct inode *dir, const struct qstr *d_name,
-			 struct inode *inode);
+extern int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
+			 struct inode *inode, struct dentry *dentry);
 extern int __ext4_link(struct inode *dir, struct inode *inode,
 		       struct dentry *dentry);
 
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 3477a16d08ae..8e1fb18f465e 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -267,8 +267,7 @@ int __ext4_forget(const char *where, unsigned int line, handle_t *handle,
 	trace_ext4_forget(inode, is_metadata, blocknr);
 	BUFFER_TRACE(bh, "enter");
 
-	jbd_debug(4, "forgetting bh %p: is_metadata = %d, mode %o, "
-		  "data mode %x\n",
+	ext4_debug("forgetting bh %p: is_metadata=%d, mode %o, data mode %x\n",
 		  bh, is_metadata, inode->i_mode,
 		  test_opt(inode->i_sb, DATA_FLAGS));
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9e09caaf9b0b..d3fae909fcbf 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5810,6 +5810,14 @@ int ext4_clu_mapped(struct inode *inode, ext4_lblk_t lclu)
 	struct ext4_extent *extent;
 	ext4_lblk_t first_lblk, first_lclu, last_lclu;
 
+	/*
+	 * if data can be stored inline, the logical cluster isn't
+	 * mapped - no physical clusters have been allocated, and the
+	 * file has no extents
+	 */
+	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+		return 0;
+
 	/* search for the extent closest to the first block in the cluster */
 	path = ext4_find_extent(inode, EXT4_C2B(sbi, lclu), NULL, 0);
 	if (IS_ERR(path)) {
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 9a3a8996aacf..aa99a3659edf 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1372,7 +1372,7 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 		if (count_reserved)
 			count_rsvd(inode, lblk, orig_es.es_len - len1 - len2,
 				   &orig_es, &rc);
-		goto out;
+		goto out_get_reserved;
 	}
 
 	if (len1 > 0) {
@@ -1414,6 +1414,7 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 		}
 	}
 
+out_get_reserved:
 	if (count_reserved)
 		*reserved = get_rsvd(inode, end, es, &rc);
 out:
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index be3f8ce98962..a8d0a8081a1d 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -399,25 +399,34 @@ static int __track_dentry_update(struct inode *inode, void *arg, bool update)
 	struct __track_dentry_update_args *dentry_update =
 		(struct __track_dentry_update_args *)arg;
 	struct dentry *dentry = dentry_update->dentry;
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct inode *dir = dentry->d_parent->d_inode;
+	struct super_block *sb = inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	mutex_unlock(&ei->i_fc_lock);
+
+	if (IS_ENCRYPTED(dir)) {
+		ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_ENCRYPTED_FILENAME,
+					NULL);
+		mutex_lock(&ei->i_fc_lock);
+		return -EOPNOTSUPP;
+	}
+
 	node = kmem_cache_alloc(ext4_fc_dentry_cachep, GFP_NOFS);
 	if (!node) {
-		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM, NULL);
+		ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_NOMEM, NULL);
 		mutex_lock(&ei->i_fc_lock);
 		return -ENOMEM;
 	}
 
 	node->fcd_op = dentry_update->op;
-	node->fcd_parent = dentry->d_parent->d_inode->i_ino;
+	node->fcd_parent = dir->i_ino;
 	node->fcd_ino = inode->i_ino;
 	if (dentry->d_name.len > DNAME_INLINE_LEN) {
 		node->fcd_name.name = kmalloc(dentry->d_name.len, GFP_NOFS);
 		if (!node->fcd_name.name) {
 			kmem_cache_free(ext4_fc_dentry_cachep, node);
-			ext4_fc_mark_ineligible(inode->i_sb,
-				EXT4_FC_REASON_NOMEM, NULL);
+			ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_NOMEM, NULL);
 			mutex_lock(&ei->i_fc_lock);
 			return -ENOMEM;
 		}
@@ -595,6 +604,15 @@ static void ext4_fc_submit_bh(struct super_block *sb, bool is_tail)
 
 /* Ext4 commit path routines */
 
+/* memcpy to fc reserved space and update CRC */
+static void *ext4_fc_memcpy(struct super_block *sb, void *dst, const void *src,
+				int len, u32 *crc)
+{
+	if (crc)
+		*crc = ext4_chksum(EXT4_SB(sb), *crc, src, len);
+	return memcpy(dst, src, len);
+}
+
 /* memzero and update CRC */
 static void *ext4_fc_memzero(struct super_block *sb, void *dst, int len,
 				u32 *crc)
@@ -620,62 +638,59 @@ static void *ext4_fc_memzero(struct super_block *sb, void *dst, int len,
  */
 static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
 {
-	struct ext4_fc_tl *tl;
+	struct ext4_fc_tl tl;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct buffer_head *bh;
 	int bsize = sbi->s_journal->j_blocksize;
 	int ret, off = sbi->s_fc_bytes % bsize;
-	int pad_len;
+	int remaining;
+	u8 *dst;
 
 	/*
-	 * After allocating len, we should have space at least for a 0 byte
-	 * padding.
+	 * If 'len' is too long to fit in any block alongside a PAD tlv, then we
+	 * cannot fulfill the request.
 	 */
-	if (len + sizeof(struct ext4_fc_tl) > bsize)
+	if (len > bsize - EXT4_FC_TAG_BASE_LEN)
 		return NULL;
 
-	if (bsize - off - 1 > len + sizeof(struct ext4_fc_tl)) {
-		/*
-		 * Only allocate from current buffer if we have enough space for
-		 * this request AND we have space to add a zero byte padding.
-		 */
-		if (!sbi->s_fc_bh) {
-			ret = jbd2_fc_get_buf(EXT4_SB(sb)->s_journal, &bh);
-			if (ret)
-				return NULL;
-			sbi->s_fc_bh = bh;
-		}
+	if (!sbi->s_fc_bh) {
+		ret = jbd2_fc_get_buf(EXT4_SB(sb)->s_journal, &bh);
+		if (ret)
+			return NULL;
+		sbi->s_fc_bh = bh;
+	}
+	dst = sbi->s_fc_bh->b_data + off;
+
+	/*
+	 * Allocate the bytes in the current block if we can do so while still
+	 * leaving enough space for a PAD tlv.
+	 */
+	remaining = bsize - EXT4_FC_TAG_BASE_LEN - off;
+	if (len <= remaining) {
 		sbi->s_fc_bytes += len;
-		return sbi->s_fc_bh->b_data + off;
+		return dst;
 	}
-	/* Need to add PAD tag */
-	tl = (struct ext4_fc_tl *)(sbi->s_fc_bh->b_data + off);
-	tl->fc_tag = cpu_to_le16(EXT4_FC_TAG_PAD);
-	pad_len = bsize - off - 1 - sizeof(struct ext4_fc_tl);
-	tl->fc_len = cpu_to_le16(pad_len);
-	if (crc)
-		*crc = ext4_chksum(sbi, *crc, tl, sizeof(*tl));
-	if (pad_len > 0)
-		ext4_fc_memzero(sb, tl + 1, pad_len, crc);
+
+	/*
+	 * Else, terminate the current block with a PAD tlv, then allocate a new
+	 * block and allocate the bytes at the start of that new block.
+	 */
+
+	tl.fc_tag = cpu_to_le16(EXT4_FC_TAG_PAD);
+	tl.fc_len = cpu_to_le16(remaining);
+	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc);
+	ext4_fc_memzero(sb, dst + EXT4_FC_TAG_BASE_LEN, remaining, crc);
+
 	ext4_fc_submit_bh(sb, false);
 
 	ret = jbd2_fc_get_buf(EXT4_SB(sb)->s_journal, &bh);
 	if (ret)
 		return NULL;
 	sbi->s_fc_bh = bh;
-	sbi->s_fc_bytes = (sbi->s_fc_bytes / bsize + 1) * bsize + len;
+	sbi->s_fc_bytes += bsize - off + len;
 	return sbi->s_fc_bh->b_data;
 }
 
-/* memcpy to fc reserved space and update CRC */
-static void *ext4_fc_memcpy(struct super_block *sb, void *dst, const void *src,
-				int len, u32 *crc)
-{
-	if (crc)
-		*crc = ext4_chksum(EXT4_SB(sb), *crc, src, len);
-	return memcpy(dst, src, len);
-}
-
 /*
  * Complete a fast commit by writing tail tag.
  *
@@ -696,23 +711,25 @@ static int ext4_fc_write_tail(struct super_block *sb, u32 crc)
 	 * ext4_fc_reserve_space takes care of allocating an extra block if
 	 * there's no enough space on this block for accommodating this tail.
 	 */
-	dst = ext4_fc_reserve_space(sb, sizeof(tl) + sizeof(tail), &crc);
+	dst = ext4_fc_reserve_space(sb, EXT4_FC_TAG_BASE_LEN + sizeof(tail), &crc);
 	if (!dst)
 		return -ENOSPC;
 
 	off = sbi->s_fc_bytes % bsize;
 
 	tl.fc_tag = cpu_to_le16(EXT4_FC_TAG_TAIL);
-	tl.fc_len = cpu_to_le16(bsize - off - 1 + sizeof(struct ext4_fc_tail));
+	tl.fc_len = cpu_to_le16(bsize - off + sizeof(struct ext4_fc_tail));
 	sbi->s_fc_bytes = round_up(sbi->s_fc_bytes, bsize);
 
-	ext4_fc_memcpy(sb, dst, &tl, sizeof(tl), &crc);
-	dst += sizeof(tl);
+	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, &crc);
+	dst += EXT4_FC_TAG_BASE_LEN;
 	tail.fc_tid = cpu_to_le32(sbi->s_journal->j_running_transaction->t_tid);
 	ext4_fc_memcpy(sb, dst, &tail.fc_tid, sizeof(tail.fc_tid), &crc);
 	dst += sizeof(tail.fc_tid);
 	tail.fc_crc = cpu_to_le32(crc);
 	ext4_fc_memcpy(sb, dst, &tail.fc_crc, sizeof(tail.fc_crc), NULL);
+	dst += sizeof(tail.fc_crc);
+	memset(dst, 0, bsize - off); /* Don't leak uninitialized memory. */
 
 	ext4_fc_submit_bh(sb, true);
 
@@ -729,15 +746,15 @@ static bool ext4_fc_add_tlv(struct super_block *sb, u16 tag, u16 len, u8 *val,
 	struct ext4_fc_tl tl;
 	u8 *dst;
 
-	dst = ext4_fc_reserve_space(sb, sizeof(tl) + len, crc);
+	dst = ext4_fc_reserve_space(sb, EXT4_FC_TAG_BASE_LEN + len, crc);
 	if (!dst)
 		return false;
 
 	tl.fc_tag = cpu_to_le16(tag);
 	tl.fc_len = cpu_to_le16(len);
 
-	ext4_fc_memcpy(sb, dst, &tl, sizeof(tl), crc);
-	ext4_fc_memcpy(sb, dst + sizeof(tl), val, len, crc);
+	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc);
+	ext4_fc_memcpy(sb, dst + EXT4_FC_TAG_BASE_LEN, val, len, crc);
 
 	return true;
 }
@@ -749,8 +766,8 @@ static bool ext4_fc_add_dentry_tlv(struct super_block *sb, u32 *crc,
 	struct ext4_fc_dentry_info fcd;
 	struct ext4_fc_tl tl;
 	int dlen = fc_dentry->fcd_name.len;
-	u8 *dst = ext4_fc_reserve_space(sb, sizeof(tl) + sizeof(fcd) + dlen,
-					crc);
+	u8 *dst = ext4_fc_reserve_space(sb,
+			EXT4_FC_TAG_BASE_LEN + sizeof(fcd) + dlen, crc);
 
 	if (!dst)
 		return false;
@@ -759,8 +776,8 @@ static bool ext4_fc_add_dentry_tlv(struct super_block *sb, u32 *crc,
 	fcd.fc_ino = cpu_to_le32(fc_dentry->fcd_ino);
 	tl.fc_tag = cpu_to_le16(fc_dentry->fcd_op);
 	tl.fc_len = cpu_to_le16(sizeof(fcd) + dlen);
-	ext4_fc_memcpy(sb, dst, &tl, sizeof(tl), crc);
-	dst += sizeof(tl);
+	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc);
+	dst += EXT4_FC_TAG_BASE_LEN;
 	ext4_fc_memcpy(sb, dst, &fcd, sizeof(fcd), crc);
 	dst += sizeof(fcd);
 	ext4_fc_memcpy(sb, dst, fc_dentry->fcd_name.name, dlen, crc);
@@ -796,13 +813,13 @@ static int ext4_fc_write_inode(struct inode *inode, u32 *crc)
 
 	ret = -ECANCELED;
 	dst = ext4_fc_reserve_space(inode->i_sb,
-			sizeof(tl) + inode_len + sizeof(fc_inode.fc_ino), crc);
+		EXT4_FC_TAG_BASE_LEN + inode_len + sizeof(fc_inode.fc_ino), crc);
 	if (!dst)
 		goto err;
 
-	if (!ext4_fc_memcpy(inode->i_sb, dst, &tl, sizeof(tl), crc))
+	if (!ext4_fc_memcpy(inode->i_sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc))
 		goto err;
-	dst += sizeof(tl);
+	dst += EXT4_FC_TAG_BASE_LEN;
 	if (!ext4_fc_memcpy(inode->i_sb, dst, &fc_inode, sizeof(fc_inode), crc))
 		goto err;
 	dst += sizeof(fc_inode);
@@ -840,8 +857,8 @@ static int ext4_fc_write_inode_data(struct inode *inode, u32 *crc)
 	mutex_unlock(&ei->i_fc_lock);
 
 	cur_lblk_off = old_blk_size;
-	jbd_debug(1, "%s: will try writing %d to %d for inode %ld\n",
-		  __func__, cur_lblk_off, new_blk_size, inode->i_ino);
+	ext4_debug("will try writing %d to %d for inode %ld\n",
+		   cur_lblk_off, new_blk_size, inode->i_ino);
 
 	while (cur_lblk_off <= new_blk_size) {
 		map.m_lblk = cur_lblk_off;
@@ -1096,7 +1113,7 @@ static void ext4_fc_update_stats(struct super_block *sb, int status,
 {
 	struct ext4_fc_stats *stats = &EXT4_SB(sb)->s_fc_stats;
 
-	jbd_debug(1, "Fast commit ended with status = %d", status);
+	ext4_debug("Fast commit ended with status = %d", status);
 	if (status == EXT4_FC_STATUS_OK) {
 		stats->fc_num_commits++;
 		stats->fc_numblks += nblks;
@@ -1266,7 +1283,7 @@ struct dentry_info_args {
 };
 
 static inline void tl_to_darg(struct dentry_info_args *darg,
-			      struct  ext4_fc_tl *tl, u8 *val)
+			      struct ext4_fc_tl *tl, u8 *val)
 {
 	struct ext4_fc_dentry_info fcd;
 
@@ -1275,8 +1292,14 @@ static inline void tl_to_darg(struct dentry_info_args *darg,
 	darg->parent_ino = le32_to_cpu(fcd.fc_parent_ino);
 	darg->ino = le32_to_cpu(fcd.fc_ino);
 	darg->dname = val + offsetof(struct ext4_fc_dentry_info, fc_dname);
-	darg->dname_len = le16_to_cpu(tl->fc_len) -
-		sizeof(struct ext4_fc_dentry_info);
+	darg->dname_len = tl->fc_len - sizeof(struct ext4_fc_dentry_info);
+}
+
+static inline void ext4_fc_get_tl(struct ext4_fc_tl *tl, u8 *val)
+{
+	memcpy(tl, val, EXT4_FC_TAG_BASE_LEN);
+	tl->fc_len = le16_to_cpu(tl->fc_len);
+	tl->fc_tag = le16_to_cpu(tl->fc_tag);
 }
 
 /* Unlink replay function */
@@ -1298,19 +1321,19 @@ static int ext4_fc_replay_unlink(struct super_block *sb, struct ext4_fc_tl *tl,
 	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
 
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "Inode %d not found", darg.ino);
+		ext4_debug("Inode %d not found", darg.ino);
 		return 0;
 	}
 
 	old_parent = ext4_iget(sb, darg.parent_ino,
 				EXT4_IGET_NORMAL);
 	if (IS_ERR(old_parent)) {
-		jbd_debug(1, "Dir with inode  %d not found", darg.parent_ino);
+		ext4_debug("Dir with inode %d not found", darg.parent_ino);
 		iput(inode);
 		return 0;
 	}
 
-	ret = __ext4_unlink(NULL, old_parent, &entry, inode);
+	ret = __ext4_unlink(old_parent, &entry, inode, NULL);
 	/* -ENOENT ok coz it might not exist anymore. */
 	if (ret == -ENOENT)
 		ret = 0;
@@ -1330,21 +1353,21 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
 
 	dir = ext4_iget(sb, darg->parent_ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(dir)) {
-		jbd_debug(1, "Dir with inode %d not found.", darg->parent_ino);
+		ext4_debug("Dir with inode %d not found.", darg->parent_ino);
 		dir = NULL;
 		goto out;
 	}
 
 	dentry_dir = d_obtain_alias(dir);
 	if (IS_ERR(dentry_dir)) {
-		jbd_debug(1, "Failed to obtain dentry");
+		ext4_debug("Failed to obtain dentry");
 		dentry_dir = NULL;
 		goto out;
 	}
 
 	dentry_inode = d_alloc(dentry_dir, &qstr_dname);
 	if (!dentry_inode) {
-		jbd_debug(1, "Inode dentry not created.");
+		ext4_debug("Inode dentry not created.");
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -1357,7 +1380,7 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
 	 * could complete.
 	 */
 	if (ret && ret != -EEXIST) {
-		jbd_debug(1, "Failed to link\n");
+		ext4_debug("Failed to link\n");
 		goto out;
 	}
 
@@ -1391,7 +1414,7 @@ static int ext4_fc_replay_link(struct super_block *sb, struct ext4_fc_tl *tl,
 
 	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "Inode not found.");
+		ext4_debug("Inode not found.");
 		return 0;
 	}
 
@@ -1441,7 +1464,7 @@ static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl,
 	struct ext4_inode *raw_fc_inode;
 	struct inode *inode = NULL;
 	struct ext4_iloc iloc;
-	int inode_len, ino, ret, tag = le16_to_cpu(tl->fc_tag);
+	int inode_len, ino, ret, tag = tl->fc_tag;
 	struct ext4_extent_header *eh;
 
 	memcpy(&fc_inode, val, sizeof(fc_inode));
@@ -1466,7 +1489,7 @@ static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl,
 	if (ret)
 		goto out;
 
-	inode_len = le16_to_cpu(tl->fc_len) - sizeof(struct ext4_fc_inode);
+	inode_len = tl->fc_len - sizeof(struct ext4_fc_inode);
 	raw_inode = ext4_raw_inode(&iloc);
 
 	memcpy(raw_inode, raw_fc_inode, offsetof(struct ext4_inode, i_block));
@@ -1501,7 +1524,7 @@ static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl,
 	/* Given that we just wrote the inode on disk, this SHOULD succeed. */
 	inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "Inode not found.");
+		ext4_debug("Inode not found.");
 		return -EFSCORRUPTED;
 	}
 
@@ -1554,7 +1577,7 @@ static int ext4_fc_replay_create(struct super_block *sb, struct ext4_fc_tl *tl,
 
 	inode = ext4_iget(sb, darg.ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "inode %d not found.", darg.ino);
+		ext4_debug("inode %d not found.", darg.ino);
 		inode = NULL;
 		ret = -EINVAL;
 		goto out;
@@ -1567,7 +1590,7 @@ static int ext4_fc_replay_create(struct super_block *sb, struct ext4_fc_tl *tl,
 		 */
 		dir = ext4_iget(sb, darg.parent_ino, EXT4_IGET_NORMAL);
 		if (IS_ERR(dir)) {
-			jbd_debug(1, "Dir %d not found.", darg.ino);
+			ext4_debug("Dir %d not found.", darg.ino);
 			goto out;
 		}
 		ret = ext4_init_new_dir(NULL, dir, inode);
@@ -1655,7 +1678,7 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 
 	inode = ext4_iget(sb, le32_to_cpu(fc_add_ex.fc_ino), EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "Inode not found.");
+		ext4_debug("Inode not found.");
 		return 0;
 	}
 
@@ -1669,7 +1692,7 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 
 	cur = start;
 	remaining = len;
-	jbd_debug(1, "ADD_RANGE, lblk %d, pblk %lld, len %d, unwritten %d, inode %ld\n",
+	ext4_debug("ADD_RANGE, lblk %d, pblk %lld, len %d, unwritten %d, inode %ld\n",
 		  start, start_pblk, len, ext4_ext_is_unwritten(ex),
 		  inode->i_ino);
 
@@ -1730,7 +1753,7 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 		}
 
 		/* Range is mapped and needs a state change */
-		jbd_debug(1, "Converting from %ld to %d %lld",
+		ext4_debug("Converting from %ld to %d %lld",
 				map.m_flags & EXT4_MAP_UNWRITTEN,
 			ext4_ext_is_unwritten(ex), map.m_pblk);
 		ret = ext4_ext_replay_update_ex(inode, cur, map.m_len,
@@ -1773,7 +1796,7 @@ ext4_fc_replay_del_range(struct super_block *sb, struct ext4_fc_tl *tl,
 
 	inode = ext4_iget(sb, le32_to_cpu(lrange.fc_ino), EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
-		jbd_debug(1, "Inode %d not found", le32_to_cpu(lrange.fc_ino));
+		ext4_debug("Inode %d not found", le32_to_cpu(lrange.fc_ino));
 		return 0;
 	}
 
@@ -1781,7 +1804,7 @@ ext4_fc_replay_del_range(struct super_block *sb, struct ext4_fc_tl *tl,
 	if (ret)
 		goto out;
 
-	jbd_debug(1, "DEL_RANGE, inode %ld, lblk %d, len %d\n",
+	ext4_debug("DEL_RANGE, inode %ld, lblk %d, len %d\n",
 			inode->i_ino, le32_to_cpu(lrange.fc_lblk),
 			le32_to_cpu(lrange.fc_len));
 	while (remaining > 0) {
@@ -1830,7 +1853,7 @@ static void ext4_fc_set_bitmaps_and_counters(struct super_block *sb)
 		inode = ext4_iget(sb, state->fc_modified_inodes[i],
 			EXT4_IGET_NORMAL);
 		if (IS_ERR(inode)) {
-			jbd_debug(1, "Inode %d not found.",
+			ext4_debug("Inode %d not found.",
 				state->fc_modified_inodes[i]);
 			continue;
 		}
@@ -1896,6 +1919,33 @@ void ext4_fc_replay_cleanup(struct super_block *sb)
 	kfree(sbi->s_fc_replay_state.fc_modified_inodes);
 }
 
+static bool ext4_fc_value_len_isvalid(struct ext4_sb_info *sbi,
+				      int tag, int len)
+{
+	switch (tag) {
+	case EXT4_FC_TAG_ADD_RANGE:
+		return len == sizeof(struct ext4_fc_add_range);
+	case EXT4_FC_TAG_DEL_RANGE:
+		return len == sizeof(struct ext4_fc_del_range);
+	case EXT4_FC_TAG_CREAT:
+	case EXT4_FC_TAG_LINK:
+	case EXT4_FC_TAG_UNLINK:
+		len -= sizeof(struct ext4_fc_dentry_info);
+		return len >= 1 && len <= EXT4_NAME_LEN;
+	case EXT4_FC_TAG_INODE:
+		len -= sizeof(struct ext4_fc_inode);
+		return len >= EXT4_GOOD_OLD_INODE_SIZE &&
+			len <= sbi->s_inode_size;
+	case EXT4_FC_TAG_PAD:
+		return true; /* padding can have any length */
+	case EXT4_FC_TAG_TAIL:
+		return len >= sizeof(struct ext4_fc_tail);
+	case EXT4_FC_TAG_HEAD:
+		return len == sizeof(struct ext4_fc_head);
+	}
+	return false;
+}
+
 /*
  * Recovery Scan phase handler
  *
@@ -1931,7 +1981,7 @@ static int ext4_fc_replay_scan(journal_t *journal,
 	state = &sbi->s_fc_replay_state;
 
 	start = (u8 *)bh->b_data;
-	end = (__u8 *)bh->b_data + journal->j_blocksize - 1;
+	end = start + journal->j_blocksize;
 
 	if (state->fc_replay_expected_off == 0) {
 		state->fc_cur_tag = 0;
@@ -1952,12 +2002,19 @@ static int ext4_fc_replay_scan(journal_t *journal,
 	}
 
 	state->fc_replay_expected_off++;
-	for (cur = start; cur < end; cur = cur + sizeof(tl) + le16_to_cpu(tl.fc_len)) {
-		memcpy(&tl, cur, sizeof(tl));
-		val = cur + sizeof(tl);
-		jbd_debug(3, "Scan phase, tag:%s, blk %lld\n",
-			  tag2str(le16_to_cpu(tl.fc_tag)), bh->b_blocknr);
-		switch (le16_to_cpu(tl.fc_tag)) {
+	for (cur = start; cur <= end - EXT4_FC_TAG_BASE_LEN;
+	     cur = cur + EXT4_FC_TAG_BASE_LEN + tl.fc_len) {
+		ext4_fc_get_tl(&tl, cur);
+		val = cur + EXT4_FC_TAG_BASE_LEN;
+		if (tl.fc_len > end - val ||
+		    !ext4_fc_value_len_isvalid(sbi, tl.fc_tag, tl.fc_len)) {
+			ret = state->fc_replay_num_tags ?
+				JBD2_FC_REPLAY_STOP : -ECANCELED;
+			goto out_err;
+		}
+		ext4_debug("Scan phase, tag:%s, blk %lld\n",
+			   tag2str(tl.fc_tag), bh->b_blocknr);
+		switch (tl.fc_tag) {
 		case EXT4_FC_TAG_ADD_RANGE:
 			memcpy(&ext, val, sizeof(ext));
 			ex = (struct ext4_extent *)&ext.fc_ex;
@@ -1977,13 +2034,13 @@ static int ext4_fc_replay_scan(journal_t *journal,
 		case EXT4_FC_TAG_PAD:
 			state->fc_cur_tag++;
 			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
-					sizeof(tl) + le16_to_cpu(tl.fc_len));
+				EXT4_FC_TAG_BASE_LEN + tl.fc_len);
 			break;
 		case EXT4_FC_TAG_TAIL:
 			state->fc_cur_tag++;
 			memcpy(&tail, val, sizeof(tail));
 			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
-						sizeof(tl) +
+						EXT4_FC_TAG_BASE_LEN +
 						offsetof(struct ext4_fc_tail,
 						fc_crc));
 			if (le32_to_cpu(tail.fc_tid) == expected_tid &&
@@ -2010,7 +2067,7 @@ static int ext4_fc_replay_scan(journal_t *journal,
 			}
 			state->fc_cur_tag++;
 			state->fc_crc = ext4_chksum(sbi, state->fc_crc, cur,
-					    sizeof(tl) + le16_to_cpu(tl.fc_len));
+				EXT4_FC_TAG_BASE_LEN + tl.fc_len);
 			break;
 		default:
 			ret = state->fc_replay_num_tags ?
@@ -2050,7 +2107,7 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 		sbi->s_mount_state |= EXT4_FC_REPLAY;
 	}
 	if (!sbi->s_fc_replay_state.fc_replay_num_tags) {
-		jbd_debug(1, "Replay stops\n");
+		ext4_debug("Replay stops\n");
 		ext4_fc_set_bitmaps_and_counters(sb);
 		return 0;
 	}
@@ -2063,21 +2120,22 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 #endif
 
 	start = (u8 *)bh->b_data;
-	end = (__u8 *)bh->b_data + journal->j_blocksize - 1;
+	end = start + journal->j_blocksize;
 
-	for (cur = start; cur < end; cur = cur + sizeof(tl) + le16_to_cpu(tl.fc_len)) {
-		memcpy(&tl, cur, sizeof(tl));
-		val = cur + sizeof(tl);
+	for (cur = start; cur <= end - EXT4_FC_TAG_BASE_LEN;
+	     cur = cur + EXT4_FC_TAG_BASE_LEN + tl.fc_len) {
+		ext4_fc_get_tl(&tl, cur);
+		val = cur + EXT4_FC_TAG_BASE_LEN;
 
 		if (state->fc_replay_num_tags == 0) {
 			ret = JBD2_FC_REPLAY_STOP;
 			ext4_fc_set_bitmaps_and_counters(sb);
 			break;
 		}
-		jbd_debug(3, "Replay phase, tag:%s\n",
-				tag2str(le16_to_cpu(tl.fc_tag)));
+
+		ext4_debug("Replay phase, tag:%s\n", tag2str(tl.fc_tag));
 		state->fc_replay_num_tags--;
-		switch (le16_to_cpu(tl.fc_tag)) {
+		switch (tl.fc_tag) {
 		case EXT4_FC_TAG_LINK:
 			ret = ext4_fc_replay_link(sb, &tl, val);
 			break;
@@ -2098,19 +2156,18 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 			break;
 		case EXT4_FC_TAG_PAD:
 			trace_ext4_fc_replay(sb, EXT4_FC_TAG_PAD, 0,
-					     le16_to_cpu(tl.fc_len), 0);
+					     tl.fc_len, 0);
 			break;
 		case EXT4_FC_TAG_TAIL:
-			trace_ext4_fc_replay(sb, EXT4_FC_TAG_TAIL, 0,
-					     le16_to_cpu(tl.fc_len), 0);
+			trace_ext4_fc_replay(sb, EXT4_FC_TAG_TAIL,
+					     0, tl.fc_len, 0);
 			memcpy(&tail, val, sizeof(tail));
 			WARN_ON(le32_to_cpu(tail.fc_tid) != expected_tid);
 			break;
 		case EXT4_FC_TAG_HEAD:
 			break;
 		default:
-			trace_ext4_fc_replay(sb, le16_to_cpu(tl.fc_tag), 0,
-					     le16_to_cpu(tl.fc_len), 0);
+			trace_ext4_fc_replay(sb, tl.fc_tag, 0, tl.fc_len, 0);
 			ret = -ECANCELED;
 			break;
 		}
@@ -2134,17 +2191,17 @@ void ext4_fc_init(struct super_block *sb, journal_t *journal)
 	journal->j_fc_cleanup_callback = ext4_fc_cleanup;
 }
 
-static const char *fc_ineligible_reasons[] = {
-	"Extended attributes changed",
-	"Cross rename",
-	"Journal flag changed",
-	"Insufficient memory",
-	"Swap boot",
-	"Resize",
-	"Dir renamed",
-	"Falloc range op",
-	"Data journalling",
-	"FC Commit Failed"
+static const char * const fc_ineligible_reasons[] = {
+	[EXT4_FC_REASON_XATTR] = "Extended attributes changed",
+	[EXT4_FC_REASON_CROSS_RENAME] = "Cross rename",
+	[EXT4_FC_REASON_JOURNAL_FLAG_CHANGE] = "Journal flag changed",
+	[EXT4_FC_REASON_NOMEM] = "Insufficient memory",
+	[EXT4_FC_REASON_SWAP_BOOT] = "Swap boot",
+	[EXT4_FC_REASON_RESIZE] = "Resize",
+	[EXT4_FC_REASON_RENAME_DIR] = "Dir renamed",
+	[EXT4_FC_REASON_FALLOC_RANGE] = "Falloc range op",
+	[EXT4_FC_REASON_INODE_JOURNAL_DATA] = "Data journalling",
+	[EXT4_FC_REASON_ENCRYPTED_FILENAME] = "Encrypted filename",
 };
 
 int ext4_fc_info_show(struct seq_file *seq, void *v)
diff --git a/fs/ext4/fast_commit.h b/fs/ext4/fast_commit.h
index 083ad1cb705a..2cbd317eda26 100644
--- a/fs/ext4/fast_commit.h
+++ b/fs/ext4/fast_commit.h
@@ -58,7 +58,7 @@ struct ext4_fc_dentry_info {
 	__u8 fc_dname[0];
 };
 
-/* Value structure for EXT4_FC_TAG_INODE and EXT4_FC_TAG_INODE_PARTIAL. */
+/* Value structure for EXT4_FC_TAG_INODE. */
 struct ext4_fc_inode {
 	__le32 fc_ino;
 	__u8 fc_raw_inode[0];
@@ -70,6 +70,9 @@ struct ext4_fc_tail {
 	__le32 fc_crc;
 };
 
+/* Tag base length */
+#define EXT4_FC_TAG_BASE_LEN (sizeof(struct ext4_fc_tl))
+
 /*
  * Fast commit status codes
  */
@@ -93,7 +96,7 @@ enum {
 	EXT4_FC_REASON_RENAME_DIR,
 	EXT4_FC_REASON_FALLOC_RANGE,
 	EXT4_FC_REASON_INODE_JOURNAL_DATA,
-	EXT4_FC_COMMIT_FAILED,
+	EXT4_FC_REASON_ENCRYPTED_FILENAME,
 	EXT4_FC_REASON_MAX
 };
 
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 89efa78ed4b2..9813cc4b7b2a 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -148,6 +148,7 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 	struct super_block *sb = inode->i_sb;
 	Indirect *p = chain;
 	struct buffer_head *bh;
+	unsigned int key;
 	int ret = -EIO;
 
 	*err = 0;
@@ -156,7 +157,13 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 	if (!p->key)
 		goto no_block;
 	while (--depth) {
-		bh = sb_getblk(sb, le32_to_cpu(p->key));
+		key = le32_to_cpu(p->key);
+		if (key > ext4_blocks_count(EXT4_SB(sb)->s_es)) {
+			/* the block was out of range */
+			ret = -EFSCORRUPTED;
+			goto failure;
+		}
+		bh = sb_getblk(sb, key);
 		if (unlikely(!bh)) {
 			ret = -ENOMEM;
 			goto failure;
@@ -460,7 +467,7 @@ static int ext4_splice_branch(handle_t *handle,
 		 * the new i_size.  But that is not done here - it is done in
 		 * generic_commit_write->__mark_inode_dirty->ext4_dirty_inode.
 		 */
-		jbd_debug(5, "splicing indirect only\n");
+		ext4_debug("splicing indirect only\n");
 		BUFFER_TRACE(where->bh, "call ext4_handle_dirty_metadata");
 		err = ext4_handle_dirty_metadata(handle, ar->inode, where->bh);
 		if (err)
@@ -472,7 +479,7 @@ static int ext4_splice_branch(handle_t *handle,
 		err = ext4_mark_inode_dirty(handle, ar->inode);
 		if (unlikely(err))
 			goto err_out;
-		jbd_debug(5, "splicing direct\n");
+		ext4_debug("splicing direct\n");
 	}
 	return err;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bdadbe57ea80..0a63863bc58c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -225,13 +225,13 @@ void ext4_evict_inode(struct inode *inode)
 
 	/*
 	 * For inodes with journalled data, transaction commit could have
-	 * dirtied the inode. Flush worker is ignoring it because of I_FREEING
-	 * flag but we still need to remove the inode from the writeback lists.
+	 * dirtied the inode. And for inodes with dioread_nolock, unwritten
+	 * extents converting worker could merge extents and also have dirtied
+	 * the inode. Flush worker is ignoring it because of I_FREEING flag but
+	 * we still need to remove the inode from the writeback lists.
 	 */
-	if (!list_empty_careful(&inode->i_io_list)) {
-		WARN_ON_ONCE(!ext4_should_journal_data(inode));
+	if (!list_empty_careful(&inode->i_io_list))
 		inode_io_list_del(inode);
-	}
 
 	/*
 	 * Protect us against freezing - iput() caller didn't have to have any
@@ -338,6 +338,12 @@ void ext4_evict_inode(struct inode *inode)
 	ext4_xattr_inode_array_free(ea_inode_array);
 	return;
 no_delete:
+	/*
+	 * Check out some where else accidentally dirty the evicting inode,
+	 * which may probably cause inode use-after-free issues later.
+	 */
+	WARN_ON_ONCE(!list_empty_careful(&inode->i_io_list));
+
 	if (!list_empty(&EXT4_I(inode)->i_fc_list))
 		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM, NULL);
 	ext4_clear_inode(inode);	/* We must guarantee clearing of inode... */
@@ -1298,7 +1304,8 @@ static int ext4_write_end(struct file *file,
 
 	trace_ext4_write_end(inode, pos, len, copied);
 
-	if (ext4_has_inline_data(inode))
+	if (ext4_has_inline_data(inode) &&
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
 		return ext4_write_inline_data_end(inode, pos, len, copied, page);
 
 	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
@@ -4198,7 +4205,8 @@ int ext4_truncate(struct inode *inode)
 
 	/* If we zero-out tail of the page, we have to create jinode for jbd2 */
 	if (inode->i_size & (inode->i_sb->s_blocksize - 1)) {
-		if (ext4_inode_attach_jinode(inode) < 0)
+		err = ext4_inode_attach_jinode(inode);
+		if (err)
 			goto out_trace;
 	}
 
@@ -4299,9 +4307,17 @@ static int __ext4_get_inode_loc(struct super_block *sb, unsigned long ino,
 	inodes_per_block = EXT4_SB(sb)->s_inodes_per_block;
 	inode_offset = ((ino - 1) %
 			EXT4_INODES_PER_GROUP(sb));
-	block = ext4_inode_table(sb, gdp) + (inode_offset / inodes_per_block);
 	iloc->offset = (inode_offset % inodes_per_block) * EXT4_INODE_SIZE(sb);
 
+	block = ext4_inode_table(sb, gdp);
+	if ((block <= le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block)) ||
+	    (block >= ext4_blocks_count(EXT4_SB(sb)->s_es))) {
+		ext4_error(sb, "Invalid inode table block %llu in "
+			   "block_group %u", block, iloc->block_group);
+		return -EFSCORRUPTED;
+	}
+	block += (inode_offset / inodes_per_block);
+
 	bh = sb_getblk(sb, block);
 	if (unlikely(!bh))
 		return -ENOMEM;
@@ -4876,8 +4892,14 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	if (IS_CASEFOLDED(inode) && !ext4_has_feature_casefold(inode->i_sb))
 		ext4_error_inode(inode, function, line, 0,
 				 "casefold flag without casefold feature");
-	brelse(iloc.bh);
+	if (is_bad_inode(inode) && !(flags & EXT4_IGET_BAD)) {
+		ext4_error_inode(inode, function, line, 0,
+				 "bad inode without EXT4_IGET_BAD flag");
+		ret = -EUCLEAN;
+		goto bad_inode;
+	}
 
+	brelse(iloc.bh);
 	unlock_new_inode(inode);
 	return inode;
 
@@ -5198,7 +5220,7 @@ int ext4_write_inode(struct inode *inode, struct writeback_control *wbc)
 
 	if (EXT4_SB(inode->i_sb)->s_journal) {
 		if (ext4_journal_current_handle()) {
-			jbd_debug(1, "called recursively, non-PF_MEMALLOC!\n");
+			ext4_debug("called recursively, non-PF_MEMALLOC!\n");
 			dump_stack();
 			return -EIO;
 		}
@@ -5791,6 +5813,14 @@ static int __ext4_expand_extra_isize(struct inode *inode,
 		return 0;
 	}
 
+	/*
+	 * We may need to allocate external xattr block so we need quotas
+	 * initialized. Here we can be called with various locks held so we
+	 * cannot affort to initialize quotas ourselves. So just bail.
+	 */
+	if (dquot_initialize_needed(inode))
+		return -EAGAIN;
+
 	/* try to expand with EAs present */
 	error = ext4_expand_extra_isize_ea(inode, new_extra_isize,
 					   raw_inode, handle);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index f61b59045c6d..2e6d03e5790e 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -124,7 +124,8 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	blkcnt_t blocks;
 	unsigned short bytes;
 
-	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO, EXT4_IGET_SPECIAL);
+	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO,
+			EXT4_IGET_SPECIAL | EXT4_IGET_BAD);
 	if (IS_ERR(inode_bl))
 		return PTR_ERR(inode_bl);
 	ei_bl = EXT4_I(inode_bl);
@@ -174,7 +175,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	/* Protect extent tree against block allocations via delalloc */
 	ext4_double_down_write_data_sem(inode, inode_bl);
 
-	if (inode_bl->i_nlink == 0) {
+	if (is_bad_inode(inode_bl) || !S_ISREG(inode_bl->i_mode)) {
 		/* this inode has never been used as a BOOT_LOADER */
 		set_nlink(inode_bl, 1);
 		i_uid_write(inode_bl, 0);
@@ -491,6 +492,10 @@ static int ext4_ioctl_setproject(struct inode *inode, __u32 projid)
 	if (ext4_is_quota_file(inode))
 		return err;
 
+	err = dquot_initialize(inode);
+	if (err)
+		return err;
+
 	err = ext4_get_inode_loc(inode, &iloc);
 	if (err)
 		return err;
@@ -506,10 +511,6 @@ static int ext4_ioctl_setproject(struct inode *inode, __u32 projid)
 		brelse(iloc.bh);
 	}
 
-	err = dquot_initialize(inode);
-	if (err)
-		return err;
-
 	handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
 		EXT4_QUOTA_INIT_BLOCKS(sb) +
 		EXT4_QUOTA_DEL_BLOCKS(sb) + 3);
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index b8cf3e986b00..1e6cc6c21d60 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3204,14 +3204,20 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	return retval;
 }
 
-int __ext4_unlink(handle_t *handle, struct inode *dir, const struct qstr *d_name,
-		  struct inode *inode)
+int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
+		  struct inode *inode,
+		  struct dentry *dentry /* NULL during fast_commit recovery */)
 {
 	int retval = -ENOENT;
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de;
+	handle_t *handle;
 	int skip_remove_dentry = 0;
 
+	/*
+	 * Keep this outside the transaction; it may have to set up the
+	 * directory's encryption key, which isn't GFP_NOFS-safe.
+	 */
 	bh = ext4_find_entry(dir, d_name, &de, NULL);
 	if (IS_ERR(bh))
 		return PTR_ERR(bh);
@@ -3228,7 +3234,14 @@ int __ext4_unlink(handle_t *handle, struct inode *dir, const struct qstr *d_name
 		if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
 			skip_remove_dentry = 1;
 		else
-			goto out;
+			goto out_bh;
+	}
+
+	handle = ext4_journal_start(dir, EXT4_HT_DIR,
+				    EXT4_DATA_TRANS_BLOCKS(dir->i_sb));
+	if (IS_ERR(handle)) {
+		retval = PTR_ERR(handle);
+		goto out_bh;
 	}
 
 	if (IS_DIRSYNC(dir))
@@ -3237,12 +3250,12 @@ int __ext4_unlink(handle_t *handle, struct inode *dir, const struct qstr *d_name
 	if (!skip_remove_dentry) {
 		retval = ext4_delete_entry(handle, dir, de, bh);
 		if (retval)
-			goto out;
+			goto out_handle;
 		dir->i_ctime = dir->i_mtime = current_time(dir);
 		ext4_update_dx_flag(dir);
 		retval = ext4_mark_inode_dirty(handle, dir);
 		if (retval)
-			goto out;
+			goto out_handle;
 	} else {
 		retval = 0;
 	}
@@ -3255,15 +3268,17 @@ int __ext4_unlink(handle_t *handle, struct inode *dir, const struct qstr *d_name
 		ext4_orphan_add(handle, inode);
 	inode->i_ctime = current_time(inode);
 	retval = ext4_mark_inode_dirty(handle, inode);
-
-out:
+	if (dentry && !retval)
+		ext4_fc_track_unlink(handle, dentry);
+out_handle:
+	ext4_journal_stop(handle);
+out_bh:
 	brelse(bh);
 	return retval;
 }
 
 static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 {
-	handle_t *handle;
 	int retval;
 
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(dir->i_sb))))
@@ -3281,16 +3296,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	if (retval)
 		goto out_trace;
 
-	handle = ext4_journal_start(dir, EXT4_HT_DIR,
-				    EXT4_DATA_TRANS_BLOCKS(dir->i_sb));
-	if (IS_ERR(handle)) {
-		retval = PTR_ERR(handle);
-		goto out_trace;
-	}
-
-	retval = __ext4_unlink(handle, dir, &dentry->d_name, d_inode(dentry));
-	if (!retval)
-		ext4_fc_track_unlink(handle, dentry);
+	retval = __ext4_unlink(dir, &dentry->d_name, d_inode(dentry), dentry);
 #ifdef CONFIG_UNICODE
 	/* VFS negative dentries are incompatible with Encoding and
 	 * Case-insensitiveness. Eventually we'll want avoid
@@ -3301,8 +3307,6 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	if (IS_CASEFOLDED(dir))
 		d_invalidate(dentry);
 #endif
-	if (handle)
-		ext4_journal_stop(handle);
 
 out_trace:
 	trace_ext4_unlink_exit(dentry, retval);
@@ -3806,6 +3810,9 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 		return -EXDEV;
 
 	retval = dquot_initialize(old.dir);
+	if (retval)
+		return retval;
+	retval = dquot_initialize(old.inode);
 	if (retval)
 		return retval;
 	retval = dquot_initialize(new.dir);
diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 53adc8f570a3..c26c404ac58b 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -181,8 +181,8 @@ int ext4_orphan_add(handle_t *handle, struct inode *inode)
 	} else
 		brelse(iloc.bh);
 
-	jbd_debug(4, "superblock will point to %lu\n", inode->i_ino);
-	jbd_debug(4, "orphan inode %lu will point to %d\n",
+	ext4_debug("superblock will point to %lu\n", inode->i_ino);
+	ext4_debug("orphan inode %lu will point to %d\n",
 			inode->i_ino, NEXT_ORPHAN(inode));
 out:
 	ext4_std_error(sb, err);
@@ -251,7 +251,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	}
 
 	mutex_lock(&sbi->s_orphan_lock);
-	jbd_debug(4, "remove inode %lu from orphan list\n", inode->i_ino);
+	ext4_debug("remove inode %lu from orphan list\n", inode->i_ino);
 
 	prev = ei->i_orphan.prev;
 	list_del_init(&ei->i_orphan);
@@ -267,7 +267,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 
 	ino_next = NEXT_ORPHAN(inode);
 	if (prev == &sbi->s_orphan) {
-		jbd_debug(4, "superblock will point to %u\n", ino_next);
+		ext4_debug("superblock will point to %u\n", ino_next);
 		BUFFER_TRACE(sbi->s_sbh, "get_write_access");
 		err = ext4_journal_get_write_access(handle, inode->i_sb,
 						    sbi->s_sbh, EXT4_JTR_NONE);
@@ -286,7 +286,7 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 		struct inode *i_prev =
 			&list_entry(prev, struct ext4_inode_info, i_orphan)->vfs_inode;
 
-		jbd_debug(4, "orphan inode %lu will point to %u\n",
+		ext4_debug("orphan inode %lu will point to %u\n",
 			  i_prev->i_ino, ino_next);
 		err = ext4_reserve_inode_write(handle, i_prev, &iloc2);
 		if (err) {
@@ -332,8 +332,8 @@ static void ext4_process_orphan(struct inode *inode,
 			ext4_msg(sb, KERN_DEBUG,
 				"%s: truncating inode %lu to %lld bytes",
 				__func__, inode->i_ino, inode->i_size);
-		jbd_debug(2, "truncating inode %lu to %lld bytes\n",
-			  inode->i_ino, inode->i_size);
+		ext4_debug("truncating inode %lu to %lld bytes\n",
+			   inode->i_ino, inode->i_size);
 		inode_lock(inode);
 		truncate_inode_pages(inode->i_mapping, inode->i_size);
 		ret = ext4_truncate(inode);
@@ -353,8 +353,8 @@ static void ext4_process_orphan(struct inode *inode,
 			ext4_msg(sb, KERN_DEBUG,
 				"%s: deleting unreferenced inode %lu",
 				__func__, inode->i_ino);
-		jbd_debug(2, "deleting unreferenced inode %lu\n",
-			  inode->i_ino);
+		ext4_debug("deleting unreferenced inode %lu\n",
+			   inode->i_ino);
 		(*nr_orphans)++;
 	}
 	iput(inode);  /* The delete magic happens here! */
@@ -391,7 +391,7 @@ void ext4_orphan_cleanup(struct super_block *sb, struct ext4_super_block *es)
 	int inodes_per_ob = ext4_inodes_per_orphan_block(sb);
 
 	if (!es->s_last_orphan && !oi->of_blocks) {
-		jbd_debug(4, "no orphan inodes to clean up\n");
+		ext4_debug("no orphan inodes to clean up\n");
 		return;
 	}
 
@@ -412,10 +412,10 @@ void ext4_orphan_cleanup(struct super_block *sb, struct ext4_super_block *es)
 		/* don't clear list on RO mount w/ errors */
 		if (es->s_last_orphan && !(s_flags & SB_RDONLY)) {
 			ext4_msg(sb, KERN_INFO, "Errors on filesystem, "
-				  "clearing orphan list.\n");
+				  "clearing orphan list.");
 			es->s_last_orphan = 0;
 		}
-		jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
+		ext4_debug("Skipping orphan recovery on fs with errors.\n");
 		return;
 	}
 
@@ -459,7 +459,7 @@ void ext4_orphan_cleanup(struct super_block *sb, struct ext4_super_block *es)
 		 * so, skip the rest.
 		 */
 		if (EXT4_SB(sb)->s_mount_state & EXT4_ERROR_FS) {
-			jbd_debug(1, "Skipping orphan recovery on fs with errors.\n");
+			ext4_debug("Skipping orphan recovery on fs with errors.\n");
 			es->s_last_orphan = 0;
 			break;
 		}
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 62bbfe8960f3..405c68085055 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1557,8 +1557,8 @@ static int ext4_flex_group_add(struct super_block *sb,
 		int meta_bg = ext4_has_feature_meta_bg(sb);
 		sector_t old_gdb = 0;
 
-		update_backups(sb, sbi->s_sbh->b_blocknr, (char *)es,
-			       sizeof(struct ext4_super_block), 0);
+		update_backups(sb, ext4_group_first_block_no(sb, 0),
+			       (char *)es, sizeof(struct ext4_super_block), 0);
 		for (; gdb_num <= gdb_num_end; gdb_num++) {
 			struct buffer_head *gdb_bh;
 
@@ -1769,7 +1769,7 @@ static int ext4_group_extend_no_check(struct super_block *sb,
 		if (test_opt(sb, DEBUG))
 			printk(KERN_DEBUG "EXT4-fs: extended group to %llu "
 			       "blocks\n", ext4_blocks_count(es));
-		update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr,
+		update_backups(sb, ext4_group_first_block_no(sb, 0),
 			       (char *)es, sizeof(struct ext4_super_block), 0);
 	}
 	return err;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 985d79fb6128..802ca160d31e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1288,6 +1288,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 		return NULL;
 
 	inode_set_iversion(&ei->vfs_inode, 1);
+	ei->i_flags = 0;
 	spin_lock_init(&ei->i_raw_lock);
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	atomic_set(&ei->i_prealloc_active, 0);
@@ -4663,30 +4664,31 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		   ext4_has_feature_journal_needs_recovery(sb)) {
 		ext4_msg(sb, KERN_ERR, "required journal recovery "
 		       "suppressed and not mounted read-only");
-		goto failed_mount_wq;
+		goto failed_mount3a;
 	} else {
 		/* Nojournal mode, all journal mount options are illegal */
-		if (test_opt2(sb, EXPLICIT_JOURNAL_CHECKSUM)) {
-			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "journal_checksum, fs mounted w/o journal");
-			goto failed_mount_wq;
-		}
 		if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
 				 "journal_async_commit, fs mounted w/o journal");
-			goto failed_mount_wq;
+			goto failed_mount3a;
+		}
+
+		if (test_opt2(sb, EXPLICIT_JOURNAL_CHECKSUM)) {
+			ext4_msg(sb, KERN_ERR, "can't mount with "
+				 "journal_checksum, fs mounted w/o journal");
+			goto failed_mount3a;
 		}
 		if (sbi->s_commit_interval != JBD2_DEFAULT_MAX_COMMIT_AGE*HZ) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
 				 "commit=%lu, fs mounted w/o journal",
 				 sbi->s_commit_interval / HZ);
-			goto failed_mount_wq;
+			goto failed_mount3a;
 		}
 		if (EXT4_MOUNT_DATA_FLAGS &
 		    (sbi->s_mount_opt ^ sbi->s_def_mount_opt)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
 				 "data=, fs mounted w/o journal");
-			goto failed_mount_wq;
+			goto failed_mount3a;
 		}
 		sbi->s_def_mount_opt &= ~EXT4_MOUNT_JOURNAL_CHECKSUM;
 		clear_opt(sb, JOURNAL_CHECKSUM);
@@ -5153,9 +5155,9 @@ static struct inode *ext4_get_journal_inode(struct super_block *sb,
 		return NULL;
 	}
 
-	jbd_debug(2, "Journal inode found at %p: %lld bytes\n",
+	ext4_debug("Journal inode found at %p: %lld bytes\n",
 		  journal_inode, journal_inode->i_size);
-	if (!S_ISREG(journal_inode->i_mode)) {
+	if (!S_ISREG(journal_inode->i_mode) || IS_ENCRYPTED(journal_inode)) {
 		ext4_msg(sb, KERN_ERR, "invalid journal inode");
 		iput(journal_inode);
 		return NULL;
@@ -6309,6 +6311,20 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 	return err;
 }
 
+static inline bool ext4_check_quota_inum(int type, unsigned long qf_inum)
+{
+	switch (type) {
+	case USRQUOTA:
+		return qf_inum == EXT4_USR_QUOTA_INO;
+	case GRPQUOTA:
+		return qf_inum == EXT4_GRP_QUOTA_INO;
+	case PRJQUOTA:
+		return qf_inum >= EXT4_GOOD_OLD_FIRST_INO;
+	default:
+		BUG();
+	}
+}
+
 static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 			     unsigned int flags)
 {
@@ -6325,9 +6341,16 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 	if (!qf_inums[type])
 		return -EPERM;
 
+	if (!ext4_check_quota_inum(type, qf_inums[type])) {
+		ext4_error(sb, "Bad quota inum: %lu, type: %d",
+				qf_inums[type], type);
+		return -EUCLEAN;
+	}
+
 	qf_inode = ext4_iget(sb, qf_inums[type], EXT4_IGET_SPECIAL);
 	if (IS_ERR(qf_inode)) {
-		ext4_error(sb, "Bad quota inode # %lu", qf_inums[type]);
+		ext4_error(sb, "Bad quota inode: %lu, type: %d",
+				qf_inums[type], type);
 		return PTR_ERR(qf_inode);
 	}
 
@@ -6366,8 +6389,9 @@ int ext4_enable_quotas(struct super_block *sb)
 			if (err) {
 				ext4_warning(sb,
 					"Failed to enable quota tracking "
-					"(type=%d, err=%d). Please run "
-					"e2fsck to fix.", type, err);
+					"(type=%d, err=%d, ino=%lu). "
+					"Please run e2fsck to fix.", type,
+					err, qf_inums[type]);
 				for (type--; type >= 0; type--) {
 					struct inode *inode;
 
diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 840639e7a7ca..5ece4d3c6210 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -76,7 +76,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		size_t n = min_t(size_t, count,
 				 PAGE_SIZE - offset_in_page(pos));
 		struct page *page;
-		void *fsdata;
+		void *fsdata = NULL;
 		int res;
 
 		res = pagecache_write_begin(NULL, inode->i_mapping, pos, n, 0,
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 533216e80fa2..b92da41e9640 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1281,7 +1281,7 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 				ce = mb_cache_entry_get(ea_block_cache, hash,
 							bh->b_blocknr);
 				if (ce) {
-					ce->e_reusable = 1;
+					set_bit(MBE_REUSABLE_B, &ce->e_flags);
 					mb_cache_entry_put(ea_block_cache, ce);
 				}
 			}
@@ -1441,6 +1441,9 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
 		if (!err)
 			err = ext4_inode_attach_jinode(ea_inode);
 		if (err) {
+			if (ext4_xattr_inode_dec_ref(handle, ea_inode))
+				ext4_warning_inode(ea_inode,
+					"cleanup dec ref error %d", err);
 			iput(ea_inode);
 			return ERR_PTR(err);
 		}
@@ -2042,7 +2045,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 				}
 				BHDR(new_bh)->h_refcount = cpu_to_le32(ref);
 				if (ref == EXT4_XATTR_REFCOUNT_MAX)
-					ce->e_reusable = 0;
+					clear_bit(MBE_REUSABLE_B, &ce->e_flags);
 				ea_bdebug(new_bh, "reusing; refcount now=%d",
 					  ref);
 				ext4_xattr_block_csum_set(inode, new_bh);
@@ -2070,19 +2073,11 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 
 			goal = ext4_group_first_block_no(sb,
 						EXT4_I(inode)->i_block_group);
-
-			/* non-extent files can't have physical blocks past 2^32 */
-			if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-				goal = goal & EXT4_MAX_BLOCK_FILE_PHYS;
-
 			block = ext4_new_meta_blocks(handle, inode, goal, 0,
 						     NULL, &error);
 			if (error)
 				goto cleanup;
 
-			if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-				BUG_ON(block > EXT4_MAX_BLOCK_FILE_PHYS);
-
 			ea_idebug(inode, "creating block %llu",
 				  (unsigned long long)block);
 
@@ -2554,7 +2549,7 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 
 	is = kzalloc(sizeof(struct ext4_xattr_ibody_find), GFP_NOFS);
 	bs = kzalloc(sizeof(struct ext4_xattr_block_find), GFP_NOFS);
-	buffer = kmalloc(value_size, GFP_NOFS);
+	buffer = kvmalloc(value_size, GFP_NOFS);
 	b_entry_name = kmalloc(entry->e_name_len + 1, GFP_NOFS);
 	if (!is || !bs || !buffer || !b_entry_name) {
 		error = -ENOMEM;
@@ -2606,7 +2601,7 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 	error = 0;
 out:
 	kfree(b_entry_name);
-	kfree(buffer);
+	kvfree(buffer);
 	if (is)
 		brelse(is->iloc.bh);
 	if (bs)
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 7863f8fd3b95..280a93855eaf 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1033,6 +1033,7 @@ static bool is_alive(struct f2fs_sb_info *sbi, struct f2fs_summary *sum,
 	if (ofs_in_node >= max_addrs) {
 		f2fs_err(sbi, "Inconsistent ofs_in_node:%u in summary, ino:%u, nid:%u, max:%u",
 			ofs_in_node, dni->ino, dni->nid, max_addrs);
+		f2fs_put_page(node_page, 1);
 		return false;
 	}
 
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 0e6e73bc42d4..f810c6bbeff0 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1357,8 +1357,7 @@ static int read_node_page(struct page *page, int op_flags)
 		return err;
 
 	/* NEW_ADDR can be seen, after cp_error drops some dirty node pages */
-	if (unlikely(ni.blk_addr == NULL_ADDR || ni.blk_addr == NEW_ADDR) ||
-			is_sbi_flag_set(sbi, SBI_IS_SHUTDOWN)) {
+	if (unlikely(ni.blk_addr == NULL_ADDR || ni.blk_addr == NEW_ADDR)) {
 		ClearPageUptodate(page);
 		return -ENOENT;
 	}
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index a58a5b733224..7c9c6d0b38fd 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -456,16 +456,16 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		/* panic? */
 		return -EIO;
 
+	res = -EIO;
 	if (HFS_I(main_inode)->cat_key.CName.len > HFS_NAMELEN)
-		return -EIO;
+		goto out;
 	fd.search_key->cat = HFS_I(main_inode)->cat_key;
 	if (hfs_brec_find(&fd))
-		/* panic? */
 		goto out;
 
 	if (S_ISDIR(main_inode->i_mode)) {
 		if (fd.entrylength < sizeof(struct hfs_cat_dir))
-			/* panic? */;
+			goto out;
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset,
 			   sizeof(struct hfs_cat_dir));
 		if (rec.type != HFS_CDR_DIR ||
@@ -478,6 +478,8 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		hfs_bnode_write(fd.bnode, &rec, fd.entryoffset,
 			    sizeof(struct hfs_cat_dir));
 	} else if (HFS_IS_RSRC(inode)) {
+		if (fd.entrylength < sizeof(struct hfs_cat_file))
+			goto out;
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset,
 			       sizeof(struct hfs_cat_file));
 		hfs_inode_write_fork(inode, rec.file.RExtRec,
@@ -486,7 +488,7 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 				sizeof(struct hfs_cat_file));
 	} else {
 		if (fd.entrylength < sizeof(struct hfs_cat_file))
-			/* panic? */;
+			goto out;
 		hfs_bnode_read(fd.bnode, &rec, fd.entryoffset,
 			   sizeof(struct hfs_cat_file));
 		if (rec.type != HFS_CDR_FIL ||
@@ -503,9 +505,10 @@ int hfs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		hfs_bnode_write(fd.bnode, &rec, fd.entryoffset,
 			    sizeof(struct hfs_cat_file));
 	}
+	res = 0;
 out:
 	hfs_find_exit(&fd);
-	return 0;
+	return res;
 }
 
 static struct dentry *hfs_file_lookup(struct inode *dir, struct dentry *dentry,
diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index 1798949f269b..ebc0d5c678d0 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -198,6 +198,8 @@ struct hfsplus_sb_info {
 #define HFSPLUS_SB_HFSX		3
 #define HFSPLUS_SB_CASEFOLD	4
 #define HFSPLUS_SB_NOBARRIER	5
+#define HFSPLUS_SB_UID		6
+#define HFSPLUS_SB_GID		7
 
 static inline struct hfsplus_sb_info *HFSPLUS_SB(struct super_block *sb)
 {
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 6fef67c2a9f0..bf6f75f569e4 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -190,11 +190,11 @@ static void hfsplus_get_perms(struct inode *inode,
 	mode = be16_to_cpu(perms->mode);
 
 	i_uid_write(inode, be32_to_cpu(perms->owner));
-	if (!i_uid_read(inode) && !mode)
+	if ((test_bit(HFSPLUS_SB_UID, &sbi->flags)) || (!i_uid_read(inode) && !mode))
 		inode->i_uid = sbi->uid;
 
 	i_gid_write(inode, be32_to_cpu(perms->group));
-	if (!i_gid_read(inode) && !mode)
+	if ((test_bit(HFSPLUS_SB_GID, &sbi->flags)) || (!i_gid_read(inode) && !mode))
 		inode->i_gid = sbi->gid;
 
 	if (dir) {
@@ -509,8 +509,7 @@ int hfsplus_cat_read_inode(struct inode *inode, struct hfs_find_data *fd)
 	if (type == HFSPLUS_FOLDER) {
 		struct hfsplus_cat_folder *folder = &entry.folder;
 
-		if (fd->entrylength < sizeof(struct hfsplus_cat_folder))
-			/* panic? */;
+		WARN_ON(fd->entrylength < sizeof(struct hfsplus_cat_folder));
 		hfs_bnode_read(fd->bnode, &entry, fd->entryoffset,
 					sizeof(struct hfsplus_cat_folder));
 		hfsplus_get_perms(inode, &folder->permissions, 1);
@@ -530,8 +529,7 @@ int hfsplus_cat_read_inode(struct inode *inode, struct hfs_find_data *fd)
 	} else if (type == HFSPLUS_FILE) {
 		struct hfsplus_cat_file *file = &entry.file;
 
-		if (fd->entrylength < sizeof(struct hfsplus_cat_file))
-			/* panic? */;
+		WARN_ON(fd->entrylength < sizeof(struct hfsplus_cat_file));
 		hfs_bnode_read(fd->bnode, &entry, fd->entryoffset,
 					sizeof(struct hfsplus_cat_file));
 
@@ -588,8 +586,7 @@ int hfsplus_cat_write_inode(struct inode *inode)
 	if (S_ISDIR(main_inode->i_mode)) {
 		struct hfsplus_cat_folder *folder = &entry.folder;
 
-		if (fd.entrylength < sizeof(struct hfsplus_cat_folder))
-			/* panic? */;
+		WARN_ON(fd.entrylength < sizeof(struct hfsplus_cat_folder));
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset,
 					sizeof(struct hfsplus_cat_folder));
 		/* simple node checks? */
@@ -614,8 +611,7 @@ int hfsplus_cat_write_inode(struct inode *inode)
 	} else {
 		struct hfsplus_cat_file *file = &entry.file;
 
-		if (fd.entrylength < sizeof(struct hfsplus_cat_file))
-			/* panic? */;
+		WARN_ON(fd.entrylength < sizeof(struct hfsplus_cat_file));
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset,
 					sizeof(struct hfsplus_cat_file));
 		hfsplus_inode_write_fork(inode, &file->data_fork);
diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index 047e05c57560..c94a58762ad6 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -140,6 +140,8 @@ int hfsplus_parse_options(char *input, struct hfsplus_sb_info *sbi)
 			if (!uid_valid(sbi->uid)) {
 				pr_err("invalid uid specified\n");
 				return 0;
+			} else {
+				set_bit(HFSPLUS_SB_UID, &sbi->flags);
 			}
 			break;
 		case opt_gid:
@@ -151,6 +153,8 @@ int hfsplus_parse_options(char *input, struct hfsplus_sb_info *sbi)
 			if (!gid_valid(sbi->gid)) {
 				pr_err("invalid gid specified\n");
 				return 0;
+			} else {
+				set_bit(HFSPLUS_SB_GID, &sbi->flags);
 			}
 			break;
 		case opt_part:
diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index 30a92ddc1817..b962b16e5aeb 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -319,7 +319,8 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
 	dn_off = le32_to_cpu(authblob->DomainName.BufferOffset);
 	dn_len = le16_to_cpu(authblob->DomainName.Length);
 
-	if (blob_len < (u64)dn_off + dn_len || blob_len < (u64)nt_off + nt_len)
+	if (blob_len < (u64)dn_off + dn_len || blob_len < (u64)nt_off + nt_len ||
+	    nt_len < CIFS_ENCPWD_SIZE)
 		return -EINVAL;
 
 	/* TODO : use domain name that imported from configuration file */
diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index 02254b09c0da..6a1d1fbe5fb2 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -310,9 +310,12 @@ int ksmbd_conn_handler_loop(void *p)
 
 		/* 4 for rfc1002 length field */
 		size = pdu_size + 4;
-		conn->request_buf = kvmalloc(size, GFP_KERNEL);
+		conn->request_buf = kvmalloc(size,
+					     GFP_KERNEL |
+					     __GFP_NOWARN |
+					     __GFP_NORETRY);
 		if (!conn->request_buf)
-			continue;
+			break;
 
 		memcpy(conn->request_buf, hdr_buf, sizeof(hdr_buf));
 		if (!ksmbd_smb_request(conn))
diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index 755329c295ca..293af921f2ad 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -295,6 +295,7 @@ static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
 	struct msghdr ksmbd_msg;
 	struct kvec *iov;
 	struct ksmbd_conn *conn = KSMBD_TRANS(t)->conn;
+	int max_retry = 2;
 
 	iov = get_conn_iovec(t, nr_segs);
 	if (!iov)
@@ -321,9 +322,11 @@ static int ksmbd_tcp_readv(struct tcp_transport *t, struct kvec *iov_orig,
 		} else if (conn->status == KSMBD_SESS_NEED_RECONNECT) {
 			total_read = -EAGAIN;
 			break;
-		} else if (length == -ERESTARTSYS || length == -EAGAIN) {
+		} else if ((length == -ERESTARTSYS || length == -EAGAIN) &&
+			   max_retry) {
 			usleep_range(1000, 2000);
 			length = 0;
+			max_retry--;
 			continue;
 		} else if (length <= 0) {
 			total_read = -EAGAIN;
diff --git a/fs/locks.c b/fs/locks.c
index 3d6fb4ae847b..82a4487e95b3 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2703,6 +2703,29 @@ int vfs_cancel_lock(struct file *filp, struct file_lock *fl)
 }
 EXPORT_SYMBOL_GPL(vfs_cancel_lock);
 
+/**
+ * vfs_inode_has_locks - are any file locks held on @inode?
+ * @inode: inode to check for locks
+ *
+ * Return true if there are any FL_POSIX or FL_FLOCK locks currently
+ * set on @inode.
+ */
+bool vfs_inode_has_locks(struct inode *inode)
+{
+	struct file_lock_context *ctx;
+	bool ret;
+
+	ctx = smp_load_acquire(&inode->i_flctx);
+	if (!ctx)
+		return false;
+
+	spin_lock(&ctx->flc_lock);
+	ret = !list_empty(&ctx->flc_posix) || !list_empty(&ctx->flc_flock);
+	spin_unlock(&ctx->flc_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfs_inode_has_locks);
+
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
diff --git a/fs/mbcache.c b/fs/mbcache.c
index 2010bc80a3f2..95b047256d09 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -90,12 +90,19 @@ int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&entry->e_list);
-	/* One ref for hash, one ref returned */
-	atomic_set(&entry->e_refcnt, 1);
+	/*
+	 * We create entry with two references. One reference is kept by the
+	 * hash table, the other reference is used to protect us from
+	 * mb_cache_entry_delete_or_get() until the entry is fully setup. This
+	 * avoids nesting of cache->c_list_lock into hash table bit locks which
+	 * is problematic for RT.
+	 */
+	atomic_set(&entry->e_refcnt, 2);
 	entry->e_key = key;
 	entry->e_value = value;
-	entry->e_reusable = reusable;
-	entry->e_referenced = 0;
+	entry->e_flags = 0;
+	if (reusable)
+		set_bit(MBE_REUSABLE_B, &entry->e_flags);
 	head = mb_cache_entry_head(cache, key);
 	hlist_bl_lock(head);
 	hlist_bl_for_each_entry(dup, dup_node, head, e_hash_list) {
@@ -107,20 +114,24 @@ int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
 	}
 	hlist_bl_add_head(&entry->e_hash_list, head);
 	hlist_bl_unlock(head);
-
 	spin_lock(&cache->c_list_lock);
 	list_add_tail(&entry->e_list, &cache->c_list);
-	/* Grab ref for LRU list */
-	atomic_inc(&entry->e_refcnt);
 	cache->c_entry_count++;
 	spin_unlock(&cache->c_list_lock);
+	mb_cache_entry_put(cache, entry);
 
 	return 0;
 }
 EXPORT_SYMBOL(mb_cache_entry_create);
 
-void __mb_cache_entry_free(struct mb_cache_entry *entry)
+void __mb_cache_entry_free(struct mb_cache *cache, struct mb_cache_entry *entry)
 {
+	struct hlist_bl_head *head;
+
+	head = mb_cache_entry_head(cache, entry->e_key);
+	hlist_bl_lock(head);
+	hlist_bl_del(&entry->e_hash_list);
+	hlist_bl_unlock(head);
 	kmem_cache_free(mb_entry_cache, entry);
 }
 EXPORT_SYMBOL(__mb_cache_entry_free);
@@ -134,7 +145,7 @@ EXPORT_SYMBOL(__mb_cache_entry_free);
  */
 void mb_cache_entry_wait_unused(struct mb_cache_entry *entry)
 {
-	wait_var_event(&entry->e_refcnt, atomic_read(&entry->e_refcnt) <= 3);
+	wait_var_event(&entry->e_refcnt, atomic_read(&entry->e_refcnt) <= 2);
 }
 EXPORT_SYMBOL(mb_cache_entry_wait_unused);
 
@@ -155,10 +166,10 @@ static struct mb_cache_entry *__entry_find(struct mb_cache *cache,
 	while (node) {
 		entry = hlist_bl_entry(node, struct mb_cache_entry,
 				       e_hash_list);
-		if (entry->e_key == key && entry->e_reusable) {
-			atomic_inc(&entry->e_refcnt);
+		if (entry->e_key == key &&
+		    test_bit(MBE_REUSABLE_B, &entry->e_flags) &&
+		    atomic_inc_not_zero(&entry->e_refcnt))
 			goto out;
-		}
 		node = node->next;
 	}
 	entry = NULL;
@@ -218,10 +229,9 @@ struct mb_cache_entry *mb_cache_entry_get(struct mb_cache *cache, u32 key,
 	head = mb_cache_entry_head(cache, key);
 	hlist_bl_lock(head);
 	hlist_bl_for_each_entry(entry, node, head, e_hash_list) {
-		if (entry->e_key == key && entry->e_value == value) {
-			atomic_inc(&entry->e_refcnt);
+		if (entry->e_key == key && entry->e_value == value &&
+		    atomic_inc_not_zero(&entry->e_refcnt))
 			goto out;
-		}
 	}
 	entry = NULL;
 out:
@@ -281,37 +291,25 @@ EXPORT_SYMBOL(mb_cache_entry_delete);
 struct mb_cache_entry *mb_cache_entry_delete_or_get(struct mb_cache *cache,
 						    u32 key, u64 value)
 {
-	struct hlist_bl_node *node;
-	struct hlist_bl_head *head;
 	struct mb_cache_entry *entry;
 
-	head = mb_cache_entry_head(cache, key);
-	hlist_bl_lock(head);
-	hlist_bl_for_each_entry(entry, node, head, e_hash_list) {
-		if (entry->e_key == key && entry->e_value == value) {
-			if (atomic_read(&entry->e_refcnt) > 2) {
-				atomic_inc(&entry->e_refcnt);
-				hlist_bl_unlock(head);
-				return entry;
-			}
-			/* We keep hash list reference to keep entry alive */
-			hlist_bl_del_init(&entry->e_hash_list);
-			hlist_bl_unlock(head);
-			spin_lock(&cache->c_list_lock);
-			if (!list_empty(&entry->e_list)) {
-				list_del_init(&entry->e_list);
-				if (!WARN_ONCE(cache->c_entry_count == 0,
-		"mbcache: attempt to decrement c_entry_count past zero"))
-					cache->c_entry_count--;
-				atomic_dec(&entry->e_refcnt);
-			}
-			spin_unlock(&cache->c_list_lock);
-			mb_cache_entry_put(cache, entry);
-			return NULL;
-		}
-	}
-	hlist_bl_unlock(head);
+	entry = mb_cache_entry_get(cache, key, value);
+	if (!entry)
+		return NULL;
+
+	/*
+	 * Drop the ref we got from mb_cache_entry_get() and the initial hash
+	 * ref if we are the last user
+	 */
+	if (atomic_cmpxchg(&entry->e_refcnt, 2, 0) != 2)
+		return entry;
 
+	spin_lock(&cache->c_list_lock);
+	if (!list_empty(&entry->e_list))
+		list_del_init(&entry->e_list);
+	cache->c_entry_count--;
+	spin_unlock(&cache->c_list_lock);
+	__mb_cache_entry_free(cache, entry);
 	return NULL;
 }
 EXPORT_SYMBOL(mb_cache_entry_delete_or_get);
@@ -325,7 +323,7 @@ EXPORT_SYMBOL(mb_cache_entry_delete_or_get);
 void mb_cache_entry_touch(struct mb_cache *cache,
 			  struct mb_cache_entry *entry)
 {
-	entry->e_referenced = 1;
+	set_bit(MBE_REFERENCED_B, &entry->e_flags);
 }
 EXPORT_SYMBOL(mb_cache_entry_touch);
 
@@ -343,42 +341,24 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
 				     unsigned long nr_to_scan)
 {
 	struct mb_cache_entry *entry;
-	struct hlist_bl_head *head;
 	unsigned long shrunk = 0;
 
 	spin_lock(&cache->c_list_lock);
 	while (nr_to_scan-- && !list_empty(&cache->c_list)) {
 		entry = list_first_entry(&cache->c_list,
 					 struct mb_cache_entry, e_list);
-		if (entry->e_referenced || atomic_read(&entry->e_refcnt) > 2) {
-			entry->e_referenced = 0;
+		/* Drop initial hash reference if there is no user */
+		if (test_bit(MBE_REFERENCED_B, &entry->e_flags) ||
+		    atomic_cmpxchg(&entry->e_refcnt, 1, 0) != 1) {
+			clear_bit(MBE_REFERENCED_B, &entry->e_flags);
 			list_move_tail(&entry->e_list, &cache->c_list);
 			continue;
 		}
 		list_del_init(&entry->e_list);
 		cache->c_entry_count--;
-		/*
-		 * We keep LRU list reference so that entry doesn't go away
-		 * from under us.
-		 */
 		spin_unlock(&cache->c_list_lock);
-		head = mb_cache_entry_head(cache, entry->e_key);
-		hlist_bl_lock(head);
-		/* Now a reliable check if the entry didn't get used... */
-		if (atomic_read(&entry->e_refcnt) > 2) {
-			hlist_bl_unlock(head);
-			spin_lock(&cache->c_list_lock);
-			list_add_tail(&entry->e_list, &cache->c_list);
-			cache->c_entry_count++;
-			continue;
-		}
-		if (!hlist_bl_unhashed(&entry->e_hash_list)) {
-			hlist_bl_del_init(&entry->e_hash_list);
-			atomic_dec(&entry->e_refcnt);
-		}
-		hlist_bl_unlock(head);
-		if (mb_cache_entry_put(cache, entry))
-			shrunk++;
+		__mb_cache_entry_free(cache, entry);
+		shrunk++;
 		cond_resched();
 		spin_lock(&cache->c_list_lock);
 	}
@@ -470,11 +450,6 @@ void mb_cache_destroy(struct mb_cache *cache)
 	 * point.
 	 */
 	list_for_each_entry_safe(entry, next, &cache->c_list, e_list) {
-		if (!hlist_bl_unhashed(&entry->e_hash_list)) {
-			hlist_bl_del_init(&entry->e_hash_list);
-			atomic_dec(&entry->e_refcnt);
-		} else
-			WARN_ON(1);
 		list_del(&entry->e_list);
 		WARN_ON(atomic_read(&entry->e_refcnt) != 1);
 		mb_cache_entry_put(cache, entry);
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index e0409f6cdfd5..dfd3877fdd81 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3514,6 +3514,17 @@ nfsd4_encode_dirent(void *ccdv, const char *name, int namlen,
 	case nfserr_noent:
 		xdr_truncate_encode(xdr, start_offset);
 		goto skip_entry;
+	case nfserr_jukebox:
+		/*
+		 * The pseudoroot should only display dentries that lead to
+		 * exports. If we get EJUKEBOX here, then we can't tell whether
+		 * this entry should be included. Just fail the whole READDIR
+		 * with NFS4ERR_DELAY in that case, and hope that the situation
+		 * will resolve itself by the client's next attempt.
+		 */
+		if (cd->rd_fhp->fh_export->ex_flags & NFSEXP_V4ROOT)
+			goto fail;
+		fallthrough;
 	default:
 		/*
 		 * If the client requested the RDATTR_ERROR attribute,
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index ccb59e91011b..373695cc62a7 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -425,8 +425,8 @@ static void nfsd_shutdown_net(struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
-	nfsd_file_cache_shutdown_net(net);
 	nfs4_state_shutdown_net(net);
+	nfsd_file_cache_shutdown_net(net);
 	if (nn->lockd_up) {
 		lockd_down(net);
 		nn->lockd_up = false;
diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index e8c00dda42ad..42af83bcaf13 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -101,6 +101,10 @@ int attr_load_runs(struct ATTRIB *attr, struct ntfs_inode *ni,
 
 	asize = le32_to_cpu(attr->size);
 	run_off = le16_to_cpu(attr->nres.run_off);
+
+	if (run_off > asize)
+		return -EINVAL;
+
 	err = run_unpack_ex(run, ni->mi.sbi, ni->mi.rno, svcn, evcn,
 			    vcn ? *vcn : svcn, Add2Ptr(attr, run_off),
 			    asize - run_off);
@@ -1142,6 +1146,11 @@ int attr_load_runs_vcn(struct ntfs_inode *ni, enum ATTR_TYPE type,
 	CLST svcn, evcn;
 	u16 ro;
 
+	if (!ni) {
+		/* Is record corrupted? */
+		return -ENOENT;
+	}
+
 	attr = ni_find_attr(ni, NULL, NULL, type, name, name_len, &vcn, NULL);
 	if (!attr) {
 		/* Is record corrupted? */
@@ -1157,6 +1166,10 @@ int attr_load_runs_vcn(struct ntfs_inode *ni, enum ATTR_TYPE type,
 	}
 
 	ro = le16_to_cpu(attr->nres.run_off);
+
+	if (ro > le32_to_cpu(attr->size))
+		return -EINVAL;
+
 	err = run_unpack_ex(run, ni->mi.sbi, ni->mi.rno, svcn, evcn, svcn,
 			    Add2Ptr(attr, ro), le32_to_cpu(attr->size) - ro);
 	if (err < 0)
@@ -1832,6 +1845,11 @@ int attr_collapse_range(struct ntfs_inode *ni, u64 vbo, u64 bytes)
 			u16 le_sz;
 			u16 roff = le16_to_cpu(attr->nres.run_off);
 
+			if (roff > le32_to_cpu(attr->size)) {
+				err = -EINVAL;
+				goto out;
+			}
+
 			run_unpack_ex(RUN_DEALLOCATE, sbi, ni->mi.rno, svcn,
 				      evcn1 - 1, svcn, Add2Ptr(attr, roff),
 				      le32_to_cpu(attr->size) - roff);
diff --git a/fs/ntfs3/attrlist.c b/fs/ntfs3/attrlist.c
index bad6d8a849a2..c0c6bcbc8c05 100644
--- a/fs/ntfs3/attrlist.c
+++ b/fs/ntfs3/attrlist.c
@@ -68,6 +68,11 @@ int ntfs_load_attr_list(struct ntfs_inode *ni, struct ATTRIB *attr)
 
 		run_init(&ni->attr_list.run);
 
+		if (run_off > le32_to_cpu(attr->size)) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		err = run_unpack_ex(&ni->attr_list.run, ni->mi.sbi, ni->mi.rno,
 				    0, le64_to_cpu(attr->nres.evcn), 0,
 				    Add2Ptr(attr, run_off),
diff --git a/fs/ntfs3/bitmap.c b/fs/ntfs3/bitmap.c
index 7f2055b7427a..2a63793f522d 100644
--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -666,7 +666,7 @@ int wnd_init(struct wnd_bitmap *wnd, struct super_block *sb, size_t nbits)
 	if (!wnd->bits_last)
 		wnd->bits_last = wbits;
 
-	wnd->free_bits = kcalloc(wnd->nwnd, sizeof(u16), GFP_NOFS);
+	wnd->free_bits = kcalloc(wnd->nwnd, sizeof(u16), GFP_NOFS | __GFP_NOWARN);
 	if (!wnd->free_bits)
 		return -ENOMEM;
 
diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 7a678a5b1ca5..c526e0427f2b 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -488,10 +488,10 @@ static int ntfs_truncate(struct inode *inode, loff_t new_size)
 
 	new_valid = ntfs_up_block(sb, min_t(u64, ni->i_valid, new_size));
 
-	ni_lock(ni);
-
 	truncate_setsize(inode, new_size);
 
+	ni_lock(ni);
+
 	down_write(&ni->file.run_lock);
 	err = attr_set_size(ni, ATTR_DATA, NULL, 0, &ni->file.run, new_size,
 			    &new_valid, ni->mi.sbi->options->prealloc, NULL);
diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 18842998c8fa..cdeb0b51f0ba 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -567,6 +567,12 @@ static int ni_repack(struct ntfs_inode *ni)
 		}
 
 		roff = le16_to_cpu(attr->nres.run_off);
+
+		if (roff > le32_to_cpu(attr->size)) {
+			err = -EINVAL;
+			break;
+		}
+
 		err = run_unpack(&run, sbi, ni->mi.rno, svcn, evcn, svcn,
 				 Add2Ptr(attr, roff),
 				 le32_to_cpu(attr->size) - roff);
@@ -1541,6 +1547,9 @@ int ni_delete_all(struct ntfs_inode *ni)
 		asize = le32_to_cpu(attr->size);
 		roff = le16_to_cpu(attr->nres.run_off);
 
+		if (roff > asize)
+			return -EINVAL;
+
 		/* run==1 means unpack and deallocate. */
 		run_unpack_ex(RUN_DEALLOCATE, sbi, ni->mi.rno, svcn, evcn, svcn,
 			      Add2Ptr(attr, roff), asize - roff);
@@ -2242,6 +2251,11 @@ int ni_decompress_file(struct ntfs_inode *ni)
 		asize = le32_to_cpu(attr->size);
 		roff = le16_to_cpu(attr->nres.run_off);
 
+		if (roff > asize) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		/*run==1  Means unpack and deallocate. */
 		run_unpack_ex(RUN_DEALLOCATE, sbi, ni->mi.rno, svcn, evcn, svcn,
 			      Add2Ptr(attr, roff), asize - roff);
diff --git a/fs/ntfs3/fslog.c b/fs/ntfs3/fslog.c
index 614513460b8e..20abdb268286 100644
--- a/fs/ntfs3/fslog.c
+++ b/fs/ntfs3/fslog.c
@@ -1132,7 +1132,7 @@ static int read_log_page(struct ntfs_log *log, u32 vbo,
 		return -EINVAL;
 
 	if (!*buffer) {
-		to_free = kmalloc(bytes, GFP_NOFS);
+		to_free = kmalloc(log->page_size, GFP_NOFS);
 		if (!to_free)
 			return -ENOMEM;
 		*buffer = to_free;
@@ -1180,10 +1180,7 @@ static int log_read_rst(struct ntfs_log *log, u32 l_size, bool first,
 			struct restart_info *info)
 {
 	u32 skip, vbo;
-	struct RESTART_HDR *r_page = kmalloc(DefaultLogPageSize, GFP_NOFS);
-
-	if (!r_page)
-		return -ENOMEM;
+	struct RESTART_HDR *r_page = NULL;
 
 	/* Determine which restart area we are looking for. */
 	if (first) {
@@ -1197,7 +1194,6 @@ static int log_read_rst(struct ntfs_log *log, u32 l_size, bool first,
 	/* Loop continuously until we succeed. */
 	for (; vbo < l_size; vbo = 2 * vbo + skip, skip = 0) {
 		bool usa_error;
-		u32 sys_page_size;
 		bool brst, bchk;
 		struct RESTART_AREA *ra;
 
@@ -1251,24 +1247,6 @@ static int log_read_rst(struct ntfs_log *log, u32 l_size, bool first,
 			goto check_result;
 		}
 
-		/* Read the entire restart area. */
-		sys_page_size = le32_to_cpu(r_page->sys_page_size);
-		if (DefaultLogPageSize != sys_page_size) {
-			kfree(r_page);
-			r_page = kzalloc(sys_page_size, GFP_NOFS);
-			if (!r_page)
-				return -ENOMEM;
-
-			if (read_log_page(log, vbo,
-					  (struct RECORD_PAGE_HDR **)&r_page,
-					  &usa_error)) {
-				/* Ignore any errors. */
-				kfree(r_page);
-				r_page = NULL;
-				continue;
-			}
-		}
-
 		if (is_client_area_valid(r_page, usa_error)) {
 			info->valid_page = true;
 			ra = Add2Ptr(r_page, le16_to_cpu(r_page->ra_off));
@@ -2727,6 +2705,9 @@ static inline bool check_attr(const struct MFT_REC *rec,
 			return false;
 		}
 
+		if (run_off > asize)
+			return false;
+
 		if (run_unpack(NULL, sbi, 0, svcn, evcn, svcn,
 			       Add2Ptr(attr, run_off), asize - run_off) < 0) {
 			return false;
@@ -4769,6 +4750,12 @@ int log_replay(struct ntfs_inode *ni, bool *initialized)
 		u16 roff = le16_to_cpu(attr->nres.run_off);
 		CLST svcn = le64_to_cpu(attr->nres.svcn);
 
+		if (roff > t32) {
+			kfree(oa->attr);
+			oa->attr = NULL;
+			goto fake_attr;
+		}
+
 		err = run_unpack(&oa->run0, sbi, inode->i_ino, svcn,
 				 le64_to_cpu(attr->nres.evcn), svcn,
 				 Add2Ptr(attr, roff), t32 - roff);
diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 24b57c3cc625..4a97a28cb8f2 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1878,9 +1878,10 @@ int ntfs_security_init(struct ntfs_sb_info *sbi)
 		goto out;
 	}
 
-	root_sdh = resident_data(attr);
+	root_sdh = resident_data_ex(attr, sizeof(struct INDEX_ROOT));
 	if (root_sdh->type != ATTR_ZERO ||
-	    root_sdh->rule != NTFS_COLLATION_TYPE_SECURITY_HASH) {
+	    root_sdh->rule != NTFS_COLLATION_TYPE_SECURITY_HASH ||
+	    offsetof(struct INDEX_ROOT, ihdr) + root_sdh->ihdr.used > attr->res.data_size) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -1896,9 +1897,10 @@ int ntfs_security_init(struct ntfs_sb_info *sbi)
 		goto out;
 	}
 
-	root_sii = resident_data(attr);
+	root_sii = resident_data_ex(attr, sizeof(struct INDEX_ROOT));
 	if (root_sii->type != ATTR_ZERO ||
-	    root_sii->rule != NTFS_COLLATION_TYPE_UINT) {
+	    root_sii->rule != NTFS_COLLATION_TYPE_UINT ||
+	    offsetof(struct INDEX_ROOT, ihdr) + root_sii->ihdr.used > attr->res.data_size) {
 		err = -EINVAL;
 		goto out;
 	}
diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 76ebea253fa2..99f8a57e9f7a 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1017,6 +1017,12 @@ int indx_read(struct ntfs_index *indx, struct ntfs_inode *ni, CLST vbn,
 		err = 0;
 	}
 
+	/* check for index header length */
+	if (offsetof(struct INDEX_BUFFER, ihdr) + ib->ihdr.used > bytes) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	in->index = ib;
 	*node = in;
 
diff --git a/fs/ntfs3/inode.c b/fs/ntfs3/inode.c
index 64b4a3c29878..ed640e4e3fac 100644
--- a/fs/ntfs3/inode.c
+++ b/fs/ntfs3/inode.c
@@ -129,6 +129,9 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 	rsize = attr->non_res ? 0 : le32_to_cpu(attr->res.data_size);
 	asize = le32_to_cpu(attr->size);
 
+	if (le16_to_cpu(attr->name_off) + attr->name_len > asize)
+		goto out;
+
 	switch (attr->type) {
 	case ATTR_STD:
 		if (attr->non_res ||
@@ -364,7 +367,13 @@ static struct inode *ntfs_read_mft(struct inode *inode,
 attr_unpack_run:
 	roff = le16_to_cpu(attr->nres.run_off);
 
+	if (roff > asize) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	t64 = le64_to_cpu(attr->nres.svcn);
+
 	err = run_unpack_ex(run, sbi, ino, t64, le64_to_cpu(attr->nres.evcn),
 			    t64, Add2Ptr(attr, roff), asize - roff);
 	if (err < 0)
diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index 861e35791506..fd342da398be 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -220,6 +220,11 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 			return NULL;
 		}
 
+		if (off + asize < off) {
+			/* overflow check */
+			return NULL;
+		}
+
 		attr = Add2Ptr(attr, asize);
 		off += asize;
 	}
@@ -260,6 +265,11 @@ struct ATTRIB *mi_enum_attr(struct mft_inode *mi, struct ATTRIB *attr)
 		if (t16 + t32 > asize)
 			return NULL;
 
+		if (attr->name_len &&
+		    le16_to_cpu(attr->name_off) + sizeof(short) * attr->name_len > t16) {
+			return NULL;
+		}
+
 		return attr;
 	}
 
diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 39b09f32f4db..33b1833ad525 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -789,7 +789,7 @@ static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
 						 : (u32)boot->record_size
 							   << sbi->cluster_bits;
 
-	if (record_size > MAXIMUM_BYTES_PER_MFT)
+	if (record_size > MAXIMUM_BYTES_PER_MFT || record_size < SECTOR_SIZE)
 		goto out;
 
 	sbi->record_bits = blksize_bits(record_size);
@@ -1136,7 +1136,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto put_inode_out;
 	}
 	bytes = inode->i_size;
-	sbi->def_table = t = kmalloc(bytes, GFP_NOFS);
+	sbi->def_table = t = kmalloc(bytes, GFP_NOFS | __GFP_NOWARN);
 	if (!t) {
 		err = -ENOMEM;
 		goto put_inode_out;
@@ -1255,9 +1255,9 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	ref.low = cpu_to_le32(MFT_REC_ROOT);
 	ref.seq = cpu_to_le16(MFT_REC_ROOT);
 	inode = ntfs_iget5(sb, &ref, &NAME_ROOT);
-	if (IS_ERR(inode)) {
+	if (IS_ERR(inode) || !inode->i_op) {
 		ntfs_err(sb, "Failed to load root.");
-		err = PTR_ERR(inode);
+		err = IS_ERR(inode) ? PTR_ERR(inode) : -EINVAL;
 		goto out;
 	}
 
@@ -1276,6 +1276,7 @@ static int ntfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	 * Free resources here.
 	 * ntfs_fs_free will be called with fc->s_fs_info = NULL
 	 */
+	put_mount_options(sbi->options);
 	put_ntfs(sbi);
 	sb->s_fs_info = NULL;
 
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 3fc86c51e260..eca984d6484d 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -589,28 +589,42 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 			goto out_revert_creds;
 	}
 
-	err = -ENOMEM;
-	override_cred = prepare_creds();
-	if (override_cred) {
+	if (!attr->hardlink) {
+		err = -ENOMEM;
+		override_cred = prepare_creds();
+		if (!override_cred)
+			goto out_revert_creds;
+		/*
+		 * In the creation cases(create, mkdir, mknod, symlink),
+		 * ovl should transfer current's fs{u,g}id to underlying
+		 * fs. Because underlying fs want to initialize its new
+		 * inode owner using current's fs{u,g}id. And in this
+		 * case, the @inode is a new inode that is initialized
+		 * in inode_init_owner() to current's fs{u,g}id. So use
+		 * the inode's i_{u,g}id to override the cred's fs{u,g}id.
+		 *
+		 * But in the other hardlink case, ovl_link() does not
+		 * create a new inode, so just use the ovl mounter's
+		 * fs{u,g}id.
+		 */
 		override_cred->fsuid = inode->i_uid;
 		override_cred->fsgid = inode->i_gid;
-		if (!attr->hardlink) {
-			err = security_dentry_create_files_as(dentry,
-					attr->mode, &dentry->d_name, old_cred,
-					override_cred);
-			if (err) {
-				put_cred(override_cred);
-				goto out_revert_creds;
-			}
+		err = security_dentry_create_files_as(dentry,
+				attr->mode, &dentry->d_name, old_cred,
+				override_cred);
+		if (err) {
+			put_cred(override_cred);
+			goto out_revert_creds;
 		}
 		put_cred(override_creds(override_cred));
 		put_cred(override_cred);
-
-		if (!ovl_dentry_is_whiteout(dentry))
-			err = ovl_create_upper(dentry, inode, attr);
-		else
-			err = ovl_create_over_whiteout(dentry, inode, attr);
 	}
+
+	if (!ovl_dentry_is_whiteout(dentry))
+		err = ovl_create_upper(dentry, inode, attr);
+	else
+		err = ovl_create_over_whiteout(dentry, inode, attr);
+
 out_revert_creds:
 	revert_creds(old_cred);
 	return err;
diff --git a/fs/pnode.c b/fs/pnode.c
index 1106137c747a..468e4e65a615 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -244,7 +244,7 @@ static int propagate_one(struct mount *m)
 		}
 		do {
 			struct mount *parent = last_source->mnt_parent;
-			if (last_source == first_source)
+			if (peers(last_source, first_source))
 				break;
 			done = parent->mnt_master == p;
 			if (done && peers(n, parent))
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 74e4d93f3e08..f3fa3625d772 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -670,7 +670,7 @@ static int ramoops_parse_dt(struct platform_device *pdev,
 		field = value;						\
 	}
 
-	parse_u32("mem-type", pdata->record_size, pdata->mem_type);
+	parse_u32("mem-type", pdata->mem_type, pdata->mem_type);
 	parse_u32("record-size", pdata->record_size, 0);
 	parse_u32("console-size", pdata->console_size, 0);
 	parse_u32("ftrace-size", pdata->ftrace_size, 0);
diff --git a/fs/pstore/zone.c b/fs/pstore/zone.c
index 7c8f8feac6c3..5d3f944f6018 100644
--- a/fs/pstore/zone.c
+++ b/fs/pstore/zone.c
@@ -761,7 +761,7 @@ static inline int notrace psz_kmsg_write_record(struct psz_context *cxt,
 		/* avoid destroying old data, allocate a new one */
 		len = zone->buffer_size + sizeof(*zone->buffer);
 		zone->oldbuf = zone->buffer;
-		zone->buffer = kzalloc(len, GFP_KERNEL);
+		zone->buffer = kzalloc(len, GFP_ATOMIC);
 		if (!zone->buffer) {
 			zone->buffer = zone->oldbuf;
 			return -ENOMEM;
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 09d1307959d0..cddd07b7d132 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2317,6 +2317,8 @@ static int vfs_setup_quota_inode(struct inode *inode, int type)
 	struct super_block *sb = inode->i_sb;
 	struct quota_info *dqopt = sb_dqopt(sb);
 
+	if (is_bad_inode(inode))
+		return -EUCLEAN;
 	if (!S_ISREG(inode->i_mode))
 		return -EACCES;
 	if (IS_RDONLY(inode))
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 6a0e8ef664c1..d2488b7e54a5 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -599,7 +599,7 @@ static void udf_do_extend_final_block(struct inode *inode,
 	 */
 	if (new_elen <= (last_ext->extLength & UDF_EXTENT_LENGTH_MASK))
 		return;
-	added_bytes = (last_ext->extLength & UDF_EXTENT_LENGTH_MASK) - new_elen;
+	added_bytes = new_elen - (last_ext->extLength & UDF_EXTENT_LENGTH_MASK);
 	last_ext->extLength += added_bytes;
 	UDF_I(inode)->i_lenExtents += added_bytes;
 
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index 142474b4af96..d94b9ed9443e 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -149,8 +149,8 @@ struct devfreq_stats {
  * @work:	delayed work for load monitoring.
  * @previous_freq:	previously configured frequency value.
  * @last_status:	devfreq user device info, performance statistics
- * @data:	Private data of the governor. The devfreq framework does not
- *		touch this.
+ * @data:	devfreq driver pass to governors, governor should not change it.
+ * @governor_data:	private data for governors, devfreq core doesn't touch it.
  * @user_min_freq_req:	PM QoS minimum frequency request from user (via sysfs)
  * @user_max_freq_req:	PM QoS maximum frequency request from user (via sysfs)
  * @scaling_min_freq:	Limit minimum frequency requested by OPP interface
@@ -187,7 +187,8 @@ struct devfreq {
 	unsigned long previous_freq;
 	struct devfreq_dev_status last_status;
 
-	void *data; /* private data for governors */
+	void *data;
+	void *governor_data;
 
 	struct dev_pm_qos_request user_min_freq_req;
 	struct dev_pm_qos_request user_max_freq_req;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 4cd4ed34d3cb..5598fc348c69 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1114,8 +1114,6 @@ void efi_check_for_embedded_firmwares(void);
 static inline void efi_check_for_embedded_firmwares(void) { }
 #endif
 
-efi_status_t efi_random_get_seed(void);
-
 /*
  * Arch code can implement the following three template macros, avoiding
  * reptition for the void/non-void return cases of {__,}efi_call_virt():
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 68fcf3ec9cf6..1e1ac116dd13 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1195,6 +1195,7 @@ extern int locks_delete_block(struct file_lock *);
 extern int vfs_test_lock(struct file *, struct file_lock *);
 extern int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct file_lock *);
 extern int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
+bool vfs_inode_has_locks(struct inode *inode);
 extern int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl);
 extern int __break_lease(struct inode *inode, unsigned int flags, unsigned int type);
 extern void lease_get_mtime(struct inode *, struct timespec64 *time);
@@ -1307,6 +1308,11 @@ static inline int vfs_cancel_lock(struct file *filp, struct file_lock *fl)
 	return 0;
 }
 
+static inline bool vfs_inode_has_locks(struct inode *inode)
+{
+	return false;
+}
+
 static inline int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl)
 {
 	return -ENOLCK;
diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
index 8eca7f25c432..591bc4cefe1d 100644
--- a/include/linux/mbcache.h
+++ b/include/linux/mbcache.h
@@ -10,16 +10,29 @@
 
 struct mb_cache;
 
+/* Cache entry flags */
+enum {
+	MBE_REFERENCED_B = 0,
+	MBE_REUSABLE_B
+};
+
 struct mb_cache_entry {
 	/* List of entries in cache - protected by cache->c_list_lock */
 	struct list_head	e_list;
-	/* Hash table list - protected by hash chain bitlock */
+	/*
+	 * Hash table list - protected by hash chain bitlock. The entry is
+	 * guaranteed to be hashed while e_refcnt > 0.
+	 */
 	struct hlist_bl_node	e_hash_list;
+	/*
+	 * Entry refcount. Once it reaches zero, entry is unhashed and freed.
+	 * While refcount > 0, the entry is guaranteed to stay in the hash and
+	 * e.g. mb_cache_entry_try_delete() will fail.
+	 */
 	atomic_t		e_refcnt;
 	/* Key in hash - stable during lifetime of the entry */
 	u32			e_key;
-	u32			e_referenced:1;
-	u32			e_reusable:1;
+	unsigned long		e_flags;
 	/* User provided value - stable during lifetime of the entry */
 	u64			e_value;
 };
@@ -29,20 +42,20 @@ void mb_cache_destroy(struct mb_cache *cache);
 
 int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
 			  u64 value, bool reusable);
-void __mb_cache_entry_free(struct mb_cache_entry *entry);
+void __mb_cache_entry_free(struct mb_cache *cache,
+			   struct mb_cache_entry *entry);
 void mb_cache_entry_wait_unused(struct mb_cache_entry *entry);
-static inline int mb_cache_entry_put(struct mb_cache *cache,
-				     struct mb_cache_entry *entry)
+static inline void mb_cache_entry_put(struct mb_cache *cache,
+				      struct mb_cache_entry *entry)
 {
 	unsigned int cnt = atomic_dec_return(&entry->e_refcnt);
 
 	if (cnt > 0) {
-		if (cnt <= 3)
+		if (cnt <= 2)
 			wake_up_var(&entry->e_refcnt);
-		return 0;
+		return;
 	}
-	__mb_cache_entry_free(entry);
-	return 1;
+	__mb_cache_entry_free(cache, entry);
 }
 
 struct mb_cache_entry *mb_cache_entry_delete_or_get(struct mb_cache *cache,
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 66eaf0aa7f69..3e72133545ca 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -1074,6 +1074,11 @@ enum {
 	MLX5_VPORT_ADMIN_STATE_AUTO  = 0x2,
 };
 
+enum {
+	MLX5_VPORT_CVLAN_INSERT_WHEN_NO_CVLAN  = 0x1,
+	MLX5_VPORT_CVLAN_INSERT_ALWAYS         = 0x3,
+};
+
 enum {
 	MLX5_L3_PROT_TYPE_IPV4		= 0,
 	MLX5_L3_PROT_TYPE_IPV6		= 1,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index cd9d1c95129e..49ea0004109e 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -822,7 +822,8 @@ struct mlx5_ifc_e_switch_cap_bits {
 	u8         vport_svlan_insert[0x1];
 	u8         vport_cvlan_insert_if_not_exist[0x1];
 	u8         vport_cvlan_insert_overwrite[0x1];
-	u8         reserved_at_5[0x2];
+	u8         reserved_at_5[0x1];
+	u8         vport_cvlan_insert_always[0x1];
 	u8         esw_shared_ingress_acl[0x1];
 	u8         esw_uplink_ingress_acl[0x1];
 	u8         root_ft_on_other_esw[0x1];
diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index ada1296c87d5..72f5ebc5c97a 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -197,7 +197,7 @@ struct ip_set_region {
 };
 
 /* Max range where every element is added/deleted in one step */
-#define IPSET_MAX_RANGE		(1<<20)
+#define IPSET_MAX_RANGE		(1<<14)
 
 /* The max revision number supported by any set type + 1 */
 #define IPSET_REVISION_MAX	9
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 039f59ee8f43..de235916c31c 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -7,6 +7,7 @@
 #ifndef _LINUX_NVME_H
 #define _LINUX_NVME_H
 
+#include <linux/bits.h>
 #include <linux/types.h>
 #include <linux/uuid.h>
 
@@ -539,7 +540,7 @@ enum {
 	NVME_CMD_EFFECTS_NCC		= 1 << 2,
 	NVME_CMD_EFFECTS_NIC		= 1 << 3,
 	NVME_CMD_EFFECTS_CCC		= 1 << 4,
-	NVME_CMD_EFFECTS_CSE_MASK	= 3 << 16,
+	NVME_CMD_EFFECTS_CSE_MASK	= GENMASK(18, 16),
 	NVME_CMD_EFFECTS_UUID_SEL	= 1 << 19,
 };
 
diff --git a/include/linux/sunrpc/rpc_pipe_fs.h b/include/linux/sunrpc/rpc_pipe_fs.h
index cd188a527d16..3b35b6f6533a 100644
--- a/include/linux/sunrpc/rpc_pipe_fs.h
+++ b/include/linux/sunrpc/rpc_pipe_fs.h
@@ -92,6 +92,11 @@ extern ssize_t rpc_pipe_generic_upcall(struct file *, struct rpc_pipe_msg *,
 				       char __user *, size_t);
 extern int rpc_queue_upcall(struct rpc_pipe *, struct rpc_pipe_msg *);
 
+/* returns true if the msg is in-flight, i.e., already eaten by the peer */
+static inline bool rpc_msg_is_inflight(const struct rpc_pipe_msg *msg) {
+	return (msg->copied != 0 && list_empty(&msg->list));
+}
+
 struct rpc_clnt;
 extern struct dentry *rpc_create_client_dir(struct dentry *, const char *, struct rpc_clnt *);
 extern int rpc_remove_client_dir(struct rpc_clnt *);
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 3214848402ec..1120363987d0 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -93,8 +93,6 @@ struct mptcp_out_options {
 };
 
 #ifdef CONFIG_MPTCP
-extern struct request_sock_ops mptcp_subflow_request_sock_ops;
-
 void mptcp_init(void);
 
 static inline bool sk_is_mptcp(const struct sock *sk)
@@ -182,6 +180,9 @@ void mptcp_seq_show(struct seq_file *seq);
 int mptcp_subflow_init_cookie_req(struct request_sock *req,
 				  const struct sock *sk_listener,
 				  struct sk_buff *skb);
+struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *ops,
+					       struct sock *sk_listener,
+					       bool attach_listener);
 
 __be32 mptcp_get_reset_option(const struct sk_buff *skb);
 
@@ -274,6 +275,13 @@ static inline int mptcp_subflow_init_cookie_req(struct request_sock *req,
 	return 0; /* TCP fallback */
 }
 
+static inline struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *ops,
+							     struct sock *sk_listener,
+							     bool attach_listener)
+{
+	return NULL;
+}
+
 static inline __be32 mptcp_reset_option(const struct sk_buff *skb)  { return htonl(0u); }
 #endif /* CONFIG_MPTCP */
 
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 53746494eb84..80df8ff5e675 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -283,17 +283,29 @@ struct nft_set_iter {
 /**
  *	struct nft_set_desc - description of set elements
  *
+ *	@ktype: key type
  *	@klen: key length
+ *	@dtype: data type
  *	@dlen: data length
+ *	@objtype: object type
+ *	@flags: flags
  *	@size: number of set elements
+ *	@policy: set policy
+ *	@gc_int: garbage collector interval
  *	@field_len: length of each field in concatenation, bytes
  *	@field_count: number of concatenated fields in element
  *	@expr: set must support for expressions
  */
 struct nft_set_desc {
+	u32			ktype;
 	unsigned int		klen;
+	u32			dtype;
 	unsigned int		dlen;
+	u32			objtype;
 	unsigned int		size;
+	u32			policy;
+	u32			gc_int;
+	u64			timeout;
 	u8			field_len[NFT_REG32_COUNT];
 	u8			field_count;
 	bool			expr;
@@ -550,7 +562,9 @@ void *nft_set_catchall_gc(const struct nft_set *set);
 
 static inline unsigned long nft_set_gc_interval(const struct nft_set *set)
 {
-	return set->gc_int ? msecs_to_jiffies(set->gc_int) : HZ;
+	u32 gc_int = READ_ONCE(set->gc_int);
+
+	return gc_int ? msecs_to_jiffies(gc_int) : HZ;
 }
 
 /**
@@ -1499,6 +1513,9 @@ struct nft_trans_rule {
 struct nft_trans_set {
 	struct nft_set			*set;
 	u32				set_id;
+	u32				gc_int;
+	u64				timeout;
+	bool				update;
 	bool				bound;
 };
 
@@ -1508,6 +1525,12 @@ struct nft_trans_set {
 	(((struct nft_trans_set *)trans->data)->set_id)
 #define nft_trans_set_bound(trans)	\
 	(((struct nft_trans_set *)trans->data)->bound)
+#define nft_trans_set_update(trans)	\
+	(((struct nft_trans_set *)trans->data)->update)
+#define nft_trans_set_timeout(trans)	\
+	(((struct nft_trans_set *)trans->data)->timeout)
+#define nft_trans_set_gc_int(trans)	\
+	(((struct nft_trans_set *)trans->data)->gc_int)
 
 struct nft_trans_chain {
 	bool				update;
diff --git a/include/sound/soc-dai.h b/include/sound/soc-dai.h
index 0dcb361a98bb..ef3bb1bcea4e 100644
--- a/include/sound/soc-dai.h
+++ b/include/sound/soc-dai.h
@@ -295,9 +295,9 @@ struct snd_soc_dai_ops {
 			unsigned int *rx_num, unsigned int *rx_slot);
 	int (*set_tristate)(struct snd_soc_dai *dai, int tristate);
 
-	int (*set_sdw_stream)(struct snd_soc_dai *dai,
-			void *stream, int direction);
-	void *(*get_sdw_stream)(struct snd_soc_dai *dai, int direction);
+	int (*set_stream)(struct snd_soc_dai *dai,
+			  void *stream, int direction);
+	void *(*get_stream)(struct snd_soc_dai *dai, int direction);
 
 	/*
 	 * DAI digital mute - optional.
@@ -515,42 +515,42 @@ static inline void *snd_soc_dai_get_drvdata(struct snd_soc_dai *dai)
 }
 
 /**
- * snd_soc_dai_set_sdw_stream() - Configures a DAI for SDW stream operation
+ * snd_soc_dai_set_stream() - Configures a DAI for stream operation
  * @dai: DAI
- * @stream: STREAM
+ * @stream: STREAM (opaque structure depending on DAI type)
  * @direction: Stream direction(Playback/Capture)
- * SoundWire subsystem doesn't have a notion of direction and we reuse
+ * Some subsystems, such as SoundWire, don't have a notion of direction and we reuse
  * the ASoC stream direction to configure sink/source ports.
  * Playback maps to source ports and Capture for sink ports.
  *
  * This should be invoked with NULL to clear the stream set previously.
  * Returns 0 on success, a negative error code otherwise.
  */
-static inline int snd_soc_dai_set_sdw_stream(struct snd_soc_dai *dai,
-				void *stream, int direction)
+static inline int snd_soc_dai_set_stream(struct snd_soc_dai *dai,
+					 void *stream, int direction)
 {
-	if (dai->driver->ops->set_sdw_stream)
-		return dai->driver->ops->set_sdw_stream(dai, stream, direction);
+	if (dai->driver->ops->set_stream)
+		return dai->driver->ops->set_stream(dai, stream, direction);
 	else
 		return -ENOTSUPP;
 }
 
 /**
- * snd_soc_dai_get_sdw_stream() - Retrieves SDW stream from DAI
+ * snd_soc_dai_get_stream() - Retrieves stream from DAI
  * @dai: DAI
  * @direction: Stream direction(Playback/Capture)
  *
  * This routine only retrieves that was previously configured
- * with snd_soc_dai_get_sdw_stream()
+ * with snd_soc_dai_get_stream()
  *
  * Returns pointer to stream or an ERR_PTR value, e.g.
  * ERR_PTR(-ENOTSUPP) if callback is not supported;
  */
-static inline void *snd_soc_dai_get_sdw_stream(struct snd_soc_dai *dai,
-					       int direction)
+static inline void *snd_soc_dai_get_stream(struct snd_soc_dai *dai,
+					   int direction)
 {
-	if (dai->driver->ops->get_sdw_stream)
-		return dai->driver->ops->get_sdw_stream(dai, direction);
+	if (dai->driver->ops->get_stream)
+		return dai->driver->ops->get_stream(dai, direction);
 	else
 		return ERR_PTR(-ENOTSUPP);
 }
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 61a64d1b2bb6..c649c7fcb9af 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -104,6 +104,7 @@ TRACE_DEFINE_ENUM(EXT4_FC_REASON_RESIZE);
 TRACE_DEFINE_ENUM(EXT4_FC_REASON_RENAME_DIR);
 TRACE_DEFINE_ENUM(EXT4_FC_REASON_FALLOC_RANGE);
 TRACE_DEFINE_ENUM(EXT4_FC_REASON_INODE_JOURNAL_DATA);
+TRACE_DEFINE_ENUM(EXT4_FC_REASON_ENCRYPTED_FILENAME);
 TRACE_DEFINE_ENUM(EXT4_FC_REASON_MAX);
 
 #define show_fc_reason(reason)						\
@@ -116,7 +117,8 @@ TRACE_DEFINE_ENUM(EXT4_FC_REASON_MAX);
 		{ EXT4_FC_REASON_RESIZE,	"RESIZE"},		\
 		{ EXT4_FC_REASON_RENAME_DIR,	"RENAME_DIR"},		\
 		{ EXT4_FC_REASON_FALLOC_RANGE,	"FALLOC_RANGE"},	\
-		{ EXT4_FC_REASON_INODE_JOURNAL_DATA,	"INODE_JOURNAL_DATA"})
+		{ EXT4_FC_REASON_INODE_JOURNAL_DATA,	"INODE_JOURNAL_DATA"}, \
+		{ EXT4_FC_REASON_ENCRYPTED_FILENAME,	"ENCRYPTED_FILENAME"})
 
 TRACE_EVENT(ext4_other_inode_update_time,
 	TP_PROTO(struct inode *inode, ino_t orig_ino),
@@ -2764,7 +2766,7 @@ TRACE_EVENT(ext4_fc_stats,
 	),
 
 	TP_printk("dev %d,%d fc ineligible reasons:\n"
-		  "%s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u "
+		  "%s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u"
 		  "num_commits:%lu, ineligible: %lu, numblks: %lu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  FC_REASON_NAME_STAT(EXT4_FC_REASON_XATTR),
@@ -2776,6 +2778,7 @@ TRACE_EVENT(ext4_fc_stats,
 		  FC_REASON_NAME_STAT(EXT4_FC_REASON_RENAME_DIR),
 		  FC_REASON_NAME_STAT(EXT4_FC_REASON_FALLOC_RANGE),
 		  FC_REASON_NAME_STAT(EXT4_FC_REASON_INODE_JOURNAL_DATA),
+		  FC_REASON_NAME_STAT(EXT4_FC_REASON_ENCRYPTED_FILENAME),
 		  __entry->fc_commits, __entry->fc_ineligible_commits,
 		  __entry->fc_numblks)
 );
diff --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h
index a4dfe005983d..29414288ea3e 100644
--- a/include/trace/events/jbd2.h
+++ b/include/trace/events/jbd2.h
@@ -40,7 +40,7 @@ DECLARE_EVENT_CLASS(jbd2_commit,
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	char,	sync_commit		  )
-		__field(	int,	transaction		  )
+		__field(	tid_t,	transaction		  )
 	),
 
 	TP_fast_assign(
@@ -49,7 +49,7 @@ DECLARE_EVENT_CLASS(jbd2_commit,
 		__entry->transaction	= commit_transaction->t_tid;
 	),
 
-	TP_printk("dev %d,%d transaction %d sync %d",
+	TP_printk("dev %d,%d transaction %u sync %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->transaction, __entry->sync_commit)
 );
@@ -97,8 +97,8 @@ TRACE_EVENT(jbd2_end_commit,
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	char,	sync_commit		  )
-		__field(	int,	transaction		  )
-		__field(	int,	head		  	  )
+		__field(	tid_t,	transaction		  )
+		__field(	tid_t,	head		  	  )
 	),
 
 	TP_fast_assign(
@@ -108,7 +108,7 @@ TRACE_EVENT(jbd2_end_commit,
 		__entry->head		= journal->j_tail_sequence;
 	),
 
-	TP_printk("dev %d,%d transaction %d sync %d head %d",
+	TP_printk("dev %d,%d transaction %u sync %d head %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->transaction, __entry->sync_commit, __entry->head)
 );
@@ -134,14 +134,14 @@ TRACE_EVENT(jbd2_submit_inode_data,
 );
 
 DECLARE_EVENT_CLASS(jbd2_handle_start_class,
-	TP_PROTO(dev_t dev, unsigned long tid, unsigned int type,
+	TP_PROTO(dev_t dev, tid_t tid, unsigned int type,
 		 unsigned int line_no, int requested_blocks),
 
 	TP_ARGS(dev, tid, type, line_no, requested_blocks),
 
 	TP_STRUCT__entry(
 		__field(		dev_t,	dev		)
-		__field(	unsigned long,	tid		)
+		__field(		tid_t,	tid		)
 		__field(	 unsigned int,	type		)
 		__field(	 unsigned int,	line_no		)
 		__field(		  int,	requested_blocks)
@@ -155,28 +155,28 @@ DECLARE_EVENT_CLASS(jbd2_handle_start_class,
 		__entry->requested_blocks = requested_blocks;
 	),
 
-	TP_printk("dev %d,%d tid %lu type %u line_no %u "
+	TP_printk("dev %d,%d tid %u type %u line_no %u "
 		  "requested_blocks %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
 		  __entry->type, __entry->line_no, __entry->requested_blocks)
 );
 
 DEFINE_EVENT(jbd2_handle_start_class, jbd2_handle_start,
-	TP_PROTO(dev_t dev, unsigned long tid, unsigned int type,
+	TP_PROTO(dev_t dev, tid_t tid, unsigned int type,
 		 unsigned int line_no, int requested_blocks),
 
 	TP_ARGS(dev, tid, type, line_no, requested_blocks)
 );
 
 DEFINE_EVENT(jbd2_handle_start_class, jbd2_handle_restart,
-	TP_PROTO(dev_t dev, unsigned long tid, unsigned int type,
+	TP_PROTO(dev_t dev, tid_t tid, unsigned int type,
 		 unsigned int line_no, int requested_blocks),
 
 	TP_ARGS(dev, tid, type, line_no, requested_blocks)
 );
 
 TRACE_EVENT(jbd2_handle_extend,
-	TP_PROTO(dev_t dev, unsigned long tid, unsigned int type,
+	TP_PROTO(dev_t dev, tid_t tid, unsigned int type,
 		 unsigned int line_no, int buffer_credits,
 		 int requested_blocks),
 
@@ -184,7 +184,7 @@ TRACE_EVENT(jbd2_handle_extend,
 
 	TP_STRUCT__entry(
 		__field(		dev_t,	dev		)
-		__field(	unsigned long,	tid		)
+		__field(		tid_t,	tid		)
 		__field(	 unsigned int,	type		)
 		__field(	 unsigned int,	line_no		)
 		__field(		  int,	buffer_credits  )
@@ -200,7 +200,7 @@ TRACE_EVENT(jbd2_handle_extend,
 		__entry->requested_blocks = requested_blocks;
 	),
 
-	TP_printk("dev %d,%d tid %lu type %u line_no %u "
+	TP_printk("dev %d,%d tid %u type %u line_no %u "
 		  "buffer_credits %d requested_blocks %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
 		  __entry->type, __entry->line_no, __entry->buffer_credits,
@@ -208,7 +208,7 @@ TRACE_EVENT(jbd2_handle_extend,
 );
 
 TRACE_EVENT(jbd2_handle_stats,
-	TP_PROTO(dev_t dev, unsigned long tid, unsigned int type,
+	TP_PROTO(dev_t dev, tid_t tid, unsigned int type,
 		 unsigned int line_no, int interval, int sync,
 		 int requested_blocks, int dirtied_blocks),
 
@@ -217,7 +217,7 @@ TRACE_EVENT(jbd2_handle_stats,
 
 	TP_STRUCT__entry(
 		__field(		dev_t,	dev		)
-		__field(	unsigned long,	tid		)
+		__field(		tid_t,	tid		)
 		__field(	 unsigned int,	type		)
 		__field(	 unsigned int,	line_no		)
 		__field(		  int,	interval	)
@@ -237,7 +237,7 @@ TRACE_EVENT(jbd2_handle_stats,
 		__entry->dirtied_blocks	  = dirtied_blocks;
 	),
 
-	TP_printk("dev %d,%d tid %lu type %u line_no %u interval %d "
+	TP_printk("dev %d,%d tid %u type %u line_no %u interval %d "
 		  "sync %d requested_blocks %d dirtied_blocks %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
 		  __entry->type, __entry->line_no, __entry->interval,
@@ -246,14 +246,14 @@ TRACE_EVENT(jbd2_handle_stats,
 );
 
 TRACE_EVENT(jbd2_run_stats,
-	TP_PROTO(dev_t dev, unsigned long tid,
+	TP_PROTO(dev_t dev, tid_t tid,
 		 struct transaction_run_stats_s *stats),
 
 	TP_ARGS(dev, tid, stats),
 
 	TP_STRUCT__entry(
 		__field(		dev_t,	dev		)
-		__field(	unsigned long,	tid		)
+		__field(		tid_t,	tid		)
 		__field(	unsigned long,	wait		)
 		__field(	unsigned long,	request_delay	)
 		__field(	unsigned long,	running		)
@@ -279,7 +279,7 @@ TRACE_EVENT(jbd2_run_stats,
 		__entry->blocks_logged	= stats->rs_blocks_logged;
 	),
 
-	TP_printk("dev %d,%d tid %lu wait %u request_delay %u running %u "
+	TP_printk("dev %d,%d tid %u wait %u request_delay %u running %u "
 		  "locked %u flushing %u logging %u handle_count %u "
 		  "blocks %u blocks_logged %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
@@ -294,14 +294,14 @@ TRACE_EVENT(jbd2_run_stats,
 );
 
 TRACE_EVENT(jbd2_checkpoint_stats,
-	TP_PROTO(dev_t dev, unsigned long tid,
+	TP_PROTO(dev_t dev, tid_t tid,
 		 struct transaction_chp_stats_s *stats),
 
 	TP_ARGS(dev, tid, stats),
 
 	TP_STRUCT__entry(
 		__field(		dev_t,	dev		)
-		__field(	unsigned long,	tid		)
+		__field(		tid_t,	tid		)
 		__field(	unsigned long,	chp_time	)
 		__field(		__u32,	forced_to_close	)
 		__field(		__u32,	written		)
@@ -317,7 +317,7 @@ TRACE_EVENT(jbd2_checkpoint_stats,
 		__entry->dropped	= stats->cs_dropped;
 	),
 
-	TP_printk("dev %d,%d tid %lu chp_time %u forced_to_close %u "
+	TP_printk("dev %d,%d tid %u chp_time %u forced_to_close %u "
 		  "written %u dropped %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
 		  jiffies_to_msecs(__entry->chp_time),
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index eebbe8a6da0c..c587221a289c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2701,7 +2701,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	return false;
 }
 
-static inline int io_fixup_rw_res(struct io_kiocb *req, unsigned res)
+static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 {
 	struct io_async_rw *io = req->async_data;
 
@@ -7598,7 +7598,7 @@ static int io_run_task_work_sig(void)
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 					  struct io_wait_queue *iowq,
-					  ktime_t timeout)
+					  ktime_t *timeout)
 {
 	int ret;
 
@@ -7610,7 +7610,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	if (test_bit(0, &ctx->check_cq_overflow))
 		return 1;
 
-	if (!schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS))
+	if (!schedule_hrtimeout(timeout, HRTIMER_MODE_ABS))
 		return -ETIME;
 	return 1;
 }
@@ -7673,7 +7673,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		}
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
+		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
 		finish_wait(&ctx->cq_wait, &iowq.wq);
 		cond_resched();
 	} while (ret > 0);
@@ -10895,8 +10895,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		return -ENXIO;
 
 	if (ctx->restricted) {
-		if (opcode >= IORING_REGISTER_LAST)
-			return -EINVAL;
 		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
 		if (!test_bit(opcode, ctx->restrictions.register_op))
 			return -EACCES;
@@ -11028,6 +11026,9 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	long ret = -EBADF;
 	struct fd f;
 
+	if (opcode >= IORING_REGISTER_LAST)
+		return -EINVAL;
+
 	f = fdget(fd);
 	if (!f.file)
 		return -EBADF;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e95088144471..d8795036202a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12215,12 +12215,12 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (flags & ~PERF_FLAG_ALL)
 		return -EINVAL;
 
-	/* Do we allow access to perf_event_open(2) ? */
-	err = security_perf_event_open(&attr, PERF_SECURITY_OPEN);
+	err = perf_copy_attr(attr_uptr, &attr);
 	if (err)
 		return err;
 
-	err = perf_copy_attr(attr_uptr, &attr);
+	/* Do we allow access to perf_event_open(2) ? */
+	err = security_perf_event_open(&attr, PERF_SECURITY_OPEN);
 	if (err)
 		return err;
 
diff --git a/kernel/kcsan/core.c b/kernel/kcsan/core.c
index 76e67d1e02d4..526510b3791e 100644
--- a/kernel/kcsan/core.c
+++ b/kernel/kcsan/core.c
@@ -14,10 +14,12 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
+#include <linux/minmax.h>
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/preempt.h>
 #include <linux/sched.h>
+#include <linux/string.h>
 #include <linux/uaccess.h>
 
 #include "encoding.h"
@@ -1060,3 +1062,51 @@ EXPORT_SYMBOL(__tsan_atomic_thread_fence);
 void __tsan_atomic_signal_fence(int memorder);
 void __tsan_atomic_signal_fence(int memorder) { }
 EXPORT_SYMBOL(__tsan_atomic_signal_fence);
+
+#ifdef __HAVE_ARCH_MEMSET
+void *__tsan_memset(void *s, int c, size_t count);
+noinline void *__tsan_memset(void *s, int c, size_t count)
+{
+	/*
+	 * Instead of not setting up watchpoints where accessed size is greater
+	 * than MAX_ENCODABLE_SIZE, truncate checked size to MAX_ENCODABLE_SIZE.
+	 */
+	size_t check_len = min_t(size_t, count, MAX_ENCODABLE_SIZE);
+
+	check_access(s, check_len, KCSAN_ACCESS_WRITE);
+	return memset(s, c, count);
+}
+#else
+void *__tsan_memset(void *s, int c, size_t count) __alias(memset);
+#endif
+EXPORT_SYMBOL(__tsan_memset);
+
+#ifdef __HAVE_ARCH_MEMMOVE
+void *__tsan_memmove(void *dst, const void *src, size_t len);
+noinline void *__tsan_memmove(void *dst, const void *src, size_t len)
+{
+	size_t check_len = min_t(size_t, len, MAX_ENCODABLE_SIZE);
+
+	check_access(dst, check_len, KCSAN_ACCESS_WRITE);
+	check_access(src, check_len, 0);
+	return memmove(dst, src, len);
+}
+#else
+void *__tsan_memmove(void *dst, const void *src, size_t len) __alias(memmove);
+#endif
+EXPORT_SYMBOL(__tsan_memmove);
+
+#ifdef __HAVE_ARCH_MEMCPY
+void *__tsan_memcpy(void *dst, const void *src, size_t len);
+noinline void *__tsan_memcpy(void *dst, const void *src, size_t len)
+{
+	size_t check_len = min_t(size_t, len, MAX_ENCODABLE_SIZE);
+
+	check_access(dst, check_len, KCSAN_ACCESS_WRITE);
+	check_access(src, check_len, 0);
+	return memcpy(dst, src, len);
+}
+#else
+void *__tsan_memcpy(void *dst, const void *src, size_t len) __alias(memcpy);
+#endif
+EXPORT_SYMBOL(__tsan_memcpy);
diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index ae8396032b5d..4bd07cc3c0ea 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -892,32 +892,24 @@ static void trc_read_check_handler(void *t_in)
 
 	// If the task is no longer running on this CPU, leave.
 	if (unlikely(texp != t)) {
-		if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
-			wake_up(&trc_wait);
 		goto reset_ipi; // Already on holdout list, so will check later.
 	}
 
 	// If the task is not in a read-side critical section, and
 	// if this is the last reader, awaken the grace-period kthread.
 	if (likely(!READ_ONCE(t->trc_reader_nesting))) {
-		if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
-			wake_up(&trc_wait);
-		// Mark as checked after decrement to avoid false
-		// positives on the above WARN_ON_ONCE().
 		WRITE_ONCE(t->trc_reader_checked, true);
 		goto reset_ipi;
 	}
 	// If we are racing with an rcu_read_unlock_trace(), try again later.
-	if (unlikely(READ_ONCE(t->trc_reader_nesting) < 0)) {
-		if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
-			wake_up(&trc_wait);
+	if (unlikely(READ_ONCE(t->trc_reader_nesting) < 0))
 		goto reset_ipi;
-	}
 	WRITE_ONCE(t->trc_reader_checked, true);
 
 	// Get here if the task is in a read-side critical section.  Set
 	// its state so that it will awaken the grace-period kthread upon
 	// exit from that critical section.
+	atomic_inc(&trc_n_readers_need_end); // One more to wait on.
 	WARN_ON_ONCE(READ_ONCE(t->trc_reader_special.b.need_qs));
 	WRITE_ONCE(t->trc_reader_special.b.need_qs, true);
 
@@ -1017,21 +1009,15 @@ static void trc_wait_for_one_reader(struct task_struct *t,
 		if (per_cpu(trc_ipi_to_cpu, cpu) || t->trc_ipi_to_cpu >= 0)
 			return;
 
-		atomic_inc(&trc_n_readers_need_end);
 		per_cpu(trc_ipi_to_cpu, cpu) = true;
 		t->trc_ipi_to_cpu = cpu;
 		rcu_tasks_trace.n_ipis++;
-		if (smp_call_function_single(cpu,
-					     trc_read_check_handler, t, 0)) {
+		if (smp_call_function_single(cpu, trc_read_check_handler, t, 0)) {
 			// Just in case there is some other reason for
 			// failure than the target CPU being offline.
 			rcu_tasks_trace.n_ipis_fails++;
 			per_cpu(trc_ipi_to_cpu, cpu) = false;
 			t->trc_ipi_to_cpu = cpu;
-			if (atomic_dec_and_test(&trc_n_readers_need_end)) {
-				WARN_ON_ONCE(1);
-				wake_up(&trc_wait);
-			}
 		}
 	}
 }
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 420ff4bc67fd..4265d125d50f 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -328,6 +328,7 @@ config SCHED_TRACER
 config HWLAT_TRACER
 	bool "Tracer to detect hardware latencies (like SMIs)"
 	select GENERIC_TRACER
+	select TRACER_MAX_TRACE
 	help
 	 This tracer, when enabled will create one or more kernel threads,
 	 depending on what the cpumask file is set to, which each thread
@@ -363,6 +364,7 @@ config HWLAT_TRACER
 config OSNOISE_TRACER
 	bool "OS Noise tracer"
 	select GENERIC_TRACER
+	select TRACER_MAX_TRACE
 	help
 	  In the context of high-performance computing (HPC), the Operating
 	  System Noise (osnoise) refers to the interference experienced by an
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b26de6ff5d0b..114d94d1e0a9 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1409,6 +1409,7 @@ int tracing_snapshot_cond_disable(struct trace_array *tr)
 	return false;
 }
 EXPORT_SYMBOL_GPL(tracing_snapshot_cond_disable);
+#define free_snapshot(tr)	do { } while (0)
 #endif /* CONFIG_TRACER_SNAPSHOT */
 
 void tracer_tracing_off(struct trace_array *tr)
@@ -1679,6 +1680,8 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 }
 
 unsigned long __read_mostly	tracing_thresh;
+
+#ifdef CONFIG_TRACER_MAX_TRACE
 static const struct file_operations tracing_max_lat_fops;
 
 #ifdef LATENCY_FS_NOTIFY
@@ -1735,18 +1738,14 @@ void latency_fsnotify(struct trace_array *tr)
 	irq_work_queue(&tr->fsnotify_irqwork);
 }
 
-#elif defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER)	\
-	|| defined(CONFIG_OSNOISE_TRACER)
+#else /* !LATENCY_FS_NOTIFY */
 
 #define trace_create_maxlat_file(tr, d_tracer)				\
 	trace_create_file("tracing_max_latency", TRACE_MODE_WRITE,	\
 			  d_tracer, &tr->max_latency, &tracing_max_lat_fops)
 
-#else
-#define trace_create_maxlat_file(tr, d_tracer)	 do { } while (0)
 #endif
 
-#ifdef CONFIG_TRACER_MAX_TRACE
 /*
  * Copy the new maximum trace into the separate maximum-trace
  * structure. (this way the maximum trace is permanently saved,
@@ -1821,14 +1820,15 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu,
 		ring_buffer_record_off(tr->max_buffer.buffer);
 
 #ifdef CONFIG_TRACER_SNAPSHOT
-	if (tr->cond_snapshot && !tr->cond_snapshot->update(tr, cond_data))
-		goto out_unlock;
+	if (tr->cond_snapshot && !tr->cond_snapshot->update(tr, cond_data)) {
+		arch_spin_unlock(&tr->max_lock);
+		return;
+	}
 #endif
 	swap(tr->array_buffer.buffer, tr->max_buffer.buffer);
 
 	__update_max_tr(tr, tsk, cpu);
 
- out_unlock:
 	arch_spin_unlock(&tr->max_lock);
 }
 
@@ -1875,6 +1875,7 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	__update_max_tr(tr, tsk, cpu);
 	arch_spin_unlock(&tr->max_lock);
 }
+
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
 static int wait_on_pipe(struct trace_iterator *iter, int full)
@@ -6536,7 +6537,7 @@ tracing_thresh_write(struct file *filp, const char __user *ubuf,
 	return ret;
 }
 
-#if defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER)
+#ifdef CONFIG_TRACER_MAX_TRACE
 
 static ssize_t
 tracing_max_lat_read(struct file *filp, char __user *ubuf,
@@ -6763,7 +6764,20 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 
 		ret = print_trace_line(iter);
 		if (ret == TRACE_TYPE_PARTIAL_LINE) {
-			/* don't print partial lines */
+			/*
+			 * If one print_trace_line() fills entire trace_seq in one shot,
+			 * trace_seq_to_user() will returns -EBUSY because save_len == 0,
+			 * In this case, we need to consume it, otherwise, loop will peek
+			 * this event next time, resulting in an infinite loop.
+			 */
+			if (save_len == 0) {
+				iter->seq.full = 0;
+				trace_seq_puts(&iter->seq, "[LINE TOO BIG]\n");
+				trace_consume(iter);
+				break;
+			}
+
+			/* In other cases, don't print partial lines */
 			iter->seq.seq.len = save_len;
 			break;
 		}
@@ -7560,7 +7574,7 @@ static const struct file_operations tracing_thresh_fops = {
 	.llseek		= generic_file_llseek,
 };
 
-#if defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER)
+#ifdef CONFIG_TRACER_MAX_TRACE
 static const struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
@@ -9549,7 +9563,9 @@ init_tracer_tracefs(struct trace_array *tr, struct dentry *d_tracer)
 
 	create_trace_options_dir(tr);
 
+#ifdef CONFIG_TRACER_MAX_TRACE
 	trace_create_maxlat_file(tr, d_tracer);
+#endif
 
 	if (ftrace_create_function_files(tr, d_tracer))
 		MEM_FAIL(1, "Could not allocate function filter files");
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 28ea6c0be495..9fc598165f3a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -309,8 +309,7 @@ struct trace_array {
 	struct array_buffer	max_buffer;
 	bool			allocated_snapshot;
 #endif
-#if defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER) \
-	|| defined(CONFIG_OSNOISE_TRACER)
+#ifdef CONFIG_TRACER_MAX_TRACE
 	unsigned long		max_latency;
 #ifdef CONFIG_FSNOTIFY
 	struct dentry		*d_max_latency;
@@ -688,12 +687,11 @@ void update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu,
 		   void *cond_data);
 void update_max_tr_single(struct trace_array *tr,
 			  struct task_struct *tsk, int cpu);
-#endif /* CONFIG_TRACER_MAX_TRACE */
 
-#if (defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER) \
-	|| defined(CONFIG_OSNOISE_TRACER)) && defined(CONFIG_FSNOTIFY)
+#ifdef CONFIG_FSNOTIFY
 #define LATENCY_FS_NOTIFY
 #endif
+#endif /* CONFIG_TRACER_MAX_TRACE */
 
 #ifdef LATENCY_FS_NOTIFY
 void latency_fsnotify(struct trace_array *tr);
@@ -1941,17 +1939,30 @@ static __always_inline void trace_iterator_reset(struct trace_iterator *iter)
 }
 
 /* Check the name is good for event/group/fields */
-static inline bool is_good_name(const char *name)
+static inline bool __is_good_name(const char *name, bool hash_ok)
 {
-	if (!isalpha(*name) && *name != '_')
+	if (!isalpha(*name) && *name != '_' && (!hash_ok || *name != '-'))
 		return false;
 	while (*++name != '\0') {
-		if (!isalpha(*name) && !isdigit(*name) && *name != '_')
+		if (!isalpha(*name) && !isdigit(*name) && *name != '_' &&
+		    (!hash_ok || *name != '-'))
 			return false;
 	}
 	return true;
 }
 
+/* Check the name is good for event/group/fields */
+static inline bool is_good_name(const char *name)
+{
+	return __is_good_name(name, false);
+}
+
+/* Check the name is good for system */
+static inline bool is_good_system_name(const char *name)
+{
+	return __is_good_name(name, true);
+}
+
 /* Convert certain expected symbols into '_' when generating event names */
 static inline void sanitize_event_name(char *name)
 {
diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
index d19dab21848e..9806316af127 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -567,6 +567,9 @@ static void eprobe_trigger_func(struct event_trigger_data *data,
 {
 	struct eprobe_data *edata = data->private_data;
 
+	if (unlikely(!rec))
+		return;
+
 	if (unlikely(!rec))
 		return;
 
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 6397285883fa..cc1a078f7a16 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -452,7 +452,7 @@ struct action_data {
 	 * event param, and is passed to the synthetic event
 	 * invocation.
 	 */
-	unsigned int		var_ref_idx[TRACING_MAP_VARS_MAX];
+	unsigned int		var_ref_idx[SYNTH_FIELDS_MAX];
 	struct synth_event	*synth_event;
 	bool			use_trace_keyword;
 	char			*synth_event_name;
@@ -1895,7 +1895,9 @@ static struct hist_field *create_var_ref(struct hist_trigger_data *hist_data,
 			return ref_field;
 		}
 	}
-
+	/* Sanity check to avoid out-of-bound write on 'hist_data->var_refs' */
+	if (hist_data->n_var_refs >= TRACING_MAP_VARS_MAX)
+		return NULL;
 	ref_field = create_hist_field(var_field->hist_data, NULL, flags, NULL);
 	if (ref_field) {
 		if (init_var_ref(ref_field, var_field, system, event_name)) {
@@ -3188,6 +3190,7 @@ static int parse_action_params(struct trace_array *tr, char *params,
 	while (params) {
 		if (data->n_params >= SYNTH_FIELDS_MAX) {
 			hist_err(tr, HIST_ERR_TOO_MANY_PARAMS, 0);
+			ret = -EINVAL;
 			goto out;
 		}
 
@@ -3524,6 +3527,10 @@ static int trace_action_create(struct hist_trigger_data *hist_data,
 
 	lockdep_assert_held(&event_mutex);
 
+	/* Sanity check to avoid out-of-bound write on 'data->var_ref_idx' */
+	if (data->n_params > SYNTH_FIELDS_MAX)
+		return -EINVAL;
+
 	if (data->use_trace_keyword)
 		synth_event_name = data->synth_event_name;
 	else
diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index 47eb92b3edd0..2fdf3fd591e1 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -1275,12 +1275,12 @@ static int __create_synth_event(const char *name, const char *raw_fields)
 				goto err;
 			}
 
-			fields[n_fields++] = field;
 			if (n_fields == SYNTH_FIELDS_MAX) {
 				synth_err(SYNTH_ERR_TOO_MANY_FIELDS, 0);
 				ret = -EINVAL;
 				goto err;
 			}
+			fields[n_fields++] = field;
 
 			n_fields_this_loop++;
 		}
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 2bbe4a7c6a2b..cb8f9fe5669a 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -246,7 +246,7 @@ int traceprobe_parse_event_name(const char **pevent, const char **pgroup,
 			return -EINVAL;
 		}
 		strlcpy(buf, event, slash - event + 1);
-		if (!is_good_name(buf)) {
+		if (!is_good_system_name(buf)) {
 			trace_probe_log_err(offset, BAD_GROUP_NAME);
 			return -EINVAL;
 		}
diff --git a/mm/compaction.c b/mm/compaction.c
index e8fcf0e0c1ca..89517ad5d6a0 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1350,7 +1350,7 @@ move_freelist_tail(struct list_head *freelist, struct page *freepage)
 }
 
 static void
-fast_isolate_around(struct compact_control *cc, unsigned long pfn, unsigned long nr_isolated)
+fast_isolate_around(struct compact_control *cc, unsigned long pfn)
 {
 	unsigned long start_pfn, end_pfn;
 	struct page *page;
@@ -1371,21 +1371,13 @@ fast_isolate_around(struct compact_control *cc, unsigned long pfn, unsigned long
 	if (!page)
 		return;
 
-	/* Scan before */
-	if (start_pfn != pfn) {
-		isolate_freepages_block(cc, &start_pfn, pfn, &cc->freepages, 1, false);
-		if (cc->nr_freepages >= cc->nr_migratepages)
-			return;
-	}
-
-	/* Scan after */
-	start_pfn = pfn + nr_isolated;
-	if (start_pfn < end_pfn)
-		isolate_freepages_block(cc, &start_pfn, end_pfn, &cc->freepages, 1, false);
+	isolate_freepages_block(cc, &start_pfn, end_pfn, &cc->freepages, 1, false);
 
 	/* Skip this pageblock in the future as it's full or nearly full */
 	if (cc->nr_freepages < cc->nr_migratepages)
 		set_pageblock_skip(page);
+
+	return;
 }
 
 /* Search orders in round-robin fashion */
@@ -1561,7 +1553,7 @@ fast_isolate_freepages(struct compact_control *cc)
 		return cc->free_pfn;
 
 	low_pfn = page_to_pfn(page);
-	fast_isolate_around(cc, low_pfn, nr_isolated);
+	fast_isolate_around(cc, low_pfn);
 	return low_pfn;
 }
 
diff --git a/net/caif/cfctrl.c b/net/caif/cfctrl.c
index 2809cbd6b7f7..d8cb4b2a076b 100644
--- a/net/caif/cfctrl.c
+++ b/net/caif/cfctrl.c
@@ -269,11 +269,15 @@ int cfctrl_linkup_request(struct cflayer *layer,
 	default:
 		pr_warn("Request setup of bad link type = %d\n",
 			param->linktype);
+		cfpkt_destroy(pkt);
 		return -EINVAL;
 	}
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
-	if (!req)
+	if (!req) {
+		cfpkt_destroy(pkt);
 		return -ENOMEM;
+	}
+
 	req->client_layer = user_layer;
 	req->cmd = CFCTRL_CMD_LINK_SETUP;
 	req->param = *param;
diff --git a/net/core/filter.c b/net/core/filter.c
index 2da05622afbe..b2031148dd8b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3182,15 +3182,18 @@ static int bpf_skb_generic_push(struct sk_buff *skb, u32 off, u32 len)
 
 static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
 {
+	void *old_data;
+
 	/* skb_ensure_writable() is not needed here, as we're
 	 * already working on an uncloned skb.
 	 */
 	if (unlikely(!pskb_may_pull(skb, off + len)))
 		return -ENOMEM;
 
-	skb_postpull_rcsum(skb, skb->data + off, len);
-	memmove(skb->data + len, skb->data, off);
+	old_data = skb->data;
 	__skb_pull(skb, len);
+	skb_postpull_rcsum(skb, old_data + off, len);
+	memmove(skb->data, old_data, off);
 
 	return 0;
 }
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 940839264025..3aab914eb103 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -290,12 +290,11 @@ struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
 	struct tcp_request_sock *treq;
 	struct request_sock *req;
 
-#ifdef CONFIG_MPTCP
 	if (sk_is_mptcp(sk))
-		ops = &mptcp_subflow_request_sock_ops;
-#endif
+		req = mptcp_subflow_reqsk_alloc(ops, sk, false);
+	else
+		req = inet_reqsk_alloc(ops, sk, false);
 
-	req = inet_reqsk_alloc(ops, sk, false);
 	if (!req)
 		return NULL;
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 5ef9013b94c7..ba4241d7c5ef 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -45,7 +45,6 @@ static void subflow_req_destructor(struct request_sock *req)
 		sock_put((struct sock *)subflow_req->msk);
 
 	mptcp_token_destroy_request(req);
-	tcp_request_sock_ops.destructor(req);
 }
 
 static void subflow_generate_hmac(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
@@ -483,9 +482,8 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	mptcp_subflow_reset(sk);
 }
 
-struct request_sock_ops mptcp_subflow_request_sock_ops;
-EXPORT_SYMBOL_GPL(mptcp_subflow_request_sock_ops);
-static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops;
+static struct request_sock_ops mptcp_subflow_v4_request_sock_ops __ro_after_init;
+static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops __ro_after_init;
 
 static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 {
@@ -497,7 +495,7 @@ static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 	if (skb_rtable(skb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		goto drop;
 
-	return tcp_conn_request(&mptcp_subflow_request_sock_ops,
+	return tcp_conn_request(&mptcp_subflow_v4_request_sock_ops,
 				&subflow_request_sock_ipv4_ops,
 				sk, skb);
 drop:
@@ -505,10 +503,17 @@ static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
+static void subflow_v4_req_destructor(struct request_sock *req)
+{
+	subflow_req_destructor(req);
+	tcp_request_sock_ops.destructor(req);
+}
+
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-static struct tcp_request_sock_ops subflow_request_sock_ipv6_ops;
-static struct inet_connection_sock_af_ops subflow_v6_specific;
-static struct inet_connection_sock_af_ops subflow_v6m_specific;
+static struct request_sock_ops mptcp_subflow_v6_request_sock_ops __ro_after_init;
+static struct tcp_request_sock_ops subflow_request_sock_ipv6_ops __ro_after_init;
+static struct inet_connection_sock_af_ops subflow_v6_specific __ro_after_init;
+static struct inet_connection_sock_af_ops subflow_v6m_specific __ro_after_init;
 static struct proto tcpv6_prot_override;
 
 static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
@@ -528,15 +533,36 @@ static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 		return 0;
 	}
 
-	return tcp_conn_request(&mptcp_subflow_request_sock_ops,
+	return tcp_conn_request(&mptcp_subflow_v6_request_sock_ops,
 				&subflow_request_sock_ipv6_ops, sk, skb);
 
 drop:
 	tcp_listendrop(sk);
 	return 0; /* don't send reset */
 }
+
+static void subflow_v6_req_destructor(struct request_sock *req)
+{
+	subflow_req_destructor(req);
+	tcp6_request_sock_ops.destructor(req);
+}
+#endif
+
+struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *ops,
+					       struct sock *sk_listener,
+					       bool attach_listener)
+{
+	if (ops->family == AF_INET)
+		ops = &mptcp_subflow_v4_request_sock_ops;
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	else if (ops->family == AF_INET6)
+		ops = &mptcp_subflow_v6_request_sock_ops;
 #endif
 
+	return inet_reqsk_alloc(ops, sk_listener, attach_listener);
+}
+EXPORT_SYMBOL(mptcp_subflow_reqsk_alloc);
+
 /* validate hmac received in third ACK */
 static bool subflow_hmac_valid(const struct request_sock *req,
 			       const struct mptcp_options_received *mp_opt)
@@ -790,7 +816,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	return child;
 }
 
-static struct inet_connection_sock_af_ops subflow_specific;
+static struct inet_connection_sock_af_ops subflow_specific __ro_after_init;
 static struct proto tcp_prot_override;
 
 enum mapping_status {
@@ -1327,7 +1353,7 @@ static void subflow_write_space(struct sock *ssk)
 	mptcp_write_space(sk);
 }
 
-static struct inet_connection_sock_af_ops *
+static const struct inet_connection_sock_af_ops *
 subflow_default_af_ops(struct sock *sk)
 {
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -1342,7 +1368,7 @@ void mptcpv6_handle_mapped(struct sock *sk, bool mapped)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
-	struct inet_connection_sock_af_ops *target;
+	const struct inet_connection_sock_af_ops *target;
 
 	target = mapped ? &subflow_v6m_specific : subflow_default_af_ops(sk);
 
@@ -1782,7 +1808,6 @@ static struct tcp_ulp_ops subflow_ulp_ops __read_mostly = {
 static int subflow_ops_init(struct request_sock_ops *subflow_ops)
 {
 	subflow_ops->obj_size = sizeof(struct mptcp_subflow_request_sock);
-	subflow_ops->slab_name = "request_sock_subflow";
 
 	subflow_ops->slab = kmem_cache_create(subflow_ops->slab_name,
 					      subflow_ops->obj_size, 0,
@@ -1792,16 +1817,17 @@ static int subflow_ops_init(struct request_sock_ops *subflow_ops)
 	if (!subflow_ops->slab)
 		return -ENOMEM;
 
-	subflow_ops->destructor = subflow_req_destructor;
-
 	return 0;
 }
 
 void __init mptcp_subflow_init(void)
 {
-	mptcp_subflow_request_sock_ops = tcp_request_sock_ops;
-	if (subflow_ops_init(&mptcp_subflow_request_sock_ops) != 0)
-		panic("MPTCP: failed to init subflow request sock ops\n");
+	mptcp_subflow_v4_request_sock_ops = tcp_request_sock_ops;
+	mptcp_subflow_v4_request_sock_ops.slab_name = "request_sock_subflow_v4";
+	mptcp_subflow_v4_request_sock_ops.destructor = subflow_v4_req_destructor;
+
+	if (subflow_ops_init(&mptcp_subflow_v4_request_sock_ops) != 0)
+		panic("MPTCP: failed to init subflow v4 request sock ops\n");
 
 	subflow_request_sock_ipv4_ops = tcp_request_sock_ipv4_ops;
 	subflow_request_sock_ipv4_ops.route_req = subflow_v4_route_req;
@@ -1815,6 +1841,20 @@ void __init mptcp_subflow_init(void)
 	tcp_prot_override.release_cb = tcp_release_cb_override;
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	/* In struct mptcp_subflow_request_sock, we assume the TCP request sock
+	 * structures for v4 and v6 have the same size. It should not changed in
+	 * the future but better to make sure to be warned if it is no longer
+	 * the case.
+	 */
+	BUILD_BUG_ON(sizeof(struct tcp_request_sock) != sizeof(struct tcp6_request_sock));
+
+	mptcp_subflow_v6_request_sock_ops = tcp6_request_sock_ops;
+	mptcp_subflow_v6_request_sock_ops.slab_name = "request_sock_subflow_v6";
+	mptcp_subflow_v6_request_sock_ops.destructor = subflow_v6_req_destructor;
+
+	if (subflow_ops_init(&mptcp_subflow_v6_request_sock_ops) != 0)
+		panic("MPTCP: failed to init subflow v6 request sock ops\n");
+
 	subflow_request_sock_ipv6_ops = tcp_request_sock_ipv6_ops;
 	subflow_request_sock_ipv6_ops.route_req = subflow_v6_route_req;
 
diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 16ae92054baa..ae061b27e446 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1698,9 +1698,10 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 		ret = set->variant->uadt(set, tb, adt, &lineno, flags, retried);
 		ip_set_unlock(set);
 		retried = true;
-	} while (ret == -EAGAIN &&
-		 set->variant->resize &&
-		 (ret = set->variant->resize(set, retried)) == 0);
+	} while (ret == -ERANGE ||
+		 (ret == -EAGAIN &&
+		  set->variant->resize &&
+		  (ret = set->variant->resize(set, retried)) == 0));
 
 	if (!ret || (ret == -IPSET_ERR_EXIST && eexist))
 		return 0;
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 75d556d71652..24adcdd7a0b1 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -98,11 +98,11 @@ static int
 hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	      enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ip4 *h = set->data;
+	struct hash_ip4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ip4_elem e = { 0 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0, hosts;
+	u32 ip = 0, ip_to = 0, hosts, i = 0;
 	int ret = 0;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -147,14 +147,14 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	hosts = h->netmask == 32 ? 1 : 2 << (32 - h->netmask - 1);
 
-	/* 64bit division is not allowed on 32bit */
-	if (((u64)ip_to - ip + 1) >> (32 - h->netmask) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to;) {
+	for (; ip <= ip_to; i++) {
 		e.ip = htonl(ip);
+		if (i > IPSET_MAX_RANGE) {
+			hash_ip4_data_next(&h->next, &e);
+			return -ERANGE;
+		}
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 153de3457423..a22ec1a6f6ec 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -97,11 +97,11 @@ static int
 hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ipmark4 *h = set->data;
+	struct hash_ipmark4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipmark4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip, ip_to = 0;
+	u32 ip, ip_to = 0, i = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -148,13 +148,14 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
 
-	if (((u64)ip_to - ip + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to; ip++) {
+	for (; ip <= ip_to; ip++, i++) {
 		e.ip = htonl(ip);
+		if (i > IPSET_MAX_RANGE) {
+			hash_ipmark4_data_next(&h->next, &e);
+			return -ERANGE;
+		}
 		ret = adtfn(set, &e, &ext, &ext, flags);
 
 		if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 7303138e46be..10481760a9b2 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -105,11 +105,11 @@ static int
 hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ipport4 *h = set->data;
+	struct hash_ipport4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport4_elem e = { .ip = 0 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip, ip_to = 0, p = 0, port, port_to;
+	u32 ip, ip_to = 0, p = 0, port, port_to, i = 0;
 	bool with_ports = false;
 	int ret;
 
@@ -173,17 +173,18 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
-	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
 		p = retried && ip == ntohl(h->next.ip) ? ntohs(h->next.port)
 						       : port;
-		for (; p <= port_to; p++) {
+		for (; p <= port_to; p++, i++) {
 			e.ip = htonl(ip);
 			e.port = htons(p);
+			if (i > IPSET_MAX_RANGE) {
+				hash_ipport4_data_next(&h->next, &e);
+				return -ERANGE;
+			}
 			ret = adtfn(set, &e, &ext, &ext, flags);
 
 			if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index 334fb1ad0e86..39a01934b153 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -108,11 +108,11 @@ static int
 hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 		    enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ipportip4 *h = set->data;
+	struct hash_ipportip4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportip4_elem e = { .ip = 0 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip, ip_to = 0, p = 0, port, port_to;
+	u32 ip, ip_to = 0, p = 0, port, port_to, i = 0;
 	bool with_ports = false;
 	int ret;
 
@@ -180,17 +180,18 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
-	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
 		p = retried && ip == ntohl(h->next.ip) ? ntohs(h->next.port)
 						       : port;
-		for (; p <= port_to; p++) {
+		for (; p <= port_to; p++, i++) {
 			e.ip = htonl(ip);
 			e.port = htons(p);
+			if (i > IPSET_MAX_RANGE) {
+				hash_ipportip4_data_next(&h->next, &e);
+				return -ERANGE;
+			}
 			ret = adtfn(set, &e, &ext, &ext, flags);
 
 			if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 7df94f437f60..5c6de605a9fb 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -160,12 +160,12 @@ static int
 hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		     enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_ipportnet4 *h = set->data;
+	struct hash_ipportnet4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportnet4_elem e = { .cidr = HOST_MASK - 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, p = 0, port, port_to;
-	u32 ip2_from = 0, ip2_to = 0, ip2;
+	u32 ip2_from = 0, ip2_to = 0, ip2, i = 0;
 	bool with_ports = false;
 	u8 cidr;
 	int ret;
@@ -253,9 +253,6 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
-	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
-
 	ip2_to = ip2_from;
 	if (tb[IPSET_ATTR_IP2_TO]) {
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2_TO], &ip2_to);
@@ -282,9 +279,15 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		for (; p <= port_to; p++) {
 			e.port = htons(p);
 			do {
+				i++;
 				e.ip2 = htonl(ip2);
 				ip2 = ip_set_range_to_cidr(ip2, ip2_to, &cidr);
 				e.cidr = cidr - 1;
+				if (i > IPSET_MAX_RANGE) {
+					hash_ipportnet4_data_next(&h->next,
+								  &e);
+					return -ERANGE;
+				}
 				ret = adtfn(set, &e, &ext, &ext, flags);
 
 				if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index 1422739d9aa2..ce0a9ce5a91f 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -136,11 +136,11 @@ static int
 hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 	       enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_net4 *h = set->data;
+	struct hash_net4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net4_elem e = { .cidr = HOST_MASK };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0, ipn, n = 0;
+	u32 ip = 0, ip_to = 0, i = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -188,19 +188,16 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (ip + UINT_MAX == ip_to)
 			return -IPSET_ERR_HASH_RANGE;
 	}
-	ipn = ip;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
-		n++;
-	} while (ipn++ < ip_to);
-
-	if (n > IPSET_MAX_RANGE)
-		return -ERANGE;
 
 	if (retried)
 		ip = ntohl(h->next.ip);
 	do {
+		i++;
 		e.ip = htonl(ip);
+		if (i > IPSET_MAX_RANGE) {
+			hash_net4_data_next(&h->next, &e);
+			return -ERANGE;
+		}
 		ip = ip_set_range_to_cidr(ip, ip_to, &e.cidr);
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index 9810f5bf63f5..031073286236 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -202,7 +202,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netiface4_elem e = { .cidr = HOST_MASK, .elem = 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0, ipn, n = 0;
+	u32 ip = 0, ip_to = 0, i = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -256,19 +256,16 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr);
 	}
-	ipn = ip;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
-		n++;
-	} while (ipn++ < ip_to);
-
-	if (n > IPSET_MAX_RANGE)
-		return -ERANGE;
 
 	if (retried)
 		ip = ntohl(h->next.ip);
 	do {
+		i++;
 		e.ip = htonl(ip);
+		if (i > IPSET_MAX_RANGE) {
+			hash_netiface4_data_next(&h->next, &e);
+			return -ERANGE;
+		}
 		ip = ip_set_range_to_cidr(ip, ip_to, &e.cidr);
 		ret = adtfn(set, &e, &ext, &ext, flags);
 
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index 3d09eefe998a..c07b70bf32db 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -163,13 +163,12 @@ static int
 hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_netnet4 *h = set->data;
+	struct hash_netnet4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0;
-	u32 ip2 = 0, ip2_from = 0, ip2_to = 0, ipn;
-	u64 n = 0, m = 0;
+	u32 ip2 = 0, ip2_from = 0, ip2_to = 0, i = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -245,19 +244,6 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
-	ipn = ip;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
-		n++;
-	} while (ipn++ < ip_to);
-	ipn = ip2_from;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
-		m++;
-	} while (ipn++ < ip2_to);
-
-	if (n*m > IPSET_MAX_RANGE)
-		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip[0]);
@@ -270,7 +256,12 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		e.ip[0] = htonl(ip);
 		ip = ip_set_range_to_cidr(ip, ip_to, &e.cidr[0]);
 		do {
+			i++;
 			e.ip[1] = htonl(ip2);
+			if (i > IPSET_MAX_RANGE) {
+				hash_netnet4_data_next(&h->next, &e);
+				return -ERANGE;
+			}
 			ip2 = ip_set_range_to_cidr(ip2, ip2_to, &e.cidr[1]);
 			ret = adtfn(set, &e, &ext, &ext, flags);
 			if (ret && !ip_set_eexist(ret, flags))
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 09cf72eb37f8..d1a0628df4ef 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -154,12 +154,11 @@ static int
 hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		   enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_netport4 *h = set->data;
+	struct hash_netport4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport4_elem e = { .cidr = HOST_MASK - 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 port, port_to, p = 0, ip = 0, ip_to = 0, ipn;
-	u64 n = 0;
+	u32 port, port_to, p = 0, ip = 0, ip_to = 0, i = 0;
 	bool with_ports = false;
 	u8 cidr;
 	int ret;
@@ -236,14 +235,6 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr + 1);
 	}
-	ipn = ip;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip_to, &cidr);
-		n++;
-	} while (ipn++ < ip_to);
-
-	if (n*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip);
@@ -255,8 +246,12 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		e.ip = htonl(ip);
 		ip = ip_set_range_to_cidr(ip, ip_to, &cidr);
 		e.cidr = cidr - 1;
-		for (; p <= port_to; p++) {
+		for (; p <= port_to; p++, i++) {
 			e.port = htons(p);
+			if (i > IPSET_MAX_RANGE) {
+				hash_netport4_data_next(&h->next, &e);
+				return -ERANGE;
+			}
 			ret = adtfn(set, &e, &ext, &ext, flags);
 			if (ret && !ip_set_eexist(ret, flags))
 				return ret;
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 19bcdb3141f6..005a7ce87217 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -173,17 +173,26 @@ hash_netportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
 
+static u32
+hash_netportnet4_range_to_cidr(u32 from, u32 to, u8 *cidr)
+{
+	if (from == 0 && to == UINT_MAX) {
+		*cidr = 0;
+		return to;
+	}
+	return ip_set_range_to_cidr(from, to, cidr);
+}
+
 static int
 hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		      enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_netportnet4 *h = set->data;
+	struct hash_netportnet4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netportnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, p = 0, port, port_to;
-	u32 ip2_from = 0, ip2_to = 0, ip2, ipn;
-	u64 n = 0, m = 0;
+	u32 ip2_from = 0, ip2_to = 0, ip2, i = 0;
 	bool with_ports = false;
 	int ret;
 
@@ -285,19 +294,6 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
-	ipn = ip;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
-		n++;
-	} while (ipn++ < ip_to);
-	ipn = ip2_from;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
-		m++;
-	} while (ipn++ < ip2_to);
-
-	if (n*m*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip[0]);
@@ -310,13 +306,19 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	do {
 		e.ip[0] = htonl(ip);
-		ip = ip_set_range_to_cidr(ip, ip_to, &e.cidr[0]);
+		ip = hash_netportnet4_range_to_cidr(ip, ip_to, &e.cidr[0]);
 		for (; p <= port_to; p++) {
 			e.port = htons(p);
 			do {
+				i++;
 				e.ip[1] = htonl(ip2);
-				ip2 = ip_set_range_to_cidr(ip2, ip2_to,
-							   &e.cidr[1]);
+				if (i > IPSET_MAX_RANGE) {
+					hash_netportnet4_data_next(&h->next,
+								   &e);
+					return -ERANGE;
+				}
+				ip2 = hash_netportnet4_range_to_cidr(ip2,
+							ip2_to, &e.cidr[1]);
 				ret = adtfn(set, &e, &ext, &ext, flags);
 				if (ret && !ip_set_eexist(ret, flags))
 					return ret;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3fac57d66dda..81bd13b3d8fd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -465,8 +465,9 @@ static int nft_delrule_by_chain(struct nft_ctx *ctx)
 	return 0;
 }
 
-static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
-			     struct nft_set *set)
+static int __nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
+			       struct nft_set *set,
+			       const struct nft_set_desc *desc)
 {
 	struct nft_trans *trans;
 
@@ -474,17 +475,28 @@ static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
 	if (trans == NULL)
 		return -ENOMEM;
 
-	if (msg_type == NFT_MSG_NEWSET && ctx->nla[NFTA_SET_ID] != NULL) {
+	if (msg_type == NFT_MSG_NEWSET && ctx->nla[NFTA_SET_ID] && !desc) {
 		nft_trans_set_id(trans) =
 			ntohl(nla_get_be32(ctx->nla[NFTA_SET_ID]));
 		nft_activate_next(ctx->net, set);
 	}
 	nft_trans_set(trans) = set;
+	if (desc) {
+		nft_trans_set_update(trans) = true;
+		nft_trans_set_gc_int(trans) = desc->gc_int;
+		nft_trans_set_timeout(trans) = desc->timeout;
+	}
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
 	return 0;
 }
 
+static int nft_trans_set_add(const struct nft_ctx *ctx, int msg_type,
+			     struct nft_set *set)
+{
+	return __nft_trans_set_add(ctx, msg_type, set, NULL);
+}
+
 static int nft_delset(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	int err;
@@ -3635,8 +3647,7 @@ static bool nft_set_ops_candidate(const struct nft_set_type *type, u32 flags)
 static const struct nft_set_ops *
 nft_select_set_ops(const struct nft_ctx *ctx,
 		   const struct nlattr * const nla[],
-		   const struct nft_set_desc *desc,
-		   enum nft_set_policies policy)
+		   const struct nft_set_desc *desc)
 {
 	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
 	const struct nft_set_ops *ops, *bops;
@@ -3665,7 +3676,7 @@ nft_select_set_ops(const struct nft_ctx *ctx,
 		if (!ops->estimate(desc, flags, &est))
 			continue;
 
-		switch (policy) {
+		switch (desc->policy) {
 		case NFT_SET_POL_PERFORMANCE:
 			if (est.lookup < best.lookup)
 				break;
@@ -3900,8 +3911,10 @@ static int nf_tables_fill_set_concat(struct sk_buff *skb,
 static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			      const struct nft_set *set, u16 event, u16 flags)
 {
-	struct nlmsghdr *nlh;
+	u64 timeout = READ_ONCE(set->timeout);
+	u32 gc_int = READ_ONCE(set->gc_int);
 	u32 portid = ctx->portid;
+	struct nlmsghdr *nlh;
 	struct nlattr *nest;
 	u32 seq = ctx->seq;
 	int i;
@@ -3937,13 +3950,13 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	    nla_put_be32(skb, NFTA_SET_OBJ_TYPE, htonl(set->objtype)))
 		goto nla_put_failure;
 
-	if (set->timeout &&
+	if (timeout &&
 	    nla_put_be64(skb, NFTA_SET_TIMEOUT,
-			 nf_jiffies64_to_msecs(set->timeout),
+			 nf_jiffies64_to_msecs(timeout),
 			 NFTA_SET_PAD))
 		goto nla_put_failure;
-	if (set->gc_int &&
-	    nla_put_be32(skb, NFTA_SET_GC_INTERVAL, htonl(set->gc_int)))
+	if (gc_int &&
+	    nla_put_be32(skb, NFTA_SET_GC_INTERVAL, htonl(gc_int)))
 		goto nla_put_failure;
 
 	if (set->policy != NFT_SET_POL_PERFORMANCE) {
@@ -4244,15 +4257,94 @@ static int nf_tables_set_desc_parse(struct nft_set_desc *desc,
 	return err;
 }
 
+static int nft_set_expr_alloc(struct nft_ctx *ctx, struct nft_set *set,
+			      const struct nlattr * const *nla,
+			      struct nft_expr **exprs, int *num_exprs,
+			      u32 flags)
+{
+	struct nft_expr *expr;
+	int err, i;
+
+	if (nla[NFTA_SET_EXPR]) {
+		expr = nft_set_elem_expr_alloc(ctx, set, nla[NFTA_SET_EXPR]);
+		if (IS_ERR(expr)) {
+			err = PTR_ERR(expr);
+			goto err_set_expr_alloc;
+		}
+		exprs[0] = expr;
+		(*num_exprs)++;
+	} else if (nla[NFTA_SET_EXPRESSIONS]) {
+		struct nlattr *tmp;
+		int left;
+
+		if (!(flags & NFT_SET_EXPR)) {
+			err = -EINVAL;
+			goto err_set_expr_alloc;
+		}
+		i = 0;
+		nla_for_each_nested(tmp, nla[NFTA_SET_EXPRESSIONS], left) {
+			if (i == NFT_SET_EXPR_MAX) {
+				err = -E2BIG;
+				goto err_set_expr_alloc;
+			}
+			if (nla_type(tmp) != NFTA_LIST_ELEM) {
+				err = -EINVAL;
+				goto err_set_expr_alloc;
+			}
+			expr = nft_set_elem_expr_alloc(ctx, set, tmp);
+			if (IS_ERR(expr)) {
+				err = PTR_ERR(expr);
+				goto err_set_expr_alloc;
+			}
+			exprs[i++] = expr;
+			(*num_exprs)++;
+		}
+	}
+
+	return 0;
+
+err_set_expr_alloc:
+	for (i = 0; i < *num_exprs; i++)
+		nft_expr_destroy(ctx, exprs[i]);
+
+	return err;
+}
+
+static bool nft_set_is_same(const struct nft_set *set,
+			    const struct nft_set_desc *desc,
+			    struct nft_expr *exprs[], u32 num_exprs, u32 flags)
+{
+	int i;
+
+	if (set->ktype != desc->ktype ||
+	    set->dtype != desc->dtype ||
+	    set->flags != flags ||
+	    set->klen != desc->klen ||
+	    set->dlen != desc->dlen ||
+	    set->field_count != desc->field_count ||
+	    set->num_exprs != num_exprs)
+		return false;
+
+	for (i = 0; i < desc->field_count; i++) {
+		if (set->field_len[i] != desc->field_len[i])
+			return false;
+	}
+
+	for (i = 0; i < num_exprs; i++) {
+		if (set->exprs[i]->ops != exprs[i]->ops)
+			return false;
+	}
+
+	return true;
+}
+
 static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
-	u32 ktype, dtype, flags, policy, gc_int, objtype;
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
 	u8 family = info->nfmsg->nfgen_family;
 	const struct nft_set_ops *ops;
-	struct nft_expr *expr = NULL;
 	struct net *net = info->net;
 	struct nft_set_desc desc;
 	struct nft_table *table;
@@ -4260,10 +4352,11 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	struct nft_set *set;
 	struct nft_ctx ctx;
 	size_t alloc_size;
-	u64 timeout;
+	int num_exprs = 0;
 	char *name;
 	int err, i;
 	u16 udlen;
+	u32 flags;
 	u64 size;
 
 	if (nla[NFTA_SET_TABLE] == NULL ||
@@ -4274,10 +4367,10 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 
 	memset(&desc, 0, sizeof(desc));
 
-	ktype = NFT_DATA_VALUE;
+	desc.ktype = NFT_DATA_VALUE;
 	if (nla[NFTA_SET_KEY_TYPE] != NULL) {
-		ktype = ntohl(nla_get_be32(nla[NFTA_SET_KEY_TYPE]));
-		if ((ktype & NFT_DATA_RESERVED_MASK) == NFT_DATA_RESERVED_MASK)
+		desc.ktype = ntohl(nla_get_be32(nla[NFTA_SET_KEY_TYPE]));
+		if ((desc.ktype & NFT_DATA_RESERVED_MASK) == NFT_DATA_RESERVED_MASK)
 			return -EINVAL;
 	}
 
@@ -4302,17 +4395,17 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 			return -EOPNOTSUPP;
 	}
 
-	dtype = 0;
+	desc.dtype = 0;
 	if (nla[NFTA_SET_DATA_TYPE] != NULL) {
 		if (!(flags & NFT_SET_MAP))
 			return -EINVAL;
 
-		dtype = ntohl(nla_get_be32(nla[NFTA_SET_DATA_TYPE]));
-		if ((dtype & NFT_DATA_RESERVED_MASK) == NFT_DATA_RESERVED_MASK &&
-		    dtype != NFT_DATA_VERDICT)
+		desc.dtype = ntohl(nla_get_be32(nla[NFTA_SET_DATA_TYPE]));
+		if ((desc.dtype & NFT_DATA_RESERVED_MASK) == NFT_DATA_RESERVED_MASK &&
+		    desc.dtype != NFT_DATA_VERDICT)
 			return -EINVAL;
 
-		if (dtype != NFT_DATA_VERDICT) {
+		if (desc.dtype != NFT_DATA_VERDICT) {
 			if (nla[NFTA_SET_DATA_LEN] == NULL)
 				return -EINVAL;
 			desc.dlen = ntohl(nla_get_be32(nla[NFTA_SET_DATA_LEN]));
@@ -4327,34 +4420,34 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (!(flags & NFT_SET_OBJECT))
 			return -EINVAL;
 
-		objtype = ntohl(nla_get_be32(nla[NFTA_SET_OBJ_TYPE]));
-		if (objtype == NFT_OBJECT_UNSPEC ||
-		    objtype > NFT_OBJECT_MAX)
+		desc.objtype = ntohl(nla_get_be32(nla[NFTA_SET_OBJ_TYPE]));
+		if (desc.objtype == NFT_OBJECT_UNSPEC ||
+		    desc.objtype > NFT_OBJECT_MAX)
 			return -EOPNOTSUPP;
 	} else if (flags & NFT_SET_OBJECT)
 		return -EINVAL;
 	else
-		objtype = NFT_OBJECT_UNSPEC;
+		desc.objtype = NFT_OBJECT_UNSPEC;
 
-	timeout = 0;
+	desc.timeout = 0;
 	if (nla[NFTA_SET_TIMEOUT] != NULL) {
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
 
-		err = nf_msecs_to_jiffies64(nla[NFTA_SET_TIMEOUT], &timeout);
+		err = nf_msecs_to_jiffies64(nla[NFTA_SET_TIMEOUT], &desc.timeout);
 		if (err)
 			return err;
 	}
-	gc_int = 0;
+	desc.gc_int = 0;
 	if (nla[NFTA_SET_GC_INTERVAL] != NULL) {
 		if (!(flags & NFT_SET_TIMEOUT))
 			return -EINVAL;
-		gc_int = ntohl(nla_get_be32(nla[NFTA_SET_GC_INTERVAL]));
+		desc.gc_int = ntohl(nla_get_be32(nla[NFTA_SET_GC_INTERVAL]));
 	}
 
-	policy = NFT_SET_POL_PERFORMANCE;
+	desc.policy = NFT_SET_POL_PERFORMANCE;
 	if (nla[NFTA_SET_POLICY] != NULL)
-		policy = ntohl(nla_get_be32(nla[NFTA_SET_POLICY]));
+		desc.policy = ntohl(nla_get_be32(nla[NFTA_SET_POLICY]));
 
 	if (nla[NFTA_SET_DESC] != NULL) {
 		err = nf_tables_set_desc_parse(&desc, nla[NFTA_SET_DESC]);
@@ -4386,6 +4479,8 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 			return PTR_ERR(set);
 		}
 	} else {
+		struct nft_expr *exprs[NFT_SET_EXPR_MAX] = {};
+
 		if (info->nlh->nlmsg_flags & NLM_F_EXCL) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_NAME]);
 			return -EEXIST;
@@ -4393,13 +4488,29 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (info->nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
-		return 0;
+		err = nft_set_expr_alloc(&ctx, set, nla, exprs, &num_exprs, flags);
+		if (err < 0)
+			return err;
+
+		err = 0;
+		if (!nft_set_is_same(set, &desc, exprs, num_exprs, flags)) {
+			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_NAME]);
+			err = -EEXIST;
+		}
+
+		for (i = 0; i < num_exprs; i++)
+			nft_expr_destroy(&ctx, exprs[i]);
+
+		if (err < 0)
+			return err;
+
+		return __nft_trans_set_add(&ctx, NFT_MSG_NEWSET, set, &desc);
 	}
 
 	if (!(info->nlh->nlmsg_flags & NLM_F_CREATE))
 		return -ENOENT;
 
-	ops = nft_select_set_ops(&ctx, nla, &desc, policy);
+	ops = nft_select_set_ops(&ctx, nla, &desc);
 	if (IS_ERR(ops))
 		return PTR_ERR(ops);
 
@@ -4439,18 +4550,18 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	set->table = table;
 	write_pnet(&set->net, net);
 	set->ops = ops;
-	set->ktype = ktype;
+	set->ktype = desc.ktype;
 	set->klen = desc.klen;
-	set->dtype = dtype;
-	set->objtype = objtype;
+	set->dtype = desc.dtype;
+	set->objtype = desc.objtype;
 	set->dlen = desc.dlen;
 	set->flags = flags;
 	set->size = desc.size;
-	set->policy = policy;
+	set->policy = desc.policy;
 	set->udlen = udlen;
 	set->udata = udata;
-	set->timeout = timeout;
-	set->gc_int = gc_int;
+	set->timeout = desc.timeout;
+	set->gc_int = desc.gc_int;
 
 	set->field_count = desc.field_count;
 	for (i = 0; i < desc.field_count; i++)
@@ -4460,43 +4571,11 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err < 0)
 		goto err_set_init;
 
-	if (nla[NFTA_SET_EXPR]) {
-		expr = nft_set_elem_expr_alloc(&ctx, set, nla[NFTA_SET_EXPR]);
-		if (IS_ERR(expr)) {
-			err = PTR_ERR(expr);
-			goto err_set_expr_alloc;
-		}
-		set->exprs[0] = expr;
-		set->num_exprs++;
-	} else if (nla[NFTA_SET_EXPRESSIONS]) {
-		struct nft_expr *expr;
-		struct nlattr *tmp;
-		int left;
-
-		if (!(flags & NFT_SET_EXPR)) {
-			err = -EINVAL;
-			goto err_set_expr_alloc;
-		}
-		i = 0;
-		nla_for_each_nested(tmp, nla[NFTA_SET_EXPRESSIONS], left) {
-			if (i == NFT_SET_EXPR_MAX) {
-				err = -E2BIG;
-				goto err_set_expr_alloc;
-			}
-			if (nla_type(tmp) != NFTA_LIST_ELEM) {
-				err = -EINVAL;
-				goto err_set_expr_alloc;
-			}
-			expr = nft_set_elem_expr_alloc(&ctx, set, tmp);
-			if (IS_ERR(expr)) {
-				err = PTR_ERR(expr);
-				goto err_set_expr_alloc;
-			}
-			set->exprs[i++] = expr;
-			set->num_exprs++;
-		}
-	}
+	err = nft_set_expr_alloc(&ctx, set, nla, set->exprs, &num_exprs, flags);
+	if (err < 0)
+		goto err_set_destroy;
 
+	set->num_exprs = num_exprs;
 	set->handle = nf_tables_alloc_handle(table);
 
 	err = nft_trans_set_add(&ctx, NFT_MSG_NEWSET, set);
@@ -4510,7 +4589,7 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 err_set_expr_alloc:
 	for (i = 0; i < set->num_exprs; i++)
 		nft_expr_destroy(&ctx, set->exprs[i]);
-
+err_set_destroy:
 	ops->destroy(set);
 err_set_init:
 	kfree(set->name);
@@ -5815,7 +5894,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return err;
 	} else if (set->flags & NFT_SET_TIMEOUT &&
 		   !(flags & NFT_SET_ELEM_INTERVAL_END)) {
-		timeout = set->timeout;
+		timeout = READ_ONCE(set->timeout);
 	}
 
 	expiration = 0;
@@ -5916,7 +5995,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_parse_key_end;
 
-		if (timeout != set->timeout) {
+		if (timeout != READ_ONCE(set->timeout)) {
 			err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 			if (err < 0)
 				goto err_parse_key_end;
@@ -8771,14 +8850,20 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_NEWSET:
-			nft_clear(net, nft_trans_set(trans));
-			/* This avoids hitting -EBUSY when deleting the table
-			 * from the transaction.
-			 */
-			if (nft_set_is_anonymous(nft_trans_set(trans)) &&
-			    !list_empty(&nft_trans_set(trans)->bindings))
-				trans->ctx.table->use--;
+			if (nft_trans_set_update(trans)) {
+				struct nft_set *set = nft_trans_set(trans);
 
+				WRITE_ONCE(set->timeout, nft_trans_set_timeout(trans));
+				WRITE_ONCE(set->gc_int, nft_trans_set_gc_int(trans));
+			} else {
+				nft_clear(net, nft_trans_set(trans));
+				/* This avoids hitting -EBUSY when deleting the table
+				 * from the transaction.
+				 */
+				if (nft_set_is_anonymous(nft_trans_set(trans)) &&
+				    !list_empty(&nft_trans_set(trans)->bindings))
+					trans->ctx.table->use--;
+			}
 			nf_tables_set_notify(&trans->ctx, nft_trans_set(trans),
 					     NFT_MSG_NEWSET, GFP_KERNEL);
 			nft_trans_destroy(trans);
@@ -9000,6 +9085,10 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWSET:
+			if (nft_trans_set_update(trans)) {
+				nft_trans_destroy(trans);
+				break;
+			}
 			trans->ctx.table->use--;
 			if (nft_trans_set_bound(trans)) {
 				nft_trans_destroy(trans);
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index a207f0b8137b..d928d5a24bbc 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1497,6 +1497,7 @@ static int nfc_genl_se_io(struct sk_buff *skb, struct genl_info *info)
 	u32 dev_idx, se_idx;
 	u8 *apdu;
 	size_t apdu_len;
+	int rc;
 
 	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
 	    !info->attrs[NFC_ATTR_SE_INDEX] ||
@@ -1510,25 +1511,37 @@ static int nfc_genl_se_io(struct sk_buff *skb, struct genl_info *info)
 	if (!dev)
 		return -ENODEV;
 
-	if (!dev->ops || !dev->ops->se_io)
-		return -ENOTSUPP;
+	if (!dev->ops || !dev->ops->se_io) {
+		rc = -EOPNOTSUPP;
+		goto put_dev;
+	}
 
 	apdu_len = nla_len(info->attrs[NFC_ATTR_SE_APDU]);
-	if (apdu_len == 0)
-		return -EINVAL;
+	if (apdu_len == 0) {
+		rc = -EINVAL;
+		goto put_dev;
+	}
 
 	apdu = nla_data(info->attrs[NFC_ATTR_SE_APDU]);
-	if (!apdu)
-		return -EINVAL;
+	if (!apdu) {
+		rc = -EINVAL;
+		goto put_dev;
+	}
 
 	ctx = kzalloc(sizeof(struct se_io_ctx), GFP_KERNEL);
-	if (!ctx)
-		return -ENOMEM;
+	if (!ctx) {
+		rc = -ENOMEM;
+		goto put_dev;
+	}
 
 	ctx->dev_idx = dev_idx;
 	ctx->se_idx = se_idx;
 
-	return nfc_se_io(dev, se_idx, apdu, apdu_len, se_io_cb, ctx);
+	rc = nfc_se_io(dev, se_idx, apdu, apdu_len, se_io_cb, ctx);
+
+put_dev:
+	nfc_put_device(dev);
+	return rc;
 }
 
 static int nfc_genl_vendor_cmd(struct sk_buff *skb,
@@ -1551,14 +1564,21 @@ static int nfc_genl_vendor_cmd(struct sk_buff *skb,
 	subcmd = nla_get_u32(info->attrs[NFC_ATTR_VENDOR_SUBCMD]);
 
 	dev = nfc_get_device(dev_idx);
-	if (!dev || !dev->vendor_cmds || !dev->n_vendor_cmds)
+	if (!dev)
 		return -ENODEV;
 
+	if (!dev->vendor_cmds || !dev->n_vendor_cmds) {
+		err = -ENODEV;
+		goto put_dev;
+	}
+
 	if (info->attrs[NFC_ATTR_VENDOR_DATA]) {
 		data = nla_data(info->attrs[NFC_ATTR_VENDOR_DATA]);
 		data_len = nla_len(info->attrs[NFC_ATTR_VENDOR_DATA]);
-		if (data_len == 0)
-			return -EINVAL;
+		if (data_len == 0) {
+			err = -EINVAL;
+			goto put_dev;
+		}
 	} else {
 		data = NULL;
 		data_len = 0;
@@ -1573,10 +1593,14 @@ static int nfc_genl_vendor_cmd(struct sk_buff *skb,
 		dev->cur_cmd_info = info;
 		err = cmd->doit(dev, data, data_len);
 		dev->cur_cmd_info = NULL;
-		return err;
+		goto put_dev;
 	}
 
-	return -EOPNOTSUPP;
+	err = -EOPNOTSUPP;
+
+put_dev:
+	nfc_put_device(dev);
+	return err;
 }
 
 /* message building helper */
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ceca0d6c41b5..7f9f2d0ef0e6 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1888,12 +1888,22 @@ static int packet_rcv_spkt(struct sk_buff *skb, struct net_device *dev,
 
 static void packet_parse_headers(struct sk_buff *skb, struct socket *sock)
 {
+	int depth;
+
 	if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
 	    sock->type == SOCK_RAW) {
 		skb_reset_mac_header(skb);
 		skb->protocol = dev_parse_header_protocol(skb);
 	}
 
+	/* Move network header to the right position for VLAN tagged packets */
+	if (likely(skb->dev->type == ARPHRD_ETHER) &&
+	    eth_type_vlan(skb->protocol) &&
+	    __vlan_get_protocol(skb, skb->protocol, &depth) != 0) {
+		if (pskb_may_pull(skb, depth))
+			skb_set_network_header(skb, depth);
+	}
+
 	skb_probe_transport_header(skb);
 }
 
@@ -3008,6 +3018,11 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	skb->mark = sockc.mark;
 	skb->tstamp = sockc.transmit_time;
 
+	if (unlikely(extra_len == 4))
+		skb->no_fcs = 1;
+
+	packet_parse_headers(skb, sock);
+
 	if (has_vnet_hdr) {
 		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
 		if (err)
@@ -3016,11 +3031,6 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		virtio_net_hdr_set_proto(skb, &vnet_hdr);
 	}
 
-	packet_parse_headers(skb, sock);
-
-	if (unlikely(extra_len == 4))
-		skb->no_fcs = 1;
-
 	err = po->xmit(skb);
 	if (unlikely(err != 0)) {
 		if (err > 0)
diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 742c7d49a958..8d1ef858db87 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -332,7 +332,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 		  struct tcindex_filter_result *r, struct nlattr **tb,
 		  struct nlattr *est, u32 flags, struct netlink_ext_ack *extack)
 {
-	struct tcindex_filter_result new_filter_result, *old_r = r;
+	struct tcindex_filter_result new_filter_result;
 	struct tcindex_data *cp = NULL, *oldp;
 	struct tcindex_filter *f = NULL; /* make gcc behave */
 	struct tcf_result cr = {};
@@ -401,7 +401,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	err = tcindex_filter_result_init(&new_filter_result, cp, net);
 	if (err < 0)
 		goto errout_alloc;
-	if (old_r)
+	if (r)
 		cr = r->res;
 
 	err = -EBUSY;
@@ -478,14 +478,6 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 		tcf_bind_filter(tp, &cr, base);
 	}
 
-	if (old_r && old_r != r) {
-		err = tcindex_filter_result_init(old_r, cp, net);
-		if (err < 0) {
-			kfree(f);
-			goto errout_alloc;
-		}
-	}
-
 	oldp = p;
 	r->res = cr;
 	tcf_exts_change(&r->exts, &e);
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 70fe1c5e44ad..33737169cc2d 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -397,10 +397,13 @@ static int atm_tc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 				result = tcf_classify(skb, NULL, fl, &res, true);
 				if (result < 0)
 					continue;
+				if (result == TC_ACT_SHOT)
+					goto done;
+
 				flow = (struct atm_flow_data *)res.class;
 				if (!flow)
 					flow = lookup_flow(sch, res.classid);
-				goto done;
+				goto drop;
 			}
 		}
 		flow = NULL;
diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index fd7e10567371..46b3dd71777d 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -231,6 +231,8 @@ cbq_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 		result = tcf_classify(skb, NULL, fl, &res, true);
 		if (!fl || result < 0)
 			goto fallback;
+		if (result == TC_ACT_SHOT)
+			return NULL;
 
 		cl = (void *)res.class;
 		if (!cl) {
@@ -251,8 +253,6 @@ cbq_classify(struct sk_buff *skb, struct Qdisc *sch, int *qerr)
 		case TC_ACT_TRAP:
 			*qerr = NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
 			fallthrough;
-		case TC_ACT_SHOT:
-			return NULL;
 		case TC_ACT_RECLASSIFY:
 			return cbq_reclassify(skb, cl);
 		}
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 5f42aa5fc612..2ff66a6a7e54 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -301,7 +301,7 @@ __gss_find_upcall(struct rpc_pipe *pipe, kuid_t uid, const struct gss_auth *auth
 	list_for_each_entry(pos, &pipe->in_downcall, list) {
 		if (!uid_eq(pos->uid, uid))
 			continue;
-		if (auth && pos->auth->service != auth->service)
+		if (pos->auth->service != auth->service)
 			continue;
 		refcount_inc(&pos->count);
 		return pos;
@@ -685,6 +685,21 @@ gss_create_upcall(struct gss_auth *gss_auth, struct gss_cred *gss_cred)
 	return err;
 }
 
+static struct gss_upcall_msg *
+gss_find_downcall(struct rpc_pipe *pipe, kuid_t uid)
+{
+	struct gss_upcall_msg *pos;
+	list_for_each_entry(pos, &pipe->in_downcall, list) {
+		if (!uid_eq(pos->uid, uid))
+			continue;
+		if (!rpc_msg_is_inflight(&pos->msg))
+			continue;
+		refcount_inc(&pos->count);
+		return pos;
+	}
+	return NULL;
+}
+
 #define MSG_BUF_MAXSIZE 1024
 
 static ssize_t
@@ -731,7 +746,7 @@ gss_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
 	err = -ENOENT;
 	/* Find a matching upcall */
 	spin_lock(&pipe->lock);
-	gss_msg = __gss_find_upcall(pipe, uid, NULL);
+	gss_msg = gss_find_downcall(pipe, uid);
 	if (gss_msg == NULL) {
 		spin_unlock(&pipe->lock);
 		goto err_put_ctx;
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 1f2817195549..48b608cb5f5e 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1162,18 +1162,23 @@ static int gss_read_proxy_verf(struct svc_rqst *rqstp,
 		return res;
 
 	inlen = svc_getnl(argv);
-	if (inlen > (argv->iov_len + rqstp->rq_arg.page_len))
+	if (inlen > (argv->iov_len + rqstp->rq_arg.page_len)) {
+		kfree(in_handle->data);
 		return SVC_DENIED;
+	}
 
 	pages = DIV_ROUND_UP(inlen, PAGE_SIZE);
 	in_token->pages = kcalloc(pages, sizeof(struct page *), GFP_KERNEL);
-	if (!in_token->pages)
+	if (!in_token->pages) {
+		kfree(in_handle->data);
 		return SVC_DENIED;
+	}
 	in_token->page_base = 0;
 	in_token->page_len = inlen;
 	for (i = 0; i < pages; i++) {
 		in_token->pages[i] = alloc_page(GFP_KERNEL);
 		if (!in_token->pages[i]) {
+			kfree(in_handle->data);
 			gss_free_in_token_pages(in_token);
 			return SVC_DENIED;
 		}
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 04375df52fc9..fe5cb7696993 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -81,6 +81,17 @@ static int dev_exceptions_copy(struct list_head *dest, struct list_head *orig)
 	return -ENOMEM;
 }
 
+static void dev_exceptions_move(struct list_head *dest, struct list_head *orig)
+{
+	struct dev_exception_item *ex, *tmp;
+
+	lockdep_assert_held(&devcgroup_mutex);
+
+	list_for_each_entry_safe(ex, tmp, orig, list) {
+		list_move_tail(&ex->list, dest);
+	}
+}
+
 /*
  * called under devcgroup_mutex
  */
@@ -603,11 +614,13 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 	int count, rc = 0;
 	struct dev_exception_item ex;
 	struct dev_cgroup *parent = css_to_devcgroup(devcgroup->css.parent);
+	struct dev_cgroup tmp_devcgrp;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	memset(&ex, 0, sizeof(ex));
+	memset(&tmp_devcgrp, 0, sizeof(tmp_devcgrp));
 	b = buffer;
 
 	switch (*b) {
@@ -619,15 +632,27 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 
 			if (!may_allow_all(parent))
 				return -EPERM;
-			dev_exception_clean(devcgroup);
-			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
-			if (!parent)
+			if (!parent) {
+				devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
+				dev_exception_clean(devcgroup);
 				break;
+			}
 
+			INIT_LIST_HEAD(&tmp_devcgrp.exceptions);
+			rc = dev_exceptions_copy(&tmp_devcgrp.exceptions,
+						 &devcgroup->exceptions);
+			if (rc)
+				return rc;
+			dev_exception_clean(devcgroup);
 			rc = dev_exceptions_copy(&devcgroup->exceptions,
 						 &parent->exceptions);
-			if (rc)
+			if (rc) {
+				dev_exceptions_move(&devcgroup->exceptions,
+						    &tmp_devcgrp.exceptions);
 				return rc;
+			}
+			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
+			dev_exception_clean(&tmp_devcgrp);
 			break;
 		case DEVCG_DENY:
 			if (css_has_online_children(&devcgroup->css))
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index f84a0598e4f6..31a8388e3dfa 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -336,8 +336,11 @@ static struct ima_template_desc *restore_template_fmt(char *template_name)
 
 	template_desc->name = "";
 	template_desc->fmt = kstrdup(template_name, GFP_KERNEL);
-	if (!template_desc->fmt)
+	if (!template_desc->fmt) {
+		kfree(template_desc);
+		template_desc = NULL;
 		goto out;
+	}
 
 	spin_lock(&template_list);
 	list_add_tail_rcu(&template_desc->list, &defined_templates);
diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integrity/platform_certs/load_uefi.c
index 185c609c6e38..d2f2c3936277 100644
--- a/security/integrity/platform_certs/load_uefi.c
+++ b/security/integrity/platform_certs/load_uefi.c
@@ -34,6 +34,7 @@ static const struct dmi_system_id uefi_skip_cert[] = {
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMacPro1,1") },
 	{ }
 };
 
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 79c65da1b4ee..642e212278ac 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6709,6 +6709,34 @@ static void alc256_fixup_mic_no_presence_and_resume(struct hda_codec *codec,
 	}
 }
 
+static void alc295_fixup_dell_inspiron_top_speakers(struct hda_codec *codec,
+					  const struct hda_fixup *fix, int action)
+{
+	static const struct hda_pintbl pincfgs[] = {
+		{ 0x14, 0x90170151 },
+		{ 0x17, 0x90170150 },
+		{ }
+	};
+	static const hda_nid_t conn[] = { 0x02, 0x03 };
+	static const hda_nid_t preferred_pairs[] = {
+		0x14, 0x02,
+		0x17, 0x03,
+		0x21, 0x02,
+		0
+	};
+	struct alc_spec *spec = codec->spec;
+
+	alc_fixup_no_shutup(codec, fix, action);
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		snd_hda_apply_pincfgs(codec, pincfgs);
+		snd_hda_override_conn_list(codec, 0x17, ARRAY_SIZE(conn), conn);
+		spec->gen.preferred_dacs = preferred_pairs;
+		break;
+	}
+}
+
 enum {
 	ALC269_FIXUP_GPIO2,
 	ALC269_FIXUP_SONY_VAIO,
@@ -6940,6 +6968,8 @@ enum {
 	ALC285_FIXUP_LEGION_Y9000X_SPEAKERS,
 	ALC285_FIXUP_LEGION_Y9000X_AUTOMUTE,
 	ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED,
+	ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS,
+	ALC236_FIXUP_DELL_DUAL_CODECS,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -8766,6 +8796,18 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC285_FIXUP_HP_MUTE_LED,
 	},
+	[ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc295_fixup_dell_inspiron_top_speakers,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
+	},
+	[ALC236_FIXUP_DELL_DUAL_CODECS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.func = alc1220_fixup_gb_dual_codecs,
+		.chained = true,
+		.chain_id = ALC255_FIXUP_DELL1_MIC_NO_PRESENCE,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -8865,6 +8907,14 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0a9e, "Dell Latitude 5430", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0b19, "Dell XPS 15 9520", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0b1a, "Dell Precision 5570", ALC289_FIXUP_DUAL_SPK),
+	SND_PCI_QUIRK(0x1028, 0x0b37, "Dell Inspiron 16 Plus 7620 2-in-1", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
+	SND_PCI_QUIRK(0x1028, 0x0b71, "Dell Inspiron 16 Plus 7620", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
+	SND_PCI_QUIRK(0x1028, 0x0c19, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1028, 0x0c1a, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1028, 0x0c1b, "Dell Precision 3440", ALC236_FIXUP_DELL_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1028, 0x0c1c, "Dell Precision 3540", ALC236_FIXUP_DELL_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1028, 0x0c1d, "Dell Precision 3440", ALC236_FIXUP_DELL_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1028, 0x0c1e, "Dell Precision 3540", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
diff --git a/sound/soc/codecs/hdac_hda.c b/sound/soc/codecs/hdac_hda.c
index 390dd6c7f6a5..de5955db0a5f 100644
--- a/sound/soc/codecs/hdac_hda.c
+++ b/sound/soc/codecs/hdac_hda.c
@@ -46,9 +46,8 @@ static int hdac_hda_dai_hw_params(struct snd_pcm_substream *substream,
 				  struct snd_soc_dai *dai);
 static int hdac_hda_dai_hw_free(struct snd_pcm_substream *substream,
 				struct snd_soc_dai *dai);
-static int hdac_hda_dai_set_tdm_slot(struct snd_soc_dai *dai,
-				     unsigned int tx_mask, unsigned int rx_mask,
-				     int slots, int slot_width);
+static int hdac_hda_dai_set_stream(struct snd_soc_dai *dai, void *stream,
+				   int direction);
 static struct hda_pcm *snd_soc_find_pcm_from_dai(struct hdac_hda_priv *hda_pvt,
 						 struct snd_soc_dai *dai);
 
@@ -58,7 +57,7 @@ static const struct snd_soc_dai_ops hdac_hda_dai_ops = {
 	.prepare = hdac_hda_dai_prepare,
 	.hw_params = hdac_hda_dai_hw_params,
 	.hw_free = hdac_hda_dai_hw_free,
-	.set_tdm_slot = hdac_hda_dai_set_tdm_slot,
+	.set_stream = hdac_hda_dai_set_stream,
 };
 
 static struct snd_soc_dai_driver hdac_hda_dais[] = {
@@ -180,21 +179,22 @@ static struct snd_soc_dai_driver hdac_hda_dais[] = {
 
 };
 
-static int hdac_hda_dai_set_tdm_slot(struct snd_soc_dai *dai,
-				     unsigned int tx_mask, unsigned int rx_mask,
-				     int slots, int slot_width)
+static int hdac_hda_dai_set_stream(struct snd_soc_dai *dai,
+				   void *stream, int direction)
 {
 	struct snd_soc_component *component = dai->component;
 	struct hdac_hda_priv *hda_pvt;
 	struct hdac_hda_pcm *pcm;
+	struct hdac_stream *hstream;
+
+	if (!stream)
+		return -EINVAL;
 
 	hda_pvt = snd_soc_component_get_drvdata(component);
 	pcm = &hda_pvt->pcm[dai->id];
+	hstream = (struct hdac_stream *)stream;
 
-	if (tx_mask)
-		pcm->stream_tag[SNDRV_PCM_STREAM_PLAYBACK] = tx_mask;
-	else
-		pcm->stream_tag[SNDRV_PCM_STREAM_CAPTURE] = rx_mask;
+	pcm->stream_tag[direction] = hstream->stream_tag;
 
 	return 0;
 }
diff --git a/sound/soc/codecs/max98373-sdw.c b/sound/soc/codecs/max98373-sdw.c
index 12323d4b5bfa..97b64477dde6 100644
--- a/sound/soc/codecs/max98373-sdw.c
+++ b/sound/soc/codecs/max98373-sdw.c
@@ -741,7 +741,7 @@ static int max98373_sdw_set_tdm_slot(struct snd_soc_dai *dai,
 static const struct snd_soc_dai_ops max98373_dai_sdw_ops = {
 	.hw_params = max98373_sdw_dai_hw_params,
 	.hw_free = max98373_pcm_hw_free,
-	.set_sdw_stream = max98373_set_sdw_stream,
+	.set_stream = max98373_set_sdw_stream,
 	.shutdown = max98373_shutdown,
 	.set_tdm_slot = max98373_sdw_set_tdm_slot,
 };
diff --git a/sound/soc/codecs/rt1308-sdw.c b/sound/soc/codecs/rt1308-sdw.c
index 8472d855c325..03adf3324b81 100644
--- a/sound/soc/codecs/rt1308-sdw.c
+++ b/sound/soc/codecs/rt1308-sdw.c
@@ -613,7 +613,7 @@ static const struct snd_soc_component_driver soc_component_sdw_rt1308 = {
 static const struct snd_soc_dai_ops rt1308_aif_dai_ops = {
 	.hw_params = rt1308_sdw_hw_params,
 	.hw_free	= rt1308_sdw_pcm_hw_free,
-	.set_sdw_stream	= rt1308_set_sdw_stream,
+	.set_stream	= rt1308_set_sdw_stream,
 	.shutdown	= rt1308_sdw_shutdown,
 	.set_tdm_slot	= rt1308_sdw_set_tdm_slot,
 };
diff --git a/sound/soc/codecs/rt1316-sdw.c b/sound/soc/codecs/rt1316-sdw.c
index 09cf3ca86fa4..1e04aa8ab166 100644
--- a/sound/soc/codecs/rt1316-sdw.c
+++ b/sound/soc/codecs/rt1316-sdw.c
@@ -602,7 +602,7 @@ static const struct snd_soc_component_driver soc_component_sdw_rt1316 = {
 static const struct snd_soc_dai_ops rt1316_aif_dai_ops = {
 	.hw_params = rt1316_sdw_hw_params,
 	.hw_free	= rt1316_sdw_pcm_hw_free,
-	.set_sdw_stream	= rt1316_set_sdw_stream,
+	.set_stream	= rt1316_set_sdw_stream,
 	.shutdown	= rt1316_sdw_shutdown,
 };
 
diff --git a/sound/soc/codecs/rt5682-sdw.c b/sound/soc/codecs/rt5682-sdw.c
index a030c9987b92..f04e18c32489 100644
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -272,7 +272,7 @@ static int rt5682_sdw_hw_free(struct snd_pcm_substream *substream,
 static const struct snd_soc_dai_ops rt5682_sdw_ops = {
 	.hw_params	= rt5682_sdw_hw_params,
 	.hw_free	= rt5682_sdw_hw_free,
-	.set_sdw_stream	= rt5682_set_sdw_stream,
+	.set_stream	= rt5682_set_sdw_stream,
 	.shutdown	= rt5682_sdw_shutdown,
 };
 
diff --git a/sound/soc/codecs/rt700.c b/sound/soc/codecs/rt700.c
index e049d672ccfd..3de3406d653e 100644
--- a/sound/soc/codecs/rt700.c
+++ b/sound/soc/codecs/rt700.c
@@ -1015,7 +1015,7 @@ static int rt700_pcm_hw_free(struct snd_pcm_substream *substream,
 static const struct snd_soc_dai_ops rt700_ops = {
 	.hw_params	= rt700_pcm_hw_params,
 	.hw_free	= rt700_pcm_hw_free,
-	.set_sdw_stream	= rt700_set_sdw_stream,
+	.set_stream	= rt700_set_sdw_stream,
 	.shutdown	= rt700_shutdown,
 };
 
diff --git a/sound/soc/codecs/rt711-sdca.c b/sound/soc/codecs/rt711-sdca.c
index 3b5df3ea2f60..5ad53bbc8528 100644
--- a/sound/soc/codecs/rt711-sdca.c
+++ b/sound/soc/codecs/rt711-sdca.c
@@ -1361,7 +1361,7 @@ static int rt711_sdca_pcm_hw_free(struct snd_pcm_substream *substream,
 static const struct snd_soc_dai_ops rt711_sdca_ops = {
 	.hw_params	= rt711_sdca_pcm_hw_params,
 	.hw_free	= rt711_sdca_pcm_hw_free,
-	.set_sdw_stream	= rt711_sdca_set_sdw_stream,
+	.set_stream	= rt711_sdca_set_sdw_stream,
 	.shutdown	= rt711_sdca_shutdown,
 };
 
diff --git a/sound/soc/codecs/rt711.c b/sound/soc/codecs/rt711.c
index 51a98e730fc8..286d882636e0 100644
--- a/sound/soc/codecs/rt711.c
+++ b/sound/soc/codecs/rt711.c
@@ -1092,7 +1092,7 @@ static int rt711_pcm_hw_free(struct snd_pcm_substream *substream,
 static const struct snd_soc_dai_ops rt711_ops = {
 	.hw_params	= rt711_pcm_hw_params,
 	.hw_free	= rt711_pcm_hw_free,
-	.set_sdw_stream	= rt711_set_sdw_stream,
+	.set_stream	= rt711_set_sdw_stream,
 	.shutdown	= rt711_shutdown,
 };
 
diff --git a/sound/soc/codecs/rt715-sdca.c b/sound/soc/codecs/rt715-sdca.c
index 66e166568c50..bfa536bd7196 100644
--- a/sound/soc/codecs/rt715-sdca.c
+++ b/sound/soc/codecs/rt715-sdca.c
@@ -938,7 +938,7 @@ static int rt715_sdca_pcm_hw_free(struct snd_pcm_substream *substream,
 static const struct snd_soc_dai_ops rt715_sdca_ops = {
 	.hw_params	= rt715_sdca_pcm_hw_params,
 	.hw_free	= rt715_sdca_pcm_hw_free,
-	.set_sdw_stream	= rt715_sdca_set_sdw_stream,
+	.set_stream	= rt715_sdca_set_sdw_stream,
 	.shutdown	= rt715_sdca_shutdown,
 };
 
diff --git a/sound/soc/codecs/rt715.c b/sound/soc/codecs/rt715.c
index 1352869cc086..a64d11a74751 100644
--- a/sound/soc/codecs/rt715.c
+++ b/sound/soc/codecs/rt715.c
@@ -909,7 +909,7 @@ static int rt715_pcm_hw_free(struct snd_pcm_substream *substream,
 static const struct snd_soc_dai_ops rt715_ops = {
 	.hw_params	= rt715_pcm_hw_params,
 	.hw_free	= rt715_pcm_hw_free,
-	.set_sdw_stream	= rt715_set_sdw_stream,
+	.set_stream	= rt715_set_sdw_stream,
 	.shutdown	= rt715_shutdown,
 };
 
diff --git a/sound/soc/codecs/sdw-mockup.c b/sound/soc/codecs/sdw-mockup.c
index 8ea13cfa9f8e..7c612aaf31c7 100644
--- a/sound/soc/codecs/sdw-mockup.c
+++ b/sound/soc/codecs/sdw-mockup.c
@@ -138,7 +138,7 @@ static int sdw_mockup_pcm_hw_free(struct snd_pcm_substream *substream,
 static const struct snd_soc_dai_ops sdw_mockup_ops = {
 	.hw_params	= sdw_mockup_pcm_hw_params,
 	.hw_free	= sdw_mockup_pcm_hw_free,
-	.set_sdw_stream	= sdw_mockup_set_sdw_stream,
+	.set_stream	= sdw_mockup_set_sdw_stream,
 	.shutdown	= sdw_mockup_shutdown,
 };
 
diff --git a/sound/soc/codecs/wcd938x.c b/sound/soc/codecs/wcd938x.c
index 8cdc45e669f2..b95cbae58641 100644
--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -4302,7 +4302,7 @@ static int wcd938x_codec_set_sdw_stream(struct snd_soc_dai *dai,
 static const struct snd_soc_dai_ops wcd938x_sdw_dai_ops = {
 	.hw_params = wcd938x_codec_hw_params,
 	.hw_free = wcd938x_codec_free,
-	.set_sdw_stream = wcd938x_codec_set_sdw_stream,
+	.set_stream = wcd938x_codec_set_sdw_stream,
 };
 
 static struct snd_soc_dai_driver wcd938x_dais[] = {
diff --git a/sound/soc/codecs/wsa881x.c b/sound/soc/codecs/wsa881x.c
index 564b78f3cdd0..0222370ff95d 100644
--- a/sound/soc/codecs/wsa881x.c
+++ b/sound/soc/codecs/wsa881x.c
@@ -1026,7 +1026,7 @@ static const struct snd_soc_dai_ops wsa881x_dai_ops = {
 	.hw_params = wsa881x_hw_params,
 	.hw_free = wsa881x_hw_free,
 	.mute_stream = wsa881x_digital_mute,
-	.set_sdw_stream = wsa881x_set_sdw_stream,
+	.set_stream = wsa881x_set_sdw_stream,
 };
 
 static struct snd_soc_dai_driver wsa881x_dais[] = {
diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index f9c82ebc552c..888e04c57757 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -570,6 +570,21 @@ static const struct dmi_system_id byt_rt5640_quirk_table[] = {
 					BYT_RT5640_SSP0_AIF1 |
 					BYT_RT5640_MCLK_EN),
 	},
+	{
+		/* Advantech MICA-071 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Advantech"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "MICA-071"),
+		},
+		/* OVCD Th = 1500uA to reliable detect head-phones vs -set */
+		.driver_data = (void *)(BYT_RT5640_IN3_MAP |
+					BYT_RT5640_JD_SRC_JD2_IN4N |
+					BYT_RT5640_OVCD_TH_1500UA |
+					BYT_RT5640_OVCD_SF_0P75 |
+					BYT_RT5640_MONO_SPEAKER |
+					BYT_RT5640_DIFF_MIC |
+					BYT_RT5640_MCLK_EN),
+	},
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ARCHOS"),
diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/sof_sdw.c
index 294e76d590ad..2d53a707aff9 100644
--- a/sound/soc/intel/boards/sof_sdw.c
+++ b/sound/soc/intel/boards/sof_sdw.c
@@ -291,7 +291,7 @@ int sdw_prepare(struct snd_pcm_substream *substream)
 	/* Find stream from first CPU DAI */
 	dai = asoc_rtd_to_cpu(rtd, 0);
 
-	sdw_stream = snd_soc_dai_get_sdw_stream(dai, substream->stream);
+	sdw_stream = snd_soc_dai_get_stream(dai, substream->stream);
 
 	if (IS_ERR(sdw_stream)) {
 		dev_err(rtd->dev, "no stream found for DAI %s", dai->name);
@@ -311,7 +311,7 @@ int sdw_trigger(struct snd_pcm_substream *substream, int cmd)
 	/* Find stream from first CPU DAI */
 	dai = asoc_rtd_to_cpu(rtd, 0);
 
-	sdw_stream = snd_soc_dai_get_sdw_stream(dai, substream->stream);
+	sdw_stream = snd_soc_dai_get_stream(dai, substream->stream);
 
 	if (IS_ERR(sdw_stream)) {
 		dev_err(rtd->dev, "no stream found for DAI %s", dai->name);
@@ -350,7 +350,7 @@ int sdw_hw_free(struct snd_pcm_substream *substream)
 	/* Find stream from first CPU DAI */
 	dai = asoc_rtd_to_cpu(rtd, 0);
 
-	sdw_stream = snd_soc_dai_get_sdw_stream(dai, substream->stream);
+	sdw_stream = snd_soc_dai_get_stream(dai, substream->stream);
 
 	if (IS_ERR(sdw_stream)) {
 		dev_err(rtd->dev, "no stream found for DAI %s", dai->name);
diff --git a/sound/soc/intel/skylake/skl-pcm.c b/sound/soc/intel/skylake/skl-pcm.c
index e4aa366d356e..db41bd717065 100644
--- a/sound/soc/intel/skylake/skl-pcm.c
+++ b/sound/soc/intel/skylake/skl-pcm.c
@@ -562,11 +562,8 @@ static int skl_link_hw_params(struct snd_pcm_substream *substream,
 
 	stream_tag = hdac_stream(link_dev)->stream_tag;
 
-	/* set the stream tag in the codec dai dma params  */
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		snd_soc_dai_set_tdm_slot(codec_dai, stream_tag, 0, 0, 0);
-	else
-		snd_soc_dai_set_tdm_slot(codec_dai, 0, stream_tag, 0, 0);
+	/* set the hdac_stream in the codec dai */
+	snd_soc_dai_set_stream(codec_dai, hdac_stream(link_dev), substream->stream);
 
 	p_params.s_fmt = snd_pcm_format_width(params_format(params));
 	p_params.ch = params_channels(params);
diff --git a/sound/soc/jz4740/jz4740-i2s.c b/sound/soc/jz4740/jz4740-i2s.c
index 7ad5d9a924d8..4e1fc4ba5150 100644
--- a/sound/soc/jz4740/jz4740-i2s.c
+++ b/sound/soc/jz4740/jz4740-i2s.c
@@ -56,7 +56,8 @@
 #define JZ_AIC_CTRL_MONO_TO_STEREO BIT(11)
 #define JZ_AIC_CTRL_SWITCH_ENDIANNESS BIT(10)
 #define JZ_AIC_CTRL_SIGNED_TO_UNSIGNED BIT(9)
-#define JZ_AIC_CTRL_FLUSH		BIT(8)
+#define JZ_AIC_CTRL_TFLUSH		BIT(8)
+#define JZ_AIC_CTRL_RFLUSH		BIT(7)
 #define JZ_AIC_CTRL_ENABLE_ROR_INT BIT(6)
 #define JZ_AIC_CTRL_ENABLE_TUR_INT BIT(5)
 #define JZ_AIC_CTRL_ENABLE_RFS_INT BIT(4)
@@ -91,6 +92,8 @@ enum jz47xx_i2s_version {
 struct i2s_soc_info {
 	enum jz47xx_i2s_version version;
 	struct snd_soc_dai_driver *dai;
+
+	bool shared_fifo_flush;
 };
 
 struct jz4740_i2s {
@@ -119,19 +122,44 @@ static inline void jz4740_i2s_write(const struct jz4740_i2s *i2s,
 	writel(value, i2s->base + reg);
 }
 
+static inline void jz4740_i2s_set_bits(const struct jz4740_i2s *i2s,
+	unsigned int reg, uint32_t bits)
+{
+	uint32_t value = jz4740_i2s_read(i2s, reg);
+	value |= bits;
+	jz4740_i2s_write(i2s, reg, value);
+}
+
 static int jz4740_i2s_startup(struct snd_pcm_substream *substream,
 	struct snd_soc_dai *dai)
 {
 	struct jz4740_i2s *i2s = snd_soc_dai_get_drvdata(dai);
-	uint32_t conf, ctrl;
+	uint32_t conf;
 	int ret;
 
+	/*
+	 * When we can flush FIFOs independently, only flush the FIFO
+	 * that is starting up. We can do this when the DAI is active
+	 * because it does not disturb other active substreams.
+	 */
+	if (!i2s->soc_info->shared_fifo_flush) {
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			jz4740_i2s_set_bits(i2s, JZ_REG_AIC_CTRL, JZ_AIC_CTRL_TFLUSH);
+		else
+			jz4740_i2s_set_bits(i2s, JZ_REG_AIC_CTRL, JZ_AIC_CTRL_RFLUSH);
+	}
+
 	if (snd_soc_dai_active(dai))
 		return 0;
 
-	ctrl = jz4740_i2s_read(i2s, JZ_REG_AIC_CTRL);
-	ctrl |= JZ_AIC_CTRL_FLUSH;
-	jz4740_i2s_write(i2s, JZ_REG_AIC_CTRL, ctrl);
+	/*
+	 * When there is a shared flush bit for both FIFOs, the TFLUSH
+	 * bit flushes both FIFOs. Flushing while the DAI is active would
+	 * cause FIFO underruns in other active substreams so we have to
+	 * guard this behind the snd_soc_dai_active() check.
+	 */
+	if (i2s->soc_info->shared_fifo_flush)
+		jz4740_i2s_set_bits(i2s, JZ_REG_AIC_CTRL, JZ_AIC_CTRL_TFLUSH);
 
 	ret = clk_prepare_enable(i2s->clk_i2s);
 	if (ret)
@@ -462,6 +490,7 @@ static struct snd_soc_dai_driver jz4740_i2s_dai = {
 static const struct i2s_soc_info jz4740_i2s_soc_info = {
 	.version = JZ_I2S_JZ4740,
 	.dai = &jz4740_i2s_dai,
+	.shared_fifo_flush = true,
 };
 
 static const struct i2s_soc_info jz4760_i2s_soc_info = {
diff --git a/sound/soc/qcom/sdm845.c b/sound/soc/qcom/sdm845.c
index 0adfc5708949..4da5ad609fce 100644
--- a/sound/soc/qcom/sdm845.c
+++ b/sound/soc/qcom/sdm845.c
@@ -56,8 +56,8 @@ static int sdm845_slim_snd_hw_params(struct snd_pcm_substream *substream,
 	int ret = 0, i;
 
 	for_each_rtd_codec_dais(rtd, i, codec_dai) {
-		sruntime = snd_soc_dai_get_sdw_stream(codec_dai,
-						      substream->stream);
+		sruntime = snd_soc_dai_get_stream(codec_dai,
+						  substream->stream);
 		if (sruntime != ERR_PTR(-ENOTSUPP))
 			pdata->sruntime[cpu_dai->id] = sruntime;
 
diff --git a/sound/soc/qcom/sm8250.c b/sound/soc/qcom/sm8250.c
index e5190aa588c6..feb6589171ca 100644
--- a/sound/soc/qcom/sm8250.c
+++ b/sound/soc/qcom/sm8250.c
@@ -70,8 +70,8 @@ static int sm8250_snd_hw_params(struct snd_pcm_substream *substream,
 	switch (cpu_dai->id) {
 	case WSA_CODEC_DMA_RX_0:
 		for_each_rtd_codec_dais(rtd, i, codec_dai) {
-			sruntime = snd_soc_dai_get_sdw_stream(codec_dai,
-						      substream->stream);
+			sruntime = snd_soc_dai_get_stream(codec_dai,
+							  substream->stream);
 			if (sruntime != ERR_PTR(-ENOTSUPP))
 				pdata->sruntime[cpu_dai->id] = sruntime;
 		}
diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index 6704dbcd101c..5f355b8d57a0 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -236,11 +236,8 @@ static int hda_link_hw_params(struct snd_pcm_substream *substream,
 	if (!link)
 		return -EINVAL;
 
-	/* set the stream tag in the codec dai dma params */
-	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
-		snd_soc_dai_set_tdm_slot(codec_dai, stream_tag, 0, 0, 0);
-	else
-		snd_soc_dai_set_tdm_slot(codec_dai, 0, stream_tag, 0, 0);
+	/* set the hdac_stream in the codec dai */
+	snd_soc_dai_set_stream(codec_dai, hdac_stream(link_dev), substream->stream);
 
 	p_params.s_fmt = snd_pcm_format_width(params_format(params));
 	p_params.ch = params_channels(params);
diff --git a/sound/usb/line6/driver.c b/sound/usb/line6/driver.c
index 59faa5a9a714..b67617b68e50 100644
--- a/sound/usb/line6/driver.c
+++ b/sound/usb/line6/driver.c
@@ -304,7 +304,8 @@ static void line6_data_received(struct urb *urb)
 		for (;;) {
 			done =
 				line6_midibuf_read(mb, line6->buffer_message,
-						LINE6_MIDI_MESSAGE_MAXLEN);
+						   LINE6_MIDI_MESSAGE_MAXLEN,
+						   LINE6_MIDIBUF_READ_RX);
 
 			if (done <= 0)
 				break;
diff --git a/sound/usb/line6/midi.c b/sound/usb/line6/midi.c
index ba0e2b7e8fe1..0838632c788e 100644
--- a/sound/usb/line6/midi.c
+++ b/sound/usb/line6/midi.c
@@ -44,7 +44,8 @@ static void line6_midi_transmit(struct snd_rawmidi_substream *substream)
 	int req, done;
 
 	for (;;) {
-		req = min(line6_midibuf_bytes_free(mb), line6->max_packet_size);
+		req = min3(line6_midibuf_bytes_free(mb), line6->max_packet_size,
+			   LINE6_FALLBACK_MAXPACKETSIZE);
 		done = snd_rawmidi_transmit_peek(substream, chunk, req);
 
 		if (done == 0)
@@ -56,7 +57,8 @@ static void line6_midi_transmit(struct snd_rawmidi_substream *substream)
 
 	for (;;) {
 		done = line6_midibuf_read(mb, chunk,
-					  LINE6_FALLBACK_MAXPACKETSIZE);
+					  LINE6_FALLBACK_MAXPACKETSIZE,
+					  LINE6_MIDIBUF_READ_TX);
 
 		if (done == 0)
 			break;
diff --git a/sound/usb/line6/midibuf.c b/sound/usb/line6/midibuf.c
index 6a70463f82c4..e7f830f7526c 100644
--- a/sound/usb/line6/midibuf.c
+++ b/sound/usb/line6/midibuf.c
@@ -9,6 +9,7 @@
 
 #include "midibuf.h"
 
+
 static int midibuf_message_length(unsigned char code)
 {
 	int message_length;
@@ -20,12 +21,7 @@ static int midibuf_message_length(unsigned char code)
 
 		message_length = length[(code >> 4) - 8];
 	} else {
-		/*
-		   Note that according to the MIDI specification 0xf2 is
-		   the "Song Position Pointer", but this is used by Line 6
-		   to send sysex messages to the host.
-		 */
-		static const int length[] = { -1, 2, -1, 2, -1, -1, 1, 1, 1, 1,
+		static const int length[] = { -1, 2, 2, 2, -1, -1, 1, 1, 1, -1,
 			1, 1, 1, -1, 1, 1
 		};
 		message_length = length[code & 0x0f];
@@ -125,7 +121,7 @@ int line6_midibuf_write(struct midi_buffer *this, unsigned char *data,
 }
 
 int line6_midibuf_read(struct midi_buffer *this, unsigned char *data,
-		       int length)
+		       int length, int read_type)
 {
 	int bytes_used;
 	int length1, length2;
@@ -148,9 +144,22 @@ int line6_midibuf_read(struct midi_buffer *this, unsigned char *data,
 
 	length1 = this->size - this->pos_read;
 
-	/* check MIDI command length */
 	command = this->buf[this->pos_read];
+	/*
+	   PODxt always has status byte lower nibble set to 0010,
+	   when it means to send 0000, so we correct if here so
+	   that control/program changes come on channel 1 and
+	   sysex message status byte is correct
+	 */
+	if (read_type == LINE6_MIDIBUF_READ_RX) {
+		if (command == 0xb2 || command == 0xc2 || command == 0xf2) {
+			unsigned char fixed = command & 0xf0;
+			this->buf[this->pos_read] = fixed;
+			command = fixed;
+		}
+	}
 
+	/* check MIDI command length */
 	if (command & 0x80) {
 		midi_length = midibuf_message_length(command);
 		this->command_prev = command;
diff --git a/sound/usb/line6/midibuf.h b/sound/usb/line6/midibuf.h
index 124a8f9f7e96..542e8d836f87 100644
--- a/sound/usb/line6/midibuf.h
+++ b/sound/usb/line6/midibuf.h
@@ -8,6 +8,9 @@
 #ifndef MIDIBUF_H
 #define MIDIBUF_H
 
+#define LINE6_MIDIBUF_READ_TX 0
+#define LINE6_MIDIBUF_READ_RX 1
+
 struct midi_buffer {
 	unsigned char *buf;
 	int size;
@@ -23,7 +26,7 @@ extern void line6_midibuf_destroy(struct midi_buffer *mb);
 extern int line6_midibuf_ignore(struct midi_buffer *mb, int length);
 extern int line6_midibuf_init(struct midi_buffer *mb, int size, int split);
 extern int line6_midibuf_read(struct midi_buffer *mb, unsigned char *data,
-			      int length);
+			      int length, int read_type);
 extern void line6_midibuf_reset(struct midi_buffer *mb);
 extern int line6_midibuf_write(struct midi_buffer *mb, unsigned char *data,
 			       int length);
diff --git a/sound/usb/line6/pod.c b/sound/usb/line6/pod.c
index 16e644330c4d..54be5ac919bf 100644
--- a/sound/usb/line6/pod.c
+++ b/sound/usb/line6/pod.c
@@ -159,8 +159,9 @@ static struct line6_pcm_properties pod_pcm_properties = {
 	.bytes_per_channel = 3 /* SNDRV_PCM_FMTBIT_S24_3LE */
 };
 
+
 static const char pod_version_header[] = {
-	0xf2, 0x7e, 0x7f, 0x06, 0x02
+	0xf0, 0x7e, 0x7f, 0x06, 0x02
 };
 
 static char *pod_alloc_sysex_buffer(struct usb_line6_pod *pod, int code,
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index edac5aaa2802..308c8806ad94 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -197,7 +197,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		return false;
 
 	insn = find_insn(file, func->sec, func->offset);
-	if (!insn->func)
+	if (!insn || !insn->func)
 		return false;
 
 	func_for_each_insn(file, func, insn) {
diff --git a/tools/perf/util/cgroup.c b/tools/perf/util/cgroup.c
index e99b41f9be45..cd978c240e0d 100644
--- a/tools/perf/util/cgroup.c
+++ b/tools/perf/util/cgroup.c
@@ -224,6 +224,19 @@ static int add_cgroup_name(const char *fpath, const struct stat *sb __maybe_unus
 	return 0;
 }
 
+static int check_and_add_cgroup_name(const char *fpath)
+{
+	struct cgroup_name *cn;
+
+	list_for_each_entry(cn, &cgroup_list, list) {
+		if (!strcmp(cn->name, fpath))
+			return 0;
+	}
+
+	/* pretend if it's added by ftw() */
+	return add_cgroup_name(fpath, NULL, FTW_D, NULL);
+}
+
 static void release_cgroup_list(void)
 {
 	struct cgroup_name *cn;
@@ -242,7 +255,7 @@ static int list_cgroups(const char *str)
 	struct cgroup_name *cn;
 	char *s;
 
-	/* use given name as is - for testing purpose */
+	/* use given name as is when no regex is given */
 	for (;;) {
 		p = strchr(str, ',');
 		e = p ? p : eos;
@@ -253,13 +266,13 @@ static int list_cgroups(const char *str)
 			s = strndup(str, e - str);
 			if (!s)
 				return -1;
-			/* pretend if it's added by ftw() */
-			ret = add_cgroup_name(s, NULL, FTW_D, NULL);
+
+			ret = check_and_add_cgroup_name(s);
 			free(s);
-			if (ret)
+			if (ret < 0)
 				return -1;
 		} else {
-			if (add_cgroup_name("", NULL, FTW_D, NULL) < 0)
+			if (check_and_add_cgroup_name("/") < 0)
 				return -1;
 		}
 
diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 15a4547d608e..090a76be522b 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -127,6 +127,7 @@ int perf_data__open_dir(struct perf_data *data)
 		file->size = st.st_size;
 	}
 
+	closedir(dir);
 	if (!files)
 		return -EINVAL;
 
@@ -135,6 +136,7 @@ int perf_data__open_dir(struct perf_data *data)
 	return 0;
 
 out_err:
+	closedir(dir);
 	close_dir(files, nr);
 	return ret;
 }
diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 609ca1671501..623527edeac1 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -308,26 +308,13 @@ static int die_get_attr_udata(Dwarf_Die *tp_die, unsigned int attr_name,
 {
 	Dwarf_Attribute attr;
 
-	if (dwarf_attr(tp_die, attr_name, &attr) == NULL ||
+	if (dwarf_attr_integrate(tp_die, attr_name, &attr) == NULL ||
 	    dwarf_formudata(&attr, result) != 0)
 		return -ENOENT;
 
 	return 0;
 }
 
-/* Get attribute and translate it as a sdata */
-static int die_get_attr_sdata(Dwarf_Die *tp_die, unsigned int attr_name,
-			      Dwarf_Sword *result)
-{
-	Dwarf_Attribute attr;
-
-	if (dwarf_attr(tp_die, attr_name, &attr) == NULL ||
-	    dwarf_formsdata(&attr, result) != 0)
-		return -ENOENT;
-
-	return 0;
-}
-
 /**
  * die_is_signed_type - Check whether a type DIE is signed or not
  * @tp_die: a DIE of a type
@@ -467,9 +454,9 @@ int die_get_data_member_location(Dwarf_Die *mb_die, Dwarf_Word *offs)
 /* Get the call file index number in CU DIE */
 static int die_get_call_fileno(Dwarf_Die *in_die)
 {
-	Dwarf_Sword idx;
+	Dwarf_Word idx;
 
-	if (die_get_attr_sdata(in_die, DW_AT_call_file, &idx) == 0)
+	if (die_get_attr_udata(in_die, DW_AT_call_file, &idx) == 0)
 		return (int)idx;
 	else
 		return -ENOENT;
@@ -478,9 +465,9 @@ static int die_get_call_fileno(Dwarf_Die *in_die)
 /* Get the declared file index number in CU DIE */
 static int die_get_decl_fileno(Dwarf_Die *pdie)
 {
-	Dwarf_Sword idx;
+	Dwarf_Word idx;
 
-	if (die_get_attr_sdata(pdie, DW_AT_decl_file, &idx) == 0)
+	if (die_get_attr_udata(pdie, DW_AT_decl_file, &idx) == 0)
 		return (int)idx;
 	else
 		return -ENOENT;
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 09d1578f9d66..1737c59e4ff6 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1963,7 +1963,7 @@ sub run_scp_mod {
 
 sub _get_grub_index {
 
-    my ($command, $target, $skip) = @_;
+    my ($command, $target, $skip, $submenu) = @_;
 
     return if (defined($grub_number) && defined($last_grub_menu) &&
 	$last_grub_menu eq $grub_menu && defined($last_machine) &&
@@ -1980,11 +1980,16 @@ sub _get_grub_index {
 
     my $found = 0;
 
+    my $submenu_number = 0;
+
     while (<IN>) {
 	if (/$target/) {
 	    $grub_number++;
 	    $found = 1;
 	    last;
+	} elsif (defined($submenu) && /$submenu/) {
+		$submenu_number++;
+		$grub_number = -1;
 	} elsif (/$skip/) {
 	    $grub_number++;
 	}
@@ -1993,6 +1998,9 @@ sub _get_grub_index {
 
     dodie "Could not find '$grub_menu' through $command on $machine"
 	if (!$found);
+    if ($submenu_number > 0) {
+	$grub_number = "$submenu_number>$grub_number";
+    }
     doprint "$grub_number\n";
     $last_grub_menu = $grub_menu;
     $last_machine = $machine;
@@ -2003,6 +2011,7 @@ sub get_grub_index {
     my $command;
     my $target;
     my $skip;
+    my $submenu;
     my $grub_menu_qt;
 
     if ($reboot_type !~ /^grub/) {
@@ -2017,8 +2026,9 @@ sub get_grub_index {
 	$skip = '^\s*title\s';
     } elsif ($reboot_type eq "grub2") {
 	$command = "cat $grub_file";
-	$target = '^menuentry.*' . $grub_menu_qt;
-	$skip = '^menuentry\s|^submenu\s';
+	$target = '^\s*menuentry.*' . $grub_menu_qt;
+	$skip = '^\s*menuentry';
+	$submenu = '^\s*submenu\s';
     } elsif ($reboot_type eq "grub2bls") {
 	$command = $grub_bls_get;
 	$target = '^title=.*' . $grub_menu_qt;
@@ -2027,7 +2037,7 @@ sub get_grub_index {
 	return;
     }
 
-    _get_grub_index($command, $target, $skip);
+    _get_grub_index($command, $target, $skip, $submenu);
 }
 
 sub wait_for_input {
@@ -2090,7 +2100,7 @@ sub reboot_to {
     if ($reboot_type eq "grub") {
 	run_ssh "'(echo \"savedefault --default=$grub_number --once\" | grub --batch)'";
     } elsif (($reboot_type eq "grub2") or ($reboot_type eq "grub2bls")) {
-	run_ssh "$grub_reboot $grub_number";
+	run_ssh "$grub_reboot \"'$grub_number'\"";
     } elsif ($reboot_type eq "syslinux") {
 	run_ssh "$syslinux --once \\\"$syslinux_label\\\" $syslinux_path";
     } elsif (defined $reboot_script) {
@@ -3768,9 +3778,10 @@ sub test_this_config {
     # .config to make sure it is missing the config that
     # we had before
     my %configs = %min_configs;
-    delete $configs{$config};
+    $configs{$config} = "# $config is not set";
     make_new_config ((values %configs), (values %keep_configs));
     make_oldconfig;
+    delete $configs{$config};
     undef %configs;
     assign_configs \%configs, $output_config;
 
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 14206d1d1efe..56a4873a343c 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -114,19 +114,27 @@ ifdef building_out_of_srctree
 override LDFLAGS =
 endif
 
-ifneq ($(O),)
-	BUILD := $(O)/kselftest
+top_srcdir ?= ../../..
+
+ifeq ("$(origin O)", "command line")
+  KBUILD_OUTPUT := $(O)
+endif
+
+ifneq ($(KBUILD_OUTPUT),)
+  # Make's built-in functions such as $(abspath ...), $(realpath ...) cannot
+  # expand a shell special character '~'. We use a somewhat tedious way here.
+  abs_objtree := $(shell cd $(top_srcdir) && mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) && pwd)
+  $(if $(abs_objtree),, \
+    $(error failed to create output directory "$(KBUILD_OUTPUT)"))
+  # $(realpath ...) resolves symlinks
+  abs_objtree := $(realpath $(abs_objtree))
+  BUILD := $(abs_objtree)/kselftest
 else
-	ifneq ($(KBUILD_OUTPUT),)
-		BUILD := $(KBUILD_OUTPUT)/kselftest
-	else
-		BUILD := $(shell pwd)
-		DEFAULT_INSTALL_HDR_PATH := 1
-	endif
+  BUILD := $(CURDIR)
+  DEFAULT_INSTALL_HDR_PATH := 1
 endif
 
 # Prepare for headers install
-top_srcdir ?= ../../..
 include $(top_srcdir)/scripts/subarch.include
 ARCH           ?= $(SUBARCH)
 export KSFT_KHDR_INSTALL_DONE := 1
diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 4a2a47fcd6ef..5192305159ec 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -46,7 +46,3 @@ CONFIG_IMA_READ_POLICY=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_FUNCTION_TRACER=y
 CONFIG_DYNAMIC_FTRACE=y
-CONFIG_NETFILTER=y
-CONFIG_NF_DEFRAG_IPV4=y
-CONFIG_NF_DEFRAG_IPV6=y
-CONFIG_NF_CONNTRACK=y
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
deleted file mode 100644
index e3166a81e989..000000000000
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ /dev/null
@@ -1,48 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <test_progs.h>
-#include <network_helpers.h>
-#include "test_bpf_nf.skel.h"
-
-enum {
-	TEST_XDP,
-	TEST_TC_BPF,
-};
-
-void test_bpf_nf_ct(int mode)
-{
-	struct test_bpf_nf *skel;
-	int prog_fd, err, retval;
-
-	skel = test_bpf_nf__open_and_load();
-	if (!ASSERT_OK_PTR(skel, "test_bpf_nf__open_and_load"))
-		return;
-
-	if (mode == TEST_XDP)
-		prog_fd = bpf_program__fd(skel->progs.nf_xdp_ct_test);
-	else
-		prog_fd = bpf_program__fd(skel->progs.nf_skb_ct_test);
-
-	err = bpf_prog_test_run(prog_fd, 1, &pkt_v4, sizeof(pkt_v4), NULL, NULL,
-				(__u32 *)&retval, NULL);
-	if (!ASSERT_OK(err, "bpf_prog_test_run"))
-		goto end;
-
-	ASSERT_EQ(skel->bss->test_einval_bpf_tuple, -EINVAL, "Test EINVAL for NULL bpf_tuple");
-	ASSERT_EQ(skel->bss->test_einval_reserved, -EINVAL, "Test EINVAL for reserved not set to 0");
-	ASSERT_EQ(skel->bss->test_einval_netns_id, -EINVAL, "Test EINVAL for netns_id < -1");
-	ASSERT_EQ(skel->bss->test_einval_len_opts, -EINVAL, "Test EINVAL for len__opts != NF_BPF_CT_OPTS_SZ");
-	ASSERT_EQ(skel->bss->test_eproto_l4proto, -EPROTO, "Test EPROTO for l4proto != TCP or UDP");
-	ASSERT_EQ(skel->bss->test_enonet_netns_id, -ENONET, "Test ENONET for bad but valid netns_id");
-	ASSERT_EQ(skel->bss->test_enoent_lookup, -ENOENT, "Test ENOENT for failed lookup");
-	ASSERT_EQ(skel->bss->test_eafnosupport, -EAFNOSUPPORT, "Test EAFNOSUPPORT for invalid len__tuple");
-end:
-	test_bpf_nf__destroy(skel);
-}
-
-void test_bpf_nf(void)
-{
-	if (test__start_subtest("xdp-ct"))
-		test_bpf_nf_ct(TEST_XDP);
-	if (test__start_subtest("tc-bpf-ct"))
-		test_bpf_nf_ct(TEST_TC_BPF);
-}
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
deleted file mode 100644
index 6f131c993c0b..000000000000
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ /dev/null
@@ -1,109 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <vmlinux.h>
-#include <bpf/bpf_helpers.h>
-
-#define EAFNOSUPPORT 97
-#define EPROTO 71
-#define ENONET 64
-#define EINVAL 22
-#define ENOENT 2
-
-int test_einval_bpf_tuple = 0;
-int test_einval_reserved = 0;
-int test_einval_netns_id = 0;
-int test_einval_len_opts = 0;
-int test_eproto_l4proto = 0;
-int test_enonet_netns_id = 0;
-int test_enoent_lookup = 0;
-int test_eafnosupport = 0;
-
-struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *, struct bpf_sock_tuple *, u32,
-				  struct bpf_ct_opts *, u32) __ksym;
-struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *, struct bpf_sock_tuple *, u32,
-				  struct bpf_ct_opts *, u32) __ksym;
-void bpf_ct_release(struct nf_conn *) __ksym;
-
-static __always_inline void
-nf_ct_test(struct nf_conn *(*func)(void *, struct bpf_sock_tuple *, u32,
-				   struct bpf_ct_opts *, u32),
-	   void *ctx)
-{
-	struct bpf_ct_opts opts_def = { .l4proto = IPPROTO_TCP, .netns_id = -1 };
-	struct bpf_sock_tuple bpf_tuple;
-	struct nf_conn *ct;
-
-	__builtin_memset(&bpf_tuple, 0, sizeof(bpf_tuple.ipv4));
-
-	ct = func(ctx, NULL, 0, &opts_def, sizeof(opts_def));
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_einval_bpf_tuple = opts_def.error;
-
-	opts_def.reserved[0] = 1;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
-	opts_def.reserved[0] = 0;
-	opts_def.l4proto = IPPROTO_TCP;
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_einval_reserved = opts_def.error;
-
-	opts_def.netns_id = -2;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
-	opts_def.netns_id = -1;
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_einval_netns_id = opts_def.error;
-
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def) - 1);
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_einval_len_opts = opts_def.error;
-
-	opts_def.l4proto = IPPROTO_ICMP;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
-	opts_def.l4proto = IPPROTO_TCP;
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_eproto_l4proto = opts_def.error;
-
-	opts_def.netns_id = 0xf00f;
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
-	opts_def.netns_id = -1;
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_enonet_netns_id = opts_def.error;
-
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4), &opts_def, sizeof(opts_def));
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_enoent_lookup = opts_def.error;
-
-	ct = func(ctx, &bpf_tuple, sizeof(bpf_tuple.ipv4) - 1, &opts_def, sizeof(opts_def));
-	if (ct)
-		bpf_ct_release(ct);
-	else
-		test_eafnosupport = opts_def.error;
-}
-
-SEC("xdp")
-int nf_xdp_ct_test(struct xdp_md *ctx)
-{
-	nf_ct_test((void *)bpf_xdp_ct_lookup, ctx);
-	return 0;
-}
-
-SEC("tc")
-int nf_skb_ct_test(struct __sk_buff *ctx)
-{
-	nf_ct_test((void *)bpf_skb_ct_lookup, ctx);
-	return 0;
-}
-
-char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index fe7ee2b0f29c..a3df78b7702c 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -129,6 +129,11 @@ endef
 clean:
 	$(CLEAN)
 
+# Enables to extend CFLAGS and LDFLAGS from command line, e.g.
+# make USERCFLAGS=-Werror USERLDFLAGS=-static
+CFLAGS += $(USERCFLAGS)
+LDFLAGS += $(USERLDFLAGS)
+
 # When make O= with kselftest target from main level
 # the following aren't defined.
 #
