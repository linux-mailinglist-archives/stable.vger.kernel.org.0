Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAED1CF355
	for <lists+stable@lfdr.de>; Tue, 12 May 2020 13:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgELLaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 07:30:15 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:33287 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726891AbgELLaO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 May 2020 07:30:14 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 54946727;
        Tue, 12 May 2020 07:30:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 12 May 2020 07:30:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EkVdKM
        K//TDT/2vilpkl3mp7EcsDkrTf+8LPtpUybrg=; b=P1NaA64ThRfTS6jw2fdj1y
        dg5XT3V7uHWWEWRD4WxJnUw7kxAbU62SgA4HyyRLTEG4pzOtnkVPTA8M+T/necZI
        ItrPZzrrM68vYKUIr4yLI10fGFlzabaEWYR2oXCNCaVvJrGxlMr6uWVY9F+zA+TB
        8S+fbyQOwr+DbqgPgdG1sKU+Veb6a/9+JSykJytNwW4aX1TQZtXqqZT9LVocDQQn
        9zTE7X8Cuu2QF82VB9w3/a7p0H1uBvS4RVpMJySoyOSH/rqB/cwBt8p0mc8KoO2/
        K+bVVrpp74MSGNRLXB3ftLZDiefoSF2JIBKdTv3z9yTmdGw5FFaBjPnRD0MU0QAw
        ==
X-ME-Sender: <xms:xIi6XqieiIitJIv1z0d4wXYFMTK5rF7t6BLsbRInQjK88xfbHV4Imw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrledvgdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:xIi6XrCZjBtNcvpa1Wg1UhEzC62B4Yr2IAWPOCM7sJJqw4nMReTAAg>
    <xmx:xIi6XiHokVLP0P-G0bvd9jb5m6nVGQtIiyaWvbdUut2HRtHkTh3MJQ>
    <xmx:xIi6XjTo_B_TtgWMfpnWAAz_QKbouCoydx-qkNxAo2_vsIHS1Wk84Q>
    <xmx:xIi6Xun9eksQZ7agRMnt0n91_iwIVaN8qMxtL__nSXNWCKxagBWB6JZ3nXQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id F3E89328006E;
        Tue, 12 May 2020 07:30:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ipc/mqueue.c: change __do_notify() to bypass" failed to apply to 4.14-stable tree
To:     oleg@redhat.com, 1vier1@web.de, akpm@linux-foundation.org,
        dave@stgolabs.net, ebiederm@xmission.com,
        elfring@users.sourceforge.net, manfred@colorfullife.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        yoji.fujihar.min@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 12 May 2020 13:30:09 +0200
Message-ID: <158928300990199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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
 

