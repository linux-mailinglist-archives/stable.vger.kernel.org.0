Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E934A4EE085
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 20:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbiCaSgV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 14:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234783AbiCaSgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 14:36:20 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06A9663BD2;
        Thu, 31 Mar 2022 11:34:33 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4B251596;
        Thu, 31 Mar 2022 11:34:32 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2731D3F718;
        Thu, 31 Mar 2022 11:34:32 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     james.morse@arm.com, catalin.marinas@arm.com
Subject: [stable:PATCH v4.14.274 04/27] arm64: Make ARM64_ERRATUM_1188873 depend on COMPAT
Date:   Thu, 31 Mar 2022 19:33:37 +0100
Message-Id: <20220331183400.73183-5-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220331183400.73183-1-james.morse@arm.com>
References: <20220331183400.73183-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <marc.zyngier@arm.com>

commit c2b5bba3967a000764e9148e6f020d776b7ecd82 upstream.

Since ARM64_ERRATUM_1188873 only affects AArch32 EL0, it makes some
sense that it should depend on COMPAT.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7c205e0fd44b..729384f19c7f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -461,6 +461,7 @@ config ARM64_ERRATUM_1024718
 config ARM64_ERRATUM_1188873
 	bool "Cortex-A76: MRC read following MRRC read of specific Generic Timer in AArch32 might give incorrect result"
 	default y
+	depends on COMPAT
 	select ARM_ARCH_TIMER_OOL_WORKAROUND
 	help
 	  This option adds work arounds for ARM Cortex-A76 erratum 1188873
-- 
2.30.2

