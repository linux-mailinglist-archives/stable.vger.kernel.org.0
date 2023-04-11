Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826C06DDF2F
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjDKPMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjDKPMN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:12:13 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA1D4C2C;
        Tue, 11 Apr 2023 08:11:59 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEwu5A022973;
        Tue, 11 Apr 2023 15:11:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Fg9T0m7X7w29GcvBtWyPWgaJzQWqhHR2/JH+eaFF9LE=;
 b=A4GrUFiGHC3sgpCTlnzlqio+Xr6xFWKf5LMZOpmmaM+NOn2350taFfHw94Hxqx4OxSVU
 KYQeoj10sDTuTW8dbsk4TvLQXlvPdoL7jX7KrJejNiBXCOHzcsvHlSTlYfOHAiii5MGV
 M6JnvZoDtfCjvPRNfpOZnlxjsU+knFahBSc/xFrzrNyj5wJp+lUESpmA4SIX8C+d9XRs
 e1sd3RyIwldhYKW3SX30q9R8NhL5Gw8w86cxePrEKyRcOX1LFYayWikdyP2St0ROAYB2
 6zx1CdhX6XqHEbYmduicDyJoJbiWyKtUNkGtxJ9Jcf8v+yFT28hSS/hzYuxD7ioztRi2 pg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bwdrvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEQ4fN030631;
        Tue, 11 Apr 2023 15:11:26 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw918d07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nx5aSLVnpHnuamu6eI8MH8Y/CVaxHqUFGrK/Ix5EgeH6+NfezyDmp4PROlCWWaYF0llOmRc5aZ3fBsOUPIuhYelSrvdh1Bf5e70kWDeP31EmWykSyrDp1snl/lCr3051zePvReBnQrsxK334Rs4N8/orLF9NuP9GazN8TNKx+zOJOVvVFjaXV4Bedtka2zNEF2C/6pJ1SauKEO7E930aRAt4NrV8r0iX5lBqMQV0L/CRhg/iNCQChsDHYWkYUahgQU6h4/j0F2wn6A2RKgyfnDGDY6nLJ1Vyo9bmzQF6hXPMKGUNtZ9HS7qnYKJ8+R3qKF1tot374Q2YoD0MQ0ySPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fg9T0m7X7w29GcvBtWyPWgaJzQWqhHR2/JH+eaFF9LE=;
 b=RtW7tmAp2hwfDz8wbWrKkrb960KYn5C28rekJ+PzE4h1ZBwXdQuZTsartkFBFPOGqIlrLyYHpnbtXOEwWL+RsDYBr3xtIbvbDCes4g3zmloM3BIbLu39Cs+eRi6jpsp0spTt2jeM79CeVUXBxv+IZ/lGwqMHOf/MleQPECl/tdKMppKXdhCuEEDrOiiqLoPLt7rEd+5doPrH44ZFBZbKx+kSt5/MPeat0ZV6au54hsC5IdwBH0XtC0gJrm1c+C1HxtxeFVwMpZOJIeAOzu1Xhobr8bYc+R+jsi0isYsK1na4BSRtr/mjgDcI9hmcm4fg7wACOlSt8lWjQXS3cL7GKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fg9T0m7X7w29GcvBtWyPWgaJzQWqhHR2/JH+eaFF9LE=;
 b=dedjmMCTDj1gDfdp2du6TI09i8QrglRXn1qyKu7KyYlD9nz1zatUpGkmYBDlfvp//zGjAGsZSA+juc/Lo9ln2D4Gzsyy0UmQRVcf/YFlW7eiYINMm6JCIGUAImKTsRrMcqGa1dCCi30JB2I/KMJhvKIUruUHGBifYIGCyzsNdwQ=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by CY5PR10MB6120.namprd10.prod.outlook.com (2603:10b6:930:34::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Tue, 11 Apr
 2023 15:11:23 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 15:11:23 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Liam Howlett <Liam.Howlett@oracle.com>,
        Jirka Hladky <jhladky@redhat.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 6.1 01/14] maple_tree: remove GFP_ZERO from kmem_cache_alloc() and kmem_cache_alloc_bulk()
Date:   Tue, 11 Apr 2023 11:10:42 -0400
Message-Id: <20230411151055.2910579-2-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
References: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0135.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2f::14) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|CY5PR10MB6120:EE_
X-MS-Office365-Filtering-Correlation-Id: 4690e2da-9dbc-4dbb-52f0-08db3a9f038f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199021)(38100700002)(36756003)(86362001)(316002)(26005)(6506007)(8936002)(5660300002)(6512007)(186003)(41300700001)(478600001)(6666004)(1076003)(2906002)(66556008)(66946007)(54906003)(8676002)(6486002)(966005)(2616005)(83380400001)(4326008)(66476007);DIR:OUT;SFP:1101;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4690e2da-9dbc-4dbb-52f0-08db3a9f038f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:11:23.8453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IGqX3Be3QFRUrpVeHjWMKFTEULaUizDXgyKQsnLqyIujZt+vkWD8DMkRT23W6qhjG469ZQsUxiRQ17MAurCAsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6120
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_10,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110138
X-Proofpoint-ORIG-GUID: 7oL9yaXL_wjsNYL9kt4-TXh9E4iIaeXL
X-Proofpoint-GUID: 7oL9yaXL_wjsNYL9kt4-TXh9E4iIaeXL
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 541e06b772c1aaffb3b6a245ccface36d7107af2 upstream.

Preallocations are common in the VMA code to avoid allocating under
certain locking conditions.  The preallocations must also cover the
worst-case scenario.  Removing the GFP_ZERO flag from the
kmem_cache_alloc() (and bulk variant) calls will reduce the amount of time
spent zeroing memory that may not be used.  Only zero out the necessary
area to keep track of the allocations in the maple state.  Zero the entire
node prior to using it in the tree.

This required internal changes to node counting on allocation, so the test
code is also updated.

This restores some micro-benchmark performance: up to +9% in mmtests mmap1
by my testing +10% to +20% in mmap, mmapaddr, mmapmany tests reported by
Red Hat

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2149636
Link: https://lkml.kernel.org/r/20230105160427.2988454-1-Liam.Howlett@oracle.com
Cc: stable@vger.kernel.org
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
Reported-by: Jirka Hladky <jhladky@redhat.com>
Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 lib/maple_tree.c                 | 80 +++++++++++++++++---------------
 tools/testing/radix-tree/maple.c | 18 +++----
 2 files changed, 52 insertions(+), 46 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 69cb44b035ec..fd824b065ace 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -149,13 +149,12 @@ struct maple_subtree_state {
 /* Functions */
 static inline struct maple_node *mt_alloc_one(gfp_t gfp)
 {
-	return kmem_cache_alloc(maple_node_cache, gfp | __GFP_ZERO);
+	return kmem_cache_alloc(maple_node_cache, gfp);
 }
 
 static inline int mt_alloc_bulk(gfp_t gfp, size_t size, void **nodes)
 {
-	return kmem_cache_alloc_bulk(maple_node_cache, gfp | __GFP_ZERO, size,
-				     nodes);
+	return kmem_cache_alloc_bulk(maple_node_cache, gfp, size, nodes);
 }
 
 static inline void mt_free_bulk(size_t size, void __rcu **nodes)
@@ -1123,9 +1122,10 @@ static inline struct maple_node *mas_pop_node(struct ma_state *mas)
 {
 	struct maple_alloc *ret, *node = mas->alloc;
 	unsigned long total = mas_allocated(mas);
+	unsigned int req = mas_alloc_req(mas);
 
 	/* nothing or a request pending. */
-	if (unlikely(!total))
+	if (WARN_ON(!total))
 		return NULL;
 
 	if (total == 1) {
@@ -1135,27 +1135,25 @@ static inline struct maple_node *mas_pop_node(struct ma_state *mas)
 		goto single_node;
 	}
 
-	if (!node->node_count) {
+	if (node->node_count == 1) {
 		/* Single allocation in this node. */
 		mas->alloc = node->slot[0];
-		node->slot[0] = NULL;
 		mas->alloc->total = node->total - 1;
 		ret = node;
 		goto new_head;
 	}
-
 	node->total--;
-	ret = node->slot[node->node_count];
-	node->slot[node->node_count--] = NULL;
+	ret = node->slot[--node->node_count];
+	node->slot[node->node_count] = NULL;
 
 single_node:
 new_head:
-	ret->total = 0;
-	ret->node_count = 0;
-	if (ret->request_count) {
-		mas_set_alloc_req(mas, ret->request_count + 1);
-		ret->request_count = 0;
+	if (req) {
+		req++;
+		mas_set_alloc_req(mas, req);
 	}
+
+	memset(ret, 0, sizeof(*ret));
 	return (struct maple_node *)ret;
 }
 
@@ -1174,21 +1172,20 @@ static inline void mas_push_node(struct ma_state *mas, struct maple_node *used)
 	unsigned long count;
 	unsigned int requested = mas_alloc_req(mas);
 
-	memset(reuse, 0, sizeof(*reuse));
 	count = mas_allocated(mas);
 
-	if (count && (head->node_count < MAPLE_ALLOC_SLOTS - 1)) {
-		if (head->slot[0])
-			head->node_count++;
-		head->slot[head->node_count] = reuse;
+	reuse->request_count = 0;
+	reuse->node_count = 0;
+	if (count && (head->node_count < MAPLE_ALLOC_SLOTS)) {
+		head->slot[head->node_count++] = reuse;
 		head->total++;
 		goto done;
 	}
 
 	reuse->total = 1;
 	if ((head) && !((unsigned long)head & 0x1)) {
-		head->request_count = 0;
 		reuse->slot[0] = head;
+		reuse->node_count = 1;
 		reuse->total += head->total;
 	}
 
@@ -1207,7 +1204,6 @@ static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
 {
 	struct maple_alloc *node;
 	unsigned long allocated = mas_allocated(mas);
-	unsigned long success = allocated;
 	unsigned int requested = mas_alloc_req(mas);
 	unsigned int count;
 	void **slots = NULL;
@@ -1223,24 +1219,29 @@ static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
 		WARN_ON(!allocated);
 	}
 
-	if (!allocated || mas->alloc->node_count == MAPLE_ALLOC_SLOTS - 1) {
+	if (!allocated || mas->alloc->node_count == MAPLE_ALLOC_SLOTS) {
 		node = (struct maple_alloc *)mt_alloc_one(gfp);
 		if (!node)
 			goto nomem_one;
 
-		if (allocated)
+		if (allocated) {
 			node->slot[0] = mas->alloc;
+			node->node_count = 1;
+		} else {
+			node->node_count = 0;
+		}
 
-		success++;
 		mas->alloc = node;
+		node->total = ++allocated;
 		requested--;
 	}
 
 	node = mas->alloc;
+	node->request_count = 0;
 	while (requested) {
 		max_req = MAPLE_ALLOC_SLOTS;
-		if (node->slot[0]) {
-			unsigned int offset = node->node_count + 1;
+		if (node->node_count) {
+			unsigned int offset = node->node_count;
 
 			slots = (void **)&node->slot[offset];
 			max_req -= offset;
@@ -1254,15 +1255,13 @@ static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
 			goto nomem_bulk;
 
 		node->node_count += count;
-		/* zero indexed. */
-		if (slots == (void **)&node->slot)
-			node->node_count--;
-
-		success += count;
+		allocated += count;
 		node = node->slot[0];
+		node->node_count = 0;
+		node->request_count = 0;
 		requested -= count;
 	}
-	mas->alloc->total = success;
+	mas->alloc->total = allocated;
 	return;
 
 nomem_bulk:
@@ -1271,7 +1270,7 @@ static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
 nomem_one:
 	mas_set_alloc_req(mas, requested);
 	if (mas->alloc && !(((unsigned long)mas->alloc & 0x1)))
-		mas->alloc->total = success;
+		mas->alloc->total = allocated;
 	mas_set_err(mas, -ENOMEM);
 	return;
 
@@ -5740,6 +5739,7 @@ int mas_preallocate(struct ma_state *mas, void *entry, gfp_t gfp)
 void mas_destroy(struct ma_state *mas)
 {
 	struct maple_alloc *node;
+	unsigned long total;
 
 	/*
 	 * When using mas_for_each() to insert an expected number of elements,
@@ -5762,14 +5762,20 @@ void mas_destroy(struct ma_state *mas)
 	}
 	mas->mas_flags &= ~(MA_STATE_BULK|MA_STATE_PREALLOC);
 
-	while (mas->alloc && !((unsigned long)mas->alloc & 0x1)) {
+	total = mas_allocated(mas);
+	while (total) {
 		node = mas->alloc;
 		mas->alloc = node->slot[0];
-		if (node->node_count > 0)
-			mt_free_bulk(node->node_count,
-				     (void __rcu **)&node->slot[1]);
+		if (node->node_count > 1) {
+			size_t count = node->node_count - 1;
+
+			mt_free_bulk(count, (void __rcu **)&node->slot[1]);
+			total -= count;
+		}
 		kmem_cache_free(maple_node_cache, node);
+		total--;
 	}
+
 	mas->alloc = NULL;
 }
 EXPORT_SYMBOL_GPL(mas_destroy);
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 2e91973fbaa6..aceb6011315c 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -172,11 +172,11 @@ static noinline void check_new_node(struct maple_tree *mt)
 
 		if (!MAPLE_32BIT) {
 			if (i >= 35)
-				e = i - 35;
+				e = i - 34;
 			else if (i >= 5)
-				e = i - 5;
+				e = i - 4;
 			else if (i >= 2)
-				e = i - 2;
+				e = i - 1;
 		} else {
 			if (i >= 4)
 				e = i - 4;
@@ -304,17 +304,17 @@ static noinline void check_new_node(struct maple_tree *mt)
 	MT_BUG_ON(mt, mas.node != MA_ERROR(-ENOMEM));
 	MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 1);
-	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS - 1);
+	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS);
 
 	mn = mas_pop_node(&mas); /* get the next node. */
 	MT_BUG_ON(mt, mn == NULL);
 	MT_BUG_ON(mt, not_empty(mn));
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS);
-	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS - 2);
+	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS - 1);
 
 	mas_push_node(&mas, mn);
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 1);
-	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS - 1);
+	MT_BUG_ON(mt, mas.alloc->node_count != MAPLE_ALLOC_SLOTS);
 
 	/* Check the limit of pop/push/pop */
 	mas_node_count(&mas, MAPLE_ALLOC_SLOTS + 2); /* Request */
@@ -322,14 +322,14 @@ static noinline void check_new_node(struct maple_tree *mt)
 	MT_BUG_ON(mt, mas.node != MA_ERROR(-ENOMEM));
 	MT_BUG_ON(mt, !mas_nomem(&mas, GFP_KERNEL));
 	MT_BUG_ON(mt, mas_alloc_req(&mas));
-	MT_BUG_ON(mt, mas.alloc->node_count);
+	MT_BUG_ON(mt, mas.alloc->node_count != 1);
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 2);
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, not_empty(mn));
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 1);
-	MT_BUG_ON(mt, mas.alloc->node_count  != MAPLE_ALLOC_SLOTS - 1);
+	MT_BUG_ON(mt, mas.alloc->node_count  != MAPLE_ALLOC_SLOTS);
 	mas_push_node(&mas, mn);
-	MT_BUG_ON(mt, mas.alloc->node_count);
+	MT_BUG_ON(mt, mas.alloc->node_count != 1);
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 2);
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, not_empty(mn));
-- 
2.39.2

