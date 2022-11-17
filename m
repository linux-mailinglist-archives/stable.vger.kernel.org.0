Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C9662D65C
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbiKQJUO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239834AbiKQJUN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:20:13 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35061697C0
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:20:12 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id om10-20020a17090b3a8a00b002108b078ab1so3742636pjb.9
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vuiGhimP9TAVmuDVc6HfD7Tzph6VXwtenyyF7FzYBHQ=;
        b=IUyR9E+jWEjbg1Bnd5pQBTrtrIU4EnUL3mQ84ih5jZ9OcGYU/xxEsqCoXtfQXFVA3j
         ta4Ag2yWrVNGAma+hY+MmHj+0mOb+dhSreaa4A78kFEwQ8xcbK2bPoFDWgtnIW8sMTjD
         gl+jUDkteY4lLE2193ixGKPRSfSpu7QqXv2RNH0l9HpcaOCgisrbr+1G6qOL6/IJgh+l
         RhBaFdmA6P9kC6avD0uoIX9z+8h1eD0OMzbs/dsLOaLvBBofy6gEfDAiXIDlcR/++w5j
         F6jCp+4fRQHBfEUYolKeeVUjc7MgAMBiNDK/jsokoHtLqnqXlHpP+lAY8gSSklCfnIum
         +Mxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vuiGhimP9TAVmuDVc6HfD7Tzph6VXwtenyyF7FzYBHQ=;
        b=LmYbNdiQEmhgOQEF+TevnnwUTN25FnS3/lXENphOodUETs0ly3QMANPJ4Hj7wXiJWz
         ZT+Wc6uTLmht42PREY10ALP0dOlNu7hP5XBd4DlvtGC/INPA2OtrB4fmt0rJtbFmXJVY
         WjFFIdm7EyljKU2N2G9A7hiSgHCBywi1BeWDRV3dFAsyMkxfRakOt5jAfRp6Q81CiOKb
         s5AQCI8HydOf2ZzoRhiMeFs4RW9uks36dWoa47p64680RCzLM/01OyORq1A9Sl365BTT
         PleDiy8haTZq+IGjDYF74ECyEWffZ+cNZnJs1iJ79aTqrtCy/hIPRDFElnzKYBmsUgx2
         fUaA==
X-Gm-Message-State: ANoB5pnMq20EJ9UQrslMpZMgFNyuEBignzwOHAkPP7kFP5nIVbY6HuCj
        WZebejHYYu9y/hhMQryAqWQ3HF94tI9MKGt52yvPri4hHRGWe3xualrgOlX3G5lxyrQz/sTmYe9
        dCEeQedEeu9u1Qt8nG2SDlOzERSAFNQD4a5p7AAjVJd5ll93AwIpj942HJsKQl/sIRog=
X-Google-Smtp-Source: AA0mqf5KkPUWWkxv9K0jVIH54BEavFTYOluIuX/0De0QEHIPyqZCsA5XZl1AYh+dIamLdfrC2H8IYlRgdc2hhw==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a05:6a00:1413:b0:56b:8e99:a5e9 with SMTP
 id l19-20020a056a00141300b0056b8e99a5e9mr2122245pfu.24.1668676811402; Thu, 17
 Nov 2022 01:20:11 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:21 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-4-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 03/34] x86/cpufeature: Add facility to check for min
 microcode revisions
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

From: Kan Liang <kan.liang@linux.intel.com>

For bug workarounds or checks, it is useful to check for specific
microcode revisions.

Add a new generic function to match the CPU with stepping.
Add the other function to check the min microcode revisions for
the matched CPU.

A new table format is introduced to facilitate the quirk to
fill the related information.

This does not change the existing x86_cpu_id because it's an ABI
shared with modules, and also has quite different requirements,
as in no wildcards, but everything has to be matched exactly.

Originally-by: Andi Kleen <ak@linux.intel.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Borislav Petkov <bp@alien8.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@google.com
Link: https://lkml.kernel.org/r/1549319013-4522-1-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/cpu_device_id.h | 28 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/match.c          | 31 ++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/arch/x86/include/asm/cpu_device_id.h b/arch/x86/include/asm/cpu_device_id.h
index baeba0567126..3417110574c1 100644
--- a/arch/x86/include/asm/cpu_device_id.h
+++ b/arch/x86/include/asm/cpu_device_id.h
@@ -11,4 +11,32 @@
 
 extern const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match);
 
+/*
+ * Match specific microcode revisions.
+ *
+ * vendor/family/model/stepping must be all set.
+ *
+ * Only checks against the boot CPU.  When mixed-stepping configs are
+ * valid for a CPU model, add a quirk for every valid stepping and
+ * do the fine-tuning in the quirk handler.
+ */
+
+struct x86_cpu_desc {
+	__u8	x86_family;
+	__u8	x86_vendor;
+	__u8	x86_model;
+	__u8	x86_stepping;
+	__u32	x86_microcode_rev;
+};
+
+#define INTEL_CPU_DESC(mod, step, rev) {			\
+	.x86_family = 6,					\
+	.x86_vendor = X86_VENDOR_INTEL,				\
+	.x86_model = mod,					\
+	.x86_stepping = step,					\
+	.x86_microcode_rev = rev,				\
+}
+
+extern bool x86_cpu_has_min_microcode_rev(const struct x86_cpu_desc *table);
+
 #endif
diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 3fed38812eea..6dd78d8235e4 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -48,3 +48,34 @@ const struct x86_cpu_id *x86_match_cpu(const struct x86_cpu_id *match)
 	return NULL;
 }
 EXPORT_SYMBOL(x86_match_cpu);
+
+static const struct x86_cpu_desc *
+x86_match_cpu_with_stepping(const struct x86_cpu_desc *match)
+{
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	const struct x86_cpu_desc *m;
+
+	for (m = match; m->x86_family | m->x86_model; m++) {
+		if (c->x86_vendor != m->x86_vendor)
+			continue;
+		if (c->x86 != m->x86_family)
+			continue;
+		if (c->x86_model != m->x86_model)
+			continue;
+		if (c->x86_stepping != m->x86_stepping)
+			continue;
+		return m;
+	}
+	return NULL;
+}
+
+bool x86_cpu_has_min_microcode_rev(const struct x86_cpu_desc *table)
+{
+	const struct x86_cpu_desc *res = x86_match_cpu_with_stepping(table);
+
+	if (!res || res->x86_microcode_rev > boot_cpu_data.microcode)
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(x86_cpu_has_min_microcode_rev);
-- 
2.38.1.431.g37b22c650d-goog

