Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881A060DB38
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 08:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233139AbiJZGaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 02:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbiJZGae (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 02:30:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7673E57E0E;
        Tue, 25 Oct 2022 23:30:33 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nXHg030454;
        Wed, 26 Oct 2022 06:30:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=7wwnJzQFEcsKNkkHPHnHyIljg6RSg1A5SCeFInZsnOM=;
 b=l+1w6MjUxB2MNhXMOVZCS/SdNsHpAzWk6yQ4n5t/WPk7aJNgrxOrxcGuzjY6WgzInEdI
 7eEd2mHjAbRHX8DgGdqkejkioq2Ajf8qGof16CdgZYeZZ69tLuGnjTVDipK92S10EU2I
 vBOLDgsK+wp29ME6vviDVafQA6ZOaJ43sRsFsStAyX8K6Bc26eP3rniwAAEdxgaFuVYW
 fi3z+Jvo4XYoo+JfnZqx2zl3s64UL192777C4hCLILMtuUEEjL4vXxZtDzB2e5kfM1UU
 OP9bfpVE9nTHVH4WG8Dwnm1WivLpGlqtwqYUekUX1GMhKH/50Phacnahq00qm+flfZH/ FA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741x249-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:28 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q38pKK021987;
        Wed, 26 Oct 2022 06:30:27 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6ybprsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 06:30:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbRmTWe4z6rTlqa97Ysc1ppHfXdVthsulyyU/HXjZvQrpxJDCLMQ3TR2NZtLypwlxd+MxJiVxf1cFWSwVj8lrmxHRnOSLvjDfXvNQ62eXm8XUiQZ0iqRDOH59ip4Eudw3zxsPpFycM58Eai08dyrFhSixBqIXd6JcTspCdOgrex9UtDnUMb19zeyNlwoWS55QaCo7Uu6Z/TR5+v+32BQQUyyZuSfCTNIwH8s2kHzq4E+3rkz1q/S9cYl8ZvNZR00cBLcINAyXfWVbrNCL3i0vulPwdZFIobiHVAj87bdu6Gwx0XFGJG02LA37B0vJIYc/mtCJukPCaYjewXA/e7mjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7wwnJzQFEcsKNkkHPHnHyIljg6RSg1A5SCeFInZsnOM=;
 b=PhLX6FqeWIEEwUqSJJOCZC9evSNt2ubSo94yepHbLDmrEJWqQV15ZowSrDmKvXtPPcMU5qtddAHwiquqQ1H43tgSDbZBTfBxlqSbqbJ6mB9CjTO42+c+QxCzvKbOErB7+LeAhpIvKLhNXhKW25ms8ScrjQ7B8hF7BXtD2BwXNQLljgU9yT4UscTN3BLW8knRaGCDOzDCJ4fGXAIU+O7yS6/XuxAHaNEqg8ou9+Cr/zJgb0buJUN4O7k7t/0seLQPQYq0dGYZR+5Xy0oh9Wcj+7ZDyazHM0Y5cavQfXoQCis+f5ayctCQwyYYUdhg3V9C3rnUoH3IMFv06Zjgw1spnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wwnJzQFEcsKNkkHPHnHyIljg6RSg1A5SCeFInZsnOM=;
 b=LFTxBLP8l2hJPNUXTrVcSY+cOcTL7VIe01domwxseFWJgSDN2aL7Sr/Bll2GPHP+VR6eNemNG/5mkx09NLrwt6CJwkr9HgNXHXVomvGYOxKnDgaBJDxyATO+8Q2hZiO+TlQJ4Y0cZjbcaTuQfon0dvwietuXpV9jWh8ywuvW2rU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS0PR10MB6151.namprd10.prod.outlook.com (2603:10b6:8:c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Wed, 26 Oct
 2022 06:30:25 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::81a2:47b1:9cbf:e9c%6]) with mapi id 15.20.5723.033; Wed, 26 Oct 2022
 06:30:25 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 15/26] xfs: fix unmount hang and memory leak on shutdown during quotaoff
Date:   Wed, 26 Oct 2022 11:58:32 +0530
Message-Id: <20221026062843.927600-16-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221026062843.927600-1-chandan.babu@oracle.com>
References: <20221026062843.927600-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0086.jpnprd01.prod.outlook.com
 (2603:1096:405:3::26) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS0PR10MB6151:EE_
X-MS-Office365-Filtering-Correlation-Id: 5de1b5e6-32d8-4735-d3d1-08dab71b914f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p96xdfxia8l2SfLWTBxoUMchmRIYnsTJA7xp1KKobEemqE1XTYXw/GmPFMORFYuCYA0bXDCL8hMW1FYtG+IBHsF+GiggqoiX0zG/u7RI0xQmTP0ZGaCw9cPTkOsEQ7NcNRQ9qofWXHqrAu4FZWFpWblMq3e3eVJjT3FaIEU2+nXtnZOP+ZDbA+6usY7TRJxENS/b5KB4M3GGud+SVbVDb75Cnq37Oy8e2HPwamZzNnc8/OErWbpDCR780L8k/ESSIrtHJDaNPKvmjRL8eDrIVOqJHOM8bCjUeYy1ARdlWuISMesX8DOYnU6YQ1XuQoEMZ4k2oC2WPhTYSu8LNRNNg2v3gZxGRxe3WlXqZq7kJzt5ftebDpPS+eNAs72Hby7Fqq6WbySzWMFcwHBQdAGyLp3EyKScrSPgB1EHUgRZxX/GE5R5GWYloSuNu+EIR6fBAv1BzvokFK+uoUGI6YOKoqRmAhUgTQDz5Ls+cuA1hpapNvyx4A3nrIyRJI+z0G4ZbA67EMHqak6MHmTOaZ2hHIZY8/kSAOUI94pI+3wl9WmAEUAWAriQ9+aOo0JSM8u9DaVZ37OpeFXyICuqbi4b3jp4IcD6LZkJIVHR/h/lIAs80WJwxpInpLnRpGWwKFWCUv2kMnG56AHmsKI4xN5TmOcPDbLa65v44udNquekDLFUq97ObqI42ncurLlTrDOw+lyL8Wy979lKTr29KgcAVXQTcANBaMIk841K8yJK3aeainNV3O0mijSXp7fOJQUM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199015)(6486002)(6512007)(6666004)(6506007)(186003)(26005)(478600001)(15650500001)(2906002)(6916009)(1076003)(83380400001)(2616005)(66946007)(41300700001)(66476007)(4326008)(66556008)(8676002)(86362001)(316002)(38100700002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ECbN4pPhYmVGEwRc7PkjsSBPsCjemVLcLscbyoT0hDSNxnOymvfmIxZWzQjJ?=
 =?us-ascii?Q?1O7shMbKLOtpY0zo+5f9c8ZGUL7Hdkf1DoiBI7+fWddH3s6oIyKS4j3PQCJt?=
 =?us-ascii?Q?w4Hp7jBXeDd4uBuIZqn3fI+7m+Bw1kFwhLQxGoJjsJQzy3Ab97vZ+PQ5oq7p?=
 =?us-ascii?Q?nnWxrMq5TQ1oSjsuYvRHNqSkT8VjfeK0hnSdLa8s8Nmj17ZBtzVp4N3uiXAy?=
 =?us-ascii?Q?0ZlGcJYRjCYOXzpW+B4Muj6CgXVOZh4rAQFnjtXKHd2jMFWbNxVa6R4O9GWp?=
 =?us-ascii?Q?L0r8j+oB0ZosJ7tKCLK4nH3c+OU6BBfurfftfa/5PdXvNkvCgOi9aGiRdpsV?=
 =?us-ascii?Q?csytGYzWll/vLNsqGCUdb+OvO7Jp5PeXDepGGjQtf9Sx2x5rz8GAr/hGpQ+D?=
 =?us-ascii?Q?FVRfQHpzLUStgtad0bwQ3jVRlZ8O3tdeELrO2YA4RbvUs4xD8jJ+8ucNGm7d?=
 =?us-ascii?Q?wItU1CMVzjhPUEQUxRQlQE3fG854Sk799F0+KPjupyt9oWrddDQWFmqGmoAE?=
 =?us-ascii?Q?2dqVjKudNBvAQRJ6r7j2sU4iOelhlwmGoWaM0fGNqLFDwkDfC8OKy21hB0bW?=
 =?us-ascii?Q?+riHkWaFGstrHSettKLiHfDUqAGMAi27UKnGwWUUWsbiV5Oh94fyxWT5aOyv?=
 =?us-ascii?Q?pKlWv4OGyPC5TNEVy568hQ2TIzHxluIFjp09Q1RebTZk75Nq64Sqfs26T9Bd?=
 =?us-ascii?Q?xZdSjeKUjqbr48l9HP8KdP8e0Fa5KpnibcrxzvTwntkHnZmq4w6pKHApzJSk?=
 =?us-ascii?Q?tzP3yv7bLgXnm9gfsc9F1zxIpqZ/fbwVQohMQKylxp/2N3n+K24FqOvdbfTJ?=
 =?us-ascii?Q?2KYvH0QQA7BkpngvT/r/EFt8TgVCw3P5hJsWI+abqKlJmXvAP50Gst0sxpBU?=
 =?us-ascii?Q?QO7IXR2RJRr3XhEmG1eQ4ok6GsPsQCacDsN1LqdtiFUim6bt+OE+3TcgeZpN?=
 =?us-ascii?Q?9u3yAX75E5uWNTjRzpwK624+zLKPYNI6Mnn3kDWqWqR9kxHPG2gDne+T/RXJ?=
 =?us-ascii?Q?ftEzMP7faLeoFIYhiYwtAw+OUd1KYAR3dx7W/9azDoRXpoWR0xMk6xFNmLxh?=
 =?us-ascii?Q?16T7ahrpJIUjq4RhGdSqCqTApGDE1BS+ufzGmjzEFuxVp3i2mm02Tgc15IPH?=
 =?us-ascii?Q?zGrN2+ghb0cGYrD4btk4yd/kRXQQiBebiaKAqx8dwNoT6KRhnjUlABz3qwbi?=
 =?us-ascii?Q?Je2RKnKNcsb25Uzy7sRvl5/ZgeHimQWCZI/53syagn8dFUT3zuXkD8/TiU4A?=
 =?us-ascii?Q?F4luqepN45GtXNxC7vCkVIX7ebaFg0BA2+8yQY/3UyvRwmQBHSXvXk2PzyA2?=
 =?us-ascii?Q?TmR6yuMY60m50ph5CPZiwlRiCOhUWjY/u1+0Wu5VT4ytg9ruuS9HNeo3Wrav?=
 =?us-ascii?Q?JIHDdc+q3mA9Jnc4Pjv5rBoG/Cy6Iz9ts4pAVPwvqa78TNm7+RKUCoXyp0ky?=
 =?us-ascii?Q?zc4BtcUZ5LKmERbe12usA2Wi6n8KnZ36DxNu7tveyU0kUdJ8ktHW/6n9H8Lt?=
 =?us-ascii?Q?AIp5ObzJTWmvpOhI70LU6G3N56EVyJGoHSy2Y9iJO1Hm9Qiiorp4x2BOwras?=
 =?us-ascii?Q?lut2gsVEACKKamsEwUXmxwjDtfWMWoLc4odh1Qgc7nmeaLWXPHXIH++yZrYz?=
 =?us-ascii?Q?Vw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de1b5e6-32d8-4735-d3d1-08dab71b914f
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 06:30:25.7212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qJzh/5JHCnpGxV3HcqYAxVBuOi6O12IW8UD+diKkRQQ2iURk5pRcFOyT9WhMWxxMpFxJMuVsSe1Bz90EavN+Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6151
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_02,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210260036
X-Proofpoint-GUID: XZK4H8RciGLAzO2yw2EIQn8RWsa40nTW
X-Proofpoint-ORIG-GUID: XZK4H8RciGLAzO2yw2EIQn8RWsa40nTW
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

commit 8a62714313391b9b2297d67c341b35edbf46c279 upstream.

AIL removal of the quotaoff start intent and free of both quotaoff
intents is currently limited to the ->iop_committed() handler of the
end intent. This executes when the end intent is committed to the
on-disk log and marks the completion of the operation. The problem
with this is it assumes the success of the operation. If a shutdown
or other error occurs during the quotaoff, it's possible for the
quotaoff task to exit without removing the start intent from the
AIL. This results in an unmount hang as the AIL cannot be emptied.
Further, no other codepath frees the intents and so this is also a
memory leak vector.

First, update the high level quotaoff error path to directly remove
and free the quotaoff start intent if it still exists in the AIL at
the time of the error. Next, update both of the start and end
quotaoff intents with an ->iop_release() callback to properly handle
transaction abort.

This means that If the quotaoff start transaction aborts, it frees
the start intent in the transaction commit path. If the filesystem
shuts down before the end transaction allocates, the quotaoff
sequence removes and frees the start intent. If the end transaction
aborts, it removes the start intent and frees both. This ensures
that a shutdown does not result in a hung unmount and that memory is
not leaked regardless of when a quotaoff error occurs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_dquot_item.c  | 15 +++++++++++++++
 fs/xfs/xfs_qm_syscalls.c | 13 +++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 2b816e9b4465..cf65e2e43c6e 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -315,17 +315,32 @@ xfs_qm_qoffend_logitem_committed(
 	return (xfs_lsn_t)-1;
 }
 
+STATIC void
+xfs_qm_qoff_logitem_release(
+	struct xfs_log_item	*lip)
+{
+	struct xfs_qoff_logitem	*qoff = QOFF_ITEM(lip);
+
+	if (test_bit(XFS_LI_ABORTED, &lip->li_flags)) {
+		if (qoff->qql_start_lip)
+			xfs_qm_qoff_logitem_relse(qoff->qql_start_lip);
+		xfs_qm_qoff_logitem_relse(qoff);
+	}
+}
+
 static const struct xfs_item_ops xfs_qm_qoffend_logitem_ops = {
 	.iop_size	= xfs_qm_qoff_logitem_size,
 	.iop_format	= xfs_qm_qoff_logitem_format,
 	.iop_committed	= xfs_qm_qoffend_logitem_committed,
 	.iop_push	= xfs_qm_qoff_logitem_push,
+	.iop_release	= xfs_qm_qoff_logitem_release,
 };
 
 static const struct xfs_item_ops xfs_qm_qoff_logitem_ops = {
 	.iop_size	= xfs_qm_qoff_logitem_size,
 	.iop_format	= xfs_qm_qoff_logitem_format,
 	.iop_push	= xfs_qm_qoff_logitem_push,
+	.iop_release	= xfs_qm_qoff_logitem_release,
 };
 
 /*
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 1ea82764bf89..5d5ac65aa1cc 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -29,8 +29,6 @@ xfs_qm_log_quotaoff(
 	int			error;
 	struct xfs_qoff_logitem	*qoffi;
 
-	*qoffstartp = NULL;
-
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
 	if (error)
 		goto out;
@@ -62,7 +60,7 @@ xfs_qm_log_quotaoff(
 STATIC int
 xfs_qm_log_quotaoff_end(
 	struct xfs_mount	*mp,
-	struct xfs_qoff_logitem	*startqoff,
+	struct xfs_qoff_logitem	**startqoff,
 	uint			flags)
 {
 	struct xfs_trans	*tp;
@@ -73,9 +71,10 @@ xfs_qm_log_quotaoff_end(
 	if (error)
 		return error;
 
-	qoffi = xfs_trans_get_qoff_item(tp, startqoff,
+	qoffi = xfs_trans_get_qoff_item(tp, *startqoff,
 					flags & XFS_ALL_QUOTA_ACCT);
 	xfs_trans_log_quotaoff_item(tp, qoffi);
+	*startqoff = NULL;
 
 	/*
 	 * We have to make sure that the transaction is secure on disk before we
@@ -103,7 +102,7 @@ xfs_qm_scall_quotaoff(
 	uint			dqtype;
 	int			error;
 	uint			inactivate_flags;
-	struct xfs_qoff_logitem	*qoffstart;
+	struct xfs_qoff_logitem	*qoffstart = NULL;
 
 	/*
 	 * No file system can have quotas enabled on disk but not in core.
@@ -228,7 +227,7 @@ xfs_qm_scall_quotaoff(
 	 * So, we have QUOTAOFF start and end logitems; the start
 	 * logitem won't get overwritten until the end logitem appears...
 	 */
-	error = xfs_qm_log_quotaoff_end(mp, qoffstart, flags);
+	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
 	if (error) {
 		/* We're screwed now. Shutdown is the only option. */
 		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
@@ -261,6 +260,8 @@ xfs_qm_scall_quotaoff(
 	}
 
 out_unlock:
+	if (error && qoffstart)
+		xfs_qm_qoff_logitem_relse(qoffstart);
 	mutex_unlock(&q->qi_quotaofflock);
 	return error;
 }
-- 
2.35.1

