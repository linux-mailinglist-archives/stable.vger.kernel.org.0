Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B303EE11C
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 02:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236509AbhHQAgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 20:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235945AbhHQAg3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E33C460240;
        Tue, 17 Aug 2021 00:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160556;
        bh=nMryLALSi7yP68Vb4DKGbdjHVlWFnxFDeXBuYmU90kg=;
        h=From:To:Cc:Subject:Date:From;
        b=pBphr/dnRobd9hFg2AurQqXz3xExYkQ9n+8duy1MdGLi8BogYMCHLcE3NXRDLE0Rc
         Xv9wPvtYE2zyegW6iTimuUNBR80iSJXTP/Lnq9aI/KsucF/y0MHJwTjgrejNu/23fS
         vaRUcoRKkgG5P3sQb43n8PE2Mx9472huSe7NGVwrICMQ89jFWeC2reco9WIH6C/Eqy
         Z7fLq/onWVR7EKxXPDXH/dio456vMuOP5Ol3bzpcakZ7wuXknMBHh1Ul5jlovab+f+
         UjcxjHa15jrJtb+eDJyDOhLLbySqNgag91t+VMPq3BL/QuUpTxuqJTPbcwGv9bD8R9
         ZrtKNN0J3tFRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Derek Fang <derek.fang@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 1/9] ASoC: rt5682: Adjust headset volume button threshold
Date:   Mon, 16 Aug 2021 20:35:46 -0400
Message-Id: <20210817003554.83213-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Derek Fang <derek.fang@realtek.com>

[ Upstream commit 6d20bf7c020f417fdef1810a22da17c126603472 ]

Adjust the threshold of headset button volume+ to fix
the wrong button detection issue with some brand headsets.

Signed-off-by: Derek Fang <derek.fang@realtek.com>
Link: https://lore.kernel.org/r/20210721133121.12333-1-derek.fang@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index 2e41b8c169e5..0486b1469799 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -44,6 +44,7 @@ static const struct reg_sequence patch_list[] = {
 	{RT5682_I2C_CTRL, 0x000f},
 	{RT5682_PLL2_INTERNAL, 0x8266},
 	{RT5682_SAR_IL_CMD_3, 0x8365},
+	{RT5682_SAR_IL_CMD_6, 0x0180},
 };
 
 void rt5682_apply_patch_list(struct rt5682_priv *rt5682, struct device *dev)
-- 
2.30.2

