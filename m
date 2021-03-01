Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6DF3286B1
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:16:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237780AbhCARNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:13:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:37784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237441AbhCARIR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:08:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8D8064F85;
        Mon,  1 Mar 2021 16:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616866;
        bh=IW0eJmTmIhXMzp2PdAZ5XWZFW8YOEUKnhrk6ACVeSuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xGw6C8zr2cIXDrDzlZP26gt0T5wfs8s+Wf2XTd/gCFIks6mND5PKPT/Wymd3nl0sz
         G2jywmINaaru4h9OC0IIgrU/QHYbYP8wmT4FQOA2i4yh7BzFcQJacNJTl7wBbN25g+
         kW/vdOd4BzDy0M3Ux2AfPtnfHwf7Cb6rdQsAUX6Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 121/247] rtc: s5m: select REGMAP_I2C
Date:   Mon,  1 Mar 2021 17:12:21 +0100
Message-Id: <20210301161037.603322841@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

[ Upstream commit 1f0cbda3b452b520c5f3794f8f0e410e8bc7386a ]

The rtc-s5m uses the I2C regmap but doesn't select it in Kconfig so
depending on the configuration the build may fail. Fix it.

Fixes: 959df7778bbd ("rtc: Enable compile testing for Maxim and Samsung drivers")
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210114102219.23682-2-brgl@bgdev.pl
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 28a4505a1bc82..b5845f16a3a26 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -639,6 +639,7 @@ config RTC_DRV_S5M
 	tristate "Samsung S2M/S5M series"
 	depends on MFD_SEC_CORE || COMPILE_TEST
 	select REGMAP_IRQ
+	select REGMAP_I2C
 	help
 	  If you say yes here you will get support for the
 	  RTC of Samsung S2MPS14 and S5M PMIC series.
-- 
2.27.0



