Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E9D348EF7
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhCYLZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229995AbhCYLZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D2B161A31;
        Thu, 25 Mar 2021 11:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671512;
        bh=tAEjqiSX6Lb3sxqxz8r37CrpsMzMrA8zNPjQEDrHp9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BtJgN+pZoB+LOE69475vvCYrQAVSszxBTpST5cy9jDCbhy89yMXf1uChoLilgAlab
         IiV1b3P6oI10EqPFAHVxLRF2S2kKYGrQADvYXUH5C/ZidCdywjOmX/9d1y3V2+fpET
         9iP0Aq4j1IvAmgJ6SJP9VukE8dTqvmjJ5kNIGCa1RDR5sBWJ7+ajIYUWFxmwyltG7/
         booD2ES/02sx4X63tM99ObijkO8wSQIwwLUQSxS6pyxU8v5g4GoKQzbTsvfSlts2Nc
         M39EezeYGBYW6UJwy4JxLRdEvZAQQgIMxtDhuHzQ888DfPVxdH/LHZKSEgkjnw8pe8
         1/0nUGuJyPdpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Yu <jack.yu@realtek.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.11 09/44] ASoC: rt1015: fix i2c communication error
Date:   Thu, 25 Mar 2021 07:24:24 -0400
Message-Id: <20210325112459.1926846-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit 9e0bdaa9fcb8c64efc1487a7fba07722e7bc515e ]

Remove 0x100 cache re-sync to solve i2c communication error.

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://lore.kernel.org/r/20210222090057.29532-1-jack.yu@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1015.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/rt1015.c b/sound/soc/codecs/rt1015.c
index 32e6bcf763d1..4607039a16e7 100644
--- a/sound/soc/codecs/rt1015.c
+++ b/sound/soc/codecs/rt1015.c
@@ -209,6 +209,7 @@ static bool rt1015_volatile_register(struct device *dev, unsigned int reg)
 	case RT1015_VENDOR_ID:
 	case RT1015_DEVICE_ID:
 	case RT1015_PRO_ALT:
+	case RT1015_MAN_I2C:
 	case RT1015_DAC3:
 	case RT1015_VBAT_TEST_OUT1:
 	case RT1015_VBAT_TEST_OUT2:
-- 
2.30.1

