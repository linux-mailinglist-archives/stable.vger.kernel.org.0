Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2066255FFE
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 05:44:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfFZDoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 23:44:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726756AbfFZDoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 23:44:10 -0400
Received: from sasha-vm.mshome.net (mobile-107-77-172-98.mobile.att.net [107.77.172.98])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CB5020659;
        Wed, 26 Jun 2019 03:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561520649;
        bh=L7CXI+xo7ES4DhQ3F7635D6a/g88+0+Xx0Fty0LNODw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=io0XUkpfnNoVvTkEi0DI7Bg4aUilOLN7hj28E3tF8XFHvb0ddX+eYlhBLaG1INxVh
         faAoA4WlfLedktT9qjo7dtGB8zyiVpxiWs57phzmpX/JBSRVlZ6WtJATYanye/iZS5
         5uLTOsz7V8TYm1pXx3CRRo3PPVBfxLRZf8zJW+es=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcus Cooper <codekipper@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 14/34] ASoC: sun4i-i2s: Fix sun8i tx channel offset mask
Date:   Tue, 25 Jun 2019 23:43:15 -0400
Message-Id: <20190626034335.23767-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626034335.23767-1-sashal@kernel.org>
References: <20190626034335.23767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcus Cooper <codekipper@gmail.com>

[ Upstream commit 7e46169a5f35762f335898a75d1b8a242f2ae0f5 ]

Although not causing any noticeable issues, the mask for the
channel offset is covering too many bits.

Signed-off-by: Marcus Cooper <codekipper@gmail.com>
Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sunxi/sun4i-i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sunxi/sun4i-i2s.c b/sound/soc/sunxi/sun4i-i2s.c
index a4aa931ebfae..5750738b6ac0 100644
--- a/sound/soc/sunxi/sun4i-i2s.c
+++ b/sound/soc/sunxi/sun4i-i2s.c
@@ -110,7 +110,7 @@
 
 #define SUN8I_I2S_TX_CHAN_MAP_REG	0x44
 #define SUN8I_I2S_TX_CHAN_SEL_REG	0x34
-#define SUN8I_I2S_TX_CHAN_OFFSET_MASK		GENMASK(13, 11)
+#define SUN8I_I2S_TX_CHAN_OFFSET_MASK		GENMASK(13, 12)
 #define SUN8I_I2S_TX_CHAN_OFFSET(offset)	(offset << 12)
 #define SUN8I_I2S_TX_CHAN_EN_MASK		GENMASK(11, 4)
 #define SUN8I_I2S_TX_CHAN_EN(num_chan)		(((1 << num_chan) - 1) << 4)
-- 
2.20.1

