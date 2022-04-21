Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3034509DA1
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388370AbiDUK2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388527AbiDUK1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:27:47 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79E61120
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:24:58 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23L900Eg031125;
        Thu, 21 Apr 2022 03:24:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=OFkhQ/oLz5so6b+SjZh4n3us/1QcW8bPqYlrOflZc7k=;
 b=Sq8zhGmMoil4INoVSVxYuDpSoEZ2xHmxIWCBaTgWjZiTRuKrOKrnXlYD7VbB+ztyAUMh
 L1+Pr72ynBjsqYjugl8Fe695EbJH0LOASFBDbkzMO19KEucJzfoZ78t8GdoBvxgB26iB
 ePvCd0tyq3B3Z5qGmZrCz4cFagilzcHxFKqZx6oak9Ibbsx5TuC6nVaH61rxMVkih1zL
 1o3KnBfRd6j8jf20Nj2mPIg2WbsHeaaVWZXauAzZFO0dNgHZr+R/psW8Mljsx2jZwoMO
 GD6SPLEaKApqFBk5W3WgH0LmAM2cEhOwD595tktUovcIZpVKaNZaCVY9OGdWjmP1+Qlq tw== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fhmfc1wxw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 03:24:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fC8aZ6IKA/yf6ci3ipbHtmP/41ODnYpOviry2oW94H60Jz3QhwxpL/DZPyRZrZrURFXqcXVaJwLM5S3Lum9ykM3irMJK8D+wO/VYjsezX9F7JF6DkUQkL2gNS/jHf3XRvGbmI70ftyB28WuDYVCD2iDJQ6wLA10c8OGcq6b9cryi6dVR1BlWqLiAxDMlDRagii5NC1bUTCJMLHGc9sRZMqRDhUl8oNK8tdhiKzIpsP8CTU8IMlB29td6qx7A52bFBMdg8fTGzfRz+n6cJrO47ArFkzgFWeZuoktxyTwM4l14uGpQXa2DoXg0bnCCiOeGYjyDGy8cFm/XIqojHqqslA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OFkhQ/oLz5so6b+SjZh4n3us/1QcW8bPqYlrOflZc7k=;
 b=OYa9Y82XKvieO/PN5ETjnY57xg3qddoCtYRoshHjQkUOayk6k31Qyyn77cz+RpPrPQdoPKHQqfl6hlItVuYWKzSSjplyJxhvIn89nJriSw34o1Sf0/mE/I/rFO9SW1HqmiLIJsogPNgO8pBQrS07G4VKXS2YpUIKwB35tbQ0pq24HebxkFC2f2RFRUZlkLdfSNLibtZJdYiGgsB0njvA5b1JBvv11QRwQ8TwpRvMxnLLQ0Vx7luaqh9YDA4AqoAU/3Ya23A/WjsmuN2Ql9g5lEx3H/fSf0UVrAevoUI3S7I5wgE8DQLgsOTQN/qdRDXpF9NgToF/OZnB6/MabE/YkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SN6PR11MB2640.namprd11.prod.outlook.com (2603:10b6:805:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 21 Apr
 2022 10:24:52 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 10:24:52 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>, Paolo Abeni <pabeni@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 5/8] ax25: fix UAF bug in ax25_send_control()
Date:   Thu, 21 Apr 2022 13:24:19 +0300
Message-Id: <20220421102422.1206656-5-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220421102422.1206656-1-ovidiu.panait@windriver.com>
References: <20220421102422.1206656-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0092.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::45) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 130e3d27-4588-4199-9bb2-08da23812c07
X-MS-TrafficTypeDiagnostic: SN6PR11MB2640:EE_
X-Microsoft-Antispam-PRVS: <SN6PR11MB2640ABBD9EF44A6A81D1A231FEF49@SN6PR11MB2640.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D3ZOcswyzelI6T1gMiedJm9JHI/GHUp5Ce731CwXjRP/Gexi7OiMO0iSYXThzlr97SLpg6J/QYRF/XO0kOqBNy9OdqEapwsDj5qmZ0GDsaw+0CEP/awlAOya9wCenT11nn1FiorFDy0mGev8NIiUJBN3I5sZiPMsthlH5wKlpnk/LYHVTbzc4mB6Fi8beO3q9+kHd303szHHvqwmlS2rgIY311HLjLjsWtOJDOUVsz1+jvoUytyTQ6ZFNRCKSqCPKwGrGZ2rqKLdhO2STUhbDHiHOs8FaAPRhogeCgx3WYCXdHpO3mewhMCJnXGl/SXPMtK1/eAShYxKvOFaG86/uAIfpq3wyf+Y/ST38f3JZAuxrZuZmR4c3eRqBHDvKXiBjFoBGzpe0+71uFyip1Da0FqdyrHNtBbEZn34ZuuNAbGXsZG/dDrU7ZetxeinaUSAbTsKUSxZGHHt2KJa3PqYTWqik2Ri94OWsPKJP6kdZNCl8JX+i8UoNH3ZITRdQEdyRKgVC4aJWfL6B5ALHJVVxRXQbcmMK2zSjmZLxspy+xE2RLfgCuBpm0sACsATEoB3B8Y8XS7/akfhaWD2YEEx73D3Lwk7LgcqEjCFNLviqDgwdRPv2Zru7q3uwaoEeVtjdTNjjvk97G/KMCVLXfRLDJcSCjYO2mDyE6w1DVDfr5S4x4CG8ZyqF8lLZ5p1bQ6rdKozbSdyfoTBEcDb/H5XVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(66946007)(36756003)(83380400001)(8676002)(44832011)(2906002)(4326008)(6916009)(5660300002)(6486002)(6512007)(8936002)(107886003)(66476007)(508600001)(6666004)(66556008)(86362001)(54906003)(1076003)(2616005)(186003)(26005)(52116002)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rtdiLeMuuLzGLkv2du73ZQVb77YPequzZhNFNmG84+dunfBkpbt/Lm3v5L+s?=
 =?us-ascii?Q?YbG3yZ6uf8ECD56fK7OPwLBDCzntjonT1Zs5ZxTX0Aa/7xtRFFhvELtMsHGw?=
 =?us-ascii?Q?L8fH1FiTny3on4nREoc0igT9Q63pQxsFLs8y2DPCLUvZPFngn6V9q6wq9J2D?=
 =?us-ascii?Q?KtvQrJgeP0eNGfrC+z/KmF5rSzEb6rAIkSzIbFPhzsSJ60b7KjQjWZQ6a96V?=
 =?us-ascii?Q?vqKWqnT60rp87QEjkuZQUhR3FNOAm8ifB9Cu6E2+YBGOsoj9dYIXRTReu6iv?=
 =?us-ascii?Q?psbE3bNAI+1BDIAz1m4QfNP/ZjDqavgd7S2P/s/v74jFXp1g7ZiOdNacUTKZ?=
 =?us-ascii?Q?BvQU0O38X2QhzUmELsCNSWVsNDS9eqHt6mJur7MnG6t96Z9k9sdMQc/7n6Pv?=
 =?us-ascii?Q?TzNJnZL5X5+dtkiB79eOnzFcI2+EZwWe2n3XBLo1k8pIWvjGPxojKya3wG69?=
 =?us-ascii?Q?8jK5UHm9r6vRYowapA9SDAAwJK9odnkyl+PgBCWEgbwMhIjRz7l/3Oi6/nfk?=
 =?us-ascii?Q?8kh6Q94lckvT5Wv6Uh3P+NVa0vuHqRRCRkdavdQve4DriU0MzLKGpO9Bk8rV?=
 =?us-ascii?Q?aNJDgcl4s52xunaSJqlfYT9oM+4MicJxByB944ua4OB9r18bxGXkxxNUXBsF?=
 =?us-ascii?Q?B64oLwOOu/VWfCnAJ93k450sooCE6jhLxh6JyLg9bVvC+bTBmp8BOEKCIn9L?=
 =?us-ascii?Q?d6G1r49JRvIIjRq5ACVO6sE2LpeYoQUNcwmMobXQBf4emlJYJDI+J8I7wNSX?=
 =?us-ascii?Q?ktmpHUm3+XYitKvYoMln/HanSXW1CKPxKy+dp1puRAjAGlEVxkQg2lH6HgVi?=
 =?us-ascii?Q?10QdoO07O6QeaZKSDwJLWwoXlY0oM4fJ4Zgo+w9xsR3xSWwzNax6r+xp7qxC?=
 =?us-ascii?Q?Gg++M/EulNvpbHiHzyWkgLsmaEgHdAq0kXlFV5MUQDLFZigrOQdIwt2hLByt?=
 =?us-ascii?Q?+iWpjVKhPBf/NVJ/jjQFXfYShM5qqH9/6qIFZE4yPIBIhdqCU9CjeqX+jYB2?=
 =?us-ascii?Q?OblEmbuIEcVkZvxbNZQUGSF82tLCHXqOqB+V3d1k/Ngp1G+idekFXg7Y12sC?=
 =?us-ascii?Q?XJ9b+oH/wTzcTcZwtLYv+l/bgnMi0XbcsEDloDezv4HVdSoJ7dmMSCwrtz23?=
 =?us-ascii?Q?0H3r2ktZ8rTzZL9kNc+9qWy1DsImWicJf+kdowzHYRGi7ysVWG6SiMpXZ2qO?=
 =?us-ascii?Q?c83tqiAt/DHn/sNbGrMvQ4vqDaYJwyxjmwO8UxZ4Ulp/ye1VrxkonaEa/WpK?=
 =?us-ascii?Q?kPsiusXX1mWVIvRWEmbFUlRS9q1UH595vn7AqiH3VylMc2rSXktKbzqBaLKT?=
 =?us-ascii?Q?5pI6grYQqY/QGP4luMcyRElfL8dOkRHa6+gpJhOyt7z4BCg4pcc3d1hzPY2y?=
 =?us-ascii?Q?IA421Oe+g+S2gC7efSAFek+62diWILPsbwd9eDE6Kys1rTBQj3mj8yOHuRB1?=
 =?us-ascii?Q?5jkSCgVlovt7DoiUXa8JVa7oO2x34VPbUCoCga1C4UlhNAGNTWHL6ohWQxDJ?=
 =?us-ascii?Q?Igy5kfYHgKYl6gX3DIc40Lk5NXM5Q3ANtbr2R6llDOu6woDBxwOe5OSretHD?=
 =?us-ascii?Q?gY1b9eJGhdlTGT01zpH5WasFutFBFg7T8ZyvBvxMb29CVpPGAPyfIrqQeWX4?=
 =?us-ascii?Q?4xXPsAReES9Lue6rzO10s2qBH1IwlbDv+jvBzYhjGRHnk8SMpWg/IpillVuR?=
 =?us-ascii?Q?Wuy/XqOEhPZ/oRRl/gTsDiKmVfRvOAJQMx+rfTkYZ4S1h21RQUN4Jf/uELnV?=
 =?us-ascii?Q?j4YXqWgnnsNNDtF7yDvCl89fJbuJlNc=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 130e3d27-4588-4199-9bb2-08da23812c07
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 10:24:52.3889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NIYs8q/WxxMbMrQIIB9XBRAcp2jUJymBOSRT9L72LRma17iGZZwfh4xwhc1OM6Unpfn/4zKOK6ky754fsKkaw9nratC0SAlVHIsN6ASc/9M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2640
X-Proofpoint-GUID: rZwOB1qTQtWoMcqWy2LN9s7CM5X7tPJI
X-Proofpoint-ORIG-GUID: rZwOB1qTQtWoMcqWy2LN9s7CM5X7tPJI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=721 suspectscore=0
 malwarescore=0 clxscore=1011 bulkscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210057
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
[OP: backport to 4.19: adjust dev_put_track()->dev_put()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 4c41c91227b2..6d08b8ef4219 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -993,10 +993,6 @@ static int ax25_release(struct socket *sock)
 	sock_orphan(sk);
 	ax25 = sk_to_ax25(sk);
 	ax25_dev = ax25->ax25_dev;
-	if (ax25_dev) {
-		dev_put(ax25_dev->dev);
-		ax25_dev_put(ax25_dev);
-	}
 
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		switch (ax25->state) {
@@ -1058,6 +1054,10 @@ static int ax25_release(struct socket *sock)
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

