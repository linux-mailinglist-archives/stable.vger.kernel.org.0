Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230C65BF455
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 05:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiIUDY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 23:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiIUDY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 23:24:57 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A4218B17;
        Tue, 20 Sep 2022 20:24:55 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28KLOO8n000789;
        Wed, 21 Sep 2022 03:24:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=LfKCjnXZxrf0uR5Mbk+cw84x4gy9INpnirLB6WqTshQ=;
 b=RNwrSrTEtj2iyMrGFMOMw0AcmyRFLQ+f99etLdKmYn7HjKarcFrK0mMJrbLoc9egFWco
 V7wxonnJssRyslCxfunipke1cIDDRSSUIZkRc0BsJEv4XKP3XrJ+C5pqtYhg/ALeJxye
 h4zpLLqhlcit9bQBsOZj6JMsFt2zHZPziApVL8zp816u/hh9ZSUn5d82oitp8G2A8kTv
 GiwkbsB1NB3hKsYbHJI+py5fXSvQ1QIuAbxraMT4OFaNyxgKUWrl/Vb3A6ZmmhrmbBZL
 YGulkzHJ+TSYZjnh5SLXHc0BcD0IwRtXgycELl3JRw1e/+wCmoXXWOPtkcxlrgJEbQVO 1A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jn68rgwm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:51 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28L2QpY4022903;
        Wed, 21 Sep 2022 03:24:50 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jp39r6tdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Sep 2022 03:24:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M84b0slCdREPQhFmSgi0/u3cPGkVQEMg64r0NUkxU27lSERbWuWpzMosJ3k0frtR4P03n017gHzk/kNPZRcGfrrRQbdAOUrm44fB2RRsJu6ciHjpDZGNXfjCSzy3XxbyQ7FB8nezUobuVrvrtVSlFHUa8NEPX5/l7vWU52C8mLhKniOHB1BZWpP1ksMOPNyi4Y+ZHQ5iHB4KRZRnICxgOOpipsl/0y7oAEpJxFJf81TI2okR4vU3Nm/BTVtYMQ7MieeyyOHiPKbgBmaHDe8kNUJ76crbLxgXPJZhSTXxHsTl749CmINsy8RpIqkYTCX23CYLX1ubAKNmczxUmiIOgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LfKCjnXZxrf0uR5Mbk+cw84x4gy9INpnirLB6WqTshQ=;
 b=CQOhaQ8to874DxM0tNxRCOC68ybUaXlItSJ2hir0tTVdxeuLVhv4XIq4nYIBThhq+22xqP8+mn4LfaJFBDsLw+Ee1S7C9qZt7sHaem1MThoG6cOxXt9EZRT3Y6V67yJTr/kbvHMaXLazg7mY7goJ5GNdg6V2s5yW7NH06J6/+O5foliAcxCNSM+ZCqZYgnpXxdtBAoH7UIrD6jqmBqB2IDJXVGiYvhKa5uQoW4oiemt475MGf3S0+qLr1WsNJh4mIDcv+xS7jbZ4Nou5Rq+pPWrlUr67YbUSN+fsW+5aJfUHWRgCckOLSSbJggE6huKuilBpMJEqS1Qr6XsDi5RrFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfKCjnXZxrf0uR5Mbk+cw84x4gy9INpnirLB6WqTshQ=;
 b=EPv+v9NxxQa5d0xQzzOKXIyqaj26RmxMYBlTI1nZ6QoyC1kMB+ZiT1sWLEh8yXfNHdbc+m414ZtZ6/k2L1VuILNTgHlhV6sPvEYC/hEpGRU0zMiSH0HfkJ0cXWfsU1iv1hkMkvyny9vD0gZkZ759MQEJ7xHBhXhGVeR4U2EZAAg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB5579.namprd10.prod.outlook.com (2603:10b6:510:f2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Wed, 21 Sep
 2022 03:24:48 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.014; Wed, 21 Sep 2022
 03:24:48 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 07/17] xfs: attach dquots and reserve quota blocks during unwritten conversion
Date:   Wed, 21 Sep 2022 08:53:42 +0530
Message-Id: <20220921032352.307699-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921032352.307699-1-chandan.babu@oracle.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:196::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB5579:EE_
X-MS-Office365-Filtering-Correlation-Id: c9f3a297-1bbd-4a22-59eb-08da9b80d664
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p53unzk68CsbXED7d3JiCDbBA1CAX92kpZJJk50gEfS6iBkqV76jeHktDhtebcZ6fDyZVMoBpC8nwq/NE0jvLWDRZxQKSaadRdrNBLQY3vN99Un8nbNPUQuUgWOq1W4L2DPqpb92rScr4L5bNfD4dIJGQ4HK0KuDz1WWLeipGi1G3l0P/pWoaApUapxkRejvq0q4JqQJq8x+Qz4O3xBG/Ctk0/xEx5SucqZM9OFLZ2qfAfTjN74w9Tg87xmyhehbdIvO2JPqgTxTaJ2mxdzBQ3ZXUDehgvpWWU22IcxclUEIO8ujuxokYMPrvmJTLYI8NycH3OhQVFQSqvtX716r1KIY/VOdmcfb5apSoi/UB2HsqAMVVAxT7FMdMZZzmnxt91i2rN2aZbTair1Loyq7f4mLq+LTpB2lGDzMVDkLnoxaIylLWLfAuUliSVa0AX5ezdxqLuCH9XRwDgILEWXbZJm2jpkIZKPXYnvg9cirWTuQQdfmbhGC+cE54k6NTtLs59ybEJOqPVnxY4voijbDTQAHoEYqyaudNCljFe5ZeXy0Ij7E0c8fjViHAx7whd6HqJsdQ7PjtcFmyPR8FeUWJlekmqbRtZ1mrwBircahj0RRqUV8vUgfBUR1rHVx3QgmBfDUQ5HFrYqccI2FzwzdPTj+xYIq889FZupRexBf06grmoQ/88oTSIin1sebPCYhRl6vkg0d7QG+NFLZom6Qjg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(136003)(39860400002)(451199015)(2616005)(41300700001)(186003)(1076003)(83380400001)(2906002)(4326008)(478600001)(66556008)(66476007)(8676002)(5660300002)(86362001)(38100700002)(316002)(6506007)(15650500001)(8936002)(66946007)(6916009)(6666004)(6486002)(6512007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bw3PDd76y7Sg5w9nGQvgxWBQCew94GpCen25NUbv/JT1RXJTbf5CdlXc8ymj?=
 =?us-ascii?Q?kO9+qvr9DiHsd5QAc4xc1NiQ3gLj8mO6Jzc5wqGLcEncY9Lw4LF0yc0P+zNa?=
 =?us-ascii?Q?cwzkpeI+SegJNRTk66d4J5Ph1R9leK3dr7OM+FPtXmAI5qB+meTztZHkx2NU?=
 =?us-ascii?Q?QB+ZiHH3DWNq51SDfFGusc5mZ7UPoSHjK778min/ZMiYMXsnkjgC9G27mTyZ?=
 =?us-ascii?Q?EEaMywcfUQg64ogmfrCTxjxnGB4rwmkMfiU2e7pTQgicw69igRbDxIvVDXxZ?=
 =?us-ascii?Q?bEbvI/xl+OIiIlttCkyKn1e05YzC7ijrQP3ADds7zc0OeW8qdqUn3w8Mdf56?=
 =?us-ascii?Q?AOpSwFJteUxHuNyXmmgwhPraJEu/hzNX9Z+issZ21psuN4KJMx8zFq44zLXy?=
 =?us-ascii?Q?4DsygyG2UKV//4+Tsemq/UqYu3gOtJ5azpXYeeTAYKacuLpf53X8Vz2ht0+Q?=
 =?us-ascii?Q?0KmpwhQuKE42kg6DqJCXmMb0ApZcYlD95UONbOGBzZdkCeybOWTe8hP4qysx?=
 =?us-ascii?Q?PsVFoQiU/Y9ZZFkSANJi3ZJ1amtRUPUd7W0gLhEad5HBL9r+/LSjo8fE2T4a?=
 =?us-ascii?Q?YCxrVodeIht80g7WzL6dVwKHKKi9Vg/uBsYo2JKDeWTdFUGLD9Rd0t4c4Wbu?=
 =?us-ascii?Q?kqH3E17LmIJgRXtsVcogIrTPKLoGQqfZNrv+SHcm2LOXl/cyAudcwVL7WRpA?=
 =?us-ascii?Q?cfABy8Vq+DdA/gzCa3lSAwobtiD9r5eN4O5xeRv0tfF4gMcdtrot/VaBdsgQ?=
 =?us-ascii?Q?MHHIao5VWVQCBvF0gs2p0FcNww5bkc7X/KVTbV57JeE9Ft1hXKi8x7Ztycca?=
 =?us-ascii?Q?NIbm5NWQ8TU4Pe/BisPNLkeBbaPUxcjask1yMMq3LpjO21luRDURj99RWDc2?=
 =?us-ascii?Q?al0JkkPE7AnjahFcjDg1LBXA1Y+VL8TjhdbclmiSXWuv60aJeuNQgs4+ZocL?=
 =?us-ascii?Q?R3Eb1wdnudgK94FoYpccoVSl5/fXt0691Ss1CGQ925phJz5omfTZGO/mgOgM?=
 =?us-ascii?Q?AAMgsh2qVeqbeB0kCIBiDgKbD2WhCzd/zYqSIdp3ukHynVNj6BaH/ZKk1zow?=
 =?us-ascii?Q?yiF+d+ebUFkxK+jl9pSJE8PtY8qiQhYgyWb72/XBCvzl7AAbKBhNTb3jwkjH?=
 =?us-ascii?Q?qMJOufqFcU3w3QqTwyt3ebBbaDRH5zJ2DN9Wb6odY/XLwLfk8Qs6LvEX6eDB?=
 =?us-ascii?Q?wZhjTeboTe1BHuO5dqfXouo4ymbB0GUTC6lRY1uh2A/K73vQlDVAsoGMu/oS?=
 =?us-ascii?Q?qA4NoVt6aztlgPOhx/R1u6/5u7eOUbGUjDq8YwMLaCP59jzJa/Af8K3YBXPO?=
 =?us-ascii?Q?57gDzn6Z2J62rfmzXjffzbSs50VbGZMXBbpcZw+a2+vYBPz9t3BbhpeSEIKm?=
 =?us-ascii?Q?Vgkm/wVJG024B/wj4Qm8DJFlZ2yXFRTk3QpbOvzmqsN94NGFBu7ENCib0HIb?=
 =?us-ascii?Q?4ZNQAhQGZ2wqk9mY+lgeKr6RRr1IoXdZLIdksrJ2X+Z3EJThv9ZJmqtH2YH8?=
 =?us-ascii?Q?+9ldRrPiZgJA2V8DpVm4NTIoX4cyxgnFjECP/3ZkgoiiYo67GG4EOu4CW27H?=
 =?us-ascii?Q?tvJfJATLAVoe8uJOVZ9GUSQ8FQD2sLNbDwhC7t4Xihzaa5ZtwgeWwRt084Bt?=
 =?us-ascii?Q?Fw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f3a297-1bbd-4a22-59eb-08da9b80d664
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 03:24:48.4178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vR0pkmeNB9gW0Ht4OFDH1OLymcCs5KTVsEbM6aBGf+rYkKR1mxEQb+GBxrCCXCzYkprpfysPM2/xbwmiBaN+Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5579
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-21_02,2022-09-20_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209210020
X-Proofpoint-GUID: UcP0AIMaBmBI3kb0cFa0-75oXStdh_As
X-Proofpoint-ORIG-GUID: UcP0AIMaBmBI3kb0cFa0-75oXStdh_As
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 2815a16d7ff6230a8e37928829d221bb075aa160 upstream.

In xfs_iomap_write_unwritten, we need to ensure that dquots are attached
to the inode and quota blocks reserved so that we capture in the quota
counters any blocks allocated to handle a bmbt split.  This can happen
on the first unwritten extent conversion to a preallocated sparse file
on a fresh mount.

This was found by running generic/311 with quotas enabled.  The bug
seems to have been introduced in "[XFS] rework iocore infrastructure,
remove some code and make it more" from ~2002?

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_iomap.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 26cf811f3d96..b6f85e488d5c 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -765,6 +765,11 @@ xfs_iomap_write_unwritten(
 	 */
 	resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
 
+	/* Attach dquots so that bmbt splits are accounted correctly. */
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return error;
+
 	do {
 		/*
 		 * Set up a transaction to convert the range of extents
@@ -783,6 +788,11 @@ xfs_iomap_write_unwritten(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, 0);
 
+		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
+				XFS_QMOPT_RES_REGBLKS);
+		if (error)
+			goto error_on_bmapi_transaction;
+
 		/*
 		 * Modify the unwritten extent state of the buffer.
 		 */
-- 
2.35.1

