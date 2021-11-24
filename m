Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEBB45D079
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352274AbhKXWxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352321AbhKXWxd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:53:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48678610A7;
        Wed, 24 Nov 2021 22:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794222;
        bh=1/WUQ5k+HYZ/31X2CQ+QaOq8FCcJ66BRptYxKusxpxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuK7Yh/DsDxDKyORH1tuGcMaPQzvnJn7ro5R4RexJcVWkayAp7f9TGRUJ4qcoisw0
         Dna3pZIyJHIvmy2fTYBrmM9TZp564XmDXCugMa85hlBuka/CyGrSMHZ0sLf1Xybj7X
         M5V0OB7WGs/XZ8+QHmJlt6U/ywzR0hwQro1Luzm7x3IJOHeiSJyhEoO3GTBBGD4P5L
         CBpJq3lEP1uZJCDCUsIJNAUuItz2ZpRaSbFJu9xBxAvaBVcPy+Ev1BLywlGru7LwnC
         DMbo/M3sl9Lsv4EqhWoiB7DZnuq6k06GK7fsSJz+gzfYeCsrfz285HKnJz+N8g0Nt3
         l+HiZAWV06X9Q==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 21/24] pinctrl: armada-37xx: add missing pin: PCIe1 Wakeup
Date:   Wed, 24 Nov 2021 23:49:30 +0100
Message-Id: <20211124224933.24275-22-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124224933.24275-1-kabel@kernel.org>
References: <20211124224933.24275-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gregory CLEMENT <gregory.clement@bootlin.com>

commit 4d98fbaacd79a82f408febb66a9c42fe42361b16 upstream.

Declare the PCIe1 Wakeup which was initially missing.

Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Tested-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 4b4fd4661268..a58367909455 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -185,6 +185,7 @@ static struct armada_37xx_pin_group armada_37xx_sb_groups[] = {
 	PIN_GRP_GPIO("smi", 18, 2, BIT(4), "smi"),
 	PIN_GRP_GPIO("pcie1", 3, 1, BIT(5), "pcie"),
 	PIN_GRP_GPIO("pcie1_clkreq", 4, 1, BIT(9), "pcie"),
+	PIN_GRP_GPIO("pcie1_wakeup", 5, 1, BIT(10), "pcie"),
 	PIN_GRP_GPIO("ptp", 20, 3, BIT(11) | BIT(12) | BIT(13), "ptp"),
 	PIN_GRP("ptp_clk", 21, 1, BIT(6), "ptp", "mii"),
 	PIN_GRP("ptp_trig", 22, 1, BIT(7), "ptp", "mii"),
-- 
2.32.0

