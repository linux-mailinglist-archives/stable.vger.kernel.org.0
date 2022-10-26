Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B94160DB45
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbiJZGbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiJZGbT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:31:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436D295E4A;
        Tue, 25 Oct 2022 23:31:18 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nQqp030372;
        Wed, 26 Oct 2022 06:31:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=X73lIuVv1dKUGPvc38YuZn9piOhOQaHrY5lm2WaNfrg=;
 b=aTCLpTnr0R/RVMMd8vhTV5m0RlUnF3j7cu6kTps8REqQJeNViwT6lXbIBDfoqNrPwelC
 UD5UA9odFVW0AgOnTwRJz/jZsRaLGmMr5hb/RHsCC+pyMmYoAAZuVSNHCo167cOqlL78
 tf+OhDfFfFxRa6wn8GqZqlseXP4/QPzNEsE+0msteHvkcUn9my5d2lKEoTv0Z0JYAb4L
 xpTQVbFHZmf/zIsKXmkd5P5867CUC5YdHa/a78X5dKuk9f9Q7jdesrx7+si8cJYAo48q
 ISCyFDDTIxM4yTGlfz4x6E6vlpsvBrAyEESJ9pIx1mR6G+eqfYPPz5wCiCpS6gR2r6Me qA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741x25u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:31:13 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q357Z4010910;
        Wed, 26 Oct 2022 06:31:13 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y5d9x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:31:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JhdDuLB5AxASQNaRaJUHFyOmiviSXzqToVdFZkdliGglnTwueViWBOJusYwwCAEZc/UlMCyhquF1+6KxjTwd2rbPKPzRzptEjfTthQflU4ZjVdqzMfsYWk/4VRCVxkphSQ+Hx7i89AS0reirdT0/IqPZEnkVdacQg007ghPrQp3DgUgGRAltxsS7xeH7YZTllANEqr3NXlApT+kPd7e+TsOVa4FrvbmigWgDSUYr71w7Z+F3IH9o/caElswz3EdNh2gPNh8Dh07Hebd7UOFd5vBuhPuPiFGwU4+83gI63JJrmho5F+n21jjlL+Znow7FCQ+n39vdYBSWZKeZfbivmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X73lIuVv1dKUGPvc38YuZn9piOhOQaHrY5lm2WaNfrg=;
 b=T+K6ChtR9KE2bvkAApYpOTF829M5gaI/ZnwaSX05427LOCv/SZ5hVuAwQow6NzttXOJq3wKjE6h0PJQ/sgW+R7KKvcwqxoO3JvoCZzUx2SYZ0/1y8g0fOgdFiTP0HUCf+BiDdEsGhEyDiAsZFrZR0guJzEOFkPrHh0K0+M71GiHNkuWN62b+0DUi+QAC67afFXzJ8Nb7Fbgg7XWZtwmoiHRngWXP8v6SpG+aUme4KdoNmNubhPSOWM6wWqngtjzJdxTJINFbyjRwXCRMR9X1xFYyAa7F/g/8UUf2yEAwf7rRxNzDNXGM4C7K3TYfMZ9XbJwiY/zCX+CUqq6iMvH8zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X73lIuVv1dKUGPvc38YuZn9piOhOQaHrY5lm2WaNfrg=;
 b=pEyRe0r4X6Qsno3/f4LqJIeV1ovEaj5Gw56lczMjEq6Xu8kIvEirgDzLPqkRALN/g1eJ/gXSNCwflbH+5ajZ5lVMzjfEF4BmGN59KeYLZZ1bljnx+RyZK09s0jwDarYZSwWgAEkEplOPRlmJUYPzdwLvWwfAfucbXiuDDm47ofg=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by PH0PR10MB4646.namprd10.prod.outlook.com (2603:10b6:510:38::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Wed, 26 Oct
 2022 06:31:11 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:31:10 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 22/26] xfs: trylock underlying buffer on dquot flush
Date:   Wed, 26 Oct 2022 11:58:39 +0530
Message-Id: <20221026062843.927600-23-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:194::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|PH0PR10MB4646:EE_
X-MS-Office365-Filtering-Correlation-Id: b690774b-e79d-46f8-bb53-08dab71bac1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ojbSgCbcBDoFvm6GkjFexfCQd6mIqVSVs9Av3LZ+uDzeCXhc17M/pDBJm5JuQaDG8E0SEmsYFb9hM784uvUERlgtBBQ2lL/Q+EAaOJ49lzs37YwJn00MP3mG4PL/aq/k2zzDQ/1Mf0HiYbsSZqRg9Qbyn/tbRg56m9dSx+fSyS1zquaTDH63hb/TLWG8DwHCUeMqpoVctHusgg7q6TrrpxRxY2ctCPx8Nmfe45HQudoCWze0QzNN3R1YjdfGstU2MfhGDRZ4UmuK3QegYvwj0ZVNiPCEiubBaFyI+f35GILmCXXrW3WBjxwG57zofk4j6y77TaxRG6yMsouqIDEqnyNMFtvvqiJyOJ3iYYPD2b0kVyW1vCra/FOV1PVkokKNSdq0P0HEhmcwPBar2GwrpJtdeTF8MHutl6+qf4j62x/RwUuSKJ+uqgGd0OY88mpHWEAJ9b2x50MhmrDjLIqChwADZkuAsagthZVu9B1UlgrQ/Lv8DgOnUHekAagluDhHl+S5F6/0vuFGaJP7GITnI9LZHCBTh/+0leTp3hp95IhWIYy89OREc/rvyKPYzkFDEKw0gUm/rZZ0FKhbAAAFCkD36Xv4Z/MWQSv07I/eDM+SQs1DpO/jJaiIsIWF6Nlip5M8Ygs2wwGJ6TP+cOHBS0uX48a+MEWFuN4qMQmJ0n2rL6zQWWWVHJX58VIyI8q/dxKxT5Rit73mURF3t1OX+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(366004)(39860400002)(346002)(451199015)(478600001)(38100700002)(83380400001)(6486002)(66556008)(6916009)(1076003)(6666004)(8676002)(36756003)(4326008)(66476007)(186003)(6506007)(8936002)(26005)(66946007)(41300700001)(316002)(2906002)(86362001)(6512007)(2616005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mZpjrmWAuYycYOENS2FmyxDouaE7yPCu7FKCPT3TN/jC3lDFerJ5rX/GMa4D?=
 =?us-ascii?Q?RzqlTbrAXW54EHaCnVkmn35P/VIjZwdJ159HlqaQyD32+5opyt2s8OF7GGTA?=
 =?us-ascii?Q?/CB/1jvYkc+eZycQBjuHh3U4MbUrgQl1jgg080KZHBMODQ1R/C54pLtGDE6g?=
 =?us-ascii?Q?oELwgrAaSlzf/Gic5vY1be0eV3HKKCPYGyPmtyVPDDAa9XpTtGyqsWov7A/o?=
 =?us-ascii?Q?9ePb5Sfstydu5O+f8G1S08PKoavu7Y22xCx3mAkOCZC0RY5cB1cmBGdYR2ur?=
 =?us-ascii?Q?wB3iHFgUjoDQDy6uzKCticogoD6J5hbRSO2MSQFzjGUAj0A83Is9MyDsytHD?=
 =?us-ascii?Q?nssORI68uc38Rg229pC11JAsm70TpFRMvfygXEa2nDbhNryZT2tbXB1TrwhS?=
 =?us-ascii?Q?I+amMq2yU4jXWxjYI1nuTXjQ+R3JSNgfOdvIk4FMIGNN4x64EgMPxCjGZmA/?=
 =?us-ascii?Q?CRp7cJMw2id+nmDhm95PxJ8N9AjPFzvAZMWSQvOeJ1GqPPNaPNnIbWOZW7Cq?=
 =?us-ascii?Q?Y9rmLc0cHAwvER9l5RurnKjeAa9gfrpCoLf3mk+Ti7B4lHqJs+Fm5khP6CtB?=
 =?us-ascii?Q?KGXwZs+rORGlhvnxLxNuOq78reGz6eH1OgNUdrIs0Xef9G3r7KGWFEjmCWJ5?=
 =?us-ascii?Q?SAHMKNG+jNv/31EwPcRG5QkxpWGy9Z56ij9H4zuievUHzLxOX0F+wYaSc2sG?=
 =?us-ascii?Q?clj0LasFctrYIHdUCWXrG1tZU/Ju472L6WmfK5qrfT8xft7VVyAJDvSwkQAE?=
 =?us-ascii?Q?RughGuqvHtW+R/e3wIskhNcBeT3n34s/p/T0g+0QDU9JoLqkpc54ICQebtEa?=
 =?us-ascii?Q?Il+8GWKlZjLlhQubQphQaOdUWsbYit5CtOkq92LVFUuV7/wV9dVbZ/AItXJb?=
 =?us-ascii?Q?EBb4f3eoj7Qi0qEx2Vm/Q3rFqQkUKd/TLl3RdRxHBHSUjTX1BDo3Sasf7E7z?=
 =?us-ascii?Q?VrwN/wOEc+qJVteh0eCOkZzNOZIH0gY2T6QBquMoBhIs+2+dFCnJe6I1GnD/?=
 =?us-ascii?Q?ErCKro51XddDpmBGPgx+SqWy5/abTPe2qBZ9hDiLg3/XwMNuVt0P7ejalmAu?=
 =?us-ascii?Q?gVZ5Os4nh3Ft+PKeRq1n8Vmay7trzQMizlKtKab9VJ6Y7wvQ3n0P4A8OQA2p?=
 =?us-ascii?Q?Lz57bnLRTSpW5uURPn6Cn+H72nvCMpb3gCJOXjXlDYMheljZQpg/NCVp2Clz?=
 =?us-ascii?Q?gEzCkilqowbl5iy2U6/veC+Aghuadca5XaAqdrd98ko5Oi/TQ4F3VvQQzAJU?=
 =?us-ascii?Q?q8zyg6JbVKo0jG5kolZHMY6mIT0yZTAxT9+XGKQIvMp9ZLNqgXtQcQu7kSuG?=
 =?us-ascii?Q?jtAi2F3oBI1yWInV8PkhQbfNM0DTa7b9+YjLpMAVRBKodCi5ricFC7dT/RMs?=
 =?us-ascii?Q?eJTSc5M+qytHAAnSMZml1KsZZfm/0otKCOGIEekUpvwb9rVrY8Pdg+6EbPmE?=
 =?us-ascii?Q?SuRJ8DzKFZAl9oxyuB8HxixX7cSxgC08/QoMggk/xLgNujkvczCmZP2eYTVz?=
 =?us-ascii?Q?He2S1dZm4A0rn59ZMRiBnQjW1ibQbClpCkVpqizhS44tgVmWD4wcMj9TiTpN?=
 =?us-ascii?Q?GIjbNJeueaXTFY7/6t6EjhwU6KDwmvFXbFTyTjNu3lUZBCTP2fN3H/vwHoC5?=
 =?us-ascii?Q?3g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b690774b-e79d-46f8-bb53-08dab71bac1d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:31:10.8788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iHMKJVo7vV+/VLEIqF9ntGWD7NWPtSQxH9UPgR84nF0MPUJsQ2jVlQpOVDHZ8UQ+xxl0WUhn5AYH8MYhaoGVmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4646
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-GUID: TYgYcCcpnYyxv98iREtM1Svo7cCNdFmp
X-Proofpoint-ORIG-GUID: TYgYcCcpnYyxv98iREtM1Svo7cCNdFmp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 8d3d7e2b35ea7d91d6e085c93b5efecfb0fba307 upstream.

A dquot flush currently blocks on the buffer lock for the underlying
dquot buffer. In turn, this causes xfsaild to block rather than
continue processing other items in the meantime. Update
xfs_qm_dqflush() to trylock the buffer, similar to how inode buffers
are handled, and return -EAGAIN if the lock fails. Fix up any
callers that don't currently handle the error properly.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_dquot.c      |  6 +++---
 fs/xfs/xfs_dquot_item.c |  3 ++-
 fs/xfs/xfs_qm.c         | 14 +++++++++-----
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 55c73f012762..9596b86e7de9 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -1105,8 +1105,8 @@ xfs_qm_dqflush(
 	 * Get the buffer containing the on-disk dquot
 	 */
 	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
-				   mp->m_quotainfo->qi_dqchunklen, 0, &bp,
-				   &xfs_dquot_buf_ops);
+				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
+				   &bp, &xfs_dquot_buf_ops);
 	if (error)
 		goto out_unlock;
 
@@ -1176,7 +1176,7 @@ xfs_qm_dqflush(
 
 out_unlock:
 	xfs_dqfunlock(dqp);
-	return -EIO;
+	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index cf65e2e43c6e..baad1748d0d1 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -189,7 +189,8 @@ xfs_qm_dquot_logitem_push(
 		if (!xfs_buf_delwri_queue(bp, buffer_list))
 			rval = XFS_ITEM_FLUSHING;
 		xfs_buf_relse(bp);
-	}
+	} else if (error == -EAGAIN)
+		rval = XFS_ITEM_LOCKED;
 
 	spin_lock(&lip->li_ailp->ail_lock);
 out_unlock:
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index fe93e044d81b..ef2faee96909 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -121,12 +121,11 @@ xfs_qm_dqpurge(
 {
 	struct xfs_mount	*mp = dqp->q_mount;
 	struct xfs_quotainfo	*qi = mp->m_quotainfo;
+	int			error = -EAGAIN;
 
 	xfs_dqlock(dqp);
-	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0) {
-		xfs_dqunlock(dqp);
-		return -EAGAIN;
-	}
+	if ((dqp->dq_flags & XFS_DQ_FREEING) || dqp->q_nrefs != 0)
+		goto out_unlock;
 
 	dqp->dq_flags |= XFS_DQ_FREEING;
 
@@ -139,7 +138,6 @@ xfs_qm_dqpurge(
 	 */
 	if (XFS_DQ_IS_DIRTY(dqp)) {
 		struct xfs_buf	*bp = NULL;
-		int		error;
 
 		/*
 		 * We don't care about getting disk errors here. We need
@@ -149,6 +147,8 @@ xfs_qm_dqpurge(
 		if (!error) {
 			error = xfs_bwrite(bp);
 			xfs_buf_relse(bp);
+		} else if (error == -EAGAIN) {
+			goto out_unlock;
 		}
 		xfs_dqflock(dqp);
 	}
@@ -174,6 +174,10 @@ xfs_qm_dqpurge(
 
 	xfs_qm_dqdestroy(dqp);
 	return 0;
+
+out_unlock:
+	xfs_dqunlock(dqp);
+	return error;
 }
 
 /*
-- 
2.35.1

