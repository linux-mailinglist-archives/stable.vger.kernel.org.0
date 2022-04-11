Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1904FB40A
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 08:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245096AbiDKGz4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 02:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236025AbiDKGzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 02:55:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F7E205F9
        for <stable@vger.kernel.org>; Sun, 10 Apr 2022 23:53:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74774B810FD
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 06:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE865C385A3;
        Mon, 11 Apr 2022 06:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649660019;
        bh=zOVvyKnzDQhTsygympmXbzFbyBDE2wGTR5SBA4mAaks=;
        h=Subject:To:Cc:From:Date:From;
        b=zdNuCJ+MZitBcA0X08ZwIwf9UDPtcWNXk1Dt8293+vI924pMkl0GJzQ88RSnyYKyb
         t9Q3/2m4gUrWqY9WXTEHaC9vREqfL4p2/E4PpHFc1/LwaPTC7h85pDbS4OzMYnSRfJ
         iiN74b2ymwZv5pGn+nRSCCtpZBCY4h1bC5RMRSBs=
Subject: FAILED: patch "[PATCH] arm64: Add part number for Arm Cortex-A78AE" failed to apply to 5.4-stable tree
To:     chanho61.park@samsung.com, catalin.marinas@arm.com,
        james.morse@arm.com, mark.rutland@arm.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 08:53:24 +0200
Message-ID: <16496600042393@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 83bea32ac7ed37bbda58733de61fc9369513f9f9 Mon Sep 17 00:00:00 2001
From: Chanho Park <chanho61.park@samsung.com>
Date: Thu, 7 Apr 2022 18:11:28 +0900
Subject: [PATCH] arm64: Add part number for Arm Cortex-A78AE

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

diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index 232b439cbaf3..ff8f4511df71 100644
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
@@ -130,6 +131,7 @@
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

