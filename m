Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC513698D57
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjBPGqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBPGqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:46:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C729CD2;
        Wed, 15 Feb 2023 22:46:36 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2J4ML000549;
        Thu, 16 Feb 2023 05:22:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=W37MCSrjzF4A/aqzuASNK4cDEKB/4j3ckfSyVDt9N00=;
 b=t0sgCUNyv0DINUBhE+X6pWDJoiMAlgdgML052WZ7C/1Exfah20sUhZ0D1Rf2k5tMreoK
 61PxVF7CVq8qFEnBbDw5lPhnWgkuZCCQ5h2Pb7TTW2x+gsQa/6PUeBrkaluGqJnmQ6pN
 jzziqMWc8RjvtPTK6PLxUQFx9eMXEqeHukRJgK4l1FTYLnFdmswW+Mx3uc0w7eiT3h/z
 JdNqqrsvm9nNWRmLq/JE9fxr4HRXhXX6stD2eoZmU0vK8T/JbtR+U1XgBO3d3yXkKuMl
 yjdBVZfgxcGU7X6Z0WBTFyvwq4+sbJXAhu/gu2jVSOLC7K53TlJMgL6i9qzX8kEoyNbk 7g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np3ju26sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:22:04 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2Nu0T003548;
        Thu, 16 Feb 2023 05:22:02 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f85fbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:22:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YHWXWUqw2rm4chOVOrKC0cYXf+D1zlzIFA8yM7Tlubru1SBlSoc3+BO6UOcP/Jnvstxstyg+RykGYBuQaTB7bF1PtgK4sDGvPjNHn3JfqDDe4N/5LEUIulu0zQOczY+C9UmRv/hCvpp1TAi2KeX2FGfnjczWCyQSj5YShs443oIwUt9wxeDEqU9LY7o9eIWTRg0zwl14cZ891KaNy2GoUG9ifTquuu+TpVUmqi650OCM09YYIBGj5pfSj9LCvpWZrJEloLHIiKC5pQR1PnkY5+xY/GbAo7CCL7eEGwELqFdfCL2abrIADmUdPCmCK4z8RwT5oncxHiVvPt5emkT+Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W37MCSrjzF4A/aqzuASNK4cDEKB/4j3ckfSyVDt9N00=;
 b=YQZpjokm137+95EM2X6AoAqtv21OUbyjPn4gqQYAA4ehELIgyaU0GfAZ4PpzFPiyCWxiAWmwv5xomUTp4pCGCs1f6yD7TiE46GMoS9TARTFFMypo8bdXyJiU9NdVkEf80XAvxuj8HDpflFJmIWT2Tlui9Hlih1AjGkJdqG037Eb6/GKMIwS3n0LdR3lTmR5D8BaAgKSyfvt2X0Wc20Rz+8f6Yt3W2qUyj9WGW1OYqU3ZsDfbP4MlSD3nVuxwWf0GYQ1E+xHutM2qMl5nLoN4F4sTvVI3lLacC7ImnJrtQGTCw3woDPdNTOQ7KPxAiJUXBphGBHRR4khzoWwF+1H+WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W37MCSrjzF4A/aqzuASNK4cDEKB/4j3ckfSyVDt9N00=;
 b=lqhlozy3CPTXpca1Ew45lM1aJmpdeeXRAH8n9a1gEmNIr/a3A4muNLpFb3ufoNksWVmh5XrqjtdtuZkbNJpR+9+SvLyi6G9FmdBRl5w+NpMLS7Ism5zKBWYAxHs31pPZgnLgwWIzsK//cjx3ID6fmeMNUq8T5ugfLrWSU6iZt70=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6789.namprd10.prod.outlook.com (2603:10b6:8:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:22:01 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:22:01 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 13/25] xfs: xfs_defer_capture should absorb remaining transaction reservation
Date:   Thu, 16 Feb 2023 10:50:07 +0530
Message-Id: <20230216052019.368896-14-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0196.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::23) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: 449bfa78-2ce6-438a-9a8b-08db0fddbb5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MpMW2tqDt+YbPCxcIyN5LDLOc2zJrnEqA8Sw6wY7YraFxZf3U/lOGm4/uCE89oRkrX4W9I3MuKQwJfcqMkEn0/1KBIU68KxhIpznRYlRQ/ExuWW+5vMboSx1AxTvihY0oyL5OhmPwDzy0JWfDWdA3bhZun0gz2yXiLMvh5k1MfUxnxDzwua015XBGSsEVjqCf0+0BUoX0EG+EqdM2dqeJGs0otld1SjhrkUtS0LiJxzPP0k/33HPkOq+KwNRtQLpyB4Fw+6RCAwg5I4powNoNDIyIkl6V8X+W41xXs28bXl5/l1Fdklkxpa+OI6ysSaG2pVyQKNxzSXHTtOHArsuprxPdwA1lC8glo8pT+QCEXTOkSt0MLoeIJOGVe0A/nVSeXPmP9gcD5fjvBBq8b7VNOOJVBXF3DAbxjKAFb5mQbJeoBQIOlnXH3YTC2/rXq8URqOlA6O4Gk/hmDW0yrHBPHG6yoYm0Ex+7DOnlndN5UPRuDp7d24FC0L0mm95WZkx9X62UKspDBgYKGRyKiTj7vom/gvun0W8iAj/LlOHEhVYSgsklXdKZjbf/A17N9HUk9tWUzPuI4YXec/yvEcz/1OpSoIrLySyI6mARZOMs3lYSj+SWNIyYrLnPPz67Vgi3fJAS+HYJG5qCto2MZMNzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(2616005)(5660300002)(38100700002)(316002)(6512007)(6486002)(2906002)(1076003)(6506007)(36756003)(26005)(478600001)(4326008)(66556008)(66476007)(8936002)(66946007)(86362001)(41300700001)(8676002)(83380400001)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nvqme0a02nxbEP0r0uuWXJnqvyzHgkHBSPg4mCGvc+Ch42REp0INCDyRrAtm?=
 =?us-ascii?Q?fq9kgv6k4dbe0T8xmilN0UPMQxa3Qj7pz7WXUWOjuB9XdLYdjezJkvcEvcx+?=
 =?us-ascii?Q?aXc+o/MiusQKmdf8tZcPCLj0eERIkVT1bD0z3FXhgE6XE1cgNb24Rbr1poUX?=
 =?us-ascii?Q?XWAArlNtWiXvoQpJkRL46nSlC/qArFuEW4qJQAaWnEeSsxV2900jb6M80QPf?=
 =?us-ascii?Q?c+UbUWUJb0eEUsoYCCE6pkwnwCOF1pGrTur7TBcUwVLyusseZosFduGe+f8+?=
 =?us-ascii?Q?sqRDuKjwE5d+bIFRjms2GadVC0eLdKuLv7n0yqeQkEG8FNKuW0VmuLCJ52zq?=
 =?us-ascii?Q?dNln6nKL2KGyKEbVB/uv2zwYkaXobo3NzOgUS1vh0A/cCUTqeQW9YlbwELW0?=
 =?us-ascii?Q?zvXMrHlTX1PNDoXu8CiG/Xtkp6qWPV4o8B4tckjaNiLSxu+2+4B200FUMrA1?=
 =?us-ascii?Q?MlBCAuNrpBSS/4QLKGbVxrkuXLqbS4u1T/00aRkcouu4i0m4MHiTOBsbylsT?=
 =?us-ascii?Q?eonZgKY7Tdq09gR/euWgW77wsikpS88f8FRFI7l91b0W8h0xTLCsj1wuyQ8q?=
 =?us-ascii?Q?lc3gbIqcL5uX/c3cM7r55GY9VuVShsYZljU+8f81xXyCs6qEqG3rWgnebNdq?=
 =?us-ascii?Q?zNDERjX8aGUb6g3ms33vgFzqt0sEcbI3UsRAi4V7bRGLDztk0GBqQNECn2Rt?=
 =?us-ascii?Q?74mFl9scqQMiSPfC3WBU4EMACOoCZGifJo7s54LPxGE/l+T5BkFeO+uJLJui?=
 =?us-ascii?Q?LnyrmxqnR1cfZXYTUexTLEPd6vCqxC7Ra3hdiOBuWK2dXQtEUwjXnicDpBc6?=
 =?us-ascii?Q?RBoUm5CoTT7IDoMxDoZR3A8k8FmeduH/PCit/YdyKVOQ2PWaR1BuiJG8p3zg?=
 =?us-ascii?Q?Rb3RDN0AGaJ5lvLDSugj/+qjOA1smkRwmL2ylfEXWcqDI7ODI/NYFDtli0H3?=
 =?us-ascii?Q?00RKr+sXa37eQZ4SV5UL7eCbSfQOrjiG1xoKmHgFlzT4uBP+zxUro80Ua0CW?=
 =?us-ascii?Q?dQltghwrzlo/7JnxxiVqgh2PrzPrsnB636GtRcl5xRh6XGZv/qRNcTK7N11b?=
 =?us-ascii?Q?uvQpZptRgc+sasocyC45heF15wtTQearb1MC1uyiuSfQar/52ptr0/23KqGQ?=
 =?us-ascii?Q?q5gRs1tIQEe5hv4zGoo9/QGIZC+vvKhRUDam4kJlK9ZUhWNzAbik8Kasltnr?=
 =?us-ascii?Q?2cfu/7e3Ly0MCk1EmyFOekUYvGsPBYEsmUyIZJA9Y7mwwUW2AwMKFxYcceWh?=
 =?us-ascii?Q?REZdomzbtutCd2sKZ7gfxH8jfXxw2pg+48eS2ss/N6lLVpOD7whXXDxwrtw7?=
 =?us-ascii?Q?U1A/mpWdWzU510/WamJNCoVd6fo5aYsxaxrzN+FTYcc+ugAYhF68wLYTzEJB?=
 =?us-ascii?Q?5xyaczHxf0HNFr6CDc+f70+QDIy3czEbFKxu2bqdPbVBC+WZCrkDkQlVDOQw?=
 =?us-ascii?Q?Sh4pHpKShiTXm7bTbRzF0DHDBnrBgoOuzZBNiREN/J1bHSn72G0DZuBfOWxa?=
 =?us-ascii?Q?R/Ykr4ePVo8kC4ANyvfX+1OMmNPrZuS5I+y9cGAj/PAMjio8jwyGFzj9k/O/?=
 =?us-ascii?Q?hArikDhE9ZexmILvUhEvPr32N0nc0TVflSk/C/9uw2D57ejUUSJantzVIiSr?=
 =?us-ascii?Q?Iw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: uDilZ8n/9xW092OVfxrv8HSAyqr7MdSGTO3tCWCVY4+yZM9LjGX2GLnCIyfj6K8Hdawn6qqABRcb0OPOU7H/6kBWcNAYyxAKnnFodPQuHebhpMfk85nPnvWHs4zF6qVoYn1WfdAGuW8dl7Otu6gCKoLQnZaL0VYlDOkhTvuBznHVLQKd17tqaobt/3NsqkMskeyfKbpAnTlETj/MHt/beReBIfOI65BTZiZCeEQA0AH8YTlSfWjwZyiNzFrTdfouvyP7/Ed7HLlG5tqtI5ipq8oZA3aO2czEPAR4XBf4846kXTlrwOYkysihUeBjPeNSHYA6Q4hQZh6NXhKZBimqxnDAr1e3dhqcR7yuY289Qu122MUw2bV88kpHNSLr3xTK/SS/RyrlaxIL71tNEukhDVQUfNb8jmF30ccWGjH0vZ9R7nTLTUU1Voyhbe3tF91Y7lr/8OrBdNKxsZITUTWi8CUFDLZXZawhULejh9PDHRMmlddDY66OW5czxUDbdiWgPFQJcwpikr2KYSllw3S/PFeiXDtyE2pZq9pxojXUSXmLI5yRqNq/8cAHhy2SwdKyiPRDn+gOfWQMoe+CzjV9RIMsrrCNBGq6s/S9KNrsZoxvK9uYmLWo2Ia//fkOMLc0BRTpwEHA8q848LC2zRtxH2sLVArRxJmutv84GHr4JeU+rNt8QDWQ5dCd9t7miwd/wDKmANvqfO0l37EdgjJOG8yMpBxz74g74h+Gjy4zX+xDhepkyfU1vFX4HXz6V4eLkawB+eoSM2qnlHlIF5Jy2s1SJx3WUXNSN/ZrAracdUA/KojDI84bwNrOmt9Dvn23yuMJhmcR92dwbs5A+pHyu3iEHtUlxV+zOSYqfKfvCKDTJQmbyPua4MOsbAWmre7M
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 449bfa78-2ce6-438a-9a8b-08db0fddbb5a
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:22:00.9616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G8MisTP9w0GhEwvm0t6SN8SjXq0b5XL9ybzydTIRbEiA5sAkA5ZWVrPyA7AVoXOrBkjVoLsmV6d02rTxJko+hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160043
X-Proofpoint-ORIG-GUID: B-lB_7Msfx9-n2lywOUnkOgnDk06yX_d
X-Proofpoint-GUID: B-lB_7Msfx9-n2lywOUnkOgnDk06yX_d
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 929b92f64048d90d23e40a59c47adf59f5026903 upstream.

When xfs_defer_capture extracts the deferred ops and transaction state
from a transaction, it should record the transaction reservation type
from the old transaction so that when we continue the dfops chain, we
still use the same reservation parameters.

Doing this means that the log item recovery functions get to determine
the transaction reservation instead of abusing tr_itruncate in yet
another part of xfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c |  3 +++
 fs/xfs/libxfs/xfs_defer.h |  3 +++
 fs/xfs/xfs_log_recover.c  | 17 ++++++++++++++---
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 4c36ab9dd33e..d92863773736 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -593,6 +593,9 @@ xfs_defer_ops_capture(
 	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
 	dfc->dfc_rtxres = tp->t_rtx_res - tp->t_rtx_res_used;
 
+	/* Preserve the log reservation size. */
+	dfc->dfc_logres = tp->t_log_res;
+
 	return dfc;
 }
 
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 7b0794ad58ca..d5b7494513e8 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -77,6 +77,9 @@ struct xfs_defer_capture {
 	/* Block reservations for the data and rt devices. */
 	unsigned int		dfc_blkres;
 	unsigned int		dfc_rtxres;
+
+	/* Log reservation saved from the transaction. */
+	unsigned int		dfc_logres;
 };
 
 /*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a591420a2c89..1e6ef00b833a 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4769,9 +4769,20 @@ xlog_finish_defer_ops(
 	int			error = 0;
 
 	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
-		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
-				dfc->dfc_blkres, dfc->dfc_rtxres,
-				XFS_TRANS_RESERVE, &tp);
+		struct xfs_trans_res	resv;
+
+		/*
+		 * Create a new transaction reservation from the captured
+		 * information.  Set logcount to 1 to force the new transaction
+		 * to regrant every roll so that we can make forward progress
+		 * in recovery no matter how full the log might be.
+		 */
+		resv.tr_logres = dfc->dfc_logres;
+		resv.tr_logcount = 1;
+		resv.tr_logflags = XFS_TRANS_PERM_LOG_RES;
+
+		error = xfs_trans_alloc(mp, &resv, dfc->dfc_blkres,
+				dfc->dfc_rtxres, XFS_TRANS_RESERVE, &tp);
 		if (error)
 			return error;
 
-- 
2.35.1

