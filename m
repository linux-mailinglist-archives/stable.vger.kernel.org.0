Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA5C5E8CC3
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 14:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiIXM52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 08:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiIXM50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 08:57:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42AC15FC0;
        Sat, 24 Sep 2022 05:57:25 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28O3RwfB004259;
        Sat, 24 Sep 2022 12:57:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=ZdfE5jLuCOFEyeEFVAnt1RSUROri6hWGWFNj56rDJ20=;
 b=IxZzDTvo4Eoa898TJeTlXEvjcNy89OrddTtoFy0CFyEHv4pubb5k/jsih1Nk+8HlV9TF
 rNFNHWTnPSj8hGp08i63qmw1gD0yytHld3hr7xlcQU60ENSH3uii5hm941RZMUW/4Bo8
 3IozChZsKeoWUpK336hVhJFGDIVTf6y+EkizSSzX0pVtrv9X1upuu0OJnMLpXrRC3GAQ
 HAKrUJtXR5OqOzU36/QTbnZrkbn1Twrf1qMcFvtwkESSEQYYEeLx20mRZy8gD5Wh7xz2
 hXxpog8GeYZxrjm+Rs6bXfYTn9eImelm4nbZIRKCbBheZ9sxuzgoymbyiTFI4P1HxEGm Jg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst0kgg20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:57:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28OCUMXk021091;
        Sat, 24 Sep 2022 12:57:19 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jsrb1gt26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Sep 2022 12:57:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAbvmq3VYiyxo47wJEpB5T6t/OKYx8AKjeYU3fl3IIcsZsySUKy76YtKz6eMxmnZiWHWLHNjQchrXXYsOm5s/PxNX/CTMcmF9LSrTEadFcy/iYK6H8Qu7SZOB+YaUkgTvrHbejTImv8VUgL1P2DRzn0egcWDNU4+fVlBnlBOvHd3IhC1zEOMSB5xykZ3TIUQvlqdNtVy2CkQBYhIlsTBRDaHqSnhGvwVD7GCgeZt1W4WPR1L5NDy8doYQLJdmQpcEJopxPP0dlvVFRGjHX8GRTTnBSz/Z9tBbILpPPTD0yQsCUxIHrxLO2bwU+8d6KzMOutPwgckhB8wEPdMZk8j+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZdfE5jLuCOFEyeEFVAnt1RSUROri6hWGWFNj56rDJ20=;
 b=OVPw9+H2fdW34GIe5Prcwk20r2QkK/0sRJzNriMeqlWkLJCAa7/7sulR4MNkhCboDaLSFTLF3fyjpvh3uhNg5i8PN+eGYZrrk4OfAIgGi5cjHOBeSj6+ZcYtC1YJuXgpY4pdQou51OqUvMQ+FJP2HyFoWLlHskWlXHZdgqjjq4bIOaQMlx0WsbslUKcNOZIcOlGYNsY6q6OuCiPbybhKxotm61u9ZduKbK/KWUZYqY+oODFhQo+s3DnXy8MG4siyI8/ekf3g6u/SFTN3GVGE0hLxwc3scNvIr5/HxqYhBEuqtLw+8fBb5J8bZgWttLYDqXCsItbhwyPjhyYlBtfD+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdfE5jLuCOFEyeEFVAnt1RSUROri6hWGWFNj56rDJ20=;
 b=astxE0U25Iw420qiDxeFD+1DSQzhehyofREaegXnqifrOM9e/V1xPCqdXIYmZp+xUnCbmq9l64a+M6neS6xkWmLBFpxp93wFOQT8X3PNX5EPj/udw4Muzto4Gr/l5ELsZHyshYtSDKsMPdLYNiNrBQ6kYF0sY/XcJAPlCbJv04A=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH7PR10MB6249.namprd10.prod.outlook.com (2603:10b6:510:213::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.20; Sat, 24 Sep
 2022 12:57:17 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%7]) with mapi id 15.20.5654.022; Sat, 24 Sep 2022
 12:57:17 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 V2 02/19] iomap: iomap that extends beyond EOF should be marked dirty
Date:   Sat, 24 Sep 2022 18:26:39 +0530
Message-Id: <20220924125656.101069-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220924125656.101069-1-chandan.babu@oracle.com>
References: <20220924125656.101069-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR04CA0012.apcprd04.prod.outlook.com
 (2603:1096:4:197::14) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH7PR10MB6249:EE_
X-MS-Office365-Filtering-Correlation-Id: 50c1d465-2b5d-46d5-6d22-08da9e2c4f6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qoci2pf4sTrKWahOW+qQAIuBUDPH+/iB3gP30r2IZBSRxpbYEyIGw169EbzkgDhGAFlUT+RKBK0VmgxJqUebSBSCo3zC90DQNLAM4lv59/ZECqkfnFIGrKA6fjinp+Yrmx/29O7Ru0cuLar09Vhfhl2gCzYUtf30XZ3l5qm8QaDHVPzWn1nzMRMbxJvAytwDLlj514YbmJLNxe5JaH7iGKosrXkGPiwQikQgDaqwW5AX7+JbbMkeYEC5Ij+bI335vWMgmvkl0M9mXxiznOeJSSjpVvvBIHp3DP/sd2pMftKF2BnPA8awdUIuKEYjwpdu3tXqtYFqGy6SHcUhP1iv1eJ6tstmBN7uJMYoNhGWHUxp4jrxhnMfxOrXQG6skEPDQ8yi9IKmMVnVKJdIhh+kMLc6SwG58W742bUdvNTp6PRlXKe7NAx7bb7J3OK7o379T1RvZ2QPRCi9GhalgpfCmykLXNWakLuRS5HUB3Dz0romf5XtPwEfnSnJSJ0Pe+uLnyU/RCg3ciHdeUSutFqm+CeDeUTOEe261xEohAwH17PVZWLjpSxjOVi0ijsPhdDsOQM4x/H/JK2vFTbb9H5QAUHuJomnZVo2f9xs2r5ekuLIfHI1FBZCJVzJtfoXNLEemuLuaZaXR9bLx0i3hPpWpdOpCoIU38B2QoYZnBP5HAmd3UHao4EQ5UQotwzRB/4po4n14oJRZlNCr1QL2/yuRr82aIvXbmN3r8sKJ0dgqIISOhV9IoNhy9jA39GXnCQD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199015)(66556008)(66946007)(66476007)(83380400001)(36756003)(6506007)(2906002)(86362001)(26005)(38100700002)(8676002)(4326008)(478600001)(6486002)(5660300002)(41300700001)(186003)(8936002)(1076003)(2616005)(6916009)(6666004)(316002)(6512007)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FYkbfKNprgrdRpIbloJ7KLVtoPfre3H8e6P4m+jCcPpN8EUYT+WpRe5geTmv?=
 =?us-ascii?Q?jT50GomsbA4VV6WL1DmGK9tDPAmEohR20vwxGdtOW8iNT5eohBZDleXYJGc3?=
 =?us-ascii?Q?dkOAA2eViYOwsePp/dwTV0SstoJbrJjFQYAifVndrcUGDsoGMWDb7yMIIKSM?=
 =?us-ascii?Q?hsInIopo0q63L8YUKu1wAtSM1C5YmLXFET0OStv3cncD4OL/PvJQ9gwpsYZ3?=
 =?us-ascii?Q?CMsCp6DbBcgar0rCKmxPKoKTHB25zRlsGQ6r0rp6Coldn8VHHazOhTKxijoL?=
 =?us-ascii?Q?/crXrXXGeznT1a8DC5vtDVeq3ue7YN934XAMpjQYtt556vo0edsiNVMH8Lkk?=
 =?us-ascii?Q?qhCuetK8v1XWvBg2cSQP2YORZIOQ556pRb6QxqwndbqOsqA73bsvqw5DMf/v?=
 =?us-ascii?Q?BOrl/w0ngHmY3w/6rOBBTCqtKTCgvGiuUDPj2lkLZqsnKg4ab7tMTVBtwOfM?=
 =?us-ascii?Q?iLiTGFld/4sZPTCQR/B1aY9coMpoCOhYvj+i2i0AFPISyiZ38H5A87+IpO9e?=
 =?us-ascii?Q?+M4pWfnlPBJZWqWBXkxGGmu8/kkslvDsDD1b4yQIWkI4EWYa7543XSxXHry9?=
 =?us-ascii?Q?qe6VJvTVSZgkBh1sJrTxtuwq1b4XFe0VnaD2E0/wc+om+HZaYn+6tXyTDSTh?=
 =?us-ascii?Q?OnMIKQNxt8wNq3h/B50wWWSX6jN62X5mJ4+DmipiVlJFtVy5Gy4D80c7LJzg?=
 =?us-ascii?Q?yuQNAnH1tiDc3sh/LJMKIPOw6H1TZt/9pD3jUBw3ublHtvZ0ExrmkX0J4cNG?=
 =?us-ascii?Q?NhjsRd6QUlv0hSwHUDEh13lsOduXPlWbUC+a8uWSTlI/M0pEAhTEVHYCLWMI?=
 =?us-ascii?Q?jrhV4p0syhXDtXKJpOUScx8JXK+ORe2DcABAOfxTWZC2Vnl77Dzy9j0ad/B3?=
 =?us-ascii?Q?NKC5elHQDFX7C5FPGKU0+UyypF1ceZOlQBIzozYPJlxXKcygRwbBGroWrVlw?=
 =?us-ascii?Q?UyPvyUdNofnWCpRJiSoGKYRVZ1tR5Xw2VlDek3x6yuQgPby6YJ7miPm+I4GH?=
 =?us-ascii?Q?z0zrUM+dMil0R1uAa2wyZjL5RInJ8iGFMmMsNAIu6QbNMVEJWev/z1D939Ep?=
 =?us-ascii?Q?Y4dxTEVJXkppMAU7TarXy5bnZfCPzKEPIh/NKvD/fWNr+5XvkVEtRyIsTATh?=
 =?us-ascii?Q?dktpNYGS0HZtq443ZEErAsY2PDWaprFtl4UZ5eITyGMp7+FALfICjctww6aF?=
 =?us-ascii?Q?tf13f+7POZ8OfXNuombO22ooqBQbAnosVBn1dzz5/AYrJOxLoA3MYgYCf7Tn?=
 =?us-ascii?Q?aGTxMfcFt1KeFntqMIFISQcBEElAm17d+tjyypQYiFdCHAtLIwvgy+6Wuk4Q?=
 =?us-ascii?Q?aMtI4UvplaqRA2DZmzuIIdHuY8hWMvXxYblL9TJ6S0k7GDqUP3kQamEr4Rvv?=
 =?us-ascii?Q?Cb9ReXKj5ECOg6CjvUeQ4u8/rhsqwlJqUXiUUatPC5EAe6k1lNFvd3zzKQFG?=
 =?us-ascii?Q?m5J6Rft58eMng7SXcMYHtXSfg7gE99IW2uw2maDsuLdjLwlc8rMB/YvubDq3?=
 =?us-ascii?Q?PL9t5CT6ZzL79Nmtq9bIGLPGp+3N41ZtUrlwuHvSOgScJIUeFXB39YF1c/Ph?=
 =?us-ascii?Q?EFTl2aVF63EPuqoL6jfrnYlBR1EIWwCH5tEWOF94?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50c1d465-2b5d-46d5-6d22-08da9e2c4f6b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2022 12:57:17.5329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ozGesJ8eU93xWBnxI9p7m8JTctPNEwU4nP7Ng91xdZwD2lCK/JChdZLWIq7ZSDRV5XWuwyqBV4NtfsEMbpsHsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6249
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-24_06,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209240097
X-Proofpoint-GUID: -O9gCNq3b9uLbb9WI7gHytfpKIwF2GtT
X-Proofpoint-ORIG-GUID: -O9gCNq3b9uLbb9WI7gHytfpKIwF2GtT
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

commit 7684e2c4384d5d1f884b01ab8bff2369e4db0bff upstream.

When doing a direct IO that spans the current EOF, and there are
written blocks beyond EOF that extend beyond the current write, the
only metadata update that needs to be done is a file size extension.

However, we don't mark such iomaps as IOMAP_F_DIRTY to indicate that
there is IO completion metadata updates required, and hence we may
fail to correctly sync file size extensions made in IO completion
when O_DSYNC writes are being used and the hardware supports FUA.

Hence when setting IOMAP_F_DIRTY, we need to also take into account
whether the iomap spans the current EOF. If it does, then we need to
mark it dirty so that IO completion will call generic_write_sync()
to flush the inode size update to stable storage correctly.

Fixes: 3460cac1ca76 ("iomap: Use FUA for pure data O_DSYNC DIO writes")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: removed the ext4 part; they'll handle it separately]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_iomap.c    | 7 +++++++
 include/linux/iomap.h | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 239c9548b156..26cf811f3d96 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1055,6 +1055,13 @@ xfs_file_iomap_begin(
 	trace_xfs_iomap_alloc(ip, offset, length, XFS_DATA_FORK, &imap);
 
 out_finish:
+	/*
+	 * Writes that span EOF might trigger an IO size update on completion,
+	 * so consider them to be dirty for the purposes of O_DSYNC even if
+	 * there is no other metadata changes pending or have been made here.
+	 */
+	if ((flags & IOMAP_WRITE) && offset + length > i_size_read(inode))
+		iomap->flags |= IOMAP_F_DIRTY;
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, shared);
 
 out_found:
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 53b16f104081..74e05e7b67f5 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -32,6 +32,8 @@ struct vm_fault;
  *
  * IOMAP_F_DIRTY indicates the inode has uncommitted metadata needed to access
  * written data and requires fdatasync to commit them to persistent storage.
+ * This needs to take into account metadata changes that *may* be made at IO
+ * completion, such as file size updates from direct IO.
  */
 #define IOMAP_F_NEW		0x01	/* blocks have been newly allocated */
 #define IOMAP_F_DIRTY		0x02	/* uncommitted metadata */
-- 
2.35.1

