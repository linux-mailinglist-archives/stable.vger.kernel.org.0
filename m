Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169814FCEC8
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347764AbiDLFTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344726AbiDLFTQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:19:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947D93465E;
        Mon, 11 Apr 2022 22:17:00 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C1kKnj012649;
        Tue, 12 Apr 2022 05:16:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=fniwVvOEnjVKx9xl+H1/NiS+KSAJHHGhJgiKJNQ7Tk8=;
 b=g9pPeqlZi2yFw+xE/OSM0HtRwaN3sKKJA3lDSwxuZqOCCEC32jgIg4Yr1myYzJMWzq+u
 lLwth8f9OnokII7vpcBGxJeNvAbwX1GXDiw+0AFgIVzvXgNpCQE4RIpJWiyU6xtCY27w
 w//06+3x3IuGwy/vhbliLr4C5y0asoAxJVOB5EU6XTLnv8rIGDTMMNQ1xfr4SXHVET2y
 F9dCw53u1mHzyqvP8Cg63XYAVnpJf8hfeUDn3sEujSQaY+an35toFktmd8Fe/YkHaWaZ
 qfIE+KgmRcVDSO6TRAaDlq2obmys5Oba0+yIDud87TnMk9L6ffU38vXRsw/X50K2cKuy 3Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb2ptwnsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:16:55 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5GNcX039690;
        Tue, 12 Apr 2022 05:16:54 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fck129f37-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:16:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MOVm7c6/s7Sfq3yd5kpHEdgJmYFX9T56vFRS+6z9pDT4gErxxEEjWK2OtB3RlthqlnTVm20lBo9WeBZQydI7umhPM3/9hOxFkRlxbdhvXbhhsh8rntRLbY0+PixP+ip0cLLBp3B2UUijxj7hHtQqyaRr5YuCwSVyiFNet7+0BxsdrbyGuFRZsjIHPYH80xLg70dmZqHlzhwtA/HgsonRv1QoBu91vhRw81UeNVcXO/sg4aUTqxgtLxxBgIYSwESzTJXV7Md1R6ivtwqhDgJ7kKCTXUIYMhY2cqKq9DfiS5xK/X6qfhefzRStmA74vKHEZsK/G9ZnAx7XiM3TBw946Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fniwVvOEnjVKx9xl+H1/NiS+KSAJHHGhJgiKJNQ7Tk8=;
 b=hI/XE78uxCxBorfD2vJpcsYSAadECVBJbXhO/h3M+ULM2Kbps0kJtF+6Es1KJ60qVik0Zyy/B+PLMYw680hZRpp0bpoHE4H63wvAt387mCcOOR8QI7Cpe2Pu9WYNOxxjPXyBoWSP+U/yhzl3NkEl3TO4aCAtY2DFy8yz5nU4fFU05/M4ozoInVqBMHYnkpuX9zt3InCGNlkRkat0Kg0C2jL6EZCG9vwei2W5h9RPvvJkB1+gfuJLfcJL1MACzDGEz9YLsUvcHXlGbKd5hwoyYJmgjudM7g1x15RXqopNe8xjauuzREjlcsLUvaPu3tDzUrkAEbiV1ypRDxrvSHnKdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fniwVvOEnjVKx9xl+H1/NiS+KSAJHHGhJgiKJNQ7Tk8=;
 b=pBfDyFRNqdgJ1QRKYa+P9rq3ThE855pvSOX2+Zfd1+syQc6fGjUug+LiZZt7UQHCxjWoSav86AW4sVHx450OPZZ9UYszVGf6zcfnZ9dHaMtf0P5kOwU2rRHuiFeHevX8XsPUTCIN+XdiepNXwN4l3NjyX3beVT99g8UvUZcu6fM=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BN8PR10MB3329.namprd10.prod.outlook.com (2603:10b6:408:cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:16:52 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:16:52 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 11/18 stable-5.15.y] iomap: Add done_before argument to iomap_dio_rw
Date:   Tue, 12 Apr 2022 13:15:08 +0800
Message-Id: <df198a1c02c4f942414a424be3c04edad80b8fb8.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:3:18::32) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0b430a6-3ad4-4092-e8ed-08da1c43a72b
X-MS-TrafficTypeDiagnostic: BN8PR10MB3329:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB33295EAFA9E49AB0BE3A4F1DE5ED9@BN8PR10MB3329.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lUSmPPihBaY8qeHjXQJZ6uyv0ENk1APi0LpzVd0Q+Le+Z12fwTZLE8vJhtG0LhjI1h3DjjPBk0rdLclu7bim7tk6aHLRtPv0si/uMntQ1+qQSRSOvpwlRf8eKKiyu9SmxwMc+o0ysjgjxKl36KmL8YzBYUIgXVo9fHsSR7DrqOzbr26ySOo1GH/NTdNSLZ6aftCh8mMufFo0YYWxs3UdG7tUwebdu1YD/Nnlcuqla7JhSvTRVB5J5B+LTYzm0MUTg8wHLKh4eHVKbMXSqP/w/4Wu2rV/1Lb5iSjpe5ISImYk7Vib35yA6BcYnFI+9mlXHPgyGxDiOzzHRtVJAbz+lImym74McakVri3hLtFsP9CvUY0k5hm7nWoqVICqIyqFe2aXXV7Vu/7g5Ymm0v585rFCxTKccKRzd0t6ZXSWnUWcNT4/IR7K6MS4Feo60kncLlgL7vwRTefsT0NI7xtWpAQVTSP4ERNltZE45W5Chxeixp80/s9YodmHhAHSrGBmbzDSsCKZ5GHV1tIJd8k9TVkQfUUyoyFgaoN1LRax4YH6oA66Cs2RXz0CFzVYOpSI55JestgtEhsWdToJEs7kIzDtYmZvxgouCiTlHhV1ngVS8pejU7mh+MxzQMvLZpiIwWJVETfXWCNM6WVy9kDeJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6506007)(86362001)(38100700002)(54906003)(6916009)(316002)(6486002)(508600001)(6512007)(2906002)(6666004)(5660300002)(107886003)(2616005)(83380400001)(8676002)(66476007)(186003)(66946007)(66556008)(44832011)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FafFrDt+uOq2oE51vmXpqscudFsTpskO3tKfk4E6cRZvVkRuwBza8o/8G36O?=
 =?us-ascii?Q?+noSuJpIkWYqVODiKiHdSptXjtFWxhyDBcGJ8aZA2P6Y3rLslm2cCkCNAAYK?=
 =?us-ascii?Q?mAoYBhJGHhqtbyNJyA3/3knMKhAVeXzf9I+4sgD9ZftlJOJZiIFPO24eYHVJ?=
 =?us-ascii?Q?hGk3uZkUx2Gfve0yMM/GE3wBLzlcMWNUHTitKNCVZPlIXX/q4t3bPS1sXFoj?=
 =?us-ascii?Q?NxEaVEd/h1w/fMZLovyA1KfE7CvtGVmMexpuqTbDyLRnPFfq84qNdgsCVt+j?=
 =?us-ascii?Q?zSp/LYHChH3VF2G+Vjzabv7OH+H9z8Iz7tBuuXFjH548PLkmE2Io0Kl64mvC?=
 =?us-ascii?Q?W0jHgBNO5JESEg2m8obFHz58a53GQmQ6lT79SnRaUWDKyMLaRKOAjQNJk5Oy?=
 =?us-ascii?Q?eUC7hUMtr1AbLyQ7Dj5jOxEuOAN1ICOETLABH3kbkZjex/6wSzSR8lWVQLSf?=
 =?us-ascii?Q?bRwtfB71e/XuJ284E4rXWIWZQzt4QJQ7HkVtVEDLdfG3Q5xQ1vsBFTVz2BAl?=
 =?us-ascii?Q?RLW+uewy2USOFqMFNoIDM0lODF0EgPiJPyyn/ewz3R4FZtwl/ZJ34U3dPZ9v?=
 =?us-ascii?Q?9BN/Q6WNXfXIs5g8N/WT7hXo3WGUpgHP8KJFuDCcVGLrsLuf6O2MaZ9X7BWs?=
 =?us-ascii?Q?osutB2WOiVpHicyVhtKiGapZiPnvWSKA3ObDRq+T9Ly2ad86/qYUEQG+4cAO?=
 =?us-ascii?Q?gZcOFahs4ra66sEmDic8juzW8VrrVOx8W5DTT94003Rlphg0/wQdEtvaGdB3?=
 =?us-ascii?Q?W7nJU0tPgoSj0XPnbPevCcnrWKZFZSCMYQK35nZSDJlz1D0m1qPoksInCzF/?=
 =?us-ascii?Q?FPEBBc/wCdGJmOA2tCtPpbwZuvyGnl49VZ0WM4euAHBWu0MCekVRud1p8a0V?=
 =?us-ascii?Q?9XbVpykg/EOWRqezXiw0m2LmJoMkTzLED0TH8it0l1JJvIQrNl+GGDwZlcd7?=
 =?us-ascii?Q?/mqU7Pawkso7Y3o0fqor/PJBIwzebHzCOG7MbDI07Ywl/C4pxPREed5vwqOL?=
 =?us-ascii?Q?jFJ4kbP4iAR+7z3yhA0dnQH+rE7dxG0wY7w2t7jmQpGatT8gH8nylbPAtfn0?=
 =?us-ascii?Q?jgvxkrlChJlBJAQG3YfDGtAtpi8FCVdn3VW1mbl9UZHS0dFVpQLHm+8xoCtQ?=
 =?us-ascii?Q?33Vx6bzZLBAhVYVInS2wiv4BC9WfV40HvZtuvVcxatCtWnwARz453kLHmH9m?=
 =?us-ascii?Q?32d52Sd6o4aHew5gFsfeTFSztB5RUrSbOyABrYLFK2BwdVgZHUPFE3ICCxdc?=
 =?us-ascii?Q?oEIR60cQxi7K0mIFt9AOZkpKxVNNeGb79bet5vXC2lPGaaK8G4chM2ZKc6xE?=
 =?us-ascii?Q?9qPiQxbXepVCC1AbEKcN6GZobzWc9RDlODFg9CS7voh7RVCfxPMOios7hrIQ?=
 =?us-ascii?Q?rTxxzg/aq0CKeuLG5VZ0SqFzhjEm4E45B+9ONj4Pg7v6i6fQiwAm4MY0uiZg?=
 =?us-ascii?Q?RGrVTZyL4aXbdqFOsbE2lhMkrA2+CnLkzMM0Kcrxny+6aVSRqYlw23pr+Bgc?=
 =?us-ascii?Q?+YgDXO31rJHN4xs09rrzh6GNZkQdBAhdhDV/ddGTT90i69kFPzBk3SdpF3M+?=
 =?us-ascii?Q?vFPYWUe/OfmyO7GKae2xr8vrZwDlW5NatRAyltzz0uoo8J5f9pux0/qyJJnu?=
 =?us-ascii?Q?29TbgMru/ZCJoxZ9Qyk836WBaOkPF4tIkTER6C+1waxOy10j7DnGCNAO6SI4?=
 =?us-ascii?Q?ltnz9i6P3nAjeU+Nb1hl/OVZOTlr/Ozyx6qD/ZgfJxqm2pKxfHBAQXwq1Epr?=
 =?us-ascii?Q?QenmyheFJ4MpHMK5jGGKe4fxNaAmyhwH+E/SAdrGFbotYEg9ozit?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0b430a6-3ad4-4092-e8ed-08da1c43a72b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:16:52.2217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UMU2hbcugQQdy4fdbBUOFDp0M0BsCp2lwwxO0qp7eVeSc3rqJ8Ws8j99abL21NWOht7J6zV3waZlXbnd8n41nA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3329
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120024
X-Proofpoint-ORIG-GUID: hsLmIBNaBFevmqBXWJnnSx63C8k6A_nv
X-Proofpoint-GUID: hsLmIBNaBFevmqBXWJnnSx63C8k6A_nv
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
index 2d0aa55205ed..81835d34d6f6 100644
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

