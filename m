Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC6D6ACA32
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 18:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjCFR2X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 12:28:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjCFR2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 12:28:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F7669061
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 09:27:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D779B80FE9
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 17:27:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D5EC4339B;
        Mon,  6 Mar 2023 17:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678123641;
        bh=R8arx6IGpOVxlHrBCpwQdHmAYRpQLjtcChmuaZ4evRE=;
        h=Subject:To:Cc:From:Date:From;
        b=vHWAybh7lbXUzqMADmrFwJOz8/edbw1D5fuD9f5K6ypykmEyg/q5IwaJNE6O8TBcj
         iUmzdyifr4aJRyh7Qindh2ksNVE6V8z3YQ5tmwFEzId//EknjYCGzVCUh8X4Ip5S/p
         IZQh6k3CQmBSHO4ErSGnTa6UZnNCDS7j/fQmIlK8=
Subject: FAILED: patch "[PATCH] x86/crash: Disable virt in core NMI crash handler to avoid" failed to apply to 4.19-stable tree
To:     seanjc@google.com, gpiccoli@igalia.com, pbonzini@redhat.com,
        tglx@linutronix.de, vkuznets@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Mar 2023 18:27:16 +0100
Message-ID: <1678123636156122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x 26044aff37a5455b19a91785086914fd33053ef4
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '1678123636156122@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

26044aff37a5 ("x86/crash: Disable virt in core NMI crash handler to avoid double shootdown")
ed72736183c4 ("x86/reboot: Force all cpus to exit VMX root if VMX is supported")
4d1d0977a215 ("x86: Fix a handful of typos")
22ca7ee933a3 ("x86/apic: Provide and use helper for send_IPI_allbutself()")
6a1cb5f5c641 ("x86/apic: Add static key to Control IPI shorthands")
bdda3b93e660 ("x86/apic: Move no_ipi_broadcast() out of 32bit")
9c92374b631d ("x86/cpu: Move arch_smt_update() to a neutral place")
c94f0718fb1c ("x86/apic: Consolidate the apic local headers")
ba77b2a02e00 ("x86/apic: Move apic_flat_64 header into apic directory")
8b542da37287 ("x86/apic: Move ipi header into apic directory")
521b82fee98c ("x86/apic: Cleanup the include maze")
cdc86c9d1f82 ("x86/apic: Move IPI inlines into ipi.c")
2591bc4e8d70 ("x86/kgbd: Use NMI_VECTOR not APIC_DM_NMI")
747d5a1bf293 ("x86/reboot: Always use NMI fallback when shutdown via reboot vector IPI fails")
7e300dabb7e7 ("treewide: Replace GPLv2 boilerplate/reference with SPDX - rule 223")
fa4bff165070 ("Merge branch 'x86-mds-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 26044aff37a5455b19a91785086914fd33053ef4 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 30 Nov 2022 23:36:47 +0000
Subject: [PATCH] x86/crash: Disable virt in core NMI crash handler to avoid
 double shootdown

Disable virtualization in crash_nmi_callback() and rework the
emergency_vmx_disable_all() path to do an NMI shootdown if and only if a
shootdown has not already occurred.   NMI crash shootdown fundamentally
can't support multiple invocations as responding CPUs are deliberately
put into halt state without unblocking NMIs.  But, the emergency reboot
path doesn't have any work of its own, it simply cares about disabling
virtualization, i.e. so long as a shootdown occurred, emergency reboot
doesn't care who initiated the shootdown, or when.

If "crash_kexec_post_notifiers" is specified on the kernel command line,
panic() will invoke crash_smp_send_stop() and result in a second call to
nmi_shootdown_cpus() during native_machine_emergency_restart().

Invoke the callback _before_ disabling virtualization, as the current
VMCS needs to be cleared before doing VMXOFF.  Note, this results in a
subtle change in ordering between disabling virtualization and stopping
Intel PT on the responding CPUs.  While VMX and Intel PT do interact,
VMXOFF and writes to MSR_IA32_RTIT_CTL do not induce faults between one
another, which is all that matters when panicking.

Harden nmi_shootdown_cpus() against multiple invocations to try and
capture any such kernel bugs via a WARN instead of hanging the system
during a crash/dump, e.g. prior to the recent hardening of
register_nmi_handler(), re-registering the NMI handler would trigger a
double list_add() and hang the system if CONFIG_BUG_ON_DATA_CORRUPTION=y.

 list_add double add: new=ffffffff82220800, prev=ffffffff8221cfe8, next=ffffffff82220800.
 WARNING: CPU: 2 PID: 1319 at lib/list_debug.c:29 __list_add_valid+0x67/0x70
 Call Trace:
  __register_nmi_handler+0xcf/0x130
  nmi_shootdown_cpus+0x39/0x90
  native_machine_emergency_restart+0x1c9/0x1d0
  panic+0x237/0x29b

Extract the disabling logic to a common helper to deduplicate code, and
to prepare for doing the shootdown in the emergency reboot path if SVM
is supported.

Note, prior to commit ed72736183c4 ("x86/reboot: Force all cpus to exit
VMX root if VMX is supported"), nmi_shootdown_cpus() was subtly protected
against a second invocation by a cpu_vmx_enabled() check as the kdump
handler would disable VMX if it ran first.

Fixes: ed72736183c4 ("x86/reboot: Force all cpus to exit VMX root if VMX is supported")
Cc: stable@vger.kernel.org
Reported-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/all/20220427224924.592546-2-gpiccoli@igalia.com
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20221130233650.1404148-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>

diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index 04c17be9b5fd..bc5b4d788c08 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -25,6 +25,8 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
+void cpu_emergency_disable_virtualization(void);
+
 typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
 void nmi_panic_self_stop(struct pt_regs *regs);
 void nmi_shootdown_cpus(nmi_shootdown_cb callback);
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 305514431f26..cdd92ab43cda 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -37,7 +37,6 @@
 #include <linux/kdebug.h>
 #include <asm/cpu.h>
 #include <asm/reboot.h>
-#include <asm/virtext.h>
 #include <asm/intel_pt.h>
 #include <asm/crash.h>
 #include <asm/cmdline.h>
@@ -81,15 +80,6 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
 	 */
 	cpu_crash_vmclear_loaded_vmcss();
 
-	/* Disable VMX or SVM if needed.
-	 *
-	 * We need to disable virtualization on all CPUs.
-	 * Having VMX or SVM enabled on any CPU may break rebooting
-	 * after the kdump kernel has finished its task.
-	 */
-	cpu_emergency_vmxoff();
-	cpu_emergency_svm_disable();
-
 	/*
 	 * Disable Intel PT to stop its logging
 	 */
@@ -148,12 +138,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	 */
 	cpu_crash_vmclear_loaded_vmcss();
 
-	/* Booting kdump kernel with VMX or SVM enabled won't work,
-	 * because (among other limitations) we can't disable paging
-	 * with the virt flags.
-	 */
-	cpu_emergency_vmxoff();
-	cpu_emergency_svm_disable();
+	cpu_emergency_disable_virtualization();
 
 	/*
 	 * Disable Intel PT to stop its logging
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index c3636ea4aa71..374c14b3a9bf 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -528,10 +528,7 @@ static inline void kb_wait(void)
 	}
 }
 
-static void vmxoff_nmi(int cpu, struct pt_regs *regs)
-{
-	cpu_emergency_vmxoff();
-}
+static inline void nmi_shootdown_cpus_on_restart(void);
 
 /* Use NMIs as IPIs to tell all CPUs to disable virtualization */
 static void emergency_vmx_disable_all(void)
@@ -554,7 +551,7 @@ static void emergency_vmx_disable_all(void)
 		__cpu_emergency_vmxoff();
 
 		/* Halt and exit VMX root operation on the other CPUs. */
-		nmi_shootdown_cpus(vmxoff_nmi);
+		nmi_shootdown_cpus_on_restart();
 	}
 }
 
@@ -795,6 +792,17 @@ void machine_crash_shutdown(struct pt_regs *regs)
 /* This is the CPU performing the emergency shutdown work. */
 int crashing_cpu = -1;
 
+/*
+ * Disable virtualization, i.e. VMX or SVM, to ensure INIT is recognized during
+ * reboot.  VMX blocks INIT if the CPU is post-VMXON, and SVM blocks INIT if
+ * GIF=0, i.e. if the crash occurred between CLGI and STGI.
+ */
+void cpu_emergency_disable_virtualization(void)
+{
+	cpu_emergency_vmxoff();
+	cpu_emergency_svm_disable();
+}
+
 #if defined(CONFIG_SMP)
 
 static nmi_shootdown_cb shootdown_callback;
@@ -817,7 +825,14 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 		return NMI_HANDLED;
 	local_irq_disable();
 
-	shootdown_callback(cpu, regs);
+	if (shootdown_callback)
+		shootdown_callback(cpu, regs);
+
+	/*
+	 * Prepare the CPU for reboot _after_ invoking the callback so that the
+	 * callback can safely use virtualization instructions, e.g. VMCLEAR.
+	 */
+	cpu_emergency_disable_virtualization();
 
 	atomic_dec(&waiting_for_crash_ipi);
 	/* Assume hlt works */
@@ -828,18 +843,32 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 	return NMI_HANDLED;
 }
 
-/*
- * Halt all other CPUs, calling the specified function on each of them
+/**
+ * nmi_shootdown_cpus - Stop other CPUs via NMI
+ * @callback:	Optional callback to be invoked from the NMI handler
+ *
+ * The NMI handler on the remote CPUs invokes @callback, if not
+ * NULL, first and then disables virtualization to ensure that
+ * INIT is recognized during reboot.
  *
- * This function can be used to halt all other CPUs on crash
- * or emergency reboot time. The function passed as parameter
- * will be called inside a NMI handler on all CPUs.
+ * nmi_shootdown_cpus() can only be invoked once. After the first
+ * invocation all other CPUs are stuck in crash_nmi_callback() and
+ * cannot respond to a second NMI.
  */
 void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 {
 	unsigned long msecs;
+
 	local_irq_disable();
 
+	/*
+	 * Avoid certain doom if a shootdown already occurred; re-registering
+	 * the NMI handler will cause list corruption, modifying the callback
+	 * will do who knows what, etc...
+	 */
+	if (WARN_ON_ONCE(crash_ipi_issued))
+		return;
+
 	/* Make a note of crashing cpu. Will be used in NMI callback. */
 	crashing_cpu = safe_smp_processor_id();
 
@@ -867,7 +896,17 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 		msecs--;
 	}
 
-	/* Leave the nmi callback set */
+	/*
+	 * Leave the nmi callback set, shootdown is a one-time thing.  Clearing
+	 * the callback could result in a NULL pointer dereference if a CPU
+	 * (finally) responds after the timeout expires.
+	 */
+}
+
+static inline void nmi_shootdown_cpus_on_restart(void)
+{
+	if (!crash_ipi_issued)
+		nmi_shootdown_cpus(NULL);
 }
 
 /*
@@ -897,6 +936,8 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 	/* No other CPUs to shoot down */
 }
 
+static inline void nmi_shootdown_cpus_on_restart(void) { }
+
 void run_crash_ipi_callback(struct pt_regs *regs)
 {
 }

