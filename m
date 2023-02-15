Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD5C698663
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjBOUt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjBOUtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:49:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49574457C7;
        Wed, 15 Feb 2023 12:47:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77E2861DA3;
        Wed, 15 Feb 2023 20:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBE5C4339E;
        Wed, 15 Feb 2023 20:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676494008;
        bh=XvkHYM4aHlvY8OJnfGfosr0f5gSKSpyrVM69yuv2oAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ci5zmlZGOncuw2lYapUhIMJM+VaWWUVgjdrYRIGSx32t65V52A1SLPUG5RKSGxolJ
         Nc7Fyb+lzb80Rop4CRtk67WiZ/ZGps2xJCEoPJDWPSTkF7SyhNdm/UZmUar4CIjBgd
         q2+ht9TynoeXRe9JCkDzZaHPdFOBxa3RXvqk/EN6JwdZDU+ASGJUvtC/unCa88zPxg
         HELTtUSdObtrSzulB9y5t30klfb8tlND09nwtQ2FqUXsppZA5zOTZmfA/kkw47sEOh
         mK0mKUwKYBJpuFloM0Wu1pTfoXxXLBXXc4UoblephiZl1Hw32XNLR39r/ZOUfd7GTP
         zb62qdi+/sIjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de
Subject: [PATCH AUTOSEL 5.15 12/12] x86/cpu: Add Lunar Lake M
Date:   Wed, 15 Feb 2023 15:46:34 -0500
Message-Id: <20230215204637.2761073-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204637.2761073-1-sashal@kernel.org>
References: <20230215204637.2761073-1-sashal@kernel.org>
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

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit f545e8831e70065e127f903fc7aca09aa50422c7 ]

Intel confirmed the existence of this CPU in Q4'2022
earnings presentation.

Add the CPU model number.

[ dhansen: Merging these as soon as possible makes it easier
	   on all the folks developing model-specific features. ]

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20230208172340.158548-1-tony.luck%40intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/intel-family.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/intel-family.h b/arch/x86/include/asm/intel-family.h
index 13922963431a0..b8e7ea9e71e20 100644
--- a/arch/x86/include/asm/intel-family.h
+++ b/arch/x86/include/asm/intel-family.h
@@ -113,6 +113,8 @@
 #define INTEL_FAM6_ALDERLAKE		0x97	/* Golden Cove / Gracemont */
 #define INTEL_FAM6_ALDERLAKE_L		0x9A	/* Golden Cove / Gracemont */
 
+#define INTEL_FAM6_LUNARLAKE_M		0xBD
+
 /* "Small Core" Processors (Atom/E-Core) */
 
 #define INTEL_FAM6_ATOM_BONNELL		0x1C /* Diamondville, Pineview */
-- 
2.39.0

