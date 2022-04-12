Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606BF4FCEB4
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiDLFSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347751AbiDLFSD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:18:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999E3344EF;
        Mon, 11 Apr 2022 22:15:46 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C4ZfLf028018;
        Tue, 12 Apr 2022 05:15:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=6bF9vyIk5yV9BuCYF/O3x6dh+jd+7z5G073ajZC+whU=;
 b=vM7E6r5mviZVwlwH6pQpxCFTVPHF9CArCTvbz56sfLjjr53zg4rg9Sn6NvZCsmJkj0ZE
 D4BGW94eZjc06hyJtOkavcLyLPk4pA81/g0XUfjLAEwBkgxb8dQKzqIP5tkS5Isd6yUS
 pf9ymNleAtsDOPC4gHq4+Fj6zAzpqUPRP0MOBgjOfAqXgFY6sjXdxj0auKQ5HRqr6vZZ
 9/R26Uc2u7mbMegVuhUyp9ptyolPlLo8+60BF6pVTfiutLJOKK4L9iDbcYeMQQGPWV8J
 Tn2s3zk/6YOEXB0c+Vko50QaTjdYwiR0E3EIIAZyiiXvGNplnrXRYnMxT8AuKbnBPALR Ww== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb219wdxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:15:44 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5FhQq016586;
        Tue, 12 Apr 2022 05:15:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k2h5gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:15:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6Kzn6G6+sOcdsJzBikbcd8/TdbsZsGSDOnx2wJN+jfBut25NWq/xVGjHlVFEqh9Y4yh3uLp3eDvSNqEKX1x+yu0O5lqg2pVxHj/0GtTsNuKCLzbwwEG0CxFRxwYpFgTs7CoIu6gM/3m+qupJRbhzB00eGoTQ/geZ65jbOn2+HFoE5tcw+20oN0u/e2BneJ2K+Uezo+YT68nNFjen7I5uaMy82Q2mePsI5EsPVAuvFhJOWpgDaM6Bd3ELMu5MGLZUU9atw185ul8wW5QZsbArbDasYPaB1NmAIwqSQLiYLTTZnehXUx++5RPbLfGwFOxm3uMJIK57ol6pLmTDuQpZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6bF9vyIk5yV9BuCYF/O3x6dh+jd+7z5G073ajZC+whU=;
 b=Rwwm5YUekCspByFHiYWQon7L+WOsC8NitwLNmaojs06cV+wnGLjiijsVhFh1zf+U9yULZgPZmgN6TeOhotXKWCa3FmNi0qpagTIgksPOncBKeexPZ1d3pJ97Om6OYhtktSN9rIwVWCueyHl4xCmrScKDyuCIJYK3uMhT83jjVZjOUceQqqPOmYv7Av0dBpJz3HBQLY0KPq9TuXOOEvOHtOJtsPSuFHWqAlIwY1UuOJQW5LKWhfvmR65DZVUMf5UxXCX9PoO0vHW9nlzGgHB0t3uXNamxpPd63ZPT0op4RmQtJibiSqL1mrViqFCySruoPhaZwcAtPvjC76lKjFpk8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bF9vyIk5yV9BuCYF/O3x6dh+jd+7z5G073ajZC+whU=;
 b=BP7ZL/xDCota4kFyP7LC2YgzJcMEv5NFHJupLwHR7Fq3TstbokzVkMDp8SWWKJV9I/FTOG+xleM7YFxovm56tXUN26ZJrOB08hxMUZzanrPoLCUhdEs8fwUC9kbF8hqIPq/5s3wT7D0eauIQtcgkUV0gsuk7drs5SgpfV4D/zwY=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BYAPR10MB3256.namprd10.prod.outlook.com (2603:10b6:a03:152::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:15:36 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:15:36 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 01/18 stable-5.15.y] gup: Turn fault_in_pages_{readable,writeable} into fault_in_{readable,writeable}
Date:   Tue, 12 Apr 2022 13:14:58 +0800
Message-Id: <cc13bb290ebf2abc2e676b4ece9f3fc39797f839.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0007.apcprd06.prod.outlook.com
 (2603:1096:4:186::9) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40d019c5-4c67-457b-d8a0-08da1c4379e2
X-MS-TrafficTypeDiagnostic: BYAPR10MB3256:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB32566CD4D2A776C2762E7D73E5ED9@BYAPR10MB3256.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WKzpNcT+YLwCCrVCpvitpjxyr0QCfCOIrX/OG5SSO7URhLMvpacZxDQ11uqaKjRKAmgxJvsa+jTtHX66CtixBDwQvg+9dEgPkQLalWujxJd7lbkK4iX5ky4PayVIX4n4LHVIBeIL5TVewLIxNC2acd5r6uDrJtMyB+p2X/+JBDXnVOJ/4YmtE9BDLsi/On3sew37pmN97zJH6jBU2Ryj2I/d8vF6soO5vBLwUnY5Crhn1rpAzE8DMKXXNQOguWjx2S1d4OO3ndQPJ63XLte9hzqnxz0ZZHIncG5LVjgsyEbCRXPhJrG/3S+mftyRxF4iB4mW1DxB4CaDLVXvXv5KC9FzfGI0w+zva61nlNnarXZsXQrn7ZEbmzE5z4yceTYbdnZ8BipZqlvzHZTmTRX6tvPb1x80LNGUyId4jR/kktGvSFkqy0M0HIqkPII5UtMH47owpWwHQXtMtr82ud4H8vTwwZlBUVthyjOyPLh3wgkqlSPEV9O/3pSeQ632p24zKKOswqcJkBq5ZxDLImHlleeXtNeojpWlDVK72l4UZwovh6AtLCsgP8hcJoqMV/4LIQ0/TZPjkB850yWMt5mHVvNIuYs9djwmT7LFV83p8bZu+ReDcX4h9PTJhffxDpcXKzsKb2Vu4H6gry0TjeDctA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(8936002)(5660300002)(30864003)(2906002)(83380400001)(6512007)(2616005)(66476007)(44832011)(107886003)(186003)(6506007)(6666004)(508600001)(66556008)(66946007)(6486002)(86362001)(54906003)(36756003)(8676002)(4326008)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PUoUC2qMP3LeZZVIOu5XwHCIwqH0qjwMoO8CeVKHNBUSZPF5G4fxtHcaIJYa?=
 =?us-ascii?Q?W3Tv3viYfQUcM2on6r5SLIlEUm1QPo6JJaLPLb9WtBYxgKiqXsEJFg18fZXM?=
 =?us-ascii?Q?hBWqe7GuGbIW0cT5XdItrz6Pc83XscCLnZQqp194dmgQm8z0bZBmOfzYpW/W?=
 =?us-ascii?Q?piHdwQi8kLwKLf1u7LyG94QmuIDNep/CQSQ2TPvng4REkJWBjEjSGLduKLgY?=
 =?us-ascii?Q?hOW+jQ4JrqN554mX9P6P7cSmm5iD+WdlnwHCgo58YaqDLNML8/Z/NWGQTBzR?=
 =?us-ascii?Q?e5fOe8HRMPGQsePBzu41fa2inZE1dHWAsr2az+/yTNXpOWKxPruonzuMBM4K?=
 =?us-ascii?Q?uRUbty6zV6o7RI9ejVCB2/QVu/xnM5luv6hHwmtFZ/LERxfMC45w6VDsKyrD?=
 =?us-ascii?Q?DeWsQwisIli2wyrsZM4l2aQpwZCn5sMK6qvxaIwE76dWkRCL9BQsOsqFy864?=
 =?us-ascii?Q?vm1zgW1KPafsPKTIdpafY4z/SbjXYvmI9FOEotLWf38IDR8+m1sxhOp8g8qf?=
 =?us-ascii?Q?+NrMcDSFFj2GiaBp68S3QfF/bGYv12Ezn7nIJTeUszNWKB+TQsqEjOKEEuPx?=
 =?us-ascii?Q?mih1WRBI8TOKQQdG0DrX9bXrFtnU6W3wiuDzxyTpGP7JS+cX9fwp6Iy9sEhP?=
 =?us-ascii?Q?I9PbCA13hxMTXCTBC6+ucvKCcnQwyzmGwBULCYC1dw5ZAPJYrSIUUATwdknr?=
 =?us-ascii?Q?P8U0EQYXAM0EFIePys/auxmbkYXITBzw/fz/xHabLkFgj7UxZR96UK4Guyqo?=
 =?us-ascii?Q?EaTGF03uVyJLixbvvSo6nKTUJz4Jleofuvzs14oqvQ20MW1D+ZvIt559/XE+?=
 =?us-ascii?Q?1SCZvIrp6HMzzd+UPz1Qrd3IGTpWJD2yVOLRrydvNjmwqMBLrOX8BqbNLCPQ?=
 =?us-ascii?Q?rK+f/lGkFP2qeYiRqEfDV2R6H3NuJtA17mN7Vt2q5SdNkjsrVJOBuCSouk/P?=
 =?us-ascii?Q?L1jjl1Ni8zKX4T07fNIwT6nzr60x3mhfyPdJSfjjYlOs3DYcPbtAPvAWOMAn?=
 =?us-ascii?Q?v+e69lW2NFyqigzk1QF3vBwLqRCOt41WtlcBNfaGqmXqY3n2l2kTzaDMvz/a?=
 =?us-ascii?Q?tZZXHFDSBmsbWnUuw9RU6XMyRkxjHW7KqDb/8v65n1LthB7oDfLMrJIV49/p?=
 =?us-ascii?Q?fMsWd9o4HimYQ+a/tnkbHEVddnCYvuNZj55ucVh4pHFGvnHzPhCx494xRpvG?=
 =?us-ascii?Q?FqVGQs2lU6SNSNQFH7ldco5SnLz4lHVIQandytP9Z+ky5sotGsNupUJEEuCo?=
 =?us-ascii?Q?eEj2df7ISivvrvI7dRUQkAPYggNBs0pzO+BYCX5NQtCUlUep/GJ+eJ0am+VX?=
 =?us-ascii?Q?mMoTAuDJ+jJOyPgLIUK1FxAnk8yQz3KH+i9uVY0J9Z98mS54iTTrkVJdvm83?=
 =?us-ascii?Q?SD43l1FlanIHGWcbNi5IMXl2+ZvjDik61zfw6P46+pGR1L9WUnU2UFHx17Ze?=
 =?us-ascii?Q?HtN1cZYrGNVFkF0xqlGJJs2oAvB5if4ze27DtOBy15O8gbODGd64Xm2aoJws?=
 =?us-ascii?Q?xdqXws4lH9Isol+BU8cWAT++DRyheMwWQopZatRB7MOeslci5Sc57yHKObkk?=
 =?us-ascii?Q?4jUGyuVFCX6K9dHDLA9ERkLTiXArCorrNHUHQ3pXpFlyg2wnf6PVYCKb7+WA?=
 =?us-ascii?Q?3TMYQNKOR2cye73V8qkKyeJpOsi+VSwY/QsNca7kPnNe7SusVM8oaHSBZ3D3?=
 =?us-ascii?Q?d/HzMo+hQypqkrY2ocD2EI2lEZFB5pvKiTq21VYh24CaQUfJo5YMgXiZVo1e?=
 =?us-ascii?Q?blwb/HWL2lwrtzFJWh48oKWL6KbpO07sp3NBrtsR7r7IxFp3dLK0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d019c5-4c67-457b-d8a0-08da1c4379e2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:15:36.2297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5lJSQOtoWCkdShBc84IsZGb1D7nHuh5Tk7Rb1enpI99e2ZGVcMNkbJa9OuoQjJ7mi6yTaP1yVenP9yQCQguMkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3256
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120024
X-Proofpoint-GUID: wSRLVjnSgIainkyzQuWJlLg0qiCygnAU
X-Proofpoint-ORIG-GUID: wSRLVjnSgIainkyzQuWJlLg0qiCygnAU
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

commit bb523b406c849eef8f265a07cd7f320f1f177743 upstream

Turn fault_in_pages_{readable,writeable} into versions that return the
number of bytes not faulted in, similar to copy_to_user, instead of
returning a non-zero value when any of the requested pages couldn't be
faulted in.  This supports the existing users that require all pages to
be faulted in as well as new users that are happy if any pages can be
faulted in.

Rename the functions to fault_in_{readable,writeable} to make sure
this change doesn't silently break things.

Neither of these functions is entirely trivial and it doesn't seem
useful to inline them, so move them to mm/gup.c.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 arch/powerpc/kernel/kvm.c           |  3 +-
 arch/powerpc/kernel/signal_32.c     |  4 +-
 arch/powerpc/kernel/signal_64.c     |  2 +-
 arch/x86/kernel/fpu/signal.c        |  7 ++-
 drivers/gpu/drm/armada/armada_gem.c |  7 ++-
 fs/btrfs/ioctl.c                    |  5 +-
 include/linux/pagemap.h             | 57 ++---------------------
 lib/iov_iter.c                      | 10 ++--
 mm/filemap.c                        |  2 +-
 mm/gup.c                            | 72 +++++++++++++++++++++++++++++
 10 files changed, 93 insertions(+), 76 deletions(-)

diff --git a/arch/powerpc/kernel/kvm.c b/arch/powerpc/kernel/kvm.c
index d89cf802d9aa..6568823cf306 100644
--- a/arch/powerpc/kernel/kvm.c
+++ b/arch/powerpc/kernel/kvm.c
@@ -669,7 +669,8 @@ static void __init kvm_use_magic_page(void)
 	on_each_cpu(kvm_map_magic_page, &features, 1);
 
 	/* Quick self-test to see if the mapping works */
-	if (fault_in_pages_readable((const char *)KVM_MAGIC_PAGE, sizeof(u32))) {
+	if (fault_in_readable((const char __user *)KVM_MAGIC_PAGE,
+			      sizeof(u32))) {
 		kvm_patching_worked = false;
 		return;
 	}
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index f2da879264bc..3e053e2fd6b6 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -1048,7 +1048,7 @@ SYSCALL_DEFINE3(swapcontext, struct ucontext __user *, old_ctx,
 	if (new_ctx == NULL)
 		return 0;
 	if (!access_ok(new_ctx, ctx_size) ||
-	    fault_in_pages_readable((u8 __user *)new_ctx, ctx_size))
+	    fault_in_readable((char __user *)new_ctx, ctx_size))
 		return -EFAULT;
 
 	/*
@@ -1239,7 +1239,7 @@ SYSCALL_DEFINE3(debug_setcontext, struct ucontext __user *, ctx,
 #endif
 
 	if (!access_ok(ctx, sizeof(*ctx)) ||
-	    fault_in_pages_readable((u8 __user *)ctx, sizeof(*ctx)))
+	    fault_in_readable((char __user *)ctx, sizeof(*ctx)))
 		return -EFAULT;
 
 	/*
diff --git a/arch/powerpc/kernel/signal_64.c b/arch/powerpc/kernel/signal_64.c
index bb9c077ac132..d1e1fc0acbea 100644
--- a/arch/powerpc/kernel/signal_64.c
+++ b/arch/powerpc/kernel/signal_64.c
@@ -688,7 +688,7 @@ SYSCALL_DEFINE3(swapcontext, struct ucontext __user *, old_ctx,
 	if (new_ctx == NULL)
 		return 0;
 	if (!access_ok(new_ctx, ctx_size) ||
-	    fault_in_pages_readable((u8 __user *)new_ctx, ctx_size))
+	    fault_in_readable((char __user *)new_ctx, ctx_size))
 		return -EFAULT;
 
 	/*
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 831b25c5e705..7f71bd4dcd0d 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -205,7 +205,7 @@ int copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 	fpregs_unlock();
 
 	if (ret) {
-		if (!fault_in_pages_writeable(buf_fx, fpu_user_xstate_size))
+		if (!fault_in_writeable(buf_fx, fpu_user_xstate_size))
 			goto retry;
 		return -EFAULT;
 	}
@@ -278,10 +278,9 @@ static int restore_fpregs_from_user(void __user *buf, u64 xrestore,
 		if (ret != -EFAULT)
 			return -EINVAL;
 
-		ret = fault_in_pages_readable(buf, size);
-		if (!ret)
+		if (!fault_in_readable(buf, size))
 			goto retry;
-		return ret;
+		return -EFAULT;
 	}
 
 	/*
diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
index 21909642ee4c..8fbb25913327 100644
--- a/drivers/gpu/drm/armada/armada_gem.c
+++ b/drivers/gpu/drm/armada/armada_gem.c
@@ -336,7 +336,7 @@ int armada_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 	struct drm_armada_gem_pwrite *args = data;
 	struct armada_gem_object *dobj;
 	char __user *ptr;
-	int ret;
+	int ret = 0;
 
 	DRM_DEBUG_DRIVER("handle %u off %u size %u ptr 0x%llx\n",
 		args->handle, args->offset, args->size, args->ptr);
@@ -349,9 +349,8 @@ int armada_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 	if (!access_ok(ptr, args->size))
 		return -EFAULT;
 
-	ret = fault_in_pages_readable(ptr, args->size);
-	if (ret)
-		return ret;
+	if (fault_in_readable(ptr, args->size))
+		return -EFAULT;
 
 	dobj = armada_gem_object_lookup(file, args->handle);
 	if (dobj == NULL)
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6a863b3f6de0..bf53af8694f8 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2258,9 +2258,8 @@ static noinline int search_ioctl(struct inode *inode,
 	key.offset = sk->min_offset;
 
 	while (1) {
-		ret = fault_in_pages_writeable(ubuf + sk_offset,
-					       *buf_size - sk_offset);
-		if (ret)
+		ret = -EFAULT;
+		if (fault_in_writeable(ubuf + sk_offset, *buf_size - sk_offset))
 			break;
 
 		ret = btrfs_search_forward(root, &key, path, sk->min_transid);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 62db6b0176b9..9fe94f7a4f7e 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -733,61 +733,10 @@ int wait_on_page_private_2_killable(struct page *page);
 extern void add_page_wait_queue(struct page *page, wait_queue_entry_t *waiter);
 
 /*
- * Fault everything in given userspace address range in.
+ * Fault in userspace address range.
  */
-static inline int fault_in_pages_writeable(char __user *uaddr, size_t size)
-{
-	char __user *end = uaddr + size - 1;
-
-	if (unlikely(size == 0))
-		return 0;
-
-	if (unlikely(uaddr > end))
-		return -EFAULT;
-	/*
-	 * Writing zeroes into userspace here is OK, because we know that if
-	 * the zero gets there, we'll be overwriting it.
-	 */
-	do {
-		if (unlikely(__put_user(0, uaddr) != 0))
-			return -EFAULT;
-		uaddr += PAGE_SIZE;
-	} while (uaddr <= end);
-
-	/* Check whether the range spilled into the next page. */
-	if (((unsigned long)uaddr & PAGE_MASK) ==
-			((unsigned long)end & PAGE_MASK))
-		return __put_user(0, end);
-
-	return 0;
-}
-
-static inline int fault_in_pages_readable(const char __user *uaddr, size_t size)
-{
-	volatile char c;
-	const char __user *end = uaddr + size - 1;
-
-	if (unlikely(size == 0))
-		return 0;
-
-	if (unlikely(uaddr > end))
-		return -EFAULT;
-
-	do {
-		if (unlikely(__get_user(c, uaddr) != 0))
-			return -EFAULT;
-		uaddr += PAGE_SIZE;
-	} while (uaddr <= end);
-
-	/* Check whether the range spilled into the next page. */
-	if (((unsigned long)uaddr & PAGE_MASK) ==
-			((unsigned long)end & PAGE_MASK)) {
-		return __get_user(c, end);
-	}
-
-	(void)c;
-	return 0;
-}
+size_t fault_in_writeable(char __user *uaddr, size_t size);
+size_t fault_in_readable(const char __user *uaddr, size_t size);
 
 int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
 				pgoff_t index, gfp_t gfp_mask);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index c5b2f0f4b8a8..2e07a4b083ed 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -191,7 +191,7 @@ static size_t copy_page_to_iter_iovec(struct page *page, size_t offset, size_t b
 	buf = iov->iov_base + skip;
 	copy = min(bytes, iov->iov_len - skip);
 
-	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_pages_writeable(buf, copy)) {
+	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_writeable(buf, copy)) {
 		kaddr = kmap_atomic(page);
 		from = kaddr + offset;
 
@@ -275,7 +275,7 @@ static size_t copy_page_from_iter_iovec(struct page *page, size_t offset, size_t
 	buf = iov->iov_base + skip;
 	copy = min(bytes, iov->iov_len - skip);
 
-	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_pages_readable(buf, copy)) {
+	if (IS_ENABLED(CONFIG_HIGHMEM) && !fault_in_readable(buf, copy)) {
 		kaddr = kmap_atomic(page);
 		to = kaddr + offset;
 
@@ -447,13 +447,11 @@ int iov_iter_fault_in_readable(const struct iov_iter *i, size_t bytes)
 			bytes = i->count;
 		for (p = i->iov, skip = i->iov_offset; bytes; p++, skip = 0) {
 			size_t len = min(bytes, p->iov_len - skip);
-			int err;
 
 			if (unlikely(!len))
 				continue;
-			err = fault_in_pages_readable(p->iov_base + skip, len);
-			if (unlikely(err))
-				return err;
+			if (fault_in_readable(p->iov_base + skip, len))
+				return -EFAULT;
 			bytes -= len;
 		}
 	}
diff --git a/mm/filemap.c b/mm/filemap.c
index 1293c3409e42..d697b3446a4a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -90,7 +90,7 @@
  *      ->lock_page		(filemap_fault, access_process_vm)
  *
  *  ->i_rwsem			(generic_perform_write)
- *    ->mmap_lock		(fault_in_pages_readable->do_page_fault)
+ *    ->mmap_lock		(fault_in_readable->do_page_fault)
  *
  *  bdi->wb.list_lock
  *    sb_lock			(fs/fs-writeback.c)
diff --git a/mm/gup.c b/mm/gup.c
index 52f08e3177e9..e063cb2bb187 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1681,6 +1681,78 @@ static long __get_user_pages_locked(struct mm_struct *mm, unsigned long start,
 }
 #endif /* !CONFIG_MMU */
 
+/**
+ * fault_in_writeable - fault in userspace address range for writing
+ * @uaddr: start of address range
+ * @size: size of address range
+ *
+ * Returns the number of bytes not faulted in (like copy_to_user() and
+ * copy_from_user()).
+ */
+size_t fault_in_writeable(char __user *uaddr, size_t size)
+{
+	char __user *start = uaddr, *end;
+
+	if (unlikely(size == 0))
+		return 0;
+	if (!PAGE_ALIGNED(uaddr)) {
+		if (unlikely(__put_user(0, uaddr) != 0))
+			return size;
+		uaddr = (char __user *)PAGE_ALIGN((unsigned long)uaddr);
+	}
+	end = (char __user *)PAGE_ALIGN((unsigned long)start + size);
+	if (unlikely(end < start))
+		end = NULL;
+	while (uaddr != end) {
+		if (unlikely(__put_user(0, uaddr) != 0))
+			goto out;
+		uaddr += PAGE_SIZE;
+	}
+
+out:
+	if (size > uaddr - start)
+		return size - (uaddr - start);
+	return 0;
+}
+EXPORT_SYMBOL(fault_in_writeable);
+
+/**
+ * fault_in_readable - fault in userspace address range for reading
+ * @uaddr: start of user address range
+ * @size: size of user address range
+ *
+ * Returns the number of bytes not faulted in (like copy_to_user() and
+ * copy_from_user()).
+ */
+size_t fault_in_readable(const char __user *uaddr, size_t size)
+{
+	const char __user *start = uaddr, *end;
+	volatile char c;
+
+	if (unlikely(size == 0))
+		return 0;
+	if (!PAGE_ALIGNED(uaddr)) {
+		if (unlikely(__get_user(c, uaddr) != 0))
+			return size;
+		uaddr = (const char __user *)PAGE_ALIGN((unsigned long)uaddr);
+	}
+	end = (const char __user *)PAGE_ALIGN((unsigned long)start + size);
+	if (unlikely(end < start))
+		end = NULL;
+	while (uaddr != end) {
+		if (unlikely(__get_user(c, uaddr) != 0))
+			goto out;
+		uaddr += PAGE_SIZE;
+	}
+
+out:
+	(void)c;
+	if (size > uaddr - start)
+		return size - (uaddr - start);
+	return 0;
+}
+EXPORT_SYMBOL(fault_in_readable);
+
 /**
  * get_dump_page() - pin user page in memory while writing it to core dump
  * @addr: user address
-- 
2.33.1

