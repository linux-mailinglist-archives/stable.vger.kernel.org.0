Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9216B6A8F18
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 03:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjCCCQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 21:16:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjCCCQM (ORCPT
        <rfc822;Stable@vger.kernel.org>); Thu, 2 Mar 2023 21:16:12 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456FE3B85C;
        Thu,  2 Mar 2023 18:16:11 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 322K4DAc000635;
        Fri, 3 Mar 2023 02:15:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=XArLj6mJ+UexcDFGeiv8cmhfIMOMz6KSpXBtiTRam9U=;
 b=SIUCEW7FX785WZXiM4l3M9IPxZ9S2E0FnVdvvYP94OboDjlbbQZWdMTY/v6HcBmQWl0c
 Xly93WfZIO92YZKKVMh+jNYWtKDizVdxwA/xMwn/mjKT4DoCTXd9lIrzXshpDZ9OtXzD
 OKKtiYheT/7j8P+2VQOlim6XOr3eUQDNUyjlDtxRbWmLBIbSsLhoEghgPgAJFsKzvVJp
 vsU3wvFSvkmtf+7tejsi31W0qN918NFC89lekbhSU189ojksgFJZve1cePnvZPAR4hL0
 VVUI7CA5PokTK+0ZN1qDuL3T1zVILhT0m0N2QQvsNMkmZTqwSzWnNh1UrNhlC9xp7Drr kw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb72n63t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Mar 2023 02:15:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32314HIV000577;
        Fri, 3 Mar 2023 02:15:55 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8savy1k-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Mar 2023 02:15:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6+NSc0j7S7IXRdt/2gxHIl/dGj5EBbfQWVcu3THTxl1P67yUrQwQam0ArfFL/y9ldlePiAf07QssPiF5vHKJTpkWB0NBa+7Lx+1lKdHMrzCLm+npVreDBzsReV4Egj5NnNP2djAn+Un5dK0nXJ+n/GDd9KeU5GAybDVtseCrI/ejTbPvXX9pq5pcZkodfOJze/5WBmpNV0jgroe5J3cH39V0cIfS9Nbbw9pHbpK2eiJGwEGHYw1ahrFH71e54A/LmcZL9kQnIA2cKJ5zQzGHwsMnRtmM3cgOVv5olUAiVIh5pXmF0YGfO23tSmJyiEMIqX86F/gbZqUpjVy8Rk14A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XArLj6mJ+UexcDFGeiv8cmhfIMOMz6KSpXBtiTRam9U=;
 b=BYTMWL5N2ffQKcQgIuWc/Xih3UnkIfCL6ONk6y4aCnhPOnufmpfhToSviIXXC++hgIxgVAHrLsd2aG8QTE5Tz6NvTbOD6H36ckv7f1zg2fgSvrseFIJdCHCksTXDm4krEH5bOX/cWWZLkdHz9D6SWAbRLMLQfLsmc+HCEiaxdZvRBdFRqKrC+W0xfWSDHC2zbvFBQh5KKU/GrvjvFt1g8YplUfoZjUmn49eWQPyjESgzboFIogdhqs+x08s1AxR165p9AnARDjFYbcZqbtVg4x40St9KLqb7LlbeGiLW3PmOxBNWHT6JWH4DgBUflIUnUpWjdO6aC5Z9Cmdflp4X7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XArLj6mJ+UexcDFGeiv8cmhfIMOMz6KSpXBtiTRam9U=;
 b=k1rDw8o0aWg1LEkwppbU5OdbK0zx4vFsnxbdJvTuth2+2D72N5jKPdQ7m2YBN+J2SBalzDfWgCFeHUQ2au+UUgk1cDK2BST0bBL4NFJWQffU4TzHKVK0W3+d2TMVgg+62LmDZ17Fnpc7pgYr78RM+QnLkZvSQNhM4W+OcsmOfeA=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by CO1PR10MB4770.namprd10.prod.outlook.com (2603:10b6:303:96::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Fri, 3 Mar
 2023 02:15:54 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319%7]) with mapi id 15.20.6156.017; Fri, 3 Mar 2023
 02:15:54 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Snild Dolkow <snild@sony.com>
Cc:     "Liam R. Howlett" <Liam.Howlett@oracle.com>, Stable@vger.kernel.org
Subject: [PATCH 2/2] test_maple_tree: Add more testing for mas_empty_area()
Date:   Thu,  2 Mar 2023 21:15:40 -0500
Message-Id: <20230303021540.1056603-2-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303021540.1056603-1-Liam.Howlett@oracle.com>
References: <20230303021540.1056603-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0102.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::21) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|CO1PR10MB4770:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e789990-27db-47c8-773b-08db1b8d37da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CM+/8Bqgkm8DAUmfpLTbKO5IgIPuQdMBPY9XbUa5K6Hzh9lJcibOqFdnHdMnXI34pzmYyU1ZUDtvZIfFytw4juY5kdDnWGAxLV115IZPVokN7OKS94QndCbHNtzslyFZd5iAJO2bs9UxUzsiPjjGqFcsOR25AQlCnBLE1X3vd9FwgvaR7t2hFtKnrZ8+vMmUOuunPdFym+3VQhNpxB9GAMYVJP1/jWHAKAnD9vFT7C36o9reOA+A2UPARzq7B9Nzk+rBf5FxWSEA/Q22AnrFaVuOgMrLT78zz3+UT44EXY+Ryz6Zhx9NmBTvXma4I6dFi1DWvYf6UugnLyHBBxedNTdwihjSUQJ+VSDmH+Gq1VwkSPsxZ5g4sKtmvNV4yITsvUjpyZLH8WAVXINvfnO8kO8ljqLshlHZ1PcyllewODvHvkYYdfBVHFBrcYin2SHhPS5zx2rz20nywzJCTxhkcrppiY16Urbe7TbDtHLhx/khrLTJGiP/SsVWQsIftZN5Lc8x1nMRlWx9i57iW1YuzDSBnw+XsbGhDpu9SjYnzF5uCz0a6G7ZS9lAfp0tOr3jilPox+FKBR2l9o/+8M8zs2DLsYxIVnzm8WZqMe/VgZGlCunUKu9glRpZHiel/VFn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199018)(36756003)(6666004)(6506007)(966005)(6512007)(2616005)(1076003)(6486002)(26005)(41300700001)(316002)(110136005)(4326008)(66556008)(186003)(8676002)(2906002)(66476007)(478600001)(8936002)(5660300002)(86362001)(38100700002)(66946007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R3AK+ul/yQd6bTK3a2fsgyyIoT24L80OY1cwHt0TliMxp5QarFe4e6X0tLOo?=
 =?us-ascii?Q?XZCx01/DFem2dhne5eRPeHhsFp/CcOVfzr5SwlRnsjUYrZ5UZE4vQ24OP9rI?=
 =?us-ascii?Q?YRLPQbqyhr1FfrOj1xKV0iYI8yYdqMBgHEX559qXPStNsrfyLhZbMYDP9+Bu?=
 =?us-ascii?Q?RdhFQPdYnyxAfxhe7kTEAq1nWC5+2Gw2aBUUwrf26Siv9JTiC4wk+YyDQ3c4?=
 =?us-ascii?Q?/fa5Z3C+Svgj6j9Zk6c5ZHSn+xTDdUeu+kY5qudIGsKs6r+36auGSD4cT8+h?=
 =?us-ascii?Q?AJ3R1LPR5lDmO/Ut0fJzfS01uba4HtIyn3XvuyIVFw6/dOHdEB21/aaBYvcu?=
 =?us-ascii?Q?EnQDxMNgZO6vcfs4DqYniDm0tVCAY4tncQL48vCZCG02dDlWnuW6TMW/xB1N?=
 =?us-ascii?Q?w3ogaWVKeQYsCPq6aH6eyUgTygm09QiZjqbz6kKABqzl8xx27MvqJnGqtbqa?=
 =?us-ascii?Q?BelaLmQp3vzg9zKkOB6m7P85u8zoIoJkD/2extjtwYaFix5lwAeYiPzf1/dc?=
 =?us-ascii?Q?K+AuHhDHBVBCR1sjMX/5XyT50+AQujI3ge+fgwPto/cU4pVXPrQCRwYZVwBU?=
 =?us-ascii?Q?t8xAfu94wzBVQ7w05PrpUxQIERZy2cpYXjUkvAY+mF8xyf3NCxwvQwYNL4KK?=
 =?us-ascii?Q?8IJTIuF0ZvcnrlzG5PKm0eoB4VEiBNlWl3HtBq8idiq5zPLOSsNev0OEuXsb?=
 =?us-ascii?Q?/rL3/rEIB4LucXF3OjY3E0s1zub9YPbfUWEjA2WsaINNNgtHfgglDex0JQjB?=
 =?us-ascii?Q?ZGdM5jKfjmlwXdjR6w3uGFxiWaI32BgJgEiH1WskFzFhl74OzZWakI4Kf1K0?=
 =?us-ascii?Q?1CxixBX2lYVnlW3hl8pMoWJten1qGGLesR9rx4oDdnxQCePotQA3+U9hihxl?=
 =?us-ascii?Q?/VlyzbdxvdsMnvorWyWJJnfw1z39LZj6TlumEC8/7ZE2i/9jDaB0Y1mIkltN?=
 =?us-ascii?Q?fVGVn1msMSp2lqbJavgDEOSrI3GYKV+DS9cpCgZ+ay3mjPcldKp0gHmyT5/0?=
 =?us-ascii?Q?jbYXP67oV82LIXwRxEwFNXmUvGaPVe/ct+dojHkkuT+TeJRfZDb/khRHx3iF?=
 =?us-ascii?Q?N61S+orcZ02FkrtNlxWPzYjL2iWE62qmkeKC70o0L6rnKioPN0mKJciFGIgq?=
 =?us-ascii?Q?30xAZUDUF+WbYlP7lJrAOYBG/R7Wt2mETEgkhNQaAwWW0CR93ErMQfhI2L3a?=
 =?us-ascii?Q?vY6IWQh4R0GjGbdNlZ+Fixo1KXNrJlCCL1xNYxR4tOmSL/MaJdc8g7WbD8WH?=
 =?us-ascii?Q?q7qbXSpGN9OuY2S66ahhFfMmxJGQQibta0fHAVV0IzvR9/nUD5jUWTYUBJG7?=
 =?us-ascii?Q?Yq7iAlO8aoH8uPUagRAb2cFNqtzHLRZoWajmjwyeuse9aLzWOUkg6LYUCy4o?=
 =?us-ascii?Q?GO+AwkVEDEY6Y6HHhYauqKI2I5XUcG84g1m/M7yri4tbk3qF5QA1jOy2dlAv?=
 =?us-ascii?Q?ND2qE3xYxAFM7YbojgBPLur5AaXhRR2S3qGsHhjvpxVqsZTDQHaRhdQ9eFoq?=
 =?us-ascii?Q?morydBO5R7Wzsm+hEec76BBkm3+8HekC/8+nS+CYJfp1rL65FLK0jKnBf2P6?=
 =?us-ascii?Q?bRdYqvsKkQF8LPuZrgiLMoXnFLSb9raJt9JjM1l2w8/VxFcnz19xrZU6fD19?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: f6+hOowneqfxFk0yt7Ax0Gk4QlrwoWsMl81eV7q2wcI/jcmk8DeJKVSergKdgCAJZhJkTuD89dy8NIS95mQ8pnTJ/lYzS4V77oJxtKrwGqygFJg4RRGHGUNkybNer2sJilIkdmQR9z/uTa6Xh0Ee4s4T1yRBbRPApXvheJ3p4E8STi26S0gAIX0Bpy1eZtwpLhOMQQcufhB8l4Xq8INOyE+p+Kc4gUeY7P5v1+y3vjN+Yb9hlKrugf6f0yP5fF4h8CSntoRHpFx730xXrp8rbtsYyksovj7CXMW+f1D6q7L8QDeZ0GD9n4c+Blp4bEEjMTFcDTmPijRBUykSIr6Ge2hPRBU0CcrEcYx9a9JZEFm+EzNiXVT0E03RBC/dzDbTknpKDUOvpnoFP34PB+pheDDOMrApmkTTds04KtLiGfNd3QnJ6o/rP0trb3rVC6MaTzSwsuOm3ERYp5mkTjI9L5ygmE1Ih+LFFVuvUs361NeFxVtS9VQLtNVqFpX9EMv9Lihv+YXqNZAa99JtsbJfRB+CtYOAAJNkG3KCFncu7CWA9Aro4qT9NHHT42clhalwOv4OYam5ZzgV9lsOLrAJg57SOeDSrJIURr+HIsu06RDD/h4jORmUAaBmVhLW0x2DyGP3uSZmoB13Tfv6bF4aJ/5qgn/7BwwPV1EsAaS92CkjxuwmNe2jm07FZtXKAzWoieHDsW5mXM1Mg4WpXkYjIeekqCjHTwHauLG5ZEa9i14oPT8ztoFZXsOVHhHh0T+PVHJTqtNrTJBxyFN5Q+f9EdZNHVQWkl8Y8ybw+0Cunj2QBIJDXy6SJCTEl4xS/Fgt5QGkDETgYfk4XogVQwJq8u0zCILMp3l7/CNKxSS+ccSikhyrf6ph8y1sBvR4bmcFGoVdMEjgbT4wtVdYb1ZYUKbTSYbewqj4RXjk58PSXw8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e789990-27db-47c8-773b-08db1b8d37da
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2023 02:15:54.5397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KTu/KX5njyyewCbTtfR0rbH6bqGxU3L8M8zCtIDMMprDe7600KzOdbCU6PeFnogOUatTWNvMDXEMsUygzOWVWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-03_01,2023-03-02_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303030017
X-Proofpoint-ORIG-GUID: M2nNT_23kXJX-GSQGIiLO5WxsCjGHYDh
X-Proofpoint-GUID: M2nNT_23kXJX-GSQGIiLO5WxsCjGHYDh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Test robust filling of an entire area of the tree, then test one beyond.
This is to test the walking back up the tree at the end of nodes and
error condition.

Test inspired by the reproducer code provided by Snild Dolkow.

Cc: Snild Dolkow <snild@sony.com>
Link: https://lore.kernel.org/linux-mm/cb8dc31a-fef2-1d09-f133-e9f7b9f9e77a@sony.com/
Cc: <Stable@vger.kernel.org>
Fixes: e15e06a83923 ("lib/test_maple_tree: add testing for maple tree")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/test_maple_tree.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
index 3d19b1f78d71..fa86874763f0 100644
--- a/lib/test_maple_tree.c
+++ b/lib/test_maple_tree.c
@@ -2670,6 +2670,36 @@ static noinline void check_empty_area_window(struct maple_tree *mt)
 	rcu_read_unlock();
 }
 
+static noinline void check_empty_area_fill(struct maple_tree *mt)
+{
+	int loop, shift;
+	unsigned long max = 0x25D78000;
+	unsigned long size;
+	MA_STATE(mas, mt, 0, 0);
+
+	mt_set_non_kernel(99999);
+	for (shift = 12; shift <= 16; shift++) {
+		loop = 5000;
+		size = 1 << shift;
+		while (loop--) {
+			mas_lock(&mas);
+			MT_BUG_ON(mt, mas_empty_area(&mas, 0, max, size) != 0);
+			MT_BUG_ON(mt, mas.last != mas.index + size - 1);
+			mas_store_gfp(&mas, &check_empty_area_fill, GFP_KERNEL);
+			mas_unlock(&mas);
+			mas_reset(&mas);
+		}
+	}
+
+	/* No space left. */
+	size = 0x1000;
+	rcu_read_lock();
+	MT_BUG_ON(mt, mas_empty_area(&mas, 0, max, size) != -EBUSY);
+	rcu_read_unlock();
+
+	mt_set_non_kernel(0);
+}
+
 static DEFINE_MTREE(tree);
 static int maple_tree_seed(void)
 {
@@ -2926,6 +2956,11 @@ static int maple_tree_seed(void)
 	check_empty_area_window(&tree);
 	mtree_destroy(&tree);
 
+	mt_init_flags(&tree, MT_FLAGS_ALLOC_RANGE);
+	check_empty_area_fill(&tree);
+	mtree_destroy(&tree);
+
+
 #if defined(BENCH)
 skip:
 #endif
-- 
2.39.2

