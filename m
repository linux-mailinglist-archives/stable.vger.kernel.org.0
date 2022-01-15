Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A402548F9C6
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 00:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233891AbiAOXC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jan 2022 18:02:59 -0500
Received: from mail-sn1anam02on2093.outbound.protection.outlook.com ([40.107.96.93]:33155
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233870AbiAOXC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Jan 2022 18:02:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ty/F1h19RKbGc+U1LIb8gRr19MYCMlvBVbLjpGcdHw0QPgEdUlPlAzi8m7yijTMImud3Da2EIqSz8T2XpFzK/IO5/cBupAggYYaXdzPCVTxaP9KsSoR3kzE8KeRTsDS5z94PRfL6Q3P1lI5B2IQt3lvhuJyD15dz6eTnlgNQIJXmZwHWA57ZLO+Tg1EPYuJCvSyZEvfVq+mzbtWIs9tp5/etJM5Dbm7ViWMVL+w4nhujv8IPhTNWomCVevR3IBVQBFqsrbJ/jEfpVs45Vqu5dQdgbAGSzPgEydc/E+bK38DYqLWgTqeAyBKWkmAJ9MpxNilyt9eQkWBW7ziOnk1HvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7hDKk4IFo85fdT65LkGB72YBZl2QindArRfDEIUHsRg=;
 b=JbcKEWMaVZ+tYdfOjXyYUTzrlilA51MCFaTS0AT14n4q65NirIkfL6r777xrBH45JY5QYCxUEzVnewIumWmRvHcELutstKZYr3XO8MgRQtYiZiINeKbIODwOEAPEkbfFQS+yj91p/+Mwjb9/bsc7nuPGDiTxa83fEo91bWgxHWyYcyqUtmqAcTxJ6FMqpHxfqF8vUfTsShG5DwcOpOGlD/TaY1hvVauFfOhKQmFaNXv7RwAirRigaqXkY4oLeuabMB13rSaVenRRnoRWyg89SeYfdAuHKaHz53cdF1JbOL2xx2igQ8qmrkjEHF+HUyf39u3RJcueI8PmvNdJBtV12A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7hDKk4IFo85fdT65LkGB72YBZl2QindArRfDEIUHsRg=;
 b=g6dqbelly//RDn5Oe/R7g2TH6Kkd8b6g1+r9I4HTkYkBiiOmFOH/mE9FVZN/3bZCbhyq3UUThG5kotqSLD/eviUau9AUdwYaCQYnB5euoZFMmkjLb2xRrIYTvcmlsKAO7xQaf9akaRvUron//K/c8NzqpTj5jdovk4e089B55lZSvsV8VET7XlJC/dZZjzFhiSbE+SaGY50EA0ePvXDjFKH1Tbdoh1fRWFQla+QDqFhkN7qna214U3k8gwVLIigSRgz47K3kSHXKDd2t2g2NscBxLKJsuClSi+ys/vO7Zqyn5eL5KrxpWSAjDAt3gWjwtrS+8JdWOqxhUkVzPnmAcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cornelisnetworks.com;
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 SA0PR01MB6140.prod.exchangelabs.com (2603:10b6:806:e4::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4888.11; Sat, 15 Jan 2022 23:02:57 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::110:392e:efd1:88d0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::110:392e:efd1:88d0%8]) with mapi id 15.20.4888.012; Sat, 15 Jan 2022
 23:02:56 +0000
From:   mike.marciniszyn@cornelisnetworks.com
To:     jgg@ziepe.ca
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        stable@vger.kernel.org
Subject: [PATCH for-rc 2/4] IB/hfi1: Fix alloc failure with larger txqueuelen
Date:   Sat, 15 Jan 2022 18:02:34 -0500
Message-Id: <1642287756-182313-3-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1642287756-182313-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
References: <1642287756-182313-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0106.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::21) To CH0PR01MB7153.prod.exchangelabs.com
 (2603:10b6:610:ea::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3bb418cc-55f6-4219-d5bd-08d9d87b2b2b
X-MS-TrafficTypeDiagnostic: SA0PR01MB6140:EE_
X-Microsoft-Antispam-PRVS: <SA0PR01MB6140423789B1D690358D8F49F2559@SA0PR01MB6140.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bnr7tZlefjANoZMxRUL8aIB0Ll02tfa2bSdCM+9tRNg6s0MGAOVY6j8IJoWlwWKkX1nnqf8M0Q4LzCCQ16jtwd2Do7rihsKh0KVuzkYl219LnwhDHLY0Xvn9BHsQydbgP2g8/MmOV1V/TlblkAQwLTdLB0XWsRQ0P1LCLjQJwaDM/nynwWA9Qng9UdC+R2O+HsdStYOG390cgMj9wbsjIpZrKmQpTqCQMXMly47aEz1ssTz0DD7WSVWYEKpw2SBxLnREv9uyjObDw5We9VDH06Ab7PyXgPTUv83WyKZGl1ljKwcUciBZoy+vRDwW751wef+rNHpHTwukQaA1KZXczLh4G01FbQaUCCQPBRKJVPl/ttrGZ1bq7X3RwatHulpMtMlpKJqk7dJRkMbBez3gCIPFvrZY+i/gImjLFLzNMUGU6Cn+MX+JvRKdGDi6x20zmuCJLl8mMM5ri1yK1x7hCI93BQye8pHgavoHjYnu9aWug5MjxDmD2BOpk+eejwge3/ek4fJzVNEKI0mLU+4C94pSEGmvVuyjEBOiTCpOZEy0RJhwiIzt0pKZCi8C/e2JYCAWk8x3akJw4hEjDXuDL4s17j7KvLmLtliVvIG8uxHvxzRMQuItvS39oYksqNygvsLuCNXlV0MRcFPUy+nmj9nDPefn07W4tVYbAx4WpSXvjAKU9Sd00lDLczBZvUoPNvNjkxJcIVH1IWCQy2vTfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(396003)(376002)(136003)(346002)(366004)(36756003)(86362001)(508600001)(4326008)(26005)(52116002)(8936002)(6666004)(38350700002)(38100700002)(6916009)(8676002)(6486002)(66946007)(5660300002)(83380400001)(66556008)(66476007)(186003)(2906002)(316002)(2616005)(9686003)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LXGQV5uP2UCYdkR7jtog+sBi59krvM/WHfGcTBjjcuRfJXV0MT+UlHxq45nJ?=
 =?us-ascii?Q?//D0mCKMGqwSCNOtijIDmEfc62FK9yCSk74Np1Y/kVRNxRLcPr3yIYbpdI8x?=
 =?us-ascii?Q?yIfDB4Jsd3xStBj2DaEOQZ48tEsOfDbYbp4tYyWF4Zl/fxXy2B8dYaTHr0eQ?=
 =?us-ascii?Q?cGV8XHq5tJjDOFqscdFybQObjH5FGWrQCnHdJVBemtuBirUHwOZpPaa/OUFi?=
 =?us-ascii?Q?rSdjFAD6XAJAVstwhcMAVcOhEwDALZQLvGvpALHDnTlFaoBkJoY+Kg+oqUQc?=
 =?us-ascii?Q?IpyufpYDAMP10wZnxzvIfQhFII7EoUHi40DEmvHczuveL18VRlc/Z+jAYrkN?=
 =?us-ascii?Q?riLwtE/o65w0SDFXXRAxuZLS1pVSYV/1aOcWXjzTThkm94pUFIbjffHeg1tj?=
 =?us-ascii?Q?gICpN3tbKlFDoMonBsvghkNLjor0Y+t8jUrV5GILTGVOuKpOdNCAwIC9xxlG?=
 =?us-ascii?Q?x9RiVd+ICbxD8BZ2unl7k1yS6YhoHr9hHRrcTeoFpcqPck8cheig2S1HShEF?=
 =?us-ascii?Q?y2Lk9VlT9Gi0+7E0jSEZ7bcgnw5uBlTx7PIPH+tnXTTL3ONb6SNplsztVGQ+?=
 =?us-ascii?Q?zTL/Pm6UBvBqp8IWpmso67c73GPQUCMAhiobVtMEzMgQS2CO+a0gF3yzlEZn?=
 =?us-ascii?Q?r1YEvhqees4y26fYjSI0SGD++0fHdruXn82lLpXSVViU652lW8H1ey68fjS8?=
 =?us-ascii?Q?YDMmLVcRiQAn/6K2YhcQiSGF2Cwo3bDnxkgsJQALMGKo1r1LluAaVhXtz8yY?=
 =?us-ascii?Q?61zMauT0xnMxRuq8gBBfYGdHqeBOMy3CO3b3RuElhneARfbaMhKMb5LKVmcz?=
 =?us-ascii?Q?x7KTkraKH59pZH+ePTOIxDeM+wte8oSDZoYoPVbozYfajCaPAZyK5eGcHXsn?=
 =?us-ascii?Q?J1wTGzoNWLzAh/On80A5JBkdvKpV+ewcoKVvoJi4ah2ZJJW0rt626Su/e9EW?=
 =?us-ascii?Q?XS1odV67YPDLSFGTteRaQyS30v/FS/VtQ7cKgNDADD4aYZSRdcRKA62Z8ub/?=
 =?us-ascii?Q?PnFPAdazRtNIweOEaVZ6Ad7IHTE9AL0/+D+68k5uq5s60yt9JI3/fQx5iE7P?=
 =?us-ascii?Q?KymoRTt2CRTb+LOD5cbs0dzvJIHCKQ+cSzueuXyc1jnlHkdgKsqvndVQ686K?=
 =?us-ascii?Q?LoswFQpk6/cS6FOIOpNjM7MBeIqLsxQVH9zX6dxHIX4UuZfZljVN8efLgwpL?=
 =?us-ascii?Q?n2z9B0f7s9sUmUL6Kub03U4zt2+iIbfBv2rqVgu2zd+0iFXvMdD6j0xq6kGR?=
 =?us-ascii?Q?TUSSoPuKLhHJpCMq//otiykx80u+uZUw2jNyuSOZHAB9p7stL9SElTovPvWy?=
 =?us-ascii?Q?UzI5yw9b82aGpLWEjp61DWqp/BTTZ8QQB20Ph9811e5CT2Dk1O8Sx6hbYiCr?=
 =?us-ascii?Q?9E+mNvRF7W/0T03zugOfQBeU7tOznr76fczydtdB971xLTWSVgz6Mrqhysid?=
 =?us-ascii?Q?kwxG91f/ztgvYl1XBKOuDxHwS/6MSj+6zFZS0q8guF88/Y+80CXYh5fgiaFs?=
 =?us-ascii?Q?wYLPGKXkgG++GNQ42xI4L1/WDEBV1i6VO1CxtxsoZD0Cz3X+0895/+Da4yG8?=
 =?us-ascii?Q?g5gZ06O+I4RhWBtqBjhZryIsg4CNCDGQBGOv48t2UkN2HL7npqFJF7hROW2A?=
 =?us-ascii?Q?Y18EVsBIZLIHPmhWNyfqEta06OE2r8g30kwojQoX1Q6TjyyJIfBmQGkI4noT?=
 =?us-ascii?Q?H0jiDPs/DZ/hhVdZEeHE7TARZGhX8XiB/olSqkgP7OHFW0oCqdKYL2IYn+C1?=
 =?us-ascii?Q?Hvu66Y1pMQ=3D=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bb418cc-55f6-4219-d5bd-08d9d87b2b2b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2022 23:02:56.8536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Vk0Cxu6mpeJLYy6oT9e8UPS3OjQ3r1R3fPndjWzNJBie7oxlF8fwmX9UO5TRWaoghVZ4nZ1vOTx/LlvVxjdrtgAqszNrD5FPG2FrrSgLY8C3+XVa2pp1q/Hst0ZZVbp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6140
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

The following allocation with large txqueuelen will result in the
following warning:

[  136.166367] Call Trace:
[  136.169661]  __alloc_pages_nodemask+0x283/0x2c0
[  136.175273]  kmalloc_large_node+0x3c/0xa0
[  136.180289]  __kmalloc_node+0x22a/0x2f0
[  136.185110]  ? __kmalloc_node+0x22a/0x2f0
[  136.190169]  hfi1_ipoib_txreq_init+0x19f/0x330 [hfi1]
[  136.196453]  hfi1_ipoib_setup_rn+0xd3/0x1a0 [hfi1]
[  136.202396]  rdma_init_netdev+0x5a/0x80 [ib_core]
[  136.208210]  ? hfi1_ipoib_set_id+0x30/0x30 [hfi1]
[  136.213995]  ipoib_intf_init+0x6c/0x350 [ib_ipoib]
[  136.219873]  ipoib_intf_alloc+0x5c/0xc0 [ib_ipoib]
[  136.225751]  ipoib_add_one+0xbe/0x300 [ib_ipoib]
[  136.231563]  add_client_context+0x12c/0x1a0 [ib_core]
[  136.237739]  ib_register_client+0x147/0x190 [ib_core]
[  136.243906]  ? 0xffffffffc0570000
[  136.248123]  ipoib_init_module+0xdd/0x132 [ib_ipoib]
[  136.254212]  do_one_initcall+0x46/0x1c3
[  136.259136]  ? do_init_module+0x22/0x220
[  136.264043]  ? kmem_cache_alloc_trace+0x131/0x270
[  136.269813]  do_init_module+0x5a/0x220
[  136.274547]  load_module+0x14c5/0x17f0
[  136.279246]  ? __do_sys_init_module+0x13b/0x180
[  136.284810]  __do_sys_init_module+0x13b/0x180
[  136.290295]  do_syscall_64+0x5b/0x1a0
[  136.294914]  entry_SYSCALL_64_after_hwframe+0x65/0xca
[  136.301070] RIP: 0033:0x7f3eacd0d80e

For ipoib, the txqueuelen is modified with the module parameter
send_queue_size.

Fix by changing to use kv versions of the same allocator to handle
the large allocations.  The allocation embeds a hdr struct that
is dma mapped.  Change that struct to a pointer to a kzalloced struct.

Fixes: d99dc602e2a5 ("IB/hfi1: Add functions to transmit datagram ipoib packets")
Cc: stable@vger.kernel.org
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
---
 drivers/infiniband/hw/hfi1/ipoib.h    |  2 +-
 drivers/infiniband/hw/hfi1/ipoib_tx.c | 36 ++++++++++++++++++++++++-----------
 2 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/ipoib.h b/drivers/infiniband/hw/hfi1/ipoib.h
index 9091229..aec60d4 100644
--- a/drivers/infiniband/hw/hfi1/ipoib.h
+++ b/drivers/infiniband/hw/hfi1/ipoib.h
@@ -55,7 +55,7 @@
  */
 struct ipoib_txreq {
 	struct sdma_txreq           txreq;
-	struct hfi1_sdma_header     sdma_hdr;
+	struct hfi1_sdma_header     *sdma_hdr;
 	int                         sdma_status;
 	int                         complete;
 	struct hfi1_ipoib_dev_priv *priv;
diff --git a/drivers/infiniband/hw/hfi1/ipoib_tx.c b/drivers/infiniband/hw/hfi1/ipoib_tx.c
index bf62956..d6bbdb8 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_tx.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_tx.c
@@ -122,7 +122,7 @@ static void hfi1_ipoib_free_tx(struct ipoib_txreq *tx, int budget)
 		dd_dev_warn(priv->dd,
 			    "%s: Status = 0x%x pbc 0x%llx txq = %d sde = %d\n",
 			    __func__, tx->sdma_status,
-			    le64_to_cpu(tx->sdma_hdr.pbc), tx->txq->q_idx,
+			    le64_to_cpu(tx->sdma_hdr->pbc), tx->txq->q_idx,
 			    tx->txq->sde->this_idx);
 	}
 
@@ -231,7 +231,7 @@ static int hfi1_ipoib_build_tx_desc(struct ipoib_txreq *tx,
 {
 	struct hfi1_devdata *dd = txp->dd;
 	struct sdma_txreq *txreq = &tx->txreq;
-	struct hfi1_sdma_header *sdma_hdr = &tx->sdma_hdr;
+	struct hfi1_sdma_header *sdma_hdr = tx->sdma_hdr;
 	u16 pkt_bytes =
 		sizeof(sdma_hdr->pbc) + (txp->hdr_dwords << 2) + tx->skb->len;
 	int ret;
@@ -256,7 +256,7 @@ static void hfi1_ipoib_build_ib_tx_headers(struct ipoib_txreq *tx,
 					   struct ipoib_txparms *txp)
 {
 	struct hfi1_ipoib_dev_priv *priv = tx->txq->priv;
-	struct hfi1_sdma_header *sdma_hdr = &tx->sdma_hdr;
+	struct hfi1_sdma_header *sdma_hdr = tx->sdma_hdr;
 	struct sk_buff *skb = tx->skb;
 	struct hfi1_pportdata *ppd = ppd_from_ibp(txp->ibp);
 	struct rdma_ah_attr *ah_attr = txp->ah_attr;
@@ -483,7 +483,7 @@ static int hfi1_ipoib_send_dma_single(struct net_device *dev,
 	if (likely(!ret)) {
 tx_ok:
 		trace_sdma_output_ibhdr(txq->priv->dd,
-					&tx->sdma_hdr.hdr,
+					&tx->sdma_hdr->hdr,
 					ib_is_sc5(txp->flow.sc5));
 		hfi1_ipoib_check_queue_depth(txq);
 		return NETDEV_TX_OK;
@@ -547,7 +547,7 @@ static int hfi1_ipoib_send_dma_list(struct net_device *dev,
 	hfi1_ipoib_check_queue_depth(txq);
 
 	trace_sdma_output_ibhdr(txq->priv->dd,
-				&tx->sdma_hdr.hdr,
+				&tx->sdma_hdr->hdr,
 				ib_is_sc5(txp->flow.sc5));
 
 	if (!netdev_xmit_more())
@@ -683,7 +683,8 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
 {
 	struct net_device *dev = priv->netdev;
 	u32 tx_ring_size, tx_item_size;
-	int i;
+	struct hfi1_ipoib_circ_buf *tx_ring;
+	int i, j;
 
 	/*
 	 * Ring holds 1 less than tx_ring_size
@@ -701,7 +702,9 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
 
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		struct hfi1_ipoib_txq *txq = &priv->txqs[i];
+		struct ipoib_txreq *tx;
 
+		tx_ring = &txq->tx_ring;
 		iowait_init(&txq->wait,
 			    0,
 			    hfi1_ipoib_flush_txq,
@@ -725,14 +728,19 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
 					     priv->dd->node);
 
 		txq->tx_ring.items =
-			kcalloc_node(tx_ring_size, tx_item_size,
-				     GFP_KERNEL, priv->dd->node);
+			kvzalloc_node(array_size(tx_ring_size, tx_item_size),
+				      GFP_KERNEL, priv->dd->node);
 		if (!txq->tx_ring.items)
 			goto free_txqs;
 
 		txq->tx_ring.max_items = tx_ring_size;
 		txq->tx_ring.shift = ilog2(tx_item_size);
 		txq->tx_ring.avail = hfi1_ipoib_ring_hwat(txq);
+		tx_ring = &txq->tx_ring;
+		for (j = 0; j < tx_ring_size; j++)
+			hfi1_txreq_from_idx(tx_ring, j)->sdma_hdr =
+				kzalloc_node(sizeof(*tx->sdma_hdr),
+					     GFP_KERNEL, priv->dd->node);
 
 		netif_tx_napi_add(dev, &txq->napi,
 				  hfi1_ipoib_poll_tx_ring,
@@ -746,7 +754,10 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
 		struct hfi1_ipoib_txq *txq = &priv->txqs[i];
 
 		netif_napi_del(&txq->napi);
-		kfree(txq->tx_ring.items);
+		tx_ring = &txq->tx_ring;
+		for (j = 0; j < tx_ring_size; j++)
+			kfree(hfi1_txreq_from_idx(tx_ring, j)->sdma_hdr);
+		kvfree(tx_ring->items);
 	}
 
 	kfree(priv->txqs);
@@ -780,17 +791,20 @@ static void hfi1_ipoib_drain_tx_list(struct hfi1_ipoib_txq *txq)
 
 void hfi1_ipoib_txreq_deinit(struct hfi1_ipoib_dev_priv *priv)
 {
-	int i;
+	int i, j;
 
 	for (i = 0; i < priv->netdev->num_tx_queues; i++) {
 		struct hfi1_ipoib_txq *txq = &priv->txqs[i];
+		struct hfi1_ipoib_circ_buf *tx_ring = &txq->tx_ring;
 
 		iowait_cancel_work(&txq->wait);
 		iowait_sdma_drain(&txq->wait);
 		hfi1_ipoib_drain_tx_list(txq);
 		netif_napi_del(&txq->napi);
 		hfi1_ipoib_drain_tx_ring(txq);
-		kfree(txq->tx_ring.items);
+		for (j = 0; j < tx_ring->max_items; j++)
+			kfree(hfi1_txreq_from_idx(tx_ring, j)->sdma_hdr);
+		kvfree(tx_ring->items);
 	}
 
 	kfree(priv->txqs);
-- 
1.8.3.1

