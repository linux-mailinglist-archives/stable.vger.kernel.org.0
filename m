Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 334EC500B14
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 12:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242278AbiDNKap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 06:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242277AbiDNKao (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 06:30:44 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B95978908;
        Thu, 14 Apr 2022 03:28:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvEPL5vO8WQA4NLf19ObAw0JkHN5iHtpg2zL7rWaoQiAA9LRR/Pt2xU2s4IsAFGsTmVEuXrOeElB6pospUuv3vWP80qdvlzgXRe0GBM9ehaQPDZNHPPeNXAd5uwYSvQ8wInT+DFUfmLUHPs5PlLNTVnqRzN62EjL9ZNpNz3H1gDmLqJvIJCyRBaQ3n7c30+VK4pFxTayyYLFRzXJfqhadFzL7RQSTU11mkeMKescLpK5CJ9Pyh79Eb/rhdZkQwV95fZpNzfWlEfL2tjQOXHHi9H7TEAFP0kCeueXYTc1TBXTQssxsPpjKAcinMGKAxijsF+NlLz8+bTYDpqWW0tFUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IC3lFi7bQXO6liyqqeh5n4xl92LgufCTRQu+QRAf5r8=;
 b=VzOt61Xeu/OGJ+81zsK5/RXXr8fHDHjnjH7ZRbdPNgpJgn8wDBl28etumjpSeUAQlAjR1vSEJwtySlvGC+dcz8DQ39V8HiNPR7A61y7dDojgrxFeJhIdB7OHCoGaFIZSGo7Zx5IEGziB7Aq27mcJZE/gNUhbYOE/+mrE75vpWQPAlJmmj2I7LyYqZrFBbT1qkiRXlum0As0d9mlsopseTlfo5IPzmFwRPagDilnkwQyC4wLVNGBkDNF/bTmcr9UeeRErD33YZOLbk0p3s9sxoB46wM2AC+8YrQY/AD9iLPR/rDA8lYyCoDq7g+c1XFI9zNYwWsjCOCSw+exlex1clg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.62.198) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IC3lFi7bQXO6liyqqeh5n4xl92LgufCTRQu+QRAf5r8=;
 b=sakSFWs/hntrCmT1YRT3qaxAJsxiDYdV1MAhRG7BnygDUPC2k4KvhWmgmYh26wQ0n746zOJ3U8hLD1zh1TdS0/S38sL3yv/Mg6IaJ3VaYA3mAtVJZLX+MXi38+Ljwmo5oO2PGXfrYWujlXBGVjpuRdUHr0Zj+RXkF6VkBs0CyEs=
Received: from BN9PR03CA0564.namprd03.prod.outlook.com (2603:10b6:408:138::29)
 by DM6PR02MB6665.namprd02.prod.outlook.com (2603:10b6:5:214::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 10:28:18 +0000
Received: from BN1NAM02FT006.eop-nam02.prod.protection.outlook.com
 (2603:10b6:408:138:cafe::84) by BN9PR03CA0564.outlook.office365.com
 (2603:10b6:408:138::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Thu, 14 Apr 2022 10:28:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 149.199.62.198)
 smtp.mailfrom=xilinx.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.62.198 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.62.198; helo=xsj-pvapexch01.xlnx.xilinx.com;
Received: from xsj-pvapexch01.xlnx.xilinx.com (149.199.62.198) by
 BN1NAM02FT006.mail.protection.outlook.com (10.13.2.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5164.19 via Frontend Transport; Thu, 14 Apr 2022 10:28:18 +0000
Received: from xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) by
 xsj-pvapexch01.xlnx.xilinx.com (172.19.86.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 14 Apr 2022 03:28:16 -0700
Received: from smtp.xilinx.com (172.19.127.95) by
 xsj-pvapexch02.xlnx.xilinx.com (172.19.86.41) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 14 Apr 2022 03:28:16 -0700
Envelope-to: linux-edac@vger.kernel.org,
 bp@alien8.de,
 mchehab@kernel.org,
 tony.luck@intel.com,
 stable@vger.kernel.org
Received: from [10.140.6.59] (port=44638 helo=xhdshubhraj40.xilinx.com)
        by smtp.xilinx.com with esmtp (Exim 4.90)
        (envelope-from <shubhrajyoti.datta@xilinx.com>)
        id 1newi0-0005Wz-GF; Thu, 14 Apr 2022 03:28:16 -0700
From:   Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
To:     <linux-edac@vger.kernel.org>
CC:     <michal.simek@xilinx.com>, <bp@alien8.de>, <mchehab@kernel.org>,
        <tony.luck@intel.com>,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v3] edac: synopsys: Fix the issue in reporting of the error count
Date:   Thu, 14 Apr 2022 15:58:13 +0530
Message-ID: <20220414102813.4468-1-shubhrajyoti.datta@xilinx.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3298dca-cf6c-44f3-df4c-08da1e017de2
X-MS-TrafficTypeDiagnostic: DM6PR02MB6665:EE_
X-Microsoft-Antispam-PRVS: <DM6PR02MB66657A3DF9C7E20C99F3E701AAEF9@DM6PR02MB6665.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BBLf7dDj/gUcJFBqgukzHR6GImRyXZvt+Wcxs4hgvZyo/PoEnUvwc+feXkCJBROLMqXyVy1pZCTjO4oEq5F1ovRiwn4mnDaEAvFenjgYD8f8ZHLHse9xcguUZ2FP9F8Rs79Dhsnds/U6MM7trChvXNMxc3uzjj2XbC5wShZlpZQpvq46JdunJkT3IyI40wQppF55R42v120i+2A78oGBOzo0ZfaEjrBru2TcFcw/7+4MMkUebvbzU7sGgQMqqX9okaHxucgm/Qf6gmGiBssodXwki3ISsyILWvNkGEa36W6G6f8wv17m6wNtV9MV3DKyBwpeWA+8IHi/QQAysicjKoSpql+psxvGwSpSAdPWxF50fRLyLnB/oUWVGNRxaArdrybz+pKajbBfOzzmi1evq0fBd9pMU63yI0Nh3rhCROvRRAtI2meR/ymXlvyoYbEwku0HFQ37PLkcfhIP8zzE5K+K67g6lS+kgdg4jFGElh94QjbmalN2NdkRR9/4b+93SvGViF03QuJh40VUb9J8N1hVv2wp2o3Tbl8hRbLMzU+FZzRfYM56zQrEdV0aBfohCYhfEzQBSz///d1PpdXujYE4vtfs8bCh0DKeJthQxk0WltDqo3HR+rIIb/9ttyLJqnVy+zcoUniRs3mRuQvfc7dAjxIp4fchN9KjjQ1rwZa/hjNaRPSYyV1OdA4B05ZC2c/ODHqofKq04aN+3H7dPg==
X-Forefront-Antispam-Report: CIP:149.199.62.198;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:xsj-pvapexch01.xlnx.xilinx.com;PTR:unknown-62-198.xilinx.com;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(508600001)(356005)(6916009)(54906003)(8936002)(47076005)(336012)(7696005)(82310400005)(426003)(36860700001)(44832011)(4326008)(26005)(186003)(7636003)(8676002)(1076003)(316002)(2616005)(9786002)(2906002)(70206006)(6666004)(70586007)(83380400001)(40460700003)(36756003)(5660300002)(102446001);DIR:OUT;SFP:1101;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 10:28:18.0917
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a3298dca-cf6c-44f3-df4c-08da1e017de2
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.62.198];Helo=[xsj-pvapexch01.xlnx.xilinx.com]
X-MS-Exchange-CrossTenant-AuthSource: BN1NAM02FT006.eop-nam02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6665
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently the error count from status register is being read which
is not correct. Fix the issue by reading the count from the
error count register(ERRCNT).

Fixes: b500b4a029d5 ("EDAC, synopsys: Add ECC support for ZynqMP DDR controller")
Cc: <stable@vger.kernel.org>
Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
---
v2:
Remove the cumulative count change
v3:
Add the fixes and stable tag

 drivers/edac/synopsys_edac.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
index f05ff02c0656..1a9a5b886903 100644
--- a/drivers/edac/synopsys_edac.c
+++ b/drivers/edac/synopsys_edac.c
@@ -164,6 +164,11 @@
 #define ECC_STAT_CECNT_SHIFT		8
 #define ECC_STAT_BITNUM_MASK		0x7F
 
+/* ECC error count register definitions */
+#define ECC_ERRCNT_UECNT_MASK		0xFFFF0000
+#define ECC_ERRCNT_UECNT_SHIFT		16
+#define ECC_ERRCNT_CECNT_MASK		0xFFFF
+
 /* DDR QOS Interrupt register definitions */
 #define DDR_QOS_IRQ_STAT_OFST		0x20200
 #define DDR_QOSUE_MASK			0x4
@@ -423,14 +428,16 @@ static int zynqmp_get_error_info(struct synps_edac_priv *priv)
 	base = priv->baseaddr;
 	p = &priv->stat;
 
+	regval = readl(base + ECC_ERRCNT_OFST);
+	p->ce_cnt = regval & ECC_ERRCNT_CECNT_MASK;
+	p->ue_cnt = (regval & ECC_ERRCNT_UECNT_MASK) >> ECC_ERRCNT_UECNT_SHIFT;
+	if (!p->ce_cnt)
+		goto ue_err;
+
 	regval = readl(base + ECC_STAT_OFST);
 	if (!regval)
 		return 1;
 
-	p->ce_cnt = (regval & ECC_STAT_CECNT_MASK) >> ECC_STAT_CECNT_SHIFT;
-	p->ue_cnt = (regval & ECC_STAT_UECNT_MASK) >> ECC_STAT_UECNT_SHIFT;
-	if (!p->ce_cnt)
-		goto ue_err;
 
 	p->ceinfo.bitpos = (regval & ECC_STAT_BITNUM_MASK);
 
-- 
2.17.1

