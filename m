Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59EFC62D68D
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbiKQJWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240066AbiKQJWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:22:10 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7931B6D48A
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:09 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id c1-20020a170902d48100b0018723580343so1022125plg.15
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dZXdznTaUsK5qm814MK3DUiCkUa5FPkQk1lWIzMTp3s=;
        b=GlHeNwfXi8H5f1FkbZ7osSdHOIYxPKDXAL4PoomT1XPGBUKqktZOjGTrjV2/tVSjK8
         qSmRrtzE+7XmMzV++ZwO2kAz8R1an++eNzRzRAshsENlF6h5ovFbm+Z3Q92ElV5JdvhV
         UG8QzOwXBPKTNUDeqbmrMdoUE/hYTHRl3ymnO7GRryZ93yF/D917jyBSMIBcAESki9gM
         ZZ8AAIZH3yz+8L+7QpmFCQORFcQenE9U5pRoR+ulTnUWg3iMBFNR6fYlABkQsLYyfJby
         1rZO9MPSudm8kWesVUK/bYN2SyCvV4KdEJ2LN9DOk/ATsexarNM5ufrmyfSHwcQIR5H/
         XFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dZXdznTaUsK5qm814MK3DUiCkUa5FPkQk1lWIzMTp3s=;
        b=hAyDI+cN6JxnI8a5AQOqqfmtj8nmBvCmIpNV+QbThmYXNIgZ19MSwbiOZ2mQGJaRrC
         PQdxWnoId7QHlEDkTaPEfY4uf2RH+HF9gQSaykmcwqrVFEDxdfWPUhYXntfjhZUDcEly
         Rxn2rPOFKH1w9shwZaubRDdZbgoHRThqyhhfsPMElihcXAxOuyWf1rCfazpuwDqFsRwl
         6ZNfPgkv3fUzndcryp6We7NJNcTVa6bTvWbOdZgn75tdOOITzwixCQmpFTZAbjShFIJL
         uTh5fKHwP3f+jWPhjsZuUqQEMhiKL1ptZvUbqqc+CrQPFywz+7e/RjYJL7R99K6hDr6v
         VsGQ==
X-Gm-Message-State: ANoB5plwsY00PJ/BJGAJbHNCkI3EzRq283CFxCHmOaWWzxq9nFwSKfR3
        R9ZQodOhTUQ6puSxFqEu5qwoBeZ4mLtg+0OGeCPt2Dk+/Zqa2wjfyL0AybK+mjdfc4TEi7oRKxH
        l2Y9XJdGkarj53yO2LTg5IapYTxmGBInoXWDNomG5KXt7eIfWymOxF80qOwuczH8M4XA=
X-Google-Smtp-Source: AA0mqf70CyiSrduLZe2+N0gTK/Rq3ByVoSQt+6FYiwfQhQObWosIvFxUCyD+Mg+cmNxtlpE//hGj89thx6qqNQ==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a05:6a00:2483:b0:56c:12c0:aaf1 with SMTP
 id c3-20020a056a00248300b0056c12c0aaf1mr2111742pfv.50.1668676928954; Thu, 17
 Nov 2022 01:22:08 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:45 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-28-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 27/34] x86/speculation: Fill RSB on vmexit for IBRS
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit 9756bba28470722dacb79ffce554336dd1f6a6cd upstream.

Prevent RSB underflow/poisoning attacks with RSB.  While at it, add a
bunch of comments to attempt to document the current state of tribal
knowledge about RSB attacks and what exactly is being mitigated.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[ bp: Adjust for the fact that vmexit is in inline assembly ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/cpufeatures.h   |  2 +-
 arch/x86/include/asm/nospec-branch.h |  2 +-
 arch/x86/kernel/cpu/bugs.c           | 63 +++++++++++++++++++++++++---
 arch/x86/kvm/vmx.c                   |  4 +-
 4 files changed, 62 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 23126290185d..0181091abf49 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -203,7 +203,7 @@
 #define X86_FEATURE_SME			( 7*32+10) /* AMD Secure Memory Encryption */
 #define X86_FEATURE_PTI			( 7*32+11) /* Kernel Page Table Isolation enabled */
 #define X86_FEATURE_KERNEL_IBRS		( 7*32+12) /* "" Set/clear IBRS on kernel entry/exit */
-/* FREE!				( 7*32+13) */
+#define X86_FEATURE_RSB_VMEXIT		( 7*32+13) /* "" Fill RSB on VM-Exit */
 #define X86_FEATURE_INTEL_PPIN		( 7*32+14) /* Intel Processor Inventory Number */
 #define X86_FEATURE_CDP_L2		( 7*32+15) /* Code and Data Prioritization L2 */
 #define X86_FEATURE_MSR_SPEC_CTRL	( 7*32+16) /* "" MSR SPEC_CTRL is implemented */
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 3e1d2389c00d..8bce4004aab2 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -279,7 +279,7 @@ static __always_inline void vmexit_fill_RSB(void)
 	asm volatile (ANNOTATE_NOSPEC_ALTERNATIVE
 		      ALTERNATIVE("jmp 910f",
 				  __stringify(__FILL_RETURN_BUFFER(%0, RSB_CLEAR_LOOPS, %1)),
-				  X86_FEATURE_RETPOLINE)
+				  X86_FEATURE_RSB_VMEXIT)
 		      "910:"
 		      : "=r" (loops), ASM_CALL_CONSTRAINT
 		      : : "memory" );
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 022b9f31333f..525623aa2dcb 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1278,16 +1278,69 @@ static void __init spectre_v2_select_mitigation(void)
 	pr_info("%s\n", spectre_v2_strings[mode]);
 
 	/*
-	 * If spectre v2 protection has been enabled, unconditionally fill
-	 * RSB during a context switch; this protects against two independent
-	 * issues:
+	 * If Spectre v2 protection has been enabled, fill the RSB during a
+	 * context switch.  In general there are two types of RSB attacks
+	 * across context switches, for which the CALLs/RETs may be unbalanced.
 	 *
-	 *	- RSB underflow (and switch to BTB) on Skylake+
-	 *	- SpectreRSB variant of spectre v2 on X86_BUG_SPECTRE_V2 CPUs
+	 * 1) RSB underflow
+	 *
+	 *    Some Intel parts have "bottomless RSB".  When the RSB is empty,
+	 *    speculated return targets may come from the branch predictor,
+	 *    which could have a user-poisoned BTB or BHB entry.
+	 *
+	 *    AMD has it even worse: *all* returns are speculated from the BTB,
+	 *    regardless of the state of the RSB.
+	 *
+	 *    When IBRS or eIBRS is enabled, the "user -> kernel" attack
+	 *    scenario is mitigated by the IBRS branch prediction isolation
+	 *    properties, so the RSB buffer filling wouldn't be necessary to
+	 *    protect against this type of attack.
+	 *
+	 *    The "user -> user" attack scenario is mitigated by RSB filling.
+	 *
+	 * 2) Poisoned RSB entry
+	 *
+	 *    If the 'next' in-kernel return stack is shorter than 'prev',
+	 *    'next' could be tricked into speculating with a user-poisoned RSB
+	 *    entry.
+	 *
+	 *    The "user -> kernel" attack scenario is mitigated by SMEP and
+	 *    eIBRS.
+	 *
+	 *    The "user -> user" scenario, also known as SpectreBHB, requires
+	 *    RSB clearing.
+	 *
+	 * So to mitigate all cases, unconditionally fill RSB on context
+	 * switches.
+	 *
+	 * FIXME: Is this pointless for retbleed-affected AMD?
 	 */
 	setup_force_cpu_cap(X86_FEATURE_RSB_CTXSW);
 	pr_info("Spectre v2 / SpectreRSB mitigation: Filling RSB on context switch\n");
 
+	/*
+	 * Similar to context switches, there are two types of RSB attacks
+	 * after vmexit:
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
+	 * eIBRS, on the other hand, has RSB-poisoning protections, so it
+	 * doesn't need RSB clearing after vmexit.
+	 */
+	if (boot_cpu_has(X86_FEATURE_RETPOLINE) ||
+	    boot_cpu_has(X86_FEATURE_KERNEL_IBRS))
+		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
+
 	/*
 	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
 	 * and Enhanced IBRS protect firmware too, so enable IBRS around
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index babb1e5a4dfa..30f0d55c8b2d 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -11018,8 +11018,8 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 * IMPORTANT: RSB filling and SPEC_CTRL handling must be done before
 	 * the first unbalanced RET after vmexit!
 	 *
-	 * For retpoline, RSB filling is needed to prevent poisoned RSB entries
-	 * and (in some cases) RSB underflow.
+	 * For retpoline or IBRS, RSB filling is needed to prevent poisoned RSB
+	 * entries and (in some cases) RSB underflow.
 	 *
 	 * eIBRS has its own protection against poisoned RSB, so it doesn't
 	 * need the RSB filling sequence.  But it does need to be enabled
-- 
2.38.1.431.g37b22c650d-goog

