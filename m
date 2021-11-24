Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D85A45D0CF
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 00:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352505AbhKXXIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 18:08:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352523AbhKXXIp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 18:08:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C58D16109E;
        Wed, 24 Nov 2021 23:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637795135;
        bh=mnGXAbde7bv9s77M2kaMmCNB4AZ0YUwUuyc64ZGDIUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWzqOVbRQ0S6yIzgDkXqyiquxTnTr3gRYPZEDlIdv5hC3oIi1eTLtDiTGI+3LWrgt
         7MDyJiENpWGNdivjY/q5N4TalqCmAWR6PCPXpMFKb0ablMcZYa0G9G9PYUSgwqEURw
         1PD0nVP5Oq41eLWjKNu6SzrSMk+lTri82hRFspcT3kVwEx8i7ioO8c8t/tASH7AKv7
         Q9pD+TaROplscfEM2aMGI6ek8caVx0qkpbL1K9LYIUIJ5PLSpaYFMOa9RMz3Hv7eoy
         d0gD1yajE+eGN1B5XPMHkgNUdkHs4Ih69l5zHrMMwFy9VPeRhUb9ac0rJbINolkXZF
         p5aHpGgYUFbRQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.19 17/20] pinctrl: armada-37xx: add missing pin: PCIe1 Wakeup
Date:   Thu, 25 Nov 2021 00:04:57 +0100
Message-Id: <20211124230500.27109-18-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124230500.27109-1-kabel@kernel.org>
References: <20211124230500.27109-1-kabel@kernel.org>
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
index cf678ac22a95..adfb1d0d58dd 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -198,6 +198,7 @@ static struct armada_37xx_pin_group armada_37xx_sb_groups[] = {
 	PIN_GRP_GPIO("smi", 18, 2, BIT(4), "smi"),
 	PIN_GRP_GPIO("pcie1", 3, 1, BIT(5), "pcie"),
 	PIN_GRP_GPIO("pcie1_clkreq", 4, 1, BIT(9), "pcie"),
+	PIN_GRP_GPIO("pcie1_wakeup", 5, 1, BIT(10), "pcie"),
 	PIN_GRP_GPIO("ptp", 20, 3, BIT(11) | BIT(12) | BIT(13), "ptp"),
 	PIN_GRP("ptp_clk", 21, 1, BIT(6), "ptp", "mii"),
 	PIN_GRP("ptp_trig", 22, 1, BIT(7), "ptp", "mii"),
-- 
2.32.0

