Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B34613E7EA
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392630AbgAPR2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:28:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:40254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392682AbgAPR2w (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:28:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B84C8246E8;
        Thu, 16 Jan 2020 17:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195732;
        bh=wp8H6JrP5r7Xu478e+qmlSSOd3BEKvsKmv9Oq1SZ05c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G29w+FI3OaFUaIAQ4BncKp3AsyDqEEI+KfgpuY4WdL0MZhwLgOLJx4ve2IBhlsec8
         sHicx6vpsyGs/S2K3obNMA5zyH92tygbRCu+6Kr3nDwkKTqHDBy5G1tu4Eec0Wu9OK
         i0hUOG9xyfitbDrMKjj3GTN8KbHM+w4XmdL75iHw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 271/371] ASoC: sun4i-i2s: RX and TX counter registers are swapped
Date:   Thu, 16 Jan 2020 12:22:23 -0500
Message-Id: <20200116172403.18149-214-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime.ripard@bootlin.com>

[ Upstream commit cf2c0e1ce9544df42170fb921f12da82dc0cc8d6 ]

The RX and TX counters registers offset have been swapped, fix that.

Fixes: fa7c0d13cb26 ("ASoC: sunxi: Add Allwinner A10 Digital Audio driver")
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Link: https://lore.kernel.org/r/8b26477560ad5fd8f69e037b167c5e61de5c26a3.1566242458.git-series.maxime.ripard@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sunxi/sun4i-i2s.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sunxi/sun4i-i2s.c b/sound/soc/sunxi/sun4i-i2s.c
index da0a2083e12a..d2802fd8c1dd 100644
--- a/sound/soc/sunxi/sun4i-i2s.c
+++ b/sound/soc/sunxi/sun4i-i2s.c
@@ -80,8 +80,8 @@
 #define SUN4I_I2S_CLK_DIV_MCLK_MASK		GENMASK(3, 0)
 #define SUN4I_I2S_CLK_DIV_MCLK(mclk)			((mclk) << 0)
 
-#define SUN4I_I2S_RX_CNT_REG		0x28
-#define SUN4I_I2S_TX_CNT_REG		0x2c
+#define SUN4I_I2S_TX_CNT_REG		0x28
+#define SUN4I_I2S_RX_CNT_REG		0x2c
 
 #define SUN4I_I2S_TX_CHAN_SEL_REG	0x30
 #define SUN4I_I2S_CHAN_SEL(num_chan)		(((num_chan) - 1) << 0)
-- 
2.20.1

