Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9944F007E
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354287AbiDBK2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235885AbiDBK2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:28:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 526B653E1F;
        Sat,  2 Apr 2022 03:26:25 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2321VUoY016265;
        Sat, 2 Apr 2022 10:26:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=6bF9vyIk5yV9BuCYF/O3x6dh+jd+7z5G073ajZC+whU=;
 b=CniZBGxTHC+rC1pgNHJL6eWyteD2n6Q20YQNfyBre8FIkUkr5kJ3UIdOJ3+gIsutAYq7
 sTtBycumXwOzKwnDd9p7XJt0gYpzJNLLv/bc2OSEKPykCiLrn8mOobWOnWz0/XwvOB9X
 2nW+q4vWxXmRVxU0M5aJ4OrmrYEP40AcUbWUGMV5QrGOgXyR3xt4j+E23kjFH21BzZEg
 wuhgBH/sMXzQAPKNJk82Xu65jj1/svL9211HCODfds4zEmI8mMryf2N1ux4xFv66uE6X
 OsckleikZzcGtUFL5ad2lbAgfu5NWB3GZ5I+qfqUxiN4xrkgQbYNdcsswIdAb5911Ify 0A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwc8cpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:26:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232AKdIB027544;
        Sat, 2 Apr 2022 10:26:22 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx165gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:26:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lal4ZXVYNTO4u1ZwTOpYYA3mXA9Lf9YsbC7vWw0UiUnSmrFkc4Xw6v1SQl1p9kKaS0c7PRGsSM/NSrj53NoCM2ryB//1p021fj6xTq/BeO/IwkGoi96mkgbY/FdzBFOsW1BGiFPe9NGKdqiEy/6XHczRO0+EpCm2YQA2TZxl7fii8rGYTjuDQxjTsVQAZL1OhZcff6Zc/LIDwVF+iviXnFMjov6cflmzbZRfkLVTyFsVSDFB6aCELVICRM9aSoFg+6TGKKV8tKr7Mb92r+8W8fbdB4RSyred1A+d56UTKy6MnHRCnTj/2XHjNxkK910AalgPwRtawGw70rk/n7QCVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6bF9vyIk5yV9BuCYF/O3x6dh+jd+7z5G073ajZC+whU=;
 b=oatRJJe99P2EG7KFDpWKwYmWcIpVytlDmlZukq1YDX14tAggvXpJHmIchp/Q2IzaCXrohsLIg3OujXp7pqkRh+h4S5smdggVMWt1R+8SXCqjQVvOxudU3s1ewNI/LQHAJNLmmEFjxmZitQYTQwR00Bp73hbHpWOWOYtPTRCDxLH43zzYqRGPz+cP/1RghZKJHXlXo1In7FNc8tXTecsFP7WOHCZogGbR2Li80+nBQi0k6a4qPH+4MocMt8t8Rx/uVwpU0R5TkZpQ0CuM/vYbwOk7vrqOmq2oujfe5OAjGiTHlPYIz/D7ZDX5/Mvvsq55W+UDoxrIVacpzgSjDEItLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bF9vyIk5yV9BuCYF/O3x6dh+jd+7z5G073ajZC+whU=;
 b=DnIHtqjRcmaFRfk484mpQhCNDwCWhjuRhXqgHi/9vsrXcxpdk94h1CqTgH0jAe3F7nPI6Dy3314wTiP2ZMxe5ckpf1gkXeB2OfYmyVAbMYDJC1GSgHVmCJiJSbOx7jceCbRzH9TBlubW8Xs4QM1fgtg8XQxuesfi7eW/y7GhYGg=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:26:20 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:26:20 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 02/17 stable-5.15.y] gup: Turn fault_in_pages_{readable,writeable} into fault_in_{readable,writeable}
Date:   Sat,  2 Apr 2022 18:25:39 +0800
Message-Id: <d5e8799dd9c350069405bef1b366a0462e38df24.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0184.apcprd04.prod.outlook.com
 (2603:1096:4:14::22) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9283dc4d-40cd-4d9b-48fc-08da14933a5f
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3049E66AAC5219A72C8DF07BE5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rVMIV6sF+c2Cly9mKNK0Qlsth9tjf/vfxPy40SFtgr2Cfcw8T2jtw6bik5QmEdrkCv063a3DN842A89RFR8ixhTnYr9eGTGtkwUxYmslEUfkniy4QanwJpzcxNXRGVlOJvWGeJQiqHr9UToMD/GMmMYpvJ1Dt1fmutFTVyd/P3/sYlGlC44lo+itl6yNQ/rgEV2gkVur0xxKrsLqYQ2017ofqnVE+nZ3wuxq6iCuIK8rHxVk8HlP6+XAsPFQMmdNNd2KIVibrQ7yuDVXm8JU0xF29aa5rCuGygq89JvMXGFTLn9iy347WmFVyZfeArC/G0h5dHGWxeC77wrCuopvsyhyd75YzHi3LX7AhR03J+R8d4UTF+u693YcG8/TCWhIwCe5+AKAMaNBW/kGsc0KEvNqUoh43O0FP3vCm+FKln/epOo44EfqfIrXGv14NQvExXDJNzp0Ahala3H4qekrxipaiqu+EketHf8JTTNMc0avLkd8zv+ChqYVCDee46WicHf/P3zQuRZMIJ7uj4YVr7SYK7bpzu37CMc/FvlAYjvY+b/782mRLNERsXMQgSt0UZFnGoSMA/FRTo8JbTXuW0O3lCy695Mcai73bgdF4NqEYPDi50IydEuUcFIaeHU/13sZNaNqUa/DQROs8CMCbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(26005)(6486002)(66476007)(54906003)(6506007)(36756003)(6512007)(86362001)(5660300002)(66946007)(107886003)(66556008)(8676002)(2906002)(6916009)(2616005)(186003)(6666004)(4326008)(38100700002)(8936002)(316002)(30864003)(508600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jhDuoHWNXLnb3Y4gqatJjWImhQywirNyGG32cIqu8AuXVgJOtfi29DOcATrf?=
 =?us-ascii?Q?HK+dOzVj4aXj0hTBg2zCmVa6id4WWUDCyM8EfffZDU++LYI3miwJloAVmlV4?=
 =?us-ascii?Q?a1+d8v+0+PC8GZCq+m3wdmWlbYFpQ+qyVIoh1cS85yBbHfLBUFSqqc+Rug+w?=
 =?us-ascii?Q?QVLbeAymN63wgxhCXQI0kn8qIn7L5STmEDfzq8oFwSYUHnIk4pRB0Kp62ZQh?=
 =?us-ascii?Q?ii4rl+bvoAcphyVc3EWrKXpQRMkF9ipEO+3CzcHaS3Q5J14nTEv/Zt+4lt4F?=
 =?us-ascii?Q?8yMPspLZTjhaxek+GLwa5tb/R9XZja9pgxt1tHRCfsnMQODGHnPCtJiL+Z33?=
 =?us-ascii?Q?IihFny57CPvQ6tboE6+JBqsGZuSx6AHwZoC9s6jp1mgZcYBgDyF7uAtqwFtw?=
 =?us-ascii?Q?x9kP1afmou1xXRhqJIXsbcZXmZW0iuIN3QVvq6b7FrPfjabA4b0VVZD7VGn2?=
 =?us-ascii?Q?HAmkKMWJUMS+De3BiQOl9votOMf/VBT00l9jTLe1v8YeOapKfQ3xyF6DR0oY?=
 =?us-ascii?Q?K+N7d+HHx+4pTTlayV8XkCOI1kGnxni8tnWYvVSTNjdDiSfPZKZ+wd1fpqlI?=
 =?us-ascii?Q?FCOqlrZOiK5TYrTzmMOjDQs1q4qvx3qnOU7R154ZeAGM6P9bXfUzcVPQhBnh?=
 =?us-ascii?Q?yikRQExE6N9ChijeDmhlpK34BnCJIW9AT9mIcG4iFRbPYhsNEyIHdegdEkTf?=
 =?us-ascii?Q?Q+HimTHJ5HEgidZAKGgfnjdha+1x8eiebd3q1sALkO4lQ/XS1TWVmMQ2BNLq?=
 =?us-ascii?Q?jzD5pLiB25oCar+rF1zjzaFn2gNwIIF5XHJaH9VcF9DLE/GJYrx6eCV/Gj6P?=
 =?us-ascii?Q?jr0+P2ZjB9J3CF1ywQGFN9QRiXN7sQaW4rQdywuhhATe7+hOTKaFiDMpNRX6?=
 =?us-ascii?Q?4vPai5dhrQQWTWvpJbvTVam5FYU89JXbxy5G0vrK7wbkQSmNkFb0Dhtbmkh/?=
 =?us-ascii?Q?shiwoLZPpuVzJSlgKHSmL11GUOXa9hWZN6N9JVfoPqz1yKvY+h+WbhTLTn8N?=
 =?us-ascii?Q?0+QCBaRFC19kvlvzPM65U1gOB5k1or7WpfQ3uDj8+duRmYptWZ8Lkfmzmpzj?=
 =?us-ascii?Q?0gTPMX5WKyS0DkTuqjdxh42wpLuWJMZWUrzYIPhRa9v1bFYLa04WGOIfJKwp?=
 =?us-ascii?Q?HK90xv8U3HIkPa9Kmxa/Zv8Y6YhgtErBtQGDhNAM0rgCkWZ/WKWu0GFwpsnh?=
 =?us-ascii?Q?G2+Vt4vsb4qDphokD2rlnYdsgDcA1/CVWsLHLMpBMDT/cBSYI8MsqbXjFOAn?=
 =?us-ascii?Q?Suv6+s9wgqNPYZ2RoWZ9FkaP6331Y0wL41Ps15dzXAP/EgjtKMRk4JGoPn5c?=
 =?us-ascii?Q?AZrl7JFsi4v4U2exwTD++eFKEKcbfdL9sqMUSko/G8NR97sR3Cy8FsuCAM7L?=
 =?us-ascii?Q?FSVF3yKutv4yOmceKVheZQvmBLXaVKZeQi/K9RLEf55u6+s4gQ9DeMFT1bE4?=
 =?us-ascii?Q?JChaNXD7KqADNLxT9zMbF7JxQk6J1Sa9LvGmbygfRMQQFUXdEUHGXeOQqH6b?=
 =?us-ascii?Q?DVoxaF1POjG6rZD1mb2VQFPumVGu2hFLqoYzLhxz7dxaTbX+bkpzHZeXnVuI?=
 =?us-ascii?Q?/vbtx3kpf3hV3Q1kPKOYSwriVxRCnRGN6lRKwMlo0AyMCsSnauZrLeMPSHdS?=
 =?us-ascii?Q?2QRqBat63pOhGp5osziWnk4ynhuwkd22GSKYbgllKE3pAyw1m2vkVJRvWWdc?=
 =?us-ascii?Q?G4wxrXMHETxfpQtlWbEy2mqTkx5dCywjNov3ZJqd1Mon7nxwBc00v80F+Hrr?=
 =?us-ascii?Q?X1vXJ6uXnA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9283dc4d-40cd-4d9b-48fc-08da14933a5f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:26:20.1385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zoSS04C8pO3NrGRuuBDXMWeYphWS9nqRmyQRadMVtii1O5Pg0lyHEkg58khmuA/KLcYpoehLXH3cgtxr3mOPrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204020064
X-Proofpoint-ORIG-GUID: 5-_zXqlvsDWztkOnjK7qaDGeAN7Ioyfb
X-Proofpoint-GUID: 5-_zXqlvsDWztkOnjK7qaDGeAN7Ioyfb
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

