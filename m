Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A94B1CF356
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 13:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbgELLaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 07:30:22 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:56595 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726891AbgELLaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 07:30:22 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id A5A6B781;
        Tue, 12 May 2020 07:30:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 12 May 2020 07:30:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=v6KVIz
        Yxn/feiWpphS82sVO2Qi/9S2tvHn9yodBOXtM=; b=181GdPV7+8yzYS51C43v08
        5SsQKvWaMmYO2HoI7IfUVY3PO9rkwnhGGFkPd4JM/j4SHsXFRaUnFIMPP+c+jY2/
        N491zQ6DLUgsUEtf1IJregDxypvlptA6tzVSS2pQmH3VVC2IUw4boXsoXYJBiJEL
        YSC1PJp7Kl3IF06fI0JyXEI5DYirjYpU+a9icosvYcp9CH2BxElWo1GTK5xsMSJx
        bj/JTMArmMDljP5XwAp4IifsXBrSH4PO9YEcw7e6Slk1aLAJUK+vYc776GW/50Ya
        G1d/wbV6BqgYRHj5UajMQP77mSgC0ju4iGTGM4POuRZz3h9GB/005+tAp6JtgtTg
        ==
X-ME-Sender: <xms:zIi6Xo10SwXXC6AneR7mdeApHPlV107aTLzgiuu0w-Rk-HpAI_2v7w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrledvgdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:zIi6XjFqyQvdWGJwalnVmaTe3ENNrTks9kMBKf11yPwkrdNRyurQvg>
    <xmx:zIi6Xg6VtlTb2EwK133GwqYeorCN8uSUPYk3XUwtXLEXzBQdXI8LPA>
    <xmx:zIi6Xh13c-0PZtOPR6H0PapIq7Y2eSUhM0fp6ppcVrK-2cq-QjRQmg>
    <xmx:zIi6Xg4XY0qNa_LsElDTaCjo0bNwW6-DLVVa4M0b8N1f-BE4zFTLU2_jZI8>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A5B3A328005D;
        Tue, 12 May 2020 07:30:19 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ipc/mqueue.c: change __do_notify() to bypass" failed to apply to 4.19-stable tree
To:     oleg@redhat.com, 1vier1@web.de, akpm@linux-foundation.org,
        dave@stgolabs.net, ebiederm@xmission.com,
        elfring@users.sourceforge.net, manfred@colorfullife.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        yoji.fujihar.min@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 12 May 2020 13:30:10 +0200
Message-ID: <158928301012872@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b5f2006144c6ae941726037120fa1001ddede784 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Thu, 7 May 2020 18:35:39 -0700
Subject: [PATCH] ipc/mqueue.c: change __do_notify() to bypass
 check_kill_permission()

Commit cc731525f26a ("signal: Remove kernel interal si_code magic")
changed the value of SI_FROMUSER(SI_MESGQ), this means that mq_notify() no
longer works if the sender doesn't have rights to send a signal.

Change __do_notify() to use do_send_sig_info() instead of kill_pid_info()
to avoid check_kill_permission().

This needs the additional notify.sigev_signo != 0 check, shouldn't we
change do_mq_notify() to deny sigev_signo == 0 ?

Test-case:

	#include <signal.h>
	#include <mqueue.h>
	#include <unistd.h>
	#include <sys/wait.h>
	#include <assert.h>

	static int notified;

	static void sigh(int sig)
	{
		notified = 1;
	}

	int main(void)
	{
		signal(SIGIO, sigh);

		int fd = mq_open("/mq", O_RDWR|O_CREAT, 0666, NULL);
		assert(fd >= 0);

		struct sigevent se = {
			.sigev_notify	= SIGEV_SIGNAL,
			.sigev_signo	= SIGIO,
		};
		assert(mq_notify(fd, &se) == 0);

		if (!fork()) {
			assert(setuid(1) == 0);
			mq_send(fd, "",1,0);
			return 0;
		}

		wait(NULL);
		mq_unlink("/mq");
		assert(notified);
		return 0;
	}

[manfred@colorfullife.com: 1) Add self_exec_id evaluation so that the implementation matches do_notify_parent 2) use PIDTYPE_TGID everywhere]
Fixes: cc731525f26a ("signal: Remove kernel interal si_code magic")
Reported-by: Yoji <yoji.fujihar.min@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Markus Elfring <elfring@users.sourceforge.net>
Cc: <1vier1@web.de>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/e2a782e4-eab9-4f5c-c749-c07a8f7a4e66@colorfullife.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index dc8307bf2d74..beff0cfcd1e8 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -142,6 +142,7 @@ struct mqueue_inode_info {
 
 	struct sigevent notify;
 	struct pid *notify_owner;
+	u32 notify_self_exec_id;
 	struct user_namespace *notify_user_ns;
 	struct user_struct *user;	/* user who created, for accounting */
 	struct sock *notify_sock;
@@ -773,28 +774,44 @@ static void __do_notify(struct mqueue_inode_info *info)
 	 * synchronously. */
 	if (info->notify_owner &&
 	    info->attr.mq_curmsgs == 1) {
-		struct kernel_siginfo sig_i;
 		switch (info->notify.sigev_notify) {
 		case SIGEV_NONE:
 			break;
-		case SIGEV_SIGNAL:
-			/* sends signal */
+		case SIGEV_SIGNAL: {
+			struct kernel_siginfo sig_i;
+			struct task_struct *task;
+
+			/* do_mq_notify() accepts sigev_signo == 0, why?? */
+			if (!info->notify.sigev_signo)
+				break;
 
 			clear_siginfo(&sig_i);
 			sig_i.si_signo = info->notify.sigev_signo;
 			sig_i.si_errno = 0;
 			sig_i.si_code = SI_MESGQ;
 			sig_i.si_value = info->notify.sigev_value;
-			/* map current pid/uid into info->owner's namespaces */
 			rcu_read_lock();
+			/* map current pid/uid into info->owner's namespaces */
 			sig_i.si_pid = task_tgid_nr_ns(current,
 						ns_of_pid(info->notify_owner));
-			sig_i.si_uid = from_kuid_munged(info->notify_user_ns, current_uid());
+			sig_i.si_uid = from_kuid_munged(info->notify_user_ns,
+						current_uid());
+			/*
+			 * We can't use kill_pid_info(), this signal should
+			 * bypass check_kill_permission(). It is from kernel
+			 * but si_fromuser() can't know this.
+			 * We do check the self_exec_id, to avoid sending
+			 * signals to programs that don't expect them.
+			 */
+			task = pid_task(info->notify_owner, PIDTYPE_TGID);
+			if (task && task->self_exec_id ==
+						info->notify_self_exec_id) {
+				do_send_sig_info(info->notify.sigev_signo,
+						&sig_i, task, PIDTYPE_TGID);
+			}
 			rcu_read_unlock();
-
-			kill_pid_info(info->notify.sigev_signo,
-				      &sig_i, info->notify_owner);
 			break;
+		}
 		case SIGEV_THREAD:
 			set_cookie(info->notify_cookie, NOTIFY_WOKENUP);
 			netlink_sendskb(info->notify_sock, info->notify_cookie);
@@ -1383,6 +1400,7 @@ static int do_mq_notify(mqd_t mqdes, const struct sigevent *notification)
 			info->notify.sigev_signo = notification->sigev_signo;
 			info->notify.sigev_value = notification->sigev_value;
 			info->notify.sigev_notify = SIGEV_SIGNAL;
+			info->notify_self_exec_id = current->self_exec_id;
 			break;
 		}
 

