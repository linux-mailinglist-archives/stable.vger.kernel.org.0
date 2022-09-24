Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB745E8CCF
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiIXM6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiIXM6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:58:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63BD10D649;
        Sat, 24 Sep 2022 05:58:01 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28OBf06c030381;
        Sat, 24 Sep 2022 12:57:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=LfKCjnXZxrf0uR5Mbk+cw84x4gy9INpnirLB6WqTshQ=;
 b=fKlrdLb9DTfSZGVGPQRZcSXCQwQhP3d2Lbw7Hi3Yb0dTeJ7V6koiYhzVNY8txooQnuVr
 QGeWULjJ3/bHrUU2fdItu0fN7i35zDzHo2VXGwnJm0HszOI8x3BWElsErE17Mif+zylA
 o2fpPlCeEvaY4pVL/1LnxY0IABBflnZ9NFGiD3vhIc+T+Crw1AUltIvorWPtZwcLk9OB
 rja2bMP6OI4/IgtyoqSSqSb9nJGp3Z3K8uMViruEaxJZmtuFYLqmDYquGfKWVdF4LmU/
 uaVDQRmaEKXlUO5am7m1QDV/9Adn2eqry/IG6v49J4UQWBgNfhRySYMk330myOxlJST8 Fw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssub8ghb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:57:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28OCtmI0020214;
        Sat, 24 Sep 2022 12:57:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb7h87r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:57:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gBy15T5q/Aa+tTxNyH6z2r1K0Al/56HkcTnyT02M8yWFnFNMGpocsdFpC/lOl9Dkf/lIC/IijuYEvFggfGW9S16uizuKWkT0c4JJPSGFHsZIluDzwns64tW4U+6eNl5WeV2HZXDEC6WY3k5kKbWICQoDlFBv90xqzXUF7biAV9jfXMv4L7UsP0jvEMirvpCPmlZnmihg+MWGqNVXCbPmzpgT0Xz+4mSA4nPDzCFdXno+1brsHgqxWv24rkt6MkX8hHJcg17wekUlGwbHurPK0rMMG+ugEZut2NRCOweB18Uocm0XHnjkyc7BB83l7d8ym2L3bihro2vWBRRzJGEy7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LfKCjnXZxrf0uR5Mbk+cw84x4gy9INpnirLB6WqTshQ=;
 b=c1nLTXvBU0jahUzbmUVltlvivfok77B+L/hXlcJ80lzQEPElyYzbNMDW4y6A13hgUFLTfbLpv9Oenokb/2iY9LjLWB5Gho/1dzHe8CqNfU+qbqsFqsRYCTijlh90ZD6tZgWnna4i4X3cAXmtdQk829zLKzwOnMVDidwgBcVn7nQj+J3vhCASUxvvzBw8f7IvkUhrtZhEDemBcy4vokjt6trESCu5CeUPk3R0j59JkPmbQ2gnFTPPnJQgbzXFf4hsT/tLqwVuTj6V29loYKbyNEW56j6tirNeW8nrK21umlkEpKHtkvxRxJoy0LLuGr7VsDv8D2U2dZUbHihuHytjBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfKCjnXZxrf0uR5Mbk+cw84x4gy9INpnirLB6WqTshQ=;
 b=p3tYNFHsy6qzcdDfJ3l2ccLYcLoNjSOUD88UOMkVp5xllNqN5FCW7XrU1BVyfEVcZIOWhV/xLQz531CSZsGsXvHT7lzpej4xl5zZ9BavCoENDbSEbmkQRyi6J5kND0YofSOEVJYwLnkMkJG5r4yAK1MSQH7YqL3yK/dekBtslPI=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH7PR10MB6249.namprd10.prod.outlook.com (2603:10b6:510:213::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Sat, 24 Sep
 2022 12:57:54 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:57:54 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 07/19] xfs: attach dquots and reserve quota blocks during unwritten conversion
Date:   Sat, 24 Sep 2022 18:26:44 +0530
Message-Id: <20220924125656.101069-8-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR01CA0008.jpnprd01.prod.outlook.com
 (2603:1096:404:a::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6249:EE_
X-MS-Office365-Filtering-Correlation-Id: a4a39c4d-3022-4732-9f65-08da9e2c6555
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7NT7Q/fk+HkFFQ54FtFK44gXdkqkIsbokHwmqox3U+85W2SVM4Z9AGZ2OoAee2pOwxmJE/SbgKSwLJEq248neKf+jzIxD11YnBj4inW4Rmtf7yBqwc+Fom5AyoutCNoXIpydNY7oLw/KwkQiji3Ktsf0GWFXnAVzBazggmPrfiPlO8Ztk8NMsJXs7x94oxUkOTBW5pEav7eY5i7XcNIvVteUY9Ln7nwgHm+3nRrlQkgdm8GkNtG7njDRsp+F01mykb65djCgt0vtUUXEy31gRBA/+VQKESvsNIVXI+us4RDxdt8jdf3WqvUPol27VKu3vejdlnJR8L+rVwgDViIHE9k7KLRXwXiB8W0jgz1NEBgJUDJjlLNff0X2Y0yzPNtNTvyMC/PoNL2/4tBAfWzSvbQKzebbS04Jq5DCYW7RoWVqueA5uRvU6DYsBsiNSgHfKm4GJXwh68HN0kaQCrzFQ5JGNhYhGFy4ItnxeYXcrLLkc2NSR8cqMhMZGGg9/uqIFs6X7saLjOnbb6dxJ5ZKPnM6xyRB9Jz72q6barIa5T30H+ydBDAEUWlYNf9LiHAXd3lVChbatMN/NxnenUmt+lyQVcVz7zmZvOtFAw0suys6txf51mAQKeTEuuFJhrq9toqFciv5oAePE/oj+d0nPx3UCq3AXN7RZBlP591wrl34XX2iY63YbmwPrDYeHguo6Si4rIr0bxDAa97py5usfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199015)(66556008)(66946007)(66476007)(83380400001)(36756003)(6506007)(2906002)(86362001)(26005)(38100700002)(8676002)(4326008)(478600001)(6486002)(5660300002)(41300700001)(186003)(15650500001)(8936002)(1076003)(2616005)(6916009)(6666004)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FDDo/E4F1kwAdXGy09QFrae1Ezv2QSBotHMxLaa5+K4Kexgz2P1Muxlyyprz?=
 =?us-ascii?Q?7Wwe21iJw1hOoEPdRAykLzR9jh64ffGVS6iyVCN768U+x+XR+/kWNP+Oj+jD?=
 =?us-ascii?Q?IChVuXPQ/CIZDuoyeA51tsI2vEsDM7Y1n7fiQvytlyfgvkLOU4dQiV2DHsf0?=
 =?us-ascii?Q?pI3ZvSUMtdONqWS/SBBzpZh1WgKxEDWdruMjFaYCo+jSYPQBC7Nk5VkGXDIm?=
 =?us-ascii?Q?HyLZMB6k9/5weXHMgD/HYJSqvXiEfdcjJfVrdUImYz7gi2HMGTNMAdxyPzee?=
 =?us-ascii?Q?j+Cd1JQJe8WAOdtKiUXQ8l1wgxfCUBIdq7sIn7hsiV65T1yDA+O+c7nqxZcC?=
 =?us-ascii?Q?+PhMTJkGXjOudWKmIKi4p/Z89iaIqeeyB1lhegyjd85PrLbnfiyF3XS5dJ4V?=
 =?us-ascii?Q?VrqU6dAvvmmZZbtMF+LBH1MN/PPDBPYS/1+cCfNnUNAYK7xORqgZHE3WLDSz?=
 =?us-ascii?Q?y30+VsVtuEUu+JZqcjaaBfvksd0+hw/VbtHCDH5mgWWAYkJZK9jHdV2Na6Ki?=
 =?us-ascii?Q?c9io+78bcM3CWYN3R6GYNm7jSKf7mGnOy6jzCE+O0TH4SukIM6CVmb8B0bmV?=
 =?us-ascii?Q?0I3Y4OmSUUT8w23kj9j5AY1eV5hHnlKuUDWpasneXJntBoYgRsPWQgbJ4gcN?=
 =?us-ascii?Q?vQfx8y8iv/WleIU/HHln2I4gJUQnnC09VJonM41Xzp8J+VYQ9NuanJqUtB/1?=
 =?us-ascii?Q?4y0OMYSpANt0MJNVLgoURxWyngEmvdhnXm/6b92yh8zw3ULwI7FGQtNabDWH?=
 =?us-ascii?Q?EgFb6AbqUNfuM7KgA93nphmbEKkeRJCfdTnK8E9Ev5H8cwoY5YZWemb5Ueu4?=
 =?us-ascii?Q?G3rX1QT+wdZYHSl2svD4Oc5O3R2EFasrCTR2wOKFHZYE0XR6NSNZrS9wNkOq?=
 =?us-ascii?Q?PekpYCmPleH0tzbHghLLUVJmw5ihYgSaUmB16+zLJ16/59kXIKY+mBGF1G7H?=
 =?us-ascii?Q?UaMKHvrOVJJtyVp+YPu6UZkFEEKH08xGX/+wWXL7YwN1dsiPKRBAJvkSXx7A?=
 =?us-ascii?Q?avbP//MDU2i4eVcIktjLfS/S2PRkWR25A+dAi92N7hkMIRMgF84s134epnZH?=
 =?us-ascii?Q?4vtSnoLoTNM6hrndlQDPRRVn1Z+ZRYt270+Z7KoffSbTTYPcLkzafx+m7CCJ?=
 =?us-ascii?Q?e82z+ndR/M/4fTzJmClJ8Pt+OAx7qi2GZW/m0oWba/TjX2HURx2miUKgLySP?=
 =?us-ascii?Q?05aBXp1Ha3vPkngpOU11zblGQYCg5cFR8uAn5qWDSrPWDBGsMUv5GF+9pcpB?=
 =?us-ascii?Q?yvZjhNZxugA3HxNOqjZbvUgrVzPCm/danOiM188zdLOpbclE1Gl+3KeVI4pd?=
 =?us-ascii?Q?RjnQAbMvssNJpZj/a7qo7CesFWZMtTBVm7SfTlzSoyaWPfS8ampBkvaO0Z5H?=
 =?us-ascii?Q?E9F5s8kOncgFp5ZM+vwC6I2ZZkPZnHCcVFd/ind2TYxM7AqruqJ/SGxbR4aD?=
 =?us-ascii?Q?0VjF3vEWCxulb2gbwNWhuEsx8Y7dtfXZIDzw5XfJ6P1WlX3URAm8ZRKsqntr?=
 =?us-ascii?Q?28IuToB2cavJtgE2r4H1iQ8bAAVGDcIU8M212FiwPjBO/WN+UvsqM/eU5TP+?=
 =?us-ascii?Q?TW5saIdcv+jj5WWj0QWZi6sfWpGl3PdZTPFxbpGq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4a39c4d-3022-4732-9f65-08da9e2c6555
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:57:54.2987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t1AlzwbQm5+xfTcs5k2wGyBbXLFshimQcsRbj1wUyA/NnC1v8lNrN47EmY96cbO35x4u0nJjQtGMYQp5E/axNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6249
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209240097
X-Proofpoint-GUID: tfxRB5U-fFsOOiLErG3t9BAirlftDJa-
X-Proofpoint-ORIG-GUID: tfxRB5U-fFsOOiLErG3t9BAirlftDJa-
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

