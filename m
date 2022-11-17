Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E84862D695
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239990AbiKQJWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239908AbiKQJWW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:22:22 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61DB6E546
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:20 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c188-20020a25c0c5000000b006d8eba07513so1025892ybf.17
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2KvZB6EN3sNPvbVTByCz7PXbeUpMJeMnoJ65o/fZ2js=;
        b=fIk89CnSBgpJLuqqbEke+q75kXF46PJNLb6bVG1/qGXOpwHpEXGgHj9ERfmz38JYpj
         3iE2nYOLmMF2MwzLXzo6kne4L7o945RTHLYgVMYH88Ypw7Qk3ZqAcCtNZ37DNoR+ja46
         YSKWXOK76EYA6ISKM7zDChSWqSKYaaJdkdDBr0/2m5VKZjqEIqoVPFrfCseNIGaxDl6s
         6F01bMHgxvy2Ot3RdsjTfWv9D88dPLNdqsC2JVXDICZZdRPZ1/H/Ek2r/lCB+vjQozyV
         JnnSg5AeigAwoLGB47hByOGL8+IMm/7D1Sm034zqChs/emWc9gTa8XGvG6nVrbkyhfu9
         xG0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2KvZB6EN3sNPvbVTByCz7PXbeUpMJeMnoJ65o/fZ2js=;
        b=BgSjB6widnKgdHQOSVnN3gjZ7dzIotCfZAJCSllKSo0+8dWZtnEPsAy9NJYkn5SLIe
         jyLKgcZgLsRMl2wjhqYXlC4FY4je2ZMUHQ4XQfJNI/8kN8f2VX4WMqPj5v9HpkUhrb/3
         hZOqHvY9XMRNTERGAfyS0EqxctTYcDc68yud4eUZvY3BSY3iL5SCcMhwx6anh2MS7b2R
         TWYKtUNeO9pbhXqWv2DTAkbSev4hn48GcW/EohghKf0+sc7CDFoxEiJPAMMTqQz7ciW2
         mbC9irGh70rPOu3N112JQ4JnnkHx2otlqVPWdHkrSvfuZ262ZQvJGMt+Lz+7JEr1UUJj
         6iPQ==
X-Gm-Message-State: ANoB5pltxLHTEgowUxS+HSLs/H658CvL0LHd0s3FgD2rIGzF5iFus5aH
        AD+LpEChXjZ2ChREkmc1kY7utzFd0mw0F6Q9SP5LQQu60NkE+zixYrPjhwnpnpgqbJTH19rT7qG
        iNJxXYHhkqCcuy1p5As2HMT9fipFlnTGqppfTwFWxcsCk5w1OKRC2h1xoiA0zEhlGL3E=
X-Google-Smtp-Source: AA0mqf5uU9bNvseZNFj26hwVTFg699qbhPI3+eT+RBJMUuCrEyOu4EYJtrWsexvcvL4Q9devbkWJxGfeg1A/sw==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a81:198f:0:b0:38f:116c:fe04 with SMTP id
 137-20020a81198f000000b0038f116cfe04mr2ywz.352.1668676939066; Thu, 17 Nov
 2022 01:22:19 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:47 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-30-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 29/34] x86/cpu/amd: Enumerate BTC_NO
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

From: Andrew Cooper <andrew.cooper3@citrix.com>

commit 26aae8ccbc1972233afd08fb3f368947c0314265 upstream.

BTC_NO indicates that hardware is not susceptible to Branch Type Confusion.

Zen3 CPUs don't suffer BTC.

Hypervisors are expected to synthesise BTC_NO when it is appropriate
given the migration pool, to prevent kernels using heuristics.

Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[ bp: Adjust context ]
Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kernel/cpu/amd.c          | 21 +++++++++++++++------
 arch/x86/kernel/cpu/common.c       |  6 ++++--
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 0181091abf49..aceae7ecda71 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -303,6 +303,7 @@
 #define X86_FEATURE_AMD_SSBD		(13*32+24) /* "" Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* Virtualized Speculative Store Bypass Disable */
 #define X86_FEATURE_AMD_SSB_NO		(13*32+26) /* "" Speculative Store Bypass is fixed in hardware. */
+#define X86_FEATURE_BTC_NO		(13*32+29) /* "" Not vulnerable to Branch Type Confusion */
 
 /* Thermal and Power Management Leaf, CPUID level 0x00000006 (EAX), word 14 */
 #define X86_FEATURE_DTHERM		(14*32+ 0) /* Digital Thermal Sensor */
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 98c23126f751..f1f41c96d319 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -885,12 +885,21 @@ static void init_amd_zn(struct cpuinfo_x86 *c)
 {
 	set_cpu_cap(c, X86_FEATURE_ZEN);
 
-	/*
-	 * Fix erratum 1076: CPB feature bit not being set in CPUID.
-	 * Always set it, except when running under a hypervisor.
-	 */
-	if (!cpu_has(c, X86_FEATURE_HYPERVISOR) && !cpu_has(c, X86_FEATURE_CPB))
-		set_cpu_cap(c, X86_FEATURE_CPB);
+	/* Fix up CPUID bits, but only if not virtualised. */
+	if (!cpu_has(c, X86_FEATURE_HYPERVISOR)) {
+
+		/* Erratum 1076: CPB feature bit not being set in CPUID. */
+		if (!cpu_has(c, X86_FEATURE_CPB))
+			set_cpu_cap(c, X86_FEATURE_CPB);
+
+		/*
+		 * Zen3 (Fam19 model < 0x10) parts are not susceptible to
+		 * Branch Type Confusion, but predate the allocation of the
+		 * BTC_NO bit.
+		 */
+		if (c->x86 == 0x19 && !cpu_has(c, X86_FEATURE_BTC_NO))
+			set_cpu_cap(c, X86_FEATURE_BTC_NO);
+	}
 }
 
 static void init_amd(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4c1db00f348a..c70be58b0a9b 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1172,8 +1172,10 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 			setup_force_cpu_bug(X86_BUG_MMIO_UNKNOWN);
 	}
 
-	if ((cpu_matches(cpu_vuln_blacklist, RETBLEED) || (ia32_cap & ARCH_CAP_RSBA)))
-		setup_force_cpu_bug(X86_BUG_RETBLEED);
+	if (!cpu_has(c, X86_FEATURE_BTC_NO)) {
+		if (cpu_matches(cpu_vuln_blacklist, RETBLEED) || (ia32_cap & ARCH_CAP_RSBA))
+			setup_force_cpu_bug(X86_BUG_RETBLEED);
+	}
 
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
-- 
2.38.1.431.g37b22c650d-goog

