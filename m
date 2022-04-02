Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA9C4F0090
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354309AbiDBK3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352322AbiDBK3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:29:15 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01151AA056;
        Sat,  2 Apr 2022 03:27:23 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2321ueEU012994;
        Sat, 2 Apr 2022 10:27:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=u/v3316w8KLCnESzqpurHWRfFDLznln6FlAfW7lJLgc=;
 b=WjvUUontuYNiI+uaIp1Y183xpZxIR3OuXdg4SyHD+7PRSZax1GwAdWqsixun86voWWwf
 Ux+cvCDb/nwr+E5CZwu98MMf/qb9+ifr6xOf6xerptv4UddPvl0lhVyK+qGE+2lxvCd6
 fuGfdISwu8Wg6ITa2Vz10Wfh/E6395pzqhXMxdpja9xcy6rkNaoOPSNN17iJy0qGCrr5
 w10zlhSdiIT2HCMejPddCa24rOulxz9pVJG14tpIwmbOgCUPmUqFijpHcWSePE8ENuB9
 6S/tLH9jL1yQi6s6ktCd9WuCrHCoUMTA5kWyVgCNE+cON5Q6j+4EDd3dFe4E0m2ngzbG bQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d92rcad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:27:21 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232AKiXS027588;
        Sat, 2 Apr 2022 10:27:21 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx165qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:27:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGDKqZXI9YkBGEO4khcLL4n+IaNqT91ITWafZ2D3ZpSiZlOMwMe7ZCkZKvSz1BmkN16K7p3VbKXtdpe5+2Qasptwfc0HXk8FQ5AV5nakDC8sbN7DMKF5zSga9A/3t1oon/+1UZW0cs4gIXzRZyKyCtt5n3cKDVTV4tShbKvX+xjUUqOdtkcDNbEJq9+2EkkeybFVQm3k/IUfEhJXrIb08nKFw6QbuNf0tYEcnjbCMc7t228TbrTBmHsyfN/4EGhuW+9Duz2P4PO4paqXyf35juWqx0VtEpiauOMAXKGUjsAy77NoQ9YwEKex+1HAdY6vEdgToKPCjyTecJUXGVQ8iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/v3316w8KLCnESzqpurHWRfFDLznln6FlAfW7lJLgc=;
 b=HFyz4/hsUGa5FQ0u7VCqQzH8STIBGVHHyIY9RaGaOUB8F3b4gzrAVcIyP5DVqhUL+bGsjfGH6EMtt0ZiMxxW686J7/7cXkTrujsJjnLxq0BAyTXtsXL7y0DsWr9/s2kA3QH1zKUGxz6HhGsn+3hW4VkDU9DbY/hhcy9331krM6piEFc7T7mMrSRwI3IcmPYmImpZgFEenx8wWSJLJcP300JSlXPcWlPc0EKgBeIZTGYTZ1Y1VK5SbY7ppHb/gV/pNOtNjVqgDtxemf9LoyWqfC8ybybAAA7DP/W+D8VZCc+96QdpWxOHOnr/xQfdnWiQ/HrI2ZS/vspDywN/txCLaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/v3316w8KLCnESzqpurHWRfFDLznln6FlAfW7lJLgc=;
 b=rd0M3Kyhrru0MP0OfFZ9cnPIeD5NyC8sBYorEhCHaG0DPj0lv5sextMkuAu8NJ7LKISmJQpcPcblVoPzBcG4rF1haCAbEQumtyjvzCscXTmb/ul74B7HWw1DJtbUx5LjlVzPnH3LbqhtdPzWfbhLTHB3A8UrDBchzj9KflUAoe4=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:27:19 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:27:19 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 09/17 stable-5.15.y] gfs2: Fix mmap + page fault deadlocks for buffered I/O
Date:   Sat,  2 Apr 2022 18:25:46 +0800
Message-Id: <a3a8bd5036ed8942fe8fd8157dc7ce61d4e2f2aa.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0224.apcprd06.prod.outlook.com
 (2603:1096:4:68::32) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45c94010-ea8b-455f-49d1-08da14935dc8
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3049DCF86E4519856416DF96E5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S0s/kUyxfsEgwzi2CPqBG6ltYWXFzfha6H/UK9naf/u+tB/2vunHAOsab0NHhLg3xRZh0ompzLRDPbJqzmluQ/Z24+i/8LnwkTTx3NgpUF/n/DYoz3euNPPq9V+Sy8E48NajvYfvoYc5YgUXnAHSLXOYFYBVvIn4O6lk1u/LudPgK2F5XAdMzZNBmQmeLn3eV+11sp5FhU5K0nmpfTCAWqfBtFbTSCF/vsh4hYczyrAHn5iCfpylZrAWJ/guFXKnQs6YvFv4sdHh6jLe781ef2yqk9Yw7Tg+oPgQgm1hEs36vO5EnIn5CmxfqrZsnVQkKUiVh4/VX0wLnveoyhE1fGkQklUYOwa3cyosG94SXHvwkvK7L/xCXibwdDDYI5FvFqqckHpuns8pUKU3a+swJbBQFtHa0LcfHTIOwPXU7EhAxdeWZ3Tz/c5Ie8ongaTCJQ+KpLXNPpSdFWMueIUof4RSBfXvgJ6AcJx5VuNXsljZaI8ZbQ0VPrQfXRC1+44jIyb4Y00waulLCKcSR6lHzmZjwr2EoN27+kITjhLcoRz86wdQDWjcCUJlN5rrBLaBK5fzFxDmryvtZbQ7enCwM+9g0fJuws/z9tLYNP2jXxsZR0zcxOKT6bvqMVvSo9vEu7gEE0VwgojPuVhV3Wkq/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(38100700002)(83380400001)(316002)(508600001)(6512007)(36756003)(86362001)(26005)(6486002)(44832011)(66476007)(6506007)(54906003)(2616005)(6666004)(4326008)(186003)(6916009)(66946007)(107886003)(66556008)(5660300002)(8676002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W+rJgMJKbLxXQsemorMuzE/ZBZvdQ9Ot36SJj7P5AqU+IWIYlSpciFuSIXz+?=
 =?us-ascii?Q?Xlgz0g0nJqPcytUUMX+SS65OGyHDIjp1JpzwJuLiUyb1i++FiF7946E+Qwut?=
 =?us-ascii?Q?1KoOQGIcUW34DPT+OKZPr6wgjN4bh7UudV1ODnRyf0HPjh+3iQ+gR/JaLan7?=
 =?us-ascii?Q?9TAwg9ZYV8U6Nbnew+njZJfEU6M8vDEtnsHqb3p+5twneOu9oc7zTm/tCmtV?=
 =?us-ascii?Q?moCPteSdCfq2Te37zrpvygDAqMYTp5IHqirzC9/6gUWRRxznGpzKEgT/wY1a?=
 =?us-ascii?Q?xBDs4M3mUYSz9IKAMiL2vCRbLmrW4Bo/KrP6YGs93wwWopYeUGtVpMa8c9Fq?=
 =?us-ascii?Q?05uFskBXqiFQuF3nbiVqIkuE921yW0sAHDreuioj/NpPpmLjUj6qskadzpaW?=
 =?us-ascii?Q?IPcOqSs1UpLJCeFqCVgHzBZkzGPkyKlWntM7TTc7Y4Qb/fRIwh8YXRql8rT6?=
 =?us-ascii?Q?Tm8whDuOHPzDhVLFVxLoW9zxP6Ty2nhsR4M+lARqreEVbuTl6O5t/LyNnLGX?=
 =?us-ascii?Q?FuAOrHgOB1XbwkypTVioIBO+HMw7sLYlg5TNOjA4dtvzvMEleu7/f+OVeZq6?=
 =?us-ascii?Q?W6MWdOi2ZbEcF0zeJlh+/aEcQrL4pw36PTWTkk9G1xuQAE6v6A9VmlSTobSA?=
 =?us-ascii?Q?pQzfkH/amBcokE9hOgHb4rH5CE0gcvG+2mY/JLjphEoF9TplcybZZIpaf3t/?=
 =?us-ascii?Q?FafaCKGSSqw9Mjk54hYLGDQEXDBT8Qf4q7s1BUc99SETNaKJ+8tSE82zfoOw?=
 =?us-ascii?Q?AIVs+2Kw0DbZYGZ4EXfiSkXPfRN/NPpQGqoBOUltMHrDKttPXlUJuEzjyXcY?=
 =?us-ascii?Q?QLjU8mQ55NhL29JJoaC1fdLyBYmyHZJCcYIZB4aP4x515dLZg7AuAhKCTd7P?=
 =?us-ascii?Q?gC3W88ASkYpVZb+PF4XcoOp6otO4Lh1qSOAEQtt1vPPXK6xkTSMtV587pfeR?=
 =?us-ascii?Q?WdTUZHsA+NdHioh9a/wSgebOVBMU1+kBD5KQ4DbjUHd1PcAbEgfMrTRTYy12?=
 =?us-ascii?Q?DjH2sm6SltNXvd4KJr6joj7WN89Y6OxsMNqaDdetOh+kwkG6PDibwniHho5n?=
 =?us-ascii?Q?piBB79eTIQSf4VHIh3S/+TkSgqcQX7cy5RZdkAXbFTLU50XwguXuFKrCDPJt?=
 =?us-ascii?Q?zhzqvprGj582R4gBwywRMaaYNHr1I0J/mui+9fK/pkwVvJLMjSNZMTb0EbT+?=
 =?us-ascii?Q?HF0QTHzLyOCwSm7ZVxub7FSCSl9qETk3++gBxdS/fc1pJcWZLBDZtpVhfCLV?=
 =?us-ascii?Q?IVH8Vqwdqr350phsf9pDHUd2z0mnYfHMmy6vhwMlJ0eecRiKvkg2aPuY8Pxp?=
 =?us-ascii?Q?J+HSdBeTe99kK8hJpSf0NqslBnu/3TqpBRlbV+EVRqhizAhTIWKYSKewcGEL?=
 =?us-ascii?Q?wNolPZxggackmpOde1cHa0XzEfAwe32b6wOaTJJXV9Y5Jh55IrQgLTb4aUOE?=
 =?us-ascii?Q?G+inWeu/T1NnUOehLtZA/5FxMCv8fN12naNwmajnbe5Xr6Fz+YC3Bkrvkjz8?=
 =?us-ascii?Q?os7NKTOLbodLuKyq32ornUjYdL/DaWCcrWN2M8fz1VrEchrQ2D4fGaQAmWS4?=
 =?us-ascii?Q?L7KVM3y0rmEP9Xu1QPoRVHZtR4zFvjVqTaJN0o3Cw0z60B8LVCIrxKCtzEv5?=
 =?us-ascii?Q?88fOLyQ3x9OCUBwvfeQ6hLiRB3upUqwegkqdOyZoredsnzaDuApICEZ8ZPP6?=
 =?us-ascii?Q?sNlIxJBBjw3J2SDQvd0cJCZFuiQPB4zpJ7EeQaHkmAt8iboceGv+1TpDlHxS?=
 =?us-ascii?Q?eSNOUbPDEw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45c94010-ea8b-455f-49d1-08da14935dc8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:27:19.3282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9fN+528ZfZJGC20eCezdB76NBnkpoKSK6mDVkJBHAzTB/YyrwjJlAuu6vfNKlZXPnbyYIEJI4vrBCpYZ11tOaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204020064
X-Proofpoint-ORIG-GUID: H2DDe41TNbxPrZO13FfWv73HYF57IVMi
X-Proofpoint-GUID: H2DDe41TNbxPrZO13FfWv73HYF57IVMi
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
index 0c1b1d259369..2565cdb36332 100644
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

