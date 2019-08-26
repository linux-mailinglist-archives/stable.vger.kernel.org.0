Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDDDE9CC0B
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 10:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730365AbfHZI7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 04:59:48 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:40403 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729802AbfHZI7r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 04:59:47 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 45E5335CD;
        Mon, 26 Aug 2019 04:59:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 26 Aug 2019 04:59:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7mE2b8
        T1rf+44AxBAjyFiQeNC0jH/AAc7aLd9gsixPI=; b=HQpCGZHj/aw3QgLTwsCIbV
        FGsTenNst9BXRavGf4ni0RNzGv0UoHV/MHwy8BYav8zcM5LchbGBG1voz9B39Z0K
        c++Za3nB2mvW4DNyLRiZM3iaIBTUHHXJjL/t6sqQFJFZ3JweytT9KSINg2k3lV7n
        RHK4zUteraywNLudfqffiTg/VVc56yTDclSep5FfdUpCqEbCvNkMaCNWSdTCTNXi
        d7Md5omaXjxbnT08KejYhVHfUkxWdIA7UTZ5FttNQttleRNbOjB6Y9OQMtuD+zAk
        QjxDp8l9BzR4QF0WL4fxUUwLkqUqikZKMC5nFE3iPItUTuGgWNzaukMVVkiidycg
        ==
X-ME-Sender: <xms:gp9jXR-VHY6mRG-7CzhqcaRoAarpCV-t4TihYsi6oeIxisDvRAc46w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehgedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeelrddvtdehrdduvd
    ekrddvgeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtgho
    mhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:gp9jXZ9NSxI-nY_cPIu81AseU65wd8EC1rYIjMIDgWvWMu-k43uH5Q>
    <xmx:gp9jXaDTC6SocpGAhNEBgtRvqWCgUqqDRVTDCFthNDwCq0I_ycjXGw>
    <xmx:gp9jXZzkqV_3CoxLcfbeP2FPJvsspDcNRQDpS4wruoN9VO7DOYNDGg>
    <xmx:gp9jXQKIS5UGvGq02YmNFwR1qCo463TefzEOvwLJdgXslrbtFljSrQ>
Received: from localhost (unknown [89.205.128.246])
        by mail.messagingengine.com (Postfix) with ESMTPA id 955A4D6005A;
        Mon, 26 Aug 2019 04:59:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family 15h/16h" failed to apply to 4.9-stable tree
To:     thomas.lendacky@amd.com, akpm@linux-foundation.org,
        andrew.cooper3@citrix.com, bp@suse.de, corbet@lwn.net,
        hpa@zytor.com, jgross@suse.com, jpoimboe@redhat.com,
        keescook@chromium.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, mingo@redhat.com,
        natechancellor@gmail.com, pavel@ucw.cz, pbonzini@redhat.com,
        rjw@rjwysocki.net, stable@vger.kernel.org, tglx@linutronix.de,
        x86@kernel.org, yu.c.chen@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Aug 2019 10:59:35 +0200
Message-ID: <1566809975147242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c49a0a80137c7ca7d6ced4c812c9e07a949f6f24 Mon Sep 17 00:00:00 2001
From: Tom Lendacky <thomas.lendacky@amd.com>
Date: Mon, 19 Aug 2019 15:52:35 +0000
Subject: [PATCH] x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family 15h/16h

There have been reports of RDRAND issues after resuming from suspend on
some AMD family 15h and family 16h systems. This issue stems from a BIOS
not performing the proper steps during resume to ensure RDRAND continues
to function properly.

RDRAND support is indicated by CPUID Fn00000001_ECX[30]. This bit can be
reset by clearing MSR C001_1004[62]. Any software that checks for RDRAND
support using CPUID, including the kernel, will believe that RDRAND is
not supported.

Update the CPU initialization to clear the RDRAND CPUID bit for any family
15h and 16h processor that supports RDRAND. If it is known that the family
15h or family 16h system does not have an RDRAND resume issue or that the
system will not be placed in suspend, the "rdrand=force" kernel parameter
can be used to stop the clearing of the RDRAND CPUID bit.

Additionally, update the suspend and resume path to save and restore the
MSR C001_1004 value to ensure that the RDRAND CPUID setting remains in
place after resuming from suspend.

Note, that clearing the RDRAND CPUID bit does not prevent a processor
that normally supports the RDRAND instruction from executing it. So any
code that determined the support based on family and model won't #UD.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chen Yu <yu.c.chen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: <stable@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "x86@kernel.org" <x86@kernel.org>
Link: https://lkml.kernel.org/r/7543af91666f491547bd86cebb1e17c66824ab9f.1566229943.git.thomas.lendacky@amd.com

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 47d981a86e2f..4c1971960afa 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4090,6 +4090,13 @@
 			Run specified binary instead of /init from the ramdisk,
 			used for early userspace startup. See initrd.
 
+	rdrand=		[X86]
+			force - Override the decision by the kernel to hide the
+				advertisement of RDRAND support (this affects
+				certain AMD processors because of buggy BIOS
+				support, specifically around the suspend/resume
+				path).
+
 	rdt=		[HW,X86,RDT]
 			Turn on/off individual RDT features. List is:
 			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 6b4fc2788078..271d837d69a8 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -381,6 +381,7 @@
 #define MSR_AMD64_PATCH_LEVEL		0x0000008b
 #define MSR_AMD64_TSC_RATIO		0xc0000104
 #define MSR_AMD64_NB_CFG		0xc001001f
+#define MSR_AMD64_CPUID_FN_1		0xc0011004
 #define MSR_AMD64_PATCH_LOADER		0xc0010020
 #define MSR_AMD64_OSVW_ID_LENGTH	0xc0010140
 #define MSR_AMD64_OSVW_STATUS		0xc0010141
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 8d4e50428b68..68c363c341bf 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -804,6 +804,64 @@ static void init_amd_ln(struct cpuinfo_x86 *c)
 	msr_set_bit(MSR_AMD64_DE_CFG, 31);
 }
 
+static bool rdrand_force;
+
+static int __init rdrand_cmdline(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	if (!strcmp(str, "force"))
+		rdrand_force = true;
+	else
+		return -EINVAL;
+
+	return 0;
+}
+early_param("rdrand", rdrand_cmdline);
+
+static void clear_rdrand_cpuid_bit(struct cpuinfo_x86 *c)
+{
+	/*
+	 * Saving of the MSR used to hide the RDRAND support during
+	 * suspend/resume is done by arch/x86/power/cpu.c, which is
+	 * dependent on CONFIG_PM_SLEEP.
+	 */
+	if (!IS_ENABLED(CONFIG_PM_SLEEP))
+		return;
+
+	/*
+	 * The nordrand option can clear X86_FEATURE_RDRAND, so check for
+	 * RDRAND support using the CPUID function directly.
+	 */
+	if (!(cpuid_ecx(1) & BIT(30)) || rdrand_force)
+		return;
+
+	msr_clear_bit(MSR_AMD64_CPUID_FN_1, 62);
+
+	/*
+	 * Verify that the CPUID change has occurred in case the kernel is
+	 * running virtualized and the hypervisor doesn't support the MSR.
+	 */
+	if (cpuid_ecx(1) & BIT(30)) {
+		pr_info_once("BIOS may not properly restore RDRAND after suspend, but hypervisor does not support hiding RDRAND via CPUID.\n");
+		return;
+	}
+
+	clear_cpu_cap(c, X86_FEATURE_RDRAND);
+	pr_info_once("BIOS may not properly restore RDRAND after suspend, hiding RDRAND via CPUID. Use rdrand=force to reenable.\n");
+}
+
+static void init_amd_jg(struct cpuinfo_x86 *c)
+{
+	/*
+	 * Some BIOS implementations do not restore proper RDRAND support
+	 * across suspend and resume. Check on whether to hide the RDRAND
+	 * instruction support via CPUID.
+	 */
+	clear_rdrand_cpuid_bit(c);
+}
+
 static void init_amd_bd(struct cpuinfo_x86 *c)
 {
 	u64 value;
@@ -818,6 +876,13 @@ static void init_amd_bd(struct cpuinfo_x86 *c)
 			wrmsrl_safe(MSR_F15H_IC_CFG, value);
 		}
 	}
+
+	/*
+	 * Some BIOS implementations do not restore proper RDRAND support
+	 * across suspend and resume. Check on whether to hide the RDRAND
+	 * instruction support via CPUID.
+	 */
+	clear_rdrand_cpuid_bit(c);
 }
 
 static void init_amd_zn(struct cpuinfo_x86 *c)
@@ -860,6 +925,7 @@ static void init_amd(struct cpuinfo_x86 *c)
 	case 0x10: init_amd_gh(c); break;
 	case 0x12: init_amd_ln(c); break;
 	case 0x15: init_amd_bd(c); break;
+	case 0x16: init_amd_jg(c); break;
 	case 0x17: init_amd_zn(c); break;
 	}
 
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 24b079e94bc2..c9ef6a7a4a1a 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -12,6 +12,7 @@
 #include <linux/smp.h>
 #include <linux/perf_event.h>
 #include <linux/tboot.h>
+#include <linux/dmi.h>
 
 #include <asm/pgtable.h>
 #include <asm/proto.h>
@@ -23,7 +24,7 @@
 #include <asm/debugreg.h>
 #include <asm/cpu.h>
 #include <asm/mmu_context.h>
-#include <linux/dmi.h>
+#include <asm/cpu_device_id.h>
 
 #ifdef CONFIG_X86_32
 __visible unsigned long saved_context_ebx;
@@ -397,15 +398,14 @@ static int __init bsp_pm_check_init(void)
 
 core_initcall(bsp_pm_check_init);
 
-static int msr_init_context(const u32 *msr_id, const int total_num)
+static int msr_build_context(const u32 *msr_id, const int num)
 {
-	int i = 0;
+	struct saved_msrs *saved_msrs = &saved_context.saved_msrs;
 	struct saved_msr *msr_array;
+	int total_num;
+	int i, j;
 
-	if (saved_context.saved_msrs.array || saved_context.saved_msrs.num > 0) {
-		pr_err("x86/pm: MSR quirk already applied, please check your DMI match table.\n");
-		return -EINVAL;
-	}
+	total_num = saved_msrs->num + num;
 
 	msr_array = kmalloc_array(total_num, sizeof(struct saved_msr), GFP_KERNEL);
 	if (!msr_array) {
@@ -413,19 +413,30 @@ static int msr_init_context(const u32 *msr_id, const int total_num)
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < total_num; i++) {
-		msr_array[i].info.msr_no	= msr_id[i];
+	if (saved_msrs->array) {
+		/*
+		 * Multiple callbacks can invoke this function, so copy any
+		 * MSR save requests from previous invocations.
+		 */
+		memcpy(msr_array, saved_msrs->array,
+		       sizeof(struct saved_msr) * saved_msrs->num);
+
+		kfree(saved_msrs->array);
+	}
+
+	for (i = saved_msrs->num, j = 0; i < total_num; i++, j++) {
+		msr_array[i].info.msr_no	= msr_id[j];
 		msr_array[i].valid		= false;
 		msr_array[i].info.reg.q		= 0;
 	}
-	saved_context.saved_msrs.num	= total_num;
-	saved_context.saved_msrs.array	= msr_array;
+	saved_msrs->num   = total_num;
+	saved_msrs->array = msr_array;
 
 	return 0;
 }
 
 /*
- * The following section is a quirk framework for problematic BIOSen:
+ * The following sections are a quirk framework for problematic BIOSen:
  * Sometimes MSRs are modified by the BIOSen after suspended to
  * RAM, this might cause unexpected behavior after wakeup.
  * Thus we save/restore these specified MSRs across suspend/resume
@@ -440,7 +451,7 @@ static int msr_initialize_bdw(const struct dmi_system_id *d)
 	u32 bdw_msr_id[] = { MSR_IA32_THERM_CONTROL };
 
 	pr_info("x86/pm: %s detected, MSR saving is needed during suspending.\n", d->ident);
-	return msr_init_context(bdw_msr_id, ARRAY_SIZE(bdw_msr_id));
+	return msr_build_context(bdw_msr_id, ARRAY_SIZE(bdw_msr_id));
 }
 
 static const struct dmi_system_id msr_save_dmi_table[] = {
@@ -455,9 +466,58 @@ static const struct dmi_system_id msr_save_dmi_table[] = {
 	{}
 };
 
+static int msr_save_cpuid_features(const struct x86_cpu_id *c)
+{
+	u32 cpuid_msr_id[] = {
+		MSR_AMD64_CPUID_FN_1,
+	};
+
+	pr_info("x86/pm: family %#hx cpu detected, MSR saving is needed during suspending.\n",
+		c->family);
+
+	return msr_build_context(cpuid_msr_id, ARRAY_SIZE(cpuid_msr_id));
+}
+
+static const struct x86_cpu_id msr_save_cpu_table[] = {
+	{
+		.vendor = X86_VENDOR_AMD,
+		.family = 0x15,
+		.model = X86_MODEL_ANY,
+		.feature = X86_FEATURE_ANY,
+		.driver_data = (kernel_ulong_t)msr_save_cpuid_features,
+	},
+	{
+		.vendor = X86_VENDOR_AMD,
+		.family = 0x16,
+		.model = X86_MODEL_ANY,
+		.feature = X86_FEATURE_ANY,
+		.driver_data = (kernel_ulong_t)msr_save_cpuid_features,
+	},
+	{}
+};
+
+typedef int (*pm_cpu_match_t)(const struct x86_cpu_id *);
+static int pm_cpu_check(const struct x86_cpu_id *c)
+{
+	const struct x86_cpu_id *m;
+	int ret = 0;
+
+	m = x86_match_cpu(msr_save_cpu_table);
+	if (m) {
+		pm_cpu_match_t fn;
+
+		fn = (pm_cpu_match_t)m->driver_data;
+		ret = fn(m);
+	}
+
+	return ret;
+}
+
 static int pm_check_save_msr(void)
 {
 	dmi_check_system(msr_save_dmi_table);
+	pm_cpu_check(msr_save_cpu_table);
+
 	return 0;
 }
 

