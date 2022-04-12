Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625B74FCEC0
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbiDLFSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344726AbiDLFSv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:18:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD85344EF;
        Mon, 11 Apr 2022 22:16:34 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C3WwDJ008887;
        Tue, 12 Apr 2022 05:16:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=//lQbjyfxI29D4MI73tnBFtgEjvUoVPymuC7OE/GFAA=;
 b=fcoPN0VLmIzGdHui2PQFsRa1z8EX2Urm96ZW+zyukvm+6onglQCmdvB9ELMRbH3B67P9
 BRB+CC9DcgtshTXbm6NX7xVy9M557RLG/GCzhZjVStQ47lWX9kMeP67q1dnc+cMMVrJI
 YgGX5yWeFbZ06cC686wdodTa6Rqkr0xgw+MHLhFRe9VzkWRv/8FIuLQ+K1W/gigoFmuW
 czO3W+HJQGdU4Ydhh2k1ucDnD/AtioUNTo0TtEEWqAVsudKwv0adBVSnyhWNZhW1q7Ri
 ImNNun/IEulumsBw4R+qE51qr7nxOTksfgHmdhnCHXaRGbviHMVLHlW6WUjwrwBuAuiL 9w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2dmbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:16:32 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5GMs6039634;
        Tue, 12 Apr 2022 05:16:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fck129exu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:16:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOmqM+llu9GWLfb1jTL9IPBJpbl3AJ/2WWBGDV7gZSm4oa8+VO3Ss0MObkNv6+e5hSsXXG2Zml1f8VxgHzz69Pperz+IO2vuwD+hbzu3huFEiZaWEVQL+BZLmGoF5hvuVcNF0hOmnZyzYXTLW6SbmXAhXmyRuJER/SeyFGeu92HZWyzsGA/Br/wFbM9j4zFYZn2Y/fVzTEqa1hqIY3vQZR1u725MC2dg5YtD3M+Q+ayWTGrLlNyqRjVhg6mUffGr23GJodUKC+6ALxfiokBYZJlO8eCe0LQ+klBUvEX4zo0yBPayuN9m2yq/aBAq+iBdh8N9jT3rV9AJllaypOIKSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//lQbjyfxI29D4MI73tnBFtgEjvUoVPymuC7OE/GFAA=;
 b=FtTg3zfJh0eoSjrlwpXzEx7K9R+UhSZY9SRYVVfTSVr7E64xe0BXiY+PCRDUxcWYV15AkKZWHhK83+GzEo/wh1hadZbwof6D2y/E49a196DfCHRTzq4zkMqWCbaZ+LUDf12zuKqw0VgCz5kuimsE+ymbdqs+tlJCczs48fEUdrYJyflslyLAeBWJHi2M9UtkDU0rE37kO9LR2VltRypWVJ8rm0FOiTNUQ5UjDyx+WzgZIxlDHdffAfxm0X3boEzIZhdPgDyKAQ7IhIT0XPucFZVcY1Ro1BvgEN+zdQ9tihd27x/cA70rdtcYJeuDzA8OOdw/wH3mDYnUblFDvbfTJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//lQbjyfxI29D4MI73tnBFtgEjvUoVPymuC7OE/GFAA=;
 b=sEgks2OlBp2ZwLk8p4b2LwFR60w+PE0WFABUKM5Pz3pwuFaT9Agfeczyta22iAtj8GKJVcFjTBxbt6KngQSdQ6zpU/NcIg3SVE6/+W4l5TOqVggKRgzn2io3JdRY6BBys8GHdhimAismQTx4WeMMqObizhiaF1Z+nugIPtU6B/0=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BN8PR10MB3329.namprd10.prod.outlook.com (2603:10b6:408:cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:16:29 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:16:29 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 08/18 stable-5.15.y] gfs2: Fix mmap + page fault deadlocks for buffered I/O
Date:   Tue, 12 Apr 2022 13:15:05 +0800
Message-Id: <3d9108b9cdc41205af5d930c339807c87a1c5adf.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::32)
 To PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3c4b76c-565a-43e7-983b-08da1c439999
X-MS-TrafficTypeDiagnostic: BN8PR10MB3329:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB33292EFE38C3FBB947FF4547E5ED9@BN8PR10MB3329.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zAe5CaX3eX+JqHEPHjaXjqmM7kDL070XBUE2s+SVUSQsa/q/Nyxt9EY4qlozwyeM9hK/3o0Xvl3/pKDR5aRDizfVkODelGCZhkE2pXThbpSRzxs4fUDprMXXgtGgPvRbFwNUDF6CH6aF8sSo+GI9UT99Lvf1Tl6LvBE1k9NYdDys5nturVw2MkUIigqm1uHmfPKkhNrcgEfw33UQCMwVA62+eXBV0N73Ta9q7SbHcKZkyBb2Ib4RIGmfFJ5ayIw7N7Cs+FnOCEMIov/4BMNKToWqsiH5RKeo6J66ha1bbtBRc8y6nzqPkahOL6YdYq9VybOcuO4cScSmSO8ktGskwvMxqNO42VNblgIyQatPfv8Hfbh57lBzvWMvtZE7qIGmQuVoHWiUqvDQJxSjIC0CtAG5djJpC35UwHIbhsLoylVzKejVTaGHs70icVU3cUHRqcMfEHbENxCFst61nalPaEicdIsUnFR9IggPnMHbHoRQcWBel5TlzVZPEUgDnx7tWTRXuA1ljodTjVz6/Tkald7I2+K5ZcSBcKnx4NZu65+Q4ffI68CrxEHD5ziWMAErqbxp06Y3ScWQtXdacrZyr3HDvKLISjwbwOxaPP0Z248v+ZWGaV62ddZy5aEqCLNeaxrU4OQr26QJTnEREjICtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6506007)(86362001)(38100700002)(54906003)(6916009)(316002)(6486002)(508600001)(6512007)(2906002)(6666004)(5660300002)(107886003)(2616005)(83380400001)(8676002)(66476007)(186003)(66946007)(66556008)(44832011)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EmValR1kgCnSRgLIeVvXpj4Nc648PyQPoeSiladcxBOfcAK2460Mr2gQ2q1S?=
 =?us-ascii?Q?XlrXd0u2PL5xrE3HI2OGNOI2CJZMcdOgiYv0lZqS/5o69GFnRA/KdvY1WRF7?=
 =?us-ascii?Q?maPW+vF03mqxjebzjxzx7OX2pmGl5+3JrWkMjYCC9QMDI4MqTfWqRc+9iYLq?=
 =?us-ascii?Q?Ao3bwKT3ViUiykd6ScrPGYORB5ml5AucJ3jrb/Yb1IdUkqteqlBevujRd3wv?=
 =?us-ascii?Q?0NQtQTBVBwAGQpwbGgmCOwauRAuk1+jO/jm7yWGBY/y+Z7/Wu6rY+jxZz1bm?=
 =?us-ascii?Q?2Vin3Bo+zubDXEkdUBxdMMnxAQl/UJZjObJFcwoGAsxbJBkYUOZZ4KN3v9tV?=
 =?us-ascii?Q?Gkd4XIHZAPh4Yv4KecRm9T/fM5rr1wpyGiS52PRBdu+NxiYBUrcuwv7+JyvB?=
 =?us-ascii?Q?0HcWQ1p9sLQQGyqoKcIFJCM07RPw97InxnV6wi0wyZtwOmPAvN3/uJbHb+fQ?=
 =?us-ascii?Q?8ACsc0Hd6+nBMrqRloUQkLds83uPIvthEHp2yCWJI+CSMhthvjFYGM1ZyAnD?=
 =?us-ascii?Q?OJTIugx9vAGlBNdvmQ37+BcevvLlFAUZpxGgAEuuOEzWmNZghMYp4SKRrXiL?=
 =?us-ascii?Q?ElZYuIHHyp7Le++zMJaoR2oYUvRgshATHoX7T/fqDeEXh7vF+OqA2lg7AlWN?=
 =?us-ascii?Q?BqOmupUJLPTrVP16hwiwK88I1B5WZpPunwKtLRJJmzGU2rc4Bt/ShHrB9s8c?=
 =?us-ascii?Q?Q4597qZCC8+jMiGfh3HKmUOrwSlh0aN00xiHttAb6bHOhF0y42SBUIrLxftM?=
 =?us-ascii?Q?Gf6YsNLcnP6PSE17yMLttp9pWF2hyng05vzpGqF/OxBD2v/TG6Nhy2JEDfRN?=
 =?us-ascii?Q?R6i0tAPbgGw5kf9npvZ4OEcNEQSan3Mzf177LXEYgKyR8Exc6qFJlWi2z5Ag?=
 =?us-ascii?Q?25uuM1ND1fN2qyhM756rC95aFLQKja6yqpV36BhW5bL39TkUqdnQYzFiwknI?=
 =?us-ascii?Q?sMGIqQX4gLPwA9d9BnoIWmyUMuEcSvfM4wf1Hzy36NRzJ/G5ZnO5MluuaWy6?=
 =?us-ascii?Q?wB0QHwj/14nLe/a2KoyixUVB9spm3LdfeuWMK2zmaWn0ibFsV5s1W25cyIqE?=
 =?us-ascii?Q?7ivqf1se8F7HB+YWBUo5xGol31PUik6Qw1tjtbUpMUQrTNc6rgTezQZL7EG/?=
 =?us-ascii?Q?zeeQvCB6W9z2JTrJL7B3V8riM4Vh+iR/vdbKvw56dfkOsat9ed53q9/tsPhO?=
 =?us-ascii?Q?3AnLqPdLP1gGoqfVFPCoYUqZUoZTKxt4QcI6kR7Vl3i2SeG3QCO8zyK8/eFT?=
 =?us-ascii?Q?LuoddhfXP19LISUl09tCBLClQt3u6RoMu+NVxae890Ztu1v1KLZyZBD2I9NO?=
 =?us-ascii?Q?kopLmIAdTRzsUaNrkFfEvLpmrsS/sTkU8VKtCnOGkykaPW5Zaz2m/cpx31p5?=
 =?us-ascii?Q?MqQxuvlH44+v9tZCaHai1+9K5H4qec8wLCdRN8y4zwBN2HU+nq9pAH+mqY6y?=
 =?us-ascii?Q?4tn3MuEyPf6Hu8NEYsNiP3AxpoXoH8NNqcz2sYQjLbZsVaaq8sf7csQ2l9Zy?=
 =?us-ascii?Q?bjuX+WIyhImoi8G5np7cxcufZuYoY7uVUWMAfijS2STyERylPUyQipxYKGlU?=
 =?us-ascii?Q?YN1IFwIZU3JpZYZa8SBaMpKs2bGljXSLQkgc4NXVGuT1KL2xpFp9cpTczMY/?=
 =?us-ascii?Q?zl6Cbn1A7xLKqPzLjs8+PLSzUEyiYwsPaVO8M88RIdOJb96xwCHvH+AE7iYE?=
 =?us-ascii?Q?Cp141CC7PNdqQ5eT9p/dlRDQgXTpQiyoH4InCiYt6XKLV08qDLUqeFkJxbxz?=
 =?us-ascii?Q?IVmLdtNtsnfSFmkHyHxKvS4Zz2iqVXkrXkUkYI48oVu5ZckEltxx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3c4b76c-565a-43e7-983b-08da1c439999
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:16:29.4681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4OFRAFK7raQR8e8nJEat8wvNnf/P+2B/k5idcs4ekQ6Q081H7cJWMWp+Eo6jMCsUyKVQ6O5sQwpb5AiavogP/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3329
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120024
X-Proofpoint-ORIG-GUID: a433yCVjcO5dbs4A_pAFGvaW5JvIx0XB
X-Proofpoint-GUID: a433yCVjcO5dbs4A_pAFGvaW5JvIx0XB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit 00bfe02f479688a67a29019d1228f1470e26f014 upstream

In the .read_iter and .write_iter file operations, we're accessing
user-space memory while holding the inode glock.  There is a possibility
that the memory is mapped to the same file, in which case we'd recurse
on the same glock.

We could detect and work around this simple case of recursive locking,
but more complex scenarios exist that involve multiple glocks,
processes, and cluster nodes, and working around all of those cases
isn't practical or even possible.

Avoid these kinds of problems by disabling page faults while holding the
inode glock.  If a page fault would occur, we either end up with a
partial read or write or with -EFAULT if nothing could be read or
written.  In either case, we know that we're not done with the
operation, so we indicate that we're willing to give up the inode glock
and then we fault in the missing pages.  If that made us lose the inode
glock, we return a partial read or write.  Otherwise, we resume the
operation.

This locking problem was originally reported by Jan Kara.  Linus came up
with the idea of disabling page faults.  Many thanks to Al Viro and
Matthew Wilcox for their feedback.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/gfs2/file.c | 99 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 94 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 288a789cb54b..2d0aa55205ed 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -777,6 +777,36 @@ static int gfs2_fsync(struct file *file, loff_t start, loff_t end,
 	return ret ? ret : ret1;
 }
 
+static inline bool should_fault_in_pages(ssize_t ret, struct iov_iter *i,
+					 size_t *prev_count,
+					 size_t *window_size)
+{
+	char __user *p = i->iov[0].iov_base + i->iov_offset;
+	size_t count = iov_iter_count(i);
+	int pages = 1;
+
+	if (likely(!count))
+		return false;
+	if (ret <= 0 && ret != -EFAULT)
+		return false;
+	if (!iter_is_iovec(i))
+		return false;
+
+	if (*prev_count != count || !*window_size) {
+		int pages, nr_dirtied;
+
+		pages = min_t(int, BIO_MAX_VECS,
+			      DIV_ROUND_UP(iov_iter_count(i), PAGE_SIZE));
+		nr_dirtied = max(current->nr_dirtied_pause -
+				 current->nr_dirtied, 1);
+		pages = min(pages, nr_dirtied);
+	}
+
+	*prev_count = count;
+	*window_size = (size_t)PAGE_SIZE * pages - offset_in_page(p);
+	return true;
+}
+
 static ssize_t gfs2_file_direct_read(struct kiocb *iocb, struct iov_iter *to,
 				     struct gfs2_holder *gh)
 {
@@ -841,9 +871,17 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct gfs2_inode *ip;
 	struct gfs2_holder gh;
+	size_t prev_count = 0, window_size = 0;
 	size_t written = 0;
 	ssize_t ret;
 
+	/*
+	 * In this function, we disable page faults when we're holding the
+	 * inode glock while doing I/O.  If a page fault occurs, we indicate
+	 * that the inode glock may be dropped, fault in the pages manually,
+	 * and retry.
+	 */
+
 	if (iocb->ki_flags & IOCB_DIRECT) {
 		ret = gfs2_file_direct_read(iocb, to, &gh);
 		if (likely(ret != -ENOTBLK))
@@ -865,13 +903,34 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	}
 	ip = GFS2_I(iocb->ki_filp->f_mapping->host);
 	gfs2_holder_init(ip->i_gl, LM_ST_SHARED, 0, &gh);
+retry:
 	ret = gfs2_glock_nq(&gh);
 	if (ret)
 		goto out_uninit;
+retry_under_glock:
+	pagefault_disable();
 	ret = generic_file_read_iter(iocb, to);
+	pagefault_enable();
 	if (ret > 0)
 		written += ret;
-	gfs2_glock_dq(&gh);
+
+	if (should_fault_in_pages(ret, to, &prev_count, &window_size)) {
+		size_t leftover;
+
+		gfs2_holder_allow_demote(&gh);
+		leftover = fault_in_iov_iter_writeable(to, window_size);
+		gfs2_holder_disallow_demote(&gh);
+		if (leftover != window_size) {
+			if (!gfs2_holder_queued(&gh)) {
+				if (written)
+					goto out_uninit;
+				goto retry;
+			}
+			goto retry_under_glock;
+		}
+	}
+	if (gfs2_holder_queued(&gh))
+		gfs2_glock_dq(&gh);
 out_uninit:
 	gfs2_holder_uninit(&gh);
 	return written ? written : ret;
@@ -886,8 +945,17 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	struct gfs2_holder *statfs_gh = NULL;
+	size_t prev_count = 0, window_size = 0;
+	size_t read = 0;
 	ssize_t ret;
 
+	/*
+	 * In this function, we disable page faults when we're holding the
+	 * inode glock while doing I/O.  If a page fault occurs, we indicate
+	 * that the inode glock may be dropped, fault in the pages manually,
+	 * and retry.
+	 */
+
 	if (inode == sdp->sd_rindex) {
 		statfs_gh = kmalloc(sizeof(*statfs_gh), GFP_NOFS);
 		if (!statfs_gh)
@@ -895,10 +963,11 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 	}
 
 	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, gh);
+retry:
 	ret = gfs2_glock_nq(gh);
 	if (ret)
 		goto out_uninit;
-
+retry_under_glock:
 	if (inode == sdp->sd_rindex) {
 		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
 
@@ -909,21 +978,41 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
 	}
 
 	current->backing_dev_info = inode_to_bdi(inode);
+	pagefault_disable();
 	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
+	pagefault_enable();
 	current->backing_dev_info = NULL;
-	if (ret > 0)
+	if (ret > 0) {
 		iocb->ki_pos += ret;
+		read += ret;
+	}
 
 	if (inode == sdp->sd_rindex)
 		gfs2_glock_dq_uninit(statfs_gh);
 
+	if (should_fault_in_pages(ret, from, &prev_count, &window_size)) {
+		size_t leftover;
+
+		gfs2_holder_allow_demote(gh);
+		leftover = fault_in_iov_iter_readable(from, window_size);
+		gfs2_holder_disallow_demote(gh);
+		if (leftover != window_size) {
+			if (!gfs2_holder_queued(gh)) {
+				if (read)
+					goto out_uninit;
+				goto retry;
+			}
+			goto retry_under_glock;
+		}
+	}
 out_unlock:
-	gfs2_glock_dq(gh);
+	if (gfs2_holder_queued(gh))
+		gfs2_glock_dq(gh);
 out_uninit:
 	gfs2_holder_uninit(gh);
 	if (statfs_gh)
 		kfree(statfs_gh);
-	return ret;
+	return read ? read : ret;
 }
 
 /**
-- 
2.33.1

