Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACDB7450E7D
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240098AbhKOSPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:15:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:49944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240251AbhKOSH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:07:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F7B861AAA;
        Mon, 15 Nov 2021 17:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998236;
        bh=U0c9k/qrcvx5RXUay2VEnf+w919Maj0xL4chiNYBK+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hyc27xBgrj14Udlh/qfE0uYlBhh/cGEzaHH3Cbq0XiQHVlSQx0L5yjbUo26j1sYMZ
         rCV9gORo/EVLAWXgSYBl+zzO5JunHVbdEjIqCHJ4ub/cCPOIi1gyQc3MvJ3v0JXaTA
         D/uwQhZAX5Dse1V5Fwpi+/g+xY8otN/U1s2aTv04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 438/575] ASoC: cs42l42: Correct some register default values
Date:   Mon, 15 Nov 2021 18:02:43 +0100
Message-Id: <20211115165358.915461947@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 828dc78202e8b..8e44d0f34194e 100644
--- a/sound/soc/codecs/cs42l42.c
+++ b/sound/soc/codecs/cs42l42.c
@@ -91,7 +91,7 @@ static const struct reg_default cs42l42_reg_defaults[] = {
 	{ CS42L42_ASP_RX_INT_MASK,		0x1F },
 	{ CS42L42_ASP_TX_INT_MASK,		0x0F },
 	{ CS42L42_CODEC_INT_MASK,		0x03 },
-	{ CS42L42_SRCPL_INT_MASK,		0xFF },
+	{ CS42L42_SRCPL_INT_MASK,		0x7F },
 	{ CS42L42_VPMON_INT_MASK,		0x01 },
 	{ CS42L42_PLL_LOCK_INT_MASK,		0x01 },
 	{ CS42L42_TSRS_PLUG_INT_MASK,		0x0F },
@@ -128,7 +128,7 @@ static const struct reg_default cs42l42_reg_defaults[] = {
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



