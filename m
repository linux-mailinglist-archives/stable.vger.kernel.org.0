Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF5B37664E
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 15:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbhEGNlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 09:41:01 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:55537 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234529AbhEGNlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 09:41:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620394800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FPkZa4xuNBv0zi3XZpi285qOOkTCg1kdiqTo4FXkHjQ=;
        b=Qh576gLaNlLtnmSYtWfBV09RGwGVXvUZToU23264sWFqCir4FbiS/8e0pGg3adO399xB9n
        opLf2PZIK1N3KLrI3qVV3tMSaBzCtnfOKqTrn7NSh+Ze+QI4kKV5htz7mnZMUvQ91SMbIT
        RWj0fCXueaykJn4V+gUOY0oPCaqz0oE=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2055.outbound.protection.outlook.com [104.47.5.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-2-9fVI41ZUNM2dLGqqitK2aQ-1;
 Fri, 07 May 2021 15:38:35 +0200
X-MC-Unique: 9fVI41ZUNM2dLGqqitK2aQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWI17/E6S8zydLWV5QHsssT3AvW9sv4ANROJpT1JRMM9Ommv/B1981CJ11XCeVaCkl17HGV29kLKC1JiRm3czVhV64BAF7qE2eKbj4zKR6P79Kcm7Gbjdm/B+ImAK7vrRxW+CRBWYXj1DYgo/QbDIXqeEWbp5VKOrskMhjQ0CdJYpRKVHbSt3IeRuAngHpp7AeTjHJ5VysmGv2d0xBz7V4+NVxh5nq4AJMug34kb78a2MBaww+QQwvsEkqmPWAjRiYZ7in4uBetj13zsoNeKhGqcsxUQ3vZMux2i4DCWiI7r6aKD4aKavXwU8Ags+t0cPDrs9qggXIt7NAYRbRXdhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V2OMTuz9RU5/6JTsJ/A97oSMRAzvsIQkdiluMAPTQ3U=;
 b=cjpGE8xduaMz13i5lbSboNxCb1JtrIGT+p2MHsUDZS4toixByar11f4Ek/f2mGIG5B9AzK+P6DYMUt+QxZOFdfbt2BKtGcel51zIG+/5keeOszlZzD8yWoG2tuTu7yrHwXBb9sbhnb4e2Op9YwzkqDCuzbVTmu3EVldRA1h8HFTxyRw3Q/NHSU2HmmU0n53PlTTfbhue8QZlptzPb6z9TWZlBUvcXX3O1xZwtObT1inzgPnrdW2hbzV77S+Das8BbGlgt3InzXd7zKO1n4l67FxdlLlKyKw8+4+b2QfCSpWh9UqghYB42B6IMZ9+BgX8TvFvhPX+vzo7afp75mHM5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM9PR04MB7571.eurprd04.prod.outlook.com (2603:10a6:20b:2dd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 7 May
 2021 13:38:33 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::756a:86b8:8283:733d]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::756a:86b8:8283:733d%6]) with mapi id 15.20.4108.027; Fri, 7 May 2021
 13:38:33 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-kernel@vger.kernel.org
CC:     varad.gautam@suse.com,
        Matthias von Faber <matthias.vonfaber@aox-tech.de>,
        Davidlohr Bueso <dbueso@suse.de>, stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jamorris@linux.microsoft.com>,
        Serge Hallyn <serge@hallyn.com>
Subject: [PATCH v3] ipc/mqueue: Avoid relying on a stack reference past its expiry
Date:   Fri,  7 May 2021 15:38:03 +0200
Message-ID: <20210507133805.11678-1-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [95.90.93.216]
X-ClientProxiedBy: AM4PR0902CA0001.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::11) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xps13.suse.de (95.90.93.216) by AM4PR0902CA0001.eurprd09.prod.outlook.com (2603:10a6:200:9b::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Fri, 7 May 2021 13:38:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7441e129-ac89-4092-b551-08d9115d68bc
X-MS-TrafficTypeDiagnostic: AM9PR04MB7571:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR04MB75713E9C24878EDA73FED25FE0579@AM9PR04MB7571.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RVeovXwHC8qxcuaEu68BnmCTXXsPtrh12Wb0vTElpFltIAWVovKmjBlhXI2L1QV/vk4xhm9iX0ygzKPwu5Pw/cfTipyNZd9Wkjdpms/w5QMNRetl7rscSk7mzBpsSbtGZgbFcTlhm0kD0vN2aU1XEKxX/qAm1wWbFZk9xrxWuSpm+VA+qRteuTd1RBjG+QBHpN0YVlMLkrgyWysqqT6Tj9ERhtCK5ETuGuvy8BGmIxrKdNVDs83psjhQuF+kSzurZYMUA+NPU8BERbeRh814j6bIjfZQe0FGWWD1nBGzm3yJsK9lFT5PVXFGIgmpBmueOFd5WhNCJa7Qd5iZx5DuBLaGXhS0CCXiYpIM+3too2tyslO4+QWQHkJl4Uusd+hiJoskn8VQM/X1QaHViP7qa2nKFFkNwBjFSe8mab6sNhFOLNup8qFVjfDohWS2L/26PqgDLWkW1KtgZ7mK/u9GwM4s0GnN9PjvTH3sAepc4ANq1C+FXW9t8qH3iVBtKAJlDgUnMD2MEAdkROVqN59jb3pCMFmyrscbYOvmockNtBKvjOYW8VOWu/bmugqZtYJpgQKJMBdQPjozppMU6zm1jIpYsFK27zH2Oa5FhOB2RXFeA28SBwyJcUo4QWOazyvJzOuuOnD8LGiG9iRascVtTw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39850400004)(366004)(1076003)(8676002)(478600001)(5660300002)(2906002)(52116002)(6916009)(26005)(83380400001)(8936002)(66946007)(38100700002)(36756003)(44832011)(6512007)(66556008)(956004)(86362001)(316002)(6666004)(66476007)(186003)(16526019)(6486002)(38350700002)(54906003)(4326008)(2616005)(7416002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qMSHi1aMdUHv1CTYE3dE78/dFtAnqvlNvG+27ERiQ2ILCMhaKtGIxHUCf2Ov?=
 =?us-ascii?Q?8yztgxnvq3NMo0GlZNz82pI8idaAgKInUGjD+QkQVytqi68j/A0gBugeIhmq?=
 =?us-ascii?Q?QX9Ivieg8w91z6B9RVWVcR37LuoP5FxG+R23hI8Z37wgm0p855YQiibi0qnc?=
 =?us-ascii?Q?3vBzQPKEeKTLlFaqFQC909loBjKInvEqbeIed313AzhljWm8hBw7/Tu7iktv?=
 =?us-ascii?Q?NCs8jagrXqapL6pf6WQhihLKps6aZmvPshOJIxNf4isJn6oJeXW3x5ay/+08?=
 =?us-ascii?Q?HG04NRtVSzgkUe62U2O5tgC+M/uKbHQVIemVosrNJzPQ5aIO9RKnGsf6fqfa?=
 =?us-ascii?Q?gk96C/M8b371ByWaf3kxJaUao6lJaB3TCRp0ng3wcqXGta0F8/SKqvintf+M?=
 =?us-ascii?Q?sGj/69S2bD75LEiHEskRxP0x9eB2r36LjYR7qAuO588p2K5gVzIe7QPxnpWi?=
 =?us-ascii?Q?xudPMLTcH398MUEXZ7/fAtSt0BILPol1THwl/hBqupjXy/lz4U3LSYlH/BHU?=
 =?us-ascii?Q?3nnzZiaS+ViEZgsfEfUUm2TSco9EXtZJN4GJ+vrZiYQMXJUMOwAwJW46RTc1?=
 =?us-ascii?Q?H6SWmaKq9EkkbKcTCBrVoKNk6AvUkm1HAylPwSk8qy7r17nMWTF1x2FgLUlL?=
 =?us-ascii?Q?VODrW4GpXW5EN24aBUV2jmu33dybu5yDHOGo+a2Lz7b00canNIlbIWHFZvqB?=
 =?us-ascii?Q?HSbUEFR14TUnnsEdg0TC2SyHNlXquxHdmbOIDH43vOi4y6QtyT/WYDVtcgL1?=
 =?us-ascii?Q?+qUuiSnzfRfbC2cSOwnboWbNCQE1fifhEdsEbC8XoK15MHubN+ju36fPLNQN?=
 =?us-ascii?Q?cNoNFvzIGgImoZgJlydOxwsxjdC70CzRHMqq11Y5afobk0BDCl4M44h7XphF?=
 =?us-ascii?Q?5cVFFr038aoIBLjfe9kLedNmHUjQRnYRRdaqgzcsl1UcGENASNahHpiAsp3M?=
 =?us-ascii?Q?r01Ii/0plop1L1yGCJpCpZyGgSo3GOViphwEtuKPO5YTZGlyCZ8qCkN2U4ff?=
 =?us-ascii?Q?RGgz2eNIXPpZQ45bs6bfXev4+BvyoJBJUlBta9JdJ+oeGbFitAxYTKcR6i/v?=
 =?us-ascii?Q?q91HPZqECerMavHLKg0UXBgSLfg8Jnd4NvwVgTwBpDEDagg/unrfWJkHP42j?=
 =?us-ascii?Q?ZoCB2t4Wdt8qegsGq7LKTNhpl/Ykld5az2CUTE2pJa59+4ea5yuTWZ0wUX8N?=
 =?us-ascii?Q?vOo2WvD9lKAaj3S4TnYV+sLr+botXcmnBQv9ipC5ukn9MevqOMmecvC5PiFL?=
 =?us-ascii?Q?U4HJS1MEI5BSQyFsy+H72IcFMivpvn/0qa32xGAiXPo7nCgkVnXePem146Oi?=
 =?us-ascii?Q?K+9ssdIHjDB1cOyPdxHoW796?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7441e129-ac89-4092-b551-08d9115d68bc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2021 13:38:33.7813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K1HAdTiHClhUamrWboXswL6ZAJ7Q8pzW2BTiVblleaXrwFuXULqTN7YlkjS5wDBPdPdpFjy6YmfDkWHaBL13DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7571
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

do_mq_timedreceive calls wq_sleep with a stack local address. The
sender (do_mq_timedsend) uses this address to later call
pipelined_send.

This leads to a very hard to trigger race where a do_mq_timedreceive call
might return and leave do_mq_timedsend to rely on an invalid address,
causing the following crash:

[  240.739977] RIP: 0010:wake_q_add_safe+0x13/0x60
[  240.739991] Call Trace:
[  240.739999]  __x64_sys_mq_timedsend+0x2a9/0x490
[  240.740003]  ? auditd_test_task+0x38/0x40
[  240.740007]  ? auditd_test_task+0x38/0x40
[  240.740011]  do_syscall_64+0x80/0x680
[  240.740017]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  240.740019] RIP: 0033:0x7f5928e40343

The race occurs as:

1. do_mq_timedreceive calls wq_sleep with the address of
`struct ext_wait_queue` on function stack (aliased as `ewq_addr` here)
- it holds a valid `struct ext_wait_queue *` as long as the stack has
not been overwritten.

2. `ewq_addr` gets added to info->e_wait_q[RECV].list in wq_add, and
do_mq_timedsend receives it via wq_get_first_waiter(info, RECV) to call
__pipelined_op.

3. Sender calls __pipelined_op::smp_store_release(&this->state, STATE_READY=
).
Here is where the race window begins. (`this` is `ewq_addr`.)

4. If the receiver wakes up now in do_mq_timedreceive::wq_sleep, it
will see `state =3D=3D STATE_READY` and break.

5. do_mq_timedreceive returns, and `ewq_addr` is no longer guaranteed
to be a `struct ext_wait_queue *` since it was on do_mq_timedreceive's
stack. (Although the address may not get overwritten until another
function happens to touch it, which means it can persist around for an
indefinite time.)

6. do_mq_timedsend::__pipelined_op() still believes `ewq_addr` is a
`struct ext_wait_queue *`, and uses it to find a task_struct to pass
to the wake_q_add_safe call. In the lucky case where nothing has
overwritten `ewq_addr` yet, `ewq_addr->task` is the right task_struct.
In the unlucky case, __pipelined_op::wake_q_add_safe gets handed a
bogus address as the receiver's task_struct causing the crash.

do_mq_timedsend::__pipelined_op() should not dereference `this` after
setting STATE_READY, as the receiver counterpart is now free to return.
Change __pipelined_op to call wake_q_add before setting STATE_READY
which ensures that the receiver's task_struct can still be found via
`this`.

Fixes: c5b2cbdbdac563 ("ipc/mqueue.c: update/document memory barriers")
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Reported-by: Matthias von Faber <matthias.vonfaber@aox-tech.de>
Acked-by: Davidlohr Bueso <dbueso@suse.de>
Cc: <stable@vger.kernel.org> # 5.6
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
v2: Call wake_q_add before smp_store_release, instead of using a
    get_task_struct/wake_q_add_safe combination across
    smp_store_release. (Davidlohr Bueso)
v3: Comment/commit message fixup.

 ipc/mqueue.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 8031464ed4ae..bf5dce399854 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -78,11 +78,13 @@ struct posix_msg_tree_node {
  * MQ_BARRIER:
  * To achieve proper release/acquire memory barrier pairing, the state is =
set to
  * STATE_READY with smp_store_release(), and it is read with READ_ONCE fol=
lowed
- * by smp_acquire__after_ctrl_dep(). In addition, wake_q_add_safe() is use=
d.
+ * by smp_acquire__after_ctrl_dep(). The state change to STATE_READY must =
be
+ * the last write operation, after which the blocked task can immediately
+ * return and exit.
  *
  * This prevents the following races:
  *
- * 1) With the simple wake_q_add(), the task could be gone already before
+ * 1) With wake_q_add(), the task could be gone already before
  *    the increase of the reference happens
  * Thread A
  *				Thread B
@@ -97,10 +99,25 @@ struct posix_msg_tree_node {
  * sys_exit()
  *				get_task_struct() // UaF
  *
- * Solution: Use wake_q_add_safe() and perform the get_task_struct() befor=
e
- * the smp_store_release() that does ->state =3D STATE_READY.
+ * 2) With wake_q_add(), the receiver task could have returned from the
+ *    syscall and had its stack-allocated waiter overwritten before the
+ *    waker could add it to the wake_q
+ * Thread A
+ *				Thread B
+ * WRITE_ONCE(wait.state, STATE_NONE);
+ * schedule_hrtimeout()
+ *				->state =3D STATE_READY
+ * <timeout returns>
+ * if (wait.state =3D=3D STATE_READY) return;
+ * sysret to user space
+ * overwrite receiver's stack
+ *				wake_q_add(A)
+ *				if (cmpxchg()) // corrupted waiter
  *
- * 2) Without proper _release/_acquire barriers, the woken up task
+ * Solution: Queue the task for wakeup before the smp_store_release() that
+ * does ->state =3D STATE_READY.
+ *
+ * 3) Without proper _release/_acquire barriers, the woken up task
  *    could read stale data
  *
  * Thread A
@@ -116,7 +133,7 @@ struct posix_msg_tree_node {
  *
  * Solution: use _release and _acquire barriers.
  *
- * 3) There is intentionally no barrier when setting current->state
+ * 4) There is intentionally no barrier when setting current->state
  *    to TASK_INTERRUPTIBLE: spin_unlock(&info->lock) provides the
  *    release memory barrier, and the wakeup is triggered when holding
  *    info->lock, i.e. spin_lock(&info->lock) provided a pairing
@@ -1005,11 +1022,9 @@ static inline void __pipelined_op(struct wake_q_head=
 *wake_q,
 				  struct ext_wait_queue *this)
 {
 	list_del(&this->list);
-	get_task_struct(this->task);
-
+	wake_q_add(wake_q, this->task);
 	/* see MQ_BARRIER for purpose/pairing */
 	smp_store_release(&this->state, STATE_READY);
-	wake_q_add_safe(wake_q, this->task);
 }
=20
 /* pipelined_send() - send a message directly to the task waiting in
--=20
2.30.2

