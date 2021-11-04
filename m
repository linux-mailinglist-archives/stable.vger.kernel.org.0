Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645D04455E3
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhKDPC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 11:02:28 -0400
Received: from mail-mw2nam10on2106.outbound.protection.outlook.com ([40.107.94.106]:52192
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229920AbhKDPC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 11:02:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fG0NU7/HrdNIiQ0qXY3RUTNjtF8Pu1YYi4L/EnoCddE856pzeUUnSt2wrAxaQU45ASCLu/U2oHk7hIZ6Wt+gbdBiRiR2TwygdyFioFupgwjAmKaixyo9udJn9g7IVh2fOEq5eJwYRM1ZPw4VLjFlvDWV3I6ps/Ye+yqGeVI9MakJrb/h2n339O5n3S9Do2uZMU/GhqH8KMSHqXdGkXii3gtiXacMbODaEExKQ+iCD+Qb4AmkFgbXnQAgm5WSWlk4f4cDW/7Bf2qqhMtwjfxs6PhJiuwDxrNVQ+0fbZrxh4pHZWQg7LpQkZBQfol0EVkuNAdi5wF80XIJJ22mV39bKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jVQMuH1owXbYATgPz8UzG5fz4iiKm9q3b0EhLY6R5pA=;
 b=BSKA8BldMQtd3kO4EaOaWKPbxn4FMB5A9sri3+G3MjfUAGeRDhn4nfT2TdURT+W55Rlwh+0zU+hl+rF/X/sxKanit3kV8OO9CRyVHtMiL+mSjbexEe3JsbVi5Cbi6HB/fqgR373n22QYwbX4458gexhGkF19OR8RqMlNlm8z9GM/UmfZ3cEV+5e2PJUrY4V4a73jtL45B1i3yUG9mgKuPyqVPKlpgvEKNq077JdtGKuU+n7rlaWkIK/hLWksnD3I/SPmgZUKSpeMxzQzZwqyWK2nd/dHe2uyAqNXY31zhod1mgqMyLjJUwsoipFB4a39eEslOYYDykCsNfkDQ/L8dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jVQMuH1owXbYATgPz8UzG5fz4iiKm9q3b0EhLY6R5pA=;
 b=QTggfsjWkLnEYsTwmKeVmWrQDj8gUpR08aVrtGp9G/gu72lkYR8RJeiluD6VYYcXY/wUNwBX8E7eI0Sqiog+m/SUqoJAkORhmoaF9ItuPOiL6zF/Do8kroYn9EAu8bmNAFUpHZ1s/w2aWknwHCxAqZ3svAHD7u8r5+uA1yLwEy3nR7ssaji3NQDkd0tXkuhSDjj9HS0TICR7l5CfeOJEOuryYFxQIhZhxtxEb9dP+pciyq1gmRfPYf7WGDGNRGh8BCInevyq5lzCB93cn9KqXZkNy4ThPkO5I6/rzGRIXpoQsfUNkRhztqlPFkWYpUc0Kd72RRuuo3t4oatTmSdTEA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 CH2PR01MB6103.prod.exchangelabs.com (2603:10b6:610:26::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.17; Thu, 4 Nov 2021 14:59:47 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0%7]) with mapi id 15.20.4649.019; Thu, 4 Nov 2021
 14:59:47 +0000
From:   mike.marciniszyn@cornelisnetworks.com
To:     stable@vger.kernel.org
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 4.4-stable 2/2] IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields
Date:   Thu,  4 Nov 2021 10:59:37 -0400
Message-Id: <1636037977-103575-3-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1636037977-103575-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
References: <1636037977-103575-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:208:256::27) To CH0PR01MB7153.prod.exchangelabs.com
 (2603:10b6:610:ea::7)
MIME-Version: 1.0
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by BL1PR13CA0022.namprd13.prod.outlook.com (2603:10b6:208:256::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Thu, 4 Nov 2021 14:59:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e4ab520-adc8-4a5f-3857-08d99fa3be3a
X-MS-TrafficTypeDiagnostic: CH2PR01MB6103:
X-Microsoft-Antispam-PRVS: <CH2PR01MB61037247D0005DADBDABD1A0F28D9@CH2PR01MB6103.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:459;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r7z8nASS394REEVe0R3Dzp0kunpg6k8tRGJ3gp5ZQECfRYR1qe7ziHF2hlTRWioXgMuDxLVzn0bhTBxXz3PXpqj3ot3fr0VqjYpI3xxYe63Z27gSmyV32tPuYpzV6B2obs7gAqMVSa5kO63LkUMlmNBOFXRDX7us/qdyiWfh+hdrWXz242lzkVYLOY1z8NAVuoh5uKma8JBzh4qZNwOaw6+lOBegq7pTtuezJhXdTBj0YnnzjxK8EuhN3I6tnn3CdQjvFX4UnKpzpu2nIFJkgW+0kifvpmM1cbVanBNx16pFSI60o0X7bUfk2XR0B/2RenL/ptxRkaj1akQTzOJohcYvIN8c7gPIlIiRSz/yoWcW+FIoIRXfj2BfVjw4bDpKWIHHTicBkHMXbBIxUTRMljmLB2SETrExow8lt4reeQAmcoYMCi5VIGaB4evOGeqdP8DcV5SvAIkocsS2FbfcYTD178Cz7A0X4miTvVAOQB+eQt9XAiB24+WXgNo0/7n1zEQRNaIWTw3Dlrc4Da5eaylX8+voecHhiqX+WZucu8iDC/RtI3GLsoyU0ofkO0s5ICSD741T9GuxFYr4gWSmww4BjcDND5iy+DEUuv4shuRZzS2nXLEvv2bvLY8UJunlyc8j/ntrWNbqwf2+7JPjgTb6VMvh+Bob3fAho27U/Vz4p9Ua3+JH/z9Dw+ZBGsYBqpqIzuaxWr6/YPcqOXZ//APBWzkVvPu1X+5NH16Y4e2EAKejXcYmp/2i9IsLFa32y34Zd9OY+Ep/aw9xI1OfNiZK46310/So9JamfSEHV3A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(39840400004)(136003)(346002)(966005)(52116002)(36756003)(2906002)(54906003)(186003)(2616005)(26005)(83380400001)(38100700002)(7696005)(8936002)(6666004)(38350700002)(316002)(508600001)(8676002)(66556008)(86362001)(66946007)(956004)(9686003)(5660300002)(4326008)(66476007)(6916009)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b6NsY9xEWx8KdepPJWLjD7JzNtoJHbmaHyJGmTOXLK0Xb7dZa5gUh4iOOUnI?=
 =?us-ascii?Q?12rdGvFUqiCuUFTvQU92FQNw35yZybi5xxUdFq8bJJzSYAErBzMXuRF2RCVN?=
 =?us-ascii?Q?CKGyuV6CuZ8safj5J84evcWtRT26AKDrJR7tBZfRzM7nyk+cwYPIyB5Jje2e?=
 =?us-ascii?Q?Cby4ZNP3TAtNspBfWStxInC/AtaK1dMtl6TJ3sxhx95HmwGx+mn3Wk9kJXbG?=
 =?us-ascii?Q?fwvWpX8VPQ9VxW6jeVo/A7KFMDzDOrmFQDyeFwrxk5M6NZar6sDMP1LhSFox?=
 =?us-ascii?Q?MHDyNDtxcdK3QxrebCphkrit4C+C6sSlZHyjvwo+BJn5LTncD1l0oeTVBVQM?=
 =?us-ascii?Q?peQ9Qwf1fhP76EGJS3GLmvFnHH+6tF6mblNBNwkV481sPa6aFJ5D9Wus2Aus?=
 =?us-ascii?Q?pMpoBFDmvbVjevAjeICwksLaaDNc1+wUOFRl1jSwC0bDx0MzPSCYF7ZvCVkm?=
 =?us-ascii?Q?VqnXGsTUXaSyXESi+XLfsVW5Rla879+GO+2U60LhC+dwRyoSNKGg9V5QTWxh?=
 =?us-ascii?Q?UxfYuyFioyHOvx1mYfx/YZg+A5e0nPQpovOTfRS1AkmzNquqdazg3yxVGqI1?=
 =?us-ascii?Q?nzC3YUYX/6GNSU5V+GLPD7yxWphXhweuhOrECEsiCfxNIB5IO9kRkGZduKp3?=
 =?us-ascii?Q?Xw2qUt474bpMyzfw6tRN2XU8WDgLSXNN5uGxHzRYT50DCCbdjN7lMObSugW7?=
 =?us-ascii?Q?WOwbpKgq8SultYi8+Gsy/udt2Jnu5NZz9bWA8dxhhPku8oSI7Rh9K7+836rq?=
 =?us-ascii?Q?Wr+pwF7x7t5LQD4zs0HFcgb/5RsJzeEXvcUHaHY4b13fWWno4rUjHtjC0PBV?=
 =?us-ascii?Q?VlWtJ/dyQIK8hO9kssMAp7dD+eiGCBNvwbjfgqh8c55LrllA9ZvXR48YWi1o?=
 =?us-ascii?Q?VjQWL51k/OF6RAImmEc1PBRkHcnLJIK4NBdDaMGTYtchc0Y1GgPZlGvHaVG4?=
 =?us-ascii?Q?mOhY7vcibqglAV567khP96SKthMYBdIxnizYV4Qa26nVGn+HF0cO6HhWVgrk?=
 =?us-ascii?Q?94x8WDs+OB0XC+jKXr42Fl3+2tWfrYdZUwSzC6HcIkB/ZKBaO8zm8msJZBDi?=
 =?us-ascii?Q?egu8kBA5G9mF+cwnWdz+YdOE88+QwhYGHncDe5zm8LphsxFZhRtjZmiIQBTs?=
 =?us-ascii?Q?EJPRzDbg1yBiqgKhkcylZ0GZQeS26pRrgVepGe50LL2kUCl/5lgBvMNegGLi?=
 =?us-ascii?Q?SmK6G6pRMojWhM0g3HjgwlcNGJxH0HGFmyGj3vZSHt/P/+0SU8cJWVe8B080?=
 =?us-ascii?Q?ygzRKDE1QKyPtZluAkFKo/cWzxWQPJ+yjNxyOlV7mjTeLkA2Buf4dbViF/iW?=
 =?us-ascii?Q?IbpBqIwusdJHMHc8lzh6N7zZQs8rPvmvG+kw9AIFeYAjz2D96OKP1wrKt73W?=
 =?us-ascii?Q?Z3G6ydXeMHah/MqyuuYC6t43C9bbjI+OgudS7SFhxIVC4o9SjxkCYUd05c2V?=
 =?us-ascii?Q?5JJ0nF+M4ohGC80k0TPY3a2IjIVZ4XOehKwJScMr+7RTBrBkRkJZhaC3T68p?=
 =?us-ascii?Q?UOiGtKoUT81qyxV+kgangeK9cH6YQN+5oisge5O7osWbYgfK3X/1vDhsb1vx?=
 =?us-ascii?Q?pRWGggEW3WfsiUDlmDMP3mxOtkvRP+XmEg5ZBFTH9r72IbH32l3L6mjzSHpZ?=
 =?us-ascii?Q?dzcsin6jKdypuK7AXWpfZ5hwbxZ8fpNfAgj35QPXTN+7mlA1XsR6JdHBEBSd?=
 =?us-ascii?Q?mN2n7YNoXqFzcZD1wzM1E9KLfewUfpoJEshq3+Cg8pEdIMJXMtGIlQ8LEijW?=
 =?us-ascii?Q?r7vHvMBdzQ=3D=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e4ab520-adc8-4a5f-3857-08d99fa3be3a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 14:59:47.0643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ge0nLhfDdEfA8SukKXT3oZJDZUBVy8I3kuUlWSMpNtxp7QaTTsSDc92wB6ySIHViZcRLeycSUEmMLckhEF+fHFSSSRIOoeqrsfvr8R0GA2G30bUAym4ZvjeytqkJHt4d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR01MB6103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

upstream commit d39bf40e55e666b5905fdbd46a0dced030ce87be.

[Apply to 4.4.x]

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
@@ -607,7 +607,7 @@ done:
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

