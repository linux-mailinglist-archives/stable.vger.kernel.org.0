Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDEE43A235
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbhJYTqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237533AbhJYTnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:43:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CEA9611C0;
        Mon, 25 Oct 2021 19:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190691;
        bh=a1twR2l04qpGH1mZCzjVX9tYTyZ9RMTyW04GGN0FLjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xohpRnOwX5bF0z9UO5nksWwa0NR6V3sTieIIK8dncHPCF2znhYclsmVxn/tqwLkBr
         3F+3glZ6MZ5LTH/DmwMKpZLs6l2ui+NMuBQivWy0RJq50pXtfq+VSBceLxcxwhj6u/
         TbdJmYdQZ3PNtGrjvK3dSggBROJm/WavqAl8gY2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksander Jan Bajkowski <olek2@wp.pl>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 039/169] net: dsa: lantiq_gswip: fix register definition
Date:   Mon, 25 Oct 2021 21:13:40 +0200
Message-Id: <20211025191022.806927972@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
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
index 267324889dd6..1b9b7569c371 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -230,7 +230,7 @@
 #define GSWIP_SDMA_PCTRLp(p)		(0xBC0 + ((p) * 0x6))
 #define  GSWIP_SDMA_PCTRL_EN		BIT(0)	/* SDMA Port Enable */
 #define  GSWIP_SDMA_PCTRL_FCEN		BIT(1)	/* Flow Control Enable */
-#define  GSWIP_SDMA_PCTRL_PAUFWD	BIT(1)	/* Pause Frame Forwarding */
+#define  GSWIP_SDMA_PCTRL_PAUFWD	BIT(3)	/* Pause Frame Forwarding */
 
 #define GSWIP_TABLE_ACTIVE_VLAN		0x01
 #define GSWIP_TABLE_VLAN_MAPPING	0x02
-- 
2.33.0



