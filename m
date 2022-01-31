Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632AB4A4582
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351045AbiAaLmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351433AbiAaLft (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:35:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2D2C07979F;
        Mon, 31 Jan 2022 03:23:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B15361299;
        Mon, 31 Jan 2022 11:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E101EC340E8;
        Mon, 31 Jan 2022 11:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628230;
        bh=AAFbgHTuVLoosPstvmMwWF1hZ3d/CR6g4fr+HnCPCsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWtXUY+zvy8AWtTgpdxF4JBeq/zhER0DV01WO23Iz1cZU4a2PdhscTsUVSX3ozgGY
         c/MZAykTHLZKuxl7VZCoXGbbN/09IlOCMBqFnIcWmS62gB8Qa8MVPyoI5nSXVHg+Dq
         3ymweKgbj1zm4Ls18aOgiVwB959eYfeepfW5a0io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 133/200] net: stmmac: dwmac-visconti: Fix bit definitions for ETHER_CLK_SEL
Date:   Mon, 31 Jan 2022 11:56:36 +0100
Message-Id: <20220131105238.031813020@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>

[ Upstream commit 1ba1a4a90fa416a6f389206416c5f488cf8b1543 ]

just 0 should be used to represent cleared bits

* ETHER_CLK_SEL_DIV_SEL_20
* ETHER_CLK_SEL_TX_CLK_EXT_SEL_IN
* ETHER_CLK_SEL_RX_CLK_EXT_SEL_IN
* ETHER_CLK_SEL_TX_CLK_O_TX_I
* ETHER_CLK_SEL_RMII_CLK_SEL_IN

Fixes: b38dd98ff8d0 ("net: stmmac: Add Toshiba Visconti SoCs glue driver")
Signed-off-by: Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
Reviewed-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
index e2e0f977875d7..43a446ceadf7a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
@@ -22,21 +22,21 @@
 #define ETHER_CLK_SEL_RMII_CLK_EN BIT(2)
 #define ETHER_CLK_SEL_RMII_CLK_RST BIT(3)
 #define ETHER_CLK_SEL_DIV_SEL_2 BIT(4)
-#define ETHER_CLK_SEL_DIV_SEL_20 BIT(0)
+#define ETHER_CLK_SEL_DIV_SEL_20 0
 #define ETHER_CLK_SEL_FREQ_SEL_125M	(BIT(9) | BIT(8))
 #define ETHER_CLK_SEL_FREQ_SEL_50M	BIT(9)
 #define ETHER_CLK_SEL_FREQ_SEL_25M	BIT(8)
 #define ETHER_CLK_SEL_FREQ_SEL_2P5M	0
-#define ETHER_CLK_SEL_TX_CLK_EXT_SEL_IN BIT(0)
+#define ETHER_CLK_SEL_TX_CLK_EXT_SEL_IN 0
 #define ETHER_CLK_SEL_TX_CLK_EXT_SEL_TXC BIT(10)
 #define ETHER_CLK_SEL_TX_CLK_EXT_SEL_DIV BIT(11)
-#define ETHER_CLK_SEL_RX_CLK_EXT_SEL_IN  BIT(0)
+#define ETHER_CLK_SEL_RX_CLK_EXT_SEL_IN  0
 #define ETHER_CLK_SEL_RX_CLK_EXT_SEL_RXC BIT(12)
 #define ETHER_CLK_SEL_RX_CLK_EXT_SEL_DIV BIT(13)
-#define ETHER_CLK_SEL_TX_CLK_O_TX_I	 BIT(0)
+#define ETHER_CLK_SEL_TX_CLK_O_TX_I	 0
 #define ETHER_CLK_SEL_TX_CLK_O_RMII_I	 BIT(14)
 #define ETHER_CLK_SEL_TX_O_E_N_IN	 BIT(15)
-#define ETHER_CLK_SEL_RMII_CLK_SEL_IN	 BIT(0)
+#define ETHER_CLK_SEL_RMII_CLK_SEL_IN	 0
 #define ETHER_CLK_SEL_RMII_CLK_SEL_RX_C	 BIT(16)
 
 #define ETHER_CLK_SEL_RX_TX_CLK_EN (ETHER_CLK_SEL_RX_CLK_EN | ETHER_CLK_SEL_TX_CLK_EN)
-- 
2.34.1



