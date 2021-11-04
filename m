Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F584455B2
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhKDOwx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:52:53 -0400
Received: from mail-mw2nam12on2120.outbound.protection.outlook.com ([40.107.244.120]:26784
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229920AbhKDOww (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:52:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4gd0Pea1HZklZW4GMARmGrv3O862MIZEGOOyn9DKXfKGMKIGBnE/q5oZj/Zgq2bSA/gcPdgtFk7Lg+Ql/edPYwG84yEomXyl1pTXH5n4hQcAvWtCqjLTjHRgVemd3KIzGuJMRK59rfkFjAqPli7nIAhWXQ0IPN7MUwWEwh6+i0RS5YazTvDnp03EdqrlQ3C44Oy3qIvk6a7htZpNyEs3f6/uGicVIJutLcorTH1+45MqO7FFeGAR/w+Eo2F1lA6tr9DoMiVnmdWKgYEv4rvmJTcQPvcaw1KkQcYkwI+MtS1aPsEKM+JmC3Y86TMoS+6Jsd2N6eqt1wZYWAn/kpbFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRpu4CaaILQYhn6i+wiqTdkFK0+wY7VP0Tx38dsQA68=;
 b=LDTdaUN3jsahhFl7QeBN0yft/3oYCjowa8CQ1/Co0r8N5trlsybhlN10enN4yl+jA24id8d97lcs6dzHtDLJjwhciQXa41PpIAut6kJ2Qj1WolPC58sry8h4o4arQGtcZHW3qEc0uXw/BDoJYgqnfmMHhF4oK5GKSVHN1UvQXnK2+xLa6AjiZOc8MnY+tiJ2ZmBHQjXRwNO2597PDQHM4aU8p9ATzeFdA4xDT0jKFpHj4um7epkeEQm1L+bro+v179FmsDZGyucbOCkMhiUE6R6fIiamHCpNwKmn8bCDmnUAeckXjSfd1LSBmXPQcrir0AXOrD+nAr3ndO4UfMq/uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRpu4CaaILQYhn6i+wiqTdkFK0+wY7VP0Tx38dsQA68=;
 b=l4oW3Xux2ewESziN5LQE+Jt2y14Nsd7JIsqxZ7a9zfZvid2gEcQN9dtK4ZZAbaWIWGXKxfjPvkMZJP4YYNB1uQ2vFbBEYMOUk+MhqH2WUuOCrDHh0gfimdm9Hg0QwXd4pX2psaU6ixTNaljh1EPNXUQ/bL6KdTbHda1V6uZnWi+HqaGUPqrImaN10nkBXhkPvJ+MO4MsStyT0wbZeUcud053uoCZRvzJLobsFooL2WXb/1uRiB2IByfB7iAouGCXALZGuawhJM8atfkuHyq7y53IIt3eWwKXlOYosYZel6armC189QqYm0fDNgDOPAG6u2Ss6n+0BhJ4B/rKwa0Kbw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 CH0PR01MB6892.prod.exchangelabs.com (2603:10b6:610:105::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.10; Thu, 4 Nov 2021 14:50:08 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0%7]) with mapi id 15.20.4649.019; Thu, 4 Nov 2021
 14:50:08 +0000
From:   mike.marciniszyn@cornelisnetworks.com
To:     stable@vger.kernel.org
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 4.9-stable 2/2] IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields
Date:   Thu,  4 Nov 2021 10:50:01 -0400
Message-Id: <1636037401-89082-3-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1636037401-89082-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
References: <1636037401-89082-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:208:120::20) To CH0PR01MB7153.prod.exchangelabs.com
 (2603:10b6:610:ea::7)
MIME-Version: 1.0
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by MN2PR10CA0007.namprd10.prod.outlook.com (2603:10b6:208:120::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 4 Nov 2021 14:50:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c227dccc-2cca-4ac7-8f09-08d99fa26518
X-MS-TrafficTypeDiagnostic: CH0PR01MB6892:
X-Microsoft-Antispam-PRVS: <CH0PR01MB689206CEAEF24A094C43B647F28D9@CH0PR01MB6892.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:459;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5XqWcjmr1IOLLSW5fui5mw6//ecG+mX1loCsTGeWg3m2K8hboGl1HhyJ8Nu9AtIrI6Zbgf5Nr/uW29eCFMXvIoMtBTcQ6LxzQQEhp69EyM+LaXsSoOzS7aPcJxZ4vAw1qVTcSse92NH6mnAqmxDJwk934w4hQQO69Qjetx53DnqqaSNRULgRAAYLwYaHisuyrsGGEQ8xCDiLLCKVBPJRABGzKaw+K3DFpSCNCiak3b1QzydCPkR8E/zYzMlFyibpVbntL1No/OtVJUddEXrwBBwiqTsyOIDHwjaRHgvgzsY0sxdapPGt43ZFUInzvb+XAf9OrtDxWo1NdvjvNYB7qsFud4fI8czHaLabTgs/vopQy2FIH6cvoVEcEdX5UhRz/uS35raOeutwfulr0dYfqN+u3mMwQ/EdHfMRQ74j0Wsh6pdDmvpAQ5YSL2Fkav60un5S9O4TQJMLOS/Q2QiP8E6v2wTFlKNH1/iH3jZQw5eDEkmFXhBktPxxSQnl6+9YsLwuqhDIYAkzGPVaBIH3G01Vgh0A9XtEc53IgvIxANSg3NDxKOfDzBEVyv/0O43sAQbzNQ3LJPjmdNmmQsYZObs+JZeBh836t9ruAcWcnYBKAkgwO0TqQKwgNg5kixOKpT8484pfdKiON/y0rJBCrOZhzdyW6tScBiZxqPw48QdIdHa5oCJxtU1Slok6ZDra204eiqZvYi9qZMJkene2KFzZITbxvrjmHHNen3ASVCkw5qFFjOv+/bb5YTpYOpQ8ovhsnkzApJSAB3xCTKUEbyecCI/pEjzmhFDkCxR2ZAw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39840400004)(366004)(5660300002)(8936002)(316002)(508600001)(38350700002)(38100700002)(7696005)(52116002)(26005)(86362001)(66946007)(2616005)(6666004)(4326008)(6916009)(956004)(83380400001)(186003)(2906002)(54906003)(966005)(6486002)(8676002)(66476007)(66556008)(36756003)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cYF9b5Nn3Lhray+zhX/2batytDdlt/bb920/3MGEXGu8QZPdoZYgL/sUj/TR?=
 =?us-ascii?Q?J1JLjCJyvNYGnabsBvk9gO2dLaCepZW7GuQg9GCwuftGVfRBkq1JRVj6pUs7?=
 =?us-ascii?Q?56juXH1907NkX8zc0EuMANUKkXe0xpv5B5yV10oWgqZJ5T393+9VcDu+lMbN?=
 =?us-ascii?Q?ap1Wo8zxAZ3z5Sfzd53bdGk/565Hs6MgE1H2ObVeCkuWYcrbLtPvTanQewIl?=
 =?us-ascii?Q?cVT1+PGnmw0rmawpn3pv/64MrRZl8jBWL+ms+mF5eIXxZ/VaL8j7dqfd45tN?=
 =?us-ascii?Q?bK8kh4RHf0lHUZbc493EH/u2kypMtEqNYXR508ClkNKfLHZwR9oaQk9/1hgg?=
 =?us-ascii?Q?/DlqVCTe5x2EqsW8UbjTFDBCJysCTfWyd59gtoxF/WyOsVTpAoIH+gKQQKGn?=
 =?us-ascii?Q?TCWVQgTTeO81EIhfLG6oO6uX2SYzwwehC5YMRBooJ6Vly7ShQ+cU/Jqgzh2r?=
 =?us-ascii?Q?hatVQIXE2CwMSkuOXNVjnitCTEIda2zikxbEXpwzY2qjYYvmCvD34QnkN799?=
 =?us-ascii?Q?Q8YYDAwyP11iThF2Cjn4KLX0TnsvRCZq1Ntn0Os+MnXi7OL29OEBWJNyEWsP?=
 =?us-ascii?Q?ZhbMlnD+wE4ThBva38W7PBbqS1A76bo10SdmYuhjJexMtA1vYj+XwD/wW1QG?=
 =?us-ascii?Q?35kfW/ik9iOiBWmOXhqstTN+x/04qj/Fok5lvJ2BFSCZ23JGU1YMMHlancqm?=
 =?us-ascii?Q?wrljNbgDqCkDRqBiqkRkcQqlinnPlwolUXFzYoKD+L79xaukNFIA9D1kViZx?=
 =?us-ascii?Q?f+S7sFRjW7cY/L5266djO3TWEI10DUUs3kt4QtJHbTb2Im8EUHjSibA7gSQT?=
 =?us-ascii?Q?9OCZeLpJ3ey9v3bWivdsAEW9YhWD/ZRB4f6eWiRK/MPhyiRWd+spbWH5OJdA?=
 =?us-ascii?Q?YQh2O7VRZ13qWi/J1KBirl9hTS68mI11PD4tRh7hnHkLVeczqB84nnCj8kbj?=
 =?us-ascii?Q?K+uWbr9wlxCVNXrOW2hngC3c88OHIg/TU+Yn2oYrbxpTJ3vpw3QeCFAe+trg?=
 =?us-ascii?Q?Snu8CdOaT9h9lR/jMnlimqEUM3G0ZpxmgbjdU7B6HFUyGTNA63/yTYyH7GHd?=
 =?us-ascii?Q?BsRuT12JiUwW1ZwaBun8bhBxs1LWUfJPImIXbQkFomFA+GoE+OUcfSC1IR3m?=
 =?us-ascii?Q?jXjw8rNSYxWXW9LnUoQzPyEKctIWVi5CYTb1J/g9lp07cjNxoFdK2szVYP6D?=
 =?us-ascii?Q?Y3LeO97tzxqdD87zY9VDbo0Z1fUuE6RuIkMq7gB6qN/qg+VBo67jHztlZVr6?=
 =?us-ascii?Q?dugmxcgtAUZzX4HN4fPHzgWEEJA9mFoGurHb/jcO2KHy7zOL39tZtAtjtY1/?=
 =?us-ascii?Q?Fld9WFOX+yY2xZlbwYR30DoNQajVJHKNXZM9VHi6LTVNP1EWI3TR/OGbHqC6?=
 =?us-ascii?Q?dJqb2Sf/EQwO7gcFEdUMGL0iOEz7Ooq1hJW3ToJ59GdeCIPGc07bRhaUc1vV?=
 =?us-ascii?Q?MDjWala7rGqEIqVidztks+a9YnBcKXm2DbJ2zYIAxlaaFkbPkoPVXDQoa5Rd?=
 =?us-ascii?Q?a3iJwZejEZ8lQqDn1UTOb/7+eju952VgvtG1C4AtDZM2GdPf+rL4dQO1hFYI?=
 =?us-ascii?Q?C8lR00WSWb87o/R3f/vOXpPmEAh//l4gHD9iIArA2aSW5k38aafx986zbxHd?=
 =?us-ascii?Q?ogyc8JZRpPlLSEt/Yn6HruvzqOpHNxoiijPtB7pbic0ghHU/xicEwa1SdYZ5?=
 =?us-ascii?Q?KD37FNxwIyLvaCS8Kn3TPn5HAs75ll38uwI+hAA0f7qam87dDWtw5vsvDe/v?=
 =?us-ascii?Q?m/cAeO4A2A=3D=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c227dccc-2cca-4ac7-8f09-08d99fa26518
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 14:50:08.1094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DAe0ehU8KJiMGAvnZcXa99ApJBGpP5are33uezKSnpLjDFshwYIWZUa35FzMA8xMS86k0h0pM+hnDkebg//YsCybwHTgGalIgUiW8xP1t/L2aE44L9piTDSuge/cZ2z9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB6892
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

upstream commit d39bf40e55e666b5905fdbd46a0dced030ce87be.

[Apply to 4.9.x]

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
index deef6ff..0dc15f9 100644
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

