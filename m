Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A6D4FCEB6
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 07:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241873AbiDLFSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 01:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347740AbiDLFSQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 01:18:16 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9E6344EF;
        Mon, 11 Apr 2022 22:15:59 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23C1kKng012649;
        Tue, 12 Apr 2022 05:15:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=xxGyidWi2psGJwQqlwpxCh5pl8mDh9nmIKiIz6H+xiU=;
 b=dynU+Cucx7gZAaChk2IH4uYi39A59mGDfxPi3IpHO4NQqsKsGHwa+ZP9M+PRvFBLBynA
 drtoSPIgxaDPKrAqR8UulXddtIBxZcdf+3rXMLUsPUmLmipIvKezInqwMQQiH6ZywAWi
 lDGZVz7M3cvUSkrHIHAgTn5w34XoTbfj/+Qvh/FngGuoRzP35H7Y5NluULr2rh2RCjTY
 GePjKb9RUvh2Vxa0KPPU+1QppSpdys31/pkvufFy56tW9vfXWlnaRRYNo6HE9CtjEYuX
 DM4sXGySgf6WsuT/A3scpcFyLsLS+IPsWDYvL5evBDgXn3TZe4/mEvKEIXCNq1R/RR5L CQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb2ptwnrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:15:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23C5BErB028116;
        Tue, 12 Apr 2022 05:15:55 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k23u9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Apr 2022 05:15:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ArSqu+/sp4cQp9pucCPXPtSKrqNkM146bBJbheIGnAX3+6CSVBktQqGCTlXzdWES7BdnuM2mIPZkyxSlIqwxZ6J1jUBsTEH6DfzfDNS4ZOfwSlnL1p5zRkI7J1Ybnk7+vrDnEjTHxXbr+4Cfdq+P5AmRoVXBMN4wxhUKqNy8W4BeUSXcJqdg37JG0ieu7l9arSAEbssmicEkgyMbh9zmZePpvgnqIASI1K+cQVOTd1UXLvECat89kE9VdtSilxm1SK7ywukTqz9vF5U0MPTTBZGe1rd2lHEpZQNhV/SqJ1xWExd8bbRetSIGSr5Ee8cxk+btLem/S9sb2MdMC1Ofvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxGyidWi2psGJwQqlwpxCh5pl8mDh9nmIKiIz6H+xiU=;
 b=WS3E1430vwApx51HiLg3rCITYfVt7PPQB0K/ieqnP7DX556jmR6x1NOeDMN9YC+qXWjhN19DDXSSawLNYRY+8q57lrvppQOqMVBPHWfhBGAL0IExoKiDjX98GPWeLAqfmGxl8Hu8DOFRntY66CvkiLahQluiM3ieDMrF0sHZK430DN4ynY4f0t2ybNev+9HZnzq1XQjsEOdBAwJVFxw98AROMsnZE59G2iPmeT5UaKzWAsB4mXViOWIsDsLTf/hbSw6yuDZJojpJDLG7pSopsGRnP3ds+Uww198R6kANYx/BXSyD4bE+eOWfANt/8HjCNXEZXbExJ7sa5vlneAGPxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxGyidWi2psGJwQqlwpxCh5pl8mDh9nmIKiIz6H+xiU=;
 b=ewIwS8DktWjeeRDa33SPndPZgKthg9Js3eKEi3pYOoqjEu0pW3KnkvfdXxbsAIG8HZfM64vy2RODKwcJ8QAgUetRy7bJ0XItq9rFdwjMkNzLGTZVMUDUWyez1DXz+tWTzCgi0EURG26riXqdMLEM9Swp1dbunx6Ge87+bG41nvM=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BN8PR10MB3329.namprd10.prod.outlook.com (2603:10b6:408:cd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 05:15:53 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 05:15:53 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 03/18 stable-5.15.y] iov_iter: Introduce fault_in_iov_iter_writeable
Date:   Tue, 12 Apr 2022 13:15:00 +0800
Message-Id: <567e96aa787d4f03add03832ae0a2a28bef0904d.1649733186.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649733186.git.anand.jain@oracle.com>
References: <cover.1649733186.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::15)
 To PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de93bfe4-b22e-4828-3cc3-08da1c43841e
X-MS-TrafficTypeDiagnostic: BN8PR10MB3329:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB33297B4245AA86F06B04FC1BE5ED9@BN8PR10MB3329.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8uP5GKl3L0YpDBQSZ8MKhUah55iRv+APIAkX5VVMvjhGl0IiYKAoPB8lBeE7d2zTr+retq8PusI4ggNGzSWOkPcwwXRVelbfbawbC4Fcvnxxr60qPwrAda/H4gc0NZQhr3qbSd9v8YqVvggWgZKExH+Rtpi8znF6mFZV0027kO3kVSaUCjOiFRUPOYiY4CLTpkU2NeNP3j2Qzwaz0XhEVHv4VAj4eB0RENeiqiM3wdCuJ0VQH8F56Ry6yi4ExX+6CYpAToEcUJLxRHfP7fOErXz9iYTqz020yMtAWdUKqOhWwW71FiwQm0RjgTJ1hxVyyGrKPPc4dHLFCRqBg18Q97FWKxCkbgRPvONRkX+0kOOIj7/02TcF+OHm6FWkXqlcgnYMU/f+tOIkw0dJ/3azgwiUM5j4YaRYXqLe64xQAvyif8SqJkAAmG3Gr5h9+k/wit4eJtTzHRftAeU1ueSpd0tZKszC5nGjIsz0GCPzEOpK4Ihyxu1x8Yf0pk8tkmk6kR6WW5e5oCivD0sEl5yjWus5ycbA2FnwJ5rTgv2Mx0Xhm9hFPiT1QvNMHI/JqIskaCwK6ZNuDiYxl4FF8y1hWZL8hmVVI4qtpaeOECuwPOc3cITLBLzYSdxGc0PYybe+QJSIBLw08jIRdgakBfxEXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6506007)(86362001)(38100700002)(54906003)(6916009)(316002)(6486002)(508600001)(6512007)(2906002)(6666004)(5660300002)(107886003)(2616005)(83380400001)(8676002)(66476007)(186003)(66946007)(66556008)(44832011)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YD2wVKgBO9GQjS3BbXYosofxXkfzqtMk8vF9RhGyCcZ6qilyiTa1LZviR3w1?=
 =?us-ascii?Q?4/CdxgDPTFFqrv5LwCVHqkXsKo4cYHNhsW46WI6lOEktHPNGtNGEwZeqJvxl?=
 =?us-ascii?Q?7Tw1V+ti6JMRr6qSkkqZ3LOuaFUgYQrKEbhpnpXqhoAEm8vjvi1K5KTQkwKe?=
 =?us-ascii?Q?Oc7l0/kqGPPSrnFAcm1QsfSmx1Ch1FCunIwoRxldZiVyFYUrDvVP0NzjlxBx?=
 =?us-ascii?Q?TXBgA7LWP8KL/YSyAhS1NKOeB+NJtTvao+c6vHako6sGdHqNIwwLPBhlVg4s?=
 =?us-ascii?Q?FzUZe5v528k58n9b8HOHkSkwjCcuCyIrhr70j4iECE0jJ/FTQXvUo+vc2lHv?=
 =?us-ascii?Q?IaWUAF1cnKF4z48a7Lk7NXJYEVim+00iiXfeu3TgQf5/vF66T7BtVGizVRiW?=
 =?us-ascii?Q?y68aq3dR1vRpMJEIQJvkwyvBf8sms/daidTB53uHmkIZklpLOhti7+qz0siO?=
 =?us-ascii?Q?v0xrh708s0RZouLsjPNe/M80vROfblG5JeC/a3ppX47v8QfXNX/4wTxOKIY2?=
 =?us-ascii?Q?XIsceE4U5zAyWMeaigctocw+tHOl1OrlgDrNJzuAZx5khbuHQEWCourBzfYE?=
 =?us-ascii?Q?CrCkQ/a2trtK0+V5tFTk0BfXCQQ6VDQTB1BV7uUGgcv3JtZZ7aVth0Qh7fgA?=
 =?us-ascii?Q?4w/ca3w8bMnPJBFOFrU4d2VDVDi0OsXcw9It75MVoGFHxK139WsT8A3dETJr?=
 =?us-ascii?Q?XthJVsvhQzNRN2tA+g4WiGnOhf3tdEGDbfNcNw6JFopDhOyuSnSZ4HyIhqnN?=
 =?us-ascii?Q?Bq/rmyDZlLBf5QvIBhHuRaGFQweMqKstilUII7J6qhNIRi9vJiSeEAc3H4m8?=
 =?us-ascii?Q?f0AFqVxOXwNC3zIoSLR7urVk9vSouianS5RrD8fqqKHg22t53zqxtCjIRVnP?=
 =?us-ascii?Q?5q9iLcVkZANl5aoXnI3zUKdgLlTR5GT+ZFG7s1RdwxW5G6vhDbNe0WEAOvCD?=
 =?us-ascii?Q?i6l3pFuVuWXnMZXRCjZ5BgGszRApUkwEyBpQVs3DMCGw26gilPIaGZFe5wdd?=
 =?us-ascii?Q?rqPLHm3v+gvLgHq9DuEZWodbS5WH8WGtglT1d9YHCyiU4WchGgsUTypndf7W?=
 =?us-ascii?Q?X3MmZG1mgX0e7WNnhhh+ipfaBuLSq5HjRFqT8fPFECkLNgcwiF7OfetjY91A?=
 =?us-ascii?Q?C+mjXEbArs7GcRDqe1cPhpq983PpGIItp0LXQIqmTwz3sotbUc3Vac3NCwib?=
 =?us-ascii?Q?apbV15QdzkSO0PFwpgFVRSF+O53Wx40Ajmt2Sv77jZKE9ktVPAj5MRipViET?=
 =?us-ascii?Q?PzX3HgYPlTFYLikIZS4l80cPr5N4T/uU0dRpxDVUAuWNn+ZgAHcuPeiaADP/?=
 =?us-ascii?Q?N/rdkfqUaCsecyvodZasbWO91jG5/oeQwUoAONJ9TP3P8li/7TO8He37MTgs?=
 =?us-ascii?Q?/ntz6cb08bF9vO8O7Tduydjy9ztzkjC0UHe24GVbRv0afuljEPBGCGCR0dWT?=
 =?us-ascii?Q?joE4HoMSe8/2oS06nPkqLk2WfQ8nuJrPxzPBDqFRwdEd6cY/6nHfKfXrBgvs?=
 =?us-ascii?Q?BP/P1cEi7FU8c5iomfU/Ove2BLXWUbNZbk/sab5tCVFgsylUurcMpezkMxjr?=
 =?us-ascii?Q?F2rYa3KI3epVumfAV6+gHs+pREw+XrCS+zr8cAEULRwmNt5gCwlJ/ka8+tOo?=
 =?us-ascii?Q?fPawJLxXZhIaqrqpTllB49peKhhTn8VTR2CUnjkmrIyGENk3nZ3FN7TUR6E+?=
 =?us-ascii?Q?SBDGp4LUiz2+agPpFPqJxP/Z5CfY8JfTA4SG7rRW4UoUHf1pPTsqL6clseIg?=
 =?us-ascii?Q?EcTNkNu3io/ARvUTViCu5rknXoiP7mDMEOL6VIY2LH9qJg6cnlLx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de93bfe4-b22e-4828-3cc3-08da1c43841e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 05:15:53.4275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7SM+mMZoZ4uXbR3xCUzNB3friBJFTmrYNwa18+rpjKdswTOAwxT7p91SKkAp7a+SJq4CZVETeGFe4BgRF365SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3329
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-12_01:2022-04-11,2022-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 mlxscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204120023
X-Proofpoint-ORIG-GUID: BEbe4HcuV3n_0S-dTfmMwqsn_v3yofSN
X-Proofpoint-GUID: BEbe4HcuV3n_0S-dTfmMwqsn_v3yofSN
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

commit cdd591fc86e38ad3899196066219fbbd845f3162 upstream

Introduce a new fault_in_iov_iter_writeable helper for safely faulting
in an iterator for writing.  Uses get_user_pages() to fault in the pages
without actually writing to them, which would be destructive.

We'll use fault_in_iov_iter_writeable in gfs2 once we've determined that
the iterator passed to .read_iter isn't in memory.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 include/linux/pagemap.h |  1 +
 include/linux/uio.h     |  1 +
 lib/iov_iter.c          | 39 +++++++++++++++++++++++++
 mm/gup.c                | 63 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 9fe94f7a4f7e..2f7dd14083d9 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -736,6 +736,7 @@ extern void add_page_wait_queue(struct page *page, wait_queue_entry_t *waiter);
  * Fault in userspace address range.
  */
 size_t fault_in_writeable(char __user *uaddr, size_t size);
+size_t fault_in_safe_writeable(const char __user *uaddr, size_t size);
 size_t fault_in_readable(const char __user *uaddr, size_t size);
 
 int add_to_page_cache_locked(struct page *page, struct address_space *mapping,
diff --git a/include/linux/uio.h b/include/linux/uio.h
index d18458af6681..25d1c24fd829 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -134,6 +134,7 @@ size_t copy_page_from_iter_atomic(struct page *page, unsigned offset,
 void iov_iter_advance(struct iov_iter *i, size_t bytes);
 void iov_iter_revert(struct iov_iter *i, size_t bytes);
 size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t bytes);
+size_t fault_in_iov_iter_writeable(const struct iov_iter *i, size_t bytes);
 size_t iov_iter_single_seg_count(const struct iov_iter *i);
 size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index b8de180420c7..b137da9afd7a 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -468,6 +468,45 @@ size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t size)
 }
 EXPORT_SYMBOL(fault_in_iov_iter_readable);
 
+/*
+ * fault_in_iov_iter_writeable - fault in iov iterator for writing
+ * @i: iterator
+ * @size: maximum length
+ *
+ * Faults in the iterator using get_user_pages(), i.e., without triggering
+ * hardware page faults.  This is primarily useful when we already know that
+ * some or all of the pages in @i aren't in memory.
+ *
+ * Returns the number of bytes not faulted in, like copy_to_user() and
+ * copy_from_user().
+ *
+ * Always returns 0 for non-user-space iterators.
+ */
+size_t fault_in_iov_iter_writeable(const struct iov_iter *i, size_t size)
+{
+	if (iter_is_iovec(i)) {
+		size_t count = min(size, iov_iter_count(i));
+		const struct iovec *p;
+		size_t skip;
+
+		size -= count;
+		for (p = i->iov, skip = i->iov_offset; count; p++, skip = 0) {
+			size_t len = min(count, p->iov_len - skip);
+			size_t ret;
+
+			if (unlikely(!len))
+				continue;
+			ret = fault_in_safe_writeable(p->iov_base + skip, len);
+			count -= len - ret;
+			if (ret)
+				break;
+		}
+		return count + size;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(fault_in_iov_iter_writeable);
+
 void iov_iter_init(struct iov_iter *i, unsigned int direction,
 			const struct iovec *iov, unsigned long nr_segs,
 			size_t count)
diff --git a/mm/gup.c b/mm/gup.c
index e063cb2bb187..bd53a5bb715d 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1716,6 +1716,69 @@ size_t fault_in_writeable(char __user *uaddr, size_t size)
 }
 EXPORT_SYMBOL(fault_in_writeable);
 
+/*
+ * fault_in_safe_writeable - fault in an address range for writing
+ * @uaddr: start of address range
+ * @size: length of address range
+ *
+ * Faults in an address range using get_user_pages, i.e., without triggering
+ * hardware page faults.  This is primarily useful when we already know that
+ * some or all of the pages in the address range aren't in memory.
+ *
+ * Other than fault_in_writeable(), this function is non-destructive.
+ *
+ * Note that we don't pin or otherwise hold the pages referenced that we fault
+ * in.  There's no guarantee that they'll stay in memory for any duration of
+ * time.
+ *
+ * Returns the number of bytes not faulted in, like copy_to_user() and
+ * copy_from_user().
+ */
+size_t fault_in_safe_writeable(const char __user *uaddr, size_t size)
+{
+	unsigned long start = (unsigned long)untagged_addr(uaddr);
+	unsigned long end, nstart, nend;
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma = NULL;
+	int locked = 0;
+
+	nstart = start & PAGE_MASK;
+	end = PAGE_ALIGN(start + size);
+	if (end < nstart)
+		end = 0;
+	for (; nstart != end; nstart = nend) {
+		unsigned long nr_pages;
+		long ret;
+
+		if (!locked) {
+			locked = 1;
+			mmap_read_lock(mm);
+			vma = find_vma(mm, nstart);
+		} else if (nstart >= vma->vm_end)
+			vma = vma->vm_next;
+		if (!vma || vma->vm_start >= end)
+			break;
+		nend = end ? min(end, vma->vm_end) : vma->vm_end;
+		if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+			continue;
+		if (nstart < vma->vm_start)
+			nstart = vma->vm_start;
+		nr_pages = (nend - nstart) / PAGE_SIZE;
+		ret = __get_user_pages_locked(mm, nstart, nr_pages,
+					      NULL, NULL, &locked,
+					      FOLL_TOUCH | FOLL_WRITE);
+		if (ret <= 0)
+			break;
+		nend = nstart + ret * PAGE_SIZE;
+	}
+	if (locked)
+		mmap_read_unlock(mm);
+	if (nstart == end)
+		return 0;
+	return size - min_t(size_t, nstart - start, size);
+}
+EXPORT_SYMBOL(fault_in_safe_writeable);
+
 /**
  * fault_in_readable - fault in userspace address range for reading
  * @uaddr: start of user address range
-- 
2.33.1

