Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B403445455
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 14:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhKDN6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 09:58:42 -0400
Received: from mail-dm6nam11on2127.outbound.protection.outlook.com ([40.107.223.127]:37057
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231186AbhKDN6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 09:58:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wqqp9+oUniBxOlccXhQuWbojqBGYgxUAOtYoirbjFvB/opvrf1PGS3HEJpi4STpQHupIPbeSdrPLaOOa0JuGJv/A4m7fb5X+Kr7+8Aa/yIHYYIegIgXeyDwB2c+aN9eadJt6xqya1MHPlmsXZHA17pOl1x1FbdwWYEjUQpxPkUxdIVveZDgTw1SrvpNco3vDf3yUpwSVEgNN22kbMGm+GVUvodMcEjjS7c4WeBy2QO+6gdxNb0EogA6vszcqXDGmcLTqUErukPn+OT/3qDigOY/teXV1SaA8tcG1cZXqbAKp6jWbwqeETISYazra3QSGOMR+dj/tZGGsoo7YUQjHtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JtQEySusHCDcapXAaJ6D7toru6slVVw+7HCM+KmZH4Y=;
 b=HvZwW25hP9k47hx48nI8nVJnEUeZiuhT9K4dgRYlJyP/gANA6Qp2UFixiGKaOYCW8V9cTnSEC57v+NckFZ9Xk0xOur0wKPrUFMyN2GaQ9ecpPk34eTaazrxJEz8KDN7NmkjyQevUOy5+rnQV3n+MZ21zwmmeDT0sVH1wNJJ4RDFnJbhhs1zu8TW3YGYANV3SIf3dE1+3JgxnujeReijkCMvApzjjif8av6RH//5Pbj86UjiJ6AM10oxSp+K5TJJdp3mJqFd9pkndSRXz68381fO4xe0Xb9aCdrludtqXz+QRca4DA6T1tg+QugW9jzQdjRW5s2uksGVq6ur0RL0+KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JtQEySusHCDcapXAaJ6D7toru6slVVw+7HCM+KmZH4Y=;
 b=eo2QL7qoMhqy02nF/QFTXktvgdWJqlDqaJWSDVxRTnwYZmn7i/OxY9medS34IG4TYvpyPgqdV1Y4AR1k7lqB0XD1bs8C6bLPq0R0PcsYjQQTvCjpLVsWfVF19cVH4O57V1P7nKskvypXcBRBZkNX3+BTS6GWH186iBtENHxva9rsPMmC7LrrkKTa/MkjvxUflazAdw5Pf0P5GfeOssKPnDt2WhY7dI4M/GMtmtUc7LpejTbzITqnnjaVH8AUoslnPcVfuVirkvZSNHU+CZbdHm3scJjObaxFBV+7laA6Dz3wnUm9tU4Tv3yehdImQesdszESDeZVknnunmTvLAUCmA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 CH0PR01MB7107.prod.exchangelabs.com (2603:10b6:610:f1::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Thu, 4 Nov 2021 13:56:01 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0%7]) with mapi id 15.20.4649.019; Thu, 4 Nov 2021
 13:56:01 +0000
From:   mike.marciniszyn@cornelisnetworks.com
To:     stable@vger.kernel.org
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 4.14-stable 2/2] IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields
Date:   Thu,  4 Nov 2021 09:55:45 -0400
Message-Id: <1636034145-7962-3-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1636034145-7962-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
References: <1636034145-7962-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0019.namprd14.prod.outlook.com
 (2603:10b6:208:23e::24) To CH0PR01MB7153.prod.exchangelabs.com
 (2603:10b6:610:ea::7)
MIME-Version: 1.0
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by MN2PR14CA0019.namprd14.prod.outlook.com (2603:10b6:208:23e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 4 Nov 2021 13:56:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c2b22f5-8611-4cca-f635-08d99f9ad5b1
X-MS-TrafficTypeDiagnostic: CH0PR01MB7107:
X-Microsoft-Antispam-PRVS: <CH0PR01MB710787671563514248135ADEF28D9@CH0PR01MB7107.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:459;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /C5Fou25ce7KxiepRahtNdd5nAf3w/4qzAIAmxeODdm+jhXPzmU9h58Vl8HIoTsIteoE/UowXv4qQz3/jfCbLeGoo2vwjMo/7ZVefP92j0WpXzAvo2tD7z+bQASwKua4xhB3qvZlVyyZSmMPdMO5rwGgBxa9oBciN7m7+xdd9K6IsRqS/u+q7tXYkK+nsAPYOtoouTN3w5Lry8iC7Rl7iRSTdD5yG8MCig1WRWTkYdpC1kYq+gYiaS/41wJz0x5iCb4vuoPR+teqRk8Fwz4//TPiMbz0FsuZDmSFFL36aBThXJzOdLJslkOzL8zrRPN6WDOIe/08+Pkb4AmPR6wFmezgv1kutdIHKu1bTcaSrrVoIvYTphrKmn2EnoIdY23QUlcwOjEiQQD03RKp5oGljjFvhIcbZyNRcZb25iN0oIXpwRHkNyEMD4ToXqpX0KB9GXdCDxkamG3YopeFOhlWtWA502XpMrWzP8iN39KemTfrsP7X53PQd4Pdirp/rpzx7UjNTaGyy5nHzeJa4rtSWN99nwHEIJMNU71GiwWQfwWwx35H7lyqPiSaGcTWr3QTqMRQ3w/0BEaxX2eF9sGF0B76j8FLtA6V5enJKsJA4Z2C+ob9jWx5a5bGLrx9gIUT7cq9Nx55UBWcZQnxY3WjoCBTqiiAJiUGSU3Ko+AkcEKwtlXgoS7InJH4a1aYGiLJykSHf/B4SkOPgY1motsUrEcac9jbewEGPbrKmJHolvdREOEgUgo2/yEcUwB+QbRsmOq3G1IQ3a1214Y+a1vLjdY8p5XhzcmkFFfUfJ4er2c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(39840400004)(396003)(2616005)(956004)(6486002)(66556008)(66476007)(83380400001)(9686003)(6916009)(966005)(508600001)(66946007)(316002)(36756003)(2906002)(86362001)(26005)(8936002)(38350700002)(8676002)(4326008)(38100700002)(7696005)(52116002)(186003)(5660300002)(6666004)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3VW8RJRY1hxWZFPdNfrx8Euw4/GEYvQNv0Y6T20uZkxaAwCycoirXGzriPvh?=
 =?us-ascii?Q?6f6vNLU9/MYkJ3uctYdsaBCDvAvGI51ek82a1QG+QvT/H6vYYeZDnVfwh5LN?=
 =?us-ascii?Q?699sZxQyuhIIEWdQduC3R9bscnsAMdZXeP91Kh7KruiZrGbvFzcs3saOyI3u?=
 =?us-ascii?Q?oC9sOhXm6N1M2U1cpoI/f/IdGk3EDm4bzI+8vA33/glDPK7qTzBC43L0/DGk?=
 =?us-ascii?Q?/j3c2bSd06mZXLpqp9xc7fUSQuCuOZMbsxdUMh4LldcAbb/fVJW85k/5LgQS?=
 =?us-ascii?Q?yu0qd/49s8CtA3YMIMJeOG8UZi9ZfByGNQOBjy8wM1ivgHeMCFWv0IZeYVJe?=
 =?us-ascii?Q?8SrTGRDjbDIjSH3gx1n+/XhVq4Je2HaP5kV7PT+rFLA8r6GbwVprXVBHFka+?=
 =?us-ascii?Q?JpU5pdXHgW1efZOqkQSSQ+O9RxocBm/HjfdOozVMR1j4r1oYQitHUH9cKK/B?=
 =?us-ascii?Q?+yrJmjsLtsgnBHZHo7ePZGV6/mcotFadp+MEgnWYq6IQAvDM8bdPw2oc0nBh?=
 =?us-ascii?Q?LwqwJzXLLSRZwjJkOMmaYAMyXieQqUoFwAXdnTLHgSp8u3fM1r4toxV4BLRr?=
 =?us-ascii?Q?9eH57Ep5o6qrG7zVtIBEDAkuRKP/ilZGiTGSQ/gim6tOzhr6VsSE08CeMQ0f?=
 =?us-ascii?Q?IVMCHl1jtT/QjjQ4SbS1oGzRuCSrcarPM+4AtGP2rkUIBAzq3ekNEZDV5MBb?=
 =?us-ascii?Q?Cj7SzM1AB3F3AgI40+N8y53O61ka/pb3ejCnLpt1GaC1uqSaHHbihLA7+MJC?=
 =?us-ascii?Q?KG665VxpEMZV88BOPU1nubEsiv7ohhifDskKeDP6nUICYOKwdWyx8lDdURs1?=
 =?us-ascii?Q?2hpFrdBINzsmeQLS5bgzWwMjir5T3z4tzWk4tVE58NEJkH/f4bcGVpZX3lmq?=
 =?us-ascii?Q?agr8UUz5BxNeJRch9yhzxb5DTHzUkv6llviivG4iSdpiTNGeZsFPy5ITmUSZ?=
 =?us-ascii?Q?8YWqVBqYKtlwZBnlpIXxwS4YSpyO7rKyMoaInLcPlXd+kH8LKxVf2ohn6MHO?=
 =?us-ascii?Q?WbLZ7ZZEzm5FSh+TXaoej8A5VamKK+4cBwgpT6b0ogbX+nNfpcakER/Nx+7w?=
 =?us-ascii?Q?1/SziWehUHiYtcwPe6IWeq/nbadK8d7HUtFUn9teOCRGpooCw1Y/WYM75hz0?=
 =?us-ascii?Q?OcByOEwI1q7YCLftqMfJhXodt2oJ2+aMNy8cq/4lLeqpzx9/CDTG0z4ulj6O?=
 =?us-ascii?Q?WQJw5NjNhuX5ivVdrn74b5clv46CO8lVnJzruyqD9B324FrmBDJjkfDLYGUC?=
 =?us-ascii?Q?/EN2r/eqt8L38fxbE3P/UKvhPH8K75CO90KF2pfk4cubKCrmZqv3Ejuy3rtL?=
 =?us-ascii?Q?IJ6DqRg1zKp0LxfUNE4EYOy90keGojHbtKWatXJ3O4r5+w0WsgyRktoVxcAD?=
 =?us-ascii?Q?pppLdGKgLE5QQ9J0Ms5noty2mKP18nOrqjbcLOZ78s1I7bztbkU4D6Yh4ePl?=
 =?us-ascii?Q?UeUuyJtoq250G8/BoO086aKiGlYcxlpjupHratDxp2p3d/3FwlWhRcCRoC64?=
 =?us-ascii?Q?Bcfo+Co8w5PeqcrsksXbHlt49u4zUrycccqEpqy0J0Z0aRgFnY901q5jNHOG?=
 =?us-ascii?Q?Px5sSImqvzSqSjb7hAA3FPz2A/KCE8naxM4uonVYgvYwITMT9Qt4eEj3l251?=
 =?us-ascii?Q?nlc6xi9DW3wNK2O7pnE1vof5hcwIP7LfMwq4Z3lXS9obch/O3BFZ2NNrnZdi?=
 =?us-ascii?Q?kprmU6WRP0Y/estLpFmx7piv8lS6r17SlM2zjDGn6Xd47v4hGa/2D/g4EmU+?=
 =?us-ascii?Q?aVQJcorvQQ=3D=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c2b22f5-8611-4cca-f635-08d99f9ad5b1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 13:56:01.0039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N3o4pHX8kRzLBNFVrhWhLlsrJam8HVUYqT0DeWLMBBd4xM105M0gAkEdF6p5PAGsCPfVstS5bEvI31uJ9gXnSCSe8AqHS5aPYXxsH4sOawBorfz2eCEqjb0Z9+nt1hQC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB7107
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

upstream commit d39bf40e55e666b5905fdbd46a0dced030ce87be.

[Apply to 4.14.x]

Overflowing either addrlimit or bytes_togo can allow userspace to trigger
a buffer overflow of kernel memory. Check for overflows in all the places
doing math on user controlled buffers.

Fixes: f931551bafe1 ("IB/qib: Add new qib driver for QLogic PCIe InfiniBand adapters")
Link: https://lore.kernel.org/r/20211012175519.7298.77738.stgit@awfm-01.cornelisnetworks.com
Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/infiniband/hw/qib/qib_user_sdma.c | 33 +++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index ffb4257..42329bb 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -607,7 +607,7 @@ static int qib_user_sdma_coalesce(const struct qib_devdata *dd,
 /*
  * How many pages in this iovec element?
  */
-static int qib_user_sdma_num_pages(const struct iovec *iov)
+static size_t qib_user_sdma_num_pages(const struct iovec *iov)
 {
 	const unsigned long addr  = (unsigned long) iov->iov_base;
 	const unsigned long  len  = iov->iov_len;
@@ -663,7 +663,7 @@ static void qib_user_sdma_free_pkt_frag(struct device *dev,
 static int qib_user_sdma_pin_pages(const struct qib_devdata *dd,
 				   struct qib_user_sdma_queue *pq,
 				   struct qib_user_sdma_pkt *pkt,
-				   unsigned long addr, int tlen, int npages)
+				   unsigned long addr, int tlen, size_t npages)
 {
 	struct page *pages[8];
 	int i, j;
@@ -727,7 +727,7 @@ static int qib_user_sdma_pin_pkt(const struct qib_devdata *dd,
 	unsigned long idx;
 
 	for (idx = 0; idx < niov; idx++) {
-		const int npages = qib_user_sdma_num_pages(iov + idx);
+		const size_t npages = qib_user_sdma_num_pages(iov + idx);
 		const unsigned long addr = (unsigned long) iov[idx].iov_base;
 
 		ret = qib_user_sdma_pin_pages(dd, pq, pkt, addr,
@@ -829,8 +829,8 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 		unsigned pktnw;
 		unsigned pktnwc;
 		int nfrags = 0;
-		int npages = 0;
-		int bytes_togo = 0;
+		size_t npages = 0;
+		size_t bytes_togo = 0;
 		int tiddma = 0;
 		int cfur;
 
@@ -890,7 +890,11 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 
 			npages += qib_user_sdma_num_pages(&iov[idx]);
 
-			bytes_togo += slen;
+			if (check_add_overflow(bytes_togo, slen, &bytes_togo) ||
+			    bytes_togo > type_max(typeof(pkt->bytes_togo))) {
+				ret = -EINVAL;
+				goto free_pbc;
+			}
 			pktnwc += slen >> 2;
 			idx++;
 			nfrags++;
@@ -909,8 +913,7 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 		}
 
 		if (frag_size) {
-			int tidsmsize, n;
-			size_t pktsize;
+			size_t tidsmsize, n, pktsize, sz, addrlimit;
 
 			n = npages*((2*PAGE_SIZE/frag_size)+1);
 			pktsize = struct_size(pkt, addr, n);
@@ -928,14 +931,24 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 			else
 				tidsmsize = 0;
 
-			pkt = kmalloc(pktsize+tidsmsize, GFP_KERNEL);
+			if (check_add_overflow(pktsize, tidsmsize, &sz)) {
+				ret = -EINVAL;
+				goto free_pbc;
+			}
+			pkt = kmalloc(sz, GFP_KERNEL);
 			if (!pkt) {
 				ret = -ENOMEM;
 				goto free_pbc;
 			}
 			pkt->largepkt = 1;
 			pkt->frag_size = frag_size;
-			pkt->addrlimit = n + ARRAY_SIZE(pkt->addr);
+			if (check_add_overflow(n, ARRAY_SIZE(pkt->addr),
+					       &addrlimit) ||
+			    addrlimit > type_max(typeof(pkt->addrlimit))) {
+				ret = -EINVAL;
+				goto free_pbc;
+			}
+			pkt->addrlimit = addrlimit;
 
 			if (tiddma) {
 				char *tidsm = (char *)pkt + pktsize;
-- 
1.8.3.1

