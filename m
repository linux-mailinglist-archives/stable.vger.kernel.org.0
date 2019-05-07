Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C31D15C03
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 08:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbfEGF74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726949AbfEGFgh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:36:37 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64A1620B7C;
        Tue,  7 May 2019 05:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207397;
        bh=dtxVRlW6Z/Ecgilwcz3UsI4vc79zq4ii/093dHgzIN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ETJVvg1+Zv2duBEc+bU7t+ZvZb6JENmyLUtyLsTKTRPTmrYY/cbTaPdp4COIXtRoE
         WEZJXn6J/spzDO2Ak5BLZI8TxfiRZF128VYtFCc7FjX/W+xx+73fIBKf4iUm0feZJb
         IMz5N6hO8gqQfCrMLulkHPw+D651GxpjWTjCthrQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 21/81] clocksource/drivers/npcm: select TIMER_OF
Date:   Tue,  7 May 2019 01:34:52 -0400
Message-Id: <20190507053554.30848-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 99834eead2a04e93a120abb112542b87c42ff5e1 ]

When this is disabled, we get a link failure:

drivers/clocksource/timer-npcm7xx.o: In function `npcm7xx_timer_init':
timer-npcm7xx.c:(.init.text+0xf): undefined reference to `timer_of_init'

Fixes: 1c00289ecd12 ("clocksource/drivers/npcm: Add NPCM7xx timer driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index c1ddafa4c299..4d37f018d846 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -136,6 +136,7 @@ config VT8500_TIMER
 config NPCM7XX_TIMER
 	bool "NPCM7xx timer driver" if COMPILE_TEST
 	depends on HAS_IOMEM
+	select TIMER_OF
 	select CLKSRC_MMIO
 	help
 	  Enable 24-bit TIMER0 and TIMER1 counters in the NPCM7xx architecture,
-- 
2.20.1

