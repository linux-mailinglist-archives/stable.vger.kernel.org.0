Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822FE62D67B
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239941AbiKQJVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239899AbiKQJVe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:21:34 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147AB697E3
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:21:26 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id c188-20020a25c0c5000000b006d8eba07513so1023714ybf.17
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:21:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K9Ae8YptpjIFLt+1WhGpIuKV36hqZRLrgMOTRnegM/o=;
        b=k+ecxoUDGl6beWbepCuLxfhUxUeYc2nm6udzLdUReRrgpO+qc560Wh+7zFcGrMIzwQ
         Q+p7plb3pG/0+Xe+r85q0c60PsokagN0ilv9lu6/XSfI8szC0xaFcNcVoY1q7iPxv1tu
         I1++eJ7b24/73O+qQXEUKYor7Md5vkXJcA92mHnpI+ESXQw6UCDzuD6bOp68QgzB1fdg
         vNTM2mBuLckJqEYoBMrum7RHl5gHjWV8G4nqlEZoDgjW1pQnpdhBK5AxcBuWwUekrbIQ
         4FA3e5AAoZktIhCox/5flWxUnV18vNckBUwEL9uYD81EOK7hI+UCPPvKGqAhCsj8Nvf4
         OCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K9Ae8YptpjIFLt+1WhGpIuKV36hqZRLrgMOTRnegM/o=;
        b=aCS/boUwNBtsD7j9oao4U0BRvGVW4PPfYnNJJSxSg1nJFugd1NuqqvGzmpC6UDUBWs
         pXAvavmVhZr4VL3nfFXgQ7oKaJsWYI+18gI/vgxl3Ak8CFYXRbxZGPooLboGnI268s8S
         GIZ7+1t5II3on6PZxheFR0USMCPMf9XWK2E8QI29LfzTd8MVbhUQfFPcrzQNBMt7vHX6
         1HbLe/6dYnXD02gT3bqJeLphEuoeIW50EFKCd/mI6g55LWjdbSN/cCltCANJyV82SEcM
         DaP9ARndVQ+WK9V4lOhZENcfqWf/yM5uugQiluR1jTPel8erNXQDQmIBqVWTtSWvEvpP
         vBGQ==
X-Gm-Message-State: ANoB5pkMkAWpsEvfQr6JmwN3DuCOUF2S9C2JfF08veigHUbTFyfgRyse
        lPyoaB8NlqAul9t97DK/iQ0/1mNiEADfqUjs5HftAbTp3tXB3IQ9wSqmyODP+KGUHPYEsQ9kneO
        w57DnRdE7cp7TGMvptxy5xeQ2cUJhWZcGw6D5IxGdjDQezdxMt39vICTRLKkMZrOn/4c=
X-Google-Smtp-Source: AA0mqf7M52p+Uab/sfpbZCekPMbDre4Hl4WcfPGNv/Fl0vgvV1zgr+A1O/uIekNtnXPGzKAnUU1sKisRIw+dUQ==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a25:5f05:0:b0:6bc:c982:acc4 with SMTP id
 t5-20020a255f05000000b006bcc982acc4mr1352958ybb.76.1668676885293; Thu, 17 Nov
 2022 01:21:25 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:36 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-19-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 18/34] intel_idle: Disable IBRS during long idle
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

commit bf5835bcdb9635c97f85120dba9bfa21e111130f upstream.

Having IBRS enabled while the SMT sibling is idle unnecessarily slows
down the running sibling. OTOH, disabling IBRS around idle takes two
MSR writes, which will increase the idle latency.

Therefore, only disable IBRS around deeper idle states. Shallow idle
states are bounded by the tick in duration, since NOHZ is not allowed
for them by virtue of their short target residency.

Only do this for mwait-driven idle, since that keeps interrupts disabled
across idle, which makes disabling IBRS vs IRQ-entry a non-issue.

Note: C6 is a random threshold, most importantly C1 probably shouldn't
disable IBRS, benchmarking needed.

Suggested-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
[cascardo: no CPUIDLE_FLAG_IRQ_ENABLE]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[cascardo: context adjustments]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/nospec-branch.h |  1 +
 arch/x86/kernel/cpu/bugs.c           |  6 ++++
 drivers/idle/intel_idle.c            | 43 ++++++++++++++++++++++++----
 3 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 43a1c7d69dbe..9311f0f9c392 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -309,6 +309,7 @@ static inline void indirect_branch_prediction_barrier(void)
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
 extern void write_spec_ctrl_current(u64 val, bool force);
+extern u64 spec_ctrl_current(void);
 
 /*
  * With retpoline, we must use IBRS to restrict branch prediction
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 63a59dbda780..0734f35d1af1 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -77,6 +77,12 @@ void write_spec_ctrl_current(u64 val, bool force)
 		wrmsrl(MSR_IA32_SPEC_CTRL, val);
 }
 
+u64 spec_ctrl_current(void)
+{
+	return this_cpu_read(x86_spec_ctrl_current);
+}
+EXPORT_SYMBOL_GPL(spec_ctrl_current);
+
 /*
  * The vendor and possibly platform specific bits which can be modified in
  * x86_spec_ctrl_base.
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index c4bb67ed8da3..6360c045e3d0 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -58,11 +58,13 @@
 #include <linux/tick.h>
 #include <trace/events/power.h>
 #include <linux/sched.h>
+#include <linux/sched/smt.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/moduleparam.h>
 #include <asm/cpu_device_id.h>
 #include <asm/intel-family.h>
+#include <asm/nospec-branch.h>
 #include <asm/mwait.h>
 #include <asm/msr.h>
 
@@ -109,6 +111,12 @@ static struct cpuidle_state *cpuidle_state_table;
  */
 #define CPUIDLE_FLAG_TLB_FLUSHED	0x10000
 
+/*
+ * Disable IBRS across idle (when KERNEL_IBRS), is exclusive vs IRQ_ENABLE
+ * above.
+ */
+#define CPUIDLE_FLAG_IBRS		BIT(16)
+
 /*
  * MWAIT takes an 8-bit "hint" in EAX "suggesting"
  * the C-state (top nibble) and sub-state (bottom nibble)
@@ -119,6 +127,24 @@ static struct cpuidle_state *cpuidle_state_table;
 #define flg2MWAIT(flags) (((flags) >> 24) & 0xFF)
 #define MWAIT2flg(eax) ((eax & 0xFF) << 24)
 
+static __cpuidle int intel_idle_ibrs(struct cpuidle_device *dev,
+				     struct cpuidle_driver *drv, int index)
+{
+	bool smt_active = sched_smt_active();
+	u64 spec_ctrl = spec_ctrl_current();
+	int ret;
+
+	if (smt_active)
+		wrmsrl(MSR_IA32_SPEC_CTRL, 0);
+
+	ret = intel_idle(dev, drv, index);
+
+	if (smt_active)
+		wrmsrl(MSR_IA32_SPEC_CTRL, spec_ctrl);
+
+	return ret;
+}
+
 /*
  * States are indexed by the cstate number,
  * which is also the index into the MWAIT hint array.
@@ -617,7 +643,7 @@ static struct cpuidle_state skl_cstates[] = {
 	{
 		.name = "C6",
 		.desc = "MWAIT 0x20",
-		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 85,
 		.target_residency = 200,
 		.enter = &intel_idle,
@@ -625,7 +651,7 @@ static struct cpuidle_state skl_cstates[] = {
 	{
 		.name = "C7s",
 		.desc = "MWAIT 0x33",
-		.flags = MWAIT2flg(0x33) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x33) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 124,
 		.target_residency = 800,
 		.enter = &intel_idle,
@@ -633,7 +659,7 @@ static struct cpuidle_state skl_cstates[] = {
 	{
 		.name = "C8",
 		.desc = "MWAIT 0x40",
-		.flags = MWAIT2flg(0x40) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x40) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 200,
 		.target_residency = 800,
 		.enter = &intel_idle,
@@ -641,7 +667,7 @@ static struct cpuidle_state skl_cstates[] = {
 	{
 		.name = "C9",
 		.desc = "MWAIT 0x50",
-		.flags = MWAIT2flg(0x50) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x50) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 480,
 		.target_residency = 5000,
 		.enter = &intel_idle,
@@ -649,7 +675,7 @@ static struct cpuidle_state skl_cstates[] = {
 	{
 		.name = "C10",
 		.desc = "MWAIT 0x60",
-		.flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x60) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 890,
 		.target_residency = 5000,
 		.enter = &intel_idle,
@@ -678,7 +704,7 @@ static struct cpuidle_state skx_cstates[] = {
 	{
 		.name = "C6",
 		.desc = "MWAIT 0x20",
-		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x20) | CPUIDLE_FLAG_TLB_FLUSHED | CPUIDLE_FLAG_IBRS,
 		.exit_latency = 133,
 		.target_residency = 600,
 		.enter = &intel_idle,
@@ -1384,6 +1410,11 @@ static void __init intel_idle_cpuidle_driver_init(void)
 		drv->states[drv->state_count] =	/* structure copy */
 			cpuidle_state_table[cstate];
 
+		if (cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS) &&
+		    cpuidle_state_table[cstate].flags & CPUIDLE_FLAG_IBRS) {
+			drv->states[drv->state_count].enter = intel_idle_ibrs;
+		}
+
 		drv->state_count += 1;
 	}
 
-- 
2.38.1.431.g37b22c650d-goog

