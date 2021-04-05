Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C307A353EBD
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238403AbhDEJHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238326AbhDEJHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:07:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6172613B8;
        Mon,  5 Apr 2021 09:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613645;
        bh=C2JhNr3EpRjgctxfTTCNtDfVHZHunRTxMC5fatgR2VQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=STuBsSYWqW5CpdEIuUZnkcmEYWTuP7J9mRdZJliZGVLiTAQ3W/f0rNXQiBv0m1qV5
         zllGdJnaRjU/wl3C4jCkdse+NUnSskb3B3CTNEELTYlrJsanvUwNxxfGbcXllpd+1D
         9SNmb23mZfivuwpGsHbrmaPUJxeJcXxsVKSM3rPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Yu <jack.yu@realtek.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/126] ASoC: rt1015: fix i2c communication error
Date:   Mon,  5 Apr 2021 10:52:51 +0200
Message-Id: <20210405085031.348026595@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



