Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C11A6DEA81
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjDLE3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjDLE31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:29:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47DF44B1;
        Tue, 11 Apr 2023 21:29:26 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLXO8B017666;
        Wed, 12 Apr 2023 04:29:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=//a6vgLhGgBOiJz7AHhTMB33EhMuMzh/qf7K7ZWuL84=;
 b=RQYEjBoFc09DKl2qNKxWoMV/+lltoyFYDtBsUVnOlWrz/KUKysAw5ie2oRpYvCCBz+AO
 38eRPn2XUWyrWTRg9CYLY/JVp66X2S3eIDB/gPjLpFO9EwPwegkhh7HwDqJOjNJMinSl
 sdiheuc59AM6wX2BB6bFf8G4ehUYiEroQ9RkAO8vrlaqyTaOK9+cVX2IW/WTWGRYhK6E
 Wj3u/jrdbsMEaT5GAp+If2SgZgeLcDDky3rAnQzkCbIXgoWJtGFAx3ICDH04WXJn3zwb
 TjKCiaiqG5toCVup4fFiHMYzEci2y04+fxB5g898f1ug6Zu+Q6pVhbJ7hBph/eMJ8IXc LA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bvy3ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:29:22 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2KAIX009863;
        Wed, 12 Apr 2023 04:29:08 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw880dxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:29:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QdDOdXZtCrMi5BkiA5yngj+A/5kvU1TbqcPzIlhwyqSIpgEpZ/t+OTguKVmf56l33enc7gTRq+QMC4f8r6uL2UAtOAhW+rOx+xOXWaK7zu4Fuz4BwgNIPmNqO0w1fTdxrRLow7grN6usdanaklT2eBD1lpYqcpYmWM3nTQmrLSzdmXoCxOUsKompX/XVTRJuCQH1iETS31GbX7sVK2Uvh5/xFHpDVacoNWkoL4Rp+gVKsKY9w34huNmHfkhC1IultjrPb2indmbRVuGZsmnz0IydWCyMxpvnJExjacJCP7YFjgs9aWrKpgU1FUkO+uO8kNXULivjE6SyafZhTf9Sbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//a6vgLhGgBOiJz7AHhTMB33EhMuMzh/qf7K7ZWuL84=;
 b=P9f+D+pVlYDp6hPdq9XZC+MCRZ7waDlibjRN0m9DwNbJ6kx1VjcVOIDcwDDXCBwPxBjFWzcMKevXyNZLsFHuyp0aVVea/WfxbEQbVQcFW18ca6Y6IS+cBndIa2Is5pi+HOrEt6wcxzRuCz6K2mFcwywZU/DlC0hoT+DTFAGHxpcBoVN4HigD6XBeNQZuW/s4eAmcj7K9g6UUhniwlOQrjiS5ezCYM5TwP8hXvfDJqsU0Ocsml7TNUG9xkZ5922kZk6F73SaRpECXBG1uHWtPuqvYbda/oF5bT4JwZOUMq85ejmLD06GcsZ7BGC+wkZJWG6LfezlCQghWvGeAT2psMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//a6vgLhGgBOiJz7AHhTMB33EhMuMzh/qf7K7ZWuL84=;
 b=eHPWrLXGZadA3AEebaEuOc/KgZz6OBo1ue0e1y3o5lq7ZCsPDhnQN1PfsA6312xu2lDTlx1bBkmcBt1psQDeM6Eiak6eXmL2ZU6TFsRn/f4WhA+JAT5Cg6pZO8bY1CMaiiVigce2sqHqfSZF1w9E3oPj8bxnjjyfMPJkZtd1JxU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB7363.namprd10.prod.outlook.com (2603:10b6:8:fd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 04:29:04 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:29:04 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 14/17] xfs: shut down the filesystem if we screw up quota reservation
Date:   Wed, 12 Apr 2023 09:56:21 +0530
Message-Id: <20230412042624.600511-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0090.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b3::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB7363:EE_
X-MS-Office365-Filtering-Correlation-Id: a79564ef-1da5-4771-96d9-08db3b0e72c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7D6JsFn8nPdnMeYxzLYlfiNe93ds642ti6Ix0T/1we7gCaWwWogYmUaIO60/Ahk8ZnBLXNNkofPlJ+wHQsvu8SH3U9vfkNTpLoTiEVI5UPsVKqPHVeTLwQvjKdwOPpjjwQj8FrnSABVilQt4vYXQcv3ndVrDTY++3i6QoLez71cU/XocXZjcYe2VIdk7kwCw3q17ZjLBJ2VeKmEi2tEqmZTFliErZ5L/0Pjn2EBjAwuk45PqDNSLCmvTLHJCgUt3Sct0IztOr9m65Dz4Npu9YfxoabQfRUREzGapCkF3mYgWIA3qAVbquGGjPx3bVUkTmUcHXeMmjquPgC7zg7I8uoFyi47q3lYrGLiR3A3dzU+CKXPlD6ZuWpa/XEH38sBnxljUUbjNgNTIN7CvUkwR9UBWLQrtys5T1E9oi00h2hzjWAkFzOfwIwZz69DuH+ms2A1CqXVwOAlvkWmaa72O+gofka5AQ7/hc1ZUJ9RX3S6xa6C5cvMwv/mkbZ6yW+OKk3jfFhJsNMaVpt+xOY1hQjgcDrBDT5HsOmVbLe+y0+ayUXecQu1SbEkByAf83pqg4Dg0owSsXfoTFGchI/58CrP9iniPEoweVehxi+Tu0mg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(396003)(376002)(346002)(451199021)(6486002)(4326008)(41300700001)(6916009)(8676002)(66946007)(66476007)(66556008)(478600001)(316002)(86362001)(36756003)(2616005)(6512007)(26005)(1076003)(6506007)(6666004)(83380400001)(8936002)(2906002)(15650500001)(5660300002)(38100700002)(186003)(15083001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?11FDzoqWgTSps8XWC7KvWtExqZOblH1sQG9lyNhGFzSzl84VCt1QSNKTDHR0?=
 =?us-ascii?Q?T0R0aYMUlMjzUhegk7DYye5BeHx82N05yAdqwrKRZ4QsmP4dNTtdu/hWFhEG?=
 =?us-ascii?Q?6xoWDGf8yCGPepZ6hmi77/dOh50VOEr/hlGbnbJ0ad1sITGkiEjW3AFAbkYq?=
 =?us-ascii?Q?LwfWlcciLBVIrth/bclpp/SKfxi5fKUGczC8nXRUuZHCfXHCy0ELvLUychSJ?=
 =?us-ascii?Q?YyJwlXXEdETV9eN6Zypqc89tFoD73G6bcdgnyd7rwkcpkI39OwF3+Va/wMTs?=
 =?us-ascii?Q?X0Nn61ZBXOkOLwixCiDxN0MIn4kx4Gybkm3DrHJsXSvBichWGGugk9Dv2o+v?=
 =?us-ascii?Q?tgFc3ettLXFOVt0imG8cjqnFG8wReRJ9vLiS+IwlFBqrPKxQ5gcVxhb6xztm?=
 =?us-ascii?Q?sbt8K0wKxIuRkW7gcx7lW4DhYb4OnqB5XiaRE+LpX/dGodZ1Vu64+6GTlDlt?=
 =?us-ascii?Q?CWvVWL8/R+CMhsHm6y1Jjhyn6Vxt1bhWfVJCB92AN0wGVExIWt+98vvNTtpl?=
 =?us-ascii?Q?s1ETqiT25IAXuOjrjZqgqhJKBlS6trG2eLveqD8HZzGBmU6BPRNR21Qj9Pgl?=
 =?us-ascii?Q?TxetsQiXHO/HgnkkQKdQZikJDF9BAoNWAltR/qWXRRME4Tx8CggDZQURFWOy?=
 =?us-ascii?Q?IFY/o7zDOj9L5bCVGaGgdOXxms8qe4bmsb4EBXQ72GkuDD/5HqclX1t0MH1u?=
 =?us-ascii?Q?L4IAmQNeho6YQHign4vmdq2pp0oeTkMJPskXjnzg4cFzUHjfgQ/ogx+pbosW?=
 =?us-ascii?Q?hdZg9b6xA0PmVv1F+FQz0gfsHuD3ErZrRP7nrnUWfSDZHN1baE3/lt8kPZAV?=
 =?us-ascii?Q?NYKoE2QpERVYjkZtc9M2XA5Z+939wbHtG5Zyn4wrLfbAgL4GuxuPqoD6folo?=
 =?us-ascii?Q?MR8nhOnSb3aiLxVAjRPeraNvTNYjP/+kqlBU2Zqk7Y8gKgUKqDCj4civ+p24?=
 =?us-ascii?Q?SYuFYp5HsJ4KSsQcUdZJx4rWOW6qYbR8zCS7yFDMwiosFZ7NXXU8UR/whFts?=
 =?us-ascii?Q?etFvROqi+U23ToJ4u5VZtZylTSOA9NlZ4a+MxEcommB2ha51IuEmE0SrB+6X?=
 =?us-ascii?Q?2tv5AX02v+8R3ynENF59k7mYTtM5qMiHps8b5Boifksjd6SkMSNhllSLzjia?=
 =?us-ascii?Q?JnbdWp9CWkhM4LA+OaRGmEROYS9j25PqtvNM+IcAaaLRnAZs8D8jFXkCMfPp?=
 =?us-ascii?Q?wKLwnnN8Z/YqLEFDt5F39IOTAjI0idc5LGzg3/Aa6dqIN5fE8ecPjGD9koYB?=
 =?us-ascii?Q?unmMUMr937PLZnS1DuNFBAWZakmW9wN/N+mGL9f0hSdyKxvvfgHyWOVBjeKe?=
 =?us-ascii?Q?nTJIOwFeK8ij5Rcp3uKxkD1eiU8ZBTe2e4nfCsDxwJI7xAmA6AgE/kEE6eL+?=
 =?us-ascii?Q?RS6Otg8Ct6j1BI9OkWyGz7mvBDtJ7Xq2eFQLe74qfI/uMu53fb/p8WFWuuSA?=
 =?us-ascii?Q?W+OXRmeNisYcqml7qCgDXfu4OM60ak8zVV0ETApXHUft2VPmVXjMdBR9j/E/?=
 =?us-ascii?Q?G17YxfpHLLck5ig8V4UIGNcm4+8JIei2bOUDWcHz+XXtD3i4Qg9eFGpbLCN0?=
 =?us-ascii?Q?8fcV9XG43ovSEho5YCjZTPRSS9WL2UrGPj2+HKhXpnFGL0+hj6uNVTPGAWg4?=
 =?us-ascii?Q?Fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wPOaNAKlhyH+xpqYSV6/gZPjk4gAPv5G0UtUK6cutNKE1Rijb7rjenuTBMjbtER+F4qhXm66LsGC4lPoJS4zu0m/C456OzpkPx8KvxHoKzHMLHoAPESqpVy5wyg1LkB70+HQlmtvpSW//dBD+ezQb2HiXmmWRfpnnd2cZ5Z10u+VlssVOYjUtpun/ZTxn/EEjQ7Xby2p17J3QOUl4MLEvCEr++rSz9ffCdJ42XA4o6ZNRMPin5b54UR0TLh4PZYXW/x1Fqp5BhkuuWoxRGNbyY+wispJXwW3qVx5OSIN2toc6zKNAleAXVvmKyWSsHwum0Hd42+KjlM0DEj5nCqKQUFts6YuQMavQgQn/Hbemluw2ZvJ1zeDWavjapLp/C6Z/sd9Cmb63EHOdh+H0zuVYLI+6yCUcs0CBbAXg4ZLpjMQ8/Dd1JbL+GrJhzXxOczRrUSJKT+M00ldjtRPsXKYsrW/sn6acrMotDV/KdUm7UVUyuvikbPW2aEx3d+vbZW82Kzy7GE70WKxjjukOhsxzaYiJ170y8mAZZrYf3DAtAMW/kd4dSLVS60o6ZeGsek2kOkSMW2F3pnE36l0Wyfn4drq3hTMUSX0hLVQoA/tMhxV1MAya/9TPJif2e2oSaaBEQIVa+xXTbCvAoqvue3D8JWCSIk36BmUEiOoeqDyeXXuQw8m0ltFzhlSRVyqGwIbJhlsNGIpy7VKglLXgNPiZ2kxyVZhWHoip3eO2iDBOGus5NMsehsp2RfNUIHn9WCvnOoszJpw2BN7vBZv8G6qIFcCt3w+VCVs+Dfs+9+RvJ8xXKV/nhGGuZ3Bf+qPXyM79WlbTfcMnWyFPijPB/nLgUHazbCnzvCDg3cDK0BnhS4UX69ilROl1OFY6aiQY3M3
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a79564ef-1da5-4771-96d9-08db3b0e72c8
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:29:04.6504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GK5u+bbDnYF80GGPrkLtfwqBf/jDYxTzM+Xh4Vc2bSenBdSu3VStNUmhGSLucL0EzVDyqE7z0iXwo0EIbjokVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7363
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120038
X-Proofpoint-GUID: JmFax3QoQc4TW3QSFS-elpjdG1dRn498
X-Proofpoint-ORIG-GUID: JmFax3QoQc4TW3QSFS-elpjdG1dRn498
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

commit 2a4bdfa8558ca2904dc17b83497dc82aa7fc05e9 upstream.

If we ever screw up the quota reservations enough to trip the
assertions, something's wrong with the quota code.  Shut down the
filesystem when this happens, because this is corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trans_dquot.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index c1238a2dbd6a..4e43d415161d 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -15,6 +15,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_quota.h"
 #include "xfs_qm.h"
+#include "xfs_error.h"
 
 STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
 
@@ -700,9 +701,14 @@ xfs_trans_dqresv(
 					    XFS_TRANS_DQ_RES_INOS,
 					    ninos);
 	}
-	ASSERT(dqp->q_res_bcount >= be64_to_cpu(dqp->q_core.d_bcount));
-	ASSERT(dqp->q_res_rtbcount >= be64_to_cpu(dqp->q_core.d_rtbcount));
-	ASSERT(dqp->q_res_icount >= be64_to_cpu(dqp->q_core.d_icount));
+
+	if (XFS_IS_CORRUPT(mp,
+		dqp->q_res_bcount < be64_to_cpu(dqp->q_core.d_bcount)) ||
+	    XFS_IS_CORRUPT(mp,
+		dqp->q_res_rtbcount < be64_to_cpu(dqp->q_core.d_rtbcount)) ||
+	    XFS_IS_CORRUPT(mp,
+		dqp->q_res_icount < be64_to_cpu(dqp->q_core.d_icount)))
+		goto error_corrupt;
 
 	xfs_dqunlock(dqp);
 	return 0;
@@ -712,6 +718,10 @@ xfs_trans_dqresv(
 	if (flags & XFS_QMOPT_ENOSPC)
 		return -ENOSPC;
 	return -EDQUOT;
+error_corrupt:
+	xfs_dqunlock(dqp);
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	return -EFSCORRUPTED;
 }
 
 
-- 
2.39.1

