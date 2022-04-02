Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82154F0081
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 12:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245360AbiDBK2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 06:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235885AbiDBK2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 06:28:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780DA53B66;
        Sat,  2 Apr 2022 03:26:43 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2323C7Io021137;
        Sat, 2 Apr 2022 10:26:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=xxGyidWi2psGJwQqlwpxCh5pl8mDh9nmIKiIz6H+xiU=;
 b=iMjDEdmKblmtIjwTY0wY6tAYQIZrCXKRrY6f99bnu4YbPBpmJRCkQnt2MKdISv5SKVVa
 BPV4gWZj9tTCJ+V0/1/bGYb+KRAzcFR+rGCzBv9frj6r/ee15vFawOpvMMBRhY+28yGJ
 uBMV4gj5KaKuZlSXeZ8jZ81LVRvXJ+QSkuwJSaV3u/epTAwoj+XZhEsjuHaZEuJDCn+7
 5pgJdQHstJdsdEJQ7qYFyFNEi8HhOMUfIY/0noxzPW3EG2E3ujhKrrghmGfv5fCVHRkD
 t3n2fkzdoUf/HyO9z+0DS1o379x5P1hyJ4IBTeWS3MWNtdDuHITI4FyloL/yZX/bXZ7A cQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6ec9gbpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:26:40 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 232AMLV8001716;
        Sat, 2 Apr 2022 10:26:39 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f6cx0y4x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 02 Apr 2022 10:26:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f7lwKlWfIcgrFU96Mt514qvtl2wNovhIi10FpycHPE+OlAFDZBcHyWAemq9XNuimF41h5oZvjklIoeKKXdSHM6F6+Ldib17MF2PF75sfjnZl3Bkff9il+s3K+mFbmd4pl6RJRNw+2iQoEUm5Og8RlAxDvptOeMJAH/+xZT25ZLpYGkjW5IjbkHtQGF9KKq4uato3QdEbcQlnSUSWZMKn/n1zZQsT1hke2AX7j+BMYbkOkHTukpgtBDbeAjqRmAm/2HR4tny1VRGgBrwyUprxhAMazeFLaFs8nRHLvmBNv/2aL/UBSB2xh1ZrUw7TQlfgk0io857TRjJZJvoQ+LBgJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxGyidWi2psGJwQqlwpxCh5pl8mDh9nmIKiIz6H+xiU=;
 b=LfI/3e0kUOF+odzhEU+B6dlcFPwj69Mz1vZjFmTrW3tj69fYEYq2rjLSXkSmo4B4Hg5hwSf4mfLLjfsGaZ2/KDCWmprHbbsANSSiYlFkPlyX5MRTplXCwfOf4v8ldsuKD6sq38jBA4mQ0sER69k8uiP0VI5ijpAdGxnFrQOFDFGAbfbovXamvNUbLED+LQsHeuGROdn/x71KA/9wyiewAaAOxenBf0p3aiV3oFUbAcSwxwnyM+y+zg1iaXx9lo9U82BIUI0oVONe8WmdXhIXLmUw4JMo6dnZV/CvlAa2kllpXm3SBlLSnKQ5khnPsuLrzZxL0i7sIYPOt7KJSK3exg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxGyidWi2psGJwQqlwpxCh5pl8mDh9nmIKiIz6H+xiU=;
 b=UB40e80T1sduahoeIcnilmcvrcuLkRNmwfK3w0ZGGqCz6FGFsCQEyBFv8xOB9Veusg45pfV1n14ibkT4B4g5uAId3QsEQtQqVgGmqebeJgZX5cEwPCckx5RJO3v5uutCni0ySy0V2ViC0Lf78JMTnAyjHMZTB+yBZf+4ywVGjFE=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by DM6PR10MB3049.namprd10.prod.outlook.com (2603:10b6:5:6f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Sat, 2 Apr
 2022 10:26:37 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::54da:72:aa08:9a8e%6]) with mapi id 15.20.5123.016; Sat, 2 Apr 2022
 10:26:37 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 04/17 stable-5.15.y] iov_iter: Introduce fault_in_iov_iter_writeable
Date:   Sat,  2 Apr 2022 18:25:41 +0800
Message-Id: <14710fc2f61036cb075bacb3b72231e5f2e22b47.1648636044.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1648636044.git.anand.jain@oracle.com>
References: <cover.1648636044.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:54::19) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ba75482-ea2c-496d-ed68-08da149344bf
X-MS-TrafficTypeDiagnostic: DM6PR10MB3049:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3049C2BA5A7D79EDFD4C7548E5E39@DM6PR10MB3049.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rpwfRXxCvRojHtD4Ue980JeNgiDl6H7XHMtcZ5RIw+r1a4+iYuzH5xlSlMLqqACQAEF4zOgpmYOeUoU0dejnlwknXzGvrqmhQ0Kqaf17fyG11zau4W/RAcQu4oj1/wVulLrcVwCIVQfwfisLZmGmgar7nu1cUrrh4TeHbiLfwHnzapc2By1jqwER+mw5C4uu1BufDLZi8C9Mw5X35YBz595DSOHkUPTgQmWkYHBTW/dj1vOx5OqygfgR7OZqbFpI/ZKxLGVFBiL271ppDzyciW12NlYbxPcHwmjrQvF4dDc48onkQ5wsDtG8fBSnHYFn9p/KgsvW4Vd15SAg4W9ErRJVF/M2q+jkJPoOo286iHzZG21Y4/RhaOMSqVBgqMDYeuF7v86eKTvili1JDupK+4JRjcfiPfzcHKbTEb9rcebeg6zdh/2fBlnAopjQxTGY80fy/mq7rURcVd6xEWcjwoZ8rLWTPaau6S5hflQO6PD5JbwQf9XQplcXWnvQblOOiPf2yeEeIUwnpQl3xJHGD/4vDSjj3BNC0OBlGP+eNUmOqsqo3PjJn2zgX4YzDuIbS6HhULmjGFWI5ROvLKpgpjqjOnj3tzj/tTSwlQixiak8QboTff2xq+SEM2SeUJWeD/BvrEtCsJy8BqAEVZ0hVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(26005)(6486002)(66476007)(54906003)(6506007)(36756003)(6512007)(86362001)(5660300002)(66946007)(107886003)(66556008)(8676002)(2906002)(6916009)(2616005)(186003)(6666004)(4326008)(38100700002)(8936002)(316002)(508600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c/DBeHJgr81TI7xq3bmVjIAbT2AnSISmC49t1uIDw2jVTwzBmjj4LuPU5lvA?=
 =?us-ascii?Q?TSjOytSARWiG4vo87M5rKLKjwBRS+nm4gYtkzpXXRmYA6efFH1a9O6ZcP7aR?=
 =?us-ascii?Q?4yieFSR4viOoBlR9DCwG6peoOXdtX+//Fjc9t9RudpVyvhIlQM41bPhRR+Kl?=
 =?us-ascii?Q?nOEaSpK0h1EReubwlOhSd7J2WjJMb2KipFXF2EZtHsN9/X3xbmuT4jF4ZORT?=
 =?us-ascii?Q?O1j1g6LZxJTOq7SEd+K43TLALAW5aYeEUi9V/jCfOO/HifA3Q2M5O4DMcRHP?=
 =?us-ascii?Q?BUAW/B4W0Er1VlO5imbDfH5YiSZGRC/An0X7MEqEOGr/im7XkKmzRN/Ij2DC?=
 =?us-ascii?Q?N++1XT4UbVQ0F3Z1MJRMGSKJPHy6Qj5bngYf8SpWBMnidDOx2RyAxcv+5sk7?=
 =?us-ascii?Q?IBVdLjUg8N7Wmwx8jOv5Ky0O9+EtoEkG5ZZVLRXLX73mdN2PTZfQDqphlPTW?=
 =?us-ascii?Q?ywPlwrlO1EpUGgjE4vZZoJLIbFBVILl3NRgkRwg55ufmNfXOZojHEHs929Et?=
 =?us-ascii?Q?OJtKuUNfCWrdQKEYMBZULhjxphYI8OqdwzxHijp3oBeV3wUAPzSHGDq93/Xa?=
 =?us-ascii?Q?Il7YFaB01Z/iLmOwEKLIb7xdhd0+3aX8zHW0S4ux8LNwfPfB5mqs3LvNwznb?=
 =?us-ascii?Q?04UrG/JYp92YR8bCxbEQgIIE6OedyWRa7FKoOjaI4uZ3foj9TYjIBfBzBRbU?=
 =?us-ascii?Q?vhDD7OXEnZFoIKqZI/PVWzlOO7ptfOQtKt2TmX6N8fsaYoWnL8p/EEaUVU5U?=
 =?us-ascii?Q?3nmydpBzZzueztyikTs+RRpkPsIfb8BL3kyssa2c0IWYueURbGoHopvijHKC?=
 =?us-ascii?Q?2ybv27UCRK9+9GBQAw34sNs4+1D6M9OcEjEXAlBIoMnlCwFq+wEnVTMs0jdT?=
 =?us-ascii?Q?MB9x2vcm9u/gO+bxEXpfFe0MgWnB5LjKg2SyouIgiS9phlVH63JrBC0SJshU?=
 =?us-ascii?Q?J6rG+kzb0QQUsAxF9VCHPfg8rbDspNF1BISAuc2oaflLlN35kYAyrg4CiFPl?=
 =?us-ascii?Q?JMeIMFF0Zz5jW4pyqA+b1hf/YKqRZZro/DZeod/ufwPKUxA92xy5fYHE0wkb?=
 =?us-ascii?Q?tGU83aPmHJ2ZK1/LplAWcF6tfDjPSDeqbV2ZYy52EQKCYZcMHur9i6EKEG6F?=
 =?us-ascii?Q?pMZUnxMGQEyPY8meyVh1RnBMkkIJbW6qYLZNpE3xWmQ62ieFvIataSY6FD6j?=
 =?us-ascii?Q?OfvEBcURd+fX/prNKgFs0la+UmxC5KKjLXtNfuz74uC3ruccC9Qwc/x6llYN?=
 =?us-ascii?Q?uxeERXJ4RAKfdxTAHjNJ4gESnehq6G7CTMKhuzZLOcsKpANzc/0Mjx4eT9m0?=
 =?us-ascii?Q?sA/TSBW4mpJrfra4GjgpftSqCyNfIRY8sCG+zukeF8WO31TYVRPbCHmT3VM0?=
 =?us-ascii?Q?6C9v4S/iDfd6PJuu7ulc/6x38FuN3kx+9MPUzfT0KgHhSSu2cI3LTuQLXXiU?=
 =?us-ascii?Q?oYkPrYbnRgE2B0qrvdsDPqdcaEsdWN0c8tWbufk2iaIhBbCUthZIoGUBfH/5?=
 =?us-ascii?Q?X/IMLPleSWOH+07TuEdal+rXxYZlvs8frocMbGeleZkq5h78rdqh+nLt3Lz1?=
 =?us-ascii?Q?kph8QCJIxS3hf0GssLRttF77pmn/2Clrpd2NZYV0gaTb+uCyGh3KCtBPj7ka?=
 =?us-ascii?Q?JZMF0u8RruMCBc1+Lj8IeKldozC9YIQzvMwMI/2mVnvasGCDfXHoO5a/0EfO?=
 =?us-ascii?Q?f8ZGm4pMJgmbcTLN92C4OT7gzeliugoYTIr+4181Mvr7YEebeyHutU9B0luk?=
 =?us-ascii?Q?SWisdyoGjQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ba75482-ea2c-496d-ed68-08da149344bf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2022 10:26:37.5178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q9PAmh7mehaYsARuh/o/tuAOIo1OfeXLe5Yxf9/+7vwbrlGCXF4rMwITzn5I9y6mDCgZKPLw16n2XKuaZ5mSWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3049
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-02_03:2022-03-30,2022-04-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204020064
X-Proofpoint-GUID: ebmtMOS4Y_6PdCTgDBeqnJnYqa93unGO
X-Proofpoint-ORIG-GUID: ebmtMOS4Y_6PdCTgDBeqnJnYqa93unGO
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

