Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F9C501E62
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347106AbiDNWc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:32:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347202AbiDNWcy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:32:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEF1C4E33;
        Thu, 14 Apr 2022 15:30:28 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EK44qo029741;
        Thu, 14 Apr 2022 22:30:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=OJHiOrVzOQHcjM9MuaDqOrx6aWEc8l2qZYk1hIKwVoo=;
 b=AVVagtZxgYpvCZay2tGGWltX0SUr0YNvzWQvpKamM2iZF5i5mlkAMHqrz/PL68U2pyWN
 Ry2Ckjiv7rT77Jt522hhGz0aiipiBQD1hh/3cuiRD+phSgQ/rHvP2A5W+mWiqqGioLUa
 iHOTg2M02N8vmvGm7ywk3JlohIp18Y7mHeG3IMa4ZGLRmPlmjQ/ZFKnkZTLu1rFlveh6
 9eGlP8Wu0VZB2uj9q7XZikLdhbP53Ap947tDFiX2Ehai9g0pZLl7+OucbXm4wPoJ3Qs+
 a5XvYE17nYpB1f8D7MK5IluIwt6iI9BiHEjk6rPef84XIKiprdKQbmAx/u8AZtBq8m7X 6A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jddp2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:23 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMGUvm009301;
        Thu, 14 Apr 2022 22:30:22 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fck15da3s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJzUB/MN08NWsVb0qjXChQF0jxfq0H30tz/bBS1n9qcjrgj3JDcg6D8H0iVd9WWuGig9OUALpl8QVdCV0e2YtmbsIEhJVWgAe8NrdQbefUIldraH/AUTGBkUbZe3gRxdsHMk8FwCtiE+w4IsU7QV0MkpaXzMh/wY2zwIXZX9GAbPJQUouhJ1PckYydvlDgql8YsjvFTMkAKIFMpH04ltNoonLrW65Zipz8591EQQao/PmWX4i2vZyylnT2ULHbRc3E+wcue9hlAudcJRCJ6qb0mjrmPaqzBmg5lnDcU+qtmvbccIMnprdBVxWaPVU76h11YsoQKHUiKkb0h6OrvkSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OJHiOrVzOQHcjM9MuaDqOrx6aWEc8l2qZYk1hIKwVoo=;
 b=nSXiiDYJ24heFgLekEBpPdmZQCvPfzLIqflOEWROQo43hwGsqZq7TDAVg6XFIVpf2S140G8QwadySCCJI0F4+gpmIs55D6CPej4SJ3hpupld+ioBDcUK3iAI5FVLi/7C5YZQanTmon0oLzkrkOwQD7dDMx43KHq1ywxaL/8gfWpU4F4nrzUoAF+FhuY6+udYQ6TG1XYa6IyTPES7yJTJKAwviB2cr7MVkSIlexyaiMYF+kHQ0WjsUyVTbTXxYhVdPUZ31TcLkhRDkztf4cHY9g5PnxZd64cLx7gz+dhLGbAWb9ehoIx3fBSLQzjc649hdgaIHvLz2ewyZumq7V7+JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OJHiOrVzOQHcjM9MuaDqOrx6aWEc8l2qZYk1hIKwVoo=;
 b=O3aqXKBJSqEcZBA4TsTGOkp2bkh6d1GsE+krTwKSQp2JyPJvPbthZQynQMeY+D/6fc6ABqd512ez1luttTD7xAGtfKQk4Ja1FJUlWdsI666t9WOPC2ogGdYim2fJ7guRxfKVniSPxeJdDoREZLjAuY4ms5PIKlh20OppdNmg6QQ=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by CO6PR10MB5572.namprd10.prod.outlook.com (2603:10b6:303:147::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 22:30:21 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:30:20 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J . Wong" <djwong@kernel.org>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 11/18 stable-5.15.y] iomap: Support partial direct I/O on user copy failures
Date:   Fri, 15 Apr 2022 06:28:49 +0800
Message-Id: <a85564f9b06b5bae198a27c7f60cd02b39c2ce79.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:4:196::17) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78e04562-8438-4a44-d9ca-08da1e665c1c
X-MS-TrafficTypeDiagnostic: CO6PR10MB5572:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5572CB7586C4C83C064A03DCE5EF9@CO6PR10MB5572.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a71mW2mSl4wuUa3gK/uayXJDQkVFBUtrSmugZ75dFghAyuBGkFhVmnA4E6DxYjBwxTqy7PYrUBL9ppHD+ABBQVrvbqKHquPQlOs8F5IWwc+/LAEQqZNNp8udHVYG0DZxHlkfopyTk31tfaD7Bxr6uiU9dPS1gOZsmUAKQjufvtAZUwD+ygR1/gzgo+Fq7q66Iih6kmgxfy+RSRkmzLjhkdDrwrORQUt0LjKkS3rm8N9+Mj/St+IVuO+1ZB7UdXCRTClueb29KI46vzbI02PFec+iGC4FZ30QvS+MsDj3u8cfm9YlnFAUIjEc6YHWVDUGTVyJB+mzQRDvSqxnXEiJ61IF4IYxwUqyJc582kFuQHkWwd6C5yCXMDn45U7c/zEtFOy6y9niAkDAyiAKFrLcMkH62/1bGqksT9hRIGLLZa+3uXgdc8m8IbXkmNSO/LzBTWjW27Dyvs9hBIEMjybmHzJOpS3lg1LyC0UTtlJ1Y0XXgY17vb1kCpr368I4BCWtYkpvY2M6Fi7B2GWi6HwYUHRsEhG8/UZY1vtXV8SQ6dmV3LMoDmaiGcUkL0Qlozf4PRYCHf2ALvRTLIDrng1oXmG9YHa6yrjQfpCoLsTvUMrF3HdQz8g+78yyPEUv1yYVfoftoa9ddRh/XasMdfY6wQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6666004)(38100700002)(86362001)(6512007)(6506007)(2906002)(4326008)(36756003)(66556008)(66476007)(66946007)(508600001)(8676002)(6486002)(44832011)(83380400001)(107886003)(8936002)(6916009)(5660300002)(316002)(2616005)(54906003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ustVVGslml6YVDs5x84d8v5Bp6EOxh22JyE5rbsJZkEJ1kh96cFQQFkEoKev?=
 =?us-ascii?Q?NcM8I5u8bDkF0NUv87bpsWt7u0TyfyRYj9/plTinQrT4ecO0DAA3YeXfX4o1?=
 =?us-ascii?Q?o3nZZzSJMv77CYEEGzh+DTw8izLW6DWHVBf2pW/2jM+0qgOFa3B2ncCtMTey?=
 =?us-ascii?Q?mSsFWh1DA/5GoW4zdnnFkbGgHcZm7PeaJHPqoydC7SwxoOQEqAIWFwL3Uxzy?=
 =?us-ascii?Q?bHo3FoacqAyIM/1h1i9hfmBvIlJ5hYVfIGgitvybu7V8cTCZ30jKHnhbt13W?=
 =?us-ascii?Q?7cFIHaxEJDUNG0P8JgCMft1XNGArQE181dn2tYJvrJ4s5xRM37SquW4Dfdec?=
 =?us-ascii?Q?MW4RTX+UKh9YHZU4V8UzyyZ0QuNyqLitr6vxBNLQWqqr1py+iOvkboXKXwce?=
 =?us-ascii?Q?xAA11Xyv0fnq1On0NnyaVel3Yq2DmXnw94H+Z5wrpvDwFjZprXWBuQjVIGfx?=
 =?us-ascii?Q?cP0O1DNrBUVQVSkQEjT3lYTwknaY+3LAP8yeO/+XS8QLdH51pOTl9W55eYQH?=
 =?us-ascii?Q?xrr10hCOTvvXTj9A7cDrEsyZK1h4qvE9c76waB6hIKmTp3kDTX+b1DpqyqoO?=
 =?us-ascii?Q?whce8u4GnSGbbG/mK/4eLvEl8AK3Oi/CkUcja0jPbJYizG45tx/SDjmjt2kM?=
 =?us-ascii?Q?tJM9zSc9nMgkZCh4PEDIR7UwL01qBfg/ONQVEw0sMchYiPMh5jhUPJac4CVK?=
 =?us-ascii?Q?QaVSwGMt14qsU8ek3K+5zqHvsDM/KnZWRlJ43E0QtSEkxT3jUjoVU+73uM+/?=
 =?us-ascii?Q?oByaf/V8Uc5k0YUpMtI0U/OoBnkQeMC/91lVk08LvGIlheTIke6Pq4EkjgHg?=
 =?us-ascii?Q?0S03aPsQJP8FpcIsCq8wjbf0dvVYYOj73/5V+Plg6Sv/CdZpox5+FU5isFvy?=
 =?us-ascii?Q?XGquSESt7q/8LVYArn69RIobrWbqzxxiLej0hJpdg2YEhumAE0OXNktmPXA3?=
 =?us-ascii?Q?TC5v/tLHWSsoUbO9miNbNXnAopI9lhkPf1jhouNFOO6kTSsotv7PaTQP5om7?=
 =?us-ascii?Q?QLVvqPgZHM1Yr57o5xeTs8+IZa/f7aQ+rcpBjWWOBJLlgcT/P6FeX/qhZQFT?=
 =?us-ascii?Q?9lCcoDjQdE1cQ5FvUg4+2BIBYTO+6DglC0EcK5VZigDkrpbyFe6oebV8PR9m?=
 =?us-ascii?Q?bmFE4+kdLFwo7IGET7wJ+UWkTe2VZXIxhrpZV7u4/ABxNbY/H58ntaFHterj?=
 =?us-ascii?Q?B4aiYjASV1xg8rhW8F3KbRzNFNCgry24TouSiXvZEuLsfr5K6jtp/LWMy21V?=
 =?us-ascii?Q?3Q5YueMwIxdyowylnHAopgfR5i9zmMzEkiqxq/SzeBPSNFGtRDJR18kd3G6Q?=
 =?us-ascii?Q?Ii7zybB18BPSvp9OIdwGkjGPfVE+jeIGnU7liu6HXwJLCYecTmeZI5qrOU91?=
 =?us-ascii?Q?/gZGz4yCrE5BZUSh2aqG36E6qCEnKbH42mqtKGdXn4AnZefCoCA+cXsL+fyu?=
 =?us-ascii?Q?t3UqOT1PbVVhfK5D0zxd6FbBp31znX8NGqtwHiKeiCGzOeajZ3knowc6U75Q?=
 =?us-ascii?Q?+cGffyGcbViKf9Kpxs5IpwlNA6kWLNDG5OeZDlOwkJMHOrvGDi9C3aDjRlQq?=
 =?us-ascii?Q?NdpU+ZSQp1U8eXNKdOHTB1Mz3wqC+mrKoBquTpvJXFPvPTJRQGxzlt42dTmU?=
 =?us-ascii?Q?oyWZ8BzaHuSsLWSBDNqE4xV2Qy1KEp6WolklbDUVl3QAlgnQVl94Ih1lX2P8?=
 =?us-ascii?Q?UjXCAuvnQcLeWHp5SmRD28pMXacPtdaq7XNi17hUckCAmCWcXyevA991Jgu2?=
 =?us-ascii?Q?DvoY/1rASTipu7+LWNDQXPFOTALaeNX37RivoTGNobep8blAbDfn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e04562-8438-4a44-d9ca-08da1e665c1c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:30:20.8478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3TZscD96Vsvo4R8OLiWoAYHODYhsthS63pzw3h/KcKZJyVety5WDv3T7fDedoC/K1B3xLnN6oQJhnVN0BS/dOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5572
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140116
X-Proofpoint-ORIG-GUID: XxKSxNkpgKfWXNFtoeC3mRvPGiPKm00o
X-Proofpoint-GUID: XxKSxNkpgKfWXNFtoeC3mRvPGiPKm00o
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

commit 97308f8b0d867e9ef59528cd97f0db55ffdf5651 upstream

In iomap_dio_rw, when iomap_apply returns an -EFAULT error and the
IOMAP_DIO_PARTIAL flag is set, complete the request synchronously and
return a partial result.  This allows the caller to deal with the page
fault and retry the remainder of the request.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/iomap/direct-io.c  | 6 ++++++
 include/linux/iomap.h | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index a2a368e824c0..a434fb7887b2 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -581,6 +581,12 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	if (iov_iter_rw(iter) == READ && iomi.pos >= dio->i_size)
 		iov_iter_revert(iter, iomi.pos - dio->i_size);
 
+	if (ret == -EFAULT && dio->size && (dio_flags & IOMAP_DIO_PARTIAL)) {
+		if (!(iocb->ki_flags & IOCB_NOWAIT))
+			wait_for_completion = true;
+		ret = 0;
+	}
+
 	/* magic error code to fall back to buffered I/O */
 	if (ret == -ENOTBLK) {
 		wait_for_completion = true;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 24f8489583ca..2a213b0d1e1f 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -330,6 +330,13 @@ struct iomap_dio_ops {
   */
 #define IOMAP_DIO_OVERWRITE_ONLY	(1 << 1)
 
+/*
+ * When a page fault occurs, return a partial synchronous result and allow
+ * the caller to retry the rest of the operation after dealing with the page
+ * fault.
+ */
+#define IOMAP_DIO_PARTIAL		(1 << 2)
+
 ssize_t iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		const struct iomap_ops *ops, const struct iomap_dio_ops *dops,
 		unsigned int dio_flags);
-- 
2.33.1

