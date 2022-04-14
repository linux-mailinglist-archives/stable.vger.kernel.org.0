Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6AE501E78
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbiDNWeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347105AbiDNWcb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:32:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF4089CFF;
        Thu, 14 Apr 2022 15:30:03 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23ELRUOX001710;
        Thu, 14 Apr 2022 22:30:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=vZJ98q+gRGUwVgpHtctUzOdAQvBxJqKuS0h9IqLPB1U=;
 b=CplwYaEDxdrmBCxSEjeL8cvkFyAh01hxN/fZmlk2ZSVtHvlklLWRKz/Sj6qwSaRSjgGW
 KIPjYsaGQeUBC3BSZbf07uwBrBhBVts9rTt/3eJtoxEgDZPlIKlWs89p8f2UE618wZpw
 4RqQeI2xeNptfPQCAbSw7lZ10FTvFMY/6NQcAlMAU8bdhmX0YpXEVhLQhV6gxeUhJ/sa
 j93nqjS7KohTrKxI/bZIZzVXLOQyaX0z4SCyGGscKfi8QT3h0L45Hu9YuzONQed3mArl
 xG5Z5QyBqfGyZDI9LEjpR4Was6o8PqkBONo+Qli/2hrfAhZ1htREWvoFtIiXaXlmItI5 1w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2p3us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMHVFq014845;
        Thu, 14 Apr 2022 22:29:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k5ucbt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c74ySfUYLDaCZKXvE5Cpol2PyPepeeety9xgZs2Eo6F/Y+0U3LLnHtXaU0o8xc2i0IENEYMr0yIv8th8s8ZqXGigKURzWQM0c3zgC3Xjo0S4wHyDspCxKwaTX97ON2QAadNiRmAk5CLmCfVlP/WUNqiEELeUPLGSm2YAR3KzM1o6PaRrlAnVKUzNvimWSMPctxwx73X8+B0KWtlfqzMG8j/oVZeU5uQZnIdI20boIKC+Mvt65X9fkgm7geHs7nb+UWGiTQxYTQ1tGuvo154BHx1Ges82Gb6n0LNBusYwGZvwoInY31SYldgzohyxs6wSHJp9V7AKr5a/MMhy2PdwWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZJ98q+gRGUwVgpHtctUzOdAQvBxJqKuS0h9IqLPB1U=;
 b=KkIRc40KNVgZwDq3sr/oJRjBIrKhdA9ryntawlYlnaoUmnqxenbzFRUu4oJyhJ9o1SlrT1UVcFzqzudmt3S3uOkfPOj5AiKGeFrG8HM9stnGKK3O/v50KxO6BV08rsrsFzf1ZvcFoVQ+EFbhRnS06k8o6f5czkZkZ/l4RBbXFLCB4M7iDE3NKYhcktrojzPBMvtmfnI48dUyFfUfOAWPsdJu9oPjJJV/RFiCfydfu1eJ9L4ZqCzJYhvsBkAi03BTn3kYmHkZbH9ZDK5c4xgfEmjNBhu7Ixxn446P8wDAKgc2L0yFirkmRkhEcWZ+HDmvw6b8ZAUPS6qvhazN8k+sdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZJ98q+gRGUwVgpHtctUzOdAQvBxJqKuS0h9IqLPB1U=;
 b=GAxqU+e4uwkmDpD8RW7sO2mB2YQWYN/1e2HL429bf1JHrCRn3GQ/NfGDjlb1swvWoG4ly3K/+naiXz4qScgAMr3n5G9TyxJwMLOi69NSSAM+Y9IvjXg6g/UvJ292fOIwENUGgEui2fLfMTrdQIhS4cWr8C5DqhVHHJk45upAf8Q=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MWHPR1001MB2094.namprd10.prod.outlook.com (2603:10b6:301:2b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 22:29:57 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:29:57 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 08/18 stable-5.15.y] gfs2: Eliminate ip->i_gh
Date:   Fri, 15 Apr 2022 06:28:46 +0800
Message-Id: <844b20e15b0e730c43faa93347d7a65ac4e7b465.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0032.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::18) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df6f7bd4-c066-40fb-e8dc-08da1e664e10
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2094:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB209410958C09166CB97DB3D2E5EF9@MWHPR1001MB2094.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jtR0hKu9WGq+X7xm8z6G2OqUJ28/J1YfcIG5ZPz3JMb+WbSlUVhOvBVheaMmXIuUYSfPmHAIdM19GEYSkDvmeTJBhyifanC3uGKv9Vxz993nse+kHecSLHZFR6A5iZ0Rzeh3xE7mETg5QpbE8cFQcsVyCLcDeoLvbs/w4Y6jX6MH74GNu+35pHJ8ggXDH95FUmrImboGeDg3DPHcDWB8ZKf+6Fjk+rdUBT1Ugpf3lDycAiMAEvvAfziydHHeMyyFYfeGO8m4j4ebEBZ8Ckfa7jIGjyp7/xW5Ll65hCRUG8pglwMcNzRKeZCsTicEMp0vRturYnPM8vuvlKaK4IvYpj5pYRPRmcL6KChQ9FtVWpcbzViEujjYWpYIYcdzdeCyHD44iUEqHhKHPniSucXZgyFArUYGHSJ3GmMhpZ6vapezvqrBBdLLzIeKCeOjaWV5iGs/FajhwEkPabj8WtK5Hj4VawWzzL7B3naV6WMeI7tvjF2WWtzz6PMapts91KzcHSX3uVz4VVbRzubA8HAtrDFhaLjMWrDPVYMi992E2edFrBsn2Be4W09qy1DBK6/11M0QVKhJYpPLtgKkhbYuczKs4qXKEwQaPxIf2jUz4+qIqnKMdNQAQflo4H9poOZzkAQs6nbFySSxsHm6Fk2Lhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6486002)(2906002)(86362001)(44832011)(508600001)(6666004)(6506007)(6512007)(5660300002)(8936002)(54906003)(316002)(186003)(6916009)(66476007)(83380400001)(66946007)(66556008)(4326008)(38100700002)(2616005)(107886003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6pK7DBExUkkcJ1/ttIJEiM1q9qdjDQDOJ1JrQTPEN26TeUl9wMAKPtnpum3X?=
 =?us-ascii?Q?7FnwcvV3x7qZvKCFgCdnjLcVpo9lObqN0KN71oczoVdjMvfYxp2gk/FLS/Re?=
 =?us-ascii?Q?PqOXUy5gSED67RqYwgMhWK//BC85Cc4U+QclwUrPW7ao9JG9+OZddYlwROSy?=
 =?us-ascii?Q?xRyZ5MAVycC3+OwIfPtw0pmV3vbIlQ/yNCGVM3pfMbwNSHZmTT7AL+ljJDDP?=
 =?us-ascii?Q?mYDANU9vFGpGhcQJQrjz1STv2U2WEHnUBlX5nZWYpdADgIObtRXQ52qARneL?=
 =?us-ascii?Q?U745NQV3ykl+hjLWpIum2og//UfLbquecY1GyFXL6oJx52M8JHtSR1wQ3S/s?=
 =?us-ascii?Q?i9XR5N0hWw8jcQ1XGTnzlUSGkH1gjzh+alipOq7THU8+NLwWBwn1++3btHC+?=
 =?us-ascii?Q?FHM4k+Tjdyhh3Nl3cfVZtVLt9L/WCEDAtrV2JtKDVFVjtzCwq0OxZU6QqfYU?=
 =?us-ascii?Q?+iZuzthOJUJfd58Ia0PxEsUJGQfngZHbt8F6hd/+shS5CZ/ygMiF3WLD8iUn?=
 =?us-ascii?Q?455z/qFq+Nj7c4c5zn36e7AzAHSzgvk1a67y4eeAM51x7+ER3BedYHbMXfLk?=
 =?us-ascii?Q?WX512d3u4qfCIC6ivObsWsScsQgSom4hS55bs0FNfoVEnJct3wqdWJo3phNB?=
 =?us-ascii?Q?lOJQWOtv1X9kDsA8Io/Kj1SwrBRKR6e9MQie+HjypaBBZm0TYiSUHCCL4VGx?=
 =?us-ascii?Q?wJtJnNxyxydZXJrZTBR/X6QarLzp5t2SkxtFkqI9oU09W66WNhwekpveulPV?=
 =?us-ascii?Q?gMqIdtsDtr+V1wb837glvCCdye4CPXwU5oDsn9iy1+3WeeogkYs88EasLXDW?=
 =?us-ascii?Q?7oe3fuPGeRho+yghDovjy4ArGMcsFDi5xHCyWak4dB0puzX8BzsstV0KcSYN?=
 =?us-ascii?Q?OUdm5kR8Ab25oRSPhRyNsIdgRK1mO6KjXv18/2uegMdsEtrEzON7E8Li4mvH?=
 =?us-ascii?Q?FPyGxrDdeNaxhMwwpktLd6t/uT51P0ybPKpPp4/5ViNpk3lIah+d2hN6Duwv?=
 =?us-ascii?Q?bfey3ndunG4lFJV66n4ge8kAOnoi+WXsDwoZeAzY5JBc7pzOfKQzqgxxiCX0?=
 =?us-ascii?Q?IjO1TaYM4oUFhpFpgHENva9z2Nq+yR6ZCBYSPU/cfAj+JhPfZpp59oZBeFjN?=
 =?us-ascii?Q?jfPHz1JcepTAcq9Crf8o9UODcs4rzqfEbkJKacmKNp+kFK12417tEpb6Eowi?=
 =?us-ascii?Q?haBEZ0LXlU1vqt/lA8W18/rLMcFibVdCm8iNuqZYwYsMz2jTKjU8juJ+5ydN?=
 =?us-ascii?Q?YK4hRv4Kh+yYg9QaFOlsBT1wzhp/ToEbfcVH1AX1XOv2Ld4ViKlfS3+SI/7y?=
 =?us-ascii?Q?9xXl8NUibYaLgL+0rW6WrYnrHJLb9Cmd7G/i5scy0wXh1x0p/f8Mj/w/vk6e?=
 =?us-ascii?Q?nsUVvfCg8rVGZFAcB35949CAHctWRVjNBqwnMP7fBVKCclRPAY6Q1TiLaPjP?=
 =?us-ascii?Q?ftzlePMUgLwGD8QAdz2WjM5jYj4kEXBIa3MKkCxGP20qtG06NSEk8QVRZbQu?=
 =?us-ascii?Q?3Fc0/DulGJOQpqKHZbwSskBaiXR1GG+ls8w5V+U7EXtf1R0eU/gBx/3n9aRd?=
 =?us-ascii?Q?u5ODU71XQvKzUplA/Twrzv40IX31izV50e2Q4q45G2KeehZKgBY3Dlaf1GsJ?=
 =?us-ascii?Q?uwBRGe/XMWvIa0OHC5yHH5tzUSFD5nQEOk63HeI1cNTl/NFjC35AvXPeOGtF?=
 =?us-ascii?Q?nSa9VoSsK8eQD2noadfdzsnL36cjygqTmxgula8gAXW8rf0g1g34lSOrTS//?=
 =?us-ascii?Q?7NhvxzWhaP0iZKkLfzUjDNjNowdI9cjmwLpfuktVOIiAbrWMc/Hl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df6f7bd4-c066-40fb-e8dc-08da1e664e10
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:29:57.4230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6eahVbWTBwvDWKBJEt8cfbbewR6YTkylcqXn+aYhZFy/5JJUfSug/0Q5y6WAbhIBMwpGfM6yqjdFptl60BFsYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2094
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140116
X-Proofpoint-ORIG-GUID: Ua-gi_VVGpHaf9QT7SK_gtlGdEKqTmPd
X-Proofpoint-GUID: Ua-gi_VVGpHaf9QT7SK_gtlGdEKqTmPd
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
index 58b7bac501e4..ca42d310fd4d 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -387,9 +387,8 @@ struct gfs2_inode {
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

