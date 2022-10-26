Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF6D60DB32
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbiJZGaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233129AbiJZGaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:30:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D7136DEB;
        Tue, 25 Oct 2022 23:30:18 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nVl9030448;
        Wed, 26 Oct 2022 06:30:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=V0p7N4PvwjuFGT5bQvHBa5EaeYmOzZ9KJhy4Carla8Q=;
 b=rsnGwTcqYmntF++zeHz9TLXjQpclsb7GT2w8Rr24a19j5B4FyxHof3eDVNX/R85luACn
 mRBTkh8H7PbT5D0pXxUfz5egNyuuMFFJLNXR/z0lEiZNsBXWtcBIPy2dxSdyxd0EQdF4
 u1Ij5NpGdDrpFjuwA85TDfYLCW/v61kLJ7Dzm850FRcu5LTb1lCfvFeGjVM82nOlrSI+
 imi71g54dR52qXvCWbjOPurd4H7Ed/604Se5qvMnPji6mgsK5yG3esE2QTQQGumhlzSd
 WuQNxzCRU8NGs3cTcSH15LH1k6w1W9lxSVQhe5dxAuGnH+xZD6BIl8Ti/h0Lmeizd7Hs iA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741x23f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:11 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q2qJ8N021955;
        Wed, 26 Oct 2022 06:30:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6ybprbw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1Kg1auG+6+gawtr/Y5+4CM7pisz3z4VYkPVvAPlbvJf9YQkIPDiwFPS0raEWaoNHoVW8mZB7SBWrq5JMS1IUhL8iOJTdFcCAYZCsdoku3Ce+neO37wqwcJGZNaPwy6DlqGauhNeBTL13d9dfL+NNNx6W2oeU5ThUiYNnIVK6VAJJN0abArARpjypSVmqYCz3ExE887xJ9WCjFjyXZJJf/pYYJzjlb974lD5PeQjRlGmwUxtYpECg03ZKVxzbJc3eNteUdTS0yCykWSnwRbE/OUgX8R8CXCr3pW02u2MF1xL7cQJAmBN1HMturOHxYybeQQ4E+e1s4zB8Dudl6kIfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V0p7N4PvwjuFGT5bQvHBa5EaeYmOzZ9KJhy4Carla8Q=;
 b=giLC1WzM3Z2n+y7JCI7r0kjqdG5q130N2KbX4DvAfz3xX3fLY2qOjp6fN8fYRe0qdq2C0cxtMTbx1G9nUMT203ECUncfVvweCRv1SHT+jicmpYaH3qkKJOSZ/aPMzUi9kepwt5jSZ4K2llWALP762Kwd41/Bhq5EEfGsNJz6s2tWKugOSgMZLzIOeF30JhbjYm3E3sBMP0vRI63ET+qjF3sdwWissgIu2zJ2bxHDlLUwUmST68KlZYqsTrOayyfFNDaKaq/YD5PivOL5MZkZrEAwVt+NoYpPiP4WHlHQFg1leP8IKISuAz7OAJZgLIxrrnP3Pe6neHAYWkvuaHqPMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V0p7N4PvwjuFGT5bQvHBa5EaeYmOzZ9KJhy4Carla8Q=;
 b=tx5dBId+xRNIrVpiAsA6lEX14AbICq8VS64mWuiFDfJ2dLO9AqiVMxRhTJQvU/PSPF1XL0mbKd6Y9DueGtn8J/DvH4jd9O7kdOKQawHE0mnXRFUOUoysc/p29BPnGK2W/UJXJsB8mI0WXRCXC1CF/DzK98aWSDk0vqwBApSBGfU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB6151.namprd10.prod.outlook.com (2603:10b6:8:c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 06:30:08 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:30:07 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 12/26] xfs: remove the xfs_qoff_logitem_t typedef
Date:   Wed, 26 Oct 2022 11:58:29 +0530
Message-Id: <20221026062843.927600-13-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0096.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::36) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: 5421a9bd-ca9d-4bad-751a-08dab71b869b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ZOumvdAeUiGVOH2wtPU2apaIPh8ju2c2CffSk/TfxaDSyr+91O7xBIc1G0Tdb5BxSRyF3jfFCueu1z2ky6TxXIfC3XbBncknpe/T3HpEidv/GMnqTtH30U7WbN/0PXOzzam7tOzjCdIV/sn1PxwJ2ogUB9aQNMuZISGu3zKws+p+/6KaIrtug1/bBnHhx0d7OBygtckx2Cp/6o+FLwiyhIwofAZCugfEqg/rP/RGZfSAL7FrfqrKeEgExmrmRzZ2oOz8slKSQkZ2Kp5pWITRAgI6Mm5JGlHYi9XfZjo3dZi9Fn+W52SOyU9y1xTzSm8MDa+BdBo9mnmQ6ARqs5wlCWQA5LEGLDf6ZH3FgfM3Vsu8LO9+HvJ+E6a+ctPj6WzindrhYep2mR+elwqwyQQ1n4xmb7KlCVONAbm6cWkU6nI13FiRuA6ahDtDtxTvPmZom3j8DPBER62cpQ/ynOOmXf19YFyaVbVZG4vxyKwFa8S69498rn+bVNsrCnMVGXW7D8+vcfjn2MFb7cSlfNtusKwQGWOJ9j+STkau+rNgtdP3wohi8MsQ2OTv6lSF4orXL6t05LNuYOiDg1NV8pF8ycyyCWP9JyQ2RkgcfZB0TlObrb7h+n4DLsc7Dx1FgvXbzo/uF8Dix59aGUSV68ltiUb6R6QLPAB087QZ2tHJ3ZFXmDkirq/jgKWWTjfoGU2J8TvyF8takK4jWVKE1MHWogoNilsAS7K8MFV+wIM4vTZ4Qgqf/H7ESPqUOnVqmTB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199015)(6486002)(6512007)(6666004)(6506007)(186003)(26005)(478600001)(2906002)(6916009)(1076003)(83380400001)(2616005)(66946007)(41300700001)(66476007)(4326008)(66556008)(8676002)(86362001)(316002)(38100700002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8XEETqk/honShtYgMuHtE6EqPFhGARl4KwI8GBlrAz6U30tCS5MTR5C8Z2f3?=
 =?us-ascii?Q?qOqnEMgMD910FLdHjs6NB0IxzKaaz7wLkgI2+lxm+0ihpB5l1u7wKf9WKpdO?=
 =?us-ascii?Q?cqHZc9s7aJbdD3wM7ff0GGTx1t7tmi7j9e8bn2QoDbTk1I7tuFXu2Cuqs/ta?=
 =?us-ascii?Q?uYUqX/xqpa+F7PIoKmZU+c/FkffOLuZO3p1HPIac33xrQSvLKK/TEqtE+YE1?=
 =?us-ascii?Q?f6flOGAJ6nNgL0F2f0YyKsvUuNXz0ZsTG17hPsG+6Wq02ZxVtQjByopJuYdG?=
 =?us-ascii?Q?Ilx60wTeyEEkcZygYiCjkplfuSiA3Lp569dAbU5wdiahxav5jJBLH6udH2pO?=
 =?us-ascii?Q?bUhE8e33/EnL8pCf+LlgfkKnKtoZn99kZWI0GXB76C0Y5RF0licSv351QW9V?=
 =?us-ascii?Q?ZZBdUVrUkKmxC/ZSd494rQI8Wl0/Dqc3XvCkQIOSfMumsCbx4WYmfwo186PN?=
 =?us-ascii?Q?kUAQCAJYQK6W2ThSw/Cd5L6pP+TP7Cpgs7VNStViA7enWxEe6LfR8130JFEa?=
 =?us-ascii?Q?VEsD4dlB7aEfVikZpV8JBIXstTLCfyEx7qKerhF5ZnVpwlAWNs1t2Tri+o/2?=
 =?us-ascii?Q?dNKsclh9E/N9xKzjcRV4zTTUn8OMu9Q7h5PcGj8QUA7ZsFvtYRwu1B1nr/GZ?=
 =?us-ascii?Q?EIHqHw+Oiwms3WaKAtk2y20u3kpDvMRGNiww+nT2yAPlsxj6gD357XCAKcKe?=
 =?us-ascii?Q?Wbtz1umzpdSwHXRxfaWbUYG6tZIni96AoapamX9CQBUG1QJINoW83gAQkmWf?=
 =?us-ascii?Q?75Iilat96dVqOIUU8X0CoZaQyL+BueDEFsuRnJV8qbTCyHPUqodB0BbQHHW9?=
 =?us-ascii?Q?9VIjHPENVfJEFkXttPbikRUwAUsQ37odoNpNVLaPu/Smnr1tLc2TXJgyuvSM?=
 =?us-ascii?Q?Wik0g/dvaVhicAqv4Pc6fbG+7NWxNSECVegSrquJApaNpT+sKbNiHjIR9tnG?=
 =?us-ascii?Q?vLg2qjha1tWPb9tc1gHGtvgqrn4tUGGsVb+FFlFv5dnwRh1ZKaMfH2oxVRxI?=
 =?us-ascii?Q?PaZowVrfTXMFD2Daa72d1+DSbCg29Qegzpdpsd8GLH69BPPuqdptEuXN6t84?=
 =?us-ascii?Q?aGda/Vp6gJ3agTElL2JBS2Anv/s3iSO8gIOj/XYTFq2fVYOn9JSEBm6gWwZg?=
 =?us-ascii?Q?OfIyABbmMP0t85Gh5zMt7VY5hFeIP3RdOZVbG62FJt3aNe1+knHETnilHobz?=
 =?us-ascii?Q?dAwGLTI4kmsiwygz+D7UHoJlikRz6ICFZkVIlS1IdWyRj0Ln25Eq5n+mtLLC?=
 =?us-ascii?Q?gP5uBqMR/DPukqifGNAjuqSC7/4d+pTyZ0njAOjvE66MLkxi5xc1+kgyqytk?=
 =?us-ascii?Q?fUqfJ88YGNtM+5WswUumMlihkVH0zUjvRFHMowaPUG7Io8byT8B8ACSFWVPS?=
 =?us-ascii?Q?EER/xCCaoACqE+yZ9CcBTtnXTQrfOBMoJG036MX6uvREWCVTSCGM3+MVt+BR?=
 =?us-ascii?Q?XdUZw29vNSCXwTeawVXWxQMoaphUDMxWedJgIzkYnrK2nfiOdendiT+XPWFl?=
 =?us-ascii?Q?zeqRBzi6D26zZXpfM+x126v7b0TgRHV+akpzrZCI/xN62yPsC783Xprl454u?=
 =?us-ascii?Q?Nj75Do9rfoAnqzwRX1NaQu0g4ZllVTtr+EL6whc6I3zEKSTede/ZgGvDJMNq?=
 =?us-ascii?Q?yQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5421a9bd-ca9d-4bad-751a-08dab71b869b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:30:07.8900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gakNADoFsKEhnlE1KlR0icieqCeqVQzxN/W48psAGU4rjuF+D2cvpLPJ6pbvrm1pIYA9vtwmO3zFY5Ab91rkvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6151
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-GUID: Au565_3hnMcrAOtJSlivbmgP9teDPjak
X-Proofpoint-ORIG-GUID: Au565_3hnMcrAOtJSlivbmgP9teDPjak
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Reichl <preichl@redhat.com>

commit d0bdfb106907e4a3ef4f25f6d27e392abf41f3a0 upstream.

Signed-off-by: Pavel Reichl <preichl@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
[darrick: fix a comment]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c |  4 ++--
 fs/xfs/xfs_dquot_item.h        | 28 +++++++++++++++-------------
 fs/xfs/xfs_qm_syscalls.c       | 29 ++++++++++++++++-------------
 fs/xfs/xfs_trans_dquot.c       | 12 ++++++------
 4 files changed, 39 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index f7e87b90c7e5..824073a839ac 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -800,7 +800,7 @@ xfs_calc_qm_dqalloc_reservation(
 
 /*
  * Turning off quotas.
- *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
+ *    the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2
  *    the superblock for the quota flags: sector size
  */
 STATIC uint
@@ -813,7 +813,7 @@ xfs_calc_qm_quotaoff_reservation(
 
 /*
  * End of turning off quotas.
- *    the xfs_qoff_logitem_t: sizeof(struct xfs_qoff_logitem) * 2
+ *    the quota off logitems: sizeof(struct xfs_qoff_logitem) * 2
  */
 STATIC uint
 xfs_calc_qm_quotaoff_end_reservation(void)
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index 3a64a7fd3b8a..3bb19e556ade 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -12,24 +12,26 @@ struct xfs_mount;
 struct xfs_qoff_logitem;
 
 struct xfs_dq_logitem {
-	struct xfs_log_item	 qli_item;	/* common portion */
+	struct xfs_log_item	qli_item;	/* common portion */
 	struct xfs_dquot	*qli_dquot;	/* dquot ptr */
-	xfs_lsn_t		 qli_flush_lsn;	/* lsn at last flush */
+	xfs_lsn_t		qli_flush_lsn;	/* lsn at last flush */
 };
 
-typedef struct xfs_qoff_logitem {
-	struct xfs_log_item	 qql_item;	/* common portion */
-	struct xfs_qoff_logitem *qql_start_lip; /* qoff-start logitem, if any */
+struct xfs_qoff_logitem {
+	struct xfs_log_item	qql_item;	/* common portion */
+	struct xfs_qoff_logitem *qql_start_lip;	/* qoff-start logitem, if any */
 	unsigned int		qql_flags;
-} xfs_qoff_logitem_t;
+};
 
 
-extern void		   xfs_qm_dquot_logitem_init(struct xfs_dquot *);
-extern xfs_qoff_logitem_t *xfs_qm_qoff_logitem_init(struct xfs_mount *,
-					struct xfs_qoff_logitem *, uint);
-extern xfs_qoff_logitem_t *xfs_trans_get_qoff_item(struct xfs_trans *,
-					struct xfs_qoff_logitem *, uint);
-extern void		   xfs_trans_log_quotaoff_item(struct xfs_trans *,
-					struct xfs_qoff_logitem *);
+void xfs_qm_dquot_logitem_init(struct xfs_dquot *dqp);
+struct xfs_qoff_logitem	*xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
+		struct xfs_qoff_logitem *start,
+		uint flags);
+struct xfs_qoff_logitem	*xfs_trans_get_qoff_item(struct xfs_trans *tp,
+		struct xfs_qoff_logitem *startqoff,
+		uint flags);
+void xfs_trans_log_quotaoff_item(struct xfs_trans *tp,
+		struct xfs_qoff_logitem *qlp);
 
 #endif	/* __XFS_DQUOT_ITEM_H__ */
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index da7ad0383037..e685b9ae90b9 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -19,9 +19,12 @@
 #include "xfs_qm.h"
 #include "xfs_icache.h"
 
-STATIC int	xfs_qm_log_quotaoff(xfs_mount_t *, xfs_qoff_logitem_t **, uint);
-STATIC int	xfs_qm_log_quotaoff_end(xfs_mount_t *, xfs_qoff_logitem_t *,
-					uint);
+STATIC int xfs_qm_log_quotaoff(struct xfs_mount *mp,
+					struct xfs_qoff_logitem **qoffstartp,
+					uint flags);
+STATIC int xfs_qm_log_quotaoff_end(struct xfs_mount *mp,
+					struct xfs_qoff_logitem *startqoff,
+					uint flags);
 
 /*
  * Turn off quota accounting and/or enforcement for all udquots and/or
@@ -40,7 +43,7 @@ xfs_qm_scall_quotaoff(
 	uint			dqtype;
 	int			error;
 	uint			inactivate_flags;
-	xfs_qoff_logitem_t	*qoffstart;
+	struct xfs_qoff_logitem	*qoffstart;
 
 	/*
 	 * No file system can have quotas enabled on disk but not in core.
@@ -540,13 +543,13 @@ xfs_qm_scall_setqlim(
 
 STATIC int
 xfs_qm_log_quotaoff_end(
-	xfs_mount_t		*mp,
-	xfs_qoff_logitem_t	*startqoff,
+	struct xfs_mount	*mp,
+	struct xfs_qoff_logitem	*startqoff,
 	uint			flags)
 {
-	xfs_trans_t		*tp;
+	struct xfs_trans	*tp;
 	int			error;
-	xfs_qoff_logitem_t	*qoffi;
+	struct xfs_qoff_logitem	*qoffi;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_equotaoff, 0, 0, 0, &tp);
 	if (error)
@@ -568,13 +571,13 @@ xfs_qm_log_quotaoff_end(
 
 STATIC int
 xfs_qm_log_quotaoff(
-	xfs_mount_t	       *mp,
-	xfs_qoff_logitem_t     **qoffstartp,
-	uint		       flags)
+	struct xfs_mount	*mp,
+	struct xfs_qoff_logitem	**qoffstartp,
+	uint			flags)
 {
-	xfs_trans_t	       *tp;
+	struct xfs_trans	*tp;
 	int			error;
-	xfs_qoff_logitem_t     *qoffi;
+	struct xfs_qoff_logitem	*qoffi;
 
 	*qoffstartp = NULL;
 
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index b6c8ee0dd39f..2a85c393cb71 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -824,13 +824,13 @@ xfs_trans_reserve_quota_nblks(
 /*
  * This routine is called to allocate a quotaoff log item.
  */
-xfs_qoff_logitem_t *
+struct xfs_qoff_logitem *
 xfs_trans_get_qoff_item(
-	xfs_trans_t		*tp,
-	xfs_qoff_logitem_t	*startqoff,
+	struct xfs_trans	*tp,
+	struct xfs_qoff_logitem	*startqoff,
 	uint			flags)
 {
-	xfs_qoff_logitem_t	*q;
+	struct xfs_qoff_logitem	*q;
 
 	ASSERT(tp != NULL);
 
@@ -852,8 +852,8 @@ xfs_trans_get_qoff_item(
  */
 void
 xfs_trans_log_quotaoff_item(
-	xfs_trans_t		*tp,
-	xfs_qoff_logitem_t	*qlp)
+	struct xfs_trans	*tp,
+	struct xfs_qoff_logitem	*qlp)
 {
 	tp->t_flags |= XFS_TRANS_DIRTY;
 	set_bit(XFS_LI_DIRTY, &qlp->qql_item.li_flags);
-- 
2.35.1

