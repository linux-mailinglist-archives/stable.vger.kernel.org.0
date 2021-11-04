Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6234455E2
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhKDPC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 11:02:27 -0400
Received: from mail-mw2nam10on2106.outbound.protection.outlook.com ([40.107.94.106]:52192
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230344AbhKDPCZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 11:02:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vnh/WazAo1zYnHjDxMXXeBUe7l33BpMsVGx/2O1Ag8TSoXCY9nGEHnznSR2ymu4pL6X8MNEzg2W+RnmR4BvXP78Vt1RRbkaZElEZ04CilzXeJwccUn3mZegpHcrT2Xj6GqaFhQjvzeEmBz4RyPq2jm+SvMumVfjVbzgpZd/ZyhWEuRKIj51Y0fhdqVQUccIteWoX7tMjIvvhkyBnRMU/bhNAqhoIwNfKKnj+KkSNiKlvtmfANEE4RV7Xr8PxYaVc5D9fHOSEw76LO25TfDVkA/iyhsNAH6TasZ3lKl6D/Xv1y4FBFl+wrDiZjmpGN75rN3nQlhfFFts3ooW0QfhssA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NcGw00fRShxsZdFN5t2j6oOps+Gdg3GJthM0AsIS6a0=;
 b=bfWt1JWOoglGY5u/27SHXt1YOe5RyNga48UaVHpKuBG7QBPSWF1DV3PatECnjf+byPFdvxXTQALd/JoCh37SjTTLa/Q2QaD3wNUok64SQVQ7ET4qdHnU8UHFh+d2xfLJwDqnFcCfIISE6nmYiLMv0F8PnE/nOxsbAFB8ric0aKXUWc3YpeIKTz7m+BrewHrdZDc4dHNWySAknNH/NCWHSOG9HQzatjzM/IkF0hbIaocOD9a5ZW1ueI0L6mnoAZ2fX5wyLhqtNs/rcuJPYjM1fY6FYfNXi0Shvg+xAyd0rIJISfGgjaumj+ozBRpCrv0QvcmvmYBFawG7FW0tS8Qliw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NcGw00fRShxsZdFN5t2j6oOps+Gdg3GJthM0AsIS6a0=;
 b=ACFMwx/Z4CpAEYxGsxFO9nTtem8i5AyyM999nEBhFf0E4kzJMayNu2p0JQldQLl86hflFgjFEn0tphBII2SX38PXKoYr9QhrbAIzDr9fj5aM1eotqWLNhD26GblYboTxj/1e8lXcNRI5VjbdZZVR6Ng7K8nCUOVf+Fz5wq1TK1HIq5vTQAXVJU9Cdo43PVrnk3F/Jj57NjiRxu737O/XQsFJnDmqy3vlAyMh8Xdwa+3P9+hnKB4GkFMgkvcvTUky+ryr0IDmHkr+dOoMKll9xcPRW/UGYqPJbMpxNQD1PxKw7NvKSi5uG9unBOU0LG7FcNSrNopvLPIw90NhQv8jRg==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 CH2PR01MB6103.prod.exchangelabs.com (2603:10b6:610:26::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.17; Thu, 4 Nov 2021 14:59:46 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0%7]) with mapi id 15.20.4649.019; Thu, 4 Nov 2021
 14:59:46 +0000
From:   mike.marciniszyn@cornelisnetworks.com
To:     stable@vger.kernel.org
Cc:     linux-rdma@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.4-stable 1/2] IB/qib: Use struct_size() helper
Date:   Thu,  4 Nov 2021 10:59:36 -0400
Message-Id: <1636037977-103575-2-git-send-email-mike.marciniszyn@cornelisnetworks.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1636037977-103575-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
References: <1636037977-103575-1-git-send-email-mike.marciniszyn@cornelisnetworks.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:208:256::27) To CH0PR01MB7153.prod.exchangelabs.com
 (2603:10b6:610:ea::7)
MIME-Version: 1.0
Received: from awfm-01.cornelisnetworks.com (208.255.156.42) by BL1PR13CA0022.namprd13.prod.outlook.com (2603:10b6:208:256::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Thu, 4 Nov 2021 14:59:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce890665-4cd4-4ef9-00fe-08d99fa3bdde
X-MS-TrafficTypeDiagnostic: CH2PR01MB6103:
X-Microsoft-Antispam-PRVS: <CH2PR01MB610393766647CEA4389F2B24F28D9@CH2PR01MB6103.prod.exchangelabs.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t0AWwGUPYqxXcRvzlFbeJB4j+jUkIChC8PwIR3w4ktmN0nZZMeqLpIbKWhUSX10VyGkOLYjeDOqREYjAYm6jMHE7Vlq1BEbCIcN/ICFzYg9yYBKlE3r/Vxcn9K9ad3eJx2c+g4CfMWUU6jqq40pbGk6Os0aJgEpnT+QYCs3Rg5zKmphDH1qXKx1E84E26Xq6LtzqTqYe0uTU1Lwsz1Oc78iVdt7mm7kBnxIfeLEn9hSPUbqEh10HT+9rZovnSbm/yH5G8yu0faZ23RnneY38QX6yp4YPNkmGqhezHvpdxBOGE1kT6JeIsQOz+KCpPzijAp+B0OSJV8cLewZ8X7fpsX3qIOnIWesh0VQBlJWWEhlIhyiNU9PkY1bQ3qL7BtrtwEY9+A1dAnHB4AVVd/+F8U976lefa5rIVf/7AE4tZyMxpgSe0yxa1wplbx/4s0tDngNwTReia4G9NISjCX4/66QYebFqdG493ejQnIpvsdGmTZ3SkiLBAhvOGnFczUuQn90Eq5477oJHGnK687KmYrMet6sRgbRP0bbUtP/CVGUaDMxWFRTOeHe2EUZvP3W2rhbDlpWheoaA2R8bwoYRpbRa3OJnvXecDskWVLmNNF8yXao1Sw9AlXUCzoDUOYSkywZ7tV6SWqWVYXkNvQ7Rtc3yW9lBnjOdOgfxFQjgsstOyKBUC0oFxnMCFjcjmmmaCZ/CYP1y23OI+59kIsCRQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(39840400004)(136003)(346002)(52116002)(36756003)(2906002)(54906003)(186003)(2616005)(26005)(83380400001)(38100700002)(7696005)(8936002)(6666004)(38350700002)(316002)(508600001)(8676002)(66556008)(86362001)(66946007)(956004)(9686003)(5660300002)(4326008)(66476007)(6916009)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wqYGn25lm8jyPioveFDFR+brr63wGA75XaWREmuzWGfekdFD4kua8yxKV/nF?=
 =?us-ascii?Q?U9IoB9gCZNZ+LmH5Cp0k2snoaH3jaZn8LCsAzFg18+m0n0s5LeoL/U7M1hm5?=
 =?us-ascii?Q?MlUIBZiemsCQwhyjuazbIjagpctoZefEN/3qFsaYTbj3Yrirond2oK9Hz1P4?=
 =?us-ascii?Q?JZspQ1+HPlZhXSeDu7NdaDEmvSq6/PJegegJVeVuIFuvpDDYOfiVQ3FI8X6A?=
 =?us-ascii?Q?IFaQXrJd9SZt9kuFuClJYus01xbZ6SqgQ40p4IHw8VAFW/2CnycZRYtkyUk2?=
 =?us-ascii?Q?uyj94rzkLME5oiAxduL6TP5UTQ4NBuS9H0DzHj8VjD7jM2NG/W00OStGh38v?=
 =?us-ascii?Q?FgMgcDeWgcejkXmZUY6YMHuIlQc8ud+Vi63ltGVYmnk72XpX+AzcBrAq+AjB?=
 =?us-ascii?Q?PPmOLefJd/jc8XpHLGvLUqlc/4g+kUeLjr47zAUTlqOw0mQ3o9FSVWPkE42j?=
 =?us-ascii?Q?XmiaNUgx+Q+TOswlid6ivRbMtDp1NM/c/vaG/5HOhgTvr3GhqY+rzKxNTrfe?=
 =?us-ascii?Q?Z1C+kL2UxBCmP4mCEbn1H5H57QCjVomdc4ZFDmeAJB07AuJwGqmcb+7f/POb?=
 =?us-ascii?Q?N4uIpwHYmt7Ug4lO6xvFkFXf1KFsSabppT5+GdqD7qtacyLaaNqYpTovlxQF?=
 =?us-ascii?Q?n2mt4t8Q1iE4+Oy5y6KaKFjstuTEUPpXY4OKQn1gg2gQX4ZF4kDmXuvaljLK?=
 =?us-ascii?Q?Ogcu5t6a+FSZDTFizoOl2AEhLZ5CzPL1BWMjpw7i3V/0EqZbh/3Qsh4GiXuO?=
 =?us-ascii?Q?FilF59Qs3FGlsi6WQOjd2WRBdUKU3VUsMyUZaKkQM+WkT2RuemAp0S5984Qj?=
 =?us-ascii?Q?Px/b3Fi7T6X0vVDXELVQY/xX0Rw/Z6B+pDxnkxHUux8WffmTvTgz2A7pjx1M?=
 =?us-ascii?Q?wj9VmNzYcOMRHXw2nLfB/JvPV9ktFBTzIdMGMS/A2dTtk4eNomy8tHD63gDk?=
 =?us-ascii?Q?o2HbLdMZJNKfPbJ71JrXFQuhQfZ0oS5Gs0YG0WNFhpsOFFubODaMpYDnbMCT?=
 =?us-ascii?Q?FaciTTdwBnOJPPx1MyeLvo5xW6H2wZRyo51bchcn5twzJgl5WCMrxEl0PyQS?=
 =?us-ascii?Q?KJd5TqIW/OtpXgY5Emc2VqDY77oqmKtNf0kh43duviNg0Wg7jBbLnBq+spY4?=
 =?us-ascii?Q?WNMci7sSzD5IfnDCQj8b7dxxqIftU9WDsVx5MwmD+cFXKH/YGHs4pWUDmt5T?=
 =?us-ascii?Q?45mXsm0ofR3tBj+RQfuMBMqt8iwMMRepykVctpuettDkcbODLyfTjITMcXK8?=
 =?us-ascii?Q?uogQpKIaHbUOJHSEsabRSXY/3TKJ6/lFhpV4XXC8EnDCXEkUnvj//EkwqwIH?=
 =?us-ascii?Q?WYjAEzglsetOt6UOCeUQEdQ6j/1xZf47HqTpWk+R4Q4ZQdpRu9l4xvD+fhxG?=
 =?us-ascii?Q?I3L9JSjgLCqtdhmBMSeZfC+uHBaJMoxX8YYZ6Bw23JZoA0axkI4NL+6BYUXf?=
 =?us-ascii?Q?wOkx4eXtsuckDykey0Q98Mm87tC1c7S2gx3snpwN8pb3bcpBrw6nWL0wrkCa?=
 =?us-ascii?Q?OvxWKlxKVuU7WKe8hgmebbFF3nXXLY3DgryTzlC4u+RCKtlustwnJ/X5vyD8?=
 =?us-ascii?Q?9M07Luvp8i/vcbJvELOn4oYRyAga837IcVcP0dn3V1gw2Rddpunq3BB+Cng9?=
 =?us-ascii?Q?BfQEbfg6xB+tt2FaOSyNBVv9Pek89kihamEjdAe8E1xtBmd/PtnXmOA2Z7aj?=
 =?us-ascii?Q?nYSugNPmqVJw5Hbh57Q2Q8q9Oynn5txjeXZqORk3IzeuY0b+RrAMudDvixA3?=
 =?us-ascii?Q?EzvHiTzUUg=3D=3D?=
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce890665-4cd4-4ef9-00fe-08d99fa3bdde
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2021 14:59:46.4530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h+vamRVR8M/WTk/fKasGChVD/E2+tmU8G8QxR8R/Kumww+G5x4b0rmahw1IiOKSBL0GtrAQWVmOYMBdyDoJ8sdcM8Tl1LskzM3raDr5Vd38vjD0uhxzKMOmPVC5+xGpo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR01MB6103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

upstream commit 829ca44ecf60e9b6f83d0161a6ef10c1304c5060.

[Apply to 4.4.x]

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes, in particular in the
context in which this code is being used.

So, replace the following form:

sizeof(*pkt) + sizeof(pkt->addr[0])*n

with:

struct_size(pkt, addr, n)

Also, notice that variable size is unnecessary, hence it is removed.

This code was detected with the help of Coccinelle.

Backport notes:
- Need to include linux/overflow.h

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/hw/qib/qib_user_sdma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index 3e0677c..deef6ff 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -41,6 +41,7 @@
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
+#include <linux/overflow.h>
 
 #include "qib.h"
 #include "qib_user_sdma.h"
@@ -908,10 +909,11 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 		}
 
 		if (frag_size) {
-			int pktsize, tidsmsize, n;
+			int tidsmsize, n;
+			size_t pktsize;
 
 			n = npages*((2*PAGE_SIZE/frag_size)+1);
-			pktsize = sizeof(*pkt) + sizeof(pkt->addr[0])*n;
+			pktsize = struct_size(pkt, addr, n);
 
 			/*
 			 * Determine if this is tid-sdma or just sdma.
-- 
1.8.3.1

