Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81572CD464
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbfJFRZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728060AbfJFRZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:25:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F11621835;
        Sun,  6 Oct 2019 17:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382711;
        bh=zL1w5syTRE29MPGD3HK6k4a/25ozxavpM0xkeCziFPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xinq34TxqnMuVecHIPTHxF4GrOIf2AwpSGTp0g5KGBItIiOnj/Pxyn7QcLkiug4+i
         iCLgBB6wVOftnSfwAb25AocSzrOjS7sKbDBQkZGcQ0/iX9k2s82Ewdhg4rPqy04J8A
         03Sxj0VpxUg1bRPtjRy+tDpqGT7CMvAzHzsu7B8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Icenowy Zheng <icenowy@aosc.io>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/68] clk: sunxi-ng: v3s: add missing clock slices for MMC2 module clocks
Date:   Sun,  6 Oct 2019 19:20:48 +0200
Message-Id: <20191006171114.433090686@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171108.150129403@linuxfoundation.org>
References: <20191006171108.150129403@linuxfoundation.org>
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
index ac12f261f8caa..9e3f4088724b4 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
@@ -499,6 +499,9 @@ static struct clk_hw_onecell_data sun8i_v3s_hw_clks = {
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



