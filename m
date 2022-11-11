Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C69625232
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 05:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiKKELP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 23:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiKKELN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 23:11:13 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AD61B9D6;
        Thu, 10 Nov 2022 20:11:09 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB42hYf028775;
        Fri, 11 Nov 2022 04:11:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=WUGQwMXNoic9AAeji0EkgAQt7C2sSK4pmz0vHuUquvY=;
 b=MveE5C9e7eQfTewd2c3Ifbtlq534I05gOPY5OQ421DD7w3Qr0jX5vePDEdFSrQzDK9aU
 lztbxO8e7GU4vTpW+4eU9OoOFwqcLxnqPgjjv+0VvUp8p0W1ChKw1gs1cXnlfzYPo4Nb
 r08ohd0Nxt98VYtOYvPH1IgdoWxCMiIqehWi5TnjWsZmEflb2VDRsu46zz3EGRWpdb5b
 xSNH7Qk/MHWvS9ZKMyS3RVPClNFjXq4A91SD0GpTdBoG0gdGZfugRP9vYOwUD1RLr9Jv
 G5KGzyTfbUbHv7kKvBeBXYeOhRf6u5kTsfCLfedH9MluVE+qQpSuW9w4YCGG5dqKm4XU XQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksf0x80et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 04:11:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB2Vo4I004081;
        Fri, 11 Nov 2022 04:10:58 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctqcp91-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 04:10:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ot8DVUstwxQZaXK0Vp4GpS5ViIZGu58xU+oXXMEXkpa82lZNO1bscEz1acCybAWAv2NLRUuKZtjQmF/Lji0vifesxaC/6FFop08k2zTW59v7W/qTUKIVCQkOfvwMYdJrRju23M2n4MJGUSVxvnyin4ZIbkw27CL51jilNaplUvuFyH/ZI/m5/PmVjzDIZ4WYs3fVi66Rf0jXNbAyP4NNs3Dhlelog/feyg4fbstwrRC//ow+eGaynBSHcULpWUf7/Toc28vhnLwyClqCuLtHH/ZzoI3DvV7R1a1BC3BqpuGbMxfTLCjwtPks4NsczDYHDLVJ5t0rRVIBgb9mPBvwhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WUGQwMXNoic9AAeji0EkgAQt7C2sSK4pmz0vHuUquvY=;
 b=h0qWabpytiTPrGuXQoU75H0pnIyd/oi4emITgGznWsdo6MExdHejuFasYmfMt79qxczwGTvNNC4Xt6Zff/wYxU6IxY22bNZrOMVDXGckwyLgtUJBCL8CnOSNZa5eYDwSwGVbrluZI75ZliigeqiA2FWdmoOZeKVvcZsYic2/BKdiH19i529W7fcGix5m0tEsslplrE/C8paJIx3yA9lD9uBk0yD8wZWK1pWf26XnPNQ9BzKi/74sfYnLe5qIe9Xq8iGx8/hnAztPuoQtKUNkSV9UECh8YpE65DtkQfWMXAly2QCaEtbXcNlTZ/zYg0Quru0vLp9+9/yJB6Q6CIIeqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WUGQwMXNoic9AAeji0EkgAQt7C2sSK4pmz0vHuUquvY=;
 b=GOEIdzB3443FSM+mSdD6JXhLFDgMeP0160xxI+wJlvxhuoQuJOll80ezFPFvVTx0bDXIWDUqVyin57X3utrzJKGVsfVr4xzQnE59NExjqpsHadbwY8bEDnx6OfF6XfhNKfINhWAkXjYrGiX0EQ2StujHMvUzDMDNmmV5092u42o=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA2PR10MB4730.namprd10.prod.outlook.com (2603:10b6:806:117::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Fri, 11 Nov
 2022 04:10:56 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::a671:8bae:5830:6fd]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::a671:8bae:5830:6fd%3]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 04:10:56 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 4/6] xfs: use MMAPLOCK around filemap_map_pages()
Date:   Fri, 11 Nov 2022 09:40:23 +0530
Message-Id: <20221111041025.87704-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111041025.87704-1-chandan.babu@oracle.com>
References: <20221111041025.87704-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0063.jpnprd01.prod.outlook.com
 (2603:1096:405:2::27) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4730:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b41a7be-2755-4205-4839-08dac39abb99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n4gYrCUgFmi2cG1dJWbjx+9RGQRHxDTpDyc1WPuRbb53Hy8E8L/58IWHtRzLTXBubVFYmzvw16M4t0r6RYNTP/S0UwdQcSEIT+lnW/3P/+9WqmKhQtaG6IEgZ4sIjdtjxQdNpewF+PRSbLINuuf1VqCPRUjSDig5sw0l4Bvip0V1GSam7XRfWj1Pz65y3jr0fJllfzf1vYoCrX0ekSRJVNrB87AnWMMKXnI3eUVa1Q3W71cFOQW/85fmNSB/RK8Bb2NjX71sNc0AqyX7cSnhdkvbSWZp/J7DKbV9ej5xiYZQppoNRVCcktPNm/Wln+I5ehlS8mneut0PvY+pX9rSuWqdJCAA8xrC2EzWArVqAhll56zbkyu40PruFFOfzAyrQRwGV+Bt5W09ByJq5PvdKOqh/6fBqwNm9KLAHMHHgm2PxZPNW7BYTa+5UgVAtUg18awj6QvxNI/ST4QOR34WfRHggMDi4sJrapvgriCDqVd0oMhWW1jU6G+BpG7exm7Ip0bPNgQ67uODx+6hSorNVwGwAYlsIn/IErhBjFtMkpL7UNJEx7IvZeBW1lqb8KJS27N8vXSpKp7WqyjrFUOP4wkUNr9NCW/jmWxcKVxonjZcrqGH41T7PTUTY4fZNj9IYuundhj1t34TSrWXXFaUCoXKBNzeYng7XWOhtBbDF31+cPXhu1L5RBa7JVG4JhWeJaSETYXbFE+H748pbei3fA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199015)(36756003)(66556008)(6916009)(38100700002)(8936002)(66476007)(5660300002)(6506007)(66946007)(8676002)(316002)(2906002)(41300700001)(4326008)(6486002)(6666004)(86362001)(2616005)(186003)(6512007)(83380400001)(478600001)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ptU6NsarDdAdDeUg2jF2NvueDkd742BO5vRb8jXdaqUISqY6hyThW9YyrHy7?=
 =?us-ascii?Q?4CWaQv5sJNEUKzFx4ndQFUJVW0l/Apt+AZV028Iu0PAz/hzcmcFQIsCf7ii0?=
 =?us-ascii?Q?B54hhSEhpmr1kn+V+FkC9eXoHfiJSisSIf+Fy3EzmdzK1xxh/dMUFtmKl3Fx?=
 =?us-ascii?Q?OwWUOkptHa6fD0Q8VK48gcyqg+bUK6wGdtP0ggM4xk6RU94cicgOazqbO2B8?=
 =?us-ascii?Q?nhJUzqnm6jV7mi9Y4gRh3VrU0c7qqGtQKSPJDbEYrxS4akfLnC9wWkAxocLA?=
 =?us-ascii?Q?AKqNNVcq1vB4bQeGCRPsjAE2gJzeGAF2jMOaxv5fXapkfxT2uH92EVIhzPjI?=
 =?us-ascii?Q?4s3eQ0zx+Qw800VWTdCmKwbK1Vqa94fUU3Fq28FbMcQF8x1oZAqvUwHC6Vnr?=
 =?us-ascii?Q?9rcSSnWgQvlVy2+JvCqtJ6j2lxlPpq/CqX/SM7oo9707Ct0Jo4oXePjJ2dQB?=
 =?us-ascii?Q?sVbrwcaxdVyW0Ptd12nDJLM+fnGgwP1DjGzE6A7ZJ/yvO14LKzUb7D+KYdTN?=
 =?us-ascii?Q?CDRtRdLNATrQS8g5fENvIwUNl2YyWkIWelXwThGmmOGvMJG8bQBAz78Q8QFf?=
 =?us-ascii?Q?OFcUTTYC7nujIIuGLp+WnXhKepNL1/tlSQfWAjMuQ8zGCyv9q3YkGJ6B2ECR?=
 =?us-ascii?Q?5K70GMisc9JixoBBJmEANBLsAeFDEXE8vcyiyUdt2mcQjNC4M/4uskDwr3lz?=
 =?us-ascii?Q?VoVYcyLUQozqT+3Ky6Gz157MD29XvVupxIFNOOpLP45UWLJN1xSD9I2kXndm?=
 =?us-ascii?Q?nRrn4j/GdlQriPo4KDN3IyNHEIhFoGSwShuVLfnrfG+L/JpgxqfrmZoEOSTj?=
 =?us-ascii?Q?/Mvma9mfaZP0ErAbQoqS2j9uJQAdHYh3R0vqIJbbyVuKE/W1dgdanYuwKnN/?=
 =?us-ascii?Q?wimbKR5deG0bwJUsTL76W7KF3BCeP1uXKxf4gAS5GCi8RsvtsCvFYqCj3sMV?=
 =?us-ascii?Q?zODR66xtV167RmZ58NahiuxtJOwEqz7HbXh7kaT3IwnXMW+3X2BdYcm6gBew?=
 =?us-ascii?Q?9mQUuzHSdCwyhFDlCnrtAx0n1VupMgYmkHEV+CwETM8rfwfz7Mu1UfVB7NSP?=
 =?us-ascii?Q?10bsoowXxa1+y2Bne+JkqqcvBBKdNlVtf2k9/riPWIOrh0oscN5WyoYnSVHp?=
 =?us-ascii?Q?EqG8bYW4/9BA3abCkgQYpy0hJZbo2wE9nZPjbwVvCUovaorkU6Gv5DAzboOD?=
 =?us-ascii?Q?S/htbTcyo62vptJFX3oNQBl+IgGb0O7y70sPWDipHsHmIfjRi0jpgJrDwyV1?=
 =?us-ascii?Q?3TOCxWuIOVTWXAHoWV4ElmW/P+5bLhdboFeRc6NygWf9EATqVrmLK0ees81o?=
 =?us-ascii?Q?n9NwTHn/PWEyPmstzbyQwihVw5lwqU2RBAlWX7Rs8zIcMRF0zilLgp92K2AF?=
 =?us-ascii?Q?Z/DhqoiZAIcllm25Qx7fHwuhlO7Qyj/ySiudGPC3G5kMZyArgOvdtTbrb8dH?=
 =?us-ascii?Q?/dlS0ux0RUN5ZwSE7/HhPEM7YVpWAVFhAHhcIWJKwmAI6+tFGphWwLMc3RXU?=
 =?us-ascii?Q?4ruF0RRDgCd8gSqETSiskHAs2MXvoFCwl4OcSWuQnduYgFuwh7gSOqDJ0kMv?=
 =?us-ascii?Q?m1mgnTsD32owHQqtSPQXsqsJooR7wa39iVqV5y91cmy25XaOlfujQbQOStlU?=
 =?us-ascii?Q?JA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b41a7be-2755-4205-4839-08dac39abb99
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 04:10:56.8297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JnvMUMHD8KwA6Vv8fPYt42xFF3Gd3bqZUKgCLCSIWCTh4kRLfpDXhECgUWhOAhosSrA6qO9jK1JiieNuCziaOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4730
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_01,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110026
X-Proofpoint-GUID: 2kvrpcl5aGuNJmP767zxx8d0BkdQNxML
X-Proofpoint-ORIG-GUID: 2kvrpcl5aGuNJmP767zxx8d0BkdQNxML
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

commit cd647d5651c0b0deaa26c1acb9e1789437ba9bc7 upstream.

The page faultround path ->map_pages is implemented in XFS via
filemap_map_pages(). This function checks that pages found in page
cache lookups have not raced with truncate based invalidation by
checking page->mapping is correct and page->index is within EOF.

However, we've known for a long time that this is not sufficient to
protect against races with invalidations done by operations that do
not change EOF. e.g. hole punching and other fallocate() based
direct extent manipulations. The way we protect against these
races is we wrap the page fault operations in a XFS_MMAPLOCK_SHARED
lock so they serialise against fallocate and truncate before calling
into the filemap function that processes the fault.

Do the same for XFS's ->map_pages implementation to close this
potential data corruption issue.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_file.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index c67fab2c37c5..b651715da8c6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1267,10 +1267,23 @@ xfs_filemap_pfn_mkwrite(
 	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
 }
 
+static void
+xfs_filemap_map_pages(
+	struct vm_fault		*vmf,
+	pgoff_t			start_pgoff,
+	pgoff_t			end_pgoff)
+{
+	struct inode		*inode = file_inode(vmf->vma->vm_file);
+
+	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+	filemap_map_pages(vmf, start_pgoff, end_pgoff);
+	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+}
+
 static const struct vm_operations_struct xfs_file_vm_ops = {
 	.fault		= xfs_filemap_fault,
 	.huge_fault	= xfs_filemap_huge_fault,
-	.map_pages	= filemap_map_pages,
+	.map_pages	= xfs_filemap_map_pages,
 	.page_mkwrite	= xfs_filemap_page_mkwrite,
 	.pfn_mkwrite	= xfs_filemap_pfn_mkwrite,
 };
-- 
2.35.1

