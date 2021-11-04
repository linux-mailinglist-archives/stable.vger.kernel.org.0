Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 640B5445643
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 16:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbhKDP00 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 11:26:26 -0400
Received: from mail-mw2nam10on2091.outbound.protection.outlook.com ([40.107.94.91]:51841
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231325AbhKDP0X (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 11:26:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKZ3Y+LJMUQm97uiOGxd/GsccLzBfITSUNtssZNqs9UXdoRaD/QKuunZBQaOHsSquYsLj5pGn3MsllkEuG2WlhMHHlRDReBbPhCK6YlY49quHNv6sc8FL5CgzHy+XPTX2xWJWvzCBcBkMYqRkqW2AZcLSdvoQItkZc9QoW/hb0N5KugPs2JPhmnhOKQPkZg2U21eUqZA+ZZoPqJtZm3hZ0nfPenffrY/zGIqPvBox1f/6S7k/hCFlfimTW8PWRMD+yKef5vE3DJkvSch8aqm3RQgSRs3ZxFHNqgKUhTFozIIhJukbRBOYC6seAAKt1SPhXfYXyzg3/gYyah7zK/MiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRpu4CaaILQYhn6i+wiqTdkFK0+wY7VP0Tx38dsQA68=;
 b=jQ7nHNc+VmmIcwaKeJEbxAQ6DvE82KK/Z8ePiZmxmdtgwmsnLcu9hkIUkxpec8tC5IZxonDFt6Qfdqt9wr+YD/M3dj2wTWYz3m4Z3uXYqEUkfOXGTUPHjcgrX4CDT+FYjY4yzx24Po5HiUlV279UyTyPcOJ66PeLnBoAm1M1/gkL30huR3679wjlO6ric2dI0a8X2rDlDirha0tYDcZ3uuhHULpk21FXVJ9kvrNMsPC/8p0HydCEQnltGAqHpng6yB3lnqGZJd9/4FC53gJJkgxraNjIpCVlApGSS86ThajgORSYe7CM/PTkyfFasp011RSta9Mf0vh0+SLwmbRAWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRpu4CaaILQYhn6i+wiqTdkFK0+wY7VP0Tx38dsQA68=;
 b=G7yTMK6dObt5Dm27dT1hwMIn/mIAZPmXy33m6sdnQLLeD9xI1b10wde0nh+0OjuEn496tv6j87IfmCyTFsTuTMxqW4h3uMwCwAMGxZ0jBkLg9k69VW2qUn8qLqoEyiNxzSx8duYuG1lxaWJu+8zt8usPYjhM/wwUrXqyI04gmiDJdCmYYtKWFrenmcHui+5Oec7whn8D7n590xyndLid/BosHHa0kPfRqxwzBAL4G8Aon834VS/L7gRATnp/MqV7asEAs1dGNosQIi4jEGEh3ATVU4myct+d/kgQtO+A5e3IjRpZya/km0uLEVPVbWYzO/yKqNH0vmHoPeIUN9S/uw==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 CH0PR01MB7139.prod.exchangelabs.com (2603:10b6:610:f6::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.11; Thu, 4 Nov 2021 15:23:41 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0%7]) with mapi id 15.20.4649.019; Thu, 4 Nov 2021
 15:23:41 +0000
From:   mike.marciniszyn@cornelisnetworks.com
To:     stable@vger.kernel.org
Cc:     linux-rdma@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 4.9-stable v2 2/2] IB/qib: Protect from buffer overflow in struct qib_user_sdma_pkt fields
Date:   Thu,  4 Nov 2021 11:23:36 -0400
Message-Id: <1636039416-138753-3-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1636039416-138753-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
References: <1636039416-138753-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
Content-Type: text/plain
X-ClientProxiedBy: BL0PR01CA0011.prod.exchangelabs.com (2603:10b6:208:71::24)
 To CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7)
MIME-Version: 1.0
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by BL0PR01CA0011.prod.exchangelabs.com (2603:10b6:208:71::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Thu, 4 Nov 2021 15:23:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 406c36ce-bfeb-4fdb-8363-08d99fa71539
X-MS-TrafficTypeDiagnostic: CH0PR01MB7139:
X-Microsoft-Antispam-PRVS: <CH0PR01MB7139362A8066EB97839FF0AFF28D9@CH0PR01MB7139.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:459;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /M/y/Qy9fqhoqpsxB3lxisb6VuEAqxei1/u5avoFr49SHD5fIlzzhLFdMWjEgKDJJGesUFLCDR8jZfhWX5Xl9An9nhGB3JmhDfvbDutAeiciMTy92c//daZM7cqaM8QtAs9YN8vUWbmFkcEf7FiDMYms60a7HFkofX0BMfFUh6QpX9vyyIVmUxJ7oeNnhLZ/mCrK+0RcRW3/KKVgiK4FMlq8fRwxUW/+7qufouwa6lR2LODPsdzknb+gX976xMc7Ifu6I26dXL79byIZFhKpF3XHs15CJ4J20DRO5geaQQFD8BWBSdLxMS+PwELsTbXVNsi2z4AQ9Yj5PbyZCy8/zAMOEZ+6iTkvXqjPwQgZwzWfcCvpMqzkIvR3fQSCTC1RaHBhJ6OXsOwHjKK/biSwWlEt7HwOaRBv5+NzZrYglCJ1hvpHkuiS6VerDTAHzWazstxSJEvs43TLo8+jsErSXmir3k5AnpIOUWYMgjsgqms+jkuNnhWkkoBggGeXV43XAW+RZbC/1FRqlmCfEMlfktFuzl8Yh2NGILtlRbc3m466Xza/VEZzxSKcC2twTO+ixnT2X4IRPluaXWFsvgD/HRAs612U6H5fP/HNmYcEml2XxwGkVoIHxcUlJ1oLW+4OwTk9rH7S64/rA0fGxXPiQOPgOcYgntfjAbyUn04NG2joiXtkHicDECGuG6pX4WMq/RmTO30kT9tWlMJNt7Ay/tmQGUR4ZNf/A34v6rUvGELqMYvC5dqzVq8Dy+PYywWUFWfEc2xTtpUSfht0KQBxLj2JvasuOW1pySSbWUHSqso=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(39840400004)(376002)(86362001)(83380400001)(5660300002)(6916009)(38100700002)(9686003)(38350700002)(186003)(6666004)(508600001)(966005)(4326008)(8676002)(52116002)(7696005)(26005)(6486002)(54906003)(8936002)(36756003)(316002)(66476007)(956004)(66946007)(2616005)(66556008)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eSO9aj6qBt8cBg6mn1wOmtIXGzFA1cbwDhcApKnKXGZTlyHSKrugNYeQpFsC?=
 =?us-ascii?Q?xDxUoHwU1ENaOMEzNfbffEbarmndA1H2LW42ZF2QaSe2UkdU9ZlsXkdWxGyh?=
 =?us-ascii?Q?hLNMlrNZmguAU8An4yqSoIkiM209x+F0qUhnYLnd0GylS3J051c0r8eg0IFt?=
 =?us-ascii?Q?wzXoWOHIliy/ouZUE7Y5j9ECJu7sud7UDP0nuKxSeS91vDcurVmHBd7nixFZ?=
 =?us-ascii?Q?zfO81UT7spPsMBJP7Xypc+i++qrKmwhtu8Vp3oi7UE5sRddZDJhdClrbaVxJ?=
 =?us-ascii?Q?ssyW9kpsxEvbaMF9jV+c5ClgA8adYqB2OTgji8KPyDfMr0Go6O/yIZhSoexZ?=
 =?us-ascii?Q?36JUYKyp6g+gKeffIdZZs4j4ihCWc+aQPJAWIJRMLNDiyCXIgxlA/t9D7oql?=
 =?us-ascii?Q?08haJ8meXjkPjvU2SUeKzML2NI4Vom9c/LCOvSF4meC4yc3t+ip/T2dVqOok?=
 =?us-ascii?Q?IZ5WOihV4RCcMEcMBpBVIlP98a4zCSvZHmYv3IENLNizlXtVPvt+kO+wtEVn?=
 =?us-ascii?Q?wjfDNqxHa7cTFszXPhMQLfTbVuxPVDbEF5QVRT/FES7JDsSzRdic88GNaunh?=
 =?us-ascii?Q?XuoV/0uwdGO6IEjeK9F4aEd7V5V9ef0hafkfyQSjWhMWKkVJhQ5Ii4uSxZwv?=
 =?us-ascii?Q?qduehel25BE7D6zdFSq7IXmPQWEr9wP13LxYoHTAW0V87Us5Vr8gM6kvm/t4?=
 =?us-ascii?Q?44tQC4DYq4rY1TmvxcBas2H4T5QbAvwT/TmEy5MqlNbo1potJgDtn9NtRl8Q?=
 =?us-ascii?Q?rmbV3E3w/e3bh6prk6EX9LWt8luVFCpqPa05Lp7jStWWvj8WhTrTx2eKZYbo?=
 =?us-ascii?Q?xx3O0L6RjN2jNPFP1u2d/IoXu64crYsIBOcbFUrWBNvrKd+c0AlmfehTxi94?=
 =?us-ascii?Q?3iqVYuRfYfX88Fb9OixiAdlSlCpNyua6/qJoCGFt1cDRX7KkORWcArtmpgqx?=
 =?us-ascii?Q?hXyBnD085O6rsBJ9ZKgeSYLJn6BcQXKGbAwriT3Pf/acpJ85X5ZJ0Yrxq9hQ?=
 =?us-ascii?Q?GnGKw40iTcbxUPG/K66xSjxhN3dlOr9LFamA+McOygphlEWOKI8UNAw0heTo?=
 =?us-ascii?Q?NqT8IYUtYp7T6FFSunBGbzspAKzuqQ4BI8VzxVd3tkBhy4wrq7HQpk3nOMIX?=
 =?us-ascii?Q?sK0iJfXAUE7i2RsEmBfbiIm8IC4smOAavDRN3pe/7Ikfpar1JBeBt8zEBvDk?=
 =?us-ascii?Q?F6z4P5iLbACGZoZjkGDVJ1Vdd+sfYaPHWKtkq1FauMJNenAZUhN7z4SYgKaO?=
 =?us-ascii?Q?XwwmBgTKoJ+FwLHXYCLzpdyR5a+TzimHwZ508/vLkCfI8yrSHyMs9ztEoj3o?=
 =?us-ascii?Q?nXCoXH1prqRSOQO2QHdR24cdDz8yZ0hVh1xV70gw+fu61AvcEu5wNutIUReR?=
 =?us-ascii?Q?UIfamOcUFRU9vlci1nzPrBD37WWmabKVwkXfJPJPT7HSKUa+84ilD92XrqSb?=
 =?us-ascii?Q?jYJ6HMy3wlP11+U8vArUjsAEJ/VwVnPxBb2xzQ/Y2Rj5o5RNWXDTT09eatia?=
 =?us-ascii?Q?4RrtL5q2TpHrRDLu6b9DVzK+g0pv5LHh7tSKTOBu0UtgwO3ZcvzNaWhlFPaw?=
 =?us-ascii?Q?kswr/VWhVHmmVuaBaCKxNUx6TatBYsksGP4OlmX1NgtEIRifMtiR/Q67OfgV?=
 =?us-ascii?Q?WK0owBDWPJ6O1i4Xn+vnJ8c90vYooISEAbGq/veX8NO0nbKk++YCVMggOC1W?=
 =?us-ascii?Q?jmUxB9AtTtXpzQ3roFTUzWkEJ1sNlbyOCO8UrzjtymQ1PNVAp6Pio26gOdbk?=
 =?us-ascii?Q?qudajyrgeQ=3D=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 406c36ce-bfeb-4fdb-8363-08d99fa71539
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 15:23:41.5943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MsIZAiypqZPp6GcTgM2EKxtT1VDs6PvLiHZxo9lkccwgWGLh1AyKCZvKpywqE3bsjhgLRLkZalo88mAzJHjyaXfaZnROlZSexezGb2SJAXx9y1eDm6uv4hB0R+rTaHVf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB7139
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

