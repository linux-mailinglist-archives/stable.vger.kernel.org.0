Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD653509DC8
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388464AbiDUKlF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388465AbiDUKlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:41:00 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9383C25C71
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:38:11 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23L9auMF015749;
        Thu, 21 Apr 2022 03:38:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=7p0Ld6EOQG6qJEG7bmLYjWJhARKO1s4up+dYkVEiOxE=;
 b=tBlWuqVSbe+y43pe6ZLGrr76fC3gV0EVwax0zMRMAtU80dtVu4S4ViwxAMuFr+EK1qwA
 vrtH40L7lrNMzuLeLeDlHp5wZFEPnpQ88yhSGTbQGXbbhr7oPtoR3ryQkHr9U5vNHCkn
 JqJx0yI3n9kzvwdjjeOnbVITpAaEqxRn1pVrknYBvT0tWErmt3QXHAeLmNwhx0WvLRKU
 jXhLv104H+39ZtiNiW7onRC0QevJyvsd8O4NhgQ0MQGtE24crgGUk5hKHfjCP2x4Uu8T
 /dxUk0OKJCauYPhtn6nNuXkXe0S174DwvowFGyw9Pc+ea+rsLW+CamY/HtsU1C8/jGZ1 7w== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fhmfc1x5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 03:38:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8SR5OPBfO/n9BZOlwG2ZDP2c45UZEbdX4KarDiamn03aH4Xv/yNK6X48YIlryOSMSuakxBk1G94zzg77sqGyNILVsSjxeKZgq6KJenJRCKeYxjolPhQKntTMOQuUOAMRpLnekLHL3MrVA0w3/7Pmk87timZXAdbiYlaEGUmx7ShjgxlPo3JHW2NZfgcSi/o1IGZ+PuIWUPfXpjJ53HURU1AyeVtAHCGUyZ1gIjAFIqa67lLdvz4xci/M/YTPqdjEtHRXxFrH8nk9/FtdAUIBHgagAB9mW+uMpvohjfgo5Y/5xqB4WplN4uhAOU1d7f8QbsX8vlzyiOZr3ttkrJEKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7p0Ld6EOQG6qJEG7bmLYjWJhARKO1s4up+dYkVEiOxE=;
 b=baoSD+5L+o7+/VlSg+1X6kRKhuqaRfpTy5BBxjMDaRsQFL8KC/Fs+pKo3OuqOaxUxCFQwDqFVzYRu9+Q4C+jckVTblGeVdI1GCn63IlDTIwXg96Gwn63h/GPqt4K3eBD1cuQqRpYsjfuIZMj0/sp7EJkRoR0h+72lIg94crhTY5HmLUcLWlx9rm/7R3pwZqfCe6ESp2RqTj6amuruTwoxg6y2GOJn2I6i+nX+4OtpxBOPyIQwidGebXqIvmrENBn7dJ/6K9/AoYdPDhXfAgPv8hVk+0lLX1ZO8jttxRlarY+pKiYT3qk2iiy/WPy1vOJ+6WckX27f1AmNbJG3lZKMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5406.namprd11.prod.outlook.com (2603:10b6:5:395::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 10:38:09 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 10:38:09 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 7/8] ax25: Fix NULL pointer dereferences in ax25 timers
Date:   Thu, 21 Apr 2022 13:37:38 +0300
Message-Id: <20220421103739.1274449-7-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220421103739.1274449-1-ovidiu.panait@windriver.com>
References: <20220421103739.1274449-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0024.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::36) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fb3a6872-069b-4ce5-492e-08da238306d0
X-MS-TrafficTypeDiagnostic: DM4PR11MB5406:EE_
X-Microsoft-Antispam-PRVS: <DM4PR11MB54064A56681C1A68704E5092FEF49@DM4PR11MB5406.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LadcKVk3wk0RL2kCFT5lA/Sm9h8GiMAnKn+3u4HqzmQxbD2QF05RMC4KZ+n+dP7C6rnSlCArji8C4xSXbe1WPwH+LEiO8yqBpVSCxksgm+RG77O8EsyZw+0OXm9sPdXX+a1T6z41C5hP0zbM+M0AOGNs0rsTjwEch2q1kRdKK2JBC5NTn/WoOpUwpLFGNhC9bRmEvdZWW24UyaoL8PAoTTsiOesEPkFZCJomD2v83d2wcDx059MQHL8CjwF5VTMnsT+ibCBMxk1OMsZAUI4zj+SVeC/5/9DXqXrmULaucFY4C74k3/zxxQiU610kBPLvOxiE7/b8GnJx6zqsW1hNVyuS5Tj8TGYveLoHNyjCHr0HN+QOMJWA/sZlNSWfQpbkghuVM2IIkvs63jVrdXPi39DfSUIllmxoIPHKMhWcwaoIKQ/SKA3JTQGJEmaHEBTVqQrkvuaMLjH5YulvPL3XJXn+QDQTpimRCcoRErdDn35NsgJC1v/GXiUNJ3cLSa/n4yGTIzCyTyLRuT5Z2/tF9YSaIRJEX0YUYAOJk6DPG3HpBaou78qFO2nTnrSv+YdgHTYUottMCvTMVjoytihbltz8N2HSkDXIURMpA8OnDyyVNL+n0n4yQkOy76Pjr3WI6RwmnYXy3TMY706ss0nyDr9l1YK7pQqYaOU6Vmq82p+F+AitiXxYxBjnucxs3Sy8JC0rVLP/LLehUiGYtHzsXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(26005)(508600001)(8936002)(86362001)(6916009)(316002)(54906003)(52116002)(36756003)(186003)(107886003)(4326008)(44832011)(66556008)(83380400001)(2906002)(6506007)(66946007)(6512007)(5660300002)(1076003)(66476007)(6666004)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nudxq46Oncdp4RLDXHC/Q60u2EYLnRoBiyk8CCXGOF8/7oDfHCozeWRmdWwU?=
 =?us-ascii?Q?/dnK+rVn0T6XoTinzdoqPcxB1I7JhPsXkcvf1r0t0GYMQ/wj6LQsiVZ7ni9+?=
 =?us-ascii?Q?5YH4brVw+sY1+Ab/6IdZKusNJKqzmqDCapGJLGKAhA8m/uGrryle3/ZM72WF?=
 =?us-ascii?Q?u7tZ1stEEW1clfQSPYDfmcbxMJFBEuTpFAjcVCCEax2MU8jZCb6HkNTPKFHn?=
 =?us-ascii?Q?+Ug+AeQipU6rvnOGrdLQAW1ueu1L/KQ9hg2mx8k9iH41w+JKQCVf5C3Gzcho?=
 =?us-ascii?Q?t3Aq0VawUUkLCvPSUV6ZYHW2q7eMi6Sb/WCFZbhr/Ai0e3ejqTiBKCGhfiGS?=
 =?us-ascii?Q?Tdbwx6jykEKXQd5X+r7phTonERhiuOhrfZ9bOfUZV1BPzpu5sGzPgxQA2jYy?=
 =?us-ascii?Q?rc6BG8x8591bL+f40UX3jVk1fvFQ9Zr7z3sHqYcXuLOXZG0JlmF/OxZXjdPk?=
 =?us-ascii?Q?/GgfRdvIfgBOIdLv7PAAcm5UZT814DEbHEBDH1BUNN9oXnpYiMVOXEUOH/M3?=
 =?us-ascii?Q?NVp9cwFCgvu3SLbXCsMqwEhAvCLNB9dp7xy/Z/OWECnj9zsHcdQjRkTkpKG+?=
 =?us-ascii?Q?n4Tug68/xzKNGGv+Vs1MBVOAI+Ga/gK8beysb92OS6iVVFpLV8DqB3Hq6AzW?=
 =?us-ascii?Q?FaAjsL1wguY4KToW7POv4NZ/t3D/rXwwAlrl3IZHVGCeutReab0QRl8Whf3u?=
 =?us-ascii?Q?laj5qEJm8Dad2LuwWgRKYWMcylnwdl72syMyRkbeonP0cVMrBbJPmRvq5U5M?=
 =?us-ascii?Q?nedbSTrKsaFAOPjoiDrtfDaoKIi+T9lp4+sd/FX0/z83bvsqRUo666vJ+jIq?=
 =?us-ascii?Q?3fGUKPHI/dbCXeiSgN/e/QqTzavR/y5lcik7uh4hveuWjzlOu93ryLG2o138?=
 =?us-ascii?Q?Ck70gYgH+guYPlpOPQCZh+ADSEUel+y3aZfNMlrOFjIshrnwL4K+QUlHOZ3s?=
 =?us-ascii?Q?75sqWqtkF34tfrOa/91Q1yn7bpyuuclc3XZDDVcFfb42kKM6uWIw0NRDoYsG?=
 =?us-ascii?Q?DFTKiolb0PGr2NHXbRvDLEZOv/cGSjfOJKA76ZUJkyaowsr7vigs4HbXqRRM?=
 =?us-ascii?Q?IPvmOpEJmsNTHrJLm/l2Cnphf9bqwO5hI3Ltd62A8kWcwarexN33c+pcAj/o?=
 =?us-ascii?Q?6MEm9puChTn+PrZYEsrGUtD2VmrBY1L/upJYZD9swAvjjbpvOz+mMlWlvfiT?=
 =?us-ascii?Q?EI4T+W6j19LeNBs4wEcvXQo7PXuSB2xKih9HS6OubzEUm5VxAJ1zl+3NcJ0f?=
 =?us-ascii?Q?BMv31MNGDKTxTaStC9UC2STqUd2taQcmHGx93B9PnBnvd8mb+KHwFWbryeyX?=
 =?us-ascii?Q?Ya+84duV9D0HpEu2W1MUATn3nim9cE9IPtEwHve18ICZswPqmzmA0rXTu9yk?=
 =?us-ascii?Q?+vcDYgulLIbgms0gp9G2tWH/edF2uadZ6DvYp8ZTVNEDD5xqRHbnqpDWBWJy?=
 =?us-ascii?Q?Y1BVsiKlIrB6iEY9Fd8w64QyohyWCFISXSWo7sNT/jt4NETWZgdY9ULDTYYV?=
 =?us-ascii?Q?1POa5s8lW1fHqqnFXmcxDLj8GsAXT9ild9ksRM6ivv/JvO0CH8TYiL2+T2v/?=
 =?us-ascii?Q?IrThNIipOGn+6GfVhJQtW7tt41tZUIYymKCZvkUrav5T2COR2qfbViCdUD0H?=
 =?us-ascii?Q?7YUn1eJyJhMSFyTHz5OE6jGq/kgCYH02J/yMYhLOvi4fy/XZKbpw/kYqR3Wy?=
 =?us-ascii?Q?J5pKbiuf2OaCckhxHugP7c7P7CX/Qy2nPGzZfV29WDULcO5FyeLzEjCjdUVz?=
 =?us-ascii?Q?XCDh3AWd8wcPNs+//vmZvJvB4+371wg=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb3a6872-069b-4ce5-492e-08da238306d0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 10:38:08.9441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /u/lSTFrEv7IksRGFNnWKEIiJlXcMa8GNzH0mkmXdGXD0vSjt2UsiX6pZ21DBxtNwXukxO2okn2+R9pjyBUOVj++jyKKXnGaB9EEI67Uzo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5406
X-Proofpoint-GUID: 0oOWLibnt5RQKwgOUMFhJRC6zwNwJ46c
X-Proofpoint-ORIG-GUID: 0oOWLibnt5RQKwgOUMFhJRC6zwNwJ46c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=757 suspectscore=0
 malwarescore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210059
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
[OP: backport to 4.14: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c   |  4 ++--
 net/ax25/ax25_subr.c | 20 ++++++++++++++------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 391b17ca1183..008b9403ab62 100644
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

