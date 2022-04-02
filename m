Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DFF94F0097
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354322AbiDBKaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354313AbiDBKaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:30:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBEE1AA4AA;
        Sat,  2 Apr 2022 03:28:14 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2321i01M024919;
        Sat, 2 Apr 2022 10:28:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=u7pbuSOhkZxQgu9xuy7BDjp5Kav08Tt7RWnB3zCSkKo=;
 b=TaABM1y7d85Xbatfp0hN1PbJ+MFpEi9T6Q4tQiIFgMyOENHrCos8xVxwKy68iZJ3gtWR
 Afh4+AGxfn3CVQ4Dx9JMBPNtrL8+iD8IGBzrSgKl5CoAnifbZ9jHsPk8cePbVtlPz124
 YSdJAxVX+NTDskxZ1dcio7Pq3Y3Ab5iA123SY63XS08KjP/q8C+CWX9M2bsIzsZhdD5v
 daXVYni+6etZpwIszsq3eYmPRG9T0APMVjeco2mNCjlJJkWDFtKqtuSAPlmwfgcfeKdT
 jOrE7VSWaX4usfUgJ6iX4G7DGQzKv7uUOovTcLxrIIm0WaUEjVWremYBR/2WIOw/vb5q dw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6d318dsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:28:12 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232AKhW9027582;
        Sat, 2 Apr 2022 10:28:11 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f6cx165yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:28:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCiz2/NF37nsElDX+E8YdocbytILkV0LLLPYWfC0ZekUSbL8+ITrFSHuep90AYO8FuRNh3BJ9ELCPfGSsMBTyfOiSfr4EzgqvJwoyXKYvXoCYkscIa8gMdIXDtZcRbzXeSDxONy6N9q++1jmUHSsSqj9FZnM3akVCFuVGh0ugGGOXFZjMQt5haGNuPVwpDfFZxp6QOWGSE2sTacMBI7yFPo2tTKehrgbi5kgHMQDhI7M2VZJyIoVAN19R+Hc7MFYkxVqfd8wAMRtA1YM7n3oaCW4Yfdbi6esg6sulHwg0HrAIr1JWfYQG0Ham6Ajg65sMAOX8f+cqnprJS5nj3rmEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u7pbuSOhkZxQgu9xuy7BDjp5Kav08Tt7RWnB3zCSkKo=;
 b=NuiewZDlmInNenzy4ylsazXUBHyCpIvoX8NWorgkbATtK8Z2xmNlhXu8C6iGpCyZCwBNnL4vz0diXbRSpW5Lvi9o4lGI5nmjnLVy0mufZkNJh/XyyonGPwArYz4T/2CQ077Xp2dCShAXrtZLMrEVQ2cm5pQ97YlLrOQ88P8zPJyZc/i0JoY0rwYe+QyBG7xc2L7MOWt7APcL/zPAZObHDhVHCzctPsxaryoA0dY2bJv26wk97JRTjzWGymwUm/A29MJvhG74qI/7aZqyQ0NBrup6M2PIxDEeHmQRS3v6v08pQYo3nItBF3GpJb+yQ5apLC55/SpAaJ17ebPWtICviA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u7pbuSOhkZxQgu9xuy7BDjp5Kav08Tt7RWnB3zCSkKo=;
 b=rvEtd7tZp9guM5diJL3l8qMmPX8lmc1/BEuOfVfEdLPn1zIsSiBY0+LM2y9axdbShtx3hiPg+snfw3Sos7bwP5NcWHwufE9p1wkukPZrCiJk0PoyNOBgihifF/f2Qa6YE7lnc6vorexGxNNv6tdy5AsINuwsAOFoIdLqxY+sWVI=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:28:08 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:28:08 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 15/17 stable-5.15.y] gfs2: Fix mmap + page fault deadlocks for direct I/O
Date:   Sat,  2 Apr 2022 18:25:52 +0800
Message-Id: <78e2ee8d1958c50a0fbadb15dc18df91b538bdf7.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0008.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::19) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d1a23d2-3be2-4caa-487a-08da14937b3a
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB30494C494A113D6289EA8B30E5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YJyy5VbLTz9dWQJE9wormN5WghGp//c0hMvGpOQRtH/hZT/1+GAb5MGsIDvo4YL3Xf+h4DEvZLNPzZJOE7nTRlPZd2Z/Eo4NLdu6uFiRjDFxxxGeRJ5vMJZvg2sIa3h7XESvD0TSu491xVZp05dpYZR5H85q1WNKc9Z/ftvz3ociljUF6z7sFKiLK4f+SsGps4Sd7hVJjICw47dHtV0mPMpmF6Flo0hoIfkAmwOtQqIqRbUGRh4qc/S142j0zpo4OghFGJv1dZ35JOfm/Qagla4mE+Vom3pI+wQvCGJfttOy8T1TkeO5UDfSJVfbaof96q1r2XwF6D1yNLWG2qbdyHSBeUntVinxD53x0lwBOAo30MPBKhnpAEXBjjcF6PjEykPcy/xDWsu6UwfBDEB7E6WRV5mP1fIFxnBjGY6GvMrUjPYEPUGCZdyEe0II2PpNwRH2PRLGwC+FYToNLIc2AanUlAbGsPHs34e3xtO9UwrHZeeCLty94MqemXPl3phev7Vrkyumz7ZHPtMVQCfA1fO9o6dxpYTHbqmeSu+ahzjT0PqJ4ELElIqxIRG+RA3FRDhwlLBtoYqRd23JIjdDbPGwmFlJY398FeIKboGVaScLYZypKputgMPNaoN0Qtx1ojWmXo1hqNJLpQdHf68Beg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(38100700002)(83380400001)(316002)(508600001)(6512007)(36756003)(86362001)(26005)(6486002)(44832011)(66476007)(6506007)(54906003)(2616005)(6666004)(4326008)(186003)(6916009)(66946007)(107886003)(66556008)(5660300002)(8676002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aZI+lAvEeqiaTs+3Po0Y7i3OkX8Xtn4/oVEqaU6pKpO6hw0VIWbyI1HgDOIT?=
 =?us-ascii?Q?l0DRRMJG+uaEykZ3lJEVxeyMeY2drChCaPCbVX93dscCKeth/Cv6Me5TtO8q?=
 =?us-ascii?Q?JEqHRUDodaGcwUwESC+eF6sFII6DluzdboxrNX0w686iuA51QXBwPVSYivvm?=
 =?us-ascii?Q?vsBR6qoA+G05a+/iMRbNAdGnrQr5MFgNpyUMp+ysLnJjchINHf8A2Zbr+IYu?=
 =?us-ascii?Q?gTojk2KQwKtWTYOcy9Q6sgi3BtHG74bVxHD3du1DEDnXVJ6gzQ+fAWSf5tU7?=
 =?us-ascii?Q?YqUWkZ6FlewppQePQ8QIKEkohWOk6M89DKCZjYDCNgwdCpCiGZDqUz92WInU?=
 =?us-ascii?Q?LhgVLBbPjSNFuUzjXEX/8gf3Im752kXwitU09PwGTPKNacEcGJiuUI9sccjc?=
 =?us-ascii?Q?vfBv0ZC3vHITJj32kcxL7/5iWKVTpAgdPQqTbqx8WNYmjyCLi392M8dlQvfr?=
 =?us-ascii?Q?KvOZD02DWl+5eSILBG9I6qkbMcIaevwzjgvFQjtIZYWS8NiNEnaaj4hx2Ku1?=
 =?us-ascii?Q?XSJVDwL4QP/Pixhhu+/66EUaRPUzoJxeXue8A8F4iPL752U9JOjqk+AGfvmP?=
 =?us-ascii?Q?mrFKyd59G1vQqMMulApzsR6N+VpmypbbISgPeFloRLmv6vuWtbik4nme+8W4?=
 =?us-ascii?Q?ClhpCTdNYdTaRv0nCwsYebz5NBpduCErxbZhQAYQryo07GAR9fvIdSI3+zFs?=
 =?us-ascii?Q?e/GJmd4cExoWegcFcEZaiChjMAqpBB4AB9kB6eQCDAiu2GMlcSGPq49qS+Rx?=
 =?us-ascii?Q?zzGy4rbwNtERYYfuuTWDGxWVLZvM9/wpMYkxte8YpCCAt8SGJiiK0VYMUqJZ?=
 =?us-ascii?Q?AijyxpWrJeVC7rDjGpllaFEvPtuUdA0Fl8YAmcdZXHQCoSTcbf4voE0neXQY?=
 =?us-ascii?Q?H2OsUmu/a+nyYF9Ny7RRj5KSHcgHsc0kGal2m8Dd7Jh9/XKn/IZErsrBqQUt?=
 =?us-ascii?Q?jESljIXGmDoidvtUtk4UOyX0QYhhmHdiMNcHpgAFcLMfBfHIcDmt0UNq3NQD?=
 =?us-ascii?Q?XszqzZoVdX/Lg8bosTZDvKrz/vdjMqHeWRXU04YesHcxc3yf2y9yrey8T0yW?=
 =?us-ascii?Q?NXvnWx1kiNDmTVND6XMBzcsRpfgfmaWzDxPYPFfkLAmyMkmOVxT0h5AhkRRu?=
 =?us-ascii?Q?1LI9OaRPo2Yc1Q86aKF2kAj5nb5+dXjv6qKoC4A8znd01ZR8gCtZHD68MHMr?=
 =?us-ascii?Q?bMgZgBk0AOugfKC78AtBj0iUIz8TMz0B+QPpNQOSuYpCc5ortCjwakr0B1mL?=
 =?us-ascii?Q?frRtjQsdPlELMSFeLbIMDTiEsm75g61ic6JkZrTNESOwcC7VXA5kB0OyJBNB?=
 =?us-ascii?Q?gT1nD9wC8qEq2VuCN/p1yFLkEHSpr49rnjMbEcwyNok+AaS3uyHJ+YkqM7rS?=
 =?us-ascii?Q?XRbZhiKwkFl4IcStThcxzUlzEZ9YfEIrws9teGsAdMs0wZR3dNp+W7+aHGiP?=
 =?us-ascii?Q?FJAZZXc6BulkpIlxeubLqk4GPFXgMNPw9p9UpAgONJU7O9yoD5IFMNnPQugg?=
 =?us-ascii?Q?M0qYcgjuEWszi6f8Mio2+5MmrYNIzg1WalqHKIRqNPNUnRZZG/hf4WuyWqV7?=
 =?us-ascii?Q?wPDbzQRsIpwc2iuXzw0o/qdQK/+wsn6ucUmzE/3EAjr9+BM7Kgo+3ENTgTmR?=
 =?us-ascii?Q?XpE25zWTaXNJkUPZsIan1O1isbtg7Ce1QnW3/rTab3EWyO1hxJIB+vJKlfNv?=
 =?us-ascii?Q?mRlEI2HQiHcys+8+Qu6HZwMVhXTnYHOKcCDp132/HKa299CnXa0GMD1nXTGj?=
 =?us-ascii?Q?VL5pQ4XMdMs2O04iHKDALiHtSA3k8B8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d1a23d2-3be2-4caa-487a-08da14937b3a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:28:08.7292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yb95xqurTYUOUtJlgzyVR135apu3sgKUtGozSPaFxfc0Hq9JynjXH5Szz8kl/57xi71cgalxDD/1ct3SeQTHbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204020064
X-Proofpoint-GUID: f7z5_EI1gsLhpsDD3QUn9eiGq9eqSUj9
X-Proofpoint-ORIG-GUID: f7z5_EI1gsLhpsDD3QUn9eiGq9eqSUj9
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
index aaeb0e9bc04d..d7b55d0ca09c 100644
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

