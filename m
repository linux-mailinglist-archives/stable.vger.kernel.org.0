Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC429509DCB
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388466AbiDUKlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379782AbiDUKk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:40:58 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BDB25580
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:38:09 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23LANwFc022458;
        Thu, 21 Apr 2022 10:38:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=/p1IE42hYuY6rJ39QgiYvfGUWQAb8rsSkNc43lTPQA4=;
 b=skGUGLHJVZ3SdXGpp8MLRQ7pfhue/c8EsDV2DhJZogoPRmypJv3VA51DQB7r3kMavAnc
 PxlzvqOvFQjuD5dU74njrz6/KI+E781hBbupZod3G70yDNKZMZ5RkQ5V4VVDBHwQiZdK
 W1xizmnkQV1+71BixOhmY9Ncx7uf+Fyc95vpxt611PImbRJvX03TWt8ncJbzeJwTNQkP
 W4Ye8qllrQs2uoCnp3IRg9WO2seUIqtgk/B6+Ch+DsI3WWFCRoOsNbPIBtv/bhZBUBb8
 6wgm5m/UANH1dfp8piK8fISuEfjaGXQLiRfZnDm4VZ2q8zoZvote5eIQ/mEvzaK7wIfZ JQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffpj2uqbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:38:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QrNhVMdIMwBNrLJtwFkDEgP08DxSPYsahT3K+fox29+XYSY67tViSQ0EvUc3PLzmEnOdsSqOuxNLKJ7qZEC/geTUnpOqt2k8CGE0j3dDGrYW81NaTFiphg5+mu1S/AAIN4kET2D1nOAibgY/CBokhYPy2bKCPZxFORfOBDKUQlwB1GEY4sgrU8yX5VIwEMU8VCT/COyNlFeXSSF1IDzi1M/h+dzn1G27w78myA76xSVchqyLh53g6zTLmvE+5+nWlUr9NOCtkgqQeX6hBZakkc6IotHjF1NnDrNvd1tPuwbL7IBtPH+sgNd+6tTwI+L/8vDD/E1MSjN/CntfBODNMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/p1IE42hYuY6rJ39QgiYvfGUWQAb8rsSkNc43lTPQA4=;
 b=doTLudCPhPjHn1Pt7eB8NHsh+xkcSpk6Fho9+74ij1Um/guu07EWeo73OxU+9Fo6WSqJ6hoZKdAQi63AC2XzRDWXTwggmnEM5EnCqPmdhYHFE7KjX1CY7PvYkxine4DtVQjhUiTNN9mARwMrYnYO/NkBWOddo9QmXc0z/8NBkbT6f7UKpgCUcwY1bB9S38fhiOoMeY9Z6CNM72zSMl27ko2lPy1JQT0gurmbenuuWpOkSH9DgBEvMWjFPoSIRE3D25hom5MtLTkmPIt+fAOLtDuDnZGLzAWqC2VCQSkV4+w/33i+L3S4zP+ZFZzbxnx/iPrNxm6KCeUulROif7NKMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5406.namprd11.prod.outlook.com (2603:10b6:5:395::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 10:38:06 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 10:38:06 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>, Paolo Abeni <pabeni@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 5/8] ax25: fix UAF bug in ax25_send_control()
Date:   Thu, 21 Apr 2022 13:37:36 +0300
Message-Id: <20220421103739.1274449-5-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9744e995-3050-44b2-4ad9-08da23830549
X-MS-TrafficTypeDiagnostic: DM4PR11MB5406:EE_
X-Microsoft-Antispam-PRVS: <DM4PR11MB540627C8DF245A686B29A099FEF49@DM4PR11MB5406.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7Fw9O22tScXx418BDoEcJxiu+pbSRHida9wt85Q2npaFmBhuioVGo/Jqqm6Q2I8WhqXN+8jPKBmQfxln+iewUMt0kCayE/bRHmsCwXREp04syqo7r2BWyICODCr/KN5StVJ0wYMaYdXJPlxCo8CBv57DNAOOVcLqhbXxkDatP8SYiqfdKnm3Z29eE6FHtSp/qCdwHSQK+VETcQ0HvC102bE/PyCTVxGW6skEPr+aaXZhxHoE1dLPrcwcBvrDKWaHcvoSYIdKTjrPMA4fU5OYJnwB4vHomJk3kXO7F8lg1Wu9EcKYVTQjh5Q/2fvgTgcm+XY9vM7kNRVdjoZMy4pUh26FBFOHIo9PUh5y5mL/9mGOerxyrjcHR01Jw9oa6rCCKz+XzEEvTp+NiaSNwI9yha9Ufy5RY2Sj8jQuDXI7P2B2ZIzt+Depb+bK+Ifb66S6Q8N23Mgzv+qCGgyf9V+k+ZSUnpeYnlM5Z0CATBOe9xzsUY4olP+Cr9oHww7Y+B9lStmltqnxJ30eHX6TQM1Zsm0vijTq3gesZbVCiSvViXMzouN06H1AXpIDpHtDiwP2vXiod5+KoKXbGOdou4tfgK1vxQW/+JrIXy9eMTdY1T8CIcKOAS21gVmyYs9a26dWttdEIBPVePmtHlBLdbyITP2G686mi5v8Dk1r1pcqDvREygh06r9g0E7JtNeYmECfj5n7drG4w4riwPP82cnZRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(26005)(508600001)(8936002)(86362001)(6916009)(316002)(54906003)(52116002)(36756003)(186003)(107886003)(4326008)(44832011)(66556008)(83380400001)(2906002)(6506007)(66946007)(6512007)(5660300002)(1076003)(66476007)(6666004)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BOsgqXaUz+2Wb3lBbjgExdaFOnvjAcFyUL0G/e8Z176DQqruIxXKesKbNcyS?=
 =?us-ascii?Q?Q6C9eUFcx66zJj6Ek1aiFdnhoCla2yNsiQNjI1cNfk74CZWcTi59YYdl0suZ?=
 =?us-ascii?Q?d1PUFhmu99V60IeIcO3Bs+QbYihwgkEIvkitp3kydvWb259CGB3nMbwRb7TU?=
 =?us-ascii?Q?/5wvPpEQ9GLcCukHsxR4QtvhEbknRHOjh5k8Lcv2ZDsvtSw6Dsuwm87nwI6q?=
 =?us-ascii?Q?gEeitjFPwH6PWUntD2f1EKbMGVt11njLL8XjysZ/55LuaqPzU5uaEFExSNTU?=
 =?us-ascii?Q?AmmorBDZbvlGnlulxccIdTUkYQplEfX3edvr8tQ0/NMHsUTtKD5Zh4wqkRpZ?=
 =?us-ascii?Q?4LfJZiURoNPxjspzIjijBf419kQSJTO5pLKUOf+MZ6ytHx/54mJpuFuuMsLh?=
 =?us-ascii?Q?fiVA5jtI3GOu9JMZe7OVDEaNHO/0Lsaf7pf/oNPZ+/cdyI3iOLiVMJXNNqhi?=
 =?us-ascii?Q?4y8nLJBQWbs8nMgIAbNTh9i4wSQQQ+ngQDcO2BQs1OP/9gCoQpxJpSdg785n?=
 =?us-ascii?Q?XHOEFTzwMD07i+aCR+bx1QOGycICzEN3BA4EyCe2z8+jRYICIJiR/3FzoGnj?=
 =?us-ascii?Q?Muam4eM+o4e/Rbs6M2dbkKOx+MPpEN4YV2k3VdU/5bP1qh3duHjlHJzt5PQ6?=
 =?us-ascii?Q?WRSkBwuXjP4Wx6Elg/ERdYskWo3nL9B5esSgfPGT4TahAGgT/WjR1IUiapUO?=
 =?us-ascii?Q?31uAlcxS7/LkTLjO2/BcnMxsPfnX/+9ZSibY06XXXpJZ8hnLVoxMxS16S25+?=
 =?us-ascii?Q?9q7QqF0e105OzijpBECIcw+3nqNQA/6pPKmaDgtM2/ef33k/NwVRhta52Rji?=
 =?us-ascii?Q?J/QhFwg2PH5hIU380A6Kh/ICvBzOshL8GnPM3/Fn6i3q/sKMjNFy9fb9mIR4?=
 =?us-ascii?Q?PLpQciCW6xTKxi1OnuaB99Cmci0uyzZC60Iwn1CKECAi2AVquvOM+mRRO6TR?=
 =?us-ascii?Q?EORg6wMehzs+XeF9MV0aj4lhL22Zuw1DGaHqDTPE9uCVBSPGGdcNzU8f3S8/?=
 =?us-ascii?Q?40SP9wKcMcNMtRf95ozzRDgxH6Njz0+KFdWYWAF6QxavLqQf0ugQNk+2cLIB?=
 =?us-ascii?Q?wJCOPsPPKHz1Wc4UpsqAtDGwlZ5zu9EABV5WGbUgf8oU46mGTViLxG4ZLyAF?=
 =?us-ascii?Q?7GDDxZ9CKSJpL6sLxLQENo4OARIsKq7xeOLEQBUNl64fz3lu3HqFnpBKkxX2?=
 =?us-ascii?Q?oWqoRZd35KFr5SQk92QtmOQMxLyWQx5SI5abvRKmbBpQx2cb8K0kq1Awg/A6?=
 =?us-ascii?Q?i1+LHXVBlADTOOWcFTSCT1PG87cMp+TV/R4jeeOzN/qnMpCBw67uOtvbInf9?=
 =?us-ascii?Q?SkWg0zZi1O6jEBFl7GRwzvD95r8HWQEnr+A4Z8SsmfbeEgUY893l5VoC7i6d?=
 =?us-ascii?Q?I59/7g2sFlghk4BwozP/+4Db7EnEg9kbnEq+PtcqDYTeZEnz2C2+af3e92yr?=
 =?us-ascii?Q?4Bed54PRqkumuDp06sFaVjMoCULkJVx6mqSSR2do9tqyhuOsct4nkFNKFy9/?=
 =?us-ascii?Q?EZf3npc3JODJoT9h/isygnWP9nHksYC3WsVmUIbU/S2RBTtraq7YOHKpa15y?=
 =?us-ascii?Q?NIkRdDqy1AQArXYn3S+w0INtem6/ixuYaBm2msthD0nuFJhKn9uZhfWkZ8XC?=
 =?us-ascii?Q?WF9MfA62EW6uckNCtM0LTotRx+jDU2fFrGQcnGUJ1+5J0JNisFZ/uHZxPrKD?=
 =?us-ascii?Q?57QR1CQCq4t/XodipqHBd7fJMx+UXjIgPPgkuvuh0aHiFUxV/OBekgxpb7E2?=
 =?us-ascii?Q?sjEi/80oKK2ViHvAlu1u3zGTNiDlLm0=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9744e995-3050-44b2-4ad9-08da23830549
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 10:38:06.3817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V8UD8PyHGCSWWpB78jituVDNPMdbjwCUCAdcx2jWUuVoeCRp48gnqey1v65BancVYQ3GJ74xyuE/nFrxkiKf7O2W/jpi0oVFyzBGdYzok+g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5406
X-Proofpoint-ORIG-GUID: rgHvKd7ph__SZtBgQbKzh8391zvc_vug
X-Proofpoint-GUID: rgHvKd7ph__SZtBgQbKzh8391zvc_vug
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=721 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210059
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
[OP: backport to 4.14: adjust dev_put_track()->dev_put()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 43a69d0e8a71..ed40d4e47887 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -994,10 +994,6 @@ static int ax25_release(struct socket *sock)
 	sock_orphan(sk);
 	ax25 = sk_to_ax25(sk);
 	ax25_dev = ax25->ax25_dev;
-	if (ax25_dev) {
-		dev_put(ax25_dev->dev);
-		ax25_dev_put(ax25_dev);
-	}
 
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		switch (ax25->state) {
@@ -1059,6 +1055,10 @@ static int ax25_release(struct socket *sock)
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

