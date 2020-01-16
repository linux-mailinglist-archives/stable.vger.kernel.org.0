Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7D4113F434
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389385AbgAPSsF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:48:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389765AbgAPRJw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:09:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E64FB2081E;
        Thu, 16 Jan 2020 17:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194591;
        bh=UPItCjmuo8SP4QHmFAW1NxhRC4SPqP7urVkVKQ4r+5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cRVrXFiRwPptZ6TDJZLDKVWUB6igv8gwBavagG5brF4rhrABcVHoHaZm9pCSu/gEh
         0udCxi1F+M9TCso/Mt4bceJ+dwHwm4oRAn95DHvpkejmKqfOBUPblu0BmXq+pYeOKt
         b3Wn34tVMcUFiQ/Wgu0Mg32gaA8GKSGemHO6iwRY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH AUTOSEL 4.19 462/671] ARM: stm32: use "depends on" instead of "if" after prompt
Date:   Thu, 16 Jan 2020 12:01:40 -0500
Message-Id: <20200116170509.12787-199-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <yamada.masahiro@socionext.com>

[ Upstream commit 7e8a0f10899075ac2665c78c4e49dbaf32bf3346 ]

This appeared after the global fixups by commit e32465429490 ("ARM: use
"depends on" for SoC configs instead of "if" after prompt"). Fix it now.

Link: https://lore.kernel.org/r/20190710051320.8738-1-yamada.masahiro@socionext.com
Fixes: e32465429490 ("ARM: use "depends on" for SoC configs instead of "if" after prompt")
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-stm32/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-stm32/Kconfig b/arch/arm/mach-stm32/Kconfig
index 713c068b953f..adca4368d67c 100644
--- a/arch/arm/mach-stm32/Kconfig
+++ b/arch/arm/mach-stm32/Kconfig
@@ -1,5 +1,6 @@
 menuconfig ARCH_STM32
-	bool "STMicroelectronics STM32 family" if ARM_SINGLE_ARMV7M || ARCH_MULTI_V7
+	bool "STMicroelectronics STM32 family"
+	depends on ARM_SINGLE_ARMV7M || ARCH_MULTI_V7
 	select ARMV7M_SYSTICK if ARM_SINGLE_ARMV7M
 	select HAVE_ARM_ARCH_TIMER if ARCH_MULTI_V7
 	select ARM_GIC if ARCH_MULTI_V7
-- 
2.20.1

