Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5390C4F008F
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354314AbiDBK3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239094AbiDBK3t (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:29:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9D31AA059;
        Sat,  2 Apr 2022 03:27:53 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2321Vbu0016306;
        Sat, 2 Apr 2022 10:27:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=PQmOUo+IV13Wgfh0J9Ncr5pYQiQwhuJVLZUTzW1AjAM=;
 b=1Eu9/R/vnFW049eXnA3aMFTNF21z9EulTwOwt2NXWKV5u48qAvRCQJC/vrPcNJvPEPcz
 n4YVqGD/N3wODmFgvGKj6j0CE0Rrq3pV0S1fUlLholSY+JCg3LbeO9ZSRgkE7P5tz2CU
 XcpyBG9CktNzNelqrekbn8cLkLfDlB+lYzNF4JPkv8H32gJe27nYz4wFljmHtR/Uf9bQ
 2JziSEpvcklyy5EoIolKHDJtzHNQEzAaa/mYayXCKY7OcJf8nA/a0Ah1KcsU/0cLHwNA
 ufTp+UsNqigHxkZqtmr6Dm6Rv+aUw9ofps/A9X5pulmzc2guBgxOTEiyPQ3pYRZ7bh9O cA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwc8cq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:27:48 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232AKVFQ001694;
        Sat, 2 Apr 2022 10:27:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx16jqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:27:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jJ51ukDbEABmjurfmB2cqd6Mkz5/Frc9LOr1H4ildX916/jMiCGdK5IwyDjoF52fn8qugt6QjKKpD1rXOj5vyG8InrhcRBomGheeqJK07uB0KN5HeAd4nXQadLUnYtX8PIY5vHpW4WomkylD4V7LgrJD2V2Pg34OrJCPoxsdmzeimD9A5kynTI7DXLlNcwDnRzmtD0Ze0WG9cakXUAbEbC6R7NE7Jx8zkd6LRPetedVDvNyo0kgWkbqWI4AkRXKP9ulyOGASnl5xdDXY0sWW7CWWY9fBWCqL9Z/ERoWx0BhFErsRINsxioh3LEV7jNlLsngESzEi9gqQZSkeB4iYTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQmOUo+IV13Wgfh0J9Ncr5pYQiQwhuJVLZUTzW1AjAM=;
 b=fWmh0SFkfymjH5kq33JU+Dt6aBZgL6d98jRf4g8LkLvqDZYRl7rxm+Hwh9z+HtG9sAF9NwfVBbtmjvBs0DuFtEAStQDx4qWmJHNWNFZLpmHu1Ph2OApIm57fQPesFKFDOCKL6Saq94ut2KCWP6QZ4rfzp6g+vk2tiL+Ls+pja2Wye7IzHPSk6vWVlffADGbS7GfT4DRZqR2hVpIbCTFpGEl/O1HmkLNtZbLS9+PD1+/kDB/YVh5hg4DYwlv8NDzqHcdoWCvxLZtNkQZN4bKUsfgLt/swQd7U+pYPRWqasTQEH+EeTn6AUJhuZxGxUI8qhFV4XXkEoy6tdI2FoFeYcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQmOUo+IV13Wgfh0J9Ncr5pYQiQwhuJVLZUTzW1AjAM=;
 b=X6QmxPtN03+LucNjf8KdOmDuroP24VHhvSLgVQ87yw2TVOV6s6pn6JvH6o0ppqLPSeQ4g2Y5F0o6Nl6m9qFubksVsgduPSd5L8f57Xlq2TkeeZLbFvSycEzcm9GSNqoioDMBdCMKonHaXUXK4FnkuH+Y3VModorRw5dNJZ2tn/0=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:27:45 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:27:44 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 12/17 stable-5.15.y] iomap: Add done_before argument to iomap_dio_rw
Date:   Sat,  2 Apr 2022 18:25:49 +0800
Message-Id: <5786df1bcdf13c6da31f78e8f8d9e6753ae65f75.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:3:18::15) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbb0263a-7052-43af-1e5b-08da14936cea
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB30492B2987B673665254BE89E5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9lsr/d5wzJKJrltMLI7vdXLuEY1Ia3eiIjzaoQKVEKTIa3MRfByiriXVeyT+U4BOR+h6U13LSmMHy8op08lY/OUHhZ2QuWgEQtg+eHjU+Tt/4NVRfDmPou/dpBgMBEsP7XSbsKO4k6RF7dj4BPkxTUgxCSgcBqMWgiizISIY17PaIUvzlTpYajgP+QXhgLnLK/LaoYJ42Wie/Mzmv4J7r2a/cEgmLYdP6CS6qij6ATMauijZA8G5J6+F2vufOE2D388zq3xCvY4oCaVFmmkZcZd2Y4BVuoWej0JuA4dTGpXlliQGMYoVx0IiVG9A9UxVcLa5tN8OhYbTrJItud+6A3tSlx5MxeEvfiSXTSLmg6WqVMI3MnexuUp+h6gMSK3fsLqv2K0EI5JMSDw5SPkvrH6NKIc1Bwsh/ABnAtxZEpK5RANZ1YN6dhIgUQBnDenVFIq6OxLtKCbNlzAzK+wDGiWmOQOippp70VvbdbRR6lVkVJTm6j6Okbd8H4bcrig3PoWudsv4hLsnd+5rAeia9TL1E70FOrwDleiTI9ZX5tvONKgBq6XDD6UA0TBP9E8DipcW/L4OOxLDPiCBsgE5oKknW7C0lXVDshMKmsW/DUZMnukaQswRmq9cTsW5iwGgxztfiHnVn0hbtczK/dLgSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(38100700002)(83380400001)(316002)(508600001)(6512007)(36756003)(86362001)(26005)(6486002)(44832011)(66476007)(6506007)(54906003)(2616005)(4326008)(186003)(6916009)(66946007)(107886003)(66556008)(5660300002)(8676002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dTpKHp13EqOSBDHyDq+ry64ptEvdl9YOB1vypC/ToXZ1reURHqdVHIxH2jjs?=
 =?us-ascii?Q?V8X2LYRZLjJ89+a/YClJ/gBKQXzT8M8gOUHbMOGdPLia6ATNQTqEVjsdT/c8?=
 =?us-ascii?Q?7sJ/BTleGy8PZpdV9VDM1c2v3I2gUzfSRD1T3kdZqW7rmRvpkupFAWhixdHl?=
 =?us-ascii?Q?qEKdVvfxGAay6PPagl4FUnqWcrHdS9+b1A8UxWuxC8dtsVEyqDDC8DpVcTjk?=
 =?us-ascii?Q?MBgtlKfRL3q42OkIEjpf7mEpjnLH+2rF5kkEKE2eVaiiZc4Lnyidj6LhQI8u?=
 =?us-ascii?Q?kakVeNKLMfvQc+yQCk6V9Ldg4U4LXtmtZQnRxqbEtmK9MEWzMeUftO+ZadI0?=
 =?us-ascii?Q?iclXVrk2sFS59f8My9HxmIVk6XxjXYUFvjHPZARl3DfQzcczxP11mWzYqQK/?=
 =?us-ascii?Q?LQ9u/bJsbHIV+jRDMfddpRWK+sN0k0iunwFqKV0OOcbR0cpG5BnzDJGULNGZ?=
 =?us-ascii?Q?eVh+7M2A47PexTze7tUEjL4af/LbX0fzac4CdrYbHSV8DLrsfCHiU0tm0uL5?=
 =?us-ascii?Q?XG1eQsutgH0XIrG2DjctvE3qlSfKsjgI+/2myxQZP0jPzf8RTM45P3TrOuuV?=
 =?us-ascii?Q?eXpdiRFXvlOsUpqP70qlCUAcPs3fNNxUReSpDA+66O+x/SR7YUBOjeF6hN6W?=
 =?us-ascii?Q?kie2Wih8r31orWiPq4SwE6eq0IIfsG7AozzFY0yP8BIRIukuRqCaactLxvJR?=
 =?us-ascii?Q?qyY/L/FSwcHTGzLp8ksKOWv9Bo8VthLPGB90vBwz/HF4Ds+eMJtiaRzqB01l?=
 =?us-ascii?Q?AEgrDV5hAALLadCZyPJ3Sw41dPFLiNa1OuxF52pxSd3jFKLZNS9GuM6+1UBY?=
 =?us-ascii?Q?04/10bt0/rPyaslA6rcIU3Dd+bEze0ggSiDsj5ZQKHJ7Crswtzwqt57N+S0/?=
 =?us-ascii?Q?O9t7Qohf8QkjHvXF6TPlMyrxQU51zEtWCcZ8VThWKSUT0gr8mBhxPL8G66vc?=
 =?us-ascii?Q?2jbA6xBi38W3JCUTM3VIgmuCtyRiQPbs6TD2WjY+O6FyhCas7Y09SwYNP3NK?=
 =?us-ascii?Q?57Khy7tr41tIJSsjMBJCASk2B1x8m+p4hdMQnOIo1WGbWrGVwCPn1PKqIeck?=
 =?us-ascii?Q?7F3xEvse9iAC829nJZW5tMS73oTikLx7flv1HFkrYSa5a/0zakp7smG+5hzP?=
 =?us-ascii?Q?B9Xh63ZmzjLI4chmVypA9pOdcm6eh+RKdMN0oh6VWKHgCyxBZLpWZA1AYUUz?=
 =?us-ascii?Q?3pvFahUfm6SlkkhlRLKhJNc58T26VphlNgJmVGmi9dGGA02UtuyeKaiN5EVt?=
 =?us-ascii?Q?h4VdSBEHJl1jH2OUI3+Yd1XYlWe4c0jFd1U7IzhHz7/VMVkXvBlJ0uPCX4iv?=
 =?us-ascii?Q?Tuoia8mjAL8FO6vYiS6q4CrddcFP2HhX1M4A8x46sDRu5nGR190Wt0xKI+GX?=
 =?us-ascii?Q?lYEgkMfGA4ly9coNuUyCvvM7uYY/aT6Il86VaA1rISMdmc8tOPx7cjoxROWL?=
 =?us-ascii?Q?Zgi6PkhbvDpSKAkOnivL4MP0bMV/EmslyOUKndfO/uDvDZ8VM9NgZ9n5qCl5?=
 =?us-ascii?Q?WOZvhaJZsi0YahVLxitCQAX+d+KUDUMYrSEPzl1uLsnruO0ukK27rttiIkz7?=
 =?us-ascii?Q?RkoGKOzhmVmK9eRBtz8O+qZLyPDzEHP4oV7KW4rb951cQ4i9V3ilINhsql8L?=
 =?us-ascii?Q?G679yhlTL5hEUA6goUfBKlWCe1O2DvvZlCXZPbWS7IMr0mq7nMi6X1+FDDAL?=
 =?us-ascii?Q?V+4YuToBM43R6AfHxmDWJmWFIFIjLkjfLNYOBVQZCP21F9+CeEwctiYYEwwZ?=
 =?us-ascii?Q?TparQljS/B9+E1UhGRW8O32GnyBtFZk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbb0263a-7052-43af-1e5b-08da14936cea
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:27:44.8877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LVwUmE3b4Gj3JlTOG+LGUJqTxk+6UhV0htCAsTzE5vKI/JW+mdLPXPazo+Tsb57dEHnfvkTsltHvbCcfv18K6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204020064
X-Proofpoint-ORIG-GUID: chBeAaeY773Urdfl4ujfAHdA9RyQnTua
X-Proofpoint-GUID: chBeAaeY773Urdfl4ujfAHdA9RyQnTua
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

commit 4fdccaa0d184c202f98d73b24e3ec8eeee88ab8d upstream

Add a done_before argument to iomap_dio_rw that indicates how much of
the request has already been transferred.  When the request succeeds, we
report that done_before additional bytes were tranferred.  This is
useful for finishing a request asynchronously when part of the request
has already been completed synchronously.

We'll use that to allow iomap_dio_rw to be used with page faults
disabled: when a page fault occurs while submitting a request, we
synchronously complete the part of the request that has already been
submitted.  The caller can then take care of the page fault and call
iomap_dio_rw again for the rest of the request, passing in the number of
bytes already tranferred.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/file.c       |  5 +++--
 fs/erofs/data.c       |  2 +-
 fs/ext4/file.c        |  5 +++--
 fs/gfs2/file.c        |  4 ++--
 fs/iomap/direct-io.c  | 19 ++++++++++++++++---
 fs/xfs/xfs_file.c     |  6 +++---
 fs/zonefs/super.c     |  4 ++--
 include/linux/iomap.h |  4 ++--
 8 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 5bf4304366e9..cd4950476366 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1956,7 +1956,7 @@ static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	dio = __iomap_dio_rw(iocb, from, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
-			     0);
+			     0, 0);
 
 	btrfs_inode_unlock(inode, ilock_flags);
 
@@ -3659,7 +3659,8 @@ static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
 		return 0;
 
 	btrfs_inode_lock(inode, BTRFS_ILOCK_SHARED);
-	ret = iomap_dio_rw(iocb, to, &btrfs_dio_iomap_ops, &btrfs_dio_ops, 0);
+	ret = iomap_dio_rw(iocb, to, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
+			   0, 0);
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
 	return ret;
 }
diff --git a/fs/erofs/data.c b/fs/erofs/data.c
index 9db829715652..16a41d0db55a 100644
--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -287,7 +287,7 @@ static ssize_t erofs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 		if (!err)
 			return iomap_dio_rw(iocb, to, &erofs_iomap_ops,
-					    NULL, 0);
+					    NULL, 0, 0);
 		if (err < 0)
 			return err;
 	}
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index ac0e11bbb445..b25c1f8f7c4f 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -74,7 +74,7 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		return generic_file_read_iter(iocb, to);
 	}
 
-	ret = iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0);
+	ret = iomap_dio_rw(iocb, to, &ext4_iomap_ops, NULL, 0, 0);
 	inode_unlock_shared(inode);
 
 	file_accessed(iocb->ki_filp);
@@ -566,7 +566,8 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	if (ilock_shared)
 		iomap_ops = &ext4_iomap_overwrite_ops;
 	ret = iomap_dio_rw(iocb, from, iomap_ops, &ext4_dio_write_ops,
-			   (unaligned_io || extend) ? IOMAP_DIO_FORCE_WAIT : 0);
+			   (unaligned_io || extend) ? IOMAP_DIO_FORCE_WAIT : 0,
+			   0);
 	if (ret == -ENOTBLK)
 		ret = 0;
 
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 2565cdb36332..aaeb0e9bc04d 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -823,7 +823,7 @@ static ssize_t gfs2_file_direct_read(struct kiocb *iocb, struct iov_iter *to,
 	if (ret)
 		goto out_uninit;
 
-	ret = iomap_dio_rw(iocb, to, &gfs2_iomap_ops, NULL, 0);
+	ret = iomap_dio_rw(iocb, to, &gfs2_iomap_ops, NULL, 0, 0);
 	gfs2_glock_dq(gh);
 out_uninit:
 	gfs2_holder_uninit(gh);
@@ -857,7 +857,7 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
 	if (offset + len > i_size_read(&ip->i_inode))
 		goto out;
 
-	ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL, 0);
+	ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL, 0, 0);
 	if (ret == -ENOTBLK)
 		ret = 0;
 out:
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index a434fb7887b2..468dcbba45bc 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -31,6 +31,7 @@ struct iomap_dio {
 	atomic_t		ref;
 	unsigned		flags;
 	int			error;
+	size_t			done_before;
 	bool			wait_for_completion;
 
 	union {
@@ -124,6 +125,9 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
 	if (ret > 0 && (dio->flags & IOMAP_DIO_NEED_SYNC))
 		ret = generic_write_sync(iocb, ret);
 
+	if (ret > 0)
+		ret += dio->done_before;
+
 	kfree(dio);
 
 	return ret;
@@ -450,13 +454,21 @@ static loff_t iomap_dio_iter(const struct iomap_iter *iter,
  * may be pure data writes. In that case, we still need to do a full data sync
  * completion.
  *
+ * When page faults are disabled and @dio_flags includes IOMAP_DIO_PARTIAL,
+ * __iomap_dio_rw can return a partial result if it encounters a non-resident
+ * page in @iter after preparing a transfer.  In that case, the non-resident
+ * pages can be faulted in and the request resumed with @done_before set to the
+ * number of bytes previously transferred.  The request will then complete with
+ * the correct total number of bytes transferred; this is essential for
+ * completing partial requests asynchronously.
+ *
  * Returns -ENOTBLK In case of a page invalidation invalidation failure for
  * writes.  The callers needs to fall back to buffered I/O in this case.
  */
 struct iomap_dio *
 __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
-		unsigned int dio_flags)
+		unsigned int dio_flags, size_t done_before)
 {
 	struct address_space *mapping = iocb->ki_filp->f_mapping;
 	struct inode *inode = file_inode(iocb->ki_filp);
@@ -486,6 +498,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	dio->dops = dops;
 	dio->error = 0;
 	dio->flags = 0;
+	dio->done_before = done_before;
 
 	dio->submit.iter = iter;
 	dio->submit.waiter = current;
@@ -652,11 +665,11 @@ EXPORT_SYMBOL_GPL(__iomap_dio_rw);
 ssize_t
 iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
-		unsigned int dio_flags)
+		unsigned int dio_flags, size_t done_before)
 {
 	struct iomap_dio *dio;
 
-	dio = __iomap_dio_rw(iocb, iter, ops, dops, dio_flags);
+	dio = __iomap_dio_rw(iocb, iter, ops, dops, dio_flags, done_before);
 	if (IS_ERR_OR_NULL(dio))
 		return PTR_ERR_OR_ZERO(dio);
 	return iomap_dio_complete(dio);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7aa943edfc02..240eb932c014 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -259,7 +259,7 @@ xfs_file_dio_read(
 	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
 	if (ret)
 		return ret;
-	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL, 0);
+	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL, 0, 0);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	return ret;
@@ -569,7 +569,7 @@ xfs_file_dio_write_aligned(
 	}
 	trace_xfs_file_direct_write(iocb, from);
 	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
-			   &xfs_dio_write_ops, 0);
+			   &xfs_dio_write_ops, 0, 0);
 out_unlock:
 	if (iolock)
 		xfs_iunlock(ip, iolock);
@@ -647,7 +647,7 @@ xfs_file_dio_write_unaligned(
 
 	trace_xfs_file_direct_write(iocb, from);
 	ret = iomap_dio_rw(iocb, from, &xfs_direct_write_iomap_ops,
-			   &xfs_dio_write_ops, flags);
+			   &xfs_dio_write_ops, flags, 0);
 
 	/*
 	 * Retry unaligned I/O with exclusive blocking semantics if the DIO
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 807f33553a8e..bced33b76bea 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -852,7 +852,7 @@ static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
 		ret = zonefs_file_dio_append(iocb, from);
 	else
 		ret = iomap_dio_rw(iocb, from, &zonefs_iomap_ops,
-				   &zonefs_write_dio_ops, 0);
+				   &zonefs_write_dio_ops, 0, 0);
 	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ &&
 	    (ret > 0 || ret == -EIOCBQUEUED)) {
 		if (ret > 0)
@@ -987,7 +987,7 @@ static ssize_t zonefs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		}
 		file_accessed(iocb->ki_filp);
 		ret = iomap_dio_rw(iocb, to, &zonefs_iomap_ops,
-				   &zonefs_read_dio_ops, 0);
+				   &zonefs_read_dio_ops, 0, 0);
 	} else {
 		ret = generic_file_read_iter(iocb, to);
 		if (ret == -EIO)
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 2a213b0d1e1f..829f2325ecba 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -339,10 +339,10 @@ struct iomap_dio_ops {
 
 ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
-		unsigned int dio_flags);
+		unsigned int dio_flags, size_t done_before);
 struct iomap_dio *__iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
-		unsigned int dio_flags);
+		unsigned int dio_flags, size_t done_before);
 ssize_t iomap_dio_complete(struct iomap_dio *dio);
 int iomap_dio_iopoll(struct kiocb *kiocb, bool spin);
 
-- 
2.33.1

