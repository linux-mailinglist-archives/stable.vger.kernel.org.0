Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A56E42DD186
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 13:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbgLQMdf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 07:33:35 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3394 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726999AbgLQMdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 07:33:35 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BHCU3tB004926
        for <stable@vger.kernel.org>; Thu, 17 Dec 2020 04:32:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=Ap/aus3ouGDmYmnWKWyOzG9JI0lzi5MlksBkZIcjP4M=;
 b=UXDB2SKLHMD2UzKCNnWuOFRW8RG+Jx9ilONY7TjQg0lEmS5PzgaN389C22ngy5D7R6oQ
 XfGG+KSbrcXw/4diMp28CYfLvLBiVZt1/iEQCNHc7HgN05zkVeiVEQe4tWiRgvPF8eqM
 T6FvRioPJc374wHiBRQC8C9PxPTsSGdnJM8Mf2BWcCA4bHNV6+Ni9/dv0Ysg7RXV9xyv
 VYSBAf6Aq/ymDxnfbMbMTId+J21ePs3adTz6LIOuL38hNtxgmUPEa/3KU9iJxoSL4tpt
 lbCtTPUsKZEu+wnCxQn+BwLPJXGPo7jx5SSZ3JqLTcuaCnXNqiqR6QJ4Cz80pEuzSN6o 7w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 35g4rp0e3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 17 Dec 2020 04:32:55 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 04:32:54 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 04:32:54 -0800
Received: from stefan-pc.marvell.com (unknown [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 730773F703F;
        Thu, 17 Dec 2020 04:32:53 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <stefanc@marvell.com>
CC:     <stable@vger.kernel.org>
Subject: [PATCH net v3] net: mvpp2: Fix GoP port 3 Networking Complex Control configurations
Date:   Thu, 17 Dec 2020 14:32:50 +0200
Message-ID: <1608208370-13607-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_08:2020-12-15,2020-12-17 signatures=0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

During GoP port 2 Networking Complex Control mode of operation configurations,
also GoP port 3 mode of operation was wrongly set.
Patch removes these configurations.
GENCONF_CTRL0_PORTX naming also fixed.

Cc: stable@vger.kernel.org
Fixes: f84bf386f395 ("net: mvpp2: initialize the GoP")
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---

Changes in v3:
- No changes
Changes in v2:
- Added Fixes tag.

 drivers/net/ethernet/marvell/mvpp2/mvpp2.h      | 6 +++---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 6bd7e40..39c4e5c 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -651,9 +651,9 @@
 #define     GENCONF_PORT_CTRL1_EN(p)			BIT(p)
 #define     GENCONF_PORT_CTRL1_RESET(p)			(BIT(p) << 28)
 #define GENCONF_CTRL0					0x1120
-#define     GENCONF_CTRL0_PORT0_RGMII			BIT(0)
-#define     GENCONF_CTRL0_PORT1_RGMII_MII		BIT(1)
-#define     GENCONF_CTRL0_PORT1_RGMII			BIT(2)
+#define     GENCONF_CTRL0_PORT2_RGMII			BIT(0)
+#define     GENCONF_CTRL0_PORT3_RGMII_MII		BIT(1)
+#define     GENCONF_CTRL0_PORT3_RGMII			BIT(2)
 
 /* Various constants */
 
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d64dc12..d2b0506 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1231,9 +1231,9 @@ static void mvpp22_gop_init_rgmii(struct mvpp2_port *port)
 
 	regmap_read(priv->sysctrl_base, GENCONF_CTRL0, &val);
 	if (port->gop_id == 2)
-		val |= GENCONF_CTRL0_PORT0_RGMII | GENCONF_CTRL0_PORT1_RGMII;
+		val |= GENCONF_CTRL0_PORT2_RGMII;
 	else if (port->gop_id == 3)
-		val |= GENCONF_CTRL0_PORT1_RGMII_MII;
+		val |= GENCONF_CTRL0_PORT3_RGMII_MII;
 	regmap_write(priv->sysctrl_base, GENCONF_CTRL0, val);
 }
 
@@ -1250,9 +1250,9 @@ static void mvpp22_gop_init_sgmii(struct mvpp2_port *port)
 	if (port->gop_id > 1) {
 		regmap_read(priv->sysctrl_base, GENCONF_CTRL0, &val);
 		if (port->gop_id == 2)
-			val &= ~GENCONF_CTRL0_PORT0_RGMII;
+			val &= ~GENCONF_CTRL0_PORT2_RGMII;
 		else if (port->gop_id == 3)
-			val &= ~GENCONF_CTRL0_PORT1_RGMII_MII;
+			val &= ~GENCONF_CTRL0_PORT3_RGMII_MII;
 		regmap_write(priv->sysctrl_base, GENCONF_CTRL0, val);
 	}
 }
-- 
1.9.1

