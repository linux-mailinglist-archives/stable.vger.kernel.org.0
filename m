Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF4C32DD188
	for <lists+stable@lfdr.de>; Thu, 17 Dec 2020 13:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgLQMfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Dec 2020 07:35:05 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:17796 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726155AbgLQMfF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Dec 2020 07:35:05 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BHCW2uQ022042
        for <stable@vger.kernel.org>; Thu, 17 Dec 2020 04:34:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=iGcMFz6EzTgWLrUXE2wy5bwI2B9olAT5/mhy2Cw27eo=;
 b=ZRUTW1jCUGqKPVrXMBL6EmPbdl/aocewP3Zv2072mksFmL0UplWyZiLBWR8ZO5v0bfKR
 0WSF43GemU07KMTaM0usU/MvJIyYu07t0jwrN+miPXvo9Fmtc11bFlI8bRV416hdipwi
 igEo5HPr04mL2j3yWvx/ophuLb7fxoH1KbFNrwELEhrizGgVxMdGE2NlmiRED7v8j8Sf
 4eYSLLz92ZhIQaeX3VzNasIKPWmb+YqkpvAN6SRBVzgEBLuACO1Zu8PthSlDwyr0mxdy
 GkTE5AXNNcwxKeiUCe0qYKRUn0glMSBk0r/Qzevy6vJQTKmZaygzL7ux+GvuGKzL6ec5 Lg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 35cx8tfh9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 17 Dec 2020 04:34:23 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 04:34:22 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 04:34:22 -0800
Received: from stefan-pc.marvell.com (unknown [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 8EF8D3F703F;
        Thu, 17 Dec 2020 04:34:21 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <stefanc@marvell.com>
CC:     <stable@vger.kernel.org>
Subject: [PATCH net v3] net: mvpp2: Fix GoP port 3 Networking Complex Control configurations
Date:   Thu, 17 Dec 2020 14:34:18 +0200
Message-ID: <1608208458-13660-1-git-send-email-stefanc@marvell.com>
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
- Added cc stable@vger.kernel.org
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

