Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEAC3FDBE7
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344681AbhIAMpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:45:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345279AbhIAMmz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:42:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F09BC61208;
        Wed,  1 Sep 2021 12:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499894;
        bh=JaVsE/qfaG5QwU8mhxxYf4ZmaSlkCE/lnVpo/qNCLtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jr4ntMkg5ipVUr6INq9dEkzjQM+TIEiOGYPjfOKLFZP3SY6I5NXHlQ5t7sIF4zdtH
         CN2gIqbaBxZngPjeDQtQfT/FHxJ86G+qL49jD7/DkrsUPOfAIDUSWHRNzfeRuEwmR5
         osREptUXvm5KJdG0vmTBeosALCUvlEBmDpAl44Oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Derek Fang <derek.fang@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 003/113] ASoC: rt5682: Adjust headset volume button threshold
Date:   Wed,  1 Sep 2021 14:27:18 +0200
Message-Id: <20210901122302.093851934@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122301.984263453@linuxfoundation.org>
References: <20210901122301.984263453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index abcd6f483788..51ecaa2abcd1 100644
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



