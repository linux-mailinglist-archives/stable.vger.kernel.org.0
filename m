Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E341D509DA4
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388363AbiDUK2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388525AbiDUK1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:27:47 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D434A1106
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:24:57 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23LA8WLN024294;
        Thu, 21 Apr 2022 03:24:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=y8cv70/h66tFYtlY7CxyFRgpQeas58ti9YV8hDvFVFU=;
 b=Qk3mz7wW4OOznfxm08sW4FSaf2Oks36zJNybalUDdY0qwLuSNdNaJnDFF+O2IZmzJlj/
 PZonCe1w0EH2N7MaUbFDlGzK4au2ji4ita/o7ESW9M+qNxJEM4wPrczuhQgbqh5zkJEn
 EyJyxjN1BkjTpNEnxuXcaZP/SlmBhNaAuRwXHR6q9DlPHmDX+FdFHdZttYhrN+AAe4J2
 S4lVHCxo2a5BLduBIh6bcUgBvFTRobdd3m+msSn7FjDr1naxCmPA4hHnOYxNeGWxAp8j
 vEJB4FvMIj6K4Y7GRfzKezASL3ppLvNgkMl7VI4h2L8vdE0dAzyNWiCBT7ExsO+0bwGS 8g== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffs313ngq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 03:24:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T9FNhy1Whtd/JB77lAdWnu2HJP732u4QD0+F/B3dyJhlV8Zmw8zrglm/Zbxo8G+axfhVDSujQom/jLcTxZxqU9rcyWyMafIjub8KrqflbLhI5J/j9PTGiJVmrrk5ikpN2JApbZLouAAThmEL0QiAN46W9z2SLC9U5o2V22OZmX4ivFKo31R8rpJ93AU0pdRsarfl0+ckBPgHQDziz/6/lXkWm3khNLvnk+byxGMoP6dyvOEXht+p0Wl3qtsTYIDdeRZ9GfLa4537OqwxRyc/ljYmHmG+ooyVhAxJqdecAkDfM6riTf1h+ra6ZDDOjEANjYAwJ3KipAlRAvVe7SrBlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8cv70/h66tFYtlY7CxyFRgpQeas58ti9YV8hDvFVFU=;
 b=Coc61XdWa1MkvD/TiBpBsSfeMXnvILpbgYdyrdnACmV13l2Hz8n8ky5efVj8UZecagEJEJ3bYKZ32GeDeTsRdYlcRNNa1wk68lVzgne3McJxIMcwD2mA5FncsMWlPkc0NsjQldMkTtd8IifijlpOd2o67wVBtEDswdVL8OMfaKfZU3Pa14hYoAUYeJTfVeaO+pidVpR3lV08daAh1vcG2s19g7yHgdnHQXQuEak6Pw+zZ09s105pC9keyoUJrCVJrgJ+fR1TcyexblXVMUZBaXkpMfUCGAkVOVBHdS+IylkURqH4e/dRG+oWg4kb9pq7r/yYGO8XGkbmV975hmyCxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by SN6PR11MB2640.namprd11.prod.outlook.com (2603:10b6:805:56::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 21 Apr
 2022 10:24:55 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 10:24:55 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 7/8] ax25: Fix NULL pointer dereferences in ax25 timers
Date:   Thu, 21 Apr 2022 13:24:21 +0300
Message-Id: <20220421102422.1206656-7-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5c5a40c9-3b2d-4672-829a-08da23812d93
X-MS-TrafficTypeDiagnostic: SN6PR11MB2640:EE_
X-Microsoft-Antispam-PRVS: <SN6PR11MB2640E0D078AC4052C4FFC37DFEF49@SN6PR11MB2640.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H8hUw27fm4rMyoQ/REVhRT0+1nIJkOXv3AObxf0MbcFzVsYZrKkR8s1FxR1AahyCnjLheL7QeHUPrSu4RV4V+PMo+2Rm4vqkRC+HqP3j+QSClpqmn18taFKHY8hwCuwC1w9SslBMiyYP/GHKmJu50fsQFlCcRzcHmzmyZI/+/TiRNW1KGjo1FHCnzhU5fHIf2NF83EkfdwQr7okQkrbYz7rpVyevhZ0y/FfVOyFCev5X9wO7tWBl1hONuDGOFfdCYfWrwfI+cMfje9l6MOM0aq/WoLr/OdLKDojfYKdCeIk1HYDrri5KiM/Sm+4gqv8+j+nlDlFNzVt6DdURyv09cogQ+Hpe6ZDsnL2IQZqigi3U3NOoITYz5R2eZY/NPq5M/uW5ioISUkIqZLEHzyiS87HDLhzUuit0rsFSqld0uFv3d+laY0YvvxyW+Ais8MfLcix+TYa7QVdh2NdnKUgY2XXV0aqMTH9+V0KL7g1wubUiyK5i9KpHtLwDraes55XsthzJLf0wHS7uIvRHuGL9JMJ/oH7XJo213ZOCBO3S65gCjV9kEy97o8qpOR8iE6xhwQCFmIWN7jE/XQFCNZUlodUkec1SeEVfbIyeKhcanDmBx/STnrNFzEo54jJCxOrob3qCGJtdecanCy5OH+wE776a6LdxhEez+hHL9bEWP2ryPwibSrHaF6DKvftkdiD6AVB4mRdad1SEP89a9ac86w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38350700002)(38100700002)(66946007)(36756003)(83380400001)(8676002)(44832011)(2906002)(4326008)(6916009)(5660300002)(6486002)(6512007)(8936002)(107886003)(66476007)(508600001)(6666004)(66556008)(86362001)(54906003)(1076003)(2616005)(186003)(26005)(52116002)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wB9n00fVkDsDiy5RmYFgVf2hC6DWi6zxwnirYwI9DTkJ3nlZM/N+LLNKIyrc?=
 =?us-ascii?Q?Vkwn9VUuPZys2zisod4ynpsQRfC557+CcdbcPDwKknKiETZVwoWcqoSvUvu8?=
 =?us-ascii?Q?kmDHkxuLHPC2zkro/XThi5QpTLbVlmfxlMBtyShbI5rYMnXA6oVQJMYzLKu1?=
 =?us-ascii?Q?3TYIgGID7XTK87kcGUzfx4ZpnPz3cBqaJyp7HqDencxq6DN4iPQZsD/taDNM?=
 =?us-ascii?Q?2iYkPJc8zaQelBghiQl6oP8hNQJS1fe1zt+KQ6RQvZ2kES2Vx+cLFXH/1S5I?=
 =?us-ascii?Q?EwSQLG9+AYY6vYlnnuhS8MYnh3MMNdYFA98aFTzOH9S2RSK4dzSjGj7aB6r8?=
 =?us-ascii?Q?8h9BIjYkeGjMoYxSFiQQ+erapFjlUYkAleO4txuuZdJ7aqBfyEp9YcTf+7cF?=
 =?us-ascii?Q?zyAStHaAKgEbq7PZHHOPo5q8jEXuFIvPU0xo0YYyg9jPVqQgRer3wHpQEcdr?=
 =?us-ascii?Q?FIBPWSrfjnuQV2OMFLL5L7x4GE/7PT6CyMxfn7Y+fJH0NpphcT5RMtQVWf/M?=
 =?us-ascii?Q?Hukm6NTCeH4Erp5lpgMggDJ2suNcTraVCac/mxS7XhkYpm/kA+YUYGGXcro/?=
 =?us-ascii?Q?VT7FPl/479CE9QunagOOKfepm22Aeyta9S/VcJGxphXBSHNT8D6VH5QLr/E7?=
 =?us-ascii?Q?GZHNazYDJ7pBoGWrxPze+XD94FGaFiAfq/7eN0VgY2Hqx5Q4EP/L1C1dnbkE?=
 =?us-ascii?Q?HdrW9pYiPrNWefr5XVpX7f3bZn42PkZdu1XIBkmJ6wl2K/QWPRABYIuEr2mp?=
 =?us-ascii?Q?B8+9kdNsyatkD49fdra4WxTvhkR5cmpOvC25EaysQ/iPT51qxwo9DQrnhFLB?=
 =?us-ascii?Q?/SgwPT4m4WmC4mTF+COt4K4ve5PwTyQI4XTfZlZJt4HYEdV1p3Dw4f0xrWzL?=
 =?us-ascii?Q?QpqrFAEVNodQsYyXqWHiaArVVHw2dGo2In84ctlVsto6OJGR0BdXgYCzB4K7?=
 =?us-ascii?Q?rMKwi2B9fFUDALSAL4XH3zTSXRzMUhE4byWo24Q9DOjVVENh6EHZpUrXAZ4p?=
 =?us-ascii?Q?4A/AYz1Tqc01f47myMbb3xGKzcOHpkX6/huk5BGyUGk+000teK86gtAEnan6?=
 =?us-ascii?Q?MNKRNV8lioShDkbgsJUZeKwTXyS/kH8bbS2Fk4nlp7Uys5ZUkwWO5AL8yPGB?=
 =?us-ascii?Q?AK+GRzpYYyl8ZbLXyucabwd4dIoPqmNUCrqzS6E3LnDul6nx3YdstGPEgGYN?=
 =?us-ascii?Q?wRP6AViP2yAeWDZB1T8ON/VXxmvKzL9Z5yiNTn9cF82Qtmunlf2y23w+Rwcv?=
 =?us-ascii?Q?ECeFypb5cL/VERMsuH/nO1sDG6d/NgcAFQeVQSIX9evPm2tq60wqffYKqNLy?=
 =?us-ascii?Q?9Fn6ofUvMNUOqyzxlBNyyXjZz1qrJN3wk/fAlsnEeHPnrkZdV1izSrAqlNcr?=
 =?us-ascii?Q?uRWMXpegwMCJb7OeNSBu7s/5bRnZrSLvHxuK1sOAja61SKzc+JAOC6e2Lgkc?=
 =?us-ascii?Q?UQ6FDpq8ImHgR03cqO65a2wcBRqD+EkDW1UgzjSY/8/v2UjG6mfVCU2xQAqd?=
 =?us-ascii?Q?nNHxrwbSZx+seeVAnw/KJRZLCW87078PfO1GV0q3dK/sgtVe+G0R/vlpiNu8?=
 =?us-ascii?Q?kiosZNZIky8o6qJAiimeStBFJra5Wgp+c+mdxJxXDYHj4ud1UqjBmhtjksQJ?=
 =?us-ascii?Q?4IKbB6ORknGpuaUhWm/cvuKARZd6yEFTPFg9fA40MYdb88rIc7BN8F6sQ0TP?=
 =?us-ascii?Q?I90bUNevhqcIjIMLQS7gZV6nzMsY9oEQJl0Vi0syDAsgE+UcR11DYx5d7HsM?=
 =?us-ascii?Q?B4N+uqhVM+y9PLBtRqWmFmDxsWswQ98=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c5a40c9-3b2d-4672-829a-08da23812d93
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 10:24:54.9679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F7ofd7AIPDcs9xYT2z4RqkcNJZ5/OhlOI5E4eKQEvNoK57FH6MoknpbB7MeQ1q0/BgjMr3CyaaXU58Uj6uGL2hrBwNSz8T+rMQH3qQrQjMo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2640
X-Proofpoint-ORIG-GUID: XG8WKlkYB4-yJ7qhot_8bUjI3sWexdaF
X-Proofpoint-GUID: XG8WKlkYB4-yJ7qhot_8bUjI3sWexdaF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=757 mlxscore=0
 adultscore=0 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204210057
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

commit fc6d01ff9ef03b66d4a3a23b46fc3c3d8cf92009 upstream.

The previous commit 7ec02f5ac8a5 ("ax25: fix NPD bug in ax25_disconnect")
move ax25_disconnect into lock_sock() in order to prevent NPD bugs. But
there are race conditions that may lead to null pointer dereferences in
ax25_heartbeat_expiry(), ax25_t1timer_expiry(), ax25_t2timer_expiry(),
ax25_t3timer_expiry() and ax25_idletimer_expiry(), when we use
ax25_kill_by_device() to detach the ax25 device.

One of the race conditions that cause null pointer dereferences can be
shown as below:

      (Thread 1)                    |      (Thread 2)
ax25_connect()                      |
 ax25_std_establish_data_link()     |
  ax25_start_t1timer()              |
   mod_timer(&ax25->t1timer,..)     |
                                    | ax25_kill_by_device()
   (wait a time)                    |  ...
                                    |  s->ax25_dev = NULL; //(1)
   ax25_t1timer_expiry()            |
    ax25->ax25_dev->values[..] //(2)|  ...
     ...                            |

We set null to ax25_cb->ax25_dev in position (1) and dereference
the null pointer in position (2).

The corresponding fail log is shown below:
===============================================================
BUG: kernel NULL pointer dereference, address: 0000000000000050
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.17.0-rc6-00794-g45690b7d0
RIP: 0010:ax25_t1timer_expiry+0x12/0x40
...
Call Trace:
 call_timer_fn+0x21/0x120
 __run_timers.part.0+0x1ca/0x250
 run_timer_softirq+0x2c/0x60
 __do_softirq+0xef/0x2f3
 irq_exit_rcu+0xb6/0x100
 sysvec_apic_timer_interrupt+0xa2/0xd0
...

This patch moves ax25_disconnect() before s->ax25_dev = NULL
and uses del_timer_sync() to delete timers in ax25_disconnect().
If ax25_disconnect() is called by ax25_kill_by_device() or
ax25->ax25_dev is NULL, the reason in ax25_disconnect() will be
equal to ENETUNREACH, it will wait all timers to stop before we
set null to s->ax25_dev in ax25_kill_by_device().

Fixes: 7ec02f5ac8a5 ("ax25: fix NPD bug in ax25_disconnect")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 4.19: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c   |  4 ++--
 net/ax25/ax25_subr.c | 20 ++++++++++++++------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index cc0d6b3d5ad7..faa098faafa7 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -92,20 +92,20 @@ static void ax25_kill_by_device(struct net_device *dev)
 			sk = s->sk;
 			if (!sk) {
 				spin_unlock_bh(&ax25_list_lock);
-				s->ax25_dev = NULL;
 				ax25_disconnect(s, ENETUNREACH);
+				s->ax25_dev = NULL;
 				spin_lock_bh(&ax25_list_lock);
 				goto again;
 			}
 			sock_hold(sk);
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
+			ax25_disconnect(s, ENETUNREACH);
 			s->ax25_dev = NULL;
 			if (sk->sk_socket) {
 				dev_put(ax25_dev->dev);
 				ax25_dev_put(ax25_dev);
 			}
-			ax25_disconnect(s, ENETUNREACH);
 			release_sock(sk);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
diff --git a/net/ax25/ax25_subr.c b/net/ax25/ax25_subr.c
index 038b109b2be7..c129865cad9f 100644
--- a/net/ax25/ax25_subr.c
+++ b/net/ax25/ax25_subr.c
@@ -264,12 +264,20 @@ void ax25_disconnect(ax25_cb *ax25, int reason)
 {
 	ax25_clear_queues(ax25);
 
-	if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
-		ax25_stop_heartbeat(ax25);
-	ax25_stop_t1timer(ax25);
-	ax25_stop_t2timer(ax25);
-	ax25_stop_t3timer(ax25);
-	ax25_stop_idletimer(ax25);
+	if (reason == ENETUNREACH) {
+		del_timer_sync(&ax25->timer);
+		del_timer_sync(&ax25->t1timer);
+		del_timer_sync(&ax25->t2timer);
+		del_timer_sync(&ax25->t3timer);
+		del_timer_sync(&ax25->idletimer);
+	} else {
+		if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
+			ax25_stop_heartbeat(ax25);
+		ax25_stop_t1timer(ax25);
+		ax25_stop_t2timer(ax25);
+		ax25_stop_t3timer(ax25);
+		ax25_stop_idletimer(ax25);
+	}
 
 	ax25->state = AX25_STATE_0;
 
-- 
2.25.1

