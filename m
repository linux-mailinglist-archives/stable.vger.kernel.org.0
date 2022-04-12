Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4599E4FCEBD
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347772AbiDLFSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbiDLFSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:18:42 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC02834647;
        Mon, 11 Apr 2022 22:16:25 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23BMDCuZ003034;
        Tue, 12 Apr 2022 05:16:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=/iYiU6ya0Q9jSxbTwyxtIX/v7IHM+oZyFAtlR2c047o=;
 b=a9jMJrt6DkBV7MZ2RyrRK1eeWvZbWBJ5QSm4HqLj5EZqI4o5ZXzKWclp4VKG14X+Htm/
 EzkD5yHyRBC2EQvXtHWB5pGK3/2xJ9bvK03bsI9RBMMFIkyTJ+XNXmkgnepJvKWVY1EI
 Cm41j21LK5X9TaCAir39TqDwjLk9zbd5lsZZ+tGjU6tXziUxUst7zcLzbLoMl41nHbn5
 gupDjfdBHUPA/1WnliPz+4nT+RbkiaLFsDDCJFDN8TZTbpeB6pjdtSs/LRUGdoip4LgO
 CK+si04UImQe4JvsmPFI9UJdoguEsMDzIIs39CJSD4aiGWosWTd+15SFLSydU4o8Kn37 QA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2dmb4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:16:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5GMoH034441;
        Tue, 12 Apr 2022 05:16:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fcg9h01qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:16:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcIVzFGOJd6j9hCJWgRABBooPNInafZ4C6b4rgALu5ThpjqKwS3o4BsnfnEaZrwfObtqQlRkcKJ6m9673PCfTIXcn1zu8yA+ZM7B+7I8tr9RFKH41LhmE77QXU2A7hPVXwHZQzBYmNmqk3GgU1GdnH9Pt13boTEMTamUpZjZLTeDwdOjEhFtuH69NvWfvPlgYuQCnvTvAOADQiz6Ex3G1xfeHBMdn5E5WAW+Uk0ggeiaLO/XLxmbssSKzqS8bJ73wczSu/Zns0EFjy/keQ+rTXzHp/hdiVxekZbpv+2t04v8jsB9rJKnHySgcyo5u9HTpOPOd6zu4jlYyd1w0CGcFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/iYiU6ya0Q9jSxbTwyxtIX/v7IHM+oZyFAtlR2c047o=;
 b=EbDiZznLW9+sTXxrg9Xulfgb9E0L0hPwZG92SUjZnqvODNbWeCFBEqf1wewWySAOtdS/gRTFCRMGPoCZlsokj0+YcNjNrt1ORu7lixrxbZv5LjDHDaoATfrFuJxfB3W10UPEEnRqkVgWKQHIRJTgD9BpIknCRPXd3kmMQbM3NkgsL2CJuF0aJ6zQxvk34753DgXH6k0u4PcwyA2kzNVeiDtqBLXmz/5APE2PWvDDxuv0xvn4w2SYiVQGc587W1lqF4BasN+gmBO9Gz9eYuhXNYd5DmMIDloJmCKTouuWlpOfT5ipCQVjWk/YTC3AxoUlrUHyANx/otDq22h8XMytLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/iYiU6ya0Q9jSxbTwyxtIX/v7IHM+oZyFAtlR2c047o=;
 b=Wb7gOn7mlzBWegnSLDRqI+8AWpC2fL7gU8Q4pECtXR6e558iVHY3h7VzT61XeRHlNtPXUZ6WA8gCLAYntCqhE9bEUMxs5C1oA69zGNrqZCGljHsjo3rw7lxaXijqQglOhEGGZhSZDadmVYFkA7omDBw+P757Xjf/8ZNOYs1rFWw=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BN8PR10MB3329.namprd10.prod.outlook.com (2603:10b6:408:cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:16:20 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:16:20 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 07/18 stable-5.15.y] gfs2: Eliminate ip->i_gh
Date:   Tue, 12 Apr 2022 13:15:04 +0800
Message-Id: <8ef6c4491dde583e6fc460286b96455b3d1671c3.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0004.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::16)
 To PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 350d5bf1-2b11-4365-7d03-08da1c43948e
X-MS-TrafficTypeDiagnostic: BN8PR10MB3329:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3329B99752454C83A64BDC11E5ED9@BN8PR10MB3329.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fEG5AzlVVyZb8iw1MmteuB8DoIcPRMVpNuRbmYHHDMmvIDc93kmxmmg78Avkv3pVdESvr1Rvpm0WqDBQ2aBJ7r9+z4Vy2DXTxruCub+g3Ldxcs8lFqcaVck8vxBrmE3LU4qgElK/CqexRHCdjuSfUyLWFty3G5lkyjmkqjBr+U8mI16ND15dBksJKCCoxWwb62TzW2ic2YSz8DIMpa+aeuhe64T0u0cYNkYtZHvZxw8syVnmpxz0xhJsi/m79nGPpQt58KSNOl8lBbXncWUlzi51rSGQmoNh7du5876F7efi4AVvkjR5t929ax5nao4ZQwFqlxUsKkTE7ma63WHdRmSmeRHqQnOaY/rJsyfyq0yt+ZeJBVbvdx/3C1CF4XilEVMwFHZP590xUZMov007s/0o1HPG5bqMKu9Bx00/s7uGeEY6xRrHr755PbJY0kwxSGV2rGM4b+0jNPwGOg2PWKvNmYuKretjDo6frcS1mg4p81agQF68iYFWDhrxFjOYiA+uYAEz1FOOC7mmmZ7Qi+avI9DJrswssKgLPvD7K9E72IS0JIx0uBRd8uE7hnFFyhMF2pZZxnNkkQlIFKgyichS8VLXHmmi+dXNk9HHBd/LYq7aP1QKJJwaEWUo3MXZpzTUD0Pn18rub1Xvgun8jg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6506007)(86362001)(38100700002)(54906003)(6916009)(316002)(6486002)(508600001)(6512007)(2906002)(6666004)(5660300002)(107886003)(2616005)(83380400001)(8676002)(66476007)(186003)(66946007)(66556008)(44832011)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GL9S+CYYMbqUnUqR9CcATKHzJktEWhuqSK3UD0NfdBDk3Fr9QqqyJZfogVgu?=
 =?us-ascii?Q?3GYgrKUHf2AD9APP4Tc2xE0aAhGm81pK7GDwT/BotqXmY86MBWXOjFM8dZWU?=
 =?us-ascii?Q?mcrtNdNBowBhN/r8qOzp5cxm/6FFWyq8xgVKCGCh1e4P9LIFi0N3Gz8eT4wK?=
 =?us-ascii?Q?1gOImt1h0MwKqTX7fJLv+iart6Xhzpy3J+ZQZFS5S/lKTrvtP9cLKVX96PF0?=
 =?us-ascii?Q?tim43ry7vul+WBt7fkvJM6bGxKGVnZLBBdmNEGmVcjC0ySpdqGY3+LobYF55?=
 =?us-ascii?Q?kyiY66HXoNOENmIesSCc3MDHbOJMZ0oKGKwu0qAydluPF5T0PdldB+hj7BeY?=
 =?us-ascii?Q?tEz4mLOZlYdXX1dOvK0aFKcEnAeGM3tKD/AjsNB2h3t7riUitUWeo4HY9xH2?=
 =?us-ascii?Q?eDqMutvpEb6ijA7DwQRKiG7N9GrqKavWwa2ZssvnWHkreEZ3roY4NyU6hRx3?=
 =?us-ascii?Q?8CAb6552ATrGDNF3pjqnM8qdZZ/p1IPE4cTichkpcO0ogWB3C4GMjfTRLW9X?=
 =?us-ascii?Q?9Na/yD3qOKAazuLnNnwDCU3jPuqqEJa107/erfvcOTqGsYP35EVggoOzRwkV?=
 =?us-ascii?Q?o0i0yPr623IHf3lpKxsn48KhqN3fZBv1/Qy3QsZ7okm9yPEYwwhNdoMhOo+x?=
 =?us-ascii?Q?MKPQ+/5VPMY/j4thKoujaaPdcMEFSVE+ppWMSaQoHKK3LW8QxLY3B2KDFezK?=
 =?us-ascii?Q?HoCJ3PToyKuf4J2aNfmBuIl4FXGasg2HMseqgalZb5na5NZeg9iwNvqvUInh?=
 =?us-ascii?Q?cLhBzdp79CMLN9FynDGx4dRJQINdwz3Eeo/aEmyNozn/VNQie0MRbOZUElcY?=
 =?us-ascii?Q?wFjdqmI0y6Dei07SrLW7X8Z0GzBeOU6ykMqgkhlcx3/Tdi777ZNkLIDhOSTR?=
 =?us-ascii?Q?m9yQL6k3AzeywJYYKa7t0p1dg13AYB9V8LcH1vr9u92CHLHzBGfZrBwyxaTH?=
 =?us-ascii?Q?Zy9qAOhnhPE8PIPsFeD79+0jTOSQnV4yI0k8NXKYz9AT3VKLcIF2iGH3xk+a?=
 =?us-ascii?Q?dZSAETNp8a8KfaVi1QziReBOoaQ9LwHnCkij2bclAj9nFuHdN9GC2YjF77wI?=
 =?us-ascii?Q?rFpsgZQ0wXWVaksv9ounXm7VIdXimlaDlC6OJ0mIaHwW06xUNrhDPzgpTJ/Q?=
 =?us-ascii?Q?jfGvy0IfC4eDmZmAfFojWN8VPbNulbWB1KelOxLbFMzbFSmGrfxUSB7DXLZe?=
 =?us-ascii?Q?LQ3Nj8a4eKgsT0U6gTZwLp6ehx5Yl76z+Z5v0GUx9Dw3aHhWZGF/rjMEW4Rc?=
 =?us-ascii?Q?CRShlCqRI22bL+dlTXQbM+JINZE2dFsERzcHY0T3l2vuObc9bgXukH4fKeaF?=
 =?us-ascii?Q?8lmlREwBp5xgCy+abWUlyEZSpN1LZZRu/E0RB6wb3/zfUAljXGurjXzalZRH?=
 =?us-ascii?Q?JvQZC9uA0rSPjzxWqKlKPZPUVEw5lf2UFUBNarxZwz7r5NLeKNygJrsWOpQo?=
 =?us-ascii?Q?tFA0Q/6lMgg10Z92W/bECu+puuWEnbw3h348pXIXt3t1WFA+nJwUjl1tlL27?=
 =?us-ascii?Q?22lfmObvZFI2P7HTSFFcJx4/ScHr5/rjkmcY3wQVWq98mu4LD4XYzJnKGWLw?=
 =?us-ascii?Q?+b6pktywN2rMJ9aQDqcRdIjg0vb48tQWGtzLkqbaZkEfBz8JaSK7HVQ7EJD6?=
 =?us-ascii?Q?EjWa0QCG1IKvyT3e1WnYLo+B5wxwlqSmANUTP3ij5LnzcY5V8aqDeVQLC9f6?=
 =?us-ascii?Q?3QLlk9Xv6T7EQiCLXW4xLXdsD/0a1//8aycOB37Zb6Ag3zkjbB9PkpxF/D8r?=
 =?us-ascii?Q?pDZxARcYJLDpMSm8MRnAlCzHiuy/kKJW/MzWVeD149/sISxZZnrg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 350d5bf1-2b11-4365-7d03-08da1c43948e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:16:20.8409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Gr9Y3nzNlzrfgjOQgbe5U6+jfLqGfnzyq9nlWU9ONhKzZCPrIF6RkcIYDlA55RPz6ND4cZsB8nXmche2zaFCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3329
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204120024
X-Proofpoint-ORIG-GUID: ayWiFk2uXxJ2jxGA2xqOVIMaM0gyzGUw
X-Proofpoint-GUID: ayWiFk2uXxJ2jxGA2xqOVIMaM0gyzGUw
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

commit 1b223f7065bc7d89c4677c27381817cc95b117a8 upstream

Now that gfs2_file_buffered_write is the only remaining user of
ip->i_gh, we can move the glock holder to the stack (or rather, use the
one we already have on the stack); there is no need for keeping the
holder in the inode anymore.

This is slightly complicated by the fact that we're using ip->i_gh for
the statfs inode in gfs2_file_buffered_write as well.  Writing to the
statfs inode isn't very common, so allocate the statfs holder
dynamically when needed.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/gfs2/file.c   | 34 +++++++++++++++++++++-------------
 fs/gfs2/incore.h |  3 +--
 2 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index f652688716aa..288a789cb54b 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -877,16 +877,25 @@ static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return written ? written : ret;
 }
 
-static ssize_t gfs2_file_buffered_write(struct kiocb *iocb, struct iov_iter *from)
+static ssize_t gfs2_file_buffered_write(struct kiocb *iocb,
+					struct iov_iter *from,
+					struct gfs2_holder *gh)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	struct gfs2_holder *statfs_gh = NULL;
 	ssize_t ret;
 
-	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &ip->i_gh);
-	ret = gfs2_glock_nq(&ip->i_gh);
+	if (inode == sdp->sd_rindex) {
+		statfs_gh = kmalloc(sizeof(*statfs_gh), GFP_NOFS);
+		if (!statfs_gh)
+			return -ENOMEM;
+	}
+
+	gfs2_holder_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, gh);
+	ret = gfs2_glock_nq(gh);
 	if (ret)
 		goto out_uninit;
 
@@ -894,7 +903,7 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb, struct iov_iter *fro
 		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
 
 		ret = gfs2_glock_nq_init(m_ip->i_gl, LM_ST_EXCLUSIVE,
-					 GL_NOCACHE, &m_ip->i_gh);
+					 GL_NOCACHE, statfs_gh);
 		if (ret)
 			goto out_unlock;
 	}
@@ -905,16 +914,15 @@ static ssize_t gfs2_file_buffered_write(struct kiocb *iocb, struct iov_iter *fro
 	if (ret > 0)
 		iocb->ki_pos += ret;
 
-	if (inode == sdp->sd_rindex) {
-		struct gfs2_inode *m_ip = GFS2_I(sdp->sd_statfs_inode);
-
-		gfs2_glock_dq_uninit(&m_ip->i_gh);
-	}
+	if (inode == sdp->sd_rindex)
+		gfs2_glock_dq_uninit(statfs_gh);
 
 out_unlock:
-	gfs2_glock_dq(&ip->i_gh);
+	gfs2_glock_dq(gh);
 out_uninit:
-	gfs2_holder_uninit(&ip->i_gh);
+	gfs2_holder_uninit(gh);
+	if (statfs_gh)
+		kfree(statfs_gh);
 	return ret;
 }
 
@@ -969,7 +977,7 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 			goto out_unlock;
 
 		iocb->ki_flags |= IOCB_DSYNC;
-		buffered = gfs2_file_buffered_write(iocb, from);
+		buffered = gfs2_file_buffered_write(iocb, from, &gh);
 		if (unlikely(buffered <= 0)) {
 			if (!ret)
 				ret = buffered;
@@ -990,7 +998,7 @@ static ssize_t gfs2_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		if (!ret || ret2 > 0)
 			ret += ret2;
 	} else {
-		ret = gfs2_file_buffered_write(iocb, from);
+		ret = gfs2_file_buffered_write(iocb, from, &gh);
 		if (likely(ret > 0))
 			ret = generic_write_sync(iocb, ret);
 	}
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 0fe49770166e..3b82fd2e917b 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -386,9 +386,8 @@ struct gfs2_inode {
 	u64 i_generation;
 	u64 i_eattr;
 	unsigned long i_flags;		/* GIF_... */
-	struct gfs2_glock *i_gl; /* Move into i_gh? */
+	struct gfs2_glock *i_gl;
 	struct gfs2_holder i_iopen_gh;
-	struct gfs2_holder i_gh; /* for prepare/commit_write only */
 	struct gfs2_qadata *i_qadata; /* quota allocation data */
 	struct gfs2_holder i_rgd_gh;
 	struct gfs2_blkreserv i_res; /* rgrp multi-block reservation */
-- 
2.33.1

