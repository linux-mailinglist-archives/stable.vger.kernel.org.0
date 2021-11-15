Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB5F451F28
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355655AbhKPAih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344405AbhKOTYi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C41A663486;
        Mon, 15 Nov 2021 18:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002632;
        bh=nIJblir7rE06TMQ8RIZS2ySMwjT52tF1fC1T68vsxY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGM4UCA+rQv9D22cujDqR4ixlIvRLjECSGcTVCPj6Uc+OWz56QTgy2uOTAhLeYGI/
         He+kBWGn9qyFYXawO8zJ6daN4Z6Fgyqxvx9e9aETlTzamWu5SROny61pcVST6mSowq
         y+nUiTqrbX/bIUPfwzJGbe8qVVyw58wFwGMMnaFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 641/917] ASoC: cs42l42: Correct some register default values
Date:   Mon, 15 Nov 2021 18:02:16 +0100
Message-Id: <20211115165450.575075429@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit d591d4b32aa9552af14a0c7c586a2d3fe9ecc6e0 ]

Some registers had wrong default values in cs42l42_reg_defaults[].

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 2c394ca79604 ("ASoC: Add support for CS42L42 codec")
Link: https://lore.kernel.org/r/20211015133619.4698-4-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l42.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs42l42.c b/sound/soc/codecs/cs42l42.c
index 4548dae7ed834..205f81d27c30f 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -93,7 +93,7 @@ static const struct reg_default cs42l42_reg_defaults[] = {
 	{ CS42L42_ASP_RX_INT_MASK,		0x1F },
 	{ CS42L42_ASP_TX_INT_MASK,		0x0F },
 	{ CS42L42_CODEC_INT_MASK,		0x03 },
-	{ CS42L42_SRCPL_INT_MASK,		0xFF },
+	{ CS42L42_SRCPL_INT_MASK,		0x7F },
 	{ CS42L42_VPMON_INT_MASK,		0x01 },
 	{ CS42L42_PLL_LOCK_INT_MASK,		0x01 },
 	{ CS42L42_TSRS_PLUG_INT_MASK,		0x0F },
@@ -130,7 +130,7 @@ static const struct reg_default cs42l42_reg_defaults[] = {
 	{ CS42L42_MIXER_CHA_VOL,		0x3F },
 	{ CS42L42_MIXER_ADC_VOL,		0x3F },
 	{ CS42L42_MIXER_CHB_VOL,		0x3F },
-	{ CS42L42_EQ_COEF_IN0,			0x22 },
+	{ CS42L42_EQ_COEF_IN0,			0x00 },
 	{ CS42L42_EQ_COEF_IN1,			0x00 },
 	{ CS42L42_EQ_COEF_IN2,			0x00 },
 	{ CS42L42_EQ_COEF_IN3,			0x00 },
-- 
2.33.0



