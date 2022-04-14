Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E74F501E6E
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343983AbiDNWdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347118AbiDNWdC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:33:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C018C5592;
        Thu, 14 Apr 2022 15:30:35 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EKkvG3006846;
        Thu, 14 Apr 2022 22:30:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=fniwVvOEnjVKx9xl+H1/NiS+KSAJHHGhJgiKJNQ7Tk8=;
 b=UbS/2mgOvDRVrL6smuNPjlVMKvZ528SrT492wM8M+zRy1rVg/S9X+WIY0JV6rE8Xfk2r
 NLy+645gdWljmghFeMwL8HU8x8+emekWuATnAknHkcrABnxc80SDXM03Nq0boLU8S70n
 qoB8L9zFZeodRLcUkI8wE+5pmydrWkpNol83R9vkdOWmzrx59jaaxOs/IQF4nI8ReNTB
 NPcAL28oELZlLrMeW8Wae0WVScq6P+WvsW+31dIQp/iPxyUlX1VKBh5a3miQ7BHcGNDz
 OvXYpQpTg4dduOXDmM1rHfFj6Tgg0fpSGqBOvlLqE6f+yXXxwfsW+Alg1lGHmAHt2064 hg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb1rse6x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMHWLV014862;
        Thu, 14 Apr 2022 22:30:30 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k5ucra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mBw3EiXaOvBv/lUHZeHGG+LoVMiU+G4fkJcqbIn9/36FXIl9i1ZFzGzwUT0nOs1RThnI0SDZ9vj3aMUFi0Hw5e811RTTvaewQIairF3s96D2Zf1yIlhXNVToKZ9NQvIt3GRc/QLrst1mWF/rY9nYzf6axJDWzjdLvH5pm7FAqsdvCNGLGMVYUnZ4K+pgv4U9Bym5JZhZErJLJ5pFxRNHNCb60sWoyB9sGix9cFfVq4Y38guRaUUX0q3WIvF56rBqT959LwiDPQeJWRtoxMGNtk9ZawPord4nyIUftNZMypnIEoEDgnmUFo/bwNnW85JCdmQVQ/sT8fIfVJeqpn8PuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fniwVvOEnjVKx9xl+H1/NiS+KSAJHHGhJgiKJNQ7Tk8=;
 b=Q+KGN9sxegC/pNMtTTA/VMV+X1wpg6IZ9WTro3qX4usL2sbFF4VNFkhyXFzeGJfctzIQ3wNevoTG5zwe12nN0OROoNqJVzsphATy63hM+sgjhywvzXBp6GeqMBWTNNBob+ZGwmR3Qhw7ggEkDQFHA9rRB7T8Y6QlxopNejwLcWj7UWlHr4IG1bwpEokfBvVWH1nZrIxviUBSssibeY+ayH1OMR26muet08TXQwwZ6PilyVoJQePoyYfbP6tSPeCNpN9sIXDXZvjQ8imNMh+/8f8kInJ3SM7Yp24UAJ6JGI/48wb6MhACXlR2IKmqrVyMwdCjTCxEo7UIu37Py6IK9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fniwVvOEnjVKx9xl+H1/NiS+KSAJHHGhJgiKJNQ7Tk8=;
 b=p4gGZYwczOUyU2wlDAcdC+21WxYlBtJW0uVqrGksQkiEJ3JHR9PqzgdmLUjhcVA80I5jS/Z6SZUPxSXUGIsuxSlZ0vMDDDNnYOGNoSZdei1wiSI8Ha9Z+yruLUhMrSCb3KLw/B15WTZEZ+iSMdCmlhd4JQy6OamTvNqyOmjp+s8=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by CO6PR10MB5572.namprd10.prod.outlook.com (2603:10b6:303:147::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 22:30:28 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:30:28 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 12/18 stable-5.15.y] iomap: Add done_before argument to iomap_dio_rw
Date:   Fri, 15 Apr 2022 06:28:50 +0800
Message-Id: <db3340e7b4b9e65960ecdd2c4e1b08f3fe5a09ec.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0005.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::23) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 034656de-ff7f-4dc5-8777-08da1e666057
X-MS-TrafficTypeDiagnostic: CO6PR10MB5572:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB557222B8FA8B92954C258E87E5EF9@CO6PR10MB5572.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BTHWrrT5YXaLiZml9PMyn1Hsv0S3WGCO6wKFu9amBc/97Kb+B/asUMPHCXQKZvUA7NgaWR30Uyx8s5YkamqTKe6mhYyRXb9dBgKnG4UdxBjNHYmduEmrTJQ71lH49hJhsrZKSQEVrwr7diKR5kEDP9lvKwsX2Q/HA+qivXdbr5xf5r16hmQcB67fO/GP99zxw1apk58q2eIY16IpLkdwFoVs/aojyPJx8CYCxiYZM/2DtzWrNBTOc/pzxbGKOgAgdXoGpijEvkow0a+89L9UtCgWggKuMsmUo8vzg0tAKwpyOTv2TTBIpkSIx9Ls/Z6/Z4kZ8JnppyRZpIlAxWT6ADPKyopn3Z8QZmkgQlkp7pByQGKNxGskN60o5fJ7wr0GUmHmbrOzFLRZOUQSt/klella7RQS2ptWBO26W2pQVnKQuQlQ2rD4nmiwa8MK0RXJ4jEXWwsxvPypPR9deTotL34hpixY4orEVwW6NkgItIuivdSsSTnkA4ICIH+UjxkyxIw4dbTpTnGygulPbaLf9aKQR9yuFNE9sy+vD/gVXYWlPH4x1StsbvzeMXXuxoRUne/n032fxv0b2Fhl5qNLpPaoTf+BwCz6KyqU8oNX633K9FshRv4uLRqZ1wYSSN0VfoWZ9m265W1aWTFzU3KUUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(38100700002)(86362001)(6512007)(6506007)(2906002)(4326008)(36756003)(66556008)(66476007)(66946007)(508600001)(8676002)(6486002)(44832011)(83380400001)(107886003)(8936002)(6916009)(5660300002)(316002)(2616005)(54906003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vd7UarMWpLzg+XaAcV6po8euJajA41T8IHzD8Kml49ItpfR9I80SsSXtT+Pf?=
 =?us-ascii?Q?lZCHnHxkFmBSzn91YRDQTF2aFNyTCqMpuL2gsMMVyhjeKG5/rBSt1k92vopJ?=
 =?us-ascii?Q?ZfMiTgFX8/TuuW2pwamfjFPTatzialZ1BIf0WtxO/2Cja0WohSiRrIzJ+5yA?=
 =?us-ascii?Q?zXT5LpVgBEq9eb7tzLR7t8LTA6M6Ylv/ho7P5/CTy9e0Ztz74wtUzCHztJdZ?=
 =?us-ascii?Q?C66CCYd+fU9wPXwOV9r3e0/nrRqP8G1FV72CzP8BjRCfvIqrsyNuecfNkzBK?=
 =?us-ascii?Q?W1wXxaZCcx97KDgnHwr6MnM3krNs/ltaCx03ggiaPSbWEymYJqOV0BDheezB?=
 =?us-ascii?Q?M6kaFssvobX8B7OQkabrFw6BptsTqJAKzAPa3SUd7TrfMZ6VXy/K24XoQNMx?=
 =?us-ascii?Q?ISAXXlQI6bIMOxaT/qleUZLO1txaLyAVHNZ72vCjCNqNkXP79hrOio+TSRtW?=
 =?us-ascii?Q?7LWHGl8EkpuSuj0JFKDoklQ2Pe4p8kc+92/ArZYSwZIB5mPkUSnk8s2d5N4k?=
 =?us-ascii?Q?n1Q85SnM0z0mZHGC4jRsnjs//tZFWcldkSMNrXEG636BecN6/z88v4ymjSJ6?=
 =?us-ascii?Q?PaM5Xrqohb9wwi0ywB5feK7KNTwshYYwjU0s335yDMEoM7Ffy8nrvODYRnmb?=
 =?us-ascii?Q?9UcLC7/6AV6mV/0M4fRmy5WKu1hDhU07Irsh4FU6lWbFSARYvv2nDzxSlm6e?=
 =?us-ascii?Q?YAV/bWqPzt7XVZKlBfbdMsYDy898Hz6isYK9DoMV7XqUOSmFF0mTEMcitrSP?=
 =?us-ascii?Q?ohJ4eV+xsrGBQBNFmJ6Q+0J4p3oTkXpD8bws1rpCUKe6O5PVhtn81OW57seM?=
 =?us-ascii?Q?1gauD4X44iojwbD8Ms1QswRt91L3QYQMZxf0GXpXj6yYiKDo0ceN3/woUT97?=
 =?us-ascii?Q?AuEuxXHzel5HhK2rIfgrP5umy8s1TuIfre4TqWIvYtFzwaX8a9txW1cKlFMI?=
 =?us-ascii?Q?gbUE13silWH8+WUgQTWJHmB6yHRcTUn/a7tAWm51nh97btoVz9izEvwsv7N4?=
 =?us-ascii?Q?jdyo2QsJmoZamDaSmgfQ4I7cufa3yR6z4m66OaszUKbc55YBF/hvJNoVrOEB?=
 =?us-ascii?Q?JohzRT5MrYdZWH2McibfoUxaGcpDsGcxJ5TkIQmWWh2sgjjIaKAS8mrpOq3n?=
 =?us-ascii?Q?4Uplz546QqVsg6d8Pks3xCQUEsvlbT8qVO1wWhQCiyoWwUrslJOQBeDs9Mlm?=
 =?us-ascii?Q?yH4RstM8qB8rdJUuSJFEo1fMZpDK6Z+iruyzeIVCTPKQlwMWPHhG/Jy4NL1C?=
 =?us-ascii?Q?Sk6YVTdHxye0kXAg6zT60BaWp3oax+Tj2fLsxaYUP25CgS2eU4nhI3BSIZFj?=
 =?us-ascii?Q?TPqvckaiGHNpWRsUAtVb5rpwOlpqTM6JwXT6TphrEb+DJ4Wv/LcP2gKY5HkG?=
 =?us-ascii?Q?CyHHqkaJvgopX8udoy8EgAnD4W9vD3CvlfkYZt1ixPgUUbeX246qzulTxlZu?=
 =?us-ascii?Q?TTAlN/lWRtlOUnLtdSf5xpp/xQwG0MDyYyuttizdXc5aiYmsfnf4NXMlKHZ1?=
 =?us-ascii?Q?rrKLqSVSNgxY7hXnyQdQ9DEdMGVNVTpKfAuhexsXPE9lYJf/CkhtXwMiWwGe?=
 =?us-ascii?Q?jes2qsP5nBKnGXf0EQtRbO+zUh8ecfkNqmkLm0/ug9Ecjd2iQ+PIx3Mb/euv?=
 =?us-ascii?Q?ILhG7LeVqcgL+53l6Xftpp59OeepTPATVIiFiLcwkNpZJpGDHJmtxedsKhmX?=
 =?us-ascii?Q?1tEIJhjODGDw0Vy0tToQBpUVcpEskSzKGHdORRosys2b69CuieQs2BCerL1z?=
 =?us-ascii?Q?rSus/FugSy3dIHVozvk3DXNvDchWqpyyEIlwzsu1ywARndbrpiOM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 034656de-ff7f-4dc5-8777-08da1e666057
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:30:27.9442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wk9Sm6X+IG9qa5DaQv1r0qTUrGv1AyzqaCf6UNUTjkucZGWqILc84huRhj9XG2UqSTPyyYIvT7xWrmFDUugTQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5572
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140116
X-Proofpoint-ORIG-GUID: WcAyqotsr1UJYogj878wvWIZagMW-l90
X-Proofpoint-GUID: WcAyqotsr1UJYogj878wvWIZagMW-l90
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

