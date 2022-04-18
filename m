Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD443504CB6
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 08:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236797AbiDRGgZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 02:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236802AbiDRGgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 02:36:14 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09B618E3A
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 23:33:35 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23I6A5q6022712
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:33:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=SaiQ7EAl1z3wH8LxdxkCIULxrBh1DwKMkhSgmjueQbY=;
 b=MdsPXwPe/A7AcBoGMkd+0LT+1nErXQDq4incZpz39igwF2MGDMGuOBQBZEW5RwNDpsQo
 dP+idyAyDE5/jMMqNW8x729PVKEQos7/8d71emre6OhB67Ij09MWFVxaeqPZDgpSm9L6
 7ahBHLBkQ+nx8+GoEo0pu0buTx3o+ezEyh6c5WXWtrrB6RBnHvBXWy0HdthfBG5CPOox
 rTOgpAM2UXlIb6i8AbZndq7MRmbpa6jF20LnNeVy6f1YbytlK7PcsPuJIFw31OS9MWoS
 9QydoHcghizxlt34SSAJA8n1GbkWDr8BExTDoFIR0Au3N6vTFbql0BZ2eA6PXHul/0HU rw== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffpj2s45t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:33:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ple+EqmVWAqBbrqZ8jUxXBQucXwHZEm4+39/W4i1Xxa8vvvqAmWyIvcCsomgnePSJlC8F4/li3eiegVitmRV09KN/hpO/zbBUMoDBihQZYfYanxxirou7x/TcuyvLoDM+zbVUoNSNYmuBQJtx2kkUmCjacbqcj4GJGBoMHPK5Ja2gGgFJOTstSWrIyNtpEYSQRR4uJWH6Rzfnv+tjcYB5WYMsIFy0py+OWIFKK2QrntrbnO3pnHIJfqcNy+neKi3YeGc4u3ruDDmrTbQcj1aZSxnhqFuBAIt/KtlT9g7L6ZZoo78d+mOkB0n5su3tkiPa1uUWtIPS6aIEN7DqsUDBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SaiQ7EAl1z3wH8LxdxkCIULxrBh1DwKMkhSgmjueQbY=;
 b=ftJnYlemlh1YSb/ef3XG3jzuBP2nD6G20ozoVi5MX6+eadIRo2JLAZZmVLwg/z9Fj/V2EX46JRtK+tGprFlt4bMavKSto8koHhe3oWRt4pcAkBdcv0PBPZQWrrXIafyegP6TTMm/jMumQO9D831ZdFltp2wEldM099vPmomXfyW26DCesnUDy+ZpG6IMamuJLmUuZGpQGuDqmpeCMapzTzbZx0traqY3QxSVgVAWqYxhe8hwmGLrKiB7XeQXutxs7/zo3bnmOp+B1TxedVjI3y70HJ2dtbMmab5cg7V2odW+krVq9kAhm2Zp4ZjkBNcf0s94xQ1u6xgwgB+mwgQSfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY4PR1101MB2135.namprd11.prod.outlook.com (2603:10b6:910:1d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:33:33 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:33:33 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 7/8] ax25: Fix NULL pointer dereferences in ax25 timers
Date:   Mon, 18 Apr 2022 09:33:11 +0300
Message-Id: <20220418063312.1628871-7-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9678cd43-f28a-480b-5d45-08da21055c37
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2135:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB2135F47F851EB0D10DA1929CFEF39@CY4PR1101MB2135.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GAXhBDqQFbE0LFO+1TGnYrl3lTN/dlDxIcXW4tQe8/5BL/owrtsrchDQZtpPnBtGEILgrLN01BNY0kVDobT9zcTLaahTrLHqqhOdwV1h3Axs9+FYd0usR0aaeDDk1NHseHYY0zPkyymvrrG/2g4kb6NgqcMWmfFaRFarGsxg3gJ4iVnFFoZ5CF/TE/P35psqtVJqzN5cUlY/d1ttC94JSr8oZodoI/eRhBrg6nV0tJOoxmwoVrtBXpx6XVTGWNkfFEmehwCazGl9rP8E8Y+AYimrDJfFtzPoHdX6KidHirMqrPpljCUcYj70lZKT9WDBn7JDMA52A7Hyxg/CCTBIM4vR9e7OhS1iKXdgEJj4Uhlm4YMgtBuSKn6HnzE3WT9b8ftPrdv3jAPWrBdS4XxAjNxHiDkVppfBDLJNMRk++CtvmgzjToHWgYCeN0a0JkgdWltW5gSdQlMgGG3HbBH1Chu5DBp/Bs1Hc/Nlm2+xkgX4W/G8/pSFyQtwlDa0TZEEy4wO9wHOPAvzvc9quyeWCRdAtpH4rHg04XXWILhedn9eazxp8ytFVzf6tc7Ts/2S2hsvHqeJdWEahY9XOv6txhd8aHBEUVlgqYzlGPYFCbSR8m9xXfm4nR0hv53uMAlX33ZTUewhGoMOlklZDtL9UWHrJABw6Q8zVDoqii9NMbKdhIY92/zTtwafirfx93cBe0gmD5ChApuHiTNuLenBjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(5660300002)(316002)(36756003)(66946007)(8676002)(66556008)(86362001)(83380400001)(186003)(26005)(6506007)(2906002)(6666004)(1076003)(2616005)(52116002)(38100700002)(38350700002)(6512007)(6916009)(66476007)(8936002)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VsYPWFsorSwuJXyod5+Z5k410lTNvxX4djp2D78dNZ6yyh4c2mb10kXJHNXM?=
 =?us-ascii?Q?zke+DYYCidKz5iYI333/gWiZcvOy8qP2wpg+4NKvpu2a1d9cz/KgVsQnXVxy?=
 =?us-ascii?Q?ijtMaNz00Ad9cDw965JNWAZfusENi0K0WtRGwhfS4A+iWVeaPDBF1Yoj64NA?=
 =?us-ascii?Q?am4XlmczCK7vNo2306O/pdF4n/bBKjPY3OvWQbvQBeDA5uxrr3I2RoP/8t7h?=
 =?us-ascii?Q?xqZcR9Id70yu3x7RiZDINngHQ/1lrdd6tA1t0MdDxfgiGOPnescID7fce9ve?=
 =?us-ascii?Q?XGbaTix2OgQ49t7YcgB9Zix5QioL1DiI8l6YHDBP7dotmfqCgWUU9gEnThcS?=
 =?us-ascii?Q?5fx7wLoJzaC/IjfoXsJp407tC1eRsEFmYNOmWAws5WWyAnaqzzhlTVb6Pvxm?=
 =?us-ascii?Q?rJFBnu8keeNIqNbpWTBZZWlJKeUsn2X1T/qF4amnfvkpr4s2lyLvLDY5ecaP?=
 =?us-ascii?Q?z+nSMeYmWi60fCRXSHBui6zDcLOYYgOZuN+0R6nCP2P35FdJ1eNttBbyvJih?=
 =?us-ascii?Q?0Em5Crv/Z5Ds4C4d5rt+o0TZapXMl6gtyFSCHimmi6+uDp4yttMJRH5ZrE3E?=
 =?us-ascii?Q?BdfHHJvsnjZSVMcr25V/8RT9bm0kWNZYB/09GIajghdhpPCZC9PaKJVYestG?=
 =?us-ascii?Q?WXHB3DMBxnAPNmOgDFRwI0+viuHisngzSSMOp/IhyVzBvOZFMilWjU4d6e6w?=
 =?us-ascii?Q?z0MTb6JrCPJvneZOHqaLqpM3upNQ8hdDGEuFno2SkBI+QQ6syhf3CavI1bGp?=
 =?us-ascii?Q?WFZJ7yAG/2iaY/lkWd2ZVSd4WmXZSxtkU3heJX/UJaU3EehpoGLd23IBD2lh?=
 =?us-ascii?Q?MYDx4/AzeWk4wD0eFMLTfIuC3wKiEETMNc/VaPFL3PVYA1kbTygW5O2eeuOx?=
 =?us-ascii?Q?bxGFGmjjBXAJ+F/ZNse4+XpZZWz8e6vKcNCkTmd3iO60fgoKyNpZLPaE78fQ?=
 =?us-ascii?Q?rAcWKU2Y8YacnRMcW5s5Vu0aTgaJR9xQQ6qNtDf/tBo/8UHvBoHKZhEp4xeC?=
 =?us-ascii?Q?YWU9kMOvVMzQ2/xmncFei/9ExA9EPafpw+7cWCOZB2ToySWflHSKWjB9/oFx?=
 =?us-ascii?Q?HkXG4TXDWOaGsykfVkW4edPgtzSA9tOXwmju9Tn/ZulOxN1p8/2lis0i+vsd?=
 =?us-ascii?Q?o17qS00u9BLpF5WnIdo3xQpVgSKXUPG5sBSjKJ6Eo5nv+XxfefiKvMvgTcXS?=
 =?us-ascii?Q?zpabjSfte1+rtqIDDrcCGZ0bxuLN7+ai/nQ8YwqZcsdT0d+luDs8lcFv/r6/?=
 =?us-ascii?Q?hMsqZKsG0jWQUxdke3Nl/jvtTAIJ8g0fPD2/PUXxtdQEkuYdYcMyRqHI6QEG?=
 =?us-ascii?Q?lqAKiN0eEzwGiv5k0hEUULZP35q1LuG4uS8ehkZWUBG6KAXHHKfX2qYm1afb?=
 =?us-ascii?Q?QLJdnQ5+kDcFkeIy3lISi+ArsUXzoyRxiKvCFWHwuyxNqWNWnqOnU38yPiJx?=
 =?us-ascii?Q?EoG3+OM89ywPbANjjsGgcRZ6bDE0WKN3klD67iarmJCPe5/PgxM/N4JaGLm7?=
 =?us-ascii?Q?coYZ5uXavTpT9nri78Mec2/4CYlYShFfvYACQ0UgnW1oY4RrE7oS/qv6sWN3?=
 =?us-ascii?Q?r19+hBkdUSRV6gScbGU9rLmcevE4v5zHd1C9p8PSCfLotb3EHYUEXTI0SEnQ?=
 =?us-ascii?Q?U8q+t8UaStKNcHwxI5Ow4vvZna90RgC2HrIHUoVbTZEpOzwostQEuxtneK+a?=
 =?us-ascii?Q?yYWjeOv1elxxcjp1J/eMC6W0gQeVKpKjNWRzQxQRWnWk56jEUJuJt/1oHmO5?=
 =?us-ascii?Q?81Jgsd7lI4S3fPjLcV+SziKSpQc7Vf0=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9678cd43-f28a-480b-5d45-08da21055c37
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:33:33.2813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I7NMsJOcqN2kFanUQLG9aIrHAhCcB3PPCNtCRgCAnVpO+b3Rz9B/+TjFOQe7dWSZn1oGWDsIjlkSkdK6uqee6eCjGRM1usE2cUe1kYl4mU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2135
X-Proofpoint-ORIG-GUID: 4283Rldw9hjMkuHLdFuCGbncLr0ty4DZ
X-Proofpoint-GUID: 4283Rldw9hjMkuHLdFuCGbncLr0ty4DZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=754 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0
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
[OP: backport to 5.4: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c   |  4 ++--
 net/ax25/ax25_subr.c | 20 ++++++++++++++------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index b7309baae945..659a52ff92dc 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -89,20 +89,20 @@ static void ax25_kill_by_device(struct net_device *dev)
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
index 15ab812c4fe4..3a476e4f6cd0 100644
--- a/net/ax25/ax25_subr.c
+++ b/net/ax25/ax25_subr.c
@@ -261,12 +261,20 @@ void ax25_disconnect(ax25_cb *ax25, int reason)
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

