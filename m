Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5E560DB3C
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbiJZGat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiJZGas (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:30:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28AFF6EF0A;
        Tue, 25 Oct 2022 23:30:46 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nFTo013699;
        Wed, 26 Oct 2022 06:30:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=NjxfT+4hP3AkeMAgzD48cuao+Xuwe3WArOID6uTy21E=;
 b=PRh4uycdia/X5YjEhQFdufRczHDVXJhK7Mnz8GxOQaKl/QWFmmzZEmeiIpA8beURVFlu
 5FPCHLjJRasEI1fu7OZgV6IsS+Dipq9V1x1YG2cKi2kejTf2jqNcffZHApNZVGfByD2i
 y8Aq2GLUTmczG9p0lCJilMskgzfq7MNNKQiFu0bKG3eQTjX08mZ5+OExpF5MKUD45/qJ
 qaAxxKrEAo1fG8SVh9Tiy4Rs/ECi6HJQH6nwXsgLZT2EgpUQKdCbmp6hsy01Bh2hiNLu
 DxrVNopFOqpu4+yoxgQiRYp/S478yTRN0ljToAsHklJmIleEu6KLlf2H5KavlBSe6lCm 7A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc84t5hkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q34gvI010994;
        Wed, 26 Oct 2022 06:30:40 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y5d9ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HE9dsZju4BtzTqhbvNZ8G0LKnPI9Nul2XMvuDpG57w3aGxvVAU4nUgu+rk8zDkiX6/fP6qHIPgPHLlyRyNK8k1CtL9F7I/EGyXjAJHgV6oqS8RJUKbPlRXVzohFgBCG5AjFttjutRTzXZOxeDeoOdqDYqvc9A2bgCtm4Sy06GvZKf2idXbUdkh5A+PGzEAw1HZ2uHR9OWOxWpNmOK+FrrssjCm1MID3/pTkJ4uWHJIXQGx4E6F8UWow8W81maN7Z6VIsHhwHPvrtPWr2hxy0QCaJrzRtlN72gCZWUkIp3lSc1uadV4Cm8RUmkpkgzgLDqEC2czVS12TADwHicyfqRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NjxfT+4hP3AkeMAgzD48cuao+Xuwe3WArOID6uTy21E=;
 b=OI1OIbaiFaXGY32aUd+n8AqbVo3UYfbQ4/Hy5IhBDy/jnn90RbHchtiwxG9Msc5sNhGMOXCaqeEbOj8lbqiG//ZfXEsinXv9yxGs09MNEWDCos0gRkVzP3xgNqnvkAp9qwYGXg7dEtb4ySRHXZ7b7n4CCGGaE9c5uMGiAlOg/AuFmlvBHc2At6sB20Q9VmsGbZ6QeXAJ0SkDHYVge4pOffodVRuNzK9SVe6jm8GbN0vngQY6WzO1LFznMfq01PoZYWu1mCuR34j5mlrWRsRkEEGst4ZiosQB3VsIcrTRzS0rfuYtMOeOLz7VRpCUjqEtuhOOF/UY3rLXvcUixnhL+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjxfT+4hP3AkeMAgzD48cuao+Xuwe3WArOID6uTy21E=;
 b=qifRlXC4y1085zS/Q5v6uILLZUUa6XeS/rU6udZFPO0WpoeHXqCJqgRn5zL96TQWC67Mubxw5uGdmIDL9JPvokVbEEBLsTbrBRUJYApfxQs0+/3tFuXb08B6KbBqycHY8TJGsxUzH3TWroX4vo224glWHQKEn6TmaAQo4bmqkS8=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4646.namprd10.prod.outlook.com (2603:10b6:510:38::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Wed, 26 Oct
 2022 06:30:38 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:30:37 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 17/26] xfs: Lower CIL flush limit for large logs
Date:   Wed, 26 Oct 2022 11:58:34 +0530
Message-Id: <20221026062843.927600-18-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0079.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4646:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d98f35c-30a2-409f-6fbd-08dab71b9869
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dGmWTg99axCuwPZBNH9c2r+pOqwBHmQvexPm4Mv/sN47l2s0pZCQpN0rPIlG6fnQGp1UYBQUNHpaXc3xWvYQ3223YsrGGKoOrMn8N1hvcM/QdbwLJbL19hg50EAnV3V0E9LE0tYPFXT5fc27pn13ZgwweCYMg8TQLMW0mV//ifcol5+p7Vehj9sfJa+XCWemWtPxjs6RBTdUh06CGjaeKSuokL2wmZZ5V0SJFOKN8pmy9GowoFuneYrMzWXVbm0zY7SskyOyC7RqyoQn9BRruZVATo3g3/3OUvdHoSaX4DFT8bJa9udEfrZKt1UL1trNPyx+mURjC+Vo4RjBJWNei8ie+7Egn3GlfS1KEngysdg8U2odzRRj0omWUfoinYZ2gBHZEvqyAtR3nvsSOz3tUQsJfFD7gr9zhb9a4+Xj/oqFtZA2fR6fPcIaDT0n9iamOSFkNYaV3+Q04Wjex7lcSHPTjgTcmCEogDxzUgoAue8IBo2GtHkqrx3NNyr6pyZ+nGbA67jnYNjiHdr8oABlq5f6uqkYPL5wB2JrgBpkGSOc0HBcRX68/9vtBykN+pzyjD4CGy18EREHNPSkKxwROj1HiqLot7ny/lGKP/Z2RhfxmTly8N6Px094LJxw1FRogPpP/DK840TLjAtk1vGwo4/joOWY4Z12bsZ8HZ6oIMzjNg82FKtiISIkcqu+romQf0++jC2ce/mC81OTyiy41A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199015)(478600001)(38100700002)(83380400001)(6486002)(66556008)(6916009)(1076003)(6666004)(8676002)(36756003)(4326008)(66476007)(186003)(6506007)(8936002)(26005)(66946007)(41300700001)(316002)(2906002)(86362001)(6512007)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g3QgK+BEdmbwWhAg0x4KPpFvhNzuw7y5NHL/vBAjpZ4UJcmAC0v9VaKGCxMi?=
 =?us-ascii?Q?iRsXQm7NrYaGqILk4KDqrEz7MuPNYYpD/iQn+z42Q2CaWYpknE1lYuevPzT5?=
 =?us-ascii?Q?1Bz6aG96OumvQ6wq/eraHhDXycAJf1y+cY1c2VBtwsSDyi41BkJS3JsjT86U?=
 =?us-ascii?Q?Jtp5yLVJmsi03uzODCwzEIX9FWsCvZVB7c5qvzhWliWU+s+V5u/Xvpp5Eykp?=
 =?us-ascii?Q?7LIeuMIMahSOPDY/4NOP3qJS7HHEuYuv6z44En/nCkoDq862CSV6GZSWwWLK?=
 =?us-ascii?Q?o2VliEnQRIaBlg2brcIV1UH+gzxNeAslQyJzKjknGVwwMhQqqwyaewzoHOya?=
 =?us-ascii?Q?/ojHPJy1t5H9C6eQhgEjZNaKdxoebyX6dNFIQpgZ67ceNOAeZDU3yjqKwIG3?=
 =?us-ascii?Q?0u4HOe53z9lbsO2gd04Jcg8Iem1GQ+r8pIgsqoWjMazlQko86VNTB/RqdcFI?=
 =?us-ascii?Q?mC62kiy6QfZNfqwmXhZFCvwNNFum8hm/p38AcLqtDy42WbpeheaMC6yYp9Vq?=
 =?us-ascii?Q?UINVHkqTHSFP+9f3xfL1xCHjy7YSLChQdRu58ZqBe/CjiRkfB/4VJ2XLkka9?=
 =?us-ascii?Q?lPY1/KCakwzF+6TWZ5/htuUaUUXuzJfnx7mgcNrucpsq+WnKaFNzUJH0lcCT?=
 =?us-ascii?Q?h5CBrID4Bkaa9sm9JtU0WKMMIzMkJoYh+SzR9LBk0bASQ9QTkWDz6lqhXvmo?=
 =?us-ascii?Q?U96m5XRV/cRKYdvbs3v5UoG5G6EFIEKD/1WbRd4yPZLhhUXkyxZYdXNbnu/n?=
 =?us-ascii?Q?9oDqMv7ftAhsbnD62y+rMgcGKOA7XmbSv9svC93n8rdCZqimzGHF/GGr73H7?=
 =?us-ascii?Q?OSknzCyCNjSrZSD3AoNWC545ouHy+Q+4QB94vnFa2kwVPOQlValGWv3S0E2K?=
 =?us-ascii?Q?WRi4FcB65mgIGCjW7Zdl2m/iqSEirx4eaRT70dV50hu+D3/OPWiL4mcp161t?=
 =?us-ascii?Q?FwlXrU1zb+VSNvH5p24bbw7O4yzc+LTr8J6mwnwdlxekymEwRrZdtU6djQEi?=
 =?us-ascii?Q?T8GOiNspiiOI0Gmjgln2xznvs5D4cSW5VTax/odoFa3PypXxO4qiToomRLWW?=
 =?us-ascii?Q?cpVkefPKXD8vbi6bEppqejlNf1O/EpKFhCAFKrZntU8ADRlo6kfBtyYENnbW?=
 =?us-ascii?Q?dmkHTVjjG3gGD+sXzqUq0lW9gNHA1ld5IQpRtL1pxcgUnKb14lrXl7//NgKa?=
 =?us-ascii?Q?jBtek6LuPLoZjHW4u2VsjbWb3zHfH9jbxNvbRHBA5to4x5VcyXJaofwRAYHx?=
 =?us-ascii?Q?02c4DQlBPfNSfYoTqVY4PMUqdOXGnZwUloX39un6SyHFZcNf2YR0K9Kosqor?=
 =?us-ascii?Q?5L3/NBr9QO4nm2E3hkullqRwOohhvdqsodDyJ+UL0JKbWpwTdluOV6SiharF?=
 =?us-ascii?Q?uzmPSt1ifHTikU/fVoy/zYhbGO6AE9GJEe8KTMBGGmujSJWj9NdifkA1kCjl?=
 =?us-ascii?Q?SQV+NXvP12v4LpaSYFS7Hl0CKK5i5EzjyBZHUKd0PnVKB3RdtbDkhicUyzod?=
 =?us-ascii?Q?RTTNSqVTaxj4vpScd70B5O7wJbCecIWIrOhLdjkmUIxKk2oFkRAP8+d7rVCD?=
 =?us-ascii?Q?Z7CysB86/qZuRFEt9MuQm4DhxF7Q46/uwXfOWhGlJhzVDAbcqMSTn5PpV6EA?=
 =?us-ascii?Q?uQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d98f35c-30a2-409f-6fbd-08dab71b9869
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:30:37.7736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hFEZXkRpjMkLmgnZYM/BHdw2nkwaKL3lxWH/iLjniyv6E8H6cm6Rw4X4Jl/kZcqztaYbiKjPctlOH7XI5tDEbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4646
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=995 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-ORIG-GUID: 5fdl-RRbgHI_0IhMTfjUVclafCDoVg-K
X-Proofpoint-GUID: 5fdl-RRbgHI_0IhMTfjUVclafCDoVg-K
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 108a42358a05312b2128533c6462a3fdeb410bdf upstream.

The current CIL size aggregation limit is 1/8th the log size. This
means for large logs we might be aggregating at least 250MB of dirty objects
in memory before the CIL is flushed to the journal. With CIL shadow
buffers sitting around, this means the CIL is often consuming >500MB
of temporary memory that is all allocated under GFP_NOFS conditions.

Flushing the CIL can take some time to do if there is other IO
ongoing, and can introduce substantial log force latency by itself.
It also pins the memory until the objects are in the AIL and can be
written back and reclaimed by shrinkers. Hence this threshold also
tends to determine the minimum amount of memory XFS can operate in
under heavy modification without triggering the OOM killer.

Modify the CIL space limit to prevent such huge amounts of pinned
metadata from aggregating. We can have 2MB of log IO in flight at
once, so limit aggregation to 16x this size. This threshold was
chosen as it little impact on performance (on 16-way fsmark) or log
traffic but pins a lot less memory on large logs especially under
heavy memory pressure.  An aggregation limit of 8x had 5-10%
performance degradation and a 50% increase in log throughput for
the same workload, so clearly that was too small for highly
concurrent workloads on large logs.

This was found via trace analysis of AIL behaviour. e.g. insertion
from a single CIL flush:

xfs_ail_insert: old lsn 0/0 new lsn 1/3033090 type XFS_LI_INODE flags IN_AIL

$ grep xfs_ail_insert /mnt/scratch/s.t |grep "new lsn 1/3033090" |wc -l
1721823
$

So there were 1.7 million objects inserted into the AIL from this
CIL checkpoint, the first at 2323.392108, the last at 2325.667566 which
was the end of the trace (i.e. it hadn't finished). Clearly a major
problem.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_priv.h | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b880c23cb6e4..a3cc8a9a16d9 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -323,13 +323,30 @@ struct xfs_cil {
  * tries to keep 25% of the log free, so we need to keep below that limit or we
  * risk running out of free log space to start any new transactions.
  *
- * In order to keep background CIL push efficient, we will set a lower
- * threshold at which background pushing is attempted without blocking current
- * transaction commits.  A separate, higher bound defines when CIL pushes are
- * enforced to ensure we stay within our maximum checkpoint size bounds.
- * threshold, yet give us plenty of space for aggregation on large logs.
+ * In order to keep background CIL push efficient, we only need to ensure the
+ * CIL is large enough to maintain sufficient in-memory relogging to avoid
+ * repeated physical writes of frequently modified metadata. If we allow the CIL
+ * to grow to a substantial fraction of the log, then we may be pinning hundreds
+ * of megabytes of metadata in memory until the CIL flushes. This can cause
+ * issues when we are running low on memory - pinned memory cannot be reclaimed,
+ * and the CIL consumes a lot of memory. Hence we need to set an upper physical
+ * size limit for the CIL that limits the maximum amount of memory pinned by the
+ * CIL but does not limit performance by reducing relogging efficiency
+ * significantly.
+ *
+ * As such, the CIL push threshold ends up being the smaller of two thresholds:
+ * - a threshold large enough that it allows CIL to be pushed and progress to be
+ *   made without excessive blocking of incoming transaction commits. This is
+ *   defined to be 12.5% of the log space - half the 25% push threshold of the
+ *   AIL.
+ * - small enough that it doesn't pin excessive amounts of memory but maintains
+ *   close to peak relogging efficiency. This is defined to be 16x the iclog
+ *   buffer window (32MB) as measurements have shown this to be roughly the
+ *   point of diminishing performance increases under highly concurrent
+ *   modification workloads.
  */
-#define XLOG_CIL_SPACE_LIMIT(log)	(log->l_logsize >> 3)
+#define XLOG_CIL_SPACE_LIMIT(log)	\
+	min_t(int, (log)->l_logsize >> 3, BBTOB(XLOG_TOTAL_REC_SHIFT(log)) << 4)
 
 /*
  * ticket grant locks, queues and accounting have their own cachlines
-- 
2.35.1

