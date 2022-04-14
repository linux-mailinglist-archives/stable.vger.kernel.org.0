Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A69501E56
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347019AbiDNWb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbiDNWb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:31:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BD86559;
        Thu, 14 Apr 2022 15:29:28 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EIbRft018418;
        Thu, 14 Apr 2022 22:29:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=xxGyidWi2psGJwQqlwpxCh5pl8mDh9nmIKiIz6H+xiU=;
 b=OETOJv78tEwAASDyJQXeLXtJ/S/DjnZ0ROS9H25ZNsuGKjZ7zMGmt6F3GAfmG0vPLutO
 zW8iC2qrBxLtfCPFpY5BFq8TpqdiS8NEgKXnQzh28x5k9rL43zJ9KZ6BXqoGg6/bgezX
 jNMORniKAzo2bgXBKARXvy3OqX0rTFAh7ic/wNtsIkrTJtF9pvN/m/7Cu2uafrr6QvcM
 zUb0i4/GP99Wh+QqYgPXOql18VIEBG2egfCe/Cx2z9NY+pp1hJ0JC+UtOb78WRn45at/
 qK7myGvAfPc0r4Y1TnOXYWQdor/n0TyxMnRr5vF41NwhXnzpNbQlqBVcAoTmgT1pbvQw nA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0r1p624-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:26 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMFvg5007784;
        Thu, 14 Apr 2022 22:29:25 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fb0k5erqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TAuTi/cr1voUlHIs1b72rYj5QqMvFJKAl8S5Lm6pqSbUGW0SxxHUYia2fY1kfbW8WyvHkhjzLr4TQiWy7/v2VPGCiOM16vFySrxGAF9GuEebm0/5dI4F0AUY2YhH1pumXjqYDdNci1j+NLgRnvVlcyuciqn/vj4gwjtQaAVGV2nR+NXtWpPRvsTz74FtOx2Z4WDwPDuOQa6G1NIMKhHUPeAAiKdq6CbCV6YHSAbi6Maav1uNwppzcNZtqiNtBj8oB42/kg4r5XesqNkaMuh9C5Um7XCJvNGHkA+C0fKND3xUxGnrG2peVHse8kOo5ag7uk7kxFQaGYrahq3dPXUUbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xxGyidWi2psGJwQqlwpxCh5pl8mDh9nmIKiIz6H+xiU=;
 b=jLLR0liy7+eLo18S01Tf1nWIwk+ey9DJnzgiv4X3D0FCAy2WchW6q8vloCSUbqKHui4XToPDBp75t7iJEKcrJDctSm3g+KJWeiUot0G/eufAgs9i4Ui44p3iOto+aEEe3d+nIfYPrQj/F12TBgMBJGirrl7VPXPsnHx7zcBotGjEvSPxuqOij7kroR/+WlN7jvFJj1BNmBdsTxaBmiOOoc0N6oX5IDkfB6Xhq2Qj3k+90QB62+z0hO5RtVFuL4LMVBZrPyNJxbPAlbhlmHX/nwIVS2Aaj4V3nQIGNPvAF+ieK7Dox5zcvo5ELv8xj2l8cYOqpW/lFrVSnDdMir17qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xxGyidWi2psGJwQqlwpxCh5pl8mDh9nmIKiIz6H+xiU=;
 b=Ovk3vOdUJ2GZO8EUY6XJr6ztRfChbVgNUUR8X/6CTWi8C1aiTmdu1s3uqmcG9AwpVg6ER91t5Aos2MM7yYDMQQYousbh9MW7Ib46JLziXaFALypBU3AwlttUUxOKUlpBKVjF2FomVFKvSe1dFg5FUDCiIRMii6/6bFnmUol4VcQ=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by CO6PR10MB5572.namprd10.prod.outlook.com (2603:10b6:303:147::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 22:29:23 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:29:23 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 03/18 stable-5.15.y] iov_iter: Introduce fault_in_iov_iter_writeable
Date:   Fri, 15 Apr 2022 06:28:41 +0800
Message-Id: <8181618a0badc14fd9bbe13e26164bc601c59df9.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYWP286CA0004.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:178::6) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dc0b8e7-bd22-40f0-1eee-08da1e663999
X-MS-TrafficTypeDiagnostic: CO6PR10MB5572:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5572CB0D8D4E2A4F74C65CA5E5EF9@CO6PR10MB5572.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f+/ypwbHSxq7Q4uhhjAIN1RilJhes4vAyOjZjJhW+h4K+VKnVs/5iqEfDhNHfKtVe845YRo9wqzaJ0+odegppCGBGSkh++rHVgvZyJXgfMja9zhaFUg2yjnrdjjL9GjuOq0B7CfbWClcPiIdTuwompJAReT+0y0x8HOaWekqex+X1v/vKSehvb0ct09gmfC3QQQ1QFXk/98nKcXIFCklpyUHrrb9F30gDK3O8S1yXgP7hK0sajMYB3vCpY/2ogiNpkhd27VtBJZK81fqOMUxtHGdSYyef0Tyqv8hW8G15A/t10vZ4fSfmJG9PTekMEtQXF6O0zA96BSTYI1Nz3kUQq4HWCMdrJ5MD44mrKznXZPuTKgdcBer5h4DD1W6U87/DWBMsZFoggi5PSnqv4dogn6NW8xqD6S9l1AsTLH/DcbLx5Zu/X9rwTVQ4VzCTkPfKxZHRtzgXay11VNTZU/ZlZlYPZjL6bibQZtyn9Nkk9PmmDulbchfodXDRfGYsdO994B6ep+b3Pc1hwsE9hVvGtCQMGwWaxW/4FsFQprZYaZPDz5gzfsMneRCTkHn8QHgnJB3EFMCXBx1OCo4MDFqiaZl+QqQD5w00muU8wZUBlXvsKpAZdR6N0JtSjz36EqXcduHgf4xQzxTSmoAcgRT3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(107886003)(83380400001)(44832011)(54906003)(2616005)(186003)(6916009)(5660300002)(8936002)(316002)(4326008)(2906002)(36756003)(6666004)(6506007)(38100700002)(86362001)(6512007)(66946007)(508600001)(66476007)(6486002)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N3SxrRmTg+TdyUlU4SvpcjWf0qJcOORZZ1aVxyndBirG4MuKHd04wAXbc+Xe?=
 =?us-ascii?Q?bcuGpn8y+G+/9CdO/Pa3xcnHjoNNFsfv2a12EjftkdIZEhBnf+6rNZOH8796?=
 =?us-ascii?Q?YA5kvHOEkBfOlrsY1glt0x9zR+jbEvQPharAyZ86uRVmgPGvAYe680N/PICq?=
 =?us-ascii?Q?VtK+Z+5JpoAXwhwuhCEEQpuIizlPp90LjcWRp8GHOh2rtqX0x0PHIEIhpLTh?=
 =?us-ascii?Q?CXpKiTBvc4Dkz/KUUxhzEm9LK62u0TUPS/W6B7RJsbIVsbwTq7X83qXpqL87?=
 =?us-ascii?Q?Bk4BIZVghn2ZuEd5JhLKG0iuYX3SYXuTiGT46EFrgg1r15LXLC7jSI5ckf4h?=
 =?us-ascii?Q?15nbfyz/ObwxUjfOrs+FyFi2UEWfHOjCNA8n71jXmXuX4Yvd+mqxDqWlq8g0?=
 =?us-ascii?Q?dVfaAWlF2BQ6OJQCePPKhw00Fkcd5aWodgCT+gaWaB+B12JKkjEPusBDrj7s?=
 =?us-ascii?Q?RZcYwXxO0ZHf4rl3b6SPxOJ6vv6cv8TB1L4lFtVR7VVeFxOEfQCicgMVr0wY?=
 =?us-ascii?Q?FYVzZFHa/I7Z3JYAXKKPC1Eg7P2Fi4J4nbi9RAgck3M924vKDFgUdCRqY8ep?=
 =?us-ascii?Q?FByt67yIN9Ml2BkDq0Wsng7z6OgoHxTtjioeOoGBc1La633+nzpiJZBXpAGP?=
 =?us-ascii?Q?gO2UMFk46KSDd0+lHeZoOfgHBxi1aeND2s5TtD15gWqkWv0zciU7XeOeJMkW?=
 =?us-ascii?Q?+zAEvODpFF0f8aSBC2DByuwh6OoZjv+ixWJpnZMdUt8cw4SnrXLXexj8djiT?=
 =?us-ascii?Q?OiowRFMzPVhAM1Zo1oru5XUtkr/pc6Vg30imr6tLfPa2A/z2bXIGv8bxWmiW?=
 =?us-ascii?Q?mXAouvImpFAzMAYLuiXu19Do14Q0MkYMjPrhHdFCIZcyIfllwUlI5ywT6PRR?=
 =?us-ascii?Q?z+BIPfFIlonOpcFymSIB4GuqBKsPQmnmd43Ua4ob0q5o1tQ6bWWU42W41PRA?=
 =?us-ascii?Q?a0hl06VnxS/wpQrFOsxRgYtHBRAjkkf+y6bSxRdKWnBqKVQ0GZ3jvbbFVWAi?=
 =?us-ascii?Q?70DvfnoIyM0IHNinTuSW85on8W3gm6FHijzoZTaYCmcTv9KtJ/QHiVY/vfYD?=
 =?us-ascii?Q?VoyTgnHGkm6lrSqwqbJzS2nQrsqAwlR3iZtfj5RL3LTFMgMC4HxTT7snlTi5?=
 =?us-ascii?Q?DgHdA5N4Uw1Pj3ab/hLT0FK5AfGURhiZP8TQtFDH7VtbloKpMGCfwmbdmwik?=
 =?us-ascii?Q?7X8/nk2U+d3R/XwpV2bq4gY4CXiWva/OZR+uH4cMIcHrRajXUcXLoX6+hfti?=
 =?us-ascii?Q?GFOlcj2BVS4GnoC+73D+P+dBgZIdprRYoRWgHLoxBJMtdzujitEsMPtNDXz7?=
 =?us-ascii?Q?2YHS1M4z00u05gsal9kp22IXE6U/+sE5gjvU5CiW+jqRBVhDYAuybvWtQRRK?=
 =?us-ascii?Q?JLohlfXL8YEep0wST9H8opLqiB2Kx4cYaGsnclzo4Du0/oNfFbTuvEFWlCtD?=
 =?us-ascii?Q?iPpUBO6zS1XifyQSB73IG6JpakSbvbAOBEeJTrdDjPvXOGu09Q0wnlnyjVpD?=
 =?us-ascii?Q?hqBeI/W54q7pDjMhIySOtBw+wzs8cpdp/oRFSnHdf/dAU6rli4IH4OBSw5xp?=
 =?us-ascii?Q?JVwD5KtN1xq2DRANB5R7Y2kRYXnPCvpNk71o/omPyFLaBsR9vORwJ+ZJYP9B?=
 =?us-ascii?Q?zuXXMrfA17XBeOzaSIcWOHhwM52Bgj8MtaT935RxBPxKUhVocIL+RXLmqOTY?=
 =?us-ascii?Q?AJo5pHJD7Vllr7vGMp1W4X/pqUAHl84a0AKJkPtgVd/t9E7ii/P01uMC/Jbt?=
 =?us-ascii?Q?7PTWVblRGqN6a8bmxmvCchilXfV5bv8FYdxTV4RFY6vBeB+3bW5h?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dc0b8e7-bd22-40f0-1eee-08da1e663999
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:29:22.9898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X13WthV9evbZA+Ia64ISASoU/bXlHD/MGE+Oij/P1YyCM36a1JTiCQqgpM5KtGkXk1EbogWG/IqQVbyMuiwX6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5572
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140116
X-Proofpoint-GUID: oZzrCJXUBF87KRE5gh86ZFSIllY87oOY
X-Proofpoint-ORIG-GUID: oZzrCJXUBF87KRE5gh86ZFSIllY87oOY
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

