Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4844A42CF
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241166AbiAaLOS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:14:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45592 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359717AbiAaLMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:12:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFF8061120;
        Mon, 31 Jan 2022 11:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5C1C340E8;
        Mon, 31 Jan 2022 11:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627519;
        bh=RUXOglG/eM0aDadg+wbP1jBITM6bw4xQ1x3s9eMpf/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4xjsSxN37ej1Mya2M4S/JvVJZuMNEEhTXyQTF8LfFA/mCg2TbFWaIzDE/T2Wl+SH
         KJqdgghEe0mZq8Lsc1nphu+wigI7+VcimNehytptPBj4f5jhetSCH/kKldgCApUFUg
         UFD4Qeli6Vt3frwqSGdIcronAP7zr2oO71vK0Qi8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/171] net: stmmac: dwmac-visconti: Fix bit definitions for ETHER_CLK_SEL
Date:   Mon, 31 Jan 2022 11:56:16 +0100
Message-Id: <20220131105233.788072043@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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
index fac788718c045..1c599a005aab6 100644
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



