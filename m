Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B0362D685
	for <lists+stable@lfdr.de>; Thu, 17 Nov 2022 10:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239738AbiKQJWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Nov 2022 04:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239988AbiKQJV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Nov 2022 04:21:58 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593606D4AF
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:21:55 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id e8-20020a5b0cc8000000b006bca0fa3ab6so1064690ybr.0
        for <stable@vger.kernel.org>; Thu, 17 Nov 2022 01:21:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=raaoQl8+LtvkCitEgdlnV5Yakk/YJIPWXn+n/iuEH/0=;
        b=fi/hzvFs59YPiGrjI9zGZca93SjbnRsGoxh/a80IV+8NnXhuII2xUyTsqnZGmY18Le
         /bd8nIKdw82iuiQa1Uy2m5moEKxWLas/VDCewDSZOmO01o/mp0ca4Chbn/q27EMCIBlf
         oc9atufgM8PxvkjNsNEG4VJMx64nQmQG/xXa+ji/S8S9hUyj2cian0EtR8SsHSqiVk8t
         r6+FDMbvSiIHv3NsyBQB0ZDIdfmJYGIonRtDuDgGb+ozmccl6ykU7rSlg3K9rzhCVeGe
         im2CP+n8a5Yh4LpFk9qW+x+Tazuz0HdkWY7oVX6zcCUZHxf9AwzdOBNgwoCt8EfP4Fj3
         HBMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=raaoQl8+LtvkCitEgdlnV5Yakk/YJIPWXn+n/iuEH/0=;
        b=v7u3dCHXfJb+aZ5VygQKtxk9jGMXV9jRednHzhR2xEo0fWee/GGi7nF7Fk4+EFYYw4
         JOB28fiGbB18MlGtb+aMcJqRPKdj0FNStPQXsHGLX4OVbbssVkLilXZKmxbVOGZHPhvw
         5i9Q3lHp94F/q2fnrOc51agK/GQtRj7MpdVcm7+k4wkxd5/m1T5is3H7imVWHOYKVw1l
         S3Wp0CA4mOmc5GEOS5QeECsuOSCFJ5DGyxfjxp+L8jFldkcVF4OSTrSETFM5pKnvXKRX
         hGwMyxtbIRtHzli28SThZC9vSVNrKT3jHaf1Zxtqjfi9x6yh88oEalj45JDDeOB6lt4P
         MixQ==
X-Gm-Message-State: ANoB5pml1cti0Ng3fdViKLMQ3gkSes2+XM1UyxNtj9tNorBtKM9YWRbU
        z9hSJzz9fGYvuGQE4pr4fT5rc7EGWB8blNFSyekFTvoHZqf1tBtUAQykz4AnAQnYfLTm0+qPp6S
        tWNGmGU8E2RnjK2S/4yI58Eu/m3GIyLY8kzljQ6FRUVxOTvOMdXR5DcdzSBKw10zBdrM=
X-Google-Smtp-Source: AA0mqf6PUvDIzftu71kikd5IdNb930uWxI8E0A+xVqsWq2tzAQiNR2/MZapSCb7XaiDlBwxo/sMcXcvSpy+9Qg==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:416e:f3c7:7f1d:6e])
 (user=suleiman job=sendgmr) by 2002:a5b:285:0:b0:6d3:bab1:8d32 with SMTP id
 x5-20020a5b0285000000b006d3bab18d32mr1255065ybl.541.1668676914593; Thu, 17
 Nov 2022 01:21:54 -0800 (PST)
Date:   Thu, 17 Nov 2022 18:19:42 +0900
In-Reply-To: <20221117091952.1940850-1-suleiman@google.com>
Message-Id: <20221117091952.1940850-25-suleiman@google.com>
Mime-Version: 1.0
References: <20221117091952.1940850-1-suleiman@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH 4.19 24/34] x86/speculation: Remove x86_spec_ctrl_mask
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

commit acac5e98ef8d638a411cfa2ee676c87e1973f126 upstream.

This mask has been made redundant by kvm_spec_ctrl_test_value().  And it
doesn't even work when MSR interception is disabled, as the guest can
just write to SPEC_CTRL directly.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/kernel/cpu/bugs.c | 31 +------------------------------
 1 file changed, 1 insertion(+), 30 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 8ab96965bf28..95d8b517cf4d 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -83,12 +83,6 @@ u64 spec_ctrl_current(void)
 }
 EXPORT_SYMBOL_GPL(spec_ctrl_current);
 
-/*
- * The vendor and possibly platform specific bits which can be modified in
- * x86_spec_ctrl_base.
- */
-static u64 __ro_after_init x86_spec_ctrl_mask = SPEC_CTRL_IBRS;
-
 /*
  * AMD specific MSR info for Speculative Store Bypass control.
  * x86_amd_ls_cfg_ssbd_mask is initialized in identify_boot_cpu().
@@ -137,10 +131,6 @@ void __init check_bugs(void)
 	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
 		rdmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
 
-	/* Allow STIBP in MSR_SPEC_CTRL if supported */
-	if (boot_cpu_has(X86_FEATURE_STIBP))
-		x86_spec_ctrl_mask |= SPEC_CTRL_STIBP;
-
 	/* Select the proper CPU mitigations before patching alternatives: */
 	spectre_v1_select_mitigation();
 	spectre_v2_select_mitigation();
@@ -198,19 +188,10 @@ void __init check_bugs(void)
 void
 x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
 {
-	u64 msrval, guestval, hostval = spec_ctrl_current();
+	u64 msrval, guestval = guest_spec_ctrl, hostval = spec_ctrl_current();
 	struct thread_info *ti = current_thread_info();
 
-	/* Is MSR_SPEC_CTRL implemented ? */
 	if (static_cpu_has(X86_FEATURE_MSR_SPEC_CTRL)) {
-		/*
-		 * Restrict guest_spec_ctrl to supported values. Clear the
-		 * modifiable bits in the host base value and or the
-		 * modifiable bits from the guest value.
-		 */
-		guestval = hostval & ~x86_spec_ctrl_mask;
-		guestval |= guest_spec_ctrl & x86_spec_ctrl_mask;
-
 		if (hostval != guestval) {
 			msrval = setguest ? guestval : hostval;
 			wrmsrl(MSR_IA32_SPEC_CTRL, msrval);
@@ -1542,16 +1523,6 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
 		break;
 	}
 
-	/*
-	 * If SSBD is controlled by the SPEC_CTRL MSR, then set the proper
-	 * bit in the mask to allow guests to use the mitigation even in the
-	 * case where the host does not enable it.
-	 */
-	if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
-	    static_cpu_has(X86_FEATURE_AMD_SSBD)) {
-		x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;
-	}
-
 	/*
 	 * We have three CPU feature flags that are in play here:
 	 *  - X86_BUG_SPEC_STORE_BYPASS - CPU is susceptible.
-- 
2.38.1.431.g37b22c650d-goog

