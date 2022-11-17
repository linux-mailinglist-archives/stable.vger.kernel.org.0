Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 002A862D67A
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239905AbiKQJVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239861AbiKQJVb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:21:31 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA74697D8
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:21:21 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id y82-20020a253255000000b006e7a04f3824so233729yby.19
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d/RXx9wXTdzXPwApBbCAYqFaROqhIuNaPO6b59yAqxM=;
        b=jWQaeFYp3+g9jpA82uXaAtNuTv9vqhneAyLLYCWBvmqqflmbQwJHRzhN0WLps8NmCh
         N/ohZkVbq6mc55ggTTvZ7Zkn91lsrgy3OHuNi2pMzOpdPPl8nipaMCSYqta8krKFLFKB
         4CpJAVpSiZcGtUnJiSWJJznj8bXWmI/pyA/mnbs546UtPQFMXGWRgNXTxKv09f3EDh4n
         bU8u8a4+jYHUZiCPygd0iC1cez8FLeWCHTBZ+n5icSn4UcJSfsm9AylHqTVNe2k1TBxm
         Oq2QNyfgEB5ufZAk4nDeEzalBH08rw3TIMqgEGV0gdyRZeITxGVaYJRCZeC0fxU6xtIE
         CfFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d/RXx9wXTdzXPwApBbCAYqFaROqhIuNaPO6b59yAqxM=;
        b=aZUGCPRfKBUMlfhoeCbuTZajkBqAvaN2j39MpzC5GPEufi8iU0xuE1siZaADac/koX
         yrbHZp55NsFSd0X4Yk85k0J6MHKalplmgIgb4Qfo3Uha29L5KXK/nkaKx8IpP/PH7vRs
         /ivfbt+44NA3CwDBoIpLcQkC7kKF2/dWFDPK2jyP/3xiZVQ76VBga30MUNox3nguDF4G
         olJR7Y0U7XdLsiPEq3hhRkEBBQhdfFHfvRrzmhtrj949sTRslKINWYNKDXdQCbTDJTJh
         SAnifAWDc7pI7vD6JGuuvNMMaRIILGYwJ98WdTNvkpRe+/eWfzMjjPpiGRWgavBeE7SG
         zJSQ==
X-Gm-Message-State: ANoB5pmLcX5IOqiCevzmZO2scVO/Rb5AFWi/G8B/IhUuBmUkX1aXV33M
        wKSc1JWZGFeJeG5LfJYY6qlQG5X8P2k4Leu/FTTPs9i+AHU/tUKWbBMGtZFM8OAG+wEoMWr7LVR
        8kViiSHvX/2oT/LdqPMC3jtLhYbKSnu0VoBgmP5jYU/WxV4pNX7zw0QZvhNs5wW+0JN0=
X-Google-Smtp-Source: AA0mqf5ISpkGpO5xnSR879HMXiw0GegQ8sspgqBtpEYeloq5BGuxW3sIewVFxcLDBWt1LpvPki+celi8NJ5JCQ==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a05:690c:881:b0:373:3558:47be with SMTP
 id cd1-20020a05690c088100b00373355847bemr1290128ywb.121.1668676881050; Thu,
 17 Nov 2022 01:21:21 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:35 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-18-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 17/34] x86/bugs: Report Intel retbleed vulnerability
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

commit 6ad0ad2bf8a67e27d1f9d006a1dabb0e1c360cc3 upstream.

Skylake suffers from RSB underflow speculation issues; report this
vulnerability and it's mitigation (spectre_v2=ibrs).

  [jpoimboe: cleanups, eibrs]

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[suleiman: different processor names]
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/msr-index.h |  1 +
 arch/x86/kernel/cpu/bugs.c       | 36 +++++++++++++++++++++++++++-----
 arch/x86/kernel/cpu/common.c     | 24 ++++++++++-----------
 3 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 586be095ed08..9233da260341 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -73,6 +73,7 @@
 #define MSR_IA32_ARCH_CAPABILITIES	0x0000010a
 #define ARCH_CAP_RDCL_NO		BIT(0)	/* Not susceptible to Meltdown */
 #define ARCH_CAP_IBRS_ALL		BIT(1)	/* Enhanced IBRS support */
+#define ARCH_CAP_RSBA			BIT(2)	/* RET may use alternative branch predictors */
 #define ARCH_CAP_SKIP_VMENTRY_L1DFLUSH	BIT(3)	/* Skip L1D flush on vmentry */
 #define ARCH_CAP_SSB_NO			BIT(4)	/*
 						 * Not susceptible to Speculative Store Bypass
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index ba60b61f0ee1..63a59dbda780 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -743,11 +743,16 @@ static int __init nospectre_v1_cmdline(char *str)
 }
 early_param("nospectre_v1", nospectre_v1_cmdline);
 
+static enum spectre_v2_mitigation spectre_v2_enabled __ro_after_init =
+	SPECTRE_V2_NONE;
+
 #undef pr_fmt
 #define pr_fmt(fmt)     "RETBleed: " fmt
 
 enum retbleed_mitigation {
 	RETBLEED_MITIGATION_NONE,
+	RETBLEED_MITIGATION_IBRS,
+	RETBLEED_MITIGATION_EIBRS,
 };
 
 enum retbleed_mitigation_cmd {
@@ -757,6 +762,8 @@ enum retbleed_mitigation_cmd {
 
 const char * const retbleed_strings[] = {
 	[RETBLEED_MITIGATION_NONE]	= "Vulnerable",
+	[RETBLEED_MITIGATION_IBRS]	= "Mitigation: IBRS",
+	[RETBLEED_MITIGATION_EIBRS]	= "Mitigation: Enhanced IBRS",
 };
 
 static enum retbleed_mitigation retbleed_mitigation __ro_after_init =
@@ -782,6 +789,7 @@ early_param("retbleed", retbleed_parse_cmdline);
 
 #define RETBLEED_UNTRAIN_MSG "WARNING: BTB untrained return thunk mitigation is only effective on AMD/Hygon!\n"
 #define RETBLEED_COMPILER_MSG "WARNING: kernel not compiled with RETPOLINE or -mfunction-return capable compiler!\n"
+#define RETBLEED_INTEL_MSG "WARNING: Spectre v2 mitigation leaves CPU vulnerable to RETBleed attacks, data leaks possible!\n"
 
 static void __init retbleed_select_mitigation(void)
 {
@@ -794,8 +802,10 @@ static void __init retbleed_select_mitigation(void)
 
 	case RETBLEED_CMD_AUTO:
 	default:
-		if (!boot_cpu_has_bug(X86_BUG_RETBLEED))
-			break;
+		/*
+		 * The Intel mitigation (IBRS) was already selected in
+		 * spectre_v2_select_mitigation().
+		 */
 
 		break;
 	}
@@ -805,15 +815,31 @@ static void __init retbleed_select_mitigation(void)
 		break;
 	}
 
+	/*
+	 * Let IBRS trump all on Intel without affecting the effects of the
+	 * retbleed= cmdline option.
+	 */
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
+		switch (spectre_v2_enabled) {
+		case SPECTRE_V2_IBRS:
+			retbleed_mitigation = RETBLEED_MITIGATION_IBRS;
+			break;
+		case SPECTRE_V2_EIBRS:
+		case SPECTRE_V2_EIBRS_RETPOLINE:
+		case SPECTRE_V2_EIBRS_LFENCE:
+			retbleed_mitigation = RETBLEED_MITIGATION_EIBRS;
+			break;
+		default:
+			pr_err(RETBLEED_INTEL_MSG);
+		}
+	}
+
 	pr_info("%s\n", retbleed_strings[retbleed_mitigation]);
 }
 
 #undef pr_fmt
 #define pr_fmt(fmt)     "Spectre V2 : " fmt
 
-static enum spectre_v2_mitigation spectre_v2_enabled __ro_after_init =
-	SPECTRE_V2_NONE;
-
 static enum spectre_v2_user_mitigation spectre_v2_user_stibp __ro_after_init =
 	SPECTRE_V2_USER_NONE;
 static enum spectre_v2_user_mitigation spectre_v2_user_ibpb __ro_after_init =
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index bc9c0739c9c3..f184c4149327 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1048,24 +1048,24 @@ static const struct x86_cpu_id cpu_vuln_blacklist[] __initconst = {
 	VULNBL_INTEL_STEPPINGS(BROADWELL_GT3E,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_X,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(BROADWELL_CORE,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_MOBILE,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_MOBILE,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(SKYLAKE_MOBILE,	X86_STEPPING_ANY,		SRBDS),
 	VULNBL_INTEL_STEPPINGS(SKYLAKE_X,	BIT(3) | BIT(4) | BIT(6) |
-						BIT(7) | BIT(0xB),              MMIO),
-	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO),
+						BIT(7) | BIT(0xB),              MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPINGS(0x3, 0x3),	SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(SKYLAKE_DESKTOP,	X86_STEPPING_ANY,		SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPINGS(0x9, 0xC),	SRBDS | MMIO),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPINGS(0x9, 0xC),	SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(KABYLAKE_MOBILE,	X86_STEPPINGS(0x0, 0x8),	SRBDS),
-	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x9, 0xD),	SRBDS | MMIO),
+	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x9, 0xD),	SRBDS | MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(KABYLAKE_DESKTOP,X86_STEPPINGS(0x0, 0x8),	SRBDS),
-	VULNBL_INTEL_STEPPINGS(ICELAKE_MOBILE,	X86_STEPPINGS(0x5, 0x5),	MMIO | MMIO_SBDS),
+	VULNBL_INTEL_STEPPINGS(ICELAKE_MOBILE,	X86_STEPPINGS(0x5, 0x5),	MMIO | MMIO_SBDS | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_XEON_D,	X86_STEPPINGS(0x1, 0x1),	MMIO),
 	VULNBL_INTEL_STEPPINGS(ICELAKE_X,	X86_STEPPINGS(0x4, 0x6),	MMIO),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE,	BIT(2) | BIT(3) | BIT(5),	MMIO | MMIO_SBDS),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
-	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x0, 0x0),	MMIO),
-	VULNBL_INTEL_STEPPINGS(LAKEFIELD,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
-	VULNBL_INTEL_STEPPINGS(ROCKETLAKE,	X86_STEPPINGS(0x1, 0x1),	MMIO),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE,	BIT(2) | BIT(3) | BIT(5),	MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(COMETLAKE_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(LAKEFIELD,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS | RETBLEED),
+	VULNBL_INTEL_STEPPINGS(ROCKETLAKE,	X86_STEPPINGS(0x1, 0x1),	MMIO | RETBLEED),
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT,	X86_STEPPINGS(0x1, 0x1),	MMIO | MMIO_SBDS),
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_X,	X86_STEPPING_ANY,		MMIO),
 	VULNBL_INTEL_STEPPINGS(ATOM_TREMONT_L,	X86_STEPPINGS(0x0, 0x0),	MMIO | MMIO_SBDS),
@@ -1178,7 +1178,7 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 			setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);
 	}
 
-	if (cpu_matches(cpu_vuln_blacklist, RETBLEED))
+	if ((cpu_matches(cpu_vuln_blacklist, RETBLEED) || (ia32_cap & ARCH_CAP_RSBA)))
 		setup_force_cpu_bug(X86_BUG_RETBLEED);
 
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
-- 
2.38.1.431.g37b22c650d-goog

