Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7740F504CBE
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 08:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236814AbiDRGgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 02:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236798AbiDRGgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 02:36:12 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E5419001
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 23:33:33 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23I6Ug8a028999
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:33:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=yS1YQ9LjxpmF3l4FiRZTvE+qWF0p9ovAMJx4rOqYhNY=;
 b=friVlreEH9DN05jEQehXqijChu5P4C/PpDsUETE23YhnlpKuZg+fAJyWLfrVtdXmjfWK
 q/6jDoRBFEcOpzzChyOPsCAMHjgaK8sZoHpOHr7GasrQhESkP+ZObBDFKw/QgR4hSu5x
 2vSr8SXPJFjjLJ+YuP6gSXIeWR2sCdSPz4y3KG1T1YHkRzsVihKWGM+jDWPwUcAc1xVj
 Q1DRMYMkWHQRuZP4NGY7HUZmF2ZKGYyErUKctWx+RwBMpfybewc0owqiTIOFsoZcpKiY
 URyBGutXD1ODJbx2inrqztvhq/3yOSHvFXks8yIT8bAoXP9I11i4b5fu12ZVMUi9sgxq Sg== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffpj2s45r-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:33:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P+knlsrNLFBPl/VUpSIO9/ggg6JDqp7LUyiEx/H7+GFXz/chCNnGInrBI5EzNbkfyiC5NZ+s/cBFrFH9GPR5a8a+iXs/wCMmg3jW5hloDBFaOR/eeuSk+0TV4EjBBaAiSnRLe59VxmJ0ChHSNaHObJQ/aaeL005VPhT1OSEZ/1G1RnPV9Abic1xzd3isJy/chLfA/jf382O0UCWWGFhcypsqL1nuECWJQIs2De4a2smWJeSGZpARKUUSVP3h9eGlf3Nai28dWR1hDY2DZFbeoiInFRJGMadxx22gZCXUlBuv5hp26rhGPsIoPLW6sdlHOn2g7FYfsZEr11bYc2fY+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yS1YQ9LjxpmF3l4FiRZTvE+qWF0p9ovAMJx4rOqYhNY=;
 b=W4srlMVbkADwsvEIIbEVj5g3X8srM2+J47KU6fnL42Ja4Nw/xmvm4LJvHiQRifhnd8rifw8EGiFrQa5lL9swxah3BwGMnDKd6Mgk1nB/5BCDRl9Mx7oBx0JqomdBnZFksNZKHJqK3qQ0M5oUBOmPVrm87QaVFbIx8tyk5t9ui8y7bh4/8DyFf8Hfk/pqqMRbA7dPq1vwpKFbI1lxxDiHsZOxUK9wOofnEuXQ8617/EjcbbcmffrysqWlKhq33whmT0GRsNarOT50mpD8PbwSVIGDopgwHLM4EueKurN+1L92qYoUrAvdSDDxDnSR9HjPOW+O4Oi2R8AW/t229vYetQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY4PR1101MB2135.namprd11.prod.outlook.com (2603:10b6:910:1d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:33:31 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:33:31 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 5/8] ax25: fix UAF bug in ax25_send_control()
Date:   Mon, 18 Apr 2022 09:33:09 +0300
Message-Id: <20220418063312.1628871-5-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220418063312.1628871-1-ovidiu.panait@windriver.com>
References: <20220418063312.1628871-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0042.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::19) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc75d480-f61f-483f-37bf-08da21055b46
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2135:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB21356A3D1EC3731E5C8F8343FEF39@CY4PR1101MB2135.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n25wdf6YLa9qYNlof68vfPNtJYBiAPv4d+lKEVSZG05tD1NUj0NCiy2Hlv7yKW1+fUSLqNd+PfbpANyrz0LenFJGQdWveFp5D++FMR7NAkTUzMExnPqK2wl2Xw14rRXmwd2igBjvkwc8Fhzu5BI99tWLtY+C6j+VJjtXAumLAjfuSSw5shd24/7T98mfvxDA2gAa8dZrMJpypdTs/mML4ao2T+EClKe7AhjDRKKaC+dXo+4IoC3Kf6SHhn7IdoqYMWKKC2Q4OZaJ/ZLleZZP9xSP8W8pYj2q44/tPzshzhaSwiMW3pgW8ts1jcPxmybhxo+2dp03xl6smOy8f2/ZoYSttobLz4RF2bEJ/r6tEuSyGzrqruUG5DYqR4O5BjyF9Gb5AQBd28pixFN7b2hzwsMZFzRk41w6mW1azLP3lHp+IJp9yVcS31UwFKWxTVuA0eOU+SFNQycUUWkyxU/NzbtUVxNR+bGM/n1i+U0arhM8L9zgnKc5mnWk+U4cq2pZmkvNMRe+FUgIZ+wYLvJz4jNVD67fojyoI59b70rR3qAh5m+Hq8O1ips+ncPyBbxIgNgoX5IFELR/2mLYrUqLis+C9OLHFqMLRkcbrqWOa8zHogi0QZQ7rNORcIm+I29KK96u1luEOoBF6g9sskNk8Zm+jsxmRMYmIOjWFQcwkyLWi/DieQuw5E8ZN03rVqpfgJYCmxIPCInMM6Pz6D8SHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(5660300002)(316002)(36756003)(66946007)(8676002)(66556008)(86362001)(83380400001)(186003)(26005)(6506007)(2906002)(6666004)(1076003)(2616005)(52116002)(38100700002)(38350700002)(6512007)(6916009)(66476007)(8936002)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3le7TgbEHuqtjKQs/ThdlmK3k+CmdHJlDHn+OU/FYJ3Gdfo2ZcRms/yeBAw1?=
 =?us-ascii?Q?u7XInV4XmrPWK14fYvDG2VTLqSNWtVugrK5jQh/vJg9b4NJQYL10+NIEP83I?=
 =?us-ascii?Q?GP5fRli+S3dWAsrCvMHCG1HxKjLbKjefT5FHhPeixWtFtdzXB3JTkrBcitPB?=
 =?us-ascii?Q?EBpqeThGds855hbhCp9ZUS5QrwX8f672h+1BgAZuv0hnmkNHHPu4xbX+q5La?=
 =?us-ascii?Q?fvJQ7Niy9/P+uZY0wtkK5UJ6n6fxyGzWKxydWDy5uCGyN3sbXSmfFlmIYgFY?=
 =?us-ascii?Q?sDwRslJvHuFHDHC4ugoL0UkFtzT8VxNNtGtSHmlrgtSqftNTkO1dGVFAiQGc?=
 =?us-ascii?Q?QsX1Oq58lkUBA4iiCTUUg3rmrwukEHPn9L8ddahw/KjQyT9iOxooyCMguBG+?=
 =?us-ascii?Q?GNKOchsPfw7AuOizEt0X+fkTT7kRx1NXCAiFOacmJ3ctI5Y9Afq3qmfzArzX?=
 =?us-ascii?Q?ug74aEZaBo0ROMDhtxMu8c0g1CSTv4kRg34mrV8DTircV0sIrRi7n9j4pL5F?=
 =?us-ascii?Q?i8Bt0OKGO0v31w9SWSkcVD27HCKAWotH58uKj2lSJn8m8szPMlTgpYPfhcfw?=
 =?us-ascii?Q?U23kcQIenxmvael1Vs30ZSOzBOZlK6NNvNYQ6ASJByfhgxzA+Gp9IDB8jXTL?=
 =?us-ascii?Q?57ZnJwPKrccmUzeGagUOja5iwz3Yd9i16XyrYUInr+4Zh9oLE1bcmKSEjnwk?=
 =?us-ascii?Q?DBsamclLpRCANysQopf8kgDtL/r+viuUHf4LrUQmpU3IsxwfTM0vyDgeEWu5?=
 =?us-ascii?Q?Eve/PqxVMhOeoCG+xvprCYV1qpo4UtU0DaRfuke+1D4zv2M8561XFStaZmmQ?=
 =?us-ascii?Q?MK/lw1Vf+Gsr/+/xgvAkK0KbVC2M3gbIkradVTrYq0jsk4OKF4JxLaSTcOIm?=
 =?us-ascii?Q?opioTcA21H0Erwfz1Odhl02IjVKB+Y8o+7V5F7c7Hve7fWPd7MY3756yk1MR?=
 =?us-ascii?Q?4cq/0QjDCLk/ovc8jgL1krBtxKuM9dFlH1AHJ40tN3OHFFDZrJytHIfdirzn?=
 =?us-ascii?Q?XOoqgeJf43VIwY22KtEOQ+EJTdMQ7fCGh61shTVcYQk/n1Rm/hJs5OmnOSfZ?=
 =?us-ascii?Q?vXu63r60g84QGM7Wah5fu+vO6Jt4sbSrJhSlmj0o4Rh4FXeq9TVOJwth0oC8?=
 =?us-ascii?Q?nDKrF6DA/IR5y3oYTiSdqhHiYKeqpmv6sMDEpIX2iiCwru+gtBMBOdNlCboy?=
 =?us-ascii?Q?b9D8RtxJAE82j0/oLyw7nycJz37s+Pj/dmb77cIZXtAsVmmdQJkKFA2nsABm?=
 =?us-ascii?Q?ORzHmbqWgGw3kjRLutDqyY+w3gjU844XhrsghPTilnwLbouO1xbMX45TxcMl?=
 =?us-ascii?Q?qZ+9uWOoge+ZRZ9UcHm+hD+mvx7yxoHW9pNlWm3XRev7mPszVhjyC5e8wNxb?=
 =?us-ascii?Q?Sr+JxEh2LoG+dLS5hQ/2WkhfYbnMq2oYatCtaUH2ITvGFYb6/D0Ru5sagEC/?=
 =?us-ascii?Q?dg3dgzOuEshfTBCiOrjWZVkMqClS3UHMcVt6A287k7uwFliAuiP0AXHGNUU3?=
 =?us-ascii?Q?UGTKRjrObHu0xe3b8XwSL++3ebAKPoEsnOTynAiEke8k/VyRW4W42OZ+4ZhO?=
 =?us-ascii?Q?cSCqIQbisaStv0jL/H2FkWOhsK2h/HBJmxMZvQ7PPpFVwEKPRbQnhTwVk+1o?=
 =?us-ascii?Q?ZnikxHp74n6x3EHmD/A5o7XiUqJpDZQXF+00q4ZDrwfsGNWmItPVAoAqKaI+?=
 =?us-ascii?Q?ratTGKl1niT8c94X2mvESC8Gjf16/8+zrihy9VHwYqu2UV2rpcCPrLWn2FoX?=
 =?us-ascii?Q?pbWx9GqgbNlV5V+gNOpU0QxosryYIA4=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc75d480-f61f-483f-37bf-08da21055b46
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:33:31.7321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X+x5PrgUwMo/ZqbC4SSoOwJgIY4c6FcaEkky0wQo09FBBsdCbVLSiFkCmEvHK2SVVNl/tVhNa0xVgz9gmiHZ7+7XWCkqm1UdxUMDI2aMjls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2135
X-Proofpoint-ORIG-GUID: yHRbq4ViWuYnxJB1fERS6aBxqBNlRjGE
X-Proofpoint-GUID: yHRbq4ViWuYnxJB1fERS6aBxqBNlRjGE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=719 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204180037
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
[OP: backport to 5.4: adjust dev_put_track()->dev_put()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 0e36147f92f9..cfda476691c1 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -990,10 +990,6 @@ static int ax25_release(struct socket *sock)
 	sock_orphan(sk);
 	ax25 = sk_to_ax25(sk);
 	ax25_dev = ax25->ax25_dev;
-	if (ax25_dev) {
-		dev_put(ax25_dev->dev);
-		ax25_dev_put(ax25_dev);
-	}
 
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		switch (ax25->state) {
@@ -1055,6 +1051,10 @@ static int ax25_release(struct socket *sock)
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

