Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2C5653D4E
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 10:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbiLVJKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Dec 2022 04:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiLVJKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Dec 2022 04:10:11 -0500
Received: from mx0a-0014ca01.pphosted.com (mx0b-0014ca01.pphosted.com [208.86.201.193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142F7218AE;
        Thu, 22 Dec 2022 01:10:07 -0800 (PST)
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BM5jlBa009021;
        Thu, 22 Dec 2022 01:09:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=proofpoint;
 bh=cSuiH3NV3hyDesH21pZK5xDXV4kQ+sp6Tvknwim7ZWY=;
 b=VSSsPin5AWnwjdfBLB3w/BfZ6NzzlRbivejSRP2CR9g8Irq6IaDOyyK5KBqec0mOU3NN
 RtNkpvfKILiYK/VUaGVY8vQJBwauniHloVBeeA/pZFUpWxe15gbrO6HfiiRSxV6JYQzj
 1YthJRhJkXm7/UkHKsEfOVvPBv/vxvyyewF2ZiLlg3zqdeF8AHX78Is1FaVHk84P6nzu
 6otOrWEzgCWpIYCS2ya2AO8sUTE4cHPH/Bob5/Bt4p5Q1uzNicWAYmSila3XS+jBj+GV
 HlKxmELn2EhaCrhKH0xm8ffs/pnNP/c5VMhAnzIfxZc7d+LHIfeM3u5l/qnhaNzQ9ufz 9A== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3mjxkjc1xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Dec 2022 01:09:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzfooUH9M1DGS2HG+gxz4MTBypPnWjXZdYFnTF5uCu0JpTS7HXHEzwXqWKv9CBbBxpQT2+GR1AjE0c3kTCUKS0ZJz+NBI3AX4ReX78/atF03vQm/zYa0UJ+3djTZjzdQrMMbSBB5RVU/PPqjXXKr+6544VbP1AtDkOHKJ7RwMVIWsG6jpXo3u6hcnwYHtIwS9UmNfMGR7jaejtXaixXNKNRCP1sasdMS1orrv7KpOMoNQK7NNVQBh7idNCHlS1QqBrOT8t0DHu9u6N+BkM3W0lR3PRF1n9eT427RasBwArSjEt7NsH86HiAYL2nHyH42nJHJPn9cXWsQTub6EYn8nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cSuiH3NV3hyDesH21pZK5xDXV4kQ+sp6Tvknwim7ZWY=;
 b=lTIIjG5ftIDq0Rh6AmTwUyqFGVKiHqh0utLpskKtiN4ypewvVkA8mmVtY0IQuNex6nPJFTiULxSbiHR9iQ94+tu4/CyxcHdqfhU7sN4YYBX0qGpPoe7v+3madvkT82q1eekPn3+9Z/1CwYycR1uJhTxqE8NgOilrNd+URhp8M6x8MNmnTp2CIGDY1DS42qAhS8Ahe56l4KPtSiTmOrfm9DUweOsxX6Jg8309WJxqlwGDTBqspwDa++J+eDkylNbC1jQad+g+7B5R74Ln6RAw+91MUNSoPlCJiCYHd0BfLkc0bggg2uBjW4/C3nYjhlFcnsvK2JvR36M1VrSEJBKC3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.147) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cSuiH3NV3hyDesH21pZK5xDXV4kQ+sp6Tvknwim7ZWY=;
 b=IQdjY8QjYNLV5q7g5cbLU9uES4TrrTIK2T/Lg3kjyXBMq3H2cU0zawc8rs3Iz3ibgb1FpbcUniicHhHvkYANzODTy76vyQ6vfhA4qhaSextAR6/XP7nLkH79AU0u4i06A7d3B9BymyHTwSgZNKBkT36x8IfPRVGpOycxFpQQEWY=
Received: from MW4PR03CA0355.namprd03.prod.outlook.com (2603:10b6:303:dc::30)
 by BYAPR07MB5909.namprd07.prod.outlook.com (2603:10b6:a03:12f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Thu, 22 Dec
 2022 09:09:53 +0000
Received: from MW2NAM12FT047.eop-nam12.prod.protection.outlook.com
 (2603:10b6:303:dc:cafe::8e) by MW4PR03CA0355.outlook.office365.com
 (2603:10b6:303:dc::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.21 via Frontend
 Transport; Thu, 22 Dec 2022 09:09:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.147)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.147 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.147; helo=sjmaillnx1.cadence.com; pr=C
Received: from sjmaillnx1.cadence.com (158.140.1.147) by
 MW2NAM12FT047.mail.protection.outlook.com (10.13.180.173) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.7 via Frontend Transport; Thu, 22 Dec 2022 09:09:53 +0000
Received: from maileu5.global.cadence.com (eudvw-maileu5.cadence.com [10.160.110.202])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id 2BM99n7F011857
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Dec 2022 01:09:50 -0800
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 22 Dec 2022 10:09:48 +0100
Received: from eu-cn02.cadence.com (10.160.89.185) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24 via Frontend Transport; Thu, 22 Dec 2022 10:09:48 +0100
Received: from eu-cn02.cadence.com (localhost.localdomain [127.0.0.1])
        by eu-cn02.cadence.com (8.14.7/8.14.7) with ESMTP id 2BM99m15145295;
        Thu, 22 Dec 2022 04:09:48 -0500
Received: (from pawell@localhost)
        by eu-cn02.cadence.com (8.14.7/8.14.7/Submit) id 2BM99lcp145284;
        Thu, 22 Dec 2022 04:09:47 -0500
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Pawel Laszczak <pawell@cadence.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: cdnsp: : add scatter gather support for ISOC endpoint
Date:   Thu, 22 Dec 2022 04:09:34 -0500
Message-ID: <20221222090934.145140-1-pawell@cadence.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-CrossPremisesHeadersFilteredBySendConnector: maileu5.global.cadence.com
X-OrganizationHeadersPreserved: maileu5.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2NAM12FT047:EE_|BYAPR07MB5909:EE_
X-MS-Office365-Filtering-Correlation-Id: 1206d009-23f3-4946-3b7d-08dae3fc4984
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dWSl7E1381joVqNYw3yDE/ZvkbvFUbPmygXOXlwe5B6tKKW4JzExKofI0TBfBDtu+Nm9Qd5xXhTss/La7aJMB36t+lC6Nw9a/7P71bNk4fs3jJ7HBvWKKRDJzDEK1om/and+Y3BamDbc2k3virKQDBjLelwV+mF/4n+WQvA+GGxskMQxvMOJfOrE9syB6YtOVCLkbE5JSuPFH/mclQSwXuZFrB1+kpJcQ/7I7SAg5Dg+d3EdLXneHVQAVtojBFOGRuDhaMdzProadKZmoy+XgB1Dhy++BlYW5wwlU73aA8hP63wOlWTgfbmUiYWfkszJWbbak2FOLyulOjr1Qg8oAXnr/TPFZz4/Lf7ONK/HUk9TKQWrvEDvoVa/IG44pijq83WdLsQpYCU5MQd6wazyAhtZZah6tLB75Zevg42TYO8ZbXEURyfd5OKfROgYHR+8kYvUm9C91JzPZzt4dC3RkU49/K6mFuyylhlgSzgBj0G5hOtGZw4mwszttMkDyhDTHIxLrQHN7NQLymSWk5zME8Z2qCN7NHrZRadgTcBKp6O19cU6IuIDREjJ+jgRhab0/2FiyUjHHXEQUJXQzjhanLfl8l6GMiwFTYCNf1UFMdkWlBnLNgMkIGNhljLLAInbhnd0wP/5XHB1PvI1qpAL7oTR3KLk7T1fPfSSmecZKDEsKpcUJmv9dqiPNtY/DSiht2QIzDVjlQY2obCYrZg6zrKRiI/OT489UhSwuPClJUw1rEnua020c7SuE5dz+Mnn
X-Forefront-Antispam-Report: CIP:158.140.1.147;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx1.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(376002)(136003)(36092001)(451199015)(46966006)(36840700001)(40470700004)(8676002)(34020700004)(4326008)(36756003)(82310400005)(70586007)(70206006)(5660300002)(8936002)(41300700001)(478600001)(40460700003)(6666004)(86362001)(26005)(54906003)(42186006)(6916009)(83380400001)(316002)(1076003)(426003)(336012)(47076005)(2616005)(82740400003)(186003)(356005)(7636003)(36860700001)(40480700001)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2022 09:09:53.0544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1206d009-23f3-4946-3b7d-08dae3fc4984
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.147];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM12FT047.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR07MB5909
X-Proofpoint-ORIG-GUID: J399LHw07xAOgMC3OqvXSDz02gAFIHhR
X-Proofpoint-GUID: J399LHw07xAOgMC3OqvXSDz02gAFIHhR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-22_03,2022-12-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 clxscore=1011
 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 malwarescore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212220080
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patch implements scatter gather support for isochronous endpoint.
This fix is forced by 'commit e81e7f9a0eb9
("usb: gadget: uvc: add scatter gather support")'.
After this fix CDNSP driver stop working with UVC class.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdnsp-gadget.c |   2 +-
 drivers/usb/cdns3/cdnsp-gadget.h |   4 +-
 drivers/usb/cdns3/cdnsp-ring.c   | 110 +++++++++++++++++--------------
 3 files changed, 63 insertions(+), 53 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
index a8640516c895..e81dca0e62a8 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -382,7 +382,7 @@ int cdnsp_ep_enqueue(struct cdnsp_ep *pep, struct cdnsp_request *preq)
 		ret = cdnsp_queue_bulk_tx(pdev, preq);
 		break;
 	case USB_ENDPOINT_XFER_ISOC:
-		ret = cdnsp_queue_isoc_tx_prepare(pdev, preq);
+		ret = cdnsp_queue_isoc_tx(pdev, preq);
 	}
 
 	if (ret)
diff --git a/drivers/usb/cdns3/cdnsp-gadget.h b/drivers/usb/cdns3/cdnsp-gadget.h
index f740fa6089d8..e1b5801fdddf 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.h
+++ b/drivers/usb/cdns3/cdnsp-gadget.h
@@ -1532,8 +1532,8 @@ void cdnsp_queue_stop_endpoint(struct cdnsp_device *pdev,
 			       unsigned int ep_index);
 int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq);
 int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq);
-int cdnsp_queue_isoc_tx_prepare(struct cdnsp_device *pdev,
-				struct cdnsp_request *preq);
+int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
+			struct cdnsp_request *preq);
 void cdnsp_queue_configure_endpoint(struct cdnsp_device *pdev,
 				    dma_addr_t in_ctx_ptr);
 void cdnsp_queue_reset_ep(struct cdnsp_device *pdev, unsigned int ep_index);
diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index b23e543b3a3d..07f6068342d4 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1333,6 +1333,20 @@ static int cdnsp_handle_tx_event(struct cdnsp_device *pdev,
 					 ep_ring->dequeue, td->last_trb,
 					 ep_trb_dma);
 
+		desc = td->preq->pep->endpoint.desc;
+
+		if (ep_seg) {
+			ep_trb = &ep_seg->trbs[(ep_trb_dma - ep_seg->dma)
+					       / sizeof(*ep_trb)];
+
+			trace_cdnsp_handle_transfer(ep_ring,
+					(struct cdnsp_generic_trb *)ep_trb);
+
+			if (pep->skip && usb_endpoint_xfer_isoc(desc) &&
+			    td->last_trb != ep_trb)
+				return -EAGAIN;
+		}
+
 		/*
 		 * Skip the Force Stopped Event. The event_trb(ep_trb_dma)
 		 * of FSE is not in the current TD pointed by ep_ring->dequeue
@@ -1347,7 +1361,6 @@ static int cdnsp_handle_tx_event(struct cdnsp_device *pdev,
 			goto cleanup;
 		}
 
-		desc = td->preq->pep->endpoint.desc;
 		if (!ep_seg) {
 			if (!pep->skip || !usb_endpoint_xfer_isoc(desc)) {
 				/* Something is busted, give up! */
@@ -1374,12 +1387,6 @@ static int cdnsp_handle_tx_event(struct cdnsp_device *pdev,
 			goto cleanup;
 		}
 
-		ep_trb = &ep_seg->trbs[(ep_trb_dma - ep_seg->dma)
-				       / sizeof(*ep_trb)];
-
-		trace_cdnsp_handle_transfer(ep_ring,
-					    (struct cdnsp_generic_trb *)ep_trb);
-
 		if (cdnsp_trb_is_noop(ep_trb))
 			goto cleanup;
 
@@ -1726,11 +1733,6 @@ static unsigned int count_sg_trbs_needed(struct cdnsp_request *preq)
 	return num_trbs;
 }
 
-static unsigned int count_isoc_trbs_needed(struct cdnsp_request *preq)
-{
-	return cdnsp_count_trbs(preq->request.dma, preq->request.length);
-}
-
 static void cdnsp_check_trb_math(struct cdnsp_request *preq, int running_total)
 {
 	if (running_total != preq->request.length)
@@ -2192,28 +2194,48 @@ static unsigned int
 }
 
 /* Queue function isoc transfer */
-static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
-			       struct cdnsp_request *preq)
+int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
+			struct cdnsp_request *preq)
 {
-	int trb_buff_len, td_len, td_remain_len, ret;
+	unsigned int trb_buff_len, td_len, td_remain_len, block_len;
 	unsigned int burst_count, last_burst_pkt;
 	unsigned int total_pkt_count, max_pkt;
 	struct cdnsp_generic_trb *start_trb;
+	struct scatterlist *sg = NULL;
 	bool more_trbs_coming = true;
 	struct cdnsp_ring *ep_ring;
+	unsigned int num_sgs = 0;
 	int running_total = 0;
 	u32 field, length_field;
+	u64 addr, send_addr;
 	int start_cycle;
 	int trbs_per_td;
-	u64 addr;
-	int i;
+	int i, sent_len, ret;
 
 	ep_ring = preq->pep->ring;
+
+	td_len = preq->request.length;
+
+	if (preq->request.num_sgs) {
+		num_sgs = preq->request.num_sgs;
+		sg = preq->request.sg;
+		addr = (u64)sg_dma_address(sg);
+		block_len = sg_dma_len(sg);
+		trbs_per_td = count_sg_trbs_needed(preq);
+	} else {
+		addr = (u64)preq->request.dma;
+		block_len = td_len;
+		trbs_per_td = count_trbs_needed(preq);
+	}
+
+	ret = cdnsp_prepare_transfer(pdev, preq, trbs_per_td);
+	if (ret)
+		return ret;
+
 	start_trb = &ep_ring->enqueue->generic;
 	start_cycle = ep_ring->cycle_state;
-	td_len = preq->request.length;
-	addr = (u64)preq->request.dma;
 	td_remain_len = td_len;
+	send_addr = addr;
 
 	max_pkt = usb_endpoint_maxp(preq->pep->endpoint.desc);
 	total_pkt_count = DIV_ROUND_UP(td_len, max_pkt);
@@ -2225,11 +2247,6 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
 	burst_count = cdnsp_get_burst_count(pdev, preq, total_pkt_count);
 	last_burst_pkt = cdnsp_get_last_burst_packet_count(pdev, preq,
 							   total_pkt_count);
-	trbs_per_td = count_isoc_trbs_needed(preq);
-
-	ret = cdnsp_prepare_transfer(pdev, preq, trbs_per_td);
-	if (ret)
-		goto cleanup;
 
 	/*
 	 * Set isoc specific data for the first TRB in a TD.
@@ -2248,6 +2265,7 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
 
 		/* Calculate TRB length. */
 		trb_buff_len = TRB_BUFF_LEN_UP_TO_BOUNDARY(addr);
+		trb_buff_len = min(trb_buff_len, block_len);
 		if (trb_buff_len > td_remain_len)
 			trb_buff_len = td_remain_len;
 
@@ -2256,7 +2274,8 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
 					       trb_buff_len, td_len, preq,
 					       more_trbs_coming, 0);
 
-		length_field = TRB_LEN(trb_buff_len) | TRB_INTR_TARGET(0);
+		length_field = TRB_LEN(trb_buff_len) | TRB_TD_SIZE(remainder) |
+			TRB_INTR_TARGET(0);
 
 		/* Only first TRB is isoc, overwrite otherwise. */
 		if (i) {
@@ -2281,12 +2300,27 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
 		}
 
 		cdnsp_queue_trb(pdev, ep_ring, more_trbs_coming,
-				lower_32_bits(addr), upper_32_bits(addr),
+				lower_32_bits(send_addr), upper_32_bits(send_addr),
 				length_field, field);
 
 		running_total += trb_buff_len;
 		addr += trb_buff_len;
 		td_remain_len -= trb_buff_len;
+
+		sent_len = trb_buff_len;
+		while (sg && sent_len >= block_len) {
+			/* New sg entry */
+			--num_sgs;
+			sent_len -= block_len;
+			if (num_sgs != 0) {
+				sg = sg_next(sg);
+				block_len = sg_dma_len(sg);
+				addr = (u64)sg_dma_address(sg);
+				addr += sent_len;
+			}
+		}
+		block_len -= sent_len;
+		send_addr = addr;
 	}
 
 	/* Check TD length */
@@ -2324,30 +2358,6 @@ static int cdnsp_queue_isoc_tx(struct cdnsp_device *pdev,
 	return ret;
 }
 
-int cdnsp_queue_isoc_tx_prepare(struct cdnsp_device *pdev,
-				struct cdnsp_request *preq)
-{
-	struct cdnsp_ring *ep_ring;
-	u32 ep_state;
-	int num_trbs;
-	int ret;
-
-	ep_ring = preq->pep->ring;
-	ep_state = GET_EP_CTX_STATE(preq->pep->out_ctx);
-	num_trbs = count_isoc_trbs_needed(preq);
-
-	/*
-	 * Check the ring to guarantee there is enough room for the whole
-	 * request. Do not insert any td of the USB Request to the ring if the
-	 * check failed.
-	 */
-	ret = cdnsp_prepare_ring(pdev, ep_ring, ep_state, num_trbs, GFP_ATOMIC);
-	if (ret)
-		return ret;
-
-	return cdnsp_queue_isoc_tx(pdev, preq);
-}
-
 /****		Command Ring Operations		****/
 /*
  * Generic function for queuing a command TRB on the command ring.
-- 
2.25.1

