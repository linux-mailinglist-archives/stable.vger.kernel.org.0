Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A63162D658
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239261AbiKQJUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239815AbiKQJUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:20:04 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66F5AF0B1
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:20:02 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id z19-20020a056a001d9300b0056df4b6f421so879719pfw.4
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:20:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xtcC7YJ9QTeiTg7PsVYnoBE27ycwT48LVwvFoBMtroc=;
        b=e5dvOTsy+VPayLLwqBE0t0B9EuCadzx+doEfqRdQQev4pBSBpuSsLP6ybnU+t2yTze
         VWZxYdfP2NaN9oJVpdT5/JzI4vK6B6LWX0yAHT18doBscNiHR6Ou0cm2lfBLsAVPyKUx
         nzdbnsEoTEGtuzeUCPu2iiK7IRtxohl7u+sPHspb4KDef7Vsxgk+kdxFit/8DTFZQZQc
         c2+McwaaHcBsmW3+gF/EWpIm2AUzUvKR9VkDQG16axE0BJi5hYIwKUcrSgulklDXsVQB
         Nm/4PdQ0qhEVgekdIRa5rznLTivZcvVtm3JNs6E67P2EeNQ2KU3rlZXNInqs3NhIzbx2
         Ndyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xtcC7YJ9QTeiTg7PsVYnoBE27ycwT48LVwvFoBMtroc=;
        b=yC/rJN2/5ucXnjxg7BLjFkowkKEpjqv75lW8hM9Y7HaexmHiEe60RtF5fhE7JzGNdv
         fmm6fIZ1aPrfFuAbgU8Uchk0tBuVW6OhFZRdbzCPHhFWsV4Ea1tAIGa/SGg+CnPORO2U
         peXEJp/0qS0NOuU8uPX6cTdmlI6/d/VVvxjeJH9y9UkbOa15sWRcMMqTpEyiDPJJlq1U
         okwFey9Di0gkX0H7Sc+b+BTFzFcW+bWn/XoWsaR622Ao+J5YnFpMNQrFf9k5IoOyr8hr
         ma+liiArzBg7Sj9flFRvFKmqpKRKlMmK7sIrnIWS1g0lmzhlaVP8Iydde040enYdnArr
         gL7A==
X-Gm-Message-State: ANoB5pnRvu3mdMKugKbOxqAqbThvpzilViWSCC9GkMuIlRwB9ggPwYfG
        PvaYumeWHNguYRYWXefN+pv7f6TKVtidGp0NhTNaw2tQ6B7IsK87+zFY6pQQyhwD3EXD6Qfq1TS
        qex8AXHkDXmJcLoxC1xY2Y2RJre8kQWW15KM8RsWyLgzxJJ2Zar9+qu51cSCIid9NO4k=
X-Google-Smtp-Source: AA0mqf6tJ7BFTIKbyIp8x7dGQsR9mYFiTSCo29idRkwOnRypWFYST/vv5H6Y/vG2hggDgO4xYzc8C7/E6B6EWQ==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a05:6a00:1409:b0:56b:e1d8:e7a1 with SMTP
 id l9-20020a056a00140900b0056be1d8e7a1mr2138084pfu.28.1668676801988; Thu, 17
 Nov 2022 01:20:01 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:19 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-2-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 01/34] Revert "x86/speculation: Add RSB VM Exit protections"
From:   Suleiman Souhlal <suleiman@google.com>
To:     stable@vger.kernel.org
Cc:     x86@kernel.org, kvm@vger.kernel.org, bp@alien8.de,
        pbonzini@redhat.com, peterz@infradead.org, jpoimboe@kernel.org,
        cascardo@canonical.com, surajjs@amazon.com, ssouhlal@FreeBSD.org,
        suleiman@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit b6c5011934a15762cd694e36fe74f2f2f93eac9b.

In order to apply IBRS mitigation for Retbleed, PBRSB mitigations must be
reverted and the reapplied, so the backports can look sane.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 Documentation/admin-guide/hw-vuln/spectre.rst |  8 ---
 arch/x86/include/asm/cpufeatures.h            |  2 -
 arch/x86/include/asm/msr-index.h              |  4 --
 arch/x86/include/asm/nospec-branch.h          | 15 -----
 arch/x86/kernel/cpu/bugs.c                    | 61 +------------------
 arch/x86/kernel/cpu/common.c                  | 14 +----
 arch/x86/kvm/vmx.c                            |  6 +-
 7 files changed, 7 insertions(+), 103 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/spectre.rst b/Documentation/admin-guide/hw-vuln/spectre.rst
index 7e061ed449aa..6bd97cd50d62 100644
--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -422,14 +422,6 @@ The possible values in this file are:
   'RSB filling'   Protection of RSB on context switch enabled
   =============   ===========================================
 
-  - EIBRS Post-barrier Return Stack Buffer (PBRSB) protection status:
-
-  ===========================  =======================================================
-  'PBRSB-eIBRS: SW sequence'   CPU is affected and protection of RSB on VMEXIT enabled
-  'PBRSB-eIBRS: Vulnerable'    CPU is vulnerable
-  'PBRSB-eIBRS: Not affected'  CPU is not affected by PBRSB
-  ===========================  =======================================================
-
 Full mitigation might require a microcode update from the CPU
 vendor. When the necessary microcode is not available, the kernel will
 report vulnerability.
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index e9b79bac9b2a..3a270a2da5b4 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -283,7 +283,6 @@
 #define X86_FEATURE_CQM_MBM_LOCAL	(11*32+ 3) /* LLC Local MBM monitoring */
 #define X86_FEATURE_FENCE_SWAPGS_USER	(11*32+ 4) /* "" LFENCE in user entry SWAPGS path */
 #define X86_FEATURE_FENCE_SWAPGS_KERNEL	(11*32+ 5) /* "" LFENCE in kernel entry SWAPGS path */
-#define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+ 6) /* "" Fill RSB on VM exit when EIBRS is enabled */
 
 /* AMD-defined CPU features, CPUID level 0x80000008 (EBX), word 13 */
 #define X86_FEATURE_CLZERO		(13*32+ 0) /* CLZERO instruction */
@@ -397,6 +396,5 @@
 #define X86_BUG_SRBDS			X86_BUG(24) /* CPU may leak RNG bits if not mitigated */
 #define X86_BUG_MMIO_STALE_DATA		X86_BUG(25) /* CPU is affected by Processor MMIO Stale Data vulnerabilities */
 #define X86_BUG_MMIO_UNKNOWN		X86_BUG(26) /* CPU is too old and its MMIO Stale Data status is unknown */
-#define X86_BUG_EIBRS_PBRSB		X86_BUG(27) /* EIBRS is vulnerable to Post Barrier RSB Predictions */
 
 #endif /* _ASM_X86_CPUFEATURES_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 7a73799537bf..586be095ed08 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -120,10 +120,6 @@
 						 * bit available to control VERW
 						 * behavior.
 						 */
-#define ARCH_CAP_PBRSB_NO		BIT(24)	/*
-						 * Not susceptible to Post-Barrier
-						 * Return Stack Buffer Predictions.
-						 */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 17a236a8b237..b2e34c74c138 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -70,14 +70,6 @@
 	add	$(BITS_PER_LONG/8) * nr, sp;
 #endif
 
-/* Sequence to mitigate PBRSB on eIBRS CPUs */
-#define __ISSUE_UNBALANCED_RET_GUARD(sp)	\
-	call	881f;				\
-	int3;					\
-881:						\
-	add	$(BITS_PER_LONG/8), sp;		\
-	lfence;
-
 #ifdef __ASSEMBLY__
 
 /*
@@ -293,13 +285,6 @@ static inline void vmexit_fill_RSB(void)
 		      : "=r" (loops), ASM_CALL_CONSTRAINT
 		      : : "memory" );
 #endif
-	asm volatile (ANNOTATE_NOSPEC_ALTERNATIVE
-		      ALTERNATIVE("jmp 920f",
-				  __stringify(__ISSUE_UNBALANCED_RET_GUARD(%0)),
-				  X86_FEATURE_RSB_VMEXIT_LITE)
-		      "920:"
-		      : ASM_CALL_CONSTRAINT
-		      : : "memory" );
 }
 
 static __always_inline
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 501d09d59abc..fc65fe5b28c2 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1046,49 +1046,6 @@ static enum spectre_v2_mitigation __init spectre_v2_select_retpoline(void)
 	return SPECTRE_V2_RETPOLINE;
 }
 
-static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_mitigation mode)
-{
-	/*
-	 * Similar to context switches, there are two types of RSB attacks
-	 * after VM exit:
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
-	 * eIBRS should protect against RSB poisoning, but if the EIBRS_PBRSB
-	 * bug is present then a LITE version of RSB protection is required,
-	 * just a single call needs to retire before a RET is executed.
-	 */
-	switch (mode) {
-	case SPECTRE_V2_NONE:
-	/* These modes already fill RSB at vmexit */
-	case SPECTRE_V2_LFENCE:
-	case SPECTRE_V2_RETPOLINE:
-	case SPECTRE_V2_EIBRS_RETPOLINE:
-		return;
-
-	case SPECTRE_V2_EIBRS_LFENCE:
-	case SPECTRE_V2_EIBRS:
-		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
-			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
-			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
-		}
-		return;
-	}
-
-	pr_warn_once("Unknown Spectre v2 mode, disabling RSB mitigation at VM exit");
-	dump_stack();
-}
-
 static void __init spectre_v2_select_mitigation(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
@@ -1181,8 +1138,6 @@ static void __init spectre_v2_select_mitigation(void)
 	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
 
-	spectre_v2_determine_rsb_fill_type_at_vmexit(mode);
-
 	/*
 	 * Retpoline means the kernel is safe because it has no indirect
 	 * branches. Enhanced IBRS protects firmware too, so, enable restricted
@@ -1918,19 +1873,6 @@ static char *ibpb_state(void)
 	return "";
 }
 
-static char *pbrsb_eibrs_state(void)
-{
-	if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
-		if (boot_cpu_has(X86_FEATURE_RSB_VMEXIT_LITE) ||
-		    boot_cpu_has(X86_FEATURE_RETPOLINE))
-			return ", PBRSB-eIBRS: SW sequence";
-		else
-			return ", PBRSB-eIBRS: Vulnerable";
-	} else {
-		return ", PBRSB-eIBRS: Not affected";
-	}
-}
-
 static ssize_t spectre_v2_show_state(char *buf)
 {
 	if (spectre_v2_enabled == SPECTRE_V2_LFENCE)
@@ -1943,13 +1885,12 @@ static ssize_t spectre_v2_show_state(char *buf)
 	    spectre_v2_enabled == SPECTRE_V2_EIBRS_LFENCE)
 		return sprintf(buf, "Vulnerable: eIBRS+LFENCE with unprivileged eBPF and SMT\n");
 
-	return sprintf(buf, "%s%s%s%s%s%s%s\n",
+	return sprintf(buf, "%s%s%s%s%s%s\n",
 		       spectre_v2_strings[spectre_v2_enabled],
 		       ibpb_state(),
 		       boot_cpu_has(X86_FEATURE_USE_IBRS_FW) ? ", IBRS_FW" : "",
 		       stibp_state(),
 		       boot_cpu_has(X86_FEATURE_RSB_CTXSW) ? ", RSB filling" : "",
-		       pbrsb_eibrs_state(),
 		       spectre_v2_module_string());
 }
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 653ced7cb396..f4ce78c20eab 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -954,8 +954,7 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 #define MSBDS_ONLY		BIT(5)
 #define NO_SWAPGS		BIT(6)
 #define NO_ITLB_MULTIHIT	BIT(7)
-#define NO_EIBRS_PBRSB		BIT(8)
-#define NO_MMIO			BIT(9)
+#define NO_MMIO			BIT(8)
 
 #define VULNWL(_vendor, _family, _model, _whitelist)	\
 	{ X86_VENDOR_##_vendor, _family, _model, X86_FEATURE_ANY, _whitelist }
@@ -997,7 +996,7 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 
 	VULNWL_INTEL(ATOM_GOLDMONT,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 	VULNWL_INTEL(ATOM_GOLDMONT_X,		NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
-	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_GOLDMONT_PLUS,	NO_MDS | NO_L1TF | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 
 	/*
 	 * Technically, swapgs isn't serializing on AMD (despite it previously
@@ -1007,9 +1006,7 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	 * good enough for our purposes.
 	 */
 
-	VULNWL_INTEL(ATOM_TREMONT,		NO_EIBRS_PBRSB),
-	VULNWL_INTEL(ATOM_TREMONT_L,		NO_EIBRS_PBRSB),
-	VULNWL_INTEL(ATOM_TREMONT_X,		NO_ITLB_MULTIHIT | NO_EIBRS_PBRSB),
+	VULNWL_INTEL(ATOM_TREMONT_X,		NO_ITLB_MULTIHIT),
 
 	/* AMD Family 0xf - 0x12 */
 	VULNWL_AMD(0x0f,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
@@ -1169,11 +1166,6 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 			setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);
 	}
 
-	if (cpu_has(c, X86_FEATURE_IBRS_ENHANCED) &&
-	    !cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
-	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
-		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
-
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c7e4dacca4cd..c0ea3b82ff00 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10988,9 +10988,6 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 #endif
 	      );
 
-	/* Eliminate branch target predictions from guest mode */
-	vmexit_fill_RSB();
-
 	vmx_enable_fb_clear(vmx);
 
 	/*
@@ -11013,6 +11010,9 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	x86_spec_ctrl_restore_host(vmx->spec_ctrl, 0);
 
+	/* Eliminate branch target predictions from guest mode */
+	vmexit_fill_RSB();
+
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs))
 		current_evmcs->hv_clean_fields |=
-- 
2.38.1.431.g37b22c650d-goog

