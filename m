Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E4560DB35
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbiJZGab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiJZGa3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:30:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6749A4C01F;
        Tue, 25 Oct 2022 23:30:28 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nbxl017465;
        Wed, 26 Oct 2022 06:30:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5W9v3eWpnM6xCr31lxTVWZBglzWEJwMnDhYqg27flUQ=;
 b=blfKi1uhvPz0MfnuU1g2492KUozMPUJGp2xPbp8ZSLj97mNkH3l+OCgqw2zr6KVONlts
 z0ZYcyP6pOUxU20Aldytt2RkPfUiXv5U5Yym5D8SXoJ6i8n2jYH52//NWicTBdlGaHse
 o3e8yusyIkFYRjWNcZWsYRxfHBaulNfy/rt/Wj65jZQvAXBG6B6W7yxJKrNvZ81QwOg3
 5J69bUWeMaoq3UpvMnB2gEjLbcLhX6eEX9iG6srm4P/jYdSLgdg94rXSOyOzJ+J6EY9O
 optOa/rY0RUQFZEvOLa2LkPjaAXVE0CLSZWx+O43EReD9CXYhXBAUFzSfTGucasysL7Z hw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc939e620-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q2w6hZ031975;
        Wed, 26 Oct 2022 06:30:22 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6ybe8et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNvIns113QFpimc53F8JQqOHJjNGN9pUxWAj926X0OqYSzCt873bxaaTSJfqCN+tLyMk9FB3Y1H1x4ZrOmrbcQfp3DB/TXa9G9QJBG3gySNQ00+KPLBaRxKi2xmXIm2yGG+kar14fpeJc2YI01Uz+yKM51Ws+VIvYMUGElqT4vu8X76AS4a0/WIpZ65MjyY9vc/u94TD+VkcBWEyp6WPNGvUkklBfbHtzao5rbPwrcCsQnQJDqKG/xIcmg2sdv6hJzOnsIUnX2PwJQWbsxmkJm2TXXuKaxn8/g4cKxl36bcpTScNQxcBthcdlAe9JRKu24E8QZHGDZusxnK6bfSsrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5W9v3eWpnM6xCr31lxTVWZBglzWEJwMnDhYqg27flUQ=;
 b=UEJ+OBAwoaB32iJeaQIvAYrFYH2GaxwpiUzO0lFucTNs5/E+vIF3447v2v9YoTvBWveYel3Leon/Fy/0D8P5sOFzJExVHURnqkjVQnYS+r/lvomu+TvFiY/o/teHRJiyCtnDWiorOsGu0QTDfDg5QS6C9AGPKplfSm4ptWZAnLeqZPsFyZdHKpm70o/EU3jURjoTIZmdwydd+W4CmjMe7stRRWHIJnRBC49kuUEImfOW0QMkIqWy6n6nKpHj4xEfS+2DMCLN6o4frD6AOsAd64pIfOg4ZOWonAcM4D+H5odmGJQ7fPCFU/OzM9AkZDGZcFXtqofH67chvWmP7ye/+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5W9v3eWpnM6xCr31lxTVWZBglzWEJwMnDhYqg27flUQ=;
 b=jjoHjHGlJ+HIqRRsVshP4KWJY+7F4Dv3Rz+09z1EBvxAjA53/u13T21xmD5Ic5Yh7pBJEpYYEUts5Y0H/Jn0DQ2C8iewz4UtD+IPlOGOwxCdUgUTU1bg+m/J9Y/47HunzikXf74LsSMTXDIf3EswN0fzFcEHH6e7Y/EqG/5H+Kw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB6151.namprd10.prod.outlook.com (2603:10b6:8:c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 06:30:20 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:30:20 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 14/26] xfs: factor out quotaoff intent AIL removal and memory free
Date:   Wed, 26 Oct 2022 11:58:31 +0530
Message-Id: <20221026062843.927600-15-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0073.jpnprd01.prod.outlook.com
 (2603:1096:405:3::13) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: bb1db02e-48d8-4d0b-1498-08dab71b8de7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JS2hD3ROKV1q4+L8RuwcHWf4gz5Doa1mJ8ktpJF9LaerxHZgGRzkd3dU7OJhwoWicvMFYEpCHXq78fu+rbDN/LOAYA9ntbI/agTVL/SHdZDluI8B38RUNhRnMbiPXWgTeKAqmnyOGANIg5UhhuvCBImvqA459celc9YCRt4s26GVJTx0vMZ7urwFSjnU9CZdT4wVruIpTWLLxoC6VVPKrmlQHpfcS+Admul7C8jcTjojctHDx46hpIlOJpo4IhkuUmhnIzJJpKgZ6fCTSk+GozNroqT0SgZw53JFoIQ5TaoxIB3+PtVgiUgUc4CGmomWIvKVRJ31WRBYwqE4WeQifppvMvhlNCTa639XbuJwYjCT6wzJxk0uVxyp2N9K06bIjNh+C6cFaiQ2oa71auhgVJDBtJ+XNGNvCPWDRR/NFfy/UztVVFeX5PM0z3VjxAVgKPSTq71vNQSaE0xpmI+DpWCn0ArWtdxxJu9NJZTzHmC92Br9UprsbEzi6YjllrsVypyyEEaZtbsFPAXAZSYcms6FQYvNEhB2iYjILUSptJwl6D6s4kM+FkGwwRvKgXYCmXfVBSTmF+BCJq8Fn86Mtm4jcgs5aqs7ZTLlBlQ6ZhL0WQysQsctX6aL0NX6zzm9HYDBgK4evzn8NDyv6i7psrpk8O1BjHaQLiRj1ZV1NTSROvuF/7YuipYpBY8HO7qXYvCxmQQeYwaHKXsV7PQpokc7z3xA4kupJxAjZPabImNb59KtS0dmFLxOd9hLwlCM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199015)(6486002)(6512007)(6666004)(6506007)(186003)(26005)(478600001)(15650500001)(2906002)(6916009)(1076003)(83380400001)(2616005)(66946007)(41300700001)(66476007)(4326008)(66556008)(8676002)(86362001)(316002)(38100700002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?25+tGvCNYCgIRQNWTFe7Yap/MCWCzYE6fohb910/Le9dL3fcsIz0+FOSsX37?=
 =?us-ascii?Q?QU05h8hC95iInYSwYRDhVcw9dxlunJ5/vVRgKabWL3Jb3ORlPQCeJ3duRPI4?=
 =?us-ascii?Q?M7KtOaQ5DuHyRb02gwG46wP4gPGP1scDbkEE35ITevJA2+Jwrj1A6h2ak+zc?=
 =?us-ascii?Q?ber4jQ8tcBPqE+udmRKrnt6KpcsgyBnROUcDrcIYFgTpxS3mdC0hKuRtXpiB?=
 =?us-ascii?Q?8929CzqXHnY+2R7xx0VQioH9kSdOX86mYPIm2/RHnvGJOnpA7rDgO6si3NjH?=
 =?us-ascii?Q?aUZqNm5ojHw4PTjyGPd5LPglCa688MGPwXDTbtz0540TnnNRFzATYHHs7ROF?=
 =?us-ascii?Q?2BhqKhEzm+njGOfYi0yJT/NDOZ1VfuHCp+HQrEvD3KGe2VjdL1MI8sXa79wO?=
 =?us-ascii?Q?TmNm+zlu+GXaBgK1YuO9NeE9YMI6AlLH+ha/dLHohaaQR4uH9pqj1uDg/bxJ?=
 =?us-ascii?Q?5AWv0UylSilzhsYV2W365Mhxp+3xbAkGey9H8I9P6n3FKb05Smlk1eCviJ9D?=
 =?us-ascii?Q?W/Higngr0/Yox8UdGe7okh1mDakaGsQNWhSBd8+h6AUy5x3d3IfCmwZDStXM?=
 =?us-ascii?Q?AUdmj0yxIhsBq3hRIWUFUxtMLGgrs+IURCgRS1gnybcR5xq1YeEW6iqmRDJi?=
 =?us-ascii?Q?Uunrb9u25KxBRTTmGGrMkDzeDfm/pYrL69fzEc8omd6PWlpQcbuqG6eq7Sz3?=
 =?us-ascii?Q?gn3w+hNl0wu99ljjwm0ir+EqXN2vE37Hroc4j6jUgTA1IsYGeQgtyWK25qzF?=
 =?us-ascii?Q?W2QZl/l1NQNDfsOCApk3IQwUlkLaSqVEKUeFXc0tIs2Lvy4EwYnaItcY3+Wm?=
 =?us-ascii?Q?8nlhhSKGoKfP6LpTO5iHX/J2wAQg91PeRID+kzw8bcsZSZpbbkDKgsH+Gu0U?=
 =?us-ascii?Q?cwgW/kI3DOxbZzXxFYmZzIMEfD4QE5yr4UPabrMFONjkYqbe40/rZ6eWrFQh?=
 =?us-ascii?Q?E8eE+AwP3uzSee+NLViEeURTd/z6kbU+zzqcJbhdFZLI+skmf7itvHAw0opm?=
 =?us-ascii?Q?uavoMgZ0vj7KkGaPkfG78NmgR7Woz3uWDuOFTqcpgBr8n+UmQGkFTTCvOfUC?=
 =?us-ascii?Q?/IQgxDZ8mDDb2f4PRKmDSnNe8e061NdRKdPlUD/keXc/TM+Si3tbNYhA7TLQ?=
 =?us-ascii?Q?4nLHEwqcgnVzwk1QUu9f4+DVfXJFrDHzevg4S3EWQtkJ29PSnnC5TQqbC4ZK?=
 =?us-ascii?Q?rTYL0iYUmiWfbB2QNt9ZZUODMzL1odnrQpI3HeXVIUsFSMc39rhC4BJsz4JW?=
 =?us-ascii?Q?B1l02uG6kKj07FO4DP+Ja1CQUQTMi4zNlLUHCukfoPRpMilMjxcZnOPY7UwS?=
 =?us-ascii?Q?LDHr0B6WAxrw6sYFstRMVJZARD4Otz2gik+KZOEgTRj/bwx8gOw2MTssVIDs?=
 =?us-ascii?Q?ZHTYeCE2VRHDXeTOANqEBpUs/CE5AaDIn2RXeGPSe1cWWQfJgkVCEp+4oCsm?=
 =?us-ascii?Q?wy0REtHUNgTca0qByf7fUH4eNv0FZlvfcpt9wox7HFnFeNjT9lJ+ratcbbX6?=
 =?us-ascii?Q?y9+PfACazNG1YJa1e8VolIU+NVK+Z+2nHcwbUSjCGrocomxjd8N9H77vfqEC?=
 =?us-ascii?Q?gzh1M2a2gRGLx8nomcIO1LUsPFLLz4aA8nDMd1yfUnK8K64rlrSV9M55imPn?=
 =?us-ascii?Q?1Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb1db02e-48d8-4d0b-1498-08dab71b8de7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:30:20.1420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YyF+3vosLe4ytzGngDYkuUGLjR12UIpoN8j54YJ0Lcp1WKyJDysZlV4sHdWovFZ3A0wMOvHhXCfMaHKNyxddtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6151
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-GUID: GsSET6VQB4vYkMpMjZxlfeU28guylw5c
X-Proofpoint-ORIG-GUID: GsSET6VQB4vYkMpMjZxlfeU28guylw5c
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

commit 854f82b1f6039a418b7d1407513f8640e05fd73f upstream.

AIL removal of the quotaoff start intent and free of both intents is
hardcoded to the ->iop_committed() handler of the end intent. Factor
out the start intent handling code so it can be used in a future
patch to properly handle quotaoff errors. Use xfs_trans_ail_remove()
instead of the _delete() variant to acquire the AIL lock and also
handle cases where an intent might not reside in the AIL at the
time of a failure.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_dquot_item.c | 29 ++++++++++++++++++++---------
 fs/xfs/xfs_dquot_item.h |  1 +
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index d60647d7197b..2b816e9b4465 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -307,18 +307,10 @@ xfs_qm_qoffend_logitem_committed(
 {
 	struct xfs_qoff_logitem	*qfe = QOFF_ITEM(lip);
 	struct xfs_qoff_logitem	*qfs = qfe->qql_start_lip;
-	struct xfs_ail		*ailp = qfs->qql_item.li_ailp;
 
-	/*
-	 * Delete the qoff-start logitem from the AIL.
-	 * xfs_trans_ail_delete() drops the AIL lock.
-	 */
-	spin_lock(&ailp->ail_lock);
-	xfs_trans_ail_delete(ailp, &qfs->qql_item, SHUTDOWN_LOG_IO_ERROR);
+	xfs_qm_qoff_logitem_relse(qfs);
 
-	kmem_free(qfs->qql_item.li_lv_shadow);
 	kmem_free(lip->li_lv_shadow);
-	kmem_free(qfs);
 	kmem_free(qfe);
 	return (xfs_lsn_t)-1;
 }
@@ -336,6 +328,25 @@ static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
 	.iop_push	= xfs_qm_qoff_logitem_push,
 };
 
+/*
+ * Delete the quotaoff intent from the AIL and free it. On success,
+ * this should only be called for the start item. It can be used for
+ * either on shutdown or abort.
+ */
+void
+xfs_qm_qoff_logitem_relse(
+	struct xfs_qoff_logitem	*qoff)
+{
+	struct xfs_log_item	*lip = &qoff->qql_item;
+
+	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags) ||
+	       test_bit(XFS_LI_ABORTED, &lip->li_flags) ||
+	       XFS_FORCED_SHUTDOWN(lip->li_mountp));
+	xfs_trans_ail_remove(lip, SHUTDOWN_LOG_IO_ERROR);
+	kmem_free(lip->li_lv_shadow);
+	kmem_free(qoff);
+}
+
 /*
  * Allocate and initialize an quotaoff item of the correct quota type(s).
  */
diff --git a/fs/xfs/xfs_dquot_item.h b/fs/xfs/xfs_dquot_item.h
index 3bb19e556ade..2b86a43d7ce2 100644
--- a/fs/xfs/xfs_dquot_item.h
+++ b/fs/xfs/xfs_dquot_item.h
@@ -28,6 +28,7 @@ void xfs_qm_dquot_logitem_init(struct xfs_dquot *dqp);
 struct xfs_qoff_logitem	*xfs_qm_qoff_logitem_init(struct xfs_mount *mp,
 		struct xfs_qoff_logitem *start,
 		uint flags);
+void xfs_qm_qoff_logitem_relse(struct xfs_qoff_logitem *);
 struct xfs_qoff_logitem	*xfs_trans_get_qoff_item(struct xfs_trans *tp,
 		struct xfs_qoff_logitem *startqoff,
 		uint flags);
-- 
2.35.1

