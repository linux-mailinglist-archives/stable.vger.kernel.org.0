Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB883629523
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 11:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbiKOKBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 05:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiKOKBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 05:01:17 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF5E23E9E;
        Tue, 15 Nov 2022 02:01:16 -0800 (PST)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AF8LkbB008759;
        Tue, 15 Nov 2022 02:01:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=proofpoint;
 bh=Qht+gvVY8/QfaKWs5Gn0dKpXRyABsHudYW9zd9A/J3c=;
 b=mUHHwP8oIKAJT6dZKqYUm4ZJE2cHwLUi1slW8NYx4BlF+b8+lE/8iPjJ5afG7DsAYwL2
 xrjtmfyDgBsqdSpe06l8RfCHydklAdCNH+zc8CxhHc2TEwvVtXw+D17DvZL38gPQ4irT
 aODjeXEyaoHegXZmsrBo8wrXXygvFZkyoQoaNBqBr4KCbsO2Gn0T3o0fZPZTjBNe4f+4
 M714ZEIxxVp3yuY0sXqnm2LI1A8h3dFTIUQmzhbeSMax8/X8wFEoU3oi/DCp9l5VRKdN
 I+57+Xm+doKmNApS8oTIVP/fKmL18BuK5nwZfkHxEoFQ1e7vP8vzWMxHrpL2Fop2c4IB kQ== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3kv76n8aaq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Nov 2022 02:01:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a17Ti1hSqa9p6AdYPuSmXYqpCoSe9duEat9vz5NJB7PPa8Vg/4RVgsc9Z50rvaC1r/8sHzGyBdKr4RJ0c0CEfO19Sb5GxRqmxxEIejut9uLl96Y+/S0iqFhMHDSHO7z+0o7u2ZzmWCRviwYnBjoUK3ElPSczq7PXERWNVqkYM7SPJyOAEmvCf1iPzfXyoOeVizY8qVSADlbVyfRh4/8hm4dF4xhMEM/rr9nXmC4XFQCmeOz+5NNr8+83cIw3zftB5agmOqqnbvM86DRHMvCR8NZ4ahgE+/lDhc3LLOloQQBe9ujrDx6edAZko1a1fz/XT38N95xY1cba+68xUGDu0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qht+gvVY8/QfaKWs5Gn0dKpXRyABsHudYW9zd9A/J3c=;
 b=jXY4JFO0nz7n6i6Om0cT+DPslkkjKdyQwhGq8JgpeGc1ewTH5mrp7MbZMdn6gl4o8hGGV92xlKdBPg3T0Teojw5h+IS+a5mwe2ds1XffHtjHpD3Y+gfrCiKd5s+7l6zvPTmtymKRx2QzNi0OhA1ypT7568JNB2GnCNegnLEjH5XqJuDDhvIa6JNw1FMI35mFRkcSFozmxBTvbyY9LGNNZSzURkR7VLEsH3NLyIxF9bCnZ1biWvroK5vHR4NWZQAZmBKdoisj0mCZ5EHaW4gt0wcKG1r7Xkq1G9MUyFz2GHGn1NSINBHYzHWme3ZxPolXNFowJ1AtEAClhV686MhK8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.148) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qht+gvVY8/QfaKWs5Gn0dKpXRyABsHudYW9zd9A/J3c=;
 b=ogfjwwrpJJyT8ZysZg8E/R9PT6qhHXTgPD011WZqvkfkBcsIlCp+fUIbKotxxA6Gy+WMvrgQm+H1/l8ujH9FaURMa3YJUKQO4O+7FLGi5OZsQkK8by21nnd8wUjeAeRFBnWiLmG5WH40fPW7Z5EjuJKd1NnbQJjCShffUzibBQU=
Received: from DM6PR02CA0114.namprd02.prod.outlook.com (2603:10b6:5:1b4::16)
 by BN7PR07MB4452.namprd07.prod.outlook.com (2603:10b6:406:b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 10:01:06 +0000
Received: from DM6NAM12FT105.eop-nam12.prod.protection.outlook.com
 (2603:10b6:5:1b4:cafe::7c) by DM6PR02CA0114.outlook.office365.com
 (2603:10b6:5:1b4::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Tue, 15 Nov 2022 10:01:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.148)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.148 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.148; helo=sjmaillnx2.cadence.com; pr=C
Received: from sjmaillnx2.cadence.com (158.140.1.148) by
 DM6NAM12FT105.mail.protection.outlook.com (10.13.178.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.7 via Frontend Transport; Tue, 15 Nov 2022 10:01:06 +0000
Received: from maileu5.global.cadence.com (eudvw-maileu5.cadence.com [10.160.110.202])
        by sjmaillnx2.cadence.com (8.14.4/8.14.4) with ESMTP id 2AFA14n9016881
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Nov 2022 02:01:05 -0800
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 15 Nov 2022 11:01:03 +0100
Received: from eu-cn01.cadence.com (10.160.89.184) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24 via Frontend Transport; Tue, 15 Nov 2022 11:01:03 +0100
Received: from eu-cn01.cadence.com (localhost.localdomain [127.0.0.1])
        by eu-cn01.cadence.com (8.14.7/8.14.7) with ESMTP id 2AFA12QV441499;
        Tue, 15 Nov 2022 05:01:02 -0500
Received: (from pawell@localhost)
        by eu-cn01.cadence.com (8.14.7/8.14.7/Submit) id 2AFA0xUe441425;
        Tue, 15 Nov 2022 05:00:59 -0500
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <felipe.balbi@linux.intel.com>, <rogerq@kernel.org>,
        <a-govindraju@ti.com>, <linux-kernel@vger.kernel.org>,
        Pawel Laszczak <pawell@cadence.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: cdns3: remove fetched trb from cache before dequeuing
Date:   Tue, 15 Nov 2022 05:00:39 -0500
Message-ID: <20221115100039.441295-1-pawell@cadence.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-CrossPremisesHeadersFilteredBySendConnector: maileu5.global.cadence.com
X-OrganizationHeadersPreserved: maileu5.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM12FT105:EE_|BN7PR07MB4452:EE_
X-MS-Office365-Filtering-Correlation-Id: 86137b61-7887-4322-d19a-08dac6f05048
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pl/LRFOByxDNg7lBQF6+rYERWpN2C+EtLVumVyG8bcCh/9o9hGknuYEEHUayMXdZUcSAkDjYDFxofhf3HxMqlSvGqOm+5f38Dia9lhQiJQyFNuyabmm/ez1GtWi+m/6YtfRQbjjdjPdhHXilqiDnTgwPWLLFW3mGicnTpGw8SzRUaF5Ol2qB/gzCMwtz9pqCPSx1x89XEmn+w59JKIUV/ycf3v2CiDWtUKhOphKX1nMsmIqysMPts0iQysV3dRrDbFsrzu28ESdAGsbxyDHmekKf3be7BRx+mfhcobFmV6V8RCzLR2E3QdutS1NuI2bS+HfZ63XDFUg4n044QBmj8imYlocnfrPDY9vHhMLz8P4Dy6tqIed2TV3M+s0CIVA8LUPQaSRx9T0mnRcC5n+L9+NoDWsGdQx35GkgBZ1WNJ1lPJ5xxemlSSDydPImh6WhgM9AfFKH9Vclq81P4UHNqGDcFq4mrzbMvFXmJm23SCu4mkJJYNjSIEiG2ezHD5yRh1yutwXOSTPX2cv9ALFDbY41O59Fv93m8MEv2MFLLo1xTUk5ZaPpIPXeHCNAJUggl3+eKrvq4w5nWHSeJovb9egyzEJqsECnPgiF/rW3KPoAhoRDGzBAwMx4cC8g6FAWZQJGpFVIl5mL42URoY7FFjPpjwHeiv1kzXkgrluNZZNA2BBfxBOP+TQb+RnMaNueFLGbejHOtQRefS95DznBLAi/Y4Z9rO5+izUBKbOziVlMoZtEWNObCGjWwEqKIVzDz5E7Tt9+MIhEFMKCfcu+og==
X-Forefront-Antispam-Report: CIP:158.140.1.148;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx2.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(136003)(396003)(36092001)(451199015)(36840700001)(40470700004)(46966006)(26005)(6666004)(54906003)(6916009)(42186006)(316002)(356005)(7636003)(70206006)(70586007)(478600001)(4326008)(8676002)(426003)(2616005)(41300700001)(1076003)(186003)(336012)(83380400001)(2906002)(8936002)(36860700001)(82740400003)(36756003)(82310400005)(86362001)(40460700003)(5660300002)(47076005)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 10:01:06.6653
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86137b61-7887-4322-d19a-08dac6f05048
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.148];Helo=[sjmaillnx2.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM12FT105.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR07MB4452
X-Proofpoint-ORIG-GUID: SJi4N7HLStuEwCj4_lg2jWZZUYttU19Y
X-Proofpoint-GUID: SJi4N7HLStuEwCj4_lg2jWZZUYttU19Y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_05,2022-11-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 malwarescore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 phishscore=0
 mlxlogscore=590 mlxscore=0 adultscore=0 priorityscore=1501 clxscore=1011
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211150069
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After doorbell DMA fetches the TRB. If during dequeuing request
driver changes NORMAL TRB to LINK TRB but doesn't delete it from
controller cache then controller will handle cached TRB and packet
can be lost.

The example scenario for this issue looks like:
1. queue request - set doorbell
2. dequeue request
3. send OUT data packet from host
4. Device will accept this packet which is unexpected
5. queue new request - set doorbell
6. Device lost the expected packet.

By setting DFLUSH controller clears DRDY bit and stop DMA transfer.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdns3-gadget.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index 5adcb349718c..ccfaebca6faa 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -2614,6 +2614,7 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
 	u8 req_on_hw_ring = 0;
 	unsigned long flags;
 	int ret = 0;
+	int val;
 
 	if (!ep || !request || !ep->desc)
 		return -EINVAL;
@@ -2649,6 +2650,13 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
 
 	/* Update ring only if removed request is on pending_req_list list */
 	if (req_on_hw_ring && link_trb) {
+		/* Stop DMA */
+		writel(EP_CMD_DFLUSH, &priv_dev->regs->ep_cmd);
+
+		/* wait for DFLUSH cleared */
+		readl_poll_timeout_atomic(&priv_dev->regs->ep_cmd, val,
+					  !(val & EP_CMD_DFLUSH), 1, 1000);
+
 		link_trb->buffer = cpu_to_le32(TRB_BUFFER(priv_ep->trb_pool_dma +
 			((priv_req->end_trb + 1) * TRB_SIZE)));
 		link_trb->control = cpu_to_le32((le32_to_cpu(link_trb->control) & TRB_CYCLE) |
@@ -2660,6 +2668,10 @@ int cdns3_gadget_ep_dequeue(struct usb_ep *ep,
 
 	cdns3_gadget_giveback(priv_ep, priv_req, -ECONNRESET);
 
+	req = cdns3_next_request(&priv_ep->pending_req_list);
+	if (req)
+		cdns3_rearm_transfer(priv_ep, 1);
+
 not_found:
 	spin_unlock_irqrestore(&priv_dev->lock, flags);
 	return ret;
-- 
2.25.1

