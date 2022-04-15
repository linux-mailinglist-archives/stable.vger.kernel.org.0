Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FE2502D92
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 18:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355790AbiDOQRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 12:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355818AbiDOQRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 12:17:44 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965FA939ED
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:15:15 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FFwNBI025644
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:15:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=kVjcxyKBDbCEwTePd1ICqejqL5zZLyl5Izu1NU4wlFE=;
 b=cpgoBiVR09vmNocdNz3zi4+BCkEsGTaE5JlqGZGCTbR1plhifG48g6p1OSDzF2aEanvh
 ccT4Lusw1HZhqdheYRMIgUTDByi3ft3NFPxmKoEFxPCFpG7gxE7DgBzkwF67UycNlOuA
 9h+D4DMNlbehBLr6QF9pOUjjT3k9TblNO/mYj7SxW8HssO1Ib9dzuSPNEd6j0e+DeNwA
 iCoEWZPMIJwPr+WbWi1DdJI/FlDyri1mSKUQnMQZN2OwaUJLkMSxofCOiZNfKn+ytFR0
 X2YqhZNYt40LundoELE/mBgHgibuN7fioSIwI6bGjG6nCd3mqk+K/6IN8511GEmU7uVR AA== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fc0jec5hv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:15:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtjCd2zopPciNghqQwbHW1ER/oFy0Ia96UE5FGeV9yCYfErEBx7/vdgWnJHh7F4yPBYfUxnszAi2S6o0cNWGbJbfcw4jierWWy9VLNzTwp3/tqQxZnrRvWPQvhRiXtXR52FoBvenfgFMZCDGsWzNU/9cNPo513ScEMd7SJe86b8Co1+IyOrIZS1Zi6gUG5Mbif/dcctDQnS5iRT05mUmE6X8kLk04a/fVe+uVUmC23mwO9Xo60JVSzfR/csVQJJU9NLVtpG7f6+4158SgTiaifYk7HvJyMA2iqj7jQqliJxph2/OEY81psEBKCDJvQWzYNrNe1I2TUM15a/I7tkIPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kVjcxyKBDbCEwTePd1ICqejqL5zZLyl5Izu1NU4wlFE=;
 b=l/PQk2wx75PioECkxA6R00wCyOrWXyvvgvKFc3U4ne6NNQJBDs6DM2YENc8leqbwOpPMBQsp8F2ilxsw3UUwf0RABGqljzKB1XvPqJjEhyyDdL0FMrDLzzieGK78Y67QcqninFG0divXNNnF9GHKc7FAoKEB/CgzZcL2EZIlpIlKAz//4xAdx4CbHwb0NinVv2gikso2awFX1dO0JOodVgGRSKXPFgBb6+7NDXqxN3ji15UZEOL4l0SEPLk9IPSuJXS4WS1ZdcDRG+Xv7paeRGNPdGCrKyanVuzrJGlEY5hO/D9GVol6TQV8vrSpvY+k4m+QIpPUY7vh37XoJ4bCWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3626.namprd11.prod.outlook.com (2603:10b6:5:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 16:14:43 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 16:14:43 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15 7/8] ax25: Fix NULL pointer dereferences in ax25 timers
Date:   Fri, 15 Apr 2022 19:14:21 +0300
Message-Id: <20220415161422.1016735-8-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1327dbdb-f4e6-42d3-5370-08da1efb0ce3
X-MS-TrafficTypeDiagnostic: DM6PR11MB3626:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB36269FCF8A2BA0C80249FBFBFEEE9@DM6PR11MB3626.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eQWhp9NWQKcj3KtN1prszytyBUxFJZIcvtZkEiS/sSwVphxFyEl0HZIznjKC/Me4qSJVpazH69TM+Ug2a7jE0ilMFMqDj8Wo8TKGd+cCgwXv9mImXQv7eLzeLGMx+Eb12a4QtLr905q9XMWG4LpPhok2YSDCLCjWFUSm/AxHt19RlvBOxVa5oG8RY8FKZqQ654ukiHLFaxPnb47oIhOm/vysbyBHexdB1euC/kRe8Ot35b8KeUhhZe0cvwhWcaoLW3dbqND2TPxkIhlBuzo9LcWzxhpYX1gkJyi6GH6MBnjdl2Gjlk7jyrulsvIaNhJBSloJXJc2rHA4+v+IuLCeheMy5L//ewqikrZmpvHoG7CIHd0Hb5on9VbWSfM2VPPHvVN3J4OxkN0GeIyuhOMFKDyfjHpwvMUoTMlGgaUYZCgqXglk/+CpranYbCda0CbjYlTOo9SYbOGK55sKD4sRioISja1MvGbLjYRj4QfGWFNA3+j+2xqLAQaJ3hwW0qOip4pP0/F6/yWjX6inb+Gxo3sa/X86q0amaTHWtXszU1cwQehcUqNY5bxbEkltMpAS1b3ZxyYROZDoSnKjgRvyY63tYu1lIn4FtNkuuLKAyFgdYayQGPhrm/1k7zRjsyrdC387t0w+FA8CusqdE2q/KbXB8f4/BefW/zv2r20X2HP6HchUt4ei4SkSRDmAnXsAKzGzVPXHJWIw+Oi3UC4wSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(8936002)(38350700002)(1076003)(6506007)(26005)(186003)(2616005)(6916009)(52116002)(6666004)(508600001)(6486002)(6512007)(316002)(66556008)(66476007)(66946007)(8676002)(83380400001)(36756003)(2906002)(44832011)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?53xhP++cPBuzOrTQfLxr3qxvLlSe2k+akx1GSgUXAjOUzdeq7dx7DgdgJZgK?=
 =?us-ascii?Q?nmF/bHPWe9uL4ImlwLQOMRZ/TGgcOWK85YHRJHUFjtiBeSgkfREr3EfzJdow?=
 =?us-ascii?Q?TzrrpMh9r0a6386TeCDnBLPTML4QP4eL6GijjpKELjwHHuEZ7zbIPPGBNIVs?=
 =?us-ascii?Q?W8D0V95BMm3wrgps/wCP8nblfvLhGXxSgQEnLU98PZZfIgIS0POuCESqm0Un?=
 =?us-ascii?Q?5kZXCriTe0sJR3oYnKI1FyDSDpvUgQ0SDClO0leyY//M7/YQcKYFzyb4QKN+?=
 =?us-ascii?Q?ws7Au1f69n5W3uQXlyKkA7xgW45lka5wzZhvXAJocfbZ1HgAYhrK1FbrY5h6?=
 =?us-ascii?Q?6cnPkIlfW6saacI0TqGdot6oHwok0DVk+0bAf+9ZCGSD+5IC5B2ZiQtOgNTg?=
 =?us-ascii?Q?+m+BKPqX6Fmp+b30RnDdFpNpyF85yUpZ0EKleObmyFi+GSH6bpXOarI8y2bG?=
 =?us-ascii?Q?iecYPrg5hbtBxs4EKjIlPpq1mgfgDLdK3EsMK2i5M2EIQ7CCHJE1hGPwIeor?=
 =?us-ascii?Q?03ezXcX93Iv7jyROqwKnnS2IBnK6YVYj3jRe5Xdl98LH7H7mKVr/tk84XGPd?=
 =?us-ascii?Q?qtx7NQKac7uKIk09rUADn/dtIiXZva2uRl4KLCZ/yDZKyzsP6HOHGbGzX7AT?=
 =?us-ascii?Q?P0sUNHTAwdPzNUuBVDeKg0GpckFQPeFZ+tu7GycZ84T7ZM8alvvlh8rJir+2?=
 =?us-ascii?Q?ppBREChWV6zR9yC6vlExMI0dI3QMIYJkUWPg+xe/rSKTnufJtFEwTU2dODCo?=
 =?us-ascii?Q?La76ZyAYU92N56ToP2TbwGJsvL4vLB0aoElt3wbKsyxms0WRvZq9ntsXKBpk?=
 =?us-ascii?Q?H4oj9ubsoz3LK+rFkpbaFeI4eOaOyKVQxLP8pquANiAtg4pExW7QVEAW2Iag?=
 =?us-ascii?Q?4fIT1MzmE4UPvqAMTXhgpVFt/upqexdzKzBwrx/hw7czffJlpgsYk3RcQBI2?=
 =?us-ascii?Q?oz9OwXk5oFEegbdZtE1sTco8oCLvYnKJgf924FsaK25ku0GDIOsTuBxLXPMd?=
 =?us-ascii?Q?uwY/mzpCPwy8FqaSMWwO5yNMwbjKSstpqa797bn2rX+Hk6jgCqbIbGi/ZevT?=
 =?us-ascii?Q?EfP/1WpbWFiSQWOuY3ufID5Cm472gjwWg4usHg81g+cKNUfcYLhTfUqDhWBV?=
 =?us-ascii?Q?8y8oDQyxcZW3++DRXWVzQH1Jj/TBE/LqTqgXP9aRrRFgFPXmfUlNn4YwwpqO?=
 =?us-ascii?Q?uAGbEO+a9OP8u+pDWLMiXi2qLGOSsNaV0LtjzK/4tOsAnYassTMitqe2UOY2?=
 =?us-ascii?Q?bcV4KNDj7f5FbVS6uTYQ8mia7Hfqk5zSVFDj5n/gbt7iy1HVlLR52IE+w7YJ?=
 =?us-ascii?Q?eUNRSFF2QDgyIVThZT/aQftoYxyTib70PB64w6gZpxmHQzBOKRlxlmcMzt5L?=
 =?us-ascii?Q?rduDdkvoOmb6qu7sH6kknxmWoXfqmPeducNSi/dRn1NVfIWK9Hs0tMQuyy7r?=
 =?us-ascii?Q?Es1aGY66w9HTgOuA0HC8xItoDagnSq/7/BcbQsDhrYS/7CL2LAGVRuS1YCDX?=
 =?us-ascii?Q?3jl/p12+sEi6tRWF8bCSxB1njQ5ZOl8KaCMfLWQwvxmRzzREzOaBJ73Sr+8U?=
 =?us-ascii?Q?jFrDr+bSkX/7KxEYfuC0NCYMf6p9ZniY5OBcaNrviPezBQCb23BZtliQpTVc?=
 =?us-ascii?Q?l+nxjThycFs8IaGIX4wKzY/tVksqFsGjr3k6kmQHW5gUUjfAHztRdzECh6ra?=
 =?us-ascii?Q?W868OU6R9iXcQvh2WnD4Eebq1NnfFwN309XvNvYAfi43pmT7yadA8Qac5MUl?=
 =?us-ascii?Q?rV8ToX8pxrQmWUwgDpZkFknGNc4mnOw=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1327dbdb-f4e6-42d3-5370-08da1efb0ce3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 16:14:42.9445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vZRAJP6Ojg6JWlTe51qdXegTyG2Fp3uSTjEiQNT7IshpjDwOpRnTfHq2WtrmgLkmwBEAY2LSedSILCfTbtWmUbjeJX+Gem/3UdHMt4E2Jjc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3626
X-Proofpoint-ORIG-GUID: fIibLDHXLBTC_MIyps2jIPgxShVyQUav
X-Proofpoint-GUID: fIibLDHXLBTC_MIyps2jIPgxShVyQUav
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=752
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204150092
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
[OP: backport to 5.15: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c   |  4 ++--
 net/ax25/ax25_subr.c | 20 ++++++++++++++------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index df01f790a34c..3116d8d1b5cf 100644
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

