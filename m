Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBCF3C46FF
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbhGLGaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235726AbhGLG3a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2697611CD;
        Mon, 12 Jul 2021 06:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071142;
        bh=d1Wj6Oyrtrrz+Ob46oWHxY/mC7y/NzeBdxbCS7iSVrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtHY9uYdowBwftHrQccKPzAoXlXBQ5dm/30S5gcz0iZrVvHQptLlzqsPKzqOmviTP
         v3kZdqliN2Y3ngiWOIIO7WmTGTXpsJlY0SXsG4HKE3WcMdjHQ06VLo/HmyJ8Lc1ZWM
         v7SrAdCx2ziqYv27R3CriNsaJhSuIzAULgRj+MYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 291/348] leds: lm3532: select regmap I2C API
Date:   Mon, 12 Jul 2021 08:11:15 +0200
Message-Id: <20210712060742.269265455@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>

[ Upstream commit 99be74f61cb0292b518f5e6d7e5c6611555c2ec7 ]

Regmap APIs should be selected, otherwise link can fail

ERROR: modpost: "__devm_regmap_init_i2c" [drivers/leds/leds-lm3532.ko] undefined!

Fixes: bc1b8492c764 ("leds: lm3532: Introduce the lm3532 LED driver")
Cc: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index 1988de1d64c0..2cbf66d1c300 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -144,6 +144,7 @@ config LEDS_LM3530
 
 config LEDS_LM3532
 	tristate "LCD Backlight driver for LM3532"
+	select REGMAP_I2C
 	depends on LEDS_CLASS
 	depends on I2C
 	help
-- 
2.30.2



