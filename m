Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5213462D69F
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239935AbiKQJXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:23:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239933AbiKQJW7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:22:59 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9EC6697F3
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:44 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-367f94b9b16so13862757b3.11
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PcwQW8WRnXIVgyeAnk+CfQlzD+bSI2L6ZxsXX1vyfjM=;
        b=ozlDUreH/uvYEcqh9NmARiO4zNZUMjZQxMzXjpgpk5K5RDr34jBSz5ygVuhLyD9ZpU
         uP3xkmDSPpQ9k63FuBsAvdmACPeb8tryup/DVLDEnIbPNxaw6m2fTe4QUh8b1Aa0iDZW
         u7VCXb7B+MP8Vf69aWpbyKuDYDlY3Q8Jl6jHTm5uvT55DD9R/IBVhdDTPkhL1ZuRbhzc
         DVzYJpUHuxsKZKB0LGEyUAa4UYUB5fVhZU8vyao8GcW4Xt+gvC96uVL+RaCuIWOcCdB8
         fwHYMlVs6OtyDop2VXzZIpPHKHLQU412apUveErK2trURQfAh/4LTXt9PEhXrbi7UtKn
         x8vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PcwQW8WRnXIVgyeAnk+CfQlzD+bSI2L6ZxsXX1vyfjM=;
        b=FF8/SICdINiJ1L+tadozjoSGGC2LqFsV64grwLzcv2Gcn6WV3zHs9t36Ox6VX2FpQS
         wxvHG5TWdSzqPWiuoRncxZH4sgoXEv+Qk87fbvhuTniU2yXCS9gJsmXMvcdF8I60NgJM
         R6vieY/e+ox30e72soOoBuxLZXe4Pu0JlLeDabc8WaaoOwUVOhR9jp3r8LzcC1EU8xbc
         bJA5EF9lyVB1bhu1kAfxGv92sJgFRxjiRHZjo82jrMKo3v/Q9I5qICfhjV8ZZC7nroVl
         4gZH8NYVBvy+u87JTKOdvvqxhNBQ88JdgDwyfqSh3o9Q+O7ALGtM94OQ/qpwN8+R9/az
         P+Rw==
X-Gm-Message-State: ANoB5pl/SXYFjlOEEm5pG0HuLwdkOUjmodq0MwbCcOAtmrzaPUh5uMQn
        GGSsjVngGQmiBOSBDLPQasuPIYTxKmgQH2zBLoaDskvbClh3VTBx3FD6NLnUJ3bJ6y3lB0PYpgP
        QCWtGvxpZLY/CVoq0QF2DDbARsempQluKNm+Kwi5CK2FQZRnF/LmVHMjAl2NWkzJiyMs=
X-Google-Smtp-Source: AA0mqf4sxIGeboHNaBg++13cvHvCWDpgDCzlEd2VKNemqTAwUQvHWhkomOKecpoxMsMp6FVg7DD/zQ278v6aOw==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a25:3c82:0:b0:6e7:39db:aeb5 with SMTP id
 j124-20020a253c82000000b006e739dbaeb5mr1078739yba.304.1668676964071; Thu, 17
 Nov 2022 01:22:44 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:52 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-35-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 34/34] x86/speculation: Add RSB VM Exit protections
From:   Suleiman Souhlal <suleiman@google.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        cascardo@canonical.com, surajjs@amazon.com, ssouhlal@FreeBSD.org,
        suleiman@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Sneddon <daniel.sneddon@linux.intel.com>

commit 2b1299322016731d56807aa49254a5ea3080b6b3 upstream.

tl;dr: The Enhanced IBRS mitigation for Spectre v2 does not work as
documented for RET instructions after VM exits. Mitigate it with a new
one-entry RSB stuffing mechanism and a new LFENCE.

== Background ==

Indirect Branch Restricted Speculation (IBRS) was designed to help
mitigate Branch Target Injection and Speculative Store Bypass, i.e.
Spectre, attacks. IBRS prevents software run in less privileged modes
from affecting branch prediction in more privileged modes. IBRS requires
the MSR to be written on every privilege level change.

To overcome some of the performance issues of IBRS, Enhanced IBRS was
introduced.  eIBRS is an "always on" IBRS, in other words, just turn
it on once instead of writing the MSR on every privilege level change.
When eIBRS is enabled, more privileged modes should be protected from
less privileged modes, including protecting VMMs from guests.

== Problem ==

Here's a simplification of how guests are run on Linux' KVM:

void run_kvm_guest(void)
{
	// Prepare to run guest
	VMRESUME();
	// Clean up after guest runs
}

The execution flow for that would look something like this to the
processor:

1. Host-side: call run_kvm_guest()
2. Host-side: VMRESUME
3. Guest runs, does "CALL guest_function"
4. VM exit, host runs again
5. Host might make some "cleanup" function calls
6. Host-side: RET from run_kvm_guest()

Now, when back on the host, there are a couple of possible scenarios of
post-guest activity the host needs to do before executing host code:

* on pre-eIBRS hardware (legacy IBRS, or nothing at all), the RSB is not
touched and Linux has to do a 32-entry stuffing.

* on eIBRS hardware, VM exit with IBRS enabled, or restoring the host
IBRS=1 shortly after VM exit, has a documented side effect of flushing
the RSB except in this PBRSB situation where the software needs to stuff
the last RSB entry "by hand".

IOW, with eIBRS supported, host RET instructions should no longer be
influenced by guest behavior after the host retires a single CALL
instruction.

However, if the RET instructions are "unbalanced" with CALLs after a VM
exit as is the RET in #6, it might speculatively use the address for the
instruction after the CALL in #3 as an RSB prediction. This is a problem
since the (untrusted) guest controls this address.

Balanced CALL/RET instruction pairs such as in step #5 are not affected.

== Solution ==

The PBRSB issue affects a wide variety of Intel processors which
support eIBRS. But not all of them need mitigation. Today,
X86_FEATURE_RSB_VMEXIT triggers an RSB filling sequence that mitigates
PBRSB. Systems setting RSB_VMEXIT need no further mitigation - i.e.,
eIBRS systems which enable legacy IBRS explicitly.

However, such systems (X86_FEATURE_IBRS_ENHANCED) do not set RSB_VMEXIT
and most of them need a new mitigation.

Therefore, introduce a new feature flag X86_FEATURE_RSB_VMEXIT_LITE
which triggers a lighter-weight PBRSB mitigation versus RSB_VMEXIT.

The lighter-weight mitigation performs a CALL instruction which is
immediately followed by a speculative execution barrier (INT3). This
steers speculative execution to the barrier -- just like a retpoline
-- which ensures that speculation can never reach an unbalanced RET.
Then, ensure this CALL is retired before continuing execution with an
LFENCE.

In other words, the window of exposure is opened at VM exit where RET
behavior is troublesome. While the window is open, force RSB predictions
sampling for RET targets to a dead end at the INT3. Close the window
with the LFENCE.

There is a subset of eIBRS systems which are not vulnerable to PBRSB.
Add these systems to the cpu_vuln_whitelist[] as NO_EIBRS_PBRSB.
Future systems that aren't vulnerable will set ARCH_CAP_PBRSB_NO.

  [ bp: Massage, incorporate review comments from Andy Cooper. ]

Signed-off-by: Daniel Sneddon <daniel.sneddon@linux.intel.com>
Co-developed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
[ bp: Adjust patch to account for kvm entry being in c ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 Documentation/admin-guide/hw-vuln/spectre.rst |  8 ++
 arch/x86/include/asm/cpufeatures.h            |  2 +
 arch/x86/include/asm/msr-index.h              |  4 +
 arch/x86/include/asm/nospec-branch.h          | 15 +++-
 arch/x86/kernel/cpu/bugs.c                    | 87 ++++++++++++++-----
 arch/x86/kernel/cpu/common.c                  | 12 ++-
 arch/x86/kvm/vmx.c                            |  4 +-
 tools/arch/x86/include/asm/cpufeatures.h      |  1 +
 8 files changed, 103 insertions(+), 30 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/spectre.rst b/Documentation/admin-guide/hw-vuln/spectre.rst
index 6bd97cd50d62..7e061ed449aa 100644
--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -422,6 +422,14 @@ The possible values in this file are:
   'RSB filling'   Protection of RSB on context switch enabled
   =============   ===========================================
 
+  - EIBRS Post-barrier Return Stack Buffer (PBRSB) protection status:
+
+  ===========================  =======================================================
+  'PBRSB-eIBRS: SW sequence'   CPU is affected and protection of RSB on VMEXIT enabled
+  'PBRSB-eIBRS: Vulnerable'    CPU is vulnerable
+  'PBRSB-eIBRS: Not affected'  CPU is not affected by PBRSB
+  ===========================  =======================================================
+
 Full mitigation might require a microcode update from the CPU
 vendor. When the necessary microcode is not available, the kernel will
 report vulnerability.
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 145eef3e5363..caaab0a20e26 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -291,6 +291,7 @@
 #define X86_FEATURE_RRSBA_CTRL		(11*32+11) /* "" RET prediction control */
 #define X86_FEATURE_RETPOLINE		(11*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
 #define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
+#define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
@@ -406,5 +407,6 @@
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
 #define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
 #define X86_BUG_RETBLEED		X86_BUG(27) /* CPU is affected by RETBleed */
+#define X86_BUG_EIBRS_PBRSB		X86_BUG(28) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index ec46d4af741c..dbe98e8ed164 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -130,6 +130,10 @@
 						 * are restricted to targets in
 						 * kernel.
 						 */
+#define ARCH_CAP_PBRSB_NO		BIT(24)	/*
+						 * Not susceptible to Post-Barrier
+						 * Return Stack Buffer Predictions.
+						 */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 0a34d5dd4364..64b086c47b4a 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -73,6 +73,13 @@
 	add	$(BITS_PER_LONG/8) * nr, sp;
 #endif
 
+#define ISSUE_UNBALANCED_RET_GUARD(sp)		\
+	call 992f;				\
+	int3;					\
+992:						\
+	add $(BITS_PER_LONG/8), sp;		\
+	lfence;
+
 #ifdef __ASSEMBLY__
 
 /*
@@ -278,9 +285,11 @@ static __always_inline void vmexit_fill_RSB(void)
 	unsigned long loops;
 
 	asm volatile (ANNOTATE_NOSPEC_ALTERNATIVE
-		      ALTERNATIVE("jmp 910f",
-				  __stringify(__FILL_RETURN_BUFFER(%0, RSB_CLEAR_LOOPS, %1)),
-				  X86_FEATURE_RSB_VMEXIT)
+		      ALTERNATIVE_2("jmp 910f", "", X86_FEATURE_RSB_VMEXIT,
+				    "jmp 911f", X86_FEATURE_RSB_VMEXIT_LITE)
+		      __stringify(__FILL_RETURN_BUFFER(%0, RSB_CLEAR_LOOPS, %1))
+		      "911:"
+		      __stringify(ISSUE_UNBALANCED_RET_GUARD(%1))
 		      "910:"
 		      : "=r" (loops), ASM_CALL_CONSTRAINT
 		      : : "memory" );
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 351551fdd198..6668f92f4321 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1198,6 +1198,54 @@ static void __init spec_ctrl_disable_kernel_rrsba(void)
 	}
 }
 
+static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_mitigation mode)
+{
+	/*
+	 * Similar to context switches, there are two types of RSB attacks
+	 * after VM exit:
+	 *
+	 * 1) RSB underflow
+	 *
+	 * 2) Poisoned RSB entry
+	 *
+	 * When retpoline is enabled, both are mitigated by filling/clearing
+	 * the RSB.
+	 *
+	 * When IBRS is enabled, while #1 would be mitigated by the IBRS branch
+	 * prediction isolation protections, RSB still needs to be cleared
+	 * because of #2.  Note that SMEP provides no protection here, unlike
+	 * user-space-poisoned RSB entries.
+	 *
+	 * eIBRS should protect against RSB poisoning, but if the EIBRS_PBRSB
+	 * bug is present then a LITE version of RSB protection is required,
+	 * just a single call needs to retire before a RET is executed.
+	 */
+	switch (mode) {
+	case SPECTRE_V2_NONE:
+		return;
+
+	case SPECTRE_V2_EIBRS_LFENCE:
+	case SPECTRE_V2_EIBRS:
+		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB) &&
+		    (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)) {
+			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
+			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
+		}
+		return;
+
+	case SPECTRE_V2_EIBRS_RETPOLINE:
+	case SPECTRE_V2_RETPOLINE:
+	case SPECTRE_V2_LFENCE:
+	case SPECTRE_V2_IBRS:
+		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
+		pr_info("Spectre v2 / SpectreRSB : Filling RSB on VMEXIT\n");
+		return;
+	}
+
+	pr_warn_once("Unknown Spectre v2 mode, disabling RSB mitigation at VM exit");
+	dump_stack();
+}
+
 static void __init spectre_v2_select_mitigation(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
@@ -1347,28 +1395,7 @@ static void __init spectre_v2_select_mitigation(void)
 	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
 
-	/*
-	 * Similar to context switches, there are two types of RSB attacks
-	 * after vmexit:
-	 *
-	 * 1) RSB underflow
-	 *
-	 * 2) Poisoned RSB entry
-	 *
-	 * When retpoline is enabled, both are mitigated by filling/clearing
-	 * the RSB.
-	 *
-	 * When IBRS is enabled, while #1 would be mitigated by the IBRS branch
-	 * prediction isolation protections, RSB still needs to be cleared
-	 * because of #2.  Note that SMEP provides no protection here, unlike
-	 * user-space-poisoned RSB entries.
-	 *
-	 * eIBRS, on the other hand, has RSB-poisoning protections, so it
-	 * doesn't need RSB clearing after vmexit.
-	 */
-	if (boot_cpu_has(X86_FEATURE_RETPOLINE) ||
-	    boot_cpu_has(X86_FEATURE_KERNEL_IBRS))
-		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
+	spectre_v2_determine_rsb_fill_type_at_vmexit(mode);
 
 	/*
 	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
@@ -2096,6 +2123,19 @@ static char *ibpb_state(void)
 	return "";
 }
 
+static char *pbrsb_eibrs_state(void)
+{
+	if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
+		if (boot_cpu_has(X86_FEATURE_RSB_VMEXIT_LITE) ||
+		    boot_cpu_has(X86_FEATURE_RSB_VMEXIT))
+			return ", PBRSB-eIBRS: SW sequence";
+		else
+			return ", PBRSB-eIBRS: Vulnerable";
+	} else {
+		return ", PBRSB-eIBRS: Not affected";
+	}
+}
+
 static ssize_t spectre_v2_show_state(char *buf)
 {
 	if (spectre_v2_enabled == SPECTRE_V2_LFENCE)
@@ -2108,12 +2148,13 @@ static ssize_t spectre_v2_show_state(char *buf)
 	    spectre_v2_enabled == SPECTRE_V2_EIBRS_LFENCE)
 		return sprintf(buf, "Vulnerable: eIBRS+LFENCE with unprivileged eBPF and SMT\n");
 
-	return sprintf(buf, "%s%s%s%s%s%s\n",
+	return sprintf(buf, "%s%s%s%s%s%s%s\n",
 		       spectre_v2_strings[spectre_v2_enabled],
 		       ibpb_state(),
 		       boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? ", IBRS_FW" : "",
 		       stibp_state(),
 		       boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? ", RSB filling" : "",
+		       pbrsb_eibrs_state(),
 		       spectre_v2_module_string());
 }
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index da3819a43418..55293e5dcbff 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -955,6 +955,7 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 #define NO_SWAPGS		BIT(6)
 #define NO_ITLB_MULTIHIT	BIT(7)
 #define NO_MMIO			BIT(8)
+#define NO_EIBRS_PBRSB		BIT(9)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -996,7 +997,7 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 
 	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB),
 
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -1006,7 +1007,9 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	 * good enough for our purposes.
 	 */
 
-	VULNWL_INTEL(ATOM_TREMONT_X,		NO_ITLB_MULTIHIT),
+	VULNWL_INTEL(ATOM_TREMONT,		NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_L,		NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_X,		NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
 
 	/* AMD Family 0xf - 0x12 */
 	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
@@ -1178,6 +1181,11 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 			setup_force_cpu_bug(X86_BUG_RETBLEED);
 	}
 
+	if (cpu_has(c, X86_FEATURE_IBRS_ENHANCED) &&
+	    !cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
+	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
+		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 30f0d55c8b2d..9bb696d7300c 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -11022,8 +11022,8 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 * entries and (in some cases) RSB underflow.
 	 *
 	 * eIBRS has its own protection against poisoned RSB, so it doesn't
-	 * need the RSB filling sequence.  But it does need to be enabled
-	 * before the first unbalanced RET.
+	 * need the RSB filling sequence.  But it does need to be enabled, and a
+	 * single call to retire, before the first unbalanced RET.
 	 *
 	 * So no RETs before vmx_spec_ctrl_restore_host() below.
 	 */
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index beab4d4e4a35..5882ff3e7094 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -271,6 +271,7 @@
 
 /* Intel-defined CPU QoS Sub-leaf, CPUID level 0x0000000F:0 (EDX), word 11 */
 #define X86_FEATURE_CQM_LLC		(11*32+ 1) /* LLC QoS if 1 */
+#define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM-Exit when EIBRS is enabled */
 
 /* Intel-defined CPU QoS Sub-leaf, CPUID level 0x0000000F:1 (EDX), word 12 */
 #define X86_FEATURE_CQM_OCCUP_LLC	(12*32+ 0) /* LLC occupancy monitoring */
-- 
2.38.1.431.g37b22c650d-goog

