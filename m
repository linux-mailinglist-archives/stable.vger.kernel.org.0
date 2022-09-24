Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9375E8CC8
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiIXM5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiIXM5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:57:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D14A810BB3E;
        Sat, 24 Sep 2022 05:57:37 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28OCh6Pc003190;
        Sat, 24 Sep 2022 12:57:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=/CgWhIi+2MeQMDT4TS0Lgy0LTio/HtpoWNSS9H9QlZM=;
 b=UqMIsBD09JKSxD6HeRns5ZAfetNGE8FmgzK0MAHwUZXgpMywyMmYgaJ/YDoFRtyapDap
 BA0seYqGftWrE8O+v7mWb65JGKxR72Vd9WiLuAZjGhr/TyLJNaeoOFUbF8HgWsYoM6DW
 Gtqoua0+bhahRz+RIhFsxgeCPjY30HtSMQN1at8eySmwtxB+bIs3hmYTJlbx71SghQDy
 eOgQbGPQWP49qDjUJCBJ5TXAdMckB0WSL+yEpMfxgGr1uLg7tHLbXuNkwTZ6cnw2nrFV
 MnhEWHDMFQcDB0fBunuCALBPQz2FWWpODKvdch0bHIyVl/DI2MOfyYjcroPaoGC1bCdy tA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jsstpgh1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:57:33 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28OCPGIf021067;
        Sat, 24 Sep 2022 12:57:32 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb1gt3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:57:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PD5lcpF+vhVbjnF+eCb4E1TjIPFxgM8V93YGn9GLsKQcXwJ8KtiMcKpjvlPB0g2GmcNTu2es/YRAsbKRCq5c/lv0aUMCmHjgVL+KrD/UYcGy40iiWYVQJOdLHqBzp+m//9S5vadQQ3ukY3kxHwsK04BBtLN+tVUTBDJi582ZototMlzL9EwE9TgIwsp14uKcbfpADUJWCfFEjNClnJZQK2Nq1LaOmrmz1aHavlKII0qtP0qGS08W8KvuT+gu2UuS7HXGx8ScEWUp82c6UqE2/VfD8SdkHbWGqTvtMMFukEfLn/gl/KWJhgxMHMMFPEq+rCULExlNVNR2Q28B+LU58A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/CgWhIi+2MeQMDT4TS0Lgy0LTio/HtpoWNSS9H9QlZM=;
 b=QDc3amkcxiPkUuqEP2vsGLuXwD6I7L/wexSAuVoJy07WZ0LfLKxgwvyJ6nN3jLCV/pRANF8IeSMl4bp9d3k9YADXxyLyaKw16MN4E8Q7F57H5ENbalbS/msWgkNJUr2A1+EwkutOFhiVcABf7dB4e8ynpYBH8wj1j156/2IPCUu3m8atUIVxfOzcKgAlCUaGgN/kfaY4Y0FM6W8eDjMQj5BlJP9tb5Tdgsfz5nHhDbcvwDt/lTSh8GazyvaOxLWEGoqekQ9bA1BaIFqnLb4dlp8NitFimjcqLdcw4XKzWcmXxmyKRv8ZV95nFQ7uuLOzvfTCT4TjYumAYFBHsmZGjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/CgWhIi+2MeQMDT4TS0Lgy0LTio/HtpoWNSS9H9QlZM=;
 b=vMzSwRtLyKWUipowVICUGlmRtKr+xkWWI8zX5kpVVH8i6TmrEkDqVulQ+vDq/xRR3FUDLBthX1d45m5Yi/5ibbNkh8ny6zhjdJ1R5+jqKMaCWkAsLG1K7/Uwp6FZhEPPREzm5dYEVa3eUo7K5ZmpjXb2PEzSy7JoHIz8Pjss6so=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH7PR10MB6249.namprd10.prod.outlook.com (2603:10b6:510:213::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Sat, 24 Sep
 2022 12:57:30 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:57:30 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 04/19] xfs: slightly tweak an assert in xfs_fs_map_blocks
Date:   Sat, 24 Sep 2022 18:26:41 +0530
Message-Id: <20220924125656.101069-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::10) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6249:EE_
X-MS-Office365-Filtering-Correlation-Id: cc87abd3-32fa-491a-43e7-08da9e2c5733
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iDqu7xJg/MpYNPwTKbloD2QFJ8+ocmQTYayUMOTps3GnmKzeko37pU8O/uEjkmliRpwvNXFr7iBDAZEHtxjca9qsp5b0wUW0k0bFqF4/rU2zRag2lmiqvHtHhj8itS2YdR07zAalRAkQoE/9NoeitHKLMD/Lgm6TrA5NpieYWylkch+MRWWGtYreHG1BYfeg57CmMTaIQAvCkDX+otLswEYSqdcyUYZAjE6MNTf/Nf5RntnwYo5fFyT/U/U69BWnZBKGtwK1XeSn7sIaCLw+kct1/HU3IK1WEb6GezTpWEkqiJezxxaF1uFDT8dCTEZNyVAZmtOGmGlbAa4maFH3jKuOLZdb3c9Ziht/D62rM8du0+qDp8ihcYt3vhNu1S1wuoOMzxGRlhVs87CbLPXSR1JMnP4iQkIVX6+KY2n2C7bFswkSSOOACCt1JVt3zPqecIVqAoB4U4UoxX6SnhDiBImLmcbVsZ70/wpfH9mZZ4Nf3fhdF94Nf3J7cGLllYpAHxn8WqX53f76JeuH4OC3C/M39cXp8R08eVAHB6pW0SeEBezLMIOtKZr8zd3jAkb5FFOJ0F0OplCR55UdXDY1Cmr+9QZIEmeilJzE2IeW3Gt//7rrFsiBuPBJu1AjkJPRrER5jQQ8h/Zx2dmi42+gGl6WAijyrbCAFrxNqBRA7Rc1NXIOxVRIpwVDNeQN6DuGWj1VEbwEqFA0K3XJ8XNzwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199015)(66556008)(66946007)(66476007)(83380400001)(36756003)(6506007)(2906002)(86362001)(26005)(38100700002)(8676002)(4326008)(478600001)(6486002)(5660300002)(41300700001)(186003)(8936002)(1076003)(2616005)(6916009)(6666004)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U+YXBa4K1DuG0PTiY3H+m8EhIbiFK4GL1eNOnbqK01wob8D2Wwt+psOewWzO?=
 =?us-ascii?Q?563n7BM9vQmL96v645z9Vs9Fj9SIP+YBbpbqvPvtThrYmIE2OxW/cfog5bxE?=
 =?us-ascii?Q?xwXeoK4ukD0JLbTN7K75ReAGhukLTH6mgpAzaghZVsRLHFCLfBJhezHX6uKj?=
 =?us-ascii?Q?SYpOA7aIlsrKUh2ZzEMsuuJxF1DkuG1Kr0NaCJNoXuIkNAa/uDXZ58cFLxbJ?=
 =?us-ascii?Q?xZmDUfJH9QxtLIum8Lg0fbbJ+G5/Tbc9zwUGZ7UcY+1O8hMSc64fktFG1nQn?=
 =?us-ascii?Q?mf7TLbDvZP04njRJsLFBL2q2ZgvPm0HB8qiUM8ACeqM3KF7N7b14GUcaBDRv?=
 =?us-ascii?Q?cmnURysm3WsY2pC8ezhK9b7LAjzQDUzIwozJ9k7rG8ROxXoVFdES8zFr6j4P?=
 =?us-ascii?Q?SqmBthj3am3B9dd5C1rYAQ0yoZtAlFNVGFo/R1JhxxD3fsrTUREn+Sh5NrpT?=
 =?us-ascii?Q?d+atCEo0h8trKxDQLRurW+jcS4quM/lET7zfgmIlDWQmY8t3eT6ZLCzYDttS?=
 =?us-ascii?Q?ln/VCiDkErBCZVw1Nu2tNGTzT8B6t6t+FWUdx6yKNwWQn/3a7C/5eNHJJZdL?=
 =?us-ascii?Q?5AlTVqeBYxX+aveB2KOEfSOI3RY1JyhED7Hyc1GB5Rzh8g5cjm7OkfN4M7ud?=
 =?us-ascii?Q?FrWktLMYnrnLrfSFnw83WQeMBRExOURRmvVuSrqDHw1LEilRKSe7mkdVyqy4?=
 =?us-ascii?Q?evwU1eOxN4iE1FiyXCa17Zb9/lVFJvLaZN4jXvOuPZ7Lux+Z2t+xlblNDEiT?=
 =?us-ascii?Q?iFm2lvQGxohWxjh6QQvk1yk9fXjxNuq9Bs/YTzXMyS0ACMUFKepUv0D8CQZW?=
 =?us-ascii?Q?tzV2BSgwvN6Cu8mPaNj+pmSEGNWeCfp4g6k9zrKP6/lAGg4V/L8+61XHT6Fl?=
 =?us-ascii?Q?4yBjTZrP3b1/npC9POm+BtmJA0yshhkQvLKajLo2REDvNW6Ub8G/yqbve4zY?=
 =?us-ascii?Q?m4/stB9s8sN9TFq43N55WQrRt7KdS1IqICU+pQv/GKyHdcGw95Q1Oz/+oh/r?=
 =?us-ascii?Q?awtaqVLFcUNthfoS9BgnjJeTKlXC3npPsvTfhlXZ1vHyMzItmzkK+FkiwVNl?=
 =?us-ascii?Q?VRYbu6HzCAGsJu+PJwdbQuQrFdQsW+FGok4NcSLg4ZIPZ4wvqqjFAjvwt+fD?=
 =?us-ascii?Q?GaAAp3aeHZDdI90FOnSm8/mO3R5zU386q2YHYQ/KmPvfvaTdUQwl1p5vcrXr?=
 =?us-ascii?Q?eGn65yWraYm6ApXY2b1gGUW8ldpWKaOLtCNo8JzP8spZaOFjLk0PpMpuBg2N?=
 =?us-ascii?Q?rC3amtZjR5ua62McWD+STdIlZUjpK/6P5pyD2XNKT+1ZXJ3tS3cg+vu0YFcB?=
 =?us-ascii?Q?8RhDoEW39PRvlkw/DVEomrBf13wu/7MOcMZ8ykTwjv/RpbOROqh0H9CHI5ab?=
 =?us-ascii?Q?knSGjEMEOshkwUJHjAzjW2OaPW8qD0HqfWi2+yYJ/K+FtRaSdYEnBuNbPvoz?=
 =?us-ascii?Q?+2nFK8JI8k6dskTYhrF3FEbXNtCPB4Lv8L0nSJMNbuPGLfzs8Bw3LcO2S/Zs?=
 =?us-ascii?Q?0srmHkkSyF0bbF8OI1iTIvlN9YyexnpzF/miZVwRwNgtwJ0RW2VBg9IIgun8?=
 =?us-ascii?Q?Ys84kqk7Yw2IoOClrC4/EBnKWsKUHpCDAT6De0Uv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc87abd3-32fa-491a-43e7-08da9e2c5733
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:57:30.7729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HJk8Ho+c9+ImdtTYvnHriw3Q/VNLtIZ8MPpqWmwHP78xA5zfkxFDp1s6ooJcV4OhCpwNRB4Ba5py1qzCB5DN8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6249
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209240097
X-Proofpoint-ORIG-GUID: RfEeMaugnby5PZqnz28gmSA49aCf2n5w
X-Proofpoint-GUID: RfEeMaugnby5PZqnz28gmSA49aCf2n5w
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

