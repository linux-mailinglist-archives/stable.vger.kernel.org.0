Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09CC560DB2E
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbiJZGaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiJZGaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:30:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E791F9E8;
        Tue, 25 Oct 2022 23:30:00 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nEAZ023399;
        Wed, 26 Oct 2022 06:29:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=n6KQS4kuU1352yEvwe4iEu0M6Zlk8BcKBiK/xTkeCVo=;
 b=oA6pXROzSqthjra7fYHrE3OBm1lTWTyP1/5K4QN8gL5AJS5aCGPoWJ7g0wjzOjiCEN9R
 4x97y1vZFV7y7vSOT1bGwxoUfomTl4WNtXMAnk4BMyRdbiwSukIpC39+ato6KN+cCtOq
 7qNvAhZOURAiiIonrLJfIR7GKj/JpUZjSYRcyusoYVxSyLZmyVlIl+/mwJ4C28ttdvGi
 FBy3ZFNlhkI7uCS9NspfV2ibuVVhuDHCEV4hJEQNH9Qn53MdTsosHvGMsVnyRrX+yNWN
 NjRiFT8U5uzAP9iFtIfUBSchZRqIsyyO7FXKhXXOHmNfX8/J+LRQIfB9rJb/kbRVbAVD nQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc7a35npf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:55 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q2FAxs017123;
        Wed, 26 Oct 2022 06:29:54 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y5mwwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:29:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i16zJ96yP7gWiAyE+k3TEfhps2gigdfrIkP1SXdwC5HTTbNVz3jhZ4nz6BZ63qavn2aPQh/Ktfq8XZnMqd0QHwrw6PxC7t3bsoq+Z8Uzx0QF5g8RLdzaHOMHGkJ2M5v0ATCQqW0YQJ8/xXDlpoSP/0vBY/SX+oKGEeBK2wsefv6s4zeBgpbLO3RXivnhBCvjQAejwJy32udYId73zSjZoy2BcjBAAYmZ7EocxLYtg1Ym2gAZtgjehMwESckHoZVSGdu+G+QEXtlU5ezuQrwAfaIrj4/4i1k0c1zDm3ssqLCh2vNMYs85syebl6TqW/EY2y0YHHXYAtFUvnTtVZsOnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6KQS4kuU1352yEvwe4iEu0M6Zlk8BcKBiK/xTkeCVo=;
 b=PtxIaEbCpBN1bh9mJ5K378U/k9E9xJL8td3ma0sQX9wCvJ+xDDj9GDlfk71I/9GjlhSB6DWqfRcQCyrUpj1+k0Tbb8VPl8mK8xcGY/ZyepQIr1nXmRq+8aXA/okdCakel5lTlrGYGIRhuFpoEXqEABs3/bD4JUEIHv29zrd7Wo7Ht/o9zT9fWyjFCc70A2O4AnyL9gzQxLZwjZdsuB0Nrv1oyH00WJqmWqGEqisvr1AQR3XRJpeMPIJn04cidBcn2HJdDasldpcRsnVPtt5FbVSegtPGIT2srtM7xPDcAe12NoYLYo0ANt7b7jEfHlyf9aPbXtE41LdpljUW/xjH2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n6KQS4kuU1352yEvwe4iEu0M6Zlk8BcKBiK/xTkeCVo=;
 b=CTBSRS+nSz1lW0tXxWV32u0XUVbxACQibrfeUQECSwfHPO5iuJBXSWSk/99sb9kaPoAfqcwvm4TVcvXRX3K0uG6X0RPQ22Kc40lamCmJTOK+R19WB42hPK1YbeBoF+7HO0OKMPag/sXQsSz3QA5RJTdYKkwv8237TxuohZ1XfmQ=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB6151.namprd10.prod.outlook.com (2603:10b6:8:c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 06:29:51 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:29:51 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 10/26] xfs: remove the xfs_disk_dquot_t and xfs_dquot_t
Date:   Wed, 26 Oct 2022 11:58:27 +0530
Message-Id: <20221026062843.927600-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0129.jpnprd01.prod.outlook.com
 (2603:1096:404:2d::21) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: 4846c877-b233-4f96-f02b-08dab71b7ceb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rIQX9eQhxovPjYHYJC+dkihvEMMssTqQhP2InjJ7p8duxgzyULSJxJbLOdYDRbJJ4JcNDwMSC4pdPj3HNFNUABXJjSbgNo8drv7ZIyKX7EH5Z8+btoQudw6SVliimt59EAMDOJI23s6IDj5l1zUgZ8/iuU5uo/LqxpjiTqkdnEpZlddZGj/ZKqW6I28h02jasDJAOJb4gVyU9MVp5djyOoSYbPHp8wdG8TVVCfdvLkpkJ9k8uvLjcXFibr6n9ZvfFpREHhuaYUUAB45ZCIGxo23t0HzaLC3zO0wiGF202EtAtzHbtjURmrUUcX0IV6WYoFOugzv4G6muqNdgQZeigGKhOSLOw+DKVMXCHb6nV0NxszqXagnA1aU76SMc6s6X+aJFN0o935R8hGi0T+RacwH7cwF6hXDA6XtLz72PIxnKELAZUm4qmJYg4PFHyr5Z2dpUoK1cy0zXBkg7stFxeQnvI+AJv7gnowwMbJ/WqVZCBysliiclorW5VZWjQk1pCFICpfnNRS0vD0bQQ/wg3WzCduCrssdGOOJF7rOYS96MYfnSN0cb4LybFzkEWs2wk94leFbzaUkRzb/SDM6AX3zVZzs26qTiJHG0ad5uctdDp45e76Ih/j2P408WnGZV8pIAwCv37JfrUzKDpncuU7VdAhNGxcTjlAAuIn8ZzrlCkep0B82qKMfvi9vj9b3hxnMI8qicc4tLRfC+VrqcT1uv4XwH9zIFQ0fKMMpfdtVTsIsngyDrETnTo97Pnkwc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199015)(6486002)(6512007)(6666004)(6506007)(186003)(26005)(478600001)(2906002)(6916009)(1076003)(34290500002)(83380400001)(2616005)(66946007)(41300700001)(66476007)(4326008)(66556008)(8676002)(86362001)(316002)(30864003)(38100700002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?opEybWLBvjBNcqwivaYuI2DvWyu/uWEVmQtweyQqXA0i8l96ldCk23Aux7FB?=
 =?us-ascii?Q?qy2C+wHrMvFEzUSdJVgLCvavKp5ynfYo1QdajU7oMh1eMvnP8STWq0wngcEX?=
 =?us-ascii?Q?ilWEv62bit017x+1liUGLjCDDPz0/tGdnOEf1mAHGKyvGbcBKTJ/07F5CwdK?=
 =?us-ascii?Q?09/yI8X/HMPfSU5OFu9s6BgPbfA9ENQNRRIpsM4JcjPIXIBT8Y4t8QIplnya?=
 =?us-ascii?Q?qaEP7Fd5k/FvDOHQLwRKB/NkEaZh2Vas3+2Gxp5nFhMjgmBSG/FulqH6s7GP?=
 =?us-ascii?Q?MzVMw0sV+Bgxp3WCOw04yCWw3O9khXE7X3zYlsxQllTrbdqiIjJsPrNz7OtA?=
 =?us-ascii?Q?D0GU/adJs7K7PjgPcw+ZPCEX00fYjD59upvONIXsNBLllIs5SNDkLnWBdGAJ?=
 =?us-ascii?Q?lx3ZDYKdS/HzG+2fN/5vJNqYq3o0sMWUA6FD2Isx4iGSKBexjDbwlRNu+Z7k?=
 =?us-ascii?Q?yREGY1JdV6NIWKmoNUdMOGLoYX3utdLirhHwkGd7Rp3w/u5i8ZmLjV62UyKi?=
 =?us-ascii?Q?Em6G+/GzuebuQSPSBvnTb7/efvR4bsi8ovjZJ0OGOciFsrEnepJlhw7iWRWC?=
 =?us-ascii?Q?CWqUQlDZpffynNa5Qwtg0MZrYWn4Opc+dfBHAg0AAsf4qhFD3QD1qn+RoQsD?=
 =?us-ascii?Q?jBEax635OnJ+2wHN/Jv4cygjF/jIs63A64OtsDcI0/eniBEixm5tiR4r1xnJ?=
 =?us-ascii?Q?5kNB6QjYZNz1D+dGj32YNnxsCrRf8RN3LTA2Xn7SK6Tut+bqvJggb7SicTfe?=
 =?us-ascii?Q?2VzplLmWTnDLuS4QiY5y5eicPiymaEKB1HE7aSKJWgD5gCkXJme++3BfxNr8?=
 =?us-ascii?Q?L3fG031/LrZA49fF8W4w8/k+xfBfGLvCFt0Sm6akB8Lz9iLSpzXW/bVtLWGw?=
 =?us-ascii?Q?YPx+s4H/txWApJq/7q2aum+Qvbm3nK+8NWN5T2qrVAhcacA86jzK8cF1G/zZ?=
 =?us-ascii?Q?fuXotK1ZJbYEF4Tj9RoRwBqIlE2BqAgBo7mRNR1OjPf1lqef4+rxJ4ha8E3Y?=
 =?us-ascii?Q?53S0enLgx0t2KoeL0jN3rHMLSSq0vp4csk3VJkJy+jXdqORtbDOnkr0gPXdA?=
 =?us-ascii?Q?juLyCSyoWR6I974Vl7EwOwg1UQfSKttWkypRSbO8YqgOAPcUM7vkEYdC9MYq?=
 =?us-ascii?Q?JVWO2MDKu/ZKt+QGbimvOrSDWqzOWpYUdMHa1BxwJnVKxNxrXtaWSxO4cwe8?=
 =?us-ascii?Q?Cl9HlNAAoZx3fV7TjX7dBXZ7Ewr/OVA06+JHtfIrsggAEo+2oixU4LPaJlR/?=
 =?us-ascii?Q?aL9C14t1hv6h8Z6KcQq7R+9DyP1vy6xDf0LhwiviyekPwVm4dslrXbsWHb74?=
 =?us-ascii?Q?fZR0g2/mH+1bY+DJY5mO9agW7/avYr3XRTODcxqRXgxE11UCt9i839GiLa9A?=
 =?us-ascii?Q?zOmqKKhYxxzXmXeAgrR2cDGFwfbHNUWFNChks0nCLEqd0Px3aU55YKM51lJK?=
 =?us-ascii?Q?+0TQcVvNW4GxPMnXdFCiysXrsUztXCeuNlNvVJShfwq21JiMzQMsVM/QrFdu?=
 =?us-ascii?Q?QjtL1nCvbfuZ2lBLR5t896ymnKjP1805b8Y7u3ZTAzhIvaqwrPOExnsLdfK4?=
 =?us-ascii?Q?+ER/zxA0e7iucgsjDm/E0aUBkHPqcYikcIhCgVVRaXkO232YQPp/lWuUQRra?=
 =?us-ascii?Q?Gg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4846c877-b233-4f96-f02b-08dab71b7ceb
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:29:51.7776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oDLUiC180yonSIwTIt0NRE7J6iUiHsx9DhNTl+EXgO167Ko0gAuZmqx3MrdYR0NMY9Ca/Et8vLagU+qv+FO+Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6151
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210260036
X-Proofpoint-GUID: EKmrCp11M7LYd6sBWLJSBJUygOa7dSXe
X-Proofpoint-ORIG-GUID: EKmrCp11M7LYd6sBWLJSBJUygOa7dSXe
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Reichl <preichl@redhat.com>

commit aefe69a45d84901c702f87672ec1e93de1d03f73 upstream.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: fix some of the comments]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_dquot_buf.c  |  8 +--
 fs/xfs/libxfs/xfs_format.h     | 10 ++--
 fs/xfs/libxfs/xfs_trans_resv.c |  2 +-
 fs/xfs/xfs_dquot.c             | 18 +++----
 fs/xfs/xfs_dquot.h             | 98 +++++++++++++++++-----------------
 fs/xfs/xfs_log_recover.c       |  5 +-
 fs/xfs/xfs_qm.c                | 30 +++++------
 fs/xfs/xfs_qm_bhv.c            |  6 +--
 fs/xfs/xfs_trans_dquot.c       | 42 +++++++--------
 9 files changed, 111 insertions(+), 108 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
index e8bd688a4073..bedc1e752b60 100644
--- a/fs/xfs/libxfs/xfs_dquot_buf.c
+++ b/fs/xfs/libxfs/xfs_dquot_buf.c
@@ -35,10 +35,10 @@ xfs_calc_dquots_per_chunk(
 
 xfs_failaddr_t
 xfs_dquot_verify(
-	struct xfs_mount *mp,
-	xfs_disk_dquot_t *ddq,
-	xfs_dqid_t	 id,
-	uint		 type)	  /* used only during quotacheck */
+	struct xfs_mount	*mp,
+	struct xfs_disk_dquot	*ddq,
+	xfs_dqid_t		id,
+	uint			type)	/* used only during quotacheck */
 {
 	/*
 	 * We can encounter an uninitialized dquot buffer for 2 reasons:
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 28203b626f6a..1f24473121f0 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1144,11 +1144,11 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 
 /*
  * This is the main portion of the on-disk representation of quota
- * information for a user. This is the q_core of the xfs_dquot_t that
+ * information for a user. This is the q_core of the struct xfs_dquot that
  * is kept in kernel memory. We pad this with some more expansion room
  * to construct the on disk structure.
  */
-typedef struct	xfs_disk_dquot {
+struct xfs_disk_dquot {
 	__be16		d_magic;	/* dquot magic = XFS_DQUOT_MAGIC */
 	__u8		d_version;	/* dquot version */
 	__u8		d_flags;	/* XFS_DQ_USER/PROJ/GROUP */
@@ -1171,15 +1171,15 @@ typedef struct	xfs_disk_dquot {
 	__be32		d_rtbtimer;	/* similar to above; for RT disk blocks */
 	__be16		d_rtbwarns;	/* warnings issued wrt RT disk blocks */
 	__be16		d_pad;
-} xfs_disk_dquot_t;
+};
 
 /*
  * This is what goes on disk. This is separated from the xfs_disk_dquot because
  * carrying the unnecessary padding would be a waste of memory.
  */
 typedef struct xfs_dqblk {
-	xfs_disk_dquot_t  dd_diskdq;	/* portion that lives incore as well */
-	char		  dd_fill[4];	/* filling for posterity */
+	struct xfs_disk_dquot	dd_diskdq; /* portion living incore as well */
+	char			dd_fill[4];/* filling for posterity */
 
 	/*
 	 * These two are only present on filesystems with the CRC bits set.
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index b3584cd2cc16..f7e87b90c7e5 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -776,7 +776,7 @@ xfs_calc_clear_agi_bucket_reservation(
 
 /*
  * Adjusting quota limits.
- *    the xfs_disk_dquot_t: sizeof(struct xfs_disk_dquot)
+ *    the disk quota buffer: sizeof(struct xfs_disk_dquot)
  */
 STATIC uint
 xfs_calc_qm_setqlim_reservation(void)
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index aa5084180270..193a7d3353f4 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -48,7 +48,7 @@ static struct lock_class_key xfs_dquot_project_class;
  */
 void
 xfs_qm_dqdestroy(
-	xfs_dquot_t	*dqp)
+	struct xfs_dquot	*dqp)
 {
 	ASSERT(list_empty(&dqp->q_lru));
 
@@ -113,8 +113,8 @@ xfs_qm_adjust_dqlimits(
  */
 void
 xfs_qm_adjust_dqtimers(
-	xfs_mount_t		*mp,
-	xfs_disk_dquot_t	*d)
+	struct xfs_mount	*mp,
+	struct xfs_disk_dquot	*d)
 {
 	ASSERT(d->d_id);
 
@@ -497,7 +497,7 @@ xfs_dquot_from_disk(
 	struct xfs_disk_dquot	*ddqp = bp->b_addr + dqp->q_bufoffset;
 
 	/* copy everything from disk dquot to the incore dquot */
-	memcpy(&dqp->q_core, ddqp, sizeof(xfs_disk_dquot_t));
+	memcpy(&dqp->q_core, ddqp, sizeof(struct xfs_disk_dquot));
 
 	/*
 	 * Reservation counters are defined as reservation plus current usage
@@ -989,7 +989,7 @@ xfs_qm_dqput(
  */
 void
 xfs_qm_dqrele(
-	xfs_dquot_t	*dqp)
+	struct xfs_dquot	*dqp)
 {
 	if (!dqp)
 		return;
@@ -1019,7 +1019,7 @@ xfs_qm_dqflush_done(
 	struct xfs_log_item	*lip)
 {
 	xfs_dq_logitem_t	*qip = (struct xfs_dq_logitem *)lip;
-	xfs_dquot_t		*dqp = qip->qli_dquot;
+	struct xfs_dquot	*dqp = qip->qli_dquot;
 	struct xfs_ail		*ailp = lip->li_ailp;
 
 	/*
@@ -1129,7 +1129,7 @@ xfs_qm_dqflush(
 	}
 
 	/* This is the only portion of data that needs to persist */
-	memcpy(ddqp, &dqp->q_core, sizeof(xfs_disk_dquot_t));
+	memcpy(ddqp, &dqp->q_core, sizeof(struct xfs_disk_dquot));
 
 	/*
 	 * Clear the dirty field and remember the flush lsn for later use.
@@ -1187,8 +1187,8 @@ xfs_qm_dqflush(
  */
 void
 xfs_dqlock2(
-	xfs_dquot_t	*d1,
-	xfs_dquot_t	*d2)
+	struct xfs_dquot	*d1,
+	struct xfs_dquot	*d2)
 {
 	if (d1 && d2) {
 		ASSERT(d1 != d2);
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 4fe85709d55d..831e4270cf65 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -30,33 +30,36 @@ enum {
 /*
  * The incore dquot structure
  */
-typedef struct xfs_dquot {
-	uint		 dq_flags;	/* various flags (XFS_DQ_*) */
-	struct list_head q_lru;		/* global free list of dquots */
-	struct xfs_mount*q_mount;	/* filesystem this relates to */
-	uint		 q_nrefs;	/* # active refs from inodes */
-	xfs_daddr_t	 q_blkno;	/* blkno of dquot buffer */
-	int		 q_bufoffset;	/* off of dq in buffer (# dquots) */
-	xfs_fileoff_t	 q_fileoffset;	/* offset in quotas file */
-
-	xfs_disk_dquot_t q_core;	/* actual usage & quotas */
-	xfs_dq_logitem_t q_logitem;	/* dquot log item */
-	xfs_qcnt_t	 q_res_bcount;	/* total regular nblks used+reserved */
-	xfs_qcnt_t	 q_res_icount;	/* total inos allocd+reserved */
-	xfs_qcnt_t	 q_res_rtbcount;/* total realtime blks used+reserved */
-	xfs_qcnt_t	 q_prealloc_lo_wmark;/* prealloc throttle wmark */
-	xfs_qcnt_t	 q_prealloc_hi_wmark;/* prealloc disabled wmark */
-	int64_t		 q_low_space[XFS_QLOWSP_MAX];
-	struct mutex	 q_qlock;	/* quota lock */
-	struct completion q_flush;	/* flush completion queue */
-	atomic_t          q_pincount;	/* dquot pin count */
-	wait_queue_head_t q_pinwait;	/* dquot pinning wait queue */
-} xfs_dquot_t;
+struct xfs_dquot {
+	uint			dq_flags;
+	struct list_head	q_lru;
+	struct xfs_mount	*q_mount;
+	uint			q_nrefs;
+	xfs_daddr_t		q_blkno;
+	int			q_bufoffset;
+	xfs_fileoff_t		q_fileoffset;
+
+	struct xfs_disk_dquot	q_core;
+	xfs_dq_logitem_t	q_logitem;
+	/* total regular nblks used+reserved */
+	xfs_qcnt_t		q_res_bcount;
+	/* total inos allocd+reserved */
+	xfs_qcnt_t		q_res_icount;
+	/* total realtime blks used+reserved */
+	xfs_qcnt_t		q_res_rtbcount;
+	xfs_qcnt_t		q_prealloc_lo_wmark;
+	xfs_qcnt_t		q_prealloc_hi_wmark;
+	int64_t			q_low_space[XFS_QLOWSP_MAX];
+	struct mutex		q_qlock;
+	struct completion	q_flush;
+	atomic_t		q_pincount;
+	struct wait_queue_head	q_pinwait;
+};
 
 /*
  * Lock hierarchy for q_qlock:
  *	XFS_QLOCK_NORMAL is the implicit default,
- * 	XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
+ *	XFS_QLOCK_NESTED is the dquot with the higher id in xfs_dqlock2
  */
 enum {
 	XFS_QLOCK_NORMAL = 0,
@@ -64,21 +67,21 @@ enum {
 };
 
 /*
- * Manage the q_flush completion queue embedded in the dquot.  This completion
+ * Manage the q_flush completion queue embedded in the dquot. This completion
  * queue synchronizes processes attempting to flush the in-core dquot back to
  * disk.
  */
-static inline void xfs_dqflock(xfs_dquot_t *dqp)
+static inline void xfs_dqflock(struct xfs_dquot *dqp)
 {
 	wait_for_completion(&dqp->q_flush);
 }
 
-static inline bool xfs_dqflock_nowait(xfs_dquot_t *dqp)
+static inline bool xfs_dqflock_nowait(struct xfs_dquot *dqp)
 {
 	return try_wait_for_completion(&dqp->q_flush);
 }
 
-static inline void xfs_dqfunlock(xfs_dquot_t *dqp)
+static inline void xfs_dqfunlock(struct xfs_dquot *dqp)
 {
 	complete(&dqp->q_flush);
 }
@@ -112,7 +115,7 @@ static inline int xfs_this_quota_on(struct xfs_mount *mp, int type)
 	}
 }
 
-static inline xfs_dquot_t *xfs_inode_dquot(struct xfs_inode *ip, int type)
+static inline struct xfs_dquot *xfs_inode_dquot(struct xfs_inode *ip, int type)
 {
 	switch (type & XFS_DQ_ALLTYPES) {
 	case XFS_DQ_USER:
@@ -147,31 +150,30 @@ static inline bool xfs_dquot_lowsp(struct xfs_dquot *dqp)
 #define XFS_QM_ISPDQ(dqp)	((dqp)->dq_flags & XFS_DQ_PROJ)
 #define XFS_QM_ISGDQ(dqp)	((dqp)->dq_flags & XFS_DQ_GROUP)
 
-extern void		xfs_qm_dqdestroy(xfs_dquot_t *);
-extern int		xfs_qm_dqflush(struct xfs_dquot *, struct xfs_buf **);
-extern void		xfs_qm_dqunpin_wait(xfs_dquot_t *);
-extern void		xfs_qm_adjust_dqtimers(xfs_mount_t *,
-					xfs_disk_dquot_t *);
-extern void		xfs_qm_adjust_dqlimits(struct xfs_mount *,
-					       struct xfs_dquot *);
-extern xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip,
-					uint type);
-extern int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
+void		xfs_qm_dqdestroy(struct xfs_dquot *dqp);
+int		xfs_qm_dqflush(struct xfs_dquot *dqp, struct xfs_buf **bpp);
+void		xfs_qm_dqunpin_wait(struct xfs_dquot *dqp);
+void		xfs_qm_adjust_dqtimers(struct xfs_mount *mp,
+						struct xfs_disk_dquot *d);
+void		xfs_qm_adjust_dqlimits(struct xfs_mount *mp,
+						struct xfs_dquot *d);
+xfs_dqid_t	xfs_qm_id_for_quotatype(struct xfs_inode *ip, uint type);
+int		xfs_qm_dqget(struct xfs_mount *mp, xfs_dqid_t id,
 					uint type, bool can_alloc,
 					struct xfs_dquot **dqpp);
-extern int		xfs_qm_dqget_inode(struct xfs_inode *ip, uint type,
-					bool can_alloc,
-					struct xfs_dquot **dqpp);
-extern int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
+int		xfs_qm_dqget_inode(struct xfs_inode *ip, uint type,
+						bool can_alloc,
+						struct xfs_dquot **dqpp);
+int		xfs_qm_dqget_next(struct xfs_mount *mp, xfs_dqid_t id,
 					uint type, struct xfs_dquot **dqpp);
-extern int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
-					xfs_dqid_t id, uint type,
-					struct xfs_dquot **dqpp);
-extern void		xfs_qm_dqput(xfs_dquot_t *);
+int		xfs_qm_dqget_uncached(struct xfs_mount *mp,
+						xfs_dqid_t id, uint type,
+						struct xfs_dquot **dqpp);
+void		xfs_qm_dqput(struct xfs_dquot *dqp);
 
-extern void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
+void		xfs_dqlock2(struct xfs_dquot *, struct xfs_dquot *);
 
-extern void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
+void		xfs_dquot_set_prealloc_limits(struct xfs_dquot *);
 
 static inline struct xfs_dquot *xfs_qm_dqhold(struct xfs_dquot *dqp)
 {
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 248101876e1e..46b1e255f55f 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2577,6 +2577,7 @@ xlog_recover_do_reg_buffer(
 	int			bit;
 	int			nbits;
 	xfs_failaddr_t		fa;
+	const size_t		size_disk_dquot = sizeof(struct xfs_disk_dquot);
 
 	trace_xfs_log_recover_buf_reg_buf(mp->m_log, buf_f);
 
@@ -2619,7 +2620,7 @@ xlog_recover_do_reg_buffer(
 					"XFS: NULL dquot in %s.", __func__);
 				goto next;
 			}
-			if (item->ri_buf[i].i_len < sizeof(xfs_disk_dquot_t)) {
+			if (item->ri_buf[i].i_len < size_disk_dquot) {
 				xfs_alert(mp,
 					"XFS: dquot too small (%d) in %s.",
 					item->ri_buf[i].i_len, __func__);
@@ -3250,7 +3251,7 @@ xlog_recover_dquot_pass2(
 		xfs_alert(log->l_mp, "NULL dquot in %s.", __func__);
 		return -EFSCORRUPTED;
 	}
-	if (item->ri_buf[1].i_len < sizeof(xfs_disk_dquot_t)) {
+	if (item->ri_buf[1].i_len < sizeof(struct xfs_disk_dquot)) {
 		xfs_alert(log->l_mp, "dquot too small (%d) in %s.",
 			item->ri_buf[1].i_len, __func__);
 		return -EFSCORRUPTED;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 66ea8e4fca86..035930a4f0dd 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -244,14 +244,14 @@ xfs_qm_unmount_quotas(
 
 STATIC int
 xfs_qm_dqattach_one(
-	xfs_inode_t	*ip,
-	xfs_dqid_t	id,
-	uint		type,
-	bool		doalloc,
-	xfs_dquot_t	**IO_idqpp)
+	struct xfs_inode	*ip,
+	xfs_dqid_t		id,
+	uint			type,
+	bool			doalloc,
+	struct xfs_dquot	**IO_idqpp)
 {
-	xfs_dquot_t	*dqp;
-	int		error;
+	struct xfs_dquot	*dqp;
+	int			error;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	error = 0;
@@ -544,8 +544,8 @@ xfs_qm_set_defquota(
 	uint		type,
 	xfs_quotainfo_t	*qinf)
 {
-	xfs_dquot_t		*dqp;
-	struct xfs_def_quota    *defq;
+	struct xfs_dquot	*dqp;
+	struct xfs_def_quota	*defq;
 	struct xfs_disk_dquot	*ddqp;
 	int			error;
 
@@ -1746,14 +1746,14 @@ xfs_qm_vop_dqalloc(
  * Actually transfer ownership, and do dquot modifications.
  * These were already reserved.
  */
-xfs_dquot_t *
+struct xfs_dquot *
 xfs_qm_vop_chown(
-	xfs_trans_t	*tp,
-	xfs_inode_t	*ip,
-	xfs_dquot_t	**IO_olddq,
-	xfs_dquot_t	*newdq)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_dquot	**IO_olddq,
+	struct xfs_dquot	*newdq)
 {
-	xfs_dquot_t	*prevdq;
+	struct xfs_dquot	*prevdq;
 	uint		bfield = XFS_IS_REALTIME_INODE(ip) ?
 				 XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
 
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 5d72e88598b4..b784a3751fe2 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -54,11 +54,11 @@ xfs_fill_statvfs_from_dquot(
  */
 void
 xfs_qm_statvfs(
-	xfs_inode_t		*ip,
+	struct xfs_inode	*ip,
 	struct kstatfs		*statp)
 {
-	xfs_mount_t		*mp = ip->i_mount;
-	xfs_dquot_t		*dqp;
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_dquot	*dqp;
 
 	if (!xfs_qm_dqget(mp, xfs_get_projid(ip), XFS_DQ_PROJ, false, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, dqp);
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 904780dd74aa..b6c8ee0dd39f 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -25,8 +25,8 @@ STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
  */
 void
 xfs_trans_dqjoin(
-	xfs_trans_t	*tp,
-	xfs_dquot_t	*dqp)
+	struct xfs_trans	*tp,
+	struct xfs_dquot	*dqp)
 {
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 	ASSERT(dqp->q_logitem.qli_dquot == dqp);
@@ -49,8 +49,8 @@ xfs_trans_dqjoin(
  */
 void
 xfs_trans_log_dquot(
-	xfs_trans_t	*tp,
-	xfs_dquot_t	*dqp)
+	struct xfs_trans	*tp,
+	struct xfs_dquot	*dqp)
 {
 	ASSERT(XFS_DQ_IS_LOCKED(dqp));
 
@@ -486,12 +486,12 @@ xfs_trans_apply_dquot_deltas(
  */
 void
 xfs_trans_unreserve_and_mod_dquots(
-	xfs_trans_t		*tp)
+	struct xfs_trans	*tp)
 {
 	int			i, j;
-	xfs_dquot_t		*dqp;
+	struct xfs_dquot	*dqp;
 	struct xfs_dqtrx	*qtrx, *qa;
-	bool                    locked;
+	bool			locked;
 
 	if (!tp->t_dqinfo || !(tp->t_flags & XFS_TRANS_DQ_DIRTY))
 		return;
@@ -571,21 +571,21 @@ xfs_quota_warn(
  */
 STATIC int
 xfs_trans_dqresv(
-	xfs_trans_t	*tp,
-	xfs_mount_t	*mp,
-	xfs_dquot_t	*dqp,
-	int64_t		nblks,
-	long		ninos,
-	uint		flags)
+	struct xfs_trans	*tp,
+	struct xfs_mount	*mp,
+	struct xfs_dquot	*dqp,
+	int64_t			nblks,
+	long			ninos,
+	uint			flags)
 {
-	xfs_qcnt_t	hardlimit;
-	xfs_qcnt_t	softlimit;
-	time_t		timer;
-	xfs_qwarncnt_t	warns;
-	xfs_qwarncnt_t	warnlimit;
-	xfs_qcnt_t	total_count;
-	xfs_qcnt_t	*resbcountp;
-	xfs_quotainfo_t	*q = mp->m_quotainfo;
+	xfs_qcnt_t		hardlimit;
+	xfs_qcnt_t		softlimit;
+	time_t			timer;
+	xfs_qwarncnt_t		warns;
+	xfs_qwarncnt_t		warnlimit;
+	xfs_qcnt_t		total_count;
+	xfs_qcnt_t		*resbcountp;
+	xfs_quotainfo_t		*q = mp->m_quotainfo;
 	struct xfs_def_quota	*defq;
 
 
-- 
2.35.1

