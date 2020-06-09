Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51AE1F44A4
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 20:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733248AbgFISG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 14:06:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41690 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388200AbgFISGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 14:06:01 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-0001p6-On; Tue, 09 Jun 2020 19:05:54 +0100
Received: from ben by deadeye with local (Exim 4.94)
        (envelope-from <ben@decadent.org.uk>)
        id 1jiidG-006VxO-44; Tue, 09 Jun 2020 19:05:54 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        tony.luck@intel.com, bp@alien8.de,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jia Zhang" <qianyue.zj@alibaba-inc.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>
Date:   Tue, 09 Jun 2020 19:04:45 +0100
Message-ID: <lsq.1591725832.791938117@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 54/61] x86/cpu: Rename cpu_data.x86_mask to
 cpu_data.x86_stepping
In-Reply-To: <lsq.1591725831.850867383@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.85-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Zhang <qianyue.zj@alibaba-inc.com>

commit b399151cb48db30ad1e0e93dd40d68c6d007b637 upstream.

x86_mask is a confusing name which is hard to associate with the
processor's stepping.

Additionally, correct an indent issue in lib/cpu.c.

Signed-off-by: Jia Zhang <qianyue.zj@alibaba-inc.com>
[ Updated it to more recent kernels. ]
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: bp@alien8.de
Cc: tony.luck@intel.com
Link: http://lkml.kernel.org/r/1514771530-70829-1-git-send-email-qianyue.zj@alibaba-inc.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16:
 - Drop changes in arch/x86/lib/cpu.c
 - Adjust filenames, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/acpi.h                |  2 +-
 arch/x86/include/asm/processor.h           |  2 +-
 arch/x86/kernel/amd_nb.c                   |  2 +-
 arch/x86/kernel/asm-offsets_32.c           |  2 +-
 arch/x86/kernel/cpu/amd.c                  | 28 +++++++++++-----------
 arch/x86/kernel/cpu/centaur.c              |  4 ++--
 arch/x86/kernel/cpu/common.c               |  8 +++----
 arch/x86/kernel/cpu/cyrix.c                |  2 +-
 arch/x86/kernel/cpu/intel.c                | 18 +++++++-------
 arch/x86/kernel/cpu/microcode/intel.c      |  4 ++--
 arch/x86/kernel/cpu/mtrr/generic.c         |  2 +-
 arch/x86/kernel/cpu/mtrr/main.c            |  4 ++--
 arch/x86/kernel/cpu/perf_event_intel.c     |  2 +-
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |  2 +-
 arch/x86/kernel/cpu/perf_event_p6.c        |  2 +-
 arch/x86/kernel/cpu/proc.c                 |  4 ++--
 arch/x86/kernel/head_32.S                  |  4 ++--
 arch/x86/kernel/mpparse.c                  |  2 +-
 drivers/char/hw_random/via-rng.c           |  2 +-
 drivers/cpufreq/acpi-cpufreq.c             |  2 +-
 drivers/cpufreq/longhaul.c                 |  6 ++---
 drivers/cpufreq/p4-clockmod.c              |  2 +-
 drivers/cpufreq/powernow-k7.c              |  2 +-
 drivers/cpufreq/speedstep-centrino.c       |  4 ++--
 drivers/cpufreq/speedstep-lib.c            |  6 ++---
 drivers/crypto/padlock-aes.c               |  2 +-
 drivers/edac/amd64_edac.c                  |  2 +-
 drivers/edac/mce_amd.c                     |  2 +-
 drivers/hwmon/coretemp.c                   |  6 ++---
 drivers/hwmon/hwmon-vid.c                  |  2 +-
 drivers/hwmon/k10temp.c                    |  2 +-
 drivers/hwmon/k8temp.c                     |  2 +-
 drivers/video/fbdev/geode/video_gx.c       |  2 +-
 33 files changed, 69 insertions(+), 69 deletions(-)

--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -87,7 +87,7 @@ static inline unsigned int acpi_processo
 	if (boot_cpu_data.x86 == 0x0F &&
 	    boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
 	    boot_cpu_data.x86_model <= 0x05 &&
-	    boot_cpu_data.x86_mask < 0x0A)
+	    boot_cpu_data.x86_stepping < 0x0A)
 		return 1;
 	else if (amd_e400_c1e_detected)
 		return 1;
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -82,7 +82,7 @@ struct cpuinfo_x86 {
 	__u8			x86;		/* CPU family */
 	__u8			x86_vendor;	/* CPU vendor */
 	__u8			x86_model;
-	__u8			x86_mask;
+	__u8			x86_stepping;
 #ifdef CONFIG_X86_32
 	char			wp_works_ok;	/* It doesn't on 386's */
 
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -116,7 +116,7 @@ int amd_cache_northbridges(void)
 	if (boot_cpu_data.x86 == 0x10 &&
 	    boot_cpu_data.x86_model >= 0x8 &&
 	    (boot_cpu_data.x86_model > 0x9 ||
-	     boot_cpu_data.x86_mask >= 0x1))
+	     boot_cpu_data.x86_stepping >= 0x1))
 		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
 
 	if (boot_cpu_data.x86 == 0x15)
--- a/arch/x86/kernel/asm-offsets_32.c
+++ b/arch/x86/kernel/asm-offsets_32.c
@@ -27,7 +27,7 @@ void foo(void)
 	OFFSET(CPUINFO_x86, cpuinfo_x86, x86);
 	OFFSET(CPUINFO_x86_vendor, cpuinfo_x86, x86_vendor);
 	OFFSET(CPUINFO_x86_model, cpuinfo_x86, x86_model);
-	OFFSET(CPUINFO_x86_mask, cpuinfo_x86, x86_mask);
+	OFFSET(CPUINFO_x86_stepping, cpuinfo_x86, x86_stepping);
 	OFFSET(CPUINFO_cpuid_level, cpuinfo_x86, cpuid_level);
 	OFFSET(CPUINFO_x86_capability, cpuinfo_x86, x86_capability);
 	OFFSET(CPUINFO_x86_vendor_id, cpuinfo_x86, x86_vendor_id);
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -101,7 +101,7 @@ static void init_amd_k6(struct cpuinfo_x
 		return;
 	}
 
-	if (c->x86_model == 6 && c->x86_mask == 1) {
+	if (c->x86_model == 6 && c->x86_stepping == 1) {
 		const int K6_BUG_LOOP = 1000000;
 		int n;
 		void (*f_vide)(void);
@@ -131,7 +131,7 @@ static void init_amd_k6(struct cpuinfo_x
 
 	/* K6 with old style WHCR */
 	if (c->x86_model < 8 ||
-	   (c->x86_model == 8 && c->x86_mask < 8)) {
+	   (c->x86_model == 8 && c->x86_stepping < 8)) {
 		/* We can only write allocate on the low 508Mb */
 		if (mbytes > 508)
 			mbytes = 508;
@@ -150,7 +150,7 @@ static void init_amd_k6(struct cpuinfo_x
 		return;
 	}
 
-	if ((c->x86_model == 8 && c->x86_mask > 7) ||
+	if ((c->x86_model == 8 && c->x86_stepping > 7) ||
 	     c->x86_model == 9 || c->x86_model == 13) {
 		/* The more serious chips .. */
 
@@ -190,12 +190,12 @@ static void amd_k7_smp_check(struct cpui
 	 * but they are not certified as MP capable.
 	 */
 	/* Athlon 660/661 is valid. */
-	if ((c->x86_model == 6) && ((c->x86_mask == 0) ||
-	    (c->x86_mask == 1)))
+	if ((c->x86_model == 6) && ((c->x86_stepping == 0) ||
+	    (c->x86_stepping == 1)))
 		return;
 
 	/* Duron 670 is valid */
-	if ((c->x86_model == 7) && (c->x86_mask == 0))
+	if ((c->x86_model == 7) && (c->x86_stepping == 0))
 		return;
 
 	/*
@@ -205,8 +205,8 @@ static void amd_k7_smp_check(struct cpui
 	 * See http://www.heise.de/newsticker/data/jow-18.10.01-000 for
 	 * more.
 	 */
-	if (((c->x86_model == 6) && (c->x86_mask >= 2)) ||
-	    ((c->x86_model == 7) && (c->x86_mask >= 1)) ||
+	if (((c->x86_model == 6) && (c->x86_stepping >= 2)) ||
+	    ((c->x86_model == 7) && (c->x86_stepping >= 1)) ||
 	     (c->x86_model > 7))
 		if (cpu_has_mp)
 			return;
@@ -244,7 +244,7 @@ static void init_amd_k7(struct cpuinfo_x
 	 * are more robust with CLK_CTL set to 200xxxxx instead of 600xxxxx
 	 * As per AMD technical note 27212 0.2
 	 */
-	if ((c->x86_model == 8 && c->x86_mask >= 1) || (c->x86_model > 8)) {
+	if ((c->x86_model == 8 && c->x86_stepping >= 1) || (c->x86_model > 8)) {
 		rdmsr(MSR_K7_CLK_CTL, l, h);
 		if ((l & 0xfff00000) != 0x20000000) {
 			printk(KERN_INFO
@@ -514,7 +514,7 @@ static void early_init_amd(struct cpuinf
 	/*  Set MTRR capability flag if appropriate */
 	if (c->x86 == 5)
 		if (c->x86_model == 13 || c->x86_model == 9 ||
-		    (c->x86_model == 8 && c->x86_mask >= 8))
+		    (c->x86_model == 8 && c->x86_stepping >= 8))
 			set_cpu_cap(c, X86_FEATURE_K6_MTRR);
 #endif
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_PCI)
@@ -561,7 +561,7 @@ static void init_amd_zn(struct cpuinfo_x
 	 * Fix erratum 1076: CPB feature bit not being set in CPUID. It affects
 	 * all up to and including B1.
 	 */
-	if (c->x86_model <= 1 && c->x86_mask <= 1)
+	if (c->x86_model <= 1 && c->x86_stepping <= 1)
 		set_cpu_cap(c, X86_FEATURE_CPB);
 }
 
@@ -810,11 +810,11 @@ static unsigned int amd_size_cache(struc
 	/* AMD errata T13 (order #21922) */
 	if ((c->x86 == 6)) {
 		/* Duron Rev A0 */
-		if (c->x86_model == 3 && c->x86_mask == 0)
+		if (c->x86_model == 3 && c->x86_stepping == 0)
 			size = 64;
 		/* Tbird rev A1/A2 */
 		if (c->x86_model == 4 &&
-			(c->x86_mask == 0 || c->x86_mask == 1))
+			(c->x86_stepping == 0 || c->x86_stepping == 1))
 			size = 256;
 	}
 	return size;
@@ -951,7 +951,7 @@ static bool cpu_has_amd_erratum(struct c
 	}
 
 	/* OSVW unavailable or ID unknown, match family-model-stepping range */
-	ms = (cpu->x86_model << 4) | cpu->x86_mask;
+	ms = (cpu->x86_model << 4) | cpu->x86_stepping;
 	while ((range = *erratum++))
 		if ((cpu->x86 == AMD_MODEL_RANGE_FAMILY(range)) &&
 		    (ms >= AMD_MODEL_RANGE_START(range)) &&
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -134,7 +134,7 @@ static void init_centaur(struct cpuinfo_
 			clear_cpu_cap(c, X86_FEATURE_TSC);
 			break;
 		case 8:
-			switch (c->x86_mask) {
+			switch (c->x86_stepping) {
 			default:
 			name = "2";
 				break;
@@ -209,7 +209,7 @@ centaur_size_cache(struct cpuinfo_x86 *c
 	 *  - Note, it seems this may only be in engineering samples.
 	 */
 	if ((c->x86 == 6) && (c->x86_model == 9) &&
-				(c->x86_mask == 1) && (size == 65))
+				(c->x86_stepping == 1) && (size == 65))
 		size -= 1;
 	return size;
 }
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -659,7 +659,7 @@ void cpu_detect(struct cpuinfo_x86 *c)
 		cpuid(0x00000001, &tfms, &misc, &junk, &cap0);
 		c->x86 = (tfms >> 8) & 0xf;
 		c->x86_model = (tfms >> 4) & 0xf;
-		c->x86_mask = tfms & 0xf;
+		c->x86_stepping = tfms & 0xf;
 
 		if (c->x86 == 0xf)
 			c->x86 += (tfms >> 20) & 0xff;
@@ -1095,7 +1095,7 @@ static void identify_cpu(struct cpuinfo_
 	c->loops_per_jiffy = loops_per_jiffy;
 	c->x86_cache_size = 0;
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
-	c->x86_model = c->x86_mask = 0;	/* So far unknown... */
+	c->x86_model = c->x86_stepping = 0;	/* So far unknown... */
 	c->x86_vendor_id[0] = '\0'; /* Unset */
 	c->x86_model_id[0] = '\0';  /* Unset */
 	c->x86_max_cores = 1;
@@ -1356,8 +1356,8 @@ void print_cpu_info(struct cpuinfo_x86 *
 
 	printk(KERN_CONT " (fam: %02x, model: %02x", c->x86, c->x86_model);
 
-	if (c->x86_mask || c->cpuid_level >= 0)
-		printk(KERN_CONT ", stepping: %02x)\n", c->x86_mask);
+	if (c->x86_stepping || c->cpuid_level >= 0)
+		printk(KERN_CONT ", stepping: %02x)\n", c->x86_stepping);
 	else
 		printk(KERN_CONT ")\n");
 
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -212,7 +212,7 @@ static void init_cyrix(struct cpuinfo_x8
 
 	/* common case step number/rev -- exceptions handled below */
 	c->x86_model = (dir1 >> 4) + 1;
-	c->x86_mask = dir1 & 0xf;
+	c->x86_stepping = dir1 & 0xf;
 
 	/* Now cook; the original recipe is by Channing Corn, from Cyrix.
 	 * We do the same thing for each generation: we work out
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -81,7 +81,7 @@ static bool bad_spectre_microcode(struct
 
 	for (i = 0; i < ARRAY_SIZE(spectre_bad_microcodes); i++) {
 		if (c->x86_model == spectre_bad_microcodes[i].model &&
-		    c->x86_mask == spectre_bad_microcodes[i].stepping)
+		    c->x86_stepping == spectre_bad_microcodes[i].stepping)
 			return (c->microcode <= spectre_bad_microcodes[i].microcode);
 	}
 	return false;
@@ -131,7 +131,7 @@ static void early_init_intel(struct cpui
 	 * need the microcode to have already been loaded... so if it is
 	 * not, recommend a BIOS update and disable large pages.
 	 */
-	if (c->x86 == 6 && c->x86_model == 0x1c && c->x86_mask <= 2 &&
+	if (c->x86 == 6 && c->x86_model == 0x1c && c->x86_stepping <= 2 &&
 	    c->microcode < 0x20e) {
 		printk(KERN_WARNING "Atom PSE erratum detected, BIOS microcode update recommended\n");
 		clear_cpu_cap(c, X86_FEATURE_PSE);
@@ -147,7 +147,7 @@ static void early_init_intel(struct cpui
 
 	/* CPUID workaround for 0F33/0F34 CPU */
 	if (c->x86 == 0xF && c->x86_model == 0x3
-	    && (c->x86_mask == 0x3 || c->x86_mask == 0x4))
+	    && (c->x86_stepping == 0x3 || c->x86_stepping == 0x4))
 		c->x86_phys_bits = 36;
 
 	/*
@@ -246,7 +246,7 @@ int ppro_with_ram_bug(void)
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
 	    boot_cpu_data.x86 == 6 &&
 	    boot_cpu_data.x86_model == 1 &&
-	    boot_cpu_data.x86_mask < 8) {
+	    boot_cpu_data.x86_stepping < 8) {
 		printk(KERN_INFO "Pentium Pro with Errata#50 detected. Taking evasive action.\n");
 		return 1;
 	}
@@ -263,7 +263,7 @@ static void intel_smp_check(struct cpuin
 	 * Mask B, Pentium, but not Pentium MMX
 	 */
 	if (c->x86 == 5 &&
-	    c->x86_mask >= 1 && c->x86_mask <= 4 &&
+	    c->x86_stepping >= 1 && c->x86_stepping <= 4 &&
 	    c->x86_model <= 3) {
 		/*
 		 * Remember we have B step Pentia with bugs
@@ -305,7 +305,7 @@ static void intel_workarounds(struct cpu
 	 * SEP CPUID bug: Pentium Pro reports SEP but doesn't have it until
 	 * model 3 mask 3
 	 */
-	if ((c->x86<<8 | c->x86_model<<4 | c->x86_mask) < 0x633)
+	if ((c->x86<<8 | c->x86_model<<4 | c->x86_stepping) < 0x633)
 		clear_cpu_cap(c, X86_FEATURE_SEP);
 
 	/*
@@ -323,7 +323,7 @@ static void intel_workarounds(struct cpu
 	 * P4 Xeon errata 037 workaround.
 	 * Hardware prefetcher may cause stale data to be loaded into the cache.
 	 */
-	if ((c->x86 == 15) && (c->x86_model == 1) && (c->x86_mask == 1)) {
+	if ((c->x86 == 15) && (c->x86_model == 1) && (c->x86_stepping == 1)) {
 		if (msr_set_bit(MSR_IA32_MISC_ENABLE,
 				MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE_BIT)
 		    > 0) {
@@ -339,7 +339,7 @@ static void intel_workarounds(struct cpu
 	 * Specification Update").
 	 */
 	if (cpu_has_apic && (c->x86<<8 | c->x86_model<<4) == 0x520 &&
-	    (c->x86_mask < 0x6 || c->x86_mask == 0xb))
+	    (c->x86_stepping < 0x6 || c->x86_stepping == 0xb))
 		set_cpu_cap(c, X86_FEATURE_11AP);
 
 
@@ -523,7 +523,7 @@ static void init_intel(struct cpuinfo_x8
 		case 6:
 			if (l2 == 128)
 				p = "Celeron (Mendocino)";
-			else if (c->x86_mask == 0 || c->x86_mask == 5)
+			else if (c->x86_stepping == 0 || c->x86_stepping == 5)
 				p = "Celeron-A";
 			break;
 
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -291,7 +291,7 @@ static bool is_blacklisted(unsigned int
 	 */
 	if (c->x86 == 6 &&
 	    c->x86_model == 0x4F &&
-	    c->x86_mask == 0x01 &&
+	    c->x86_stepping == 0x01 &&
 	    llc_size_per_core > 2621440 &&
 	    c->microcode < 0x0b000021) {
 		pr_err_once("Erratum BDF90: late loading with revision < 0x0b000021 (0x%x) disabled.\n", c->microcode);
@@ -314,7 +314,7 @@ static enum ucode_state request_microcod
 		return UCODE_NFOUND;
 
 	sprintf(name, "intel-ucode/%02x-%02x-%02x",
-		c->x86, c->x86_model, c->x86_mask);
+		c->x86, c->x86_model, c->x86_stepping);
 
 	if (request_firmware_direct(&firmware, name, device)) {
 		pr_debug("data file %s load failed\n", name);
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -791,7 +791,7 @@ int generic_validate_add_page(unsigned l
 	 */
 	if (is_cpu(INTEL) && boot_cpu_data.x86 == 6 &&
 	    boot_cpu_data.x86_model == 1 &&
-	    boot_cpu_data.x86_mask <= 7) {
+	    boot_cpu_data.x86_stepping <= 7) {
 		if (base & ((1 << (22 - PAGE_SHIFT)) - 1)) {
 			pr_warning("mtrr: base(0x%lx000) is not 4 MiB aligned\n", base);
 			return -EINVAL;
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -688,8 +688,8 @@ void __init mtrr_bp_init(void)
 			if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
 			    boot_cpu_data.x86 == 0xF &&
 			    boot_cpu_data.x86_model == 0x3 &&
-			    (boot_cpu_data.x86_mask == 0x3 ||
-			     boot_cpu_data.x86_mask == 0x4))
+			    (boot_cpu_data.x86_stepping == 0x3 ||
+			     boot_cpu_data.x86_stepping == 0x4))
 				phys_addr = 36;
 
 			size_or_mask = SIZE_OR_MASK_BITS(phys_addr);
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2192,7 +2192,7 @@ static int intel_snb_pebs_broken(int cpu
 		break;
 
 	case 45: /* SNB-EP */
-		switch (cpu_data(cpu).x86_mask) {
+		switch (cpu_data(cpu).x86_stepping) {
 		case 6: rev = 0x618; break;
 		case 7: rev = 0x70c; break;
 		}
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -763,7 +763,7 @@ void intel_pmu_lbr_init_atom(void)
 	 * on PMU interrupt
 	 */
 	if (boot_cpu_data.x86_model == 28
-	    && boot_cpu_data.x86_mask < 10) {
+	    && boot_cpu_data.x86_stepping < 10) {
 		pr_cont("LBR disabled due to erratum");
 		return;
 	}
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -233,7 +233,7 @@ static __initconst const struct x86_pmu
 
 static __init void p6_pmu_rdpmc_quirk(void)
 {
-	if (boot_cpu_data.x86_mask < 9) {
+	if (boot_cpu_data.x86_stepping < 9) {
 		/*
 		 * PPro erratum 26; fixed in stepping 9 and above.
 		 */
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -69,8 +69,8 @@ static int show_cpuinfo(struct seq_file
 		   c->x86_model,
 		   c->x86_model_id[0] ? c->x86_model_id : "unknown");
 
-	if (c->x86_mask || c->cpuid_level >= 0)
-		seq_printf(m, "stepping\t: %d\n", c->x86_mask);
+	if (c->x86_stepping || c->cpuid_level >= 0)
+		seq_printf(m, "stepping\t: %d\n", c->x86_stepping);
 	else
 		seq_printf(m, "stepping\t: unknown\n");
 	if (c->microcode)
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -33,7 +33,7 @@
 #define X86		new_cpu_data+CPUINFO_x86
 #define X86_VENDOR	new_cpu_data+CPUINFO_x86_vendor
 #define X86_MODEL	new_cpu_data+CPUINFO_x86_model
-#define X86_MASK	new_cpu_data+CPUINFO_x86_mask
+#define X86_STEPPING	new_cpu_data+CPUINFO_x86_stepping
 #define X86_HARD_MATH	new_cpu_data+CPUINFO_hard_math
 #define X86_CPUID	new_cpu_data+CPUINFO_cpuid_level
 #define X86_CAPABILITY	new_cpu_data+CPUINFO_x86_capability
@@ -433,7 +433,7 @@ enable_paging:
 	shrb $4,%al
 	movb %al,X86_MODEL
 	andb $0x0f,%cl		# mask mask revision
-	movb %cl,X86_MASK
+	movb %cl,X86_STEPPING
 	movl %edx,X86_CAPABILITY
 
 is486:
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -409,7 +409,7 @@ static inline void __init construct_defa
 	processor.apicver = mpc_default_type > 4 ? 0x10 : 0x01;
 	processor.cpuflag = CPU_ENABLED;
 	processor.cpufeature = (boot_cpu_data.x86 << 8) |
-	    (boot_cpu_data.x86_model << 4) | boot_cpu_data.x86_mask;
+	    (boot_cpu_data.x86_model << 4) | boot_cpu_data.x86_stepping;
 	processor.featureflag = boot_cpu_data.x86_capability[0];
 	processor.reserved[0] = 0;
 	processor.reserved[1] = 0;
--- a/drivers/char/hw_random/via-rng.c
+++ b/drivers/char/hw_random/via-rng.c
@@ -166,7 +166,7 @@ static int via_rng_init(struct hwrng *rn
 	/* Enable secondary noise source on CPUs where it is present. */
 
 	/* Nehemiah stepping 8 and higher */
-	if ((c->x86_model == 9) && (c->x86_mask > 7))
+	if ((c->x86_model == 9) && (c->x86_stepping > 7))
 		lo |= VIA_NOISESRC2;
 
 	/* Esther */
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -628,7 +628,7 @@ static int acpi_cpufreq_blacklist(struct
 	if (c->x86_vendor == X86_VENDOR_INTEL) {
 		if ((c->x86 == 15) &&
 		    (c->x86_model == 6) &&
-		    (c->x86_mask == 8)) {
+		    (c->x86_stepping == 8)) {
 			printk(KERN_INFO "acpi-cpufreq: Intel(R) "
 			    "Xeon(R) 7100 Errata AL30, processors may "
 			    "lock up on frequency changes: disabling "
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -786,7 +786,7 @@ static int longhaul_cpu_init(struct cpuf
 		break;
 
 	case 7:
-		switch (c->x86_mask) {
+		switch (c->x86_stepping) {
 		case 0:
 			longhaul_version = TYPE_LONGHAUL_V1;
 			cpu_model = CPU_SAMUEL2;
@@ -798,7 +798,7 @@ static int longhaul_cpu_init(struct cpuf
 			break;
 		case 1 ... 15:
 			longhaul_version = TYPE_LONGHAUL_V2;
-			if (c->x86_mask < 8) {
+			if (c->x86_stepping < 8) {
 				cpu_model = CPU_SAMUEL2;
 				cpuname = "C3 'Samuel 2' [C5B]";
 			} else {
@@ -825,7 +825,7 @@ static int longhaul_cpu_init(struct cpuf
 		numscales = 32;
 		memcpy(mults, nehemiah_mults, sizeof(nehemiah_mults));
 		memcpy(eblcr, nehemiah_eblcr, sizeof(nehemiah_eblcr));
-		switch (c->x86_mask) {
+		switch (c->x86_stepping) {
 		case 0 ... 1:
 			cpu_model = CPU_NEHEMIAH;
 			cpuname = "C3 'Nehemiah A' [C5XLOE]";
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -176,7 +176,7 @@ static int cpufreq_p4_cpu_init(struct cp
 #endif
 
 	/* Errata workaround */
-	cpuid = (c->x86 << 8) | (c->x86_model << 4) | c->x86_mask;
+	cpuid = (c->x86 << 8) | (c->x86_model << 4) | c->x86_stepping;
 	switch (cpuid) {
 	case 0x0f07:
 	case 0x0f0a:
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -133,7 +133,7 @@ static int check_powernow(void)
 		return 0;
 	}
 
-	if ((c->x86_model == 6) && (c->x86_mask == 0)) {
+	if ((c->x86_model == 6) && (c->x86_stepping == 0)) {
 		printk(KERN_INFO PFX "K7 660[A0] core detected, "
 				"enabling errata workarounds\n");
 		have_a0 = 1;
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -36,7 +36,7 @@ struct cpu_id
 {
 	__u8	x86;            /* CPU family */
 	__u8	x86_model;	/* model */
-	__u8	x86_mask;	/* stepping */
+	__u8	x86_stepping;	/* stepping */
 };
 
 enum {
@@ -276,7 +276,7 @@ static int centrino_verify_cpu_id(const
 {
 	if ((c->x86 == x->x86) &&
 	    (c->x86_model == x->x86_model) &&
-	    (c->x86_mask == x->x86_mask))
+	    (c->x86_stepping == x->x86_stepping))
 		return 1;
 	return 0;
 }
--- a/drivers/cpufreq/speedstep-lib.c
+++ b/drivers/cpufreq/speedstep-lib.c
@@ -270,9 +270,9 @@ unsigned int speedstep_detect_processor(
 		ebx = cpuid_ebx(0x00000001);
 		ebx &= 0x000000FF;
 
-		pr_debug("ebx value is %x, x86_mask is %x\n", ebx, c->x86_mask);
+		pr_debug("ebx value is %x, x86_stepping is %x\n", ebx, c->x86_stepping);
 
-		switch (c->x86_mask) {
+		switch (c->x86_stepping) {
 		case 4:
 			/*
 			 * B-stepping [M-P4-M]
@@ -359,7 +359,7 @@ unsigned int speedstep_detect_processor(
 				msr_lo, msr_hi);
 		if ((msr_hi & (1<<18)) &&
 		    (relaxed_check ? 1 : (msr_hi & (3<<24)))) {
-			if (c->x86_mask == 0x01) {
+			if (c->x86_stepping == 0x01) {
 				pr_debug("early PIII version\n");
 				return SPEEDSTEP_CPU_PIII_C_EARLY;
 			} else
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -535,7 +535,7 @@ static int __init padlock_init(void)
 
 	printk(KERN_NOTICE PFX "Using VIA PadLock ACE for AES algorithm.\n");
 
-	if (c->x86 == 6 && c->x86_model == 15 && c->x86_mask == 2) {
+	if (c->x86 == 6 && c->x86_model == 15 && c->x86_stepping == 2) {
 		ecb_fetch_blocks = MAX_ECB_FETCH_BLOCKS;
 		cbc_fetch_blocks = MAX_CBC_FETCH_BLOCKS;
 		printk(KERN_NOTICE PFX "VIA Nano stepping 2 detected: enabling workaround.\n");
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2576,7 +2576,7 @@ static struct amd64_family_type *per_fam
 	struct amd64_family_type *fam_type = NULL;
 
 	pvt->ext_model  = boot_cpu_data.x86_model >> 4;
-	pvt->stepping	= boot_cpu_data.x86_mask;
+	pvt->stepping	= boot_cpu_data.x86_stepping;
 	pvt->model	= boot_cpu_data.x86_model;
 	pvt->fam	= boot_cpu_data.x86;
 
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -744,7 +744,7 @@ int amd_decode_mce(struct notifier_block
 
 	pr_emerg(HW_ERR "CPU:%d (%x:%x:%x) MC%d_STATUS[%s|%s|%s|%s|%s",
 		m->extcpu,
-		c->x86, c->x86_model, c->x86_mask,
+		c->x86, c->x86_model, c->x86_stepping,
 		m->bank,
 		((m->status & MCI_STATUS_OVER)	? "Over"  : "-"),
 		((m->status & MCI_STATUS_UC)	? "UE"	  : "CE"),
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -268,13 +268,13 @@ static int adjust_tjmax(struct cpuinfo_x
 	for (i = 0; i < ARRAY_SIZE(tjmax_model_table); i++) {
 		const struct tjmax_model *tm = &tjmax_model_table[i];
 		if (c->x86_model == tm->model &&
-		    (tm->mask == ANY || c->x86_mask == tm->mask))
+		    (tm->mask == ANY || c->x86_stepping == tm->mask))
 			return tm->tjmax;
 	}
 
 	/* Early chips have no MSR for TjMax */
 
-	if (c->x86_model == 0xf && c->x86_mask < 4)
+	if (c->x86_model == 0xf && c->x86_stepping < 4)
 		usemsr_ee = 0;
 
 	if (c->x86_model > 0xe && usemsr_ee) {
@@ -426,7 +426,7 @@ static int chk_ucode_version(unsigned in
 	 * Readings might stop update when processor visited too deep sleep,
 	 * fixed for stepping D0 (6EC).
 	 */
-	if (c->x86_model == 0xe && c->x86_mask < 0xc && c->microcode < 0x39) {
+	if (c->x86_model == 0xe && c->x86_stepping < 0xc && c->microcode < 0x39) {
 		pr_err("Errata AE18 not fixed, update BIOS or microcode of the CPU!\n");
 		return -ENODEV;
 	}
--- a/drivers/hwmon/hwmon-vid.c
+++ b/drivers/hwmon/hwmon-vid.c
@@ -293,7 +293,7 @@ u8 vid_which_vrm(void)
 	if (c->x86 < 6)		/* Any CPU with family lower than 6 */
 		return 0;	/* doesn't have VID */
 
-	vrm_ret = find_vrm(c->x86, c->x86_model, c->x86_mask, c->x86_vendor);
+	vrm_ret = find_vrm(c->x86, c->x86_model, c->x86_stepping, c->x86_vendor);
 	if (vrm_ret == 134)
 		vrm_ret = get_via_model_d_vrm();
 	if (vrm_ret == 0)
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -126,7 +126,7 @@ static bool has_erratum_319(struct pci_d
 	 * and AM3 formats, but that's the best we can do.
 	 */
 	return boot_cpu_data.x86_model < 4 ||
-	       (boot_cpu_data.x86_model == 4 && boot_cpu_data.x86_mask <= 2);
+	       (boot_cpu_data.x86_model == 4 && boot_cpu_data.x86_stepping <= 2);
 }
 
 static int k10temp_probe(struct pci_dev *pdev,
--- a/drivers/hwmon/k8temp.c
+++ b/drivers/hwmon/k8temp.c
@@ -187,7 +187,7 @@ static int k8temp_probe(struct pci_dev *
 		return -ENOMEM;
 
 	model = boot_cpu_data.x86_model;
-	stepping = boot_cpu_data.x86_mask;
+	stepping = boot_cpu_data.x86_stepping;
 
 	/* feature available since SH-C0, exclude older revisions */
 	if ((model == 4 && stepping == 0) ||
--- a/drivers/video/fbdev/geode/video_gx.c
+++ b/drivers/video/fbdev/geode/video_gx.c
@@ -127,7 +127,7 @@ void gx_set_dclk_frequency(struct fb_inf
 	int timeout = 1000;
 
 	/* Rev. 1 Geode GXs use a 14 MHz reference clock instead of 48 MHz. */
-	if (cpu_data(0).x86_mask == 1) {
+	if (cpu_data(0).x86_stepping == 1) {
 		pll_table = gx_pll_table_14MHz;
 		pll_table_len = ARRAY_SIZE(gx_pll_table_14MHz);
 	} else {

