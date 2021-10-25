Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4482F43A122
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234864AbhJYThV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236393AbhJYTee (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:34:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D37486108B;
        Mon, 25 Oct 2021 19:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190220;
        bh=g/lRSPQvJ7X9caG7g4i58+fKx4Hd6vMP4zX/x1hamiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQ8QD9paCry6FZQOk858IZRgkDlznf6AltiO3CuYTmU21hvHJc2R6BYXujXHiuEl1
         uTXjPEXNcEE+V2An/dvh3xLP0v2ezOoz35V615g2xURXdepJTrTzaJNoPCyh7su4nR
         acNi8gYymSGAmWX/FG8cAlsLnLJBuycI0TxPdK6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksander Jan Bajkowski <olek2@wp.pl>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 21/95] net: dsa: lantiq_gswip: fix register definition
Date:   Mon, 25 Oct 2021 21:14:18 +0200
Message-Id: <20211025190959.961950598@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 66d262804a2276721eac86cf18fcd61046149193 ]

I compared the register definitions with the D-Link DWR-966
GPL sources and found that the PUAFD field definition was
incorrect. This definition is unused and causes no issues.

Fixes: 14fceff4771e ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lantiq_gswip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 95e634cbc4b6..4d23a7aba796 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -229,7 +229,7 @@
 #define GSWIP_SDMA_PCTRLp(p)		(0xBC0 + ((p) * 0x6))
 #define  GSWIP_SDMA_PCTRL_EN		BIT(0)	/* SDMA Port Enable */
 #define  GSWIP_SDMA_PCTRL_FCEN		BIT(1)	/* Flow Control Enable */
-#define  GSWIP_SDMA_PCTRL_PAUFWD	BIT(1)	/* Pause Frame Forwarding */
+#define  GSWIP_SDMA_PCTRL_PAUFWD	BIT(3)	/* Pause Frame Forwarding */
 
 #define GSWIP_TABLE_ACTIVE_VLAN		0x01
 #define GSWIP_TABLE_VLAN_MAPPING	0x02
-- 
2.33.0



