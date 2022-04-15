Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A1C502E71
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 19:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344030AbiDORww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 13:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344184AbiDORw1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 13:52:27 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD18759A6E
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:49:57 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FHjqLK031109
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:49:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=RCk1BBwkc2IJSQ6yb3h2PQhM/r+57uwyNOSc9X870io=;
 b=dJWLpY9YXhx/frYXy/znF1MTtWq6/2qtj7hXvaq3OfpCQ32mfTbW5vzBH7P8aCWt2DIx
 Ooh7HAqQ8lJ0kmAv7/20i6f/yils+2CGPKV7sYMV8APr2LcELAXnKmJqhrPb3VnbIUz6
 CrvO9ducb8kIWlAA1hov5Qb0bk7nu//Hlx1m5Hb2ZIVpo+34rVQWEBcYSdrXYmxZn3Ud
 zN5ada53EFXC+waJIt0yHzG9V92RCrJlFWFhjt5i2JG+5w+Tu1c+XVyf/9SvD44NQ7Vn
 7tYKSlu0WlyaiNU9d5K+E34pwcrjF/CHfC++wBJfyG3sgvszF7/p33MCLzWdV0s0DX3u JQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb9nfvu71-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:49:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ROTJGLIXZSGARIQc5izWR8BYJ5yYLhzWRnjA1Dz0xQHyoEmGW7kgjYzR2t7syIcmVvSx5hACTkN/rTtoFSdsU9qF+P7fsPedJaFCOZBK6+swtiyAy9lEQSMnJODE8Tv1q5zMO7zmpuImk60RknkkZNmHn5i4h4mC7OK0rCTzvqhjeyT705jkU6JJfn80uIOUYsXwp52WMcmUbH96LCeJOFz6ZE2XcVERyev9fEDuSGqJRuJUFfShljMh3KpoEOvKUHrLFQvNrymVKEVqCqa89qqlGqAc0HlelfABRCsFOPcVYwNuGyyAg/3gCwP2QIv7a/97k/1Inf4j9QMdTJr0Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RCk1BBwkc2IJSQ6yb3h2PQhM/r+57uwyNOSc9X870io=;
 b=ePd006CTLlnU1i708GfXL9qG5wMiH7p5Uef/4oPkzB0q72HViF6/X/RMMz6kfl550CQdXMtn22LLX1/SpCO75zozBw2UxC+9b9s6E7iBLwO2LskFt5OLSY2ZR/lWdCmakM9tSsKr94kaTGzz5Brx6PRjIMNiYjRW57XrAqrmgpnwsQ83L4+/m8Hh4eXQKN2icc5PK/MD/3g1dQOVPx3RXLVQkhfAm+QNsMMTC6RAddtOyTYSDkcGBi+C+4hHpQbaXvPgaS2qbaLMceWaPY31gDSYeUSdVV9QdtnFE/6ZIKtOZoo2+gdKcKp3UtjwyxjsnDbr8LPzTHnQFqJX28V04Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB2697.namprd11.prod.outlook.com (2603:10b6:5:c3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 17:49:54 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 17:49:54 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 5/8] ax25: fix UAF bug in ax25_send_control()
Date:   Fri, 15 Apr 2022 20:49:30 +0300
Message-Id: <20220415174933.1076972-5-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415174933.1076972-1-ovidiu.panait@windriver.com>
References: <20220415174933.1076972-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0217.eurprd08.prod.outlook.com
 (2603:10a6:802:15::26) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74ebf112-6410-4fa2-1ce1-08da1f08592e
X-MS-TrafficTypeDiagnostic: DM6PR11MB2697:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB2697E5235AFC7C5C3B36EDAAFEEE9@DM6PR11MB2697.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MMZbYsr0gUAB2rOvC4hM4hmYHT2BN4e49maMeIYVsBfnAJNZ7ypBnp5FZB86RAYeAv7mclSql9F2eszUcpTZkequJV/oxLFCZWHV0UZOnYdf4QR1OyQXvVnyFTlqU18B/UZQk0vaAtfKMeXSviH6sYgrooGxEDFpikJ39znlqXtlo4vX4RWbS1KEkkhTZUZMSIj+pn0m/O/Wzpl8kzgTg0dSlb2YR8FFn3rcYgAs8C87bQURMLFtVVlcVyShN9Qr+uuQ0aaHEIiU9HRcLyYWTX0qWx1hp3/76hblmYFkej0pr7yME5f+nrbah5nAyzaQo6rgnTOqN8oG0sj2j87fk75EQltN9YiFFsCqgYQGhW5cvhklVaU8kFXAhaF7EmpKKQ6ckvO5Vkomp0u2nu+rdEzLRI/OtEvnZovAnmugZjmmf+dh1vVzzj0hAjyt8lRKTXrN5VH7Jzh5UR89KTRY4SKXKOKpHurZ/LnE6O7hVwj7I1Y7zMQpkKkhdfMc2pTAK9LVE+S4LN8DnOMWPoY5CgnOMF4IqE6QUzdGKr8i0IWCqOSJsoVSwr7nxtIbEH1QxWgiZFDCk2+bU0EvCjr9+4KaSaEvb5/YnWPjVpF5SPHRJCSg1sR5fuoTLqmy4B9yp9JFA0Fsp+NEvXH95viOHMvgxnlg433+L5KXJeHGd8gK3f6G9DKbhmnOVYmgUIj38jqgOU28B8jrL2LlolCJkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(6512007)(52116002)(6506007)(36756003)(6916009)(316002)(6486002)(86362001)(66946007)(508600001)(8676002)(66476007)(26005)(2906002)(5660300002)(66556008)(38350700002)(38100700002)(8936002)(44832011)(1076003)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2Mj1Yp7E7DinOOe0vZVFm5QR9B7DBIP5xzaWL0udLg3I4U+TwSWDZ4rADJ1e?=
 =?us-ascii?Q?jzbmwRUJrLUZgXYa2cpkRda63wMOEJKzMNn1u+1KUX+gPnS8z3Rqf8H4eWy/?=
 =?us-ascii?Q?HJHJxpC8VundcIRE85o2O91vv2k8cuHQIriohzgbBBhjcC8NDmKwLL2/8Jql?=
 =?us-ascii?Q?5hnLBq2OjjOAoTWiQgARifmFfegXqrlD5q+NkQn/X4eICbEC8gL3fwyhAVUq?=
 =?us-ascii?Q?4+C8Ew1NVHmn3ftDlY41C/V/TinQz0K1Posh2rUHrhabgC9klzugiVkk3Ief?=
 =?us-ascii?Q?RhYqCWcYYJaiYuvmk8vxDoaOuKYYykYpazCdnzHlnA1gkSYK9XoCY+kk5RCb?=
 =?us-ascii?Q?OpCRck9LRG1pa96UTr1eDHL0Y0ywZoIvYwnZv4JRSgUumy4665zKVr86obLg?=
 =?us-ascii?Q?cXUE1Q1JJBxGpQElKUHAbsZZir33NX9dHijp+MPCamGwwTt8obWWdB8bh99J?=
 =?us-ascii?Q?lhAX11YCr5SBIJjhyOMwcM5z8uoH30bRui0bbZrxrJWynkNb+thNpY8TzJir?=
 =?us-ascii?Q?LHaoc9u4hR9KjhevtFjcwdQokO2M3ICu+RYDiPuRd8XFMt1k9Wji6Cf/UH9V?=
 =?us-ascii?Q?wEFywi8kEywkwuVaJ3RrgLxANbtgcaoWjUksbA0N8YNAanrqrQaiqhn7SqoR?=
 =?us-ascii?Q?Skyo3IUVoYLp3lkyfJl3H9JP00UbzlZ0ODtrPB+rnTAkTNscYX2+ZoEl33oP?=
 =?us-ascii?Q?RywwVAVVu1q02VdIw0593wDRI2YAuqqguFRUAeg0INLS1sWtqshlNHy3HwCk?=
 =?us-ascii?Q?3HLuI63qCEjLw1Dl9iziH651AjbFoNKrKiGVd/gbVYceRcpJKTlGkwX9BRYn?=
 =?us-ascii?Q?z3wH2mplh9AiomBPWZxmGCEOLZ2AOoOB1fY+ouRzPci/5xnmqPkMKRN0/s5S?=
 =?us-ascii?Q?Z9bprzD15lPfyaHhQDUO0LxPT1/d1awgm3VwcR3QT9UQ9KgevPLQZY/4KzQ7?=
 =?us-ascii?Q?jnFHdw5wuRm5bXn+YPwRmgYSAEQDOtMQe+aanAMnYlrJUcsVxOE69lw/72xa?=
 =?us-ascii?Q?f16cQwTFlc/qYmu8PcrlkPZz2qfC/F+s54NbOkjPdyqOaGLnI1boxSSbGw1c?=
 =?us-ascii?Q?ZTd47sJGBv2ChX8hFCqG76DXKVk49JrPEUYTsEp3xn/IxkusHLd4JtdP0GK5?=
 =?us-ascii?Q?trmOtEI5aQYrTaBZq9lcvytL8v0Lg109TbO4xbSaEXMfGcUwTr4EO67rAyKX?=
 =?us-ascii?Q?YFl7CmUw51QdXdIPTJegxSPQvKwyGfjD+Z2K/frePCwAjdbIGuad/KlmryP5?=
 =?us-ascii?Q?wLDDlocqjH/mJazYtRjVdKpqfpkVjYNtpbjc01a1rLNaw3bU3P99hJNce+02?=
 =?us-ascii?Q?c39mLfbKfh++y6GZsGUV2EFvGHYsnDCyRqo9/88SUTs/b10KkzH7mY/Os7mA?=
 =?us-ascii?Q?B61l9wOfT0WtWCkoz2q428O57Y5Zjv7jfSUhUSAyDXw88CgnmEPLdHJFpBZ9?=
 =?us-ascii?Q?dAWwyP7EHlU1iUHWdXgsxuokD+/mRU/3Og/v19UYFQMWoYB2AnPvAPibP17h?=
 =?us-ascii?Q?P3BPCeXzlHg6JziXuzREFBnz2pTTRu6cwP9xAXHHCIzFyvDlUp7timtMrsqA?=
 =?us-ascii?Q?eSygd7Y7W76mNofuWH+vaiAX1sLid0UCkaOymHA12nlRk4HKOH6Axzl83WEF?=
 =?us-ascii?Q?SW8Ddt+JIKIDzoFPwDrg2CW3M1n1jrBdJiqkqHq0dYYJ1So/HgTj6sM7ZUtW?=
 =?us-ascii?Q?/DWW3/iNZJYmXBRTAg8iP6vy7K5QpifgAOjHxnE7rHPS+H2+lq9Cmgn9kPG+?=
 =?us-ascii?Q?45k6FnyzrhYdK+zlTQzbSU1aO9exb7o=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ebf112-6410-4fa2-1ce1-08da1f08592e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 17:49:54.4302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eeSFUpNiR8iclWLjqqdB9znKkATF/EUbdgygUuv2zVJKy9uKDyd/zft+QuGGNVKvLD7u2CuyqsXW8mVvGAYFbG8xNz7l+98NPKGJJhWuS/o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2697
X-Proofpoint-ORIG-GUID: zz1qTYJLb2_m9zFIMtjTNNzexAU6YDiC
X-Proofpoint-GUID: zz1qTYJLb2_m9zFIMtjTNNzexAU6YDiC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=721 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204150100
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
[OP: backport to 5.10: adjust dev_put_track()->dev_put()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index c2ac5a43c641..f6594dcd36a2 100644
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

