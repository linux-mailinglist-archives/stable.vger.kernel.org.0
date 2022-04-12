Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA154FCA23
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243772AbiDLAvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244125AbiDLAuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:50:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA5031DED;
        Mon, 11 Apr 2022 17:46:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67AFBB819B5;
        Tue, 12 Apr 2022 00:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBDEC385A4;
        Tue, 12 Apr 2022 00:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724411;
        bh=ResghmII99n/SG65QwcSI9j5RgNFRUjFsjQqNkCWCW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ctypd+poFqFg7rBujnj8wa7m73RImaS6Q1aXN1XI/l1DiMuaTU4oqzJpl+lEnUfYH
         14MXe1blFfOZ5j2+ipXVHUJBv4tF3B2YEImUicYy7zIxRv21Jvxj5xRSTlS3oBsp53
         F/6ywdf/6zVjAQGmnJD4B6us+sUJi1LGMXRLZS06RZTbn0uwauLw1YgkHtie56pwjm
         YTmX3nKm07+tdMtdEa/54MU2Qk9aiyp+COObxEnH3ajfM6tr2KBKyzPp0xdBiFwq/k
         L4v2kIi6glZIdkxIwTOIgzBr9lZF5/YcDDWdZSxJGgAd15510JoPWKZBn/myQFJczF
         VWaE7ISpvLCaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chanho Park <chanho61.park@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Sasha Levin <sashal@kernel.org>, suzuki.poulose@arm.com,
        anshuman.khandual@arm.com, lcherian@marvell.com,
        rmk+kernel@armlinux.org.uk, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 48/49] arm64: Add part number for Arm Cortex-A78AE
Date:   Mon, 11 Apr 2022 20:44:06 -0400
Message-Id: <20220412004411.349427-48-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chanho Park <chanho61.park@samsung.com>

[ Upstream commit 83bea32ac7ed37bbda58733de61fc9369513f9f9 ]

Add the MIDR part number info for the Arm Cortex-A78AE[1] and add it to
spectre-BHB affected list[2].

[1]: https://developer.arm.com/Processors/Cortex-A78AE
[2]: https://developer.arm.com/Arm%20Security%20Center/Spectre-BHB

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Link: https://lore.kernel.org/r/20220407091128.8700-1-chanho61.park@samsung.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cputype.h | 2 ++
 arch/arm64/kernel/proton-pack.c  | 1 +
 2 files changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index bfbf0c4c7c5e..39f5c1672f48 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -75,6 +75,7 @@
 #define ARM_CPU_PART_CORTEX_A77		0xD0D
 #define ARM_CPU_PART_NEOVERSE_V1	0xD40
 #define ARM_CPU_PART_CORTEX_A78		0xD41
+#define ARM_CPU_PART_CORTEX_A78AE	0xD42
 #define ARM_CPU_PART_CORTEX_X1		0xD44
 #define ARM_CPU_PART_CORTEX_A510	0xD46
 #define ARM_CPU_PART_CORTEX_A710	0xD47
@@ -123,6 +124,7 @@
 #define MIDR_CORTEX_A77	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A77)
 #define MIDR_NEOVERSE_V1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V1)
 #define MIDR_CORTEX_A78	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78)
+#define MIDR_CORTEX_A78AE	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78AE)
 #define MIDR_CORTEX_X1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X1)
 #define MIDR_CORTEX_A510 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A510)
 #define MIDR_CORTEX_A710 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A710)
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index 5777929d35bf..40be3a7c2c53 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -853,6 +853,7 @@ u8 spectre_bhb_loop_affected(int scope)
 	if (scope == SCOPE_LOCAL_CPU) {
 		static const struct midr_range spectre_bhb_k32_list[] = {
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_A78),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A78AE),
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_A78C),
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_X1),
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_A710),
-- 
2.35.1

