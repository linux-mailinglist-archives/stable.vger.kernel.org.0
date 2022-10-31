Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6BC612F89
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 05:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiJaEyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 00:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJaEyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 00:54:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6A6DCE;
        Sun, 30 Oct 2022 21:54:21 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29V3aIlX030854;
        Mon, 31 Oct 2022 04:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=XgDlp0C1fY5IbVrOA0fHlKiLnY00lISVAWUQl1iKJCQ=;
 b=LemksGvuPbpuzt2tvYvRlBdLMqTTxtETb7SPOZ+uZnGo/Zx88I6yEdiiTfs+5PfP8MJU
 1JZn6sHhBIRjlDNBD5ypveyCN1pIpEVlKd0a5H1RxQe6LlbowdMRsbkDJJHRY3qsFg+U
 knjwVlLbzCbN7lnbfVgT9Rn4Z8swuUTYnaqlpxrncdqwjV32uAXeDLoBTA+mvd2ahwlm
 YkU2T3jaFQ9CkqOhWw/ogfnna0D9DitdlYw+adZlw+J0RK9a3J54v7cOyk4+hDDbIoA8
 w7xjV+6+8hevV7xWDusS5nH5I5JPOLEuOOwidVSGAQ5Bil02NfJZN7LsRfa09/19/3UK Xw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgtkd2dqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Oct 2022 04:54:16 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29V2Arrb023896;
        Mon, 31 Oct 2022 04:54:15 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm2vapa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Oct 2022 04:54:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZvYbZxpN3aEwsUJtUJUtGwsVf364JDYj3+FRgLOuckYqH6K15SHTYAMm5v2PQzmyJY4edWpo+wctQpnUlAKxpJAFuoB1vgdmeQE4PJeXgwx1l7Wv5k1Ziu/aivwwCo99dAVH0ctkzgXLSRQBG4Hm4vlAaI3iekh8uNB1/90N+0yeUKCJU32iHt4NwfHjDFimxw7WBTuHYpcQO7Vykwl31lKC09B6C7AFXjklQx6ct4NmIq5BaGMabaAB5grzUH7nChVbNQVoHurooKRaBsuabMLVAXyr8uCcDJKpxTrNd7zfbXDZDRf5lPoyVbjV3WpjG0Bnm33NKxlANT6FQXWDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XgDlp0C1fY5IbVrOA0fHlKiLnY00lISVAWUQl1iKJCQ=;
 b=Fe1RiIzxWGGChonfCTs7du01HQNIbmK5caCedZVCYX7YV/tto3lSlSfBHFzqbbeD0PC/7KvtcOKTW8QmjEfRJz1ld4XDCqfCz1avYa01q+O0reyOy7cpf5Tskl1fzJUWxWKusA+C3SDaf7inNBDjZNXToLaeeWH7NMd4b31ZIQ3d3SypiSqNb6BY1XIVA2FCWe2fe4ZEWtCmAQhW2ScvbUElAXARY05tn5WBciKZUlCY4Gkx8h0megRR7ZkxG32rxaDPCuJUg1JVHrgTtg2NQQGOPYkWnap/mj3r988pF5F8VbQKJac5Nq/RJqyw/HoeNmZurF8G7E7DzRevhYtVdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XgDlp0C1fY5IbVrOA0fHlKiLnY00lISVAWUQl1iKJCQ=;
 b=IYl0+zMj3jWUEqQ5AFV4sp2qSiGnwtzskHbihMuLY9bnUHyp3kZNh5miMm/x3y/1vKuE2iL0/G+Bgqx2p+1sJ9Xrbznf6JW6lpe7f8N3cRmJqGEj0ywc5hc/zRZo/3GpmfH/qUWdvphNwiNtuBhhBjuPbYWCzBeYP8NiSsjolAs=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB5976.namprd10.prod.outlook.com (2603:10b6:8:9c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.19; Mon, 31 Oct 2022 04:54:13 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::4b19:b0f9:b1c4:c8b1%3]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 04:54:13 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 2/3] xfs: clear XFS_DQ_FREEING if we can't lock the dquot buffer to flush
Date:   Mon, 31 Oct 2022 10:23:53 +0530
Message-Id: <20221031045354.183020-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221031045354.183020-1-chandan.babu@oracle.com>
References: <20221031045354.183020-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0005.jpnprd01.prod.outlook.com (2603:1096:405::17)
 To SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB5976:EE_
X-MS-Office365-Filtering-Correlation-Id: a6b5bf9d-b1bb-48b1-9453-08dabafbf4b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x4KIPFoNjsNHtQhDO9nB5BpbAYCG+RMsQDyLk8oMj/YbcImMdPiA4iVUHfEnOAu05UPS599BSNZqsdRtlvNiAKAe+vKJsLTY/nwpbrZtbtKeC+nMScfIVrCPUJWk8lo/lAw5+UNM89LxYQ+iyNY+b+4oNfxXf7Ygp0SkCJLNxXY0jyUHv0WMRCWXd0I09h9EadwQYHjE5m2KUQENr7FEnT4quCWAeF3I+X2sGI7ftpWCxZeeRJbxCE6AKbRy9AZacMfZ6IcIKRiAEJGP/fxiGjmV5Rda+KKORwbA8QozhD3O0jW1KafkpE6SPGda6DaPeu5gpme0GWg0pAQr9vjXHqhgrp0Qpp9skF4ZE4hQjGRYmNb6Xh1ew9cluEfqIPz3rS5Jqko0e7BxjHnYssjTQHSgLg8CCoPg2e0S1tdg4nTqw1zohqAyJ98DfZachKfHe9w3HHHWse9voPtMO/vrWbRjyPtw2BjwdrKFpYpvXlzjqRfb0nbw5oYk9LeE6uhqNdJwPNDLFH1o/yaApgvawUvqGzxV+HciUb1ZanUOblt+COY6TME72SS9/nDBwZi53+/KLioRS0LqFAVcrC8EfKUpNQr07eb1Ul3zOPAYN8SOj+xSXw163gRUrk62fuhhSHRk2HBaaK76hcZDQeNt2vu46xbNqCJ2nYw+GgXQINHm7Ld1+VCAMjr8SmtSW2tXWnZSFK0ZfhgXLNA3D0wDMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(396003)(346002)(39860400002)(451199015)(83380400001)(86362001)(6666004)(6486002)(2906002)(38100700002)(36756003)(6512007)(26005)(1076003)(2616005)(186003)(66946007)(316002)(66476007)(66556008)(8676002)(4326008)(478600001)(6506007)(41300700001)(5660300002)(6916009)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b6fBDLPonFnyg72ov9gmClitQcliTt4WWg/yj9MhRGVvGh0Gt1ifCbwpWesw?=
 =?us-ascii?Q?vWUBAkbJZXl9TL4aT9c8rCuZ8WkVTg3nJkhD2WJtxjaMRN54Lv+qkq6Fs1uk?=
 =?us-ascii?Q?qWuHrxNtnBN0Q2bmKNOKzR3gPzxaoanwcKsySaWEdPz8SkbGFKbrd6Is6ma2?=
 =?us-ascii?Q?+L8f3UQWSKC3yLURoGStspLHOn42UIvqOL/FInwR3GIkXYA38H1TRaHvwJvi?=
 =?us-ascii?Q?eYf8MXUVLYZr4xVirZfmlZoFFo8JiS3n1zFpGEzT0NIrj0OBloHrfzZ1dqWN?=
 =?us-ascii?Q?HID4kQ9LI7ILQThMv/5sLrnHJ798Eq4EmjCFsBqM2ZNr1tyR7/r8u4SLxp06?=
 =?us-ascii?Q?I6FmCFC6KM9tWT8m1as7JPtN7ZnoBZ53mVFA0tVwxn7YRwdMFW4PdO5iPCCp?=
 =?us-ascii?Q?oxIaFAmeKDevoBsPBus4JsUJMj/WJgf2c565wNFqGrJIxZbTw95sUrTRA1pb?=
 =?us-ascii?Q?KtINHhK7wVj0WkqCFg/VxO8z2peScLOwNupRJxDACvipKCJFxf2Zw1NUmqNs?=
 =?us-ascii?Q?o2YF6Ru7J+Ht4BQP6LeuztXVqHLeq7os0tfKivKB22/gxvk1ymeGglU0TLIq?=
 =?us-ascii?Q?l2MEgKW1ZfQg5O4gwriy0O4Gv6VwrUOUr0kAr3JbrJFhsC4jaAZX+n3tuq+2?=
 =?us-ascii?Q?FAPKzHgapqOMbQ2QjQRjA/hCwqHF9QbubTHAUa/+n3thvXjiKJSLvo/Gnk2Z?=
 =?us-ascii?Q?tg8dan+NjeRzSmavh5ZiEy2j7YSvOK4uzpCstfF9ixLRETBYlKGpDsKdwNGF?=
 =?us-ascii?Q?ewT0p17tFWFi/UyBI+jkufe8wxQsrryrApx3LMnsdqlyJnJDijXESNXFfmCK?=
 =?us-ascii?Q?lW6kPl3B/fcGXTGJuEOBHJ0/6BZOV4wgXdgow32aiLaT+nzsjzgJY5Osx7+k?=
 =?us-ascii?Q?zWugWPpla95aPEBWZgPLb7YPMIE1uQXblizo+Lb4J/ecFjgBlKQbrWONVrJn?=
 =?us-ascii?Q?aWsXwFmBMV5IBnbVDENMipcJPbhaAc9VNfQ7lZ7lHdtfDaQLAUgd3jiNgCeA?=
 =?us-ascii?Q?9i2BbzeBUcikNWLU3MR+ASZ+vi1VSrhtrN8xzOW1ngeR0dxsLrkGqYph2NRM?=
 =?us-ascii?Q?0el0KUUsWGXS8Ga37ouehckva4X1zS1+WwVpCphq9CTYF6PvfUvHTVvLKPDH?=
 =?us-ascii?Q?eYvpMujTV+AdNe/22Vl9asNHK9HghjkAv9wy0j9VRZJXrosy5ZsCoZKy+3ml?=
 =?us-ascii?Q?wjl7D54GbtLs9DfYr+fs1mBQLGUA6ykaCkABV6IZf+BrpUt/J/B4ElZbOgtd?=
 =?us-ascii?Q?I6wYorIov3iqn5LHmFOj7fSgsNyCYb5ivOYP2rvQ2s63nJhczUK61k6YnYPy?=
 =?us-ascii?Q?hcUaV/LpEheiFaOilK985wiOg1ruB/SMNDQPWqB2yUgHMqc3E7Poqsuw66rv?=
 =?us-ascii?Q?ny9u4dJYJg9tivPx7lZ8odtRzLwtniVspOvQvyYKAmmUel1gRxfTdwkuIMWQ?=
 =?us-ascii?Q?N6X29AsUAUftH65u472aACjvpUHZpyvX2FI/nNnew8Mu7A+z5TMd2001YUwE?=
 =?us-ascii?Q?Fxb8lNAnxddXFn7XnbJtEXxWV/ZCfswYVrvjvj7nfIfEXpE7xEHUCc7AyNWH?=
 =?us-ascii?Q?OKAfmNTR9pukVfK8tu71/DqXwzg5vdtvR8TusSNzb3zjqCKubAdfukE/VF+l?=
 =?us-ascii?Q?6w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6b5bf9d-b1bb-48b1-9453-08dabafbf4b9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 04:54:13.3749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d5SbB2TxhkFP9s//bxsJlWqkDo4oW0W9hG69tDrvzLOZKmWAF6UTMSe0mfEBqjfhFfBYIutNGk58UANqYd8wIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5976
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_02,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210310031
X-Proofpoint-ORIG-GUID: 0pnbIQZdVytAGSbcpg9xQVs9eUlaC8FR
X-Proofpoint-GUID: 0pnbIQZdVytAGSbcpg9xQVs9eUlaC8FR
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

commit c97738a960a86081a147e7d436138e6481757445 upstream.

In commit 8d3d7e2b35ea, we changed xfs_qm_dqpurge to bail out if we
can't lock the dquot buf to flush the dquot.  This prevents the AIL from
blocking on the dquot, but it also forgets to clear the FREEING flag on
its way out.  A subsequent purge attempt will see the FREEING flag is
set and bail out, which leads to dqpurge_all failing to purge all the
dquots.

(copy-pasting from Dave Chinner's identical patch)

This was found by inspection after having xfs/305 hang 1 in ~50
iterations in a quotaoff operation:

[ 8872.301115] xfs_quota       D13888 92262  91813 0x00004002
[ 8872.302538] Call Trace:
[ 8872.303193]  __schedule+0x2d2/0x780
[ 8872.304108]  ? do_raw_spin_unlock+0x57/0xd0
[ 8872.305198]  schedule+0x6e/0xe0
[ 8872.306021]  schedule_timeout+0x14d/0x300
[ 8872.307060]  ? __next_timer_interrupt+0xe0/0xe0
[ 8872.308231]  ? xfs_qm_dqusage_adjust+0x200/0x200
[ 8872.309422]  schedule_timeout_uninterruptible+0x2a/0x30
[ 8872.310759]  xfs_qm_dquot_walk.isra.0+0x15a/0x1b0
[ 8872.311971]  xfs_qm_dqpurge_all+0x7f/0x90
[ 8872.313022]  xfs_qm_scall_quotaoff+0x18d/0x2b0
[ 8872.314163]  xfs_quota_disable+0x3a/0x60
[ 8872.315179]  kernel_quotactl+0x7e2/0x8d0
[ 8872.316196]  ? __do_sys_newstat+0x51/0x80
[ 8872.317238]  __x64_sys_quotactl+0x1e/0x30
[ 8872.318266]  do_syscall_64+0x46/0x90
[ 8872.319193]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 8872.320490] RIP: 0033:0x7f46b5490f2a
[ 8872.321414] Code: Bad RIP value.

Returning -EAGAIN from xfs_qm_dqpurge() without clearing the
XFS_DQ_FREEING flag means the xfs_qm_dqpurge_all() code can never
free the dquot, and we loop forever waiting for the XFS_DQ_FREEING
flag to go away on the dquot that leaked it via -EAGAIN.

Fixes: 8d3d7e2b35ea ("xfs: trylock underlying buffer on dquot flush")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_qm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ef2faee96909..6b23ebd3f54f 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -148,6 +148,7 @@ xfs_qm_dqpurge(
 			error = xfs_bwrite(bp);
 			xfs_buf_relse(bp);
 		} else if (error == -EAGAIN) {
+			dqp->dq_flags &= ~XFS_DQ_FREEING;
 			goto out_unlock;
 		}
 		xfs_dqflock(dqp);
-- 
2.35.1

