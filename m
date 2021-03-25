Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9D5348F56
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhCYL1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:27:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230476AbhCYL0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:26:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BE0461A58;
        Thu, 25 Mar 2021 11:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671571;
        bh=C2JhNr3EpRjgctxfTTCNtDfVHZHunRTxMC5fatgR2VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGhxV/GovUhgVVJNb8VHmbZfAkwDbmjEMLDxHyOw2q80Esp6ErKMYN+KgO+yKpTsS
         SKDIzPwEAsExwFsQemNMpy4WX0jvTrfai7dFd1Sl9+1mod4wLO7r8Shg4LCrbRyojT
         ArjuKy+sl6hyLDAERYodwxcrTE12UdcyLSnA2hKlKknvpp7du1PQ3hWtFg8mhkSq5b
         T1jAyV0KIPGF3qSLudY+fudkoQ8cttN8XcaF7/HOKGPj6pUVeCbOGAmCDPCC6oXM2Z
         Bd1Au2hZriI0rCJwmmcayWWQz98cLiTEGZ+08nm8lkpOtgesWLslB/dX8zQYuzk7pO
         fR/IspnB/8QJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Yu <jack.yu@realtek.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, alsa-devel@alsa-project.org
Subject: [PATCH AUTOSEL 5.10 09/39] ASoC: rt1015: fix i2c communication error
Date:   Thu, 25 Mar 2021 07:25:28 -0400
Message-Id: <20210325112558.1927423-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112558.1927423-1-sashal@kernel.org>
References: <20210325112558.1927423-1-sashal@kernel.org>
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
index 3db07293c70b..2627910060dc 100644
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

