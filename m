Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB204FCEBC
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243466AbiDLFSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239534AbiDLFSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:18:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B7D6344EF;
        Mon, 11 Apr 2022 22:16:19 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C3I1iu008564;
        Tue, 12 Apr 2022 05:16:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=PTEA+N1XhqybQyFM2JLWgGwf4Cn2MWL8Z3+i5Yv4H5Y=;
 b=yD4RONZahZaA0zjBQW5eGm4ZglR82KOum+hhM/lelZUDG63Yg+NLK2xQiK56MV/2xMtk
 vHSjc8Dq3OvHB6BsIPm0vhj6TbFjDl1lRdfYRd8ihmc1nBZdmmsdq6vjWyHCpAvwStlv
 Kt9lbR3DK69OQHn+3soKUgedugZSgj4s9fAo10G5VXQG23PDeoTvfrRRQm8mkyZz59vz
 raviVowKS8ugjdCjK4usp1vTZVLAjbz0WJ9l6l6J0efyIyfI58U31/VQV2r5oEEvvdtc
 Lsky/I+GYiLttaUwijDLGia6Ve9XBA+UFFZI52DWzg9xviiUVeGQCqJAPqnGPaetz0g/ Fw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2dmax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:16:16 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5BDFH028059;
        Tue, 12 Apr 2022 05:16:15 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k23uev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:16:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WswKWWZXciq/VfMzj/gTfef2WFJcHBMkOI3AVRAR+Sc0XU+8ns8hUYiaShGHi702RtkEOW00KWC+89Kwfdb9H8tjwaucOycp/6iaex/JXblDzZRWqbzAzhOSWLnNrl1XMQA2xlh8vFwn2e5XUnzvGx+89ImsBCidBx+fTEGFlYI5zEPJy1Gb7hgqajXgTdpJgqFp58hnpkdHt2A4sl2YS9ftyKo33QP002eSAsvgoi+0Rozd0teS87RB30ARuXKI54AFs3wC5SrFuGVvrlSADPHcMwrhohFq5fVLQx+saYN5GBjddxWHLxM6P++M4sxb6rzWGyis2askSjop7ekaXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTEA+N1XhqybQyFM2JLWgGwf4Cn2MWL8Z3+i5Yv4H5Y=;
 b=TDyq5Abx17L+GCv7kdyfC2ZbgLDN+/y4mUzC4QGZxi1CIV62bHvXaXZL/cjSGGq72Tipe4JI84DtZjLPjObiYb8M0WzJBsiyUNqq3mqtZzmi7FsokhxWHscJqpv+HXrjhrzDQT5PojYY0HyTPVWH2qRG/uYfQfkAMsxvfryg72OZbhVjXuWFApsh/LS1fYWcnHsheAgNi5cL2HGIbS/xujb+5YdiLN6KVsD6rXICoPnhU+kJWQX1HELog1FLLwgJI8c63ODxSwHt6HkzKOOSQgZxpuZ7MjkhrvuDe24v72av60WiHkh4lvaozTPgPWw09966mqzaOM9n3Lzt+1176w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PTEA+N1XhqybQyFM2JLWgGwf4Cn2MWL8Z3+i5Yv4H5Y=;
 b=L6umTRDfCGjMI8cYAnOppXTNx00Q1Wy1K3qu2lxuGU5TwuhWomDcI1u4+2HdHH40HPQs7EdfSchvvCvPzcfCCJKx35Eqf6aVFlL/JIzyTptQFnovbsunyQ5QJxI2Rki3WeaR84SjxRqI/hToxFkHWIbuSwtV2/fyx3wItjxMP+M=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BN8PR10MB3329.namprd10.prod.outlook.com (2603:10b6:408:cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:16:13 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:16:13 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 06/18 stable-5.15.y] gfs2: Move the inode glock locking to gfs2_file_buffered_write
Date:   Tue, 12 Apr 2022 13:15:03 +0800
Message-Id: <9ac0468803165f72cb1a30db282a13a2336e2739.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0099.apcprd03.prod.outlook.com
 (2603:1096:4:7c::27) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9450519-4571-4591-f8dd-08da1c439037
X-MS-TrafficTypeDiagnostic: BN8PR10MB3329:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB332969FE70864A12541FB222E5ED9@BN8PR10MB3329.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wG5l4bSnjm+VgeNXHnWuV0ZHbLzIQAYhGxlk8SrFw6au9TKTQU5V5uorzihwMYMZzCZMF92urF6WKm6GVne3J7ZBz06BooLV/UkdadlX3mBOiue5yvd+jfVZ57AKC/TGK6zLC3G9mRgVOIqPXXhJmNCn/bzlQZhb3Rg9LVx27J99ozRCx1SvFxlxjw9U/2IctOJxqbY4jKTUdmu9jR2E/vw7/sEtsopmW2ktNe2m2MHln2ieBnFvkNIN8U+q4jZiqNAWcVOa+4sI/B5033dn9tCTM0qm1XOa/F5fhfCFo0NAs2UwBgjsJy1DwqG487D7XcwyqKjAUne2tkcX57ilXUsqNibjaJ3868UocRhxkHZ5vLbFUa60FspRU7g4VtYJMb2CQ2tZb+bTo9y6z1UUB8gyJpQKdYuI1xmR/qFYpW4Vb4mv2MaUUNET6Bkazk2/i3JjVO3NkAJXb7fPBPzpaBhgIkqFRY4Qeog7Ypn68Z3Jv55oYCbPblr0ekcmTqVhyeg8QZ2EMPshaE8ZQp/XMNpEREm/FdvK420hoggVeVhy0ItZS69QDlZSz0HqJWnujiSZFLwgZ1mtn9fJkTMvpQjpdNvSx4oNXvPb2pYQSwp4SEStLDlraTXI/O8oVRL69LB2YQlADML4i2qF6I7GXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6506007)(86362001)(38100700002)(54906003)(6916009)(316002)(6486002)(508600001)(6512007)(2906002)(6666004)(5660300002)(107886003)(2616005)(83380400001)(8676002)(66476007)(186003)(66946007)(66556008)(44832011)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RE9U1in9fMxv8CoyP0KLcfroxN8SJSDsrGxNTd/Q2VxxVWhfo88/0M8ongIi?=
 =?us-ascii?Q?XigMJ/DBV2ER6RopInO14OxOVNSeSSVOsoi8BINAbWFPg7lm03vpDjSjUHjK?=
 =?us-ascii?Q?wmCeb58w+roUJgQHqRMfxoTHMaOFhu3oPG/xRJ/dk2B07QJXYeL0uxiK8Xgo?=
 =?us-ascii?Q?GiAAN3ZE2zQgtwp6QJaFRZEKgURzmDhF4MN7yjue3xyEcxASgg0v/9JOYbAR?=
 =?us-ascii?Q?rigEYkWiPKHVyDt0q7CR2aC5agiIlBkqdBONP3ejTQItkLbkgXoJiZnFwD/6?=
 =?us-ascii?Q?+c4hojqfj+JFMZObB3xHneNY/aBG3gt2zbDFxpvMMZ0ANpT0kh4a62LjyqEy?=
 =?us-ascii?Q?5SaotrsdBYzTgPBbkrX2Yl2ZRRW7Exe7gj7KyMT3RZOCOsNyciANH7Um1RZL?=
 =?us-ascii?Q?8MsA+5q7tl5DEnAR4gAuhU7KW/LzfznJGjUxhmf1Xw8X4lPJnz0ORiuROZoG?=
 =?us-ascii?Q?FlpU3YjwAOxo8LpKeDCyAanyfrxWNaSbC53pdV3H2VrholZel1nBYjCWY61/?=
 =?us-ascii?Q?cPH7hXtEbUblYURcETkscK3GYkQ4PONBf2L+1956yTAkfwhz1RgSiPJY/j4B?=
 =?us-ascii?Q?fc1XWsFBE0s/ie1XKxp52WiD1g08ZXO5C68Y195caXoyrmPrz9B/Yc1qjRJl?=
 =?us-ascii?Q?FBhmePAhj3ZhytqkaLhY11OKIdlwdsyDOm04ETjg8vyy0ekdpk+Pvt48MYa8?=
 =?us-ascii?Q?evZ6WW1bUwNpWr/KtIuHMmRcmSoFoRh1SrSC5T1Hlkvc9cKIjoSG/Q3fI9Tq?=
 =?us-ascii?Q?4zb6xBIt2vGfHRgIDxySgF0QsSYkI4Z4hQKfsVJJHQAFdukF/gyI1/veO/nd?=
 =?us-ascii?Q?4uFpFBaBYUiHTX9PKOxPLR1dCEtaDDMn+2fimBbGnvGSAT97C4oXX9wrZTHW?=
 =?us-ascii?Q?Cwm8L7ZC/k9D77x2WxTcVU1vJVEfJ2wARFVYB3rIpuCVWrlEhhWIwLDSHtgz?=
 =?us-ascii?Q?z15DckdYmV05bUG6quG+scwjerMrQiI6WquI+b+L4w9qFMLbUe+TJX4aKNox?=
 =?us-ascii?Q?wlAqCKCNG1EnFdtBzwdbRJTRoLOZvXJFiLWPHMGKjIb37YBt4G589Nz5dTk2?=
 =?us-ascii?Q?MszkF3RpIUmOQPZcJF3k5lJQtr15xcNiXNCVHlWTgu/xp1nC+HceaaFs5Y46?=
 =?us-ascii?Q?RhklrFOmZdlZjhERQBGIHlYw8gjGLK/G8UUb7+yOsT10V8B7C5N7YwPcNV9s?=
 =?us-ascii?Q?ripm6dyJdDKKp04vCcrg65p+nOKzSTlERYNVmlqEpNP0QoKxs4ECw/yS8Ra2?=
 =?us-ascii?Q?cYq8mMjDRCxGPFkWGcL76lRMh7g26ChwH1r+3IcPYCLZT8jVXL6F5XsQsEz2?=
 =?us-ascii?Q?DBAjXHI4go9RfTYq175EQwQtNvkmPDEn5HHen3zvAk2czXiWvim+4hwaxrwr?=
 =?us-ascii?Q?nV14mDG9zdjcYw8zS7Xsouc6XSJ8ZM19R3xQpJi7GP4A7ZpbDQy5jDfYZ2DF?=
 =?us-ascii?Q?qRhmh7+epc1jPdIDJNxiz2MqM9AuAfpI0LMtstUc7xkPXiV9c9HqBBU4EPgn?=
 =?us-ascii?Q?BW6lOHU0NSV8jU3xmtK2/NOdPEXHTiCoCG690UB7GntW1rmVYUsFUVxpc6xG?=
 =?us-ascii?Q?oe25+ZfXGM0FtRWjOQkRMcWqLwgJEUa9rwbhZX2iHztyMwKvb/RotfCv3sdi?=
 =?us-ascii?Q?poEppsUHr7DYLpxcJUO6kARoy3UUHZGEbsNp/m1Awn3MhphmQNj3tUjTKZ6i?=
 =?us-ascii?Q?XlCY1JQKspEtmlL+4rCBuiGGzTtL87NV7cMOBdlQIBWf2bQaKRUJza2jZujm?=
 =?us-ascii?Q?KJZQPeoxW4zbAuOBGNZWEzaD6k0lU1bwZJ0ItavuK01KeBEFXQ+i?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9450519-4571-4591-f8dd-08da1c439037
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:16:13.7288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D9PS7sfS5T0xp6c/B9gFGb2DERxoA1Bf+rVCEjhUUwqxV/hyG90WqudX4Fm6g9OF/6avbdaxqSstvnTAOr5UOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3329
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120023
X-Proofpoint-ORIG-GUID: LZf99VWcaIkq30uoOh92pyqr-0gWV5z3
X-Proofpoint-GUID: LZf99VWcaIkq30uoOh92pyqr-0gWV5z3
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

commit b924bdab7445946e2ed364a0e6e249d36f1f1158 upstream

So far, for buffered writes, we were taking the inode glock in
gfs2_iomap_begin and dropping it in gfs2_iomap_end with the intention of
not holding the inode glock while iomap_write_actor faults in user
pages.  It turns out that iomap_write_actor is called inside iomap_begin
... iomap_end, so the user pages were still faulted in while holding the
inode glock and the locking code in iomap_begin / iomap_end was
completely pointless.

Move the locking into gfs2_file_buffered_write instead.  We'll take care
of the potential deadlocks due to faulting in user pages while holding a
glock in a subsequent patch.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/gfs2/bmap.c | 60 +-------------------------------------------------
 fs/gfs2/file.c | 27 +++++++++++++++++++++++
 2 files changed, 28 insertions(+), 59 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index bb9014ced702..fbdb7a30470a 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -961,46 +961,6 @@ static int __gfs2_iomap_get(struct inode *inode, loff_t pos, loff_t length,
 	goto out;
 }
 
-static int gfs2_write_lock(struct inode *inode)
-{
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	int error;
-
-	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
-	error = gfs2_glock_nq(&ip->i_gh);
-	if (error)
-		goto out_uninit;
-	if (&ip->i_inode == sdp->sd_rindex) {
-		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
-
-		error = gfs2_glock_nq_init(m_ip->i_gl, LM_ST_EXCLUSIVE,
-					   GL_NOCACHE, &m_ip->i_gh);
-		if (error)
-			goto out_unlock;
-	}
-	return 0;
-
-out_unlock:
-	gfs2_glock_dq(&ip->i_gh);
-out_uninit:
-	gfs2_holder_uninit(&ip->i_gh);
-	return error;
-}
-
-static void gfs2_write_unlock(struct inode *inode)
-{
-	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
-
-	if (&ip->i_inode == sdp->sd_rindex) {
-		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
-
-		gfs2_glock_dq_uninit(&m_ip->i_gh);
-	}
-	gfs2_glock_dq_uninit(&ip->i_gh);
-}
-
 static int gfs2_iomap_page_prepare(struct inode *inode, loff_t pos,
 				   unsigned len)
 {
@@ -1118,11 +1078,6 @@ static int gfs2_iomap_begin_write(struct inode *inode, loff_t pos,
 	return ret;
 }
 
-static inline bool gfs2_iomap_need_write_lock(unsigned flags)
-{
-	return (flags & IOMAP_WRITE) && !(flags & IOMAP_DIRECT);
-}
-
 static int gfs2_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
 			    unsigned flags, struct iomap *iomap,
 			    struct iomap *srcmap)
@@ -1135,12 +1090,6 @@ static int gfs2_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
 		iomap->flags |= IOMAP_F_BUFFER_HEAD;
 
 	trace_gfs2_iomap_start(ip, pos, length, flags);
-	if (gfs2_iomap_need_write_lock(flags)) {
-		ret = gfs2_write_lock(inode);
-		if (ret)
-			goto out;
-	}
-
 	ret = __gfs2_iomap_get(inode, pos, length, flags, iomap, &mp);
 	if (ret)
 		goto out_unlock;
@@ -1168,10 +1117,7 @@ static int gfs2_iomap_begin(struct inode *inode, loff_t pos, loff_t length,
 	ret = gfs2_iomap_begin_write(inode, pos, length, flags, iomap, &mp);
 
 out_unlock:
-	if (ret && gfs2_iomap_need_write_lock(flags))
-		gfs2_write_unlock(inode);
 	release_metapath(&mp);
-out:
 	trace_gfs2_iomap_end(ip, iomap, ret);
 	return ret;
 }
@@ -1219,15 +1165,11 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	}
 
 	if (unlikely(!written))
-		goto out_unlock;
+		return 0;
 
 	if (iomap->flags & IOMAP_F_SIZE_CHANGED)
 		mark_inode_dirty(inode);
 	set_bit(GLF_DIRTY, &ip->i_gl->gl_flags);
-
-out_unlock:
-	if (gfs2_iomap_need_write_lock(flags))
-		gfs2_write_unlock(inode);
 	return 0;
 }
 
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index df5504214dd4..f652688716aa 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -881,13 +881,40 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb, struct iov_iter *fro
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
+	struct gfs2_inode *ip = GFS2_I(inode);
+	struct gfs2_sbd *sdp = GFS2_SB(inode);
 	ssize_t ret;
 
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
+	ret = gfs2_glock_nq(&ip->i_gh);
+	if (ret)
+		goto out_uninit;
+
+	if (inode == sdp->sd_rindex) {
+		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
+
+		ret = gfs2_glock_nq_init(m_ip->i_gl, LM_ST_EXCLUSIVE,
+					 GL_NOCACHE, &m_ip->i_gh);
+		if (ret)
+			goto out_unlock;
+	}
+
 	current->backing_dev_info = inode_to_bdi(inode);
 	ret = iomap_file_buffered_write(iocb, from, &gfs2_iomap_ops);
 	current->backing_dev_info = NULL;
 	if (ret > 0)
 		iocb->ki_pos += ret;
+
+	if (inode == sdp->sd_rindex) {
+		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
+
+		gfs2_glock_dq_uninit(&m_ip->i_gh);
+	}
+
+out_unlock:
+	gfs2_glock_dq(&ip->i_gh);
+out_uninit:
+	gfs2_holder_uninit(&ip->i_gh);
 	return ret;
 }
 
-- 
2.33.1

