Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8243C4F78
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243598AbhGLH0E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:26:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240231AbhGLHXF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:23:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FC54611AF;
        Mon, 12 Jul 2021 07:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074417;
        bh=npUCgBotvC7g50sxRQ8mv5F5Iv7WgH9ZXNco0MCndDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0DcSNCOoUZaa04qym04VSTOuFCzJp34Dr9llX24ewDQmA4nVW9fAduFZ8pilhFhaB
         9HFWagpuEXmFa8y3yj+95nPvhcbZwmJo5P92k35vNUTVez/9G8/4Kwyb9ELxkSIjBY
         ot6FXuFqnvv0vmSL4ojrwIABiZpN9F22blrlG5AM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 571/700] leds: lm3532: select regmap I2C API
Date:   Mon, 12 Jul 2021 08:10:54 +0200
Message-Id: <20210712061036.838936292@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index b6742b4231bf..258247dd5e3d 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -199,6 +199,7 @@ config LEDS_LM3530
 
 config LEDS_LM3532
 	tristate "LCD Backlight driver for LM3532"
+	select REGMAP_I2C
 	depends on LEDS_CLASS
 	depends on I2C
 	help
-- 
2.30.2



