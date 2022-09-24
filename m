Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FE05E8CD2
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiIXM6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbiIXM6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:58:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DA610E5C5;
        Sat, 24 Sep 2022 05:58:12 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28OBefWq030222;
        Sat, 24 Sep 2022 12:58:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=bFK4p2xZW2BRQU9pEJv0zBlHzxLGdFal4PTiCbm/zkU=;
 b=pez4DzjT1kqw1y/fu4NZ/tbpqUwzqtG9+LZh1qEc7mi96SdHZ5xENGUgRanNZNSf157R
 B85bnCWWUaj1+hZtPqnzZ1DPZwlB4hcncXu0qqXCilrAwvfM/jSSkc6KN+lnVLR0GRx0
 alqnBI6lGJSDueMW4cw0U0qZIFYfk7tHy0SXr5J2/1i6hlvUfu8TCqfItRWlN1dZE/ln
 x+Wsq3XbrLDdZ9umGC9CEOy9gOQLllYHxQKCLap2HPEdyirfqxLXZgiXmB4FTWgIlpdJ
 ZN5E/6oznJyrsAmgEeR8sAAWWFccqRN+Q0/MQ5g3kYFn4IouQgN6YrfQSRucqY0kH4sN 9A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssub8ghf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:58:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28O4dCTP033317;
        Sat, 24 Sep 2022 12:58:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb1gwu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:58:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2BDHwAQadMJAQtuHoUD2C2T1CLL4ab3yvLvXRZK9A33fgTUF/yFU3dU7AL2N5/WsN++NhRvAvy88AgQgGgr/Qksy3oCkCAAiqqkGnQ/uVk7Vn5FICYZPt1TLcl8/HwPrTxxgvgQXYh1hafa6ZikFuuUKBpLfKPP605AmAECmaHbPJkE5SJNNkFwFXRSxzfyiAJIpSbfx0PGLvGrvg0cogJnaMq00Pk4+rECf60juxcJuAwa8FlqWWbCasnJ2wumFq3u78d4qgiCrXdY6VNckcsumDx2j6CsYOM9BkdKB1jpj153Ny7wdYigq+Ujat8QVZv0D5rk3tm/SwtuTjCKNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFK4p2xZW2BRQU9pEJv0zBlHzxLGdFal4PTiCbm/zkU=;
 b=R0HNKtrNSdDIuelprypMbOGhpNCdO3IaFKw2iUhH1KTARETa7OJtdC7InnlMrlUhrp0lhycSyaqJYl6ehxyc/9oaoUD/qpX/3rcREIep7I2SPvV0GDk2aJXNRHMa7vo1pe3qMGaHj6rXRLEabwDBoA3wjr5sWWjAlR5CSywK/mR6lZlJVoDycJbOHSM5b3T+2r+5kT1fQd+hK9uNlme4+pm3m5dVXN7zavg4XnTCVbTVbZSsYWoRgpw0TVEeIBEMDWd/uqheWbnZs7EMye393DITH9UXqceQIy8kOalCHs8SMBGb+OYAUtkbdUYaYMG1lmAxRzsfR7JGiYY3i9001Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFK4p2xZW2BRQU9pEJv0zBlHzxLGdFal4PTiCbm/zkU=;
 b=I0LZxNvgInxdPjOQRPo8ZpYIEHjFHfDIvkyOaDBLXaK2YQOUIU7z/NVfcaTyWGtx+xP9tOlIF/JNLwFOupMt6ZbI3EHLZDKmejN7kMUg4+nPwYdF7OnkFwh0erVcMP7PdTuG9mWkNWJd4lYMCV/e5Ii9f2+wnbsTg/gixrZMrkU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH7PR10MB6249.namprd10.prod.outlook.com (2603:10b6:510:213::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Sat, 24 Sep
 2022 12:58:01 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:58:01 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 08/19] xfs: Fix deadlock between AGI and AGF when target_ip exists in xfs_rename()
Date:   Sat, 24 Sep 2022 18:26:45 +0530
Message-Id: <20220924125656.101069-9-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR04CA0011.apcprd04.prod.outlook.com
 (2603:1096:404:f6::23) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6249:EE_
X-MS-Office365-Filtering-Correlation-Id: 26d3ef1a-4ab9-49eb-ce90-08da9e2c696c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KNQgQgOJ3xb/bjG7gKvhNVdf0wrLgt3yFMlEoAkt6UD6zDXaQhkMpy8Jr0ETP9Q54RirnRhNkCuAgxHCTY3KmIsTPngCfTojZzlhiW8FVcylAXAq1vfl9J4Bm4dNiXlGFWg8DSbF2ckrFMYl5aIN3U7X0vU8Ciak6HAs79pmUjrwhFsa4oyeFW3workBMR+Pg1glB6fYLXXcf/wi47nFK91dA1vDpGpVBPtgyO+vHyBrKkHa6OdP2DON2NHYSgL5w+EXleU+2zHVNg8AqpfW1fHa2ZZpFSwjiQxoY5oJF7tmMsxDkM8BdSz/uGZctsYcI2OM5cqa7WB7y7kplUp/aYDwn8/EnOx67h26fwfib6vpvjvVaKdxrQnn9JHHoK+PeRpP/H2pZrk8tuzwnbxSHrXvvWiY9o3fcc21CfVEg7VrfjxYtUhFOSnTIAwDhy36ZKs52P+kBaBWEvZnmzqX8Ukc8+Ze0+THDd5ZoeBH3kR7S17trw+JR9l7p8tCbsWZvMgzRQBoAFnaebUqysetqNxMdSiAQ9FuvxU7ML/OIR93Ep71tWEvNgUO2YC1H5sxhgC4BCEZUOQ7M8FL9Q1iMD2LQZDQh31jOa4CP/SgQSIzgWCdatBOHys4VCmY6ywia3oszW5G35Lg49HsCqttYUY/Xt6XXW9vb8zQcshXLHsrx5cOkjLitMiADMH10fXwCe90b1o6a5s5v+HiKlvPqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199015)(66556008)(66946007)(66476007)(83380400001)(36756003)(6506007)(2906002)(86362001)(26005)(38100700002)(8676002)(4326008)(478600001)(6486002)(5660300002)(41300700001)(186003)(8936002)(1076003)(2616005)(6916009)(6666004)(316002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VPwN0nRVmxKv+1FikpH1mWKTfWAzEfEnzNkkkjJW2cqiOFBDvIPzjJ6f4nQ0?=
 =?us-ascii?Q?X+XpRMZ0v4FSwDUInCWJMrzupIm6FtlCZdR2quanv3DGx5n7A/pbfH86Vwa4?=
 =?us-ascii?Q?Zy1XlXfXKoJGAKS93a0IbIz6MX6fnrfZa8D8fiBY+R1Lc0k3ZWjEJkzf8apH?=
 =?us-ascii?Q?cyhPHxI0QNnTor6KA1NC+IhhvNEnTh/nVWkwr5XQr5aODwI9dkveLLLWseoA?=
 =?us-ascii?Q?cEMwrB90R12iwPD2vfLWaxXZZxiFwcoXc3l/xtaUUM+41Puj3/+cnJJjnLDe?=
 =?us-ascii?Q?v+legbi1pjYjzwHD4d5k2SvjzQF9ZbUezFzbZnTic11vlimWR8f0+8JEVgtW?=
 =?us-ascii?Q?VPaBLYnsTcgMY3MIFN02MQ1Y8/c7Kdd4Q3jZ/D0s9eGmioOvBK9HPD9xX3Uj?=
 =?us-ascii?Q?bUx0WXuEc4FtGcMcUIH2e4TSavWH66S+S5daIyFaRYcbSnVYbuBC9kiBNdlT?=
 =?us-ascii?Q?qz9TvJvsVlGSSC/sevSOSRVS0eaVDhZEe1T4skW8xCZp4aX/WRgjESqo3ElF?=
 =?us-ascii?Q?+0XlQhzUlfH8i0oYEUl3hfwTDpghyr/TguJEQLbfD3RTQ3mCCVds7MKoDOfQ?=
 =?us-ascii?Q?OT3aK9X7S2OUABnLFA+pZycFo9h6IIPndYp5j0WQ6368wFefUB02dde6m25s?=
 =?us-ascii?Q?SGsTcOAskYqeV6DF38GxkGLLTlAz5oL1dWuZ6S9Au6+EwFFybFQz0j14LZbP?=
 =?us-ascii?Q?qOJBU3UyadCDakGYxzoHP4dqiUgSlGDFzSyHcTllI3VFgoRkYeFcnUxzS/bH?=
 =?us-ascii?Q?c2Ju32n3wkf4SI92H9AxD3ib3ft2BeBdClJEig76FeplbcBotzzx/RBXMRN6?=
 =?us-ascii?Q?dfw8FH8oaDZIqmLoMDTibnBIgPb3b4seJxDhxP9CJz5XsT/kuaPWga/qa3UV?=
 =?us-ascii?Q?sOqrneUKdJ/jEldOCH2/usi88lx7H1WebNeKa4C2Jen+IA4WRmEIyeRXt+kJ?=
 =?us-ascii?Q?WUgV6ZLXQnGWPbLMACCgSoNn7ABqXC6sIZwzRrH1HtYXab4bqWStK1ntmM3u?=
 =?us-ascii?Q?vPVrln09MHy58ntxNYjMON1m5cObPmvA20bj1jm/s/51pr/7vyhdp7VYtsoX?=
 =?us-ascii?Q?dkmt/qxG9FiuXbDiRB8Vyb2U6dAtbC3w1sfZWSh3VXj3uyPMCzs4CYSoUg8/?=
 =?us-ascii?Q?0wNNYxxwazVC29AgEpY8h8uQAIxvMW1BKPyzpjmzgFOfHWd91hyIRolx5phY?=
 =?us-ascii?Q?AP2pF+zA5UOZqC806dBx6KWx8sKsifxF86DZUWyx4hOfSv55I/pHnUOiTbiD?=
 =?us-ascii?Q?h/7C4V5g9RJOHMAOoIZNYJRnlPRcow5ZruIywHwsBPwaBcuPMqk1j3I0zkvZ?=
 =?us-ascii?Q?PJJVHCGmoTzNHNgqwycZb57sDtijSC7iOLfAI5ERSlGzXVAQVsDYQ9qD4zM3?=
 =?us-ascii?Q?XRo4/UNAA8zOg7CJQVg3/y+Be9fW2hhUg/H4iHVGxwv25TBTDfslk9bKOKCF?=
 =?us-ascii?Q?nFXfH6Wb38xHwI/9IG9iMpK3Fn+B1luJf/FoJyGffZrX6v34ujio3Xv7XZXh?=
 =?us-ascii?Q?JLmj5nh0D6ZWKvoCyxmxDUBYbDUyoK96IEx5uNMRF5BmkzuZ0HiIWo0FFA8a?=
 =?us-ascii?Q?jRgi3mpV9H7bkfW5PfsNJCK7rVUE1H8UacAzoDXQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26d3ef1a-4ab9-49eb-ce90-08da9e2c696c
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:58:01.2865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w2Ih0ecYdoYN7spjiFqYyY7WuUYX6R2FOJOtNr2kiaBrGAtGB2cYx3z4iXHt0+oxTIvYm7lnB/XcWgwLFWYJ4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6249
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=782
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209240098
X-Proofpoint-GUID: GkLnR_DIhJeqhINYLTMxhuTgr2twl1Q5
X-Proofpoint-ORIG-GUID: GkLnR_DIhJeqhINYLTMxhuTgr2twl1Q5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: kaixuxia <xiakaixu1987@gmail.com>

commit 93597ae8dac0149b5c00b787cba6bf7ba213e666 upstream.

When target_ip exists in xfs_rename(), the xfs_dir_replace() call may
need to hold the AGF lock to allocate more blocks, and then invoking
the xfs_droplink() call to hold AGI lock to drop target_ip onto the
unlinked list, so we get the lock order AGF->AGI. This would break the
ordering constraint on AGI and AGF locking - inode allocation locks
the AGI, then can allocate a new extent for new inodes, locking the
AGF after the AGI.

In this patch we check whether the replace operation need more
blocks firstly. If so, acquire the agi lock firstly to preserve
locking order(AGI/AGF). Actually, the locking order problem only
occurs when we are locking the AGI/AGF of the same AG. For multiple
AGs the AGI lock will be released after the transaction committed.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: reword the comment]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.h    |  2 ++
 fs/xfs/libxfs/xfs_dir2_sf.c | 28 +++++++++++++++++++++++-----
 fs/xfs/xfs_inode.c          | 17 +++++++++++++++++
 3 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index f54244779492..01b1722333a9 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -124,6 +124,8 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
+extern bool xfs_dir2_sf_replace_needblock(struct xfs_inode *dp,
+				xfs_ino_t inum);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				struct xfs_name *name, xfs_ino_t inum,
 				xfs_extlen_t tot);
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index ae16ca7c422a..90eff6c2de7e 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -944,6 +944,27 @@ xfs_dir2_sf_removename(
 	return 0;
 }
 
+/*
+ * Check whether the sf dir replace operation need more blocks.
+ */
+bool
+xfs_dir2_sf_replace_needblock(
+	struct xfs_inode	*dp,
+	xfs_ino_t		inum)
+{
+	int			newsize;
+	struct xfs_dir2_sf_hdr	*sfp;
+
+	if (dp->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+		return false;
+
+	sfp = (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
+	newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
+
+	return inum > XFS_DIR2_MAX_SHORT_INUM &&
+	       sfp->i8count == 0 && newsize > XFS_IFORK_DSIZE(dp);
+}
+
 /*
  * Replace the inode number of an entry in a shortform directory.
  */
@@ -980,17 +1001,14 @@ xfs_dir2_sf_replace(
 	 */
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && sfp->i8count == 0) {
 		int	error;			/* error return value */
-		int	newsize;		/* new inode size */
 
-		newsize = dp->i_df.if_bytes + (sfp->count + 1) * XFS_INO64_DIFF;
 		/*
 		 * Won't fit as shortform, convert to block then do replace.
 		 */
-		if (newsize > XFS_IFORK_DSIZE(dp)) {
+		if (xfs_dir2_sf_replace_needblock(dp, args->inumber)) {
 			error = xfs_dir2_sf_to_block(args);
-			if (error) {
+			if (error)
 				return error;
-			}
 			return xfs_dir2_block_replace(args);
 		}
 		/*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 7a9048c4c2f9..8990be13a16c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3215,6 +3215,7 @@ xfs_rename(
 	struct xfs_trans	*tp;
 	struct xfs_inode	*wip = NULL;		/* whiteout inode */
 	struct xfs_inode	*inodes[__XFS_SORT_INODES];
+	struct xfs_buf		*agibp;
 	int			num_inodes = __XFS_SORT_INODES;
 	bool			new_parent = (src_dp != target_dp);
 	bool			src_is_directory = S_ISDIR(VFS_I(src_ip)->i_mode);
@@ -3379,6 +3380,22 @@ xfs_rename(
 		 * In case there is already an entry with the same
 		 * name at the destination directory, remove it first.
 		 */
+
+		/*
+		 * Check whether the replace operation will need to allocate
+		 * blocks.  This happens when the shortform directory lacks
+		 * space and we have to convert it to a block format directory.
+		 * When more blocks are necessary, we must lock the AGI first
+		 * to preserve locking order (AGI -> AGF).
+		 */
+		if (xfs_dir2_sf_replace_needblock(target_dp, src_ip->i_ino)) {
+			error = xfs_read_agi(mp, tp,
+					XFS_INO_TO_AGNO(mp, target_ip->i_ino),
+					&agibp);
+			if (error)
+				goto out_trans_cancel;
+		}
+
 		error = xfs_dir_replace(tp, target_dp, target_name,
 					src_ip->i_ino, spaceres);
 		if (error)
-- 
2.35.1

