Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB145BF441
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiIUDYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiIUDYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:24:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A1F2653;
        Tue, 20 Sep 2022 20:24:34 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KLO9Zn006566;
        Wed, 21 Sep 2022 03:24:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=/CgWhIi+2MeQMDT4TS0Lgy0LTio/HtpoWNSS9H9QlZM=;
 b=O0xeyOh5efv8eOI9EM6IDVkXp2B4UinJFDiugl8NHGArgd8oi3onu00Dy/a9Z2EJTVOZ
 D1eHkpfxbewdZPOpB3t9m8y3suTUL/GYZrKqQLBjpIHiaCpc8RcOx/hlIPJFGtzrij+L
 JT6lhihP6wGJPMBNzlDUbs8PLXV7GgaUM2/AyrhEyqjkRmW9NmX9a9Fxg7yolEXnkCx7
 CB+KQJuIB4EeLCnFrOC5M2/vXMp3w+AKVEw2sathHZ0IQJgjJvrwbKcvscSrFAcpqUyI
 22/vw+c6IuVLDInt+lKqGlJl+KvRd5WZxgWapuigf01ohzxSZAQOeP1NTLqMXdLO7jpW YQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn69ks0vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L1rWA9022876;
        Wed, 21 Sep 2022 03:24:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39r6tax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDSCHr0iCswu0TPnatA0L9kHzFIcS0SyYxSd7ntGRpKpi+JJIkRGVXPDE0eq4eUR4gHMNMWNv/zOT87IGb6HLe9v8Ujr1zQ/GD+dgeZoIOluNv5rmH0UU6NhEVFqKdAJBmoh69CTjJXxn9HE4PUK6m//SUwSfqIgizO7or5++s5UwupN4dy1YxMpDHsEyh1cJ+yq6jGlsIK3+hIyWcIwBrW7ziobysi+jAAFhV7n5VWJ8GxWmzG6Np/9GiQWA5KiWmqAkU2Awjc646rzHw5K7+cXeyrkOrG6RoAdkKcEtkMZK7ojnONBTzfejY2snEgtQo2QOql9J9IkZHKmpUc0oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/CgWhIi+2MeQMDT4TS0Lgy0LTio/HtpoWNSS9H9QlZM=;
 b=G+vE2p2c4yAMg57xcxUHbLA+eLx6LLrSf7Ng3MgBrVQj7SuXEEodXkv61or3qEJa5uSfg6YCbqvOfRIJUkSfQTNGksfyrITjbm+4kukje/mDqYSKb7GzYvmdGBWqQuKCEk9jwu8dFgoSIjl+6fQfz48s4iVRRDH5BqUileEbUeHcdBKylMDJjXmoX+NjcFjp2a3tx/hrjAlKojoAx8dY6ouMePvDpriZ0KnNPyMa76RBBNqctzNASRNsMzxyGOE3s8tLFO5WFdpnkEKfKMV09M2OzwE4hPjKv1dwDPNlaWbcQHzXaW/Kr8oqN8yyVgCJWzzTVwcv5oCZQl1U05kAxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CgWhIi+2MeQMDT4TS0Lgy0LTio/HtpoWNSS9H9QlZM=;
 b=xFu48dfLUOz6UGC5WvMDRYB3DvxlllGuNRdpnz8+ZSTStRF+NcsTSm9iulRcBDiRPt1b0h0Dp4uaY5+4xelaV4n0s1sH4VTx9TNsC2t60cc+Ys7kAxfdvBTTH/cUF1pE+19YXLWuE2YX8v9SG55E39lu8AsOLpgzwJ8kWHl022Y=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 03:24:27 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:24:27 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 04/17] xfs: slightly tweak an assert in xfs_fs_map_blocks
Date:   Wed, 21 Sep 2022 08:53:39 +0530
Message-Id: <20220921032352.307699-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::19)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB5579:EE_
X-MS-Office365-Filtering-Correlation-Id: b361f4dc-d828-4885-eb24-08da9b80ca28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qDZ5a7r6Kl6KuPYZWi+RoCWqsoeYXdhonPapocVdtf171ri5o0DW0a4yZHe7EjZg7JCP3X77ROG8E92gKWt+OAco8rRzlZRvOOkBTzQYxLLAxXzYNq6y/ixWkg+RZk8kM1tutU6OtS1CEDpaY0FK8yQZp6wvlL0id/tKreB5+ETuPld+Q8obrnmMQXGCmT4STFkAKgKU+qWzOl3kSzFh6h7uSu/fEgi+XTy+H/zf1ZdnaG9a6oVMVuVEsszKs7OFxBrsj7LxfixuaT12PfuGtqmk7epxH6wdLw3g32OL3vLmq9y69hSVR/lFPP89Bo4UxhS8DC2j5Sb4Hglla8r1i/aID2LMiumr1ySZpc+PAU0POCUhYsKQ4nHNnZp8s+DSK0HYsyPTgd5jSb3LQF1AwIuL4NWLB7aqKheLz8tp2qZRJ6YFhtQM2NPbr//tMEDOYkFepx3rQFdomiDMwSoNw4CjeotDCpmDVewS0gRyg/xQr3veNZOcVemiJQvvGgBGCbddrMvaNzHCE7yjDcqo2xTSXQ5SxE/2nOl3P/pAXEXkG4Mksrfd2JR2KN7ehPbj/zx8LuxDzwludAcmwcrU9JpIdfFbFT7EAvMV/JUUX3Xy3mL3eBjE7FfIQP0Tn/BxygLzYMSOBG+UzinD8chsnXV/zCbB5azSdNQWYU+eLBLxWTab4GtG+ddqiBlD8QpQDwmcMRiEGO5ueLC2FMqmPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(2616005)(41300700001)(186003)(1076003)(83380400001)(2906002)(4326008)(478600001)(66556008)(66476007)(8676002)(5660300002)(86362001)(38100700002)(316002)(6506007)(8936002)(66946007)(6916009)(6666004)(6486002)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CoUA1wp037t8HfArT+S3C1izph6MjwtTAE7vDZavDPpT/Xzwan1lVLM7Seqj?=
 =?us-ascii?Q?HhnaKZBOGRbTfSJNGJ3phreWbzbeiESriJd8vicoSxBwY4JZmXEPs1khHjdu?=
 =?us-ascii?Q?Owzf8Fj7BBcXFpGuGwI5XthOldZaX3oR4j2yZnDOh+jYGtf9wV/XVpmAx84H?=
 =?us-ascii?Q?kmTMu+EQQiA7f/LhsOWRbfS46oysXABidECk4zfo2AAwPLHGW6Yj7rJFpKPW?=
 =?us-ascii?Q?he0I+1ZXZSClqzRA9BGJeNnX0RKBLLzxDbrdo5bK2EhlDEWR16Sy4QnLhy02?=
 =?us-ascii?Q?PwBQHiA9q+0MrtzLmIu/6hRGaOARoHeXxZggFZpCHhOLVoCC3a0x/e9tSjbs?=
 =?us-ascii?Q?dK8lj/uglnSbbq+382ea19bjVJEWnckiyfKLlAtUpAxxXdUEoFSRRgjBznsW?=
 =?us-ascii?Q?agAGfJUXQTup57f5CR0PRPezMC9JCdHqAP0C3lDPehz6dhTLjhSkbq3vx9sn?=
 =?us-ascii?Q?D13CIout2tifXoiO78swOGid8yRfwBg71WNnWSh6j0yiw/qyxg3NQODqtCPI?=
 =?us-ascii?Q?v67NC/h9mGlLOT2fhr5fhaDGjhhI7nNIRCoHWIACbk4fiS1jQ4LHy5IzKTnd?=
 =?us-ascii?Q?cnuyEUDzUjF127FB2kP56rR9m/yRGcICYD0X3iVfomlNlelzhnIR5QYdPelu?=
 =?us-ascii?Q?Ev1dn8lEB669VWYZXzKE9+J8PkTCXTGceC1PHs/Yrmb3j7XWytY2QxWEjJ/l?=
 =?us-ascii?Q?68KgUYMTUeejxSrR3oMZnCGebcHQtcBquMpRVjoWhjFQHkMzzuBPtLveXUet?=
 =?us-ascii?Q?yBdGBl9Pza3MZkAC1ut1Je6Relljn2Syfumx0im5t0iMqjJQiQ1NpfH0XpRY?=
 =?us-ascii?Q?Z00QFVKAdrg8ridhKZFyhu4sVIcFZjsAkpZmwW26TDabhX8SrEyFEvl32nnr?=
 =?us-ascii?Q?spZMBX9t9EqlZqxwjWAxO9U6O5sIWY4+uxpR+kuZfjVuqAhEUFYibDK90RrR?=
 =?us-ascii?Q?FgVtHJHjBLfzt8WzMu95wCuuF0ei228spoOioXB311H5uI5AjeLbG/Pv5sLl?=
 =?us-ascii?Q?4krw/bQO8qPuz0Z+6KuNMeLqOgZzYURacLgc/TnCoyfm2Qsb25Pd8qEblon8?=
 =?us-ascii?Q?HzLqSqNLZ0xHU/WYdw5HCRTu5T/eSRwbjzCxEacJYG2Hx90lug+5MFBNDAQr?=
 =?us-ascii?Q?SOSc1ioyZtbkbEzcLLiHA1CI2KgUgn5LWrzFe33eQfl2vJUUZV0F3713hZyZ?=
 =?us-ascii?Q?GYRp6kjZlKpJW4JhITmGTzRVt1uutXO4/5TXUKH47Jr26RcDQNKaX7nrI8KQ?=
 =?us-ascii?Q?gvoZ9TVjpW5pJZRnLcjs1x4Cgn5alZOe9kAo0gQk19qfNz9NipKbpp+QXi+8?=
 =?us-ascii?Q?QEVwgADhDbX1IzFMJjKG7xu4EXbjz/RUwo1X5naGALB7CEZKPqMKmXVXcP3d?=
 =?us-ascii?Q?fhjvvo/XIRuLwwnxXRYU2ATa/BUQVctUWWeDC7JvMvZrG7RL+7r+5wPSjH9m?=
 =?us-ascii?Q?w9Mjc7Gs2kXt5JYpAa8xpxllxqwadgzpBUKef+Es86gCyNovFD4NPyUL3tX5?=
 =?us-ascii?Q?AjRiebnQJP0rjI4Ev8VPyC14Zd+77NE6TssfQpZwXTLVIkUmCJhTTret4bT3?=
 =?us-ascii?Q?U8YFzmX3tTlzbavl4iWsXjm008NXDvmT2tbYDZMR+E2CwHCoDrOiW0HixtnR?=
 =?us-ascii?Q?Wg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b361f4dc-d828-4885-eb24-08da9b80ca28
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:24:27.8956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H56dIcp098Gr9owFxkAZpMsHzVNx1alT4aIk2Mc7r3FLEmveyf3DBSN8sVKGWDAusfEVysm0evSXS8E0C9tjGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209210020
X-Proofpoint-ORIG-GUID: 5_Olm_AUBjo_OZsbuvKZhw4658CnFmWZ
X-Proofpoint-GUID: 5_Olm_AUBjo_OZsbuvKZhw4658CnFmWZ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit 88cdb7147b21b2d8b4bd3f3d95ce0bffd73e1ac3 upstream.

We should never see delalloc blocks for a pNFS layout, write or not.
Adjust the assert to check for that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_pnfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index f63fe8d924a3..058af699e046 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -147,11 +147,11 @@ xfs_fs_map_blocks(
 	if (error)
 		goto out_unlock;
 
+	ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
+
 	if (write) {
 		enum xfs_prealloc_flags	flags = 0;
 
-		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
-
 		if (!nimaps || imap.br_startblock == HOLESTARTBLOCK) {
 			/*
 			 * xfs_iomap_write_direct() expects to take ownership of
-- 
2.35.1

