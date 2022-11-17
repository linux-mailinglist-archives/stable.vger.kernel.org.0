Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DED062D699
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239449AbiKQJWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239856AbiKQJWe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:22:34 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C449F74A92
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:29 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id e37-20020a635025000000b00476bfca5d31so951443pgb.21
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=10/9eMzcDrW1DCI4jLHP9QDImJCZApyrJGfjbHWIKbA=;
        b=NBFdlpVZgHHiFimbOkUnSwlun1blfU86j5s/1nQwI1WbNIklSYUv6rS8/QESccjKJw
         2D1fuDVZOioAVSJXEL4AgqByK6fXZtm25BJs5WkhzpCuhaBRW18pbmCVjwN8edS7dK5w
         bOajLyXTlH4/e0Rdb6HGKAyFbuxZimGV8ZTV+Lketwb6Vi9j8xKAZXSzme6maleEAOnp
         zZuYqeugPac8k2/GtAZ+nGA9QZPRxzvEZLASvkPPKR56zHP7cQuTXaV3AA9YYTOPcAjA
         sBWVCVXorEg9e4+L7+jy1t7dnfzRIE9Ap5s54+f0qLielh80HF2POImu8Q39LghV/SxB
         OwSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=10/9eMzcDrW1DCI4jLHP9QDImJCZApyrJGfjbHWIKbA=;
        b=gRQxeQ9+RS9Wj9W2TbXbqY+gD5y88z8kzwrZFHN5OmVNl8mMYA7EjOqZkylKl8+ANL
         asJcbdJ6p3IrBTNxa8Hl4UUyNpg2qxL+K6RZg1xrZDngODk0E8mGVIAEN2ioPRevNQj/
         56P9z9FKblpEYUoM4B/lpVdrrD0xXVjDrNit3yRFb8M0WP6N4uStxO9RFwHhsD0/BXyA
         0XeScxawaGCZkF4GRqOfg2dtyNbanGHFqMw0e2V32jRQFGEDaA/S4PecbNMPB8/7A4wv
         Y/EGSLns17lPclbsJLfmWByyJGh+ObRiXOh3SGNCli3KtjTkRazMBJ1QIqr6mqUWIIvu
         COsQ==
X-Gm-Message-State: ANoB5pkvUCi2kYsrG+6QlCpI5SEIuvfigtc2x4cADpH2MJS2EFbBN9g0
        WQsSVAS0bKdY0r8lzkL51Mb1l88TKQSN7BlPiYatkdMCQgamouN+PYu75Kj/GBkKVPqCjPecMxk
        kg6mz9i/TbA5E54JYkjnulEr3BQxzjUDecWsBA5HxtIcovrUaRyLc9UOelinsIAZ9B2s=
X-Google-Smtp-Source: AA0mqf7kpUXwdn8nNkhWDRTQUmDhtnfxfvm3R4/Hk/9n0oBD98KzGDtMX2oBNVUkua5Qr3qhpkl3K3w7X0kfVA==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a17:902:bc8c:b0:186:df61:4693 with SMTP
 id bb12-20020a170902bc8c00b00186df614693mr1716318plb.173.1668676949270; Thu,
 17 Nov 2022 01:22:29 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:49 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-32-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 31/34] x86/speculation: Disable RRSBA behavior
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 4ad3278df6fe2b0852b00d5757fc2ccd8e92c26e upstream.

Some Intel processors may use alternate predictors for RETs on
RSB-underflow. This condition may be vulnerable to Branch History
Injection (BHI) and intramode-BTI.

Kernel earlier added spectre_v2 mitigation modes (eIBRS+Retpolines,
eIBRS+LFENCE, Retpolines) which protect indirect CALLs and JMPs against
such attacks. However, on RSB-underflow, RET target prediction may
fallback to alternate predictors. As a result, RET's predicted target
may get influenced by branch history.

A new MSR_IA32_SPEC_CTRL bit (RRSBA_DIS_S) controls this fallback
behavior when in kernel mode. When set, RETs will not take predictions
from alternate predictors, hence mitigating RETs as well. Support for
this is enumerated by CPUID.7.2.EDX[RRSBA_CTRL] (bit2).

For spectre v2 mitigation, when a user selects a mitigation that
protects indirect CALLs and JMPs against BHI and intramode-BTI, set
RRSBA_DIS_S also to protect RETs for RSB-underflow case.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
[bwh: Backported to 5.15: adjust context in scattered.c]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[sam: Fixed for missing X86_FEATURE_ENTRY_IBPB context]
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/cpufeatures.h |  2 +-
 arch/x86/include/asm/msr-index.h   |  9 +++++++++
 arch/x86/kernel/cpu/bugs.c         | 26 ++++++++++++++++++++++++++
 arch/x86/kernel/cpu/scattered.c    |  1 +
 4 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index aceae7ecda71..145eef3e5363 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -288,7 +288,7 @@
 /* FREE!				(11*32+ 8) */
 /* FREE!				(11*32+ 9) */
 /* FREE!				(11*32+10) */
-/* FREE!				(11*32+11) */
+#define X86_FEATURE_RRSBA_CTRL		(11*32+11) /* "" RET prediction control */
 #define X86_FEATURE_RETPOLINE		(11*32+12) /* "" Generic Retpoline mitigation for Spectre variant 2 */
 #define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 9233da260341..ec46d4af741c 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -47,6 +47,8 @@
 #define SPEC_CTRL_STIBP			BIT(SPEC_CTRL_STIBP_SHIFT)	/* STIBP mask */
 #define SPEC_CTRL_SSBD_SHIFT		2	   /* Speculative Store Bypass Disable bit */
 #define SPEC_CTRL_SSBD			BIT(SPEC_CTRL_SSBD_SHIFT)	/* Speculative Store Bypass Disable */
+#define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior */
+#define SPEC_CTRL_RRSBA_DIS_S		BIT(SPEC_CTRL_RRSBA_DIS_S_SHIFT)
 
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
 #define PRED_CMD_IBPB			BIT(0)	   /* Indirect Branch Prediction Barrier */
@@ -121,6 +123,13 @@
 						 * bit available to control VERW
 						 * behavior.
 						 */
+#define ARCH_CAP_RRSBA			BIT(19)	/*
+						 * Indicates RET may use predictors
+						 * other than the RSB. With eIBRS
+						 * enabled predictions in kernel mode
+						 * are restricted to targets in
+						 * kernel.
+						 */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 525623aa2dcb..a4684b224b59 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1181,6 +1181,22 @@ static enum spectre_v2_mitigation __init spectre_v2_select_retpoline(void)
 	return SPECTRE_V2_RETPOLINE;
 }
 
+/* Disable in-kernel use of non-RSB RET predictors */
+static void __init spec_ctrl_disable_kernel_rrsba(void)
+{
+	u64 ia32_cap;
+
+	if (!boot_cpu_has(X86_FEATURE_RRSBA_CTRL))
+		return;
+
+	ia32_cap = x86_read_arch_cap_msr();
+
+	if (ia32_cap & ARCH_CAP_RRSBA) {
+		x86_spec_ctrl_base |= SPEC_CTRL_RRSBA_DIS_S;
+		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+	}
+}
+
 static void __init spectre_v2_select_mitigation(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
@@ -1274,6 +1290,16 @@ static void __init spectre_v2_select_mitigation(void)
 		break;
 	}
 
+	/*
+	 * Disable alternate RSB predictions in kernel when indirect CALLs and
+	 * JMPs gets protection against BHI and Intramode-BTI, but RET
+	 * prediction from a non-RSB predictor is still a risk.
+	 */
+	if (mode == SPECTRE_V2_EIBRS_LFENCE ||
+	    mode == SPECTRE_V2_EIBRS_RETPOLINE ||
+	    mode == SPECTRE_V2_RETPOLINE)
+		spec_ctrl_disable_kernel_rrsba();
+
 	spectre_v2_enabled = mode;
 	pr_info("%s\n", spectre_v2_strings[mode]);
 
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 5a52672e3f8b..90bd155d7e7a 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -21,6 +21,7 @@ struct cpuid_bit {
 static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_APERFMPERF,       CPUID_ECX,  0, 0x00000006, 0 },
 	{ X86_FEATURE_EPB,		CPUID_ECX,  3, 0x00000006, 0 },
+	{ X86_FEATURE_RRSBA_CTRL,	CPUID_EDX,  2, 0x00000007, 2 },
 	{ X86_FEATURE_CQM_LLC,		CPUID_EDX,  1, 0x0000000f, 0 },
 	{ X86_FEATURE_CQM_OCCUP_LLC,	CPUID_EDX,  0, 0x0000000f, 1 },
 	{ X86_FEATURE_CQM_MBM_TOTAL,	CPUID_EDX,  1, 0x0000000f, 1 },
-- 
2.38.1.431.g37b22c650d-goog

