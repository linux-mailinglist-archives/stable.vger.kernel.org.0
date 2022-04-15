Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E227502D9C
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 18:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355786AbiDOQRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 12:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355837AbiDOQRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 12:17:48 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA2AB2A73D
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:15:19 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FFQIe3014393
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:15:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=Ss9Z9wnqaJz4zS/Qna87oCWMAvPq/5WbHpZd1yAVUYU=;
 b=VguAxFA8aajGpaUbfoS9S4bWOWOvwhAxvbHL435HE1ITWQA6c9Wa78Vd5jLz15zUc8oO
 k1L6ecdp+EksJL76QCLUFfoCshDSqlS+pi56VnLQPCeDhztTop0lDPptzA2m9zeDKurM
 bnokiSh4UYICmyMoUjKS5iiJxMJOd2IYLXcFB/hsN3bs7OyErvQmqKBnYAzisofGvPMl
 FChftgF7baQ+iINBmqcWMeLx0R88l7PbbvHXIoejWu2NzuqK5ogR5x4SuCDcHNWGItU6
 EvVhmrJ6Yvm7NHbuSoil0W91MejhSjuVuq/EVcg9L+WcXkD675DApG9E/jloqk0HxScT +Q== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb9nfvsk3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:14:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=es5N84VuA5ugGhm/Yx7UqVfeYKGEUBnjMly/bQOo0Sh6A9ii4oS929aBfxenPnAZB4v307JVvjk2JBlnOFWIA31/HkT7UMJjlrj3AO2hu/GAKflKhgcODjAV+bIQ1vWYOoWe/oHhJvw2zeZhk2/UauLkuELeQgKVAHpyz69CJ2PJ6tahF4+o4/FP5v6YDwXjyedtiLW/zvaWUauM05G5pphwIOJho0M5667qrqP1XfBK8QiuAhZtuMxJLwbnxyfqF7kLCIJu0XOxvipHfjO9OP/ypolvVca4ysw5ZVFIqRNxxDR7OO4UX7xUbGJwheovu8Aoa+6rs6lbrnBeQ2cmDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ss9Z9wnqaJz4zS/Qna87oCWMAvPq/5WbHpZd1yAVUYU=;
 b=ClWmpXLeA1sN7XW7ho8p4ekB5uvyNjJnnX80H8wpLOqIZLgFdcnwvni+WKB7MSl4R3VXS5giWWURfe7NvM+/aRfzeNwcFZck9ZvYBm7/vX4L43n2N9lWiOTh7Ca7kIZ9MsayAK2szhEhHRQu9AGLqZaq5b+yirjs/TXL/kMisVFsGDi61vE62hmecUgo5lfBlcoz3NaUVJBF+bc5mGEBf18cm7ugAh+E/oDNl024i3WxROt3dcP9h5GlNokuQiYAsgKW90ohvHisCyhkIdnrGiYMiD9NW/XyvDCGN/tZ3E0VqFo0iI92IoNMQnrjp8K/6psYpnDB3sSzLgUmdg2cHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3626.namprd11.prod.outlook.com (2603:10b6:5:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 16:14:41 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 16:14:41 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15 5/8] ax25: fix UAF bug in ax25_send_control()
Date:   Fri, 15 Apr 2022 19:14:19 +0300
Message-Id: <20220415161422.1016735-6-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415161422.1016735-1-ovidiu.panait@windriver.com>
References: <20220415161422.1016735-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0009.eurprd02.prod.outlook.com
 (2603:10a6:803:14::22) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0876bf0b-08b8-4cc0-0d03-08da1efb0bec
X-MS-TrafficTypeDiagnostic: DM6PR11MB3626:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB362613E0A258417E89C74C56FEEE9@DM6PR11MB3626.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tlpdT1qSSc6v0/slrXZD71jnD6DdOnuH6qLflD8hNXpcATFiHc4W2Ct28r6jnRZC4GyDyzfsLu9UzU2rrXkUBDeSBGR6CiOx2B6zNewWHWpDQNFC4YrPDj9PYhrEd1belY3bA9nYqSsssAGeOgJkVZhiFrCuAddgoAZXfHG6LQaujkNGFfp4Ejnb0J6LOKAJw/qoSrN6UhtcYGcMKysewY9s14L2KEb7UCxxYvur3uwmzgJBqHFIbKWZeehh4LAxHwkoWMLQ/ZZJzfI+l1LEiUXzTuJk8FEKDRff3KsQbIunFlB0T3WVdMyNNNAahLBLuLVGjXSHJFG8W9NGFhlA1rV47dd6MTZkOfgcrhzvflOX7EY5mZE6NVM2jGEjHAQLIWqDPFu/bOhUyNi9kPUvAxuXBJVibDFARuEIp7hq5weF+zCCwb4dwtKUfvjusa889xJbpyUTe+ZGNU6e2epixR+faLwtkIPMNlXZUsNGOcg0q0r0wIhhJQNeD5Dk5+ObISJEBybrre2GD05/Hs2BalxR3eraFIZnlKMMtRxbaieYV9HuuEF3cgamkbe1fIDIbNT7DIeBAruJhDBjATeMRFIxrBX+Bd/WZ8PwuGny5vAaFwj2pbzUcVO2SxSkTwpOQzCAxplrC4RkNy9CRo4tG05CcqAs8s7DxS9zGmO69kcptHHdTII+VKbOHoss/1m2ZWlglMh7EFJJuT8iUhVmWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(8936002)(38350700002)(1076003)(6506007)(26005)(186003)(2616005)(6916009)(52116002)(6666004)(508600001)(6486002)(6512007)(316002)(66556008)(66476007)(66946007)(8676002)(83380400001)(36756003)(2906002)(44832011)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tiFJQfR11Jyip7FPPRn7QzkrSzY4wagV7a1oJj+rrBySM+EvK9+l2X3Ycrp3?=
 =?us-ascii?Q?3aHLwzO4zA27nI2yTEAN1VnjytdLMiQEg1uT0Veyc+vRIFfLPwTSais0PWvC?=
 =?us-ascii?Q?PaTUGSGWbQ8SX0Yc2K4Sa7Q4aZyV3uN90ALZzoAa5sV0n5JjMN4UsE1gc1sK?=
 =?us-ascii?Q?nQ9Pq8L9/nj3QoN8QpgZ2sT3OGe9ssSfS7lwPPnoF9YvpvTNo+FLhOjoxZBK?=
 =?us-ascii?Q?Ewic1N/13+KrD33f3+qrHvjxfKYfJK/x8ERvKle19JUaoBOd/vei6z8wmO3r?=
 =?us-ascii?Q?/Jl/4/TNZUY99Iu8Y1TagjyZRmbu0ET31qDF+tUTQ4AMeS9DpNxaW2qU/6lH?=
 =?us-ascii?Q?3IPBFLhwEqZFlIj2qlk9971rCSL05QAWU1/SbUegWtFPsLP/ZgFnqeI9XbCH?=
 =?us-ascii?Q?DBSlEGAoyJJxhnLmo/e/j9K5MYbXugaP01BoRwWx4ovJVsXfPIuMfMx7SLfJ?=
 =?us-ascii?Q?09Lz5J7lCDAtRWqbWxMe3pbmamQdeN/BVTzwQ+L4SMRM+hurIHsxElLtxO3a?=
 =?us-ascii?Q?lRBB62Zp1EFUKsQ1AyN/Pyi6PCPRDsxL6cRtb+qhVimG/I/GMQ8fek8olZov?=
 =?us-ascii?Q?4xwE0RN8+MRg2ujGXzeOoNa7kjegxTVfMxwnwSk+5k0RP686P5531aMrEYpg?=
 =?us-ascii?Q?hbsQsiVL4COlJjLJL7Wnm1b/lXK5vVrvZJrcXTz6jBjBnbQqn3ZyN0ir/Vvp?=
 =?us-ascii?Q?9E99F2bzCWG7gZrl+LU0/rBX3pX7TJVMaekyPKfHfMB9EhFI+K87XxHNYbzt?=
 =?us-ascii?Q?8JsLUsvYz2JC7iBhQK6PO36WujxpZ3T2lfxkiIYrQrFxJlNKyt/JgL7R/ro+?=
 =?us-ascii?Q?HC46UvBqX2fJ4AglDNFH8RC58jl4Db2EyA8rX6oJHlvU8DEMOpQ1Wg7kcZEQ?=
 =?us-ascii?Q?4YCVadFOrdxsOr7T5W0PDhfR8QBX5yUbEVPjbsqZd15epVvUzGz/XPxWRpLo?=
 =?us-ascii?Q?kzNsCpT/1vopuTOFN7rA6jB58u3gjg7M/Ml7epvdAB4QPMOsJa3xUkZPCBP2?=
 =?us-ascii?Q?WzXwvY0eft3u+tPY/o1qoNk5bAig0+/hEC5mLGH8I6WEk2XbSHL0VPmH+8QO?=
 =?us-ascii?Q?USQEnkHGO86rXV+Q1mnoE6fvJuHRWd7Ghhkzxk//URDagdTOGdbH/Cr3rK7e?=
 =?us-ascii?Q?DEHheaV4FqsNLYYVI8DTkmPP4sP2d3AwNx2+DKOAPnHT34MtaXKNl3MZL9/1?=
 =?us-ascii?Q?H/5C5OQOlfZMT1rf0JDv8VBYcAoQ1UZ3SJx6Hmh/7CRi8vOIE1sTNhNM+QVB?=
 =?us-ascii?Q?OhfNVbhlnm0bjWmDQrQZ7+Bhd+uzd3FEh2s3ygjoDYCLZG9kyIDV5DCxcFUa?=
 =?us-ascii?Q?tcuDm/aqlbXWZ6IWsLex47urKoRsbkCcgXDNfPVbCAUEd39wf7/E6P1BJATv?=
 =?us-ascii?Q?G+bFnfALEX1NWaDjweRfNB9PiUO287lrFn++4NHPou30m7bXlK7js2Rcjqty?=
 =?us-ascii?Q?iM7pMdpPyvt/HpXVdJPYK4FuXKBSkf3+Iy7nOBAM+ujkhe8ItwqtPNJNBnBQ?=
 =?us-ascii?Q?qVC57WZvGbn+2I7sQJwaBufSx1P+acJZL3DvSaG9tUmgDcHSPJTuP0k42Oyl?=
 =?us-ascii?Q?RjOv9/FIZ6rT3zvD3PT66FPyINiR9SyLBX584/gZrXRRGOb6YmCWYWpw2mvZ?=
 =?us-ascii?Q?N/YwOBa+v45MAUFB9CFNDyAMBC8MARpn/dRyk5Ck9Fstqj9Uv2FGMznn3iQ4?=
 =?us-ascii?Q?2YYxzQ8a8hCPXD4vbjLyobDfKozoTckT9eIEeUYz1GU0Y43fEFYuEsnDX0jp?=
 =?us-ascii?Q?s+vkOyh2z4ngcbsBr+0l0MHDLGmEdIA=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0876bf0b-08b8-4cc0-0d03-08da1efb0bec
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 16:14:41.3083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UrzfZIAk6PWVDHeZzIotlNdKkJBpfqBOKxd9Zv8HUv24UJbB4sZCraAvQV/GIEcnvS0uchBDixlo3cJyTaYx7Z0FjYIHGvEiNadxaegMTr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3626
X-Proofpoint-ORIG-GUID: Oa-2HkS6V-KKOm7RdF5u65Rc0W8jDc70
X-Proofpoint-GUID: Oa-2HkS6V-KKOm7RdF5u65Rc0W8jDc70
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=721 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204150092
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit 5352a761308397a0e6250fdc629bb3f615b94747 upstream.

There are UAF bugs in ax25_send_control(), when we call ax25_release()
to deallocate ax25_dev. The possible race condition is shown below:

      (Thread 1)              |     (Thread 2)
ax25_dev_device_up() //(1)    |
                              | ax25_kill_by_device()
ax25_bind()          //(2)    |
ax25_connect()                | ...
 ax25->state = AX25_STATE_1   |
 ...                          | ax25_dev_device_down() //(3)

      (Thread 3)
ax25_release()                |
 ax25_dev_put()  //(4) FREE   |
 case AX25_STATE_1:           |
  ax25_send_control()         |
   alloc_skb()       //USE    |

The refcount of ax25_dev increases in position (1) and (2), and
decreases in position (3) and (4). The ax25_dev will be freed
before dereference sites in ax25_send_control().

The following is part of the report:

[  102.297448] BUG: KASAN: use-after-free in ax25_send_control+0x33/0x210
[  102.297448] Read of size 8 at addr ffff888009e6e408 by task ax25_close/602
[  102.297448] Call Trace:
[  102.303751]  ax25_send_control+0x33/0x210
[  102.303751]  ax25_release+0x356/0x450
[  102.305431]  __sock_release+0x6d/0x120
[  102.305431]  sock_close+0xf/0x20
[  102.305431]  __fput+0x11f/0x420
[  102.305431]  task_work_run+0x86/0xd0
[  102.307130]  get_signal+0x1075/0x1220
[  102.308253]  arch_do_signal_or_restart+0x1df/0xc00
[  102.308253]  exit_to_user_mode_prepare+0x150/0x1e0
[  102.308253]  syscall_exit_to_user_mode+0x19/0x50
[  102.308253]  do_syscall_64+0x48/0x90
[  102.308253]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  102.308253] RIP: 0033:0x405ae7

This patch defers the free operation of ax25_dev and net_device after
all corresponding dereference sites in ax25_release() to avoid UAF.

Fixes: 9fd75b66b8f6 ("ax25: Fix refcount leaks caused by ax25_cb_del()")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[OP: backport to 5.15: adjust dev_put_track()->dev_put()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 13e8c9a0cf4f..7968696d78ee 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -991,10 +991,6 @@ static int ax25_release(struct socket *sock)
 	sock_orphan(sk);
 	ax25 = sk_to_ax25(sk);
 	ax25_dev = ax25->ax25_dev;
-	if (ax25_dev) {
-		dev_put(ax25_dev->dev);
-		ax25_dev_put(ax25_dev);
-	}
 
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		switch (ax25->state) {
@@ -1056,6 +1052,10 @@ static int ax25_release(struct socket *sock)
 		sk->sk_state_change(sk);
 		ax25_destroy_socket(ax25);
 	}
+	if (ax25_dev) {
+		dev_put(ax25_dev->dev);
+		ax25_dev_put(ax25_dev);
+	}
 
 	sock->sk   = NULL;
 	release_sock(sk);
-- 
2.25.1

