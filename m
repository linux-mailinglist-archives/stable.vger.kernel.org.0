Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 415BACD5D0
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730269AbfJFRkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730262AbfJFRkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:40:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94FEA2053B;
        Sun,  6 Oct 2019 17:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383603;
        bh=PnbnIcgZjtEdYqUlBBBWYErDr6FSx8IYXnn0vmGA5PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6r/1mPbvmIR2ggNjRx//96bi0qTacFDDqAqCSZmDyeCv7CcM+RL4ldKOfDg8bV2p
         J8CU25WMEVM/Qf1Qk09HxnY1hZCgkh4kg2keCGjlamd6V3dfmCDHNsOYBp69txMOzu
         mqK5YxuFdlMy9tbYM5IJoHt9uQEjhHumQ0ZspBcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Icenowy Zheng <icenowy@aosc.io>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 027/166] clk: sunxi-ng: v3s: add missing clock slices for MMC2 module clocks
Date:   Sun,  6 Oct 2019 19:19:53 +0200
Message-Id: <20191006171215.381887646@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Icenowy Zheng <icenowy@aosc.io>

[ Upstream commit 720099603d1f62e37b789366d7e89824b009ca28 ]

The MMC2 clock slices are currently not defined in V3s CCU driver, which
makes MMC2 not working.

Fix this issue.

Fixes: d0f11d14b0bc ("clk: sunxi-ng: add support for V3s CCU")
Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
index 9b3939fc7faa6..5ca4d34b4094f 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
@@ -502,6 +502,9 @@ static struct clk_hw_onecell_data sun8i_v3s_hw_clks = {
 		[CLK_MMC1]		= &mmc1_clk.common.hw,
 		[CLK_MMC1_SAMPLE]	= &mmc1_sample_clk.common.hw,
 		[CLK_MMC1_OUTPUT]	= &mmc1_output_clk.common.hw,
+		[CLK_MMC2]		= &mmc2_clk.common.hw,
+		[CLK_MMC2_SAMPLE]	= &mmc2_sample_clk.common.hw,
+		[CLK_MMC2_OUTPUT]	= &mmc2_output_clk.common.hw,
 		[CLK_CE]		= &ce_clk.common.hw,
 		[CLK_SPI0]		= &spi0_clk.common.hw,
 		[CLK_USB_PHY0]		= &usb_phy0_clk.common.hw,
-- 
2.20.1



