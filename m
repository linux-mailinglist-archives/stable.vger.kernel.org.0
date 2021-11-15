Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CDE450C54
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237458AbhKORh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:37:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238181AbhKORdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:33:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 103546320D;
        Mon, 15 Nov 2021 17:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996910;
        bh=xnVOSpaJW6cSr7E6hQe7CuIDHJhYbj57Ev7vPPZ7gyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v55apZhaOQ9yjxMfCU8d8gd0RBtB/QU3FoWDtT7QtD6L1Bf1eziTAJZ4cAKvuYYaA
         KkfigtCu4/wYXwwFp8Paruxik2BEoW9S/4YxSN5SGU3AkHm7FELG2tqx62DxcpR4wN
         2QYXTgU9jAwuTDFc4gC/NLngU8FcDJftREwSz3D8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 280/355] ASoC: cs42l42: Correct some register default values
Date:   Mon, 15 Nov 2021 18:03:24 +0100
Message-Id: <20211115165322.790631812@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
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
index 6825e874785f2..710b43205ea05 100644
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



