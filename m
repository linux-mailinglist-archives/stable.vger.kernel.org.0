Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7234F007F
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238987AbiDBK20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235885AbiDBK2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:28:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D9553B66;
        Sat,  2 Apr 2022 03:26:34 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2321Vbtw016306;
        Sat, 2 Apr 2022 10:26:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=ERYh48ykYmmI8JFk2ZObmnRtqYk1ziVRysFQjyCuqVo=;
 b=osCyvwx6t9BxPFuccdjihHUZg/QrePNgqPtvwOcoku5eogLnVJzBMsB+UQ+OcR+XrbKl
 t/AkX7eUR6BprI4EXAr7n3FFE7ogj043IEVCw83GDSxnXO1Q9ZMZmbZbX/WvhlMqQehz
 AxUQ7VZnC/TVq0BPPy/G0mIVPxg4Zwjo2BDpJW5Z2QTshujA/MzX0wxNxu+Uzdw5F3Ub
 VEEBxOe3u/1mE9AAmyrg2dlJPmY2DzJOvvaUKfZ6HeHk6wrJZ6fp5i1gtM607KoQ8DYy
 Bgx7+aqwEdknrVSFAtGR5HV+HHoKNiTNOAdf/kCRi6d4jliHE95ny8Y8xoJqCeMVxLFx ug== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6cwc8cph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:26:31 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232AKdkf004370;
        Sat, 2 Apr 2022 10:26:31 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx163jj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:26:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVaYxcftDaBzhw1CB3nQKBgxBH1rqTj93zuJpP/8B0C1DDtbifLxeuInxrZBgj+S+paYAeSkmSPf7t7J5m5AczzsjebxYrahKEKRdGwDre3G4kIPgZpFDY6/osOFCqJS0piVmzEafcZmjDRV5c4JPmS/MoLUSqZHF1Mq6+r1i7eM40CLa6kCwy1Bj5up82Et6G4x0BtvSjG/DgjbWzWM+QtLF+/O1CGwPuRgHDYRRQsuPFNbglPEr08ttoK1vV4Troe1PzLtpSaXlq7OysDuQ7GWXrUDUPT+V2ijXFl72UPzv8sPaO3Wvrag2c94LQgpTexTAc5Nab/3gU8NR/UURg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ERYh48ykYmmI8JFk2ZObmnRtqYk1ziVRysFQjyCuqVo=;
 b=L/I4qJ0EkEulIKuUAXxun6a7zI6F52zMSWdkJGmgv4CSSEX0g1SPzG+00jxrN0yC2V8sviYQrgEkLM3yhrM5bsWCWAb52VA1Fk5+kkKjSEl1StWjy2bPBlCOGextuQLTRk3FxtZz48NlTw3Iva0CdbuURznPUyLu3XOe6wbg3TCWSQ0U++PVuhIGCUkjAEqx6yCWptgddA3sU+Zlt0qr2YqQBWozu/8w+yPxdfLnkNfbS9zPSeCkFuy4X87g93ytjQAiuUpXEl5aagOmBmfguLH0cgGKcctCXmW+tMOZtaeJ6tMdDgLKa8zWytQYT+z/HWZ9jFbJOGvTBi53cvfppg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERYh48ykYmmI8JFk2ZObmnRtqYk1ziVRysFQjyCuqVo=;
 b=fG99fJPCL1BV6H0xcBRINRWMzc0I497dpmX3r2fKKnG2+DkthdBVyd5ZljwbEBxjOWvDxx0M/+Yc8ERRZwJO2K5GICu8t/aDLTF86iCQkupPaRHTTli5xBW0zfv+qHjJf/d5BPfEapcrIFTIgH8Ek5EYYhfPEyj6LhkaG4gSZSc=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:26:28 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:26:28 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 03/17 stable-5.15.y] iov_iter: Turn iov_iter_fault_in_readable into fault_in_iov_iter_readable
Date:   Sat,  2 Apr 2022 18:25:40 +0800
Message-Id: <b223c09ca244cac48dbc6675029cc912f0234ceb.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0070.apcprd02.prod.outlook.com
 (2603:1096:4:54::34) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8a80aad-e469-46e4-20aa-08da14933f81
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3049F7B37204C90E54CC6E99E5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r9iZS67aiZrlE8gytGEgnHOlmr6K3YLSWu1PHtS6ZChIsyCVLNXnWO0sn2Ac4KXQHCPluevcpby+6WYOjVLt7kLWrMr/qB7kJyrtqQA4n1d8ZjG9zugywvzw3QNLvWsT6NjaBTPDIFmapCWlo44P2YuHq/svqJwaMb68rORLgPryd0DpkQf8A374HYQkBOSg+D7a6voZrzp+/Vm9WotN1SvjeHiCQXDm9dbCSzLMstWsGqSNvLlZu7MDvHZLwV3cHm85fzJzfsHMK5ckij8A8t/uh90lZZtCeT/hzHOOGv0p55DrOQwIZoXfTcr+TRmg4CxFhZVdsAYn3cuGB6xq///SC2AnQd9mVG3G8U6eMo8noEF2d9BiO0EzlmPUZ+3cnQOEd7bOWuV5msEuPlG1g2e4FtwBw55Y3M8wyiAVRptSqpkYUnQJJu68ahhXhTF0bqUfOpQJU+vwE9Kqxateah9zqjwXDvSwCM2XURBzeeCCMdys9WpKCnydCSyPcZ/EO0hqYZLqAAEEQEm6AmfPJyY7O28W0hOFia2XMVSjKNj9JPkELw13DCoo5/XlX8vs+ykf6UHhIU/7bp0ty5UqETyO6VW4iVGFw3XHozVHwpkTQRqXk1GQMaF5BVMHmKDxeXosS45I3tJiNViM5CU5wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(26005)(6486002)(66476007)(54906003)(6506007)(36756003)(6512007)(86362001)(5660300002)(66946007)(107886003)(66556008)(8676002)(2906002)(6916009)(2616005)(186003)(6666004)(4326008)(38100700002)(8936002)(316002)(508600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fm0Q2zw+tVEsmM71lnViL4h3tSiGBVF5epdB8BdksfniRyrlj9lfC+jK/BYf?=
 =?us-ascii?Q?pttiXmP1W3CdvA2cY5IMuZyKIE4KSjgds08fcI/rjBDOM/JX7Rulrv3hi7Zo?=
 =?us-ascii?Q?z5w+/tSNOwW++mG/KOEStoLQglyMMTaPJ+/RxyBuTcy1+SbYIEhW+eQLjWPz?=
 =?us-ascii?Q?WcvGJFU+L6ggybvLMFnvUhvVM2MjNLWT4IomE2pSPh/dCY9sq0fDdm+5dZi+?=
 =?us-ascii?Q?t9dmh5PozSNRr+aKsChCiWI9jwz+Bq1nRPywVDYC7B8igq4sXOgmJ9O5CPBX?=
 =?us-ascii?Q?wu90tbhzfmXjYB+HIe0h4arv6h7Cuy8RkJOYB2EXPYAMLwBJPwEHYN/S+KHr?=
 =?us-ascii?Q?Bw1ol+zjKTX/9yHj77oCdD1Nz+SKf65ft26ZPUlYBoXsMvt5zXF+wjwFP8vd?=
 =?us-ascii?Q?VToLLvjwmoPgnOj6k3AsZraB+WkFu1wC8K80qGkTr/uNNNKCQqU9SbMx3lGq?=
 =?us-ascii?Q?dzLG718C8qvReXR9Ywhq7N4dphVcztXyxD72O6R5cxO6WXme3EpCYOukMXSm?=
 =?us-ascii?Q?No4MDJrzE198RU+hIdnmoE09sNiLze/Ga0VZFjwIlFqlUf1CAtvsRwkD6P8o?=
 =?us-ascii?Q?NuHOVZxgeN/cSm3kKdLgmYF50BX4rfuQlBWRZx6C086wsXPu4apvZrt79D8o?=
 =?us-ascii?Q?2gTT7MxcePEgQBXiILZbs9nIgB4LBq+pwQFVBlw8kgfFulKpiixNrWi9yLR8?=
 =?us-ascii?Q?kpOd5RSjlBl0MEmBZAY97t6lV2QgQWxC4MkROWUFLdlz1D7nc7O5VZ79BZoU?=
 =?us-ascii?Q?kpgNM6KsWTpdOuQpg25dwg0bLiWL/v6c35nUmkrWOtrPi6pizKKjJ4c1iw+A?=
 =?us-ascii?Q?3UopY3+2/pKkIWpIkqPzRNZ6W8Jfj182zey9UABqiz42NeW5ve70WFcxDZ8b?=
 =?us-ascii?Q?jWaWufgDkHmH2im1ijYL7h/3FxQzPXq4L2iCM5quzJ3qM1YL/mmodeu0rFLJ?=
 =?us-ascii?Q?CSV0+XbvxG1SIavEwMQY8T65HK6mKqp9mDwMuQyduOVWChkwsa9M1V35QGBZ?=
 =?us-ascii?Q?gb5EuDeVZ2OQ0Gma+Mm+Td0KthMt1rPsIjhITM2N1ZIkAcX8PKnTiXIXZ5tT?=
 =?us-ascii?Q?Mqv8yfp72gfuUfZvEYkMpMWuMX7k/UnVZ93KiyNMIjW2YyCzorWqMmYIXgPN?=
 =?us-ascii?Q?+SiO2vqU/yzwpCLXiNryIHJQlYAW7Ero8x6dgWQ9JlAi/pgwETyp/Ctndg9p?=
 =?us-ascii?Q?LsoRnmgEq1Om2k7Z2eSEkf4LmT7ffTcEgvFVOHOriEaHMt7a3rtOgqH5GSXB?=
 =?us-ascii?Q?CC0ED3Wf8d2H7qbTbI6aTqafrsiTA0qyZlbJq6er/4k1di+a15BIUn7nfw0h?=
 =?us-ascii?Q?OuQzhM3alG2zsWdFLQe6Ug8Hq8hsSmDmlnvWuFZTWYn1z7212CyeGsO1HHjE?=
 =?us-ascii?Q?WZDaeJ1rTHY/qwwqWbDWdjXbttmZGbl953ai6Yq02WKxvjHqkDYLpg1p7OVx?=
 =?us-ascii?Q?8KsoOp8qPbzxwx3hZOfDDiCEPvYPyb4Yn+bGrKpVKygDMKiIcc1ijGTBEaNg?=
 =?us-ascii?Q?afLzBPoz9KeQ9mwfVoN2Hf1H8vRbQN+CfMdC97N5PFsvyapfGkR5Mulr4zZi?=
 =?us-ascii?Q?NnRcAGsS1LkjuCieIp1KeIGbVRT0wyAnhJgC5nzooYz1m7/yRRGiGIvBtGuM?=
 =?us-ascii?Q?0EgqOhiLfXbnNxHxVfYIW9L8bBr05kMcHPBrxA6cmFvkwH5I3CQEAQpX4zL0?=
 =?us-ascii?Q?jFvvdNJxykcvXBe4Ub3foFndlX3wTv3mKmAjQYVBSb7aU3jF9m+mg6WmH6vf?=
 =?us-ascii?Q?hAP+q/Pt3Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a80aad-e469-46e4-20aa-08da14933f81
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:26:28.5458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DQ/t71gZDT1CUNVxeUkGCOE14G/WifbwCW65CRgGnTN6Jw5sYOgjoxgI7uoeNz1b8i/lVDJOhzjZxpt8WcubNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204020064
X-Proofpoint-ORIG-GUID: _gxKzlfuGnYCwCl6KeCVmzjgbyUJJXOY
X-Proofpoint-GUID: _gxKzlfuGnYCwCl6KeCVmzjgbyUJJXOY
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

commit a6294593e8a1290091d0b078d5d33da5e0cd3dfe upstream

Turn iov_iter_fault_in_readable into a function that returns the number
of bytes not faulted in, similar to copy_to_user, instead of returning a
non-zero value when any of the requested pages couldn't be faulted in.
This supports the existing users that require all pages to be faulted in
as well as new users that are happy if any pages can be faulted in.

Rename iov_iter_fault_in_readable to fault_in_iov_iter_readable to make
sure this change doesn't silently break things.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/file.c        |  2 +-
 fs/f2fs/file.c         |  2 +-
 fs/fuse/file.c         |  2 +-
 fs/iomap/buffered-io.c |  2 +-
 fs/ntfs/file.c         |  2 +-
 fs/ntfs3/file.c        |  2 +-
 include/linux/uio.h    |  2 +-
 lib/iov_iter.c         | 33 +++++++++++++++++++++------------
 mm/filemap.c           |  2 +-
 9 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a1762363f61f..5bf4304366e9 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1709,7 +1709,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 		 * Fault pages before locking them in prepare_pages
 		 * to avoid recursive lock
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, write_bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(i, write_bytes))) {
 			ret = -EFAULT;
 			break;
 		}
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 7ed44752c758..7014ae39264b 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4276,7 +4276,7 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		size_t target_size = 0;
 		int err;
 
-		if (iov_iter_fault_in_readable(from, iov_iter_count(from)))
+		if (fault_in_iov_iter_readable(from, iov_iter_count(from)))
 			set_inode_flag(inode, FI_NO_PREALLOC);
 
 		if ((iocb->ki_flags & IOCB_NOWAIT)) {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index bc50a9fa84a0..71e9e301e569 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1164,7 +1164,7 @@ static ssize_t fuse_fill_write_pages(struct fuse_io_args *ia,
 
  again:
 		err = -EFAULT;
-		if (iov_iter_fault_in_readable(ii, bytes))
+		if (fault_in_iov_iter_readable(ii, bytes))
 			break;
 
 		err = -ENOMEM;
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 97119ec3b850..fe10d8a30f6b 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -757,7 +757,7 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 		 * same page as we're writing to, without it being marked
 		 * up-to-date.
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
 			status = -EFAULT;
 			break;
 		}
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index ab4f3362466d..a43adeacd930 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -1829,7 +1829,7 @@ static ssize_t ntfs_perform_write(struct file *file, struct iov_iter *i,
 		 * pages being swapped out between us bringing them into memory
 		 * and doing the actual copying.
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
 			status = -EFAULT;
 			break;
 		}
diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 43b1451bff53..54b9599640ef 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -989,7 +989,7 @@ static ssize_t ntfs_compress_write(struct kiocb *iocb, struct iov_iter *from)
 		frame_vbo = pos & ~(frame_size - 1);
 		index = frame_vbo >> PAGE_SHIFT;
 
-		if (unlikely(iov_iter_fault_in_readable(from, bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(from, bytes))) {
 			err = -EFAULT;
 			goto out;
 		}
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 207101a9c5c3..d18458af6681 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -133,7 +133,7 @@ size_t copy_page_from_iter_atomic(struct page *page, unsigned offset,
 				  size_t bytes, struct iov_iter *i);
 void iov_iter_advance(struct iov_iter *i, size_t bytes);
 void iov_iter_revert(struct iov_iter *i, size_t bytes);
-int iov_iter_fault_in_readable(const struct iov_iter *i, size_t bytes);
+size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t bytes);
 size_t iov_iter_single_seg_count(const struct iov_iter *i);
 size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 2e07a4b083ed..b8de180420c7 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -431,33 +431,42 @@ static size_t copy_page_to_iter_pipe(struct page *page, size_t offset, size_t by
 }
 
 /*
+ * fault_in_iov_iter_readable - fault in iov iterator for reading
+ * @i: iterator
+ * @size: maximum length
+ *
  * Fault in one or more iovecs of the given iov_iter, to a maximum length of
- * bytes.  For each iovec, fault in each page that constitutes the iovec.
+ * @size.  For each iovec, fault in each page that constitutes the iovec.
+ *
+ * Returns the number of bytes not faulted in (like copy_to_user() and
+ * copy_from_user()).
  *
- * Return 0 on success, or non-zero if the memory could not be accessed (i.e.
- * because it is an invalid address).
+ * Always returns 0 for non-userspace iterators.
  */
-int iov_iter_fault_in_readable(const struct iov_iter *i, size_t bytes)
+size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t size)
 {
 	if (iter_is_iovec(i)) {
+		size_t count = min(size, iov_iter_count(i));
 		const struct iovec *p;
 		size_t skip;
 
-		if (bytes > i->count)
-			bytes = i->count;
-		for (p = i->iov, skip = i->iov_offset; bytes; p++, skip = 0) {
-			size_t len = min(bytes, p->iov_len - skip);
+		size -= count;
+		for (p = i->iov, skip = i->iov_offset; count; p++, skip = 0) {
+			size_t len = min(count, p->iov_len - skip);
+			size_t ret;
 
 			if (unlikely(!len))
 				continue;
-			if (fault_in_readable(p->iov_base + skip, len))
-				return -EFAULT;
-			bytes -= len;
+			ret = fault_in_readable(p->iov_base + skip, len);
+			count -= len - ret;
+			if (ret)
+				break;
 		}
+		return count + size;
 	}
 	return 0;
 }
-EXPORT_SYMBOL(iov_iter_fault_in_readable);
+EXPORT_SYMBOL(fault_in_iov_iter_readable);
 
 void iov_iter_init(struct iov_iter *i, unsigned int direction,
 			const struct iovec *iov, unsigned long nr_segs,
diff --git a/mm/filemap.c b/mm/filemap.c
index d697b3446a4a..00e391e75880 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3760,7 +3760,7 @@ ssize_t generic_perform_write(struct file *file,
 		 * same page as we're writing to, without it being marked
 		 * up-to-date.
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
 			status = -EFAULT;
 			break;
 		}
-- 
2.33.1

