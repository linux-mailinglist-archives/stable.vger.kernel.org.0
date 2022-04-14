Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2AB2501E66
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347204AbiDNWdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347197AbiDNWdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:33:21 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07911C559B;
        Thu, 14 Apr 2022 15:30:55 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EJT05Q028178;
        Thu, 14 Apr 2022 22:30:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=dXLgYHGX2bcuJ1qIa1hHlApYOsaF6wp685Y8tY54+6o=;
 b=DDbb1yeSVQ3HYx36SR8fgZ5tmnBsEwTxtUUMvTpwoeYu7pPVCUlylWC94JxpbKFlW33g
 EYWmeBwECxSnWclMaSgoKKkxTjJJaRV5sgc+zUmu6GEjdOgRCyiOvKo0J6rn7hjFFRC0
 2YFdbx+tbJip5BlEu0ocrBY5STYcQqyECdQ9C4yPm8Y+E6cm1Lq64oSGNfgart1AVKNg
 YqApNiljxlOINy5U4xj/jFrdx4R5bwxDmdMiBsfChoq8w5nryuy9IpvabfpSTHObgnmh
 8HC5hVEdGFFxxxIU5Wdh8J2uyNH0q8Ab1xEKH6wl9eZ26yBrfVFBquYvIugieFTTc9cj Sw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb21a5m0m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:52 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMGT7v009294;
        Thu, 14 Apr 2022 22:30:51 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fck15dac9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUFHKj+KehihwS/HkqjUmmnIxiyofbL8KxrRgVnOyOddRaRRxGSTl4X+ZWIG7fbX4Il1pXyhF2vI11KffFOsrlYBV7c9SrlLg0lYiiMnXXvjFKEZyMatoTf5e2xUVRgA6NEiLb73k05PFaXYZ4PwinTHNOZ7yoFHBHH518j2+yEjPeS9jjDbrhpcHB/zKfde8ZASU6QQRWUpG0+Z2sM/Oy6SwY8W+1C99DQAxPMHl+dV304Lbe2STPF12FqhzW/nnoaBYev3Cu8feZaSter/+ANFyjxZ2VQ7U9+wxvR2XjHI3ABJzeTyaxAU4WN1al7zUVnbpeDF9q30m1r35RQmCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dXLgYHGX2bcuJ1qIa1hHlApYOsaF6wp685Y8tY54+6o=;
 b=YuqOJuTlteeujetbLPxQNfPVpApdiBFxVwf0eTUFUJu1AYL86TAQt+zo9FM6DbNzZqLoB0BRMtHzJOm8XbdwmS7OPkIf2/0i8Bik0uYDW01Ud3y9zIUCx+RNwSSpvgg7GjFANswiC2MLotrl36c3ITr+2M8vxlBrfy6Znfcls3YUROO3lJUN/d0CKs7HOla1GppmuldmE3cZ2fHyJJhU8+mMdiuqHxUMEsYcwPg8PxaRIyDbmzr0Xib+h/vsmJ0TACCTsi94untAxlplEPUs9Qy8SCu6Bvhf+Mz8rcC6LIM1kj4eMm11f5irC20OG42lF+OO/bakoxaXZh+GUzkWsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXLgYHGX2bcuJ1qIa1hHlApYOsaF6wp685Y8tY54+6o=;
 b=lf3wx0GHGWMWuYuuFGokt3qepqe0GG8E9W40hubNvYKPq/dnUgA6E7oohhumOBNpEWt6jVaQDwR0LoW/88sYYSxAHlodHvmgHl8a8CidTL939aEbIwbPyk2PK54GsRNGGwwdkCkp2/whpI9KkH679BRKkGZWIaWxZvX9ec0KBxM=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by CO6PR10MB5572.namprd10.prod.outlook.com (2603:10b6:303:147::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 22:30:49 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:30:49 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 15/18 stable-5.15.y] gfs2: Fix mmap + page fault deadlocks for direct I/O
Date:   Fri, 15 Apr 2022 06:28:53 +0800
Message-Id: <02aca00403b19d316add3a4c835d40436a615103.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0057.jpnprd01.prod.outlook.com
 (2603:1096:405:2::21) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 165da06e-1e37-422c-7e19-08da1e666d1d
X-MS-TrafficTypeDiagnostic: CO6PR10MB5572:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB55722E4FD5D9A9B5DC42D823E5EF9@CO6PR10MB5572.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6YZcoYg/l+ICi5T9/36TxpHfXFPkp5ZNa7dgxq4humM6+II80SJQCMetM0c2wczw6s6coWmmjmz3PgyoF0PLL1ThxAE1wJgzKKNg5qvkO4pM61n8lhrsvg1/zCc5W45wSYMpG/cDVcIDV3d6mEPNQnmhw/Z9BSy4hO98+vV+0m5AoUFMhySuhinEeUGnyxBcvRQr9BgOArRZsEa3VM89AoQ2GLu75+7z8HT5xNH5xL0gk7IIwQrxWSdKuP6RfJ48eI2T3AUTmok47wbFbUtEn26nVDFB8Q6hpgEQEiR8o94x0/5Kt28pTnw780ytT5/J+3AbwiONja0lSTiexVzSNK/rbM5wLfImVpfo/7gg9uSKIUuE5arPtT1+rilWnQMX4gstj61i2BeuXelnEvUDRWvjGFozaO0KF7BRHXEDUvY0JGT7voyH9TGMagPJ+XyahZf0p7Nbewcal0eF8/v2NMXr3SigTN1l9HV6ubY5gmHZXbRKCI5iOhfpVBzKMbvzO+A/ZWrRKaA88PaU1/xOm1xPDgISz0LSuOnF2e3KlmHxaMslS4n2msMpCqPM+LL43MiM2n1x6mCtq/LbJPrMhQ2vNvX1jiuHdxaMX01TWaH5irGAlxhR0RVjTjHVfqiJyfcwnrR/l3Sr99oow/7vkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(38100700002)(86362001)(6512007)(6506007)(2906002)(4326008)(36756003)(66556008)(66476007)(66946007)(508600001)(8676002)(6486002)(44832011)(83380400001)(107886003)(8936002)(6916009)(5660300002)(316002)(2616005)(54906003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qL+7s49vVW36elxmUWB10WSQVUgYYkwadA2wDYHeRvzSmo4/WyXYSEuq3x83?=
 =?us-ascii?Q?VgJNG6xTQOFXS2Hy/lFMoE0SJyixs1Fs8U9nq0DN6D+toBYnIqS6KVi49GwC?=
 =?us-ascii?Q?ze6tBsVsIHXC3ekp4aRwLaQWMJrgTZodZiZxaVr6ix7os0EArlJlfARm5ubZ?=
 =?us-ascii?Q?2hD4Z3q7SixpHnxWbu/q4Xn8jDtdKUsXur2Ebuuqv/rGLiBfGCcOk7CloQhw?=
 =?us-ascii?Q?hdNYdDow79FQmdJ+kFZ18YP8aRwE28YGvpXBQUnmSYpl2CPD7cEBDBi5i0nV?=
 =?us-ascii?Q?KMjBuA8x/YLdwllWu3Mm+qkiSbntiPWbOSapXu4FcYgsKttQGG4TPobYhrad?=
 =?us-ascii?Q?MxP7fhqvQGfmp7P6t2HkZJZFMD17rzGCl8W8Lc8+5X/Vv9UZVbcure+p0cbn?=
 =?us-ascii?Q?SSnb79LbWYnL/PehjwGz4cCBsJJN75bMHEankBwWL4eYXTVALT9lGtBhkR5G?=
 =?us-ascii?Q?Yur3e1AcQERzdgf0h/7PVL4dgepT4CUo9aprdHR5nzLCowNEJGKVsWLaZ6Uj?=
 =?us-ascii?Q?v+NDOCVoY0s2LfzXmuBXGU37Ahk+5MWc6fnJDyHEo6joaqvGqzifY3Fc5N2J?=
 =?us-ascii?Q?YO/1dD5jVxYjVcCEeKISPAIK/85buEWluTUuGohXp1c3mZ0gtX5OICvoeQjS?=
 =?us-ascii?Q?cWhPzbJxsbgsyNYgM5Zer6ys/gAMHO+W4d6HEmK4nkhR+PoSX+P1zlo6HktR?=
 =?us-ascii?Q?cXeIqxIQ6sMCT34zTW0BX9i8zf7cLvqwb6kK6souM686oq38kS1xs15ZA4bz?=
 =?us-ascii?Q?238PTUkSqcUMbbmjkRpbD6Wgy8RaC0GJeGwT+lQf/iUstsC/63QJebNjy/9I?=
 =?us-ascii?Q?DG1fyzJIkN/L4KSYBA1DpIw/DptsDBauh/cPMNJXG+NXxl3iDJNyuCCTyiR/?=
 =?us-ascii?Q?avr+tlgGIhaCgRD27YoeVA/CTHFpWVpcpqE2a4MYzGYvhuT+v7Ontuf4/baE?=
 =?us-ascii?Q?fZqdqrcHVQ6Vaxc96GP9Sb1LzEARp9K7ZMbHa+IHLigdhpb98sFLJ2oDIh2l?=
 =?us-ascii?Q?L/iZLtVLGW0bkVLJQ4avxRb8HExAyxlRhQ1iT/WB89oL0uuSPH36p/KPGBrc?=
 =?us-ascii?Q?E5I5blWqoH5yPFk2wnfoMhdqGBMPap1FVVUqX12Dh3eOb8R57fRfaqmirtkt?=
 =?us-ascii?Q?Vk8PWajqMBSVvmNV3njjy8QE80Bap+QLh2YKcg0s4+kWw7qLq86901ERXGcL?=
 =?us-ascii?Q?ARpu3js/V/zKe3A5TT2JkuhxItJIPw3QpiLAo6wi095FGHzc+6e6jVbufBNv?=
 =?us-ascii?Q?ttkVDrIMH/aJg4CZNntUziMpf/ry+qD1PPlV9Ku3gDpUJrkbyQr/vxtTDpyc?=
 =?us-ascii?Q?1CjyQITxAcN8VERKD2iR9fDwGr5rHcz0jinA4l5P6eH3p3e1Eyt40rijV2t/?=
 =?us-ascii?Q?KsE/fwTXDMG0pjBQi+47BgIqGCxN3OYWOQ+Mk2O6RqbvF1ANMefqe6C2jJQv?=
 =?us-ascii?Q?UkDJYmvg9kmy3gQT3XVovqDk5F+sOasAPPpO+tnqrExMM166ISAenWaRhzVp?=
 =?us-ascii?Q?0q/MVJmq9GYWnwLzJ2JhtYy8kzy2X+yZcpaCJo8x82A2Qw5CbXfvkmiAyP1a?=
 =?us-ascii?Q?yIroxH7XjX7lN5tD9P0+4yXAbDqM39JAdl6qRxD//IjNOhUJic+4tYxesKHT?=
 =?us-ascii?Q?iHSZ1VyipORE+oB4g/V+nliEyEaEZr5NXgugefFjRNnh4hbEwkVF2Sj3tGfv?=
 =?us-ascii?Q?SJhBxinpQFK23UeO2kEl426gwrmGDgO1fcPziyQ1VZXShVKlZbQuuvcWYKGU?=
 =?us-ascii?Q?G1MAGtaVirZEDkYjr2oIOOjjYKWg0kUA579soxEd1GeGoJg+vs4o?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 165da06e-1e37-422c-7e19-08da1e666d1d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:30:49.4211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TpUbKEvga7h8SkIx8RPl/5vHAFRO3TAYz9g6cEKJkW8k28HEyQ2KJsIMAQG0oFH6U8T6gVKEi5y1KhGeLRHPhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5572
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140116
X-Proofpoint-GUID: 0GgPr6T3PgpEQfCXX9VDRzFckatUStbK
X-Proofpoint-ORIG-GUID: 0GgPr6T3PgpEQfCXX9VDRzFckatUStbK
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

commit b01b2d72da25c000aeb124bc78daf3fb998be2b6 upstream

Also disable page faults during direct I/O requests and implement a
similar kind of retry logic as in the buffered I/O case.

The retry logic in the direct I/O case differs from the buffered I/O
case in the following way: direct I/O doesn't provide the kinds of
consistency guarantees between concurrent reads and writes that buffered
I/O provides, so once we lose the inode glock while faulting in user
pages, we always resume the operation.  We never need to return a
partial read or write.

This locking problem was originally reported by Jan Kara.  Linus came up
with the idea of disabling page faults.  Many thanks to Al Viro and
Matthew Wilcox for their feedback.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/gfs2/file.c | 99 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 87 insertions(+), 12 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 81835d34d6f6..247b8d95b5ef 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -812,22 +812,64 @@ static ssize_t gfs2_file_direct_read(struct kiocb *iocb, struct iov_iter *to,
 {
 	struct file *file = iocb->ki_filp;
 	struct gfs2_inode *ip = GFS2_I(file->f_mapping->host);
-	size_t count = iov_iter_count(to);
+	size_t prev_count = 0, window_size = 0;
+	size_t written = 0;
 	ssize_t ret;
 
-	if (!count)
+	/*
+	 * In this function, we disable page faults when we're holding the
+	 * inode glock while doing I/O.  If a page fault occurs, we indicate
+	 * that the inode glock may be dropped, fault in the pages manually,
+	 * and retry.
+	 *
+	 * Unlike generic_file_read_iter, for reads, iomap_dio_rw can trigger
+	 * physical as well as manual page faults, and we need to disable both
+	 * kinds.
+	 *
+	 * For direct I/O, gfs2 takes the inode glock in deferred mode.  This
+	 * locking mode is compatible with other deferred holders, so multiple
+	 * processes and nodes can do direct I/O to a file at the same time.
+	 * There's no guarantee that reads or writes will be atomic.  Any
+	 * coordination among readers and writers needs to happen externally.
+	 */
+
+	if (!iov_iter_count(to))
 		return 0; /* skip atime */
 
 	gfs2_holder_init(ip->i_gl, LM_ST_DEFERRED, 0, gh);
+retry:
 	ret = gfs2_glock_nq(gh);
 	if (ret)
 		goto out_uninit;
+retry_under_glock:
+	pagefault_disable();
+	to->nofault = true;
+	ret = iomap_dio_rw(iocb, to, &gfs2_iomap_ops, NULL,
+			   IOMAP_DIO_PARTIAL, written);
+	to->nofault = false;
+	pagefault_enable();
+	if (ret > 0)
+		written = ret;
 
-	ret = iomap_dio_rw(iocb, to, &gfs2_iomap_ops, NULL, 0, 0);
-	gfs2_glock_dq(gh);
+	if (should_fault_in_pages(ret, to, &prev_count, &window_size)) {
+		size_t leftover;
+
+		gfs2_holder_allow_demote(gh);
+		leftover = fault_in_iov_iter_writeable(to, window_size);
+		gfs2_holder_disallow_demote(gh);
+		if (leftover != window_size) {
+			if (!gfs2_holder_queued(gh))
+				goto retry;
+			goto retry_under_glock;
+		}
+	}
+	if (gfs2_holder_queued(gh))
+		gfs2_glock_dq(gh);
 out_uninit:
 	gfs2_holder_uninit(gh);
-	return ret;
+	if (ret < 0)
+		return ret;
+	return written;
 }
 
 static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
@@ -836,10 +878,20 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
-	size_t len = iov_iter_count(from);
-	loff_t offset = iocb->ki_pos;
+	size_t prev_count = 0, window_size = 0;
+	size_t read = 0;
 	ssize_t ret;
 
+	/*
+	 * In this function, we disable page faults when we're holding the
+	 * inode glock while doing I/O.  If a page fault occurs, we indicate
+	 * that the inode glock may be dropped, fault in the pages manually,
+	 * and retry.
+	 *
+	 * For writes, iomap_dio_rw only triggers manual page faults, so we
+	 * don't need to disable physical ones.
+	 */
+
 	/*
 	 * Deferred lock, even if its a write, since we do no allocation on
 	 * this path. All we need to change is the atime, and this lock mode
@@ -849,22 +901,45 @@ static ssize_t gfs2_file_direct_write(struct kiocb *iocb, struct iov_iter *from,
 	 * VFS does.
 	 */
 	gfs2_holder_init(ip->i_gl, LM_ST_DEFERRED, 0, gh);
+retry:
 	ret = gfs2_glock_nq(gh);
 	if (ret)
 		goto out_uninit;
-
+retry_under_glock:
 	/* Silently fall back to buffered I/O when writing beyond EOF */
-	if (offset + len > i_size_read(&ip->i_inode))
+	if (iocb->ki_pos + iov_iter_count(from) > i_size_read(&ip->i_inode))
 		goto out;
 
-	ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL, 0, 0);
+	from->nofault = true;
+	ret = iomap_dio_rw(iocb, from, &gfs2_iomap_ops, NULL,
+			   IOMAP_DIO_PARTIAL, read);
+	from->nofault = false;
+
 	if (ret == -ENOTBLK)
 		ret = 0;
+	if (ret > 0)
+		read = ret;
+
+	if (should_fault_in_pages(ret, from, &prev_count, &window_size)) {
+		size_t leftover;
+
+		gfs2_holder_allow_demote(gh);
+		leftover = fault_in_iov_iter_readable(from, window_size);
+		gfs2_holder_disallow_demote(gh);
+		if (leftover != window_size) {
+			if (!gfs2_holder_queued(gh))
+				goto retry;
+			goto retry_under_glock;
+		}
+	}
 out:
-	gfs2_glock_dq(gh);
+	if (gfs2_holder_queued(gh))
+		gfs2_glock_dq(gh);
 out_uninit:
 	gfs2_holder_uninit(gh);
-	return ret;
+	if (ret < 0)
+		return ret;
+	return read;
 }
 
 static ssize_t gfs2_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
-- 
2.33.1

