Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42764374FA9
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 08:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhEFG5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 02:57:53 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:51694 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232674AbhEFG5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 02:57:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620284214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=nPP2oedJa0y7csQG0hE8rjTkcLshU+LA6mzl9i8rFww=;
        b=IqF8ITr4Da+WaNtBEOyyv//aIFE18/XD7CdI1Ju/GwIiwXtHkf6N/H3M2A4JHywjAQo0ah
        iIYR2LBivpuwQK6xZra0DGnhYvZLyTpjifJ0CBOaRklWQV2/BlWnf6FoAK8uYrUAA6Q1xN
        nemvLkDPvX0GnMQKJ+hfQyY/RpnnUVE=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2057.outbound.protection.outlook.com [104.47.1.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-17-DGyAriILMS6ZmW73w0bc3g-1; Thu, 06 May 2021 08:56:53 +0200
X-MC-Unique: DGyAriILMS6ZmW73w0bc3g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QFIfHqLBSFHlbqKhl9Kvl3JtNAYS0tKuc9Kw7L2/+ZVkDOQ5syjtqOmclHMiVXYyves/5tXd9zcSF4VzX+Vb5i9atsUQvGC/jKK9E7g4x9rJ6MxLnfUDT56hMt3XOefC26SnH+a8hsjVqJLumQ+0te6y7N9DrAKjfbMGNhUAlkg14ZnD+NRb9+eetgzXEhX2A0bfycBu6DQ7BH4jajT4+PpqlcYgy5GulxfD0qm5NaV19Q9jdXPdhrfbvQqkxI3B+3n6wIhcnvC+HSVT+PvaiB8nKA0trpI4CN0xiSK659zgXCwToZdrYn2QFQ7WXzJvY2Evvk9BpjnL1nKA3Y54og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IhnT8KKzjCaiXAfshxCAlVECwmBx7ITVBsRQ+iF5/Yw=;
 b=Xn5nIoP1W5Ij59ovxNAtH7f6mVj9P2pwnyxnrxRYD3W79pKFdu5I0m869N7wHdUwgWuuwknWv8213jEZcqE2HdZXT9VxCz0BlT1LmwFtOonQJlaWa/qUWddr5WktLrDAXfEimvmRpsKHWgDE/MyJr50V7S7R7uYKFrUqyKArZ77vZLnvoVvz6ofMGAJSnfuZ/46FMxfl4LIcl++QJ7W4MyeqSNvNPmiAyj7/NjbvUofTuI7sWFdzYxbEYcqXeG1XeT39rdH6j51A14QYdxS40NHR/OC3pzdu9k4BVMWXrp6lOEnuXG1UzfzwYQ4WakjJDqnV1x1ar2CQiHdDYwIvPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM0PR04MB7009.eurprd04.prod.outlook.com (2603:10a6:208:19b::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Thu, 6 May
 2021 06:56:51 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::756a:86b8:8283:733d]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::756a:86b8:8283:733d%6]) with mapi id 15.20.4108.027; Thu, 6 May 2021
 06:56:51 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-kernel@vger.kernel.org
CC:     varad.gautam@suse.com,
        Matthias von Faber <matthias.vonfaber@aox-tech.de>,
        stable@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dbueso@suse.de>,
        Serge Hallyn <serge@hallyn.com>,
        James Morris <jamorris@linux.microsoft.com>
Subject: [PATCH v2] ipc/mqueue: Avoid relying on a stack reference past its expiry
Date:   Thu,  6 May 2021 08:56:19 +0200
Message-ID: <20210506065621.9292-1-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [95.90.93.216]
X-ClientProxiedBy: FR3P281CA0069.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4b::16) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xps13.suse.de (95.90.93.216) by FR3P281CA0069.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:4b::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.12 via Frontend Transport; Thu, 6 May 2021 06:56:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0067fa06-9486-4a3d-edf1-08d9105c202a
X-MS-TrafficTypeDiagnostic: AM0PR04MB7009:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB7009AF8130BFA0E8B4313D0DE0589@AM0PR04MB7009.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pRNWcurdb2se8DCxgH3Cd9RHu1mZdKwRJQtPRKiakM5B56LEOyD4QlVyL9+hUxDsbpg3SY7Lxz+GUvyva5vPGy98szPnL6hjBSsW7q8RSUhcIZLXM+YKsILA3EGdbhVBjZyRDY3C8r4zrZWvc7iOIdyGTsaNJDIBKyRj55Go5FTnN4iRwuB4D90XpXNxs/M0uG7JdebeECmy/ipP9KAFRY8EvHjzBLbDedmYvNV+GRwIeuoBZAqIA6Vr3p3CgwcID3fATcXbnnW/74C6q6QSdfL/4CWJ95tn67gaAyR6H2yrRsk8GxwYiBEZxMhgtbrQOlj46TgxXyeS/bPmnfd2aUvfptuSM8i8erd57diV2jIBnXlumAKf5qNqE0yNU3LVjsknJclwRiqa62h0MxSVGh8rZa7LvmG6mFMuw5AxiRmpgvomzcfD2G8lyw+ceKyhuaF8CDbBT8XDHuwGjT0DDcRzbP53GBcJUxou08ImvtLGluHlzjsElRshzYep/DkEpBqZ4taCS3uim9Uwm3yDexbk12NxDebfHJk0Ucc56q/f5XmEuScwLqIwYTz92Pvw6ciWmV5s4RclVVMntkvfU7n4PVLqc/R7kCxYx5+D7IZ6AKsLYF1BbOdS/BrSVcV7snjcHxYp0Rm7ASRuoKhMTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(346002)(136003)(376002)(6486002)(7416002)(6916009)(186003)(6666004)(83380400001)(36756003)(86362001)(54906003)(26005)(44832011)(16526019)(1076003)(5660300002)(6512007)(8676002)(4326008)(2616005)(66556008)(66476007)(2906002)(52116002)(38350700002)(8936002)(38100700002)(66946007)(478600001)(316002)(956004)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?k0CYrfqlH152Lm7esuhCe7xPMDbIR7xqN1ycGS9M3lkkpmW8jAzR4GXH5lwr?=
 =?us-ascii?Q?9249SbrTozfSFpwTdq9992oY2SPT4WK5Mxa/79Ycyw9U3FPcO0ks3l46/vea?=
 =?us-ascii?Q?m8Y+pChG4XqQvg3RrJUlQIAM9+t+b7Izp/9FaH8Kk1cioeFg4cGXhLXPm8m6?=
 =?us-ascii?Q?N6RktTyMD1pag/tpREGkONtsZUZ2GxECNd+MT1Dh7Ls7TO4inaGKcbCVr5+O?=
 =?us-ascii?Q?eqGxDYZmCBZEk5NfmsfVseEc418OMAV9BzZV22kXfYarjiF1iCFzGixAVu7g?=
 =?us-ascii?Q?UCNngtuE/6FW1oRMSKCpvDjF18RKhL/5wld4z8jWDeoywEBtafNa8Pa9eu9o?=
 =?us-ascii?Q?zvRmQLbRde8z6m1g9AY4JdrSS+0yWs332xSJcd9ChQesVYQ/VAFOwSIeX6B7?=
 =?us-ascii?Q?AlsqGH474Ejxs5R5lngiGQmu357UVSS1BaSqNKMG21TpNpgGaFcc0ikYMcLN?=
 =?us-ascii?Q?GtD/Ac5z9AhTCwU1k+MY1bUCfCIU5iclSKlTVuA6eg9O7+BzhFwnAqVTEu+R?=
 =?us-ascii?Q?baoygqv0eyFrDe3OfPlaC2wYpaYzhrmDMzHR+jQenbhuqT7F3DVdnFaxUt2K?=
 =?us-ascii?Q?5X6Q+FgBT4FoPXWhNb+bjDBj8bpkd8ogR6Hn+j+d+gB/EPs2AwfDoDo68j56?=
 =?us-ascii?Q?iF0uy068hI3k7IAfZFd3Q7SpHpR/DHPoEvOSHTypi+RANmIdePaYP41+HAai?=
 =?us-ascii?Q?H1iYWz49hHK2yP0lgzF6cUgpYN1PR/k3BUF8G024ipaA/1f0Bp+zP+9tacJd?=
 =?us-ascii?Q?wnVx7FJtmb2bX7Vb8Wt0jSRRR5KsKsEEibFE1wDa/ZBkEqxogiay/RL8c7ye?=
 =?us-ascii?Q?9vZvSS0jAG7jgpYjArQrDWKgdOdUWbmt0L8AQeUhJrtpldVOBHMlrectIV8g?=
 =?us-ascii?Q?udxmtwZictcSXfXinNpbvLrPkgi4Ca2bNFTIeoVkrTCeE7m76CUXWdt1FnEQ?=
 =?us-ascii?Q?FYCDDxdYDi+XQgGsCuRr5ZQHCMXJxoJT++KK3OWEbS2hdaL3c5PBD3cPmYPP?=
 =?us-ascii?Q?Z+spT/ScRDkY4BJT4E8/PPam1TATQaIP1Cqscm/3XiyJv8T/jIWqHRxW9pIg?=
 =?us-ascii?Q?LxscFDv19ESjlOfPM5krtJshh3vuRPRPcmgvW+e5Ifh+6GHyCYoXT5RqBJzX?=
 =?us-ascii?Q?kyWTbda69LPjAq4uXZsjWKkLg0Dj3Md0EDzL70rYCpfqtVfYl4XKtA1a5eI2?=
 =?us-ascii?Q?DP7Y501aRW1OS5wIj3jJAuhCWozkTeHz+3NocYFBcf1D/OmWrz3Ch/ulMEG7?=
 =?us-ascii?Q?mdQgk961vOoGoxyEwB2GXKi1Xg3Hse/2giOmgq5TjZb9E9Vcppjvluz0C4r6?=
 =?us-ascii?Q?Uy6RFOYQtlGoFY8wewl+Hctx?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0067fa06-9486-4a3d-edf1-08d9105c202a
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 06:56:51.3755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2xKlTdnxANMGIaMzHbpzZ4mnw1RQITSeg7LlxaGTZgditA/0NM7w+KCrmdb97ZgozDX7ZpznYotEweypslKfiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7009
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
will see `state =3D=3D STATE_READY` and break. `ewq_addr` gets removed from
info->e_wait_q[RECV].list.

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
Cc: <stable@vger.kernel.org> # 5.6
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Davidlohr Bueso <dbueso@suse.de>
---
v2: Call wake_q_add before smp_store_release, instead of using a
    get_task_struct/wake_q_add_safe combination across
    smp_store_release. (Davidlohr Bueso)

 ipc/mqueue.c | 33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 8031464ed4ae..bfcb6f81a824 100644
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
+ *    sender could add it to the wake_q
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

