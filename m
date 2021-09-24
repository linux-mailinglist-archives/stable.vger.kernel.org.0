Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC8B417507
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346267AbhIXNOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346604AbhIXNLC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:11:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AF60610CF;
        Fri, 24 Sep 2021 12:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488303;
        bh=XpQUfQy7ZtNzfvjjkjz0CwgSNfXeEp8Pk0BzxNT3NvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HW8D7cWYk08lhQDA3djrbweHs1O41onbrFV56S892ARy3S5MTM0g2Qui3hdVk+DA/
         qSi4sF4/gdlKwvthoULa6u1X+rg3mYgpv4ID5yRGfDJzy9q0ogEPO775B/5IXP66sH
         WqELwZNwho3LwzNNG1+hJ2LGja1Yi9O6Hz8iRdWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu-Tung Chang <mtwget@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 61/63] rtc: rx8010: select REGMAP_I2C
Date:   Fri, 24 Sep 2021 14:45:01 +0200
Message-Id: <20210924124336.359915887@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu-Tung Chang <mtwget@gmail.com>

[ Upstream commit 0c45d3e24ef3d3d87c5e0077b8f38d1372af7176 ]

The rtc-rx8010 uses the I2C regmap but doesn't select it in Kconfig so
depending on the configuration the build may fail. Fix it.

Signed-off-by: Yu-Tung Chang <mtwget@gmail.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210830052532.40356-1-mtwget@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 33e4ecd6c665..54cf5ec8f401 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -624,6 +624,7 @@ config RTC_DRV_FM3130
 
 config RTC_DRV_RX8010
 	tristate "Epson RX8010SJ"
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for the Epson RX8010SJ RTC
 	  chip.
-- 
2.33.0



