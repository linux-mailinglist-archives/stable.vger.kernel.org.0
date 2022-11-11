Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0EB625094
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbiKKChA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbiKKCgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:36:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20E467132;
        Thu, 10 Nov 2022 18:35:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 37BD7CE24A0;
        Fri, 11 Nov 2022 02:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FEE2C433D6;
        Fri, 11 Nov 2022 02:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134106;
        bh=IDovsT+QhP/9OK7dKsXTow+ChFDjK4jPLt6qQPOf2/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dn/Kl2XSUjBpcMSgmccutPb4diOyEg4QO/vvZK7+r3xXacgXtQ8A6VoBtzIn2PqXy
         Wjea6OynFgYGO+VX4PXF2/zE9k5QUYox7MbjWokLr7mqyEmIfNwUWKIl6rJCtyqGpr
         9PJkyNdk7RVO27SvEuqsTIudkDcfaE7dH9r8uFrZL58kHi4HH7pBtPX7JQLmf5wu/8
         cSkfe6sZ3w0VvDFEnzcCWYJ5e2HiPlv1JoDiGTrXROhnDhtpmM3kFizd3N1+3r8h0R
         vg/4AH6kcR7QGw5bvwn9rOW931kG3+KQWidQjgdGPC3y8Z0l3ZLdyjYpCwAA37xxwb
         nwhnYxFLSTjPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de
Subject: [PATCH AUTOSEL 6.0 28/30] x86/cpu: Add several Intel server CPU model numbers
Date:   Thu, 10 Nov 2022 21:33:36 -0500
Message-Id: <20221111023340.227279-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit 7beade0dd41d42d797ccb7791b134a77fcebf35b ]

These servers are all on the public versions of the roadmap. The model
numbers for Grand Ridge, Granite Rapids, and Sierra Forest were included
in the September 2022 edition of the Instruction Set Extensions document.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/r/20221103203310.5058-1-tony.luck@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 5d75fe229342..347707d459c6 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -107,6 +107,11 @@
 
 #define INTEL_FAM6_SAPPHIRERAPIDS_X	0x8F	/* Golden Cove */
 
+#define INTEL_FAM6_EMERALDRAPIDS_X	0xCF
+
+#define INTEL_FAM6_GRANITERAPIDS_X	0xAD
+#define INTEL_FAM6_GRANITERAPIDS_D	0xAE
+
 #define INTEL_FAM6_ALDERLAKE		0x97	/* Golden Cove / Gracemont */
 #define INTEL_FAM6_ALDERLAKE_L		0x9A	/* Golden Cove / Gracemont */
 #define INTEL_FAM6_ALDERLAKE_N		0xBE
@@ -118,7 +123,7 @@
 #define INTEL_FAM6_METEORLAKE		0xAC
 #define INTEL_FAM6_METEORLAKE_L		0xAA
 
-/* "Small Core" Processors (Atom) */
+/* "Small Core" Processors (Atom/E-Core) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
 #define INTEL_FAM6_ATOM_BONNELL_MID	0x26 /* Silverthorne, Lincroft */
@@ -145,6 +150,10 @@
 #define INTEL_FAM6_ATOM_TREMONT		0x96 /* Elkhart Lake */
 #define INTEL_FAM6_ATOM_TREMONT_L	0x9C /* Jasper Lake */
 
+#define INTEL_FAM6_SIERRAFOREST_X	0xAF
+
+#define INTEL_FAM6_GRANDRIDGE		0xB6
+
 /* Xeon Phi */
 
 #define INTEL_FAM6_XEON_PHI_KNL		0x57 /* Knights Landing */
-- 
2.35.1

