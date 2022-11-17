Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B0E62D66E
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239844AbiKQJU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239867AbiKQJUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:20:53 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5E0697D3
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:20:51 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id s15-20020a170902ea0f00b00187050232fcso1044118plg.3
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1f4niJ3p3aIxjtHLgpf7t3OjeyKo3ZNaALNAd5V8ORc=;
        b=HeXwj9hOIAvDLkJNTb65ZZjOApkXT6G01nTKSX4n9Y9Q07EebM0R7fyw9GoFC1m/Dn
         8uUX6f0M0kWHHiqvzGIztlErVr0EdOYlH4wDeoyYMQo2R9KoMPfcF3az+f7iJ/3U/lX0
         7kn9mYoByQ0ltqsbaPmeNbuLCeAkvNhleck29cKE8ZCOyTXtSzh58YdOOBrU9dx2qfVJ
         mLSj3eigNA2dqAxctov1qCWDd9iCqJY5yPwkgjMCCXdIMN1HHnzIVpxdfTrfFHa8b9Yb
         bJ7ZFfa01aqV32P3u++bz5oTsiCq1g+Gxuw9S9nPKbQ0ohQHSvuK0n86W7gFX8oE1HId
         XfZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1f4niJ3p3aIxjtHLgpf7t3OjeyKo3ZNaALNAd5V8ORc=;
        b=5FlaiHvqCt/c3OtgwSMB+4yldKqwOyTPRMeGVmWpMVSGuSzO2A/FaKXIwR4sNQ6Vox
         QNjDHr9Vv7QXq9yd2FHrY9Qi7Mtx/br9iKnuD1V1W4R05c5xN5tCztOZHYqltEGHy24p
         yafTlFlvVwJR749sUnVSGouOnKG8HwAUKgZi7Y2R7ikEMgHwKv/rgre3RIocVDjOmnEG
         ipkjKd94Yp/4FnqVA69nxVNGSWlbBGvS8AYoXN3YfBulZbvFIWxG+azq0hL0JEzQj7hJ
         HzwhmIF08Oqze7RH6a/bwiE6TdBlCxGwm+Yxe932ePnipJd+kNzbqIxzwPOzAuEUdeLx
         rOmw==
X-Gm-Message-State: ANoB5pkchKSYuM6l3kk0dWDuIgDAmUBGJsBUR2dUaS577MbGVOtQ6TNi
        Z0zlowfhFswqrKUlpUNyd16/G/bV6IzU+7bWkG8PfjGGUBvZOtlR7cPqvu3b1AV6mA78bcFA/4y
        FXAidmPKa0VdcFfhyueE8QLR3aemFkgUBfBYQEjYIt/x6ys7J9fulJE15pO5v/2IfgRA=
X-Google-Smtp-Source: AA0mqf4e72Ex2l48cqwCjcHrFhkbbXvuln4yHDnA8r6PIeWwmujGXXvqYIbFYokltr8w/yZvyUf0ebOY1tcf1A==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a63:f042:0:b0:476:f92e:f7a5 with SMTP id
 s2-20020a63f042000000b00476f92ef7a5mr1272880pgj.188.1668676851242; Thu, 17
 Nov 2022 01:20:51 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:29 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-12-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 11/34] x86/bugs: Keep a per-CPU IA32_SPEC_CTRL value
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

From: Peter Zijlstra <peterz@infradead.org>

commit caa0ff24d5d0e02abce5e65c3d2b7f20a6617be5 upstream.

Due to TIF_SSBD and TIF_SPEC_IB the actual IA32_SPEC_CTRL value can
differ from x86_spec_ctrl_base. As such, keep a per-CPU value
reflecting the current task's MSR content.

  [jpoimboe: rename]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/nospec-branch.h |  1 +
 arch/x86/kernel/cpu/bugs.c           | 28 +++++++++++++++++++++++-----
 arch/x86/kernel/process.c            |  2 +-
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index b2e34c74c138..6e2ff31584ae 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -307,6 +307,7 @@ static inline void indirect_branch_prediction_barrier(void)
 
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
+extern void write_spec_ctrl_current(u64 val);
 
 /*
  * With retpoline, we must use IBRS to restrict branch prediction
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 6f5e3b21c72a..c55570a7c91a 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -47,11 +47,29 @@ static void __init taa_select_mitigation(void);
 static void __init mmio_select_mitigation(void);
 static void __init srbds_select_mitigation(void);
 
-/* The base value of the SPEC_CTRL MSR that always has to be preserved. */
+/* The base value of the SPEC_CTRL MSR without task-specific bits set */
 u64 x86_spec_ctrl_base;
 EXPORT_SYMBOL_GPL(x86_spec_ctrl_base);
+
+/* The current value of the SPEC_CTRL MSR with task-specific bits set */
+DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
+EXPORT_SYMBOL_GPL(x86_spec_ctrl_current);
+
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
+/*
+ * Keep track of the SPEC_CTRL MSR value for the current task, which may differ
+ * from x86_spec_ctrl_base due to STIBP/SSB in __speculation_ctrl_update().
+ */
+void write_spec_ctrl_current(u64 val)
+{
+	if (this_cpu_read(x86_spec_ctrl_current) == val)
+		return;
+
+	this_cpu_write(x86_spec_ctrl_current, val);
+	wrmsrl(MSR_IA32_SPEC_CTRL, val);
+}
+
 /*
  * The vendor and possibly platform specific bits which can be modified in
  * x86_spec_ctrl_base.
@@ -1177,7 +1195,7 @@ static void __init spectre_v2_select_mitigation(void)
 	if (spectre_v2_in_eibrs_mode(mode)) {
 		/* Force it so VMEXIT will restore correctly */
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+		write_spec_ctrl_current(x86_spec_ctrl_base);
 	}
 
 	switch (mode) {
@@ -1232,7 +1250,7 @@ static void __init spectre_v2_select_mitigation(void)
 
 static void update_stibp_msr(void * __unused)
 {
-	wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+	write_spec_ctrl_current(x86_spec_ctrl_base);
 }
 
 /* Update x86_spec_ctrl_base in case SMT state changed. */
@@ -1475,7 +1493,7 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
 			x86_amd_ssb_disable();
 		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
-			wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+			write_spec_ctrl_current(x86_spec_ctrl_base);
 		}
 	}
 
@@ -1680,7 +1698,7 @@ int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which)
 void x86_spec_ctrl_setup_ap(void)
 {
 	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
-		wrmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
+		write_spec_ctrl_current(x86_spec_ctrl_base);
 
 	if (ssb_mode == SPEC_STORE_BYPASS_DISABLE)
 		x86_amd_ssb_disable();
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index cd138bfd926c..d697ccbf0cd2 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -434,7 +434,7 @@ static __always_inline void __speculation_ctrl_update(unsigned long tifp,
 	}
 
 	if (updmsr)
-		wrmsrl(MSR_IA32_SPEC_CTRL, msr);
+		write_spec_ctrl_current(msr);
 }
 
 static unsigned long speculation_ctrl_update_tif(struct task_struct *tsk)
-- 
2.38.1.431.g37b22c650d-goog

