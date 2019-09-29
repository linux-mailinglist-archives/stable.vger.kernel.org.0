Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E53B8C1791
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 19:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730618AbfI2Rfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 13:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729743AbfI2Rfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 13:35:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F75E21A4C;
        Sun, 29 Sep 2019 17:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569778538;
        bh=WrghAeNzTGmbheaQre+L1DgLavNEbOtJ9RxrZY3iou0=;
        h=From:To:Cc:Subject:Date:From;
        b=pIakAgD8Pb9xS8xa+H8ICaidsZRsjPUXVxwhxvFW9tl2Q85WuBPQgFrj0DPhtl9gI
         sv3XQW8XOYFIqDQxpmsj2zXB+THdqSwjGuIryJMF9vRnsflqQI0ZazsG+cRwRyocRl
         PbSndnY3hbQHxNTvS/FjpnjU7MHInDMdj69fxUKY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Mathieu Malaterre <malat@debian.org>,
        Artur Rojek <contact@artur-rojek.eu>,
        Stephen Boyd <sboyd@kernel.org>, Rob Herring <robh@kernel.org>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Turquette <mturquette@baylibre.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-clk@vger.kernel.org, od@zcrc.me,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 01/23] clk: jz4740: Add TCU clock
Date:   Sun, 29 Sep 2019 13:35:11 -0400
Message-Id: <20190929173535.9744-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 73dd11dc1a883d4c994d729dc9984f4890001157 ]

Add the missing TCU clock to the list of clocks supplied by the CGU for
the JZ4740 SoC.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Tested-by: Mathieu Malaterre <malat@debian.org>
Tested-by: Artur Rojek <contact@artur-rojek.eu>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-mips@vger.kernel.org
Cc: linux-clk@vger.kernel.org
Cc: od@zcrc.me
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ingenic/jz4740-cgu.c       | 6 ++++++
 include/dt-bindings/clock/jz4740-cgu.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/clk/ingenic/jz4740-cgu.c b/drivers/clk/ingenic/jz4740-cgu.c
index 32fcc75f6f77e..216ba051e743c 100644
--- a/drivers/clk/ingenic/jz4740-cgu.c
+++ b/drivers/clk/ingenic/jz4740-cgu.c
@@ -211,6 +211,12 @@ static const struct ingenic_cgu_clk_info jz4740_cgu_clocks[] = {
 		.parents = { JZ4740_CLK_EXT, -1, -1, -1 },
 		.gate = { CGU_REG_CLKGR, 5 },
 	},
+
+	[JZ4740_CLK_TCU] = {
+		"tcu", CGU_CLK_GATE,
+		.parents = { JZ4740_CLK_EXT, -1, -1, -1 },
+		.gate = { CGU_REG_CLKGR, 1 },
+	},
 };
 
 static void __init jz4740_cgu_init(struct device_node *np)
diff --git a/include/dt-bindings/clock/jz4740-cgu.h b/include/dt-bindings/clock/jz4740-cgu.h
index 6ed83f926ae71..e82d77028581a 100644
--- a/include/dt-bindings/clock/jz4740-cgu.h
+++ b/include/dt-bindings/clock/jz4740-cgu.h
@@ -34,5 +34,6 @@
 #define JZ4740_CLK_ADC		19
 #define JZ4740_CLK_I2C		20
 #define JZ4740_CLK_AIC		21
+#define JZ4740_CLK_TCU		22
 
 #endif /* __DT_BINDINGS_CLOCK_JZ4740_CGU_H__ */
-- 
2.20.1

