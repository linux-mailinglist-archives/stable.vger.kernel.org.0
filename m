Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D06605BDEC
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 16:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfGAOR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 10:17:29 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:54767 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726462AbfGAOR3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 10:17:29 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id BA7F31E79;
        Mon,  1 Jul 2019 10:17:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 01 Jul 2019 10:17:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=KWTcSg
        OinSYr3oTprXcCbZSpVQm1p5//qLiBRVYVcuI=; b=Dmyw0Y1nlml0yA/EW3jfeU
        WiKukuxsSH4cpfuerTR0JlXxYo34k1828ACz3b5G3qsP+WtVp/fvooIaL1Cumrqa
        q8cajtznNzMSgcExIK/2cP94iLo+gea2IRZHTo3owaW06S87zmtyw0qjjIkUdIUh
        D5jcHxi03Ia+dD3axGhwNOTnEKQf2JTPyfh6tYs1hw4BfBw9sI4DAdCOaaCV97bl
        M3ukvbNBag89Js6lZM3wWfIR+R6uc5lm+OWUecnJYs/FoNfspSQhsJYH2nLQaQ8M
        QrBdiWRk3bR5C4C5Cb777/yMXBf3uENTKz+ZzAZOo/scrdAwELZ0SoEE38OnaGDg
        ==
X-ME-Sender: <xms:8hUaXV8OTwkQPcowKgLfR87JmYE14jbJNCZsX1cc1l0ytXHAcU0ZZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdeigdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:8hUaXVN__vXSwTGRDTZHgxtTqOXWRsNGzvLQgzpBvevHnuaIVsopUg>
    <xmx:8hUaXZB_9aWQLLgRsfybisaY-_sgfSTM5eRPN97FIrE5vR5JXj98Yw>
    <xmx:8hUaXXOFaumBR10ZlkKPHEOX2GDDbA-pG8lo2fbnTgDl_xzoHOkCDg>
    <xmx:9RUaXe_pwaKApH6zrwhxfsPFeQNshOATIzxtJGYPffuoQrttdifWBQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2A2478006A;
        Mon,  1 Jul 2019 10:17:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] signal: remove the wrong signal_pending() check in" failed to apply to 5.1-stable tree
To:     oleg@redhat.com, David.Laight@ACULAB.COM,
        akpm@linux-foundation.org, arnd@arndb.de, axboe@kernel.dk,
        dave@stgolabs.net, deepa.kernel@gmail.com, e@80x24.org,
        ebiederm@xmission.com, jbaron@akamai.com, mtk.manpages@gmail.com,
        stable@vger.kernel.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Jul 2019 16:17:19 +0200
Message-ID: <1561990639229217@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 97abc889ee296faf95ca0e978340fb7b942a3e32 Mon Sep 17 00:00:00 2001
From: Oleg Nesterov <oleg@redhat.com>
Date: Fri, 28 Jun 2019 12:06:50 -0700
Subject: [PATCH] signal: remove the wrong signal_pending() check in
 restore_user_sigmask()

This is the minimal fix for stable, I'll send cleanups later.

Commit 854a6ed56839 ("signal: Add restore_user_sigmask()") introduced
the visible change which breaks user-space: a signal temporary unblocked
by set_user_sigmask() can be delivered even if the caller returns
success or timeout.

Change restore_user_sigmask() to accept the additional "interrupted"
argument which should be used instead of signal_pending() check, and
update the callers.

Eric said:

: For clarity.  I don't think this is required by posix, or fundamentally to
: remove the races in select.  It is what linux has always done and we have
: applications who care so I agree this fix is needed.
:
: Further in any case where the semantic change that this patch rolls back
: (aka where allowing a signal to be delivered and the select like call to
: complete) would be advantage we can do as well if not better by using
: signalfd.
:
: Michael is there any chance we can get this guarantee of the linux
: implementation of pselect and friends clearly documented.  The guarantee
: that if the system call completes successfully we are guaranteed that no
: signal that is unblocked by using sigmask will be delivered?

Link: http://lkml.kernel.org/r/20190604134117.GA29963@redhat.com
Fixes: 854a6ed56839a40f6b5d02a2962f48841482eec4 ("signal: Add restore_user_sigmask()")
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Eric Wong <e@80x24.org>
Tested-by: Eric Wong <e@80x24.org>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: <stable@vger.kernel.org>	[5.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/aio.c b/fs/aio.c
index 3490d1fa0e16..c1e581dd32f5 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -2095,6 +2095,7 @@ SYSCALL_DEFINE6(io_pgetevents,
 	struct __aio_sigset	ksig = { NULL, };
 	sigset_t		ksigmask, sigsaved;
 	struct timespec64	ts;
+	bool interrupted;
 	int ret;
 
 	if (timeout && unlikely(get_timespec64(&ts, timeout)))
@@ -2108,8 +2109,10 @@ SYSCALL_DEFINE6(io_pgetevents,
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+
+	interrupted = signal_pending(current);
+	restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
+	if (interrupted && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
@@ -2128,6 +2131,7 @@ SYSCALL_DEFINE6(io_pgetevents_time32,
 	struct __aio_sigset	ksig = { NULL, };
 	sigset_t		ksigmask, sigsaved;
 	struct timespec64	ts;
+	bool interrupted;
 	int ret;
 
 	if (timeout && unlikely(get_old_timespec32(&ts, timeout)))
@@ -2142,8 +2146,10 @@ SYSCALL_DEFINE6(io_pgetevents_time32,
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &ts : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+
+	interrupted = signal_pending(current);
+	restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
+	if (interrupted && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
@@ -2193,6 +2199,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 	struct __compat_aio_sigset ksig = { NULL, };
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 t;
+	bool interrupted;
 	int ret;
 
 	if (timeout && get_old_timespec32(&t, timeout))
@@ -2206,8 +2213,10 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents,
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+
+	interrupted = signal_pending(current);
+	restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
+	if (interrupted && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
@@ -2226,6 +2235,7 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
 	struct __compat_aio_sigset ksig = { NULL, };
 	sigset_t ksigmask, sigsaved;
 	struct timespec64 t;
+	bool interrupted;
 	int ret;
 
 	if (timeout && get_timespec64(&t, timeout))
@@ -2239,8 +2249,10 @@ COMPAT_SYSCALL_DEFINE6(io_pgetevents_time64,
 		return ret;
 
 	ret = do_io_getevents(ctx_id, min_nr, nr, events, timeout ? &t : NULL);
-	restore_user_sigmask(ksig.sigmask, &sigsaved);
-	if (signal_pending(current) && !ret)
+
+	interrupted = signal_pending(current);
+	restore_user_sigmask(ksig.sigmask, &sigsaved, interrupted);
+	if (interrupted && !ret)
 		ret = -ERESTARTNOHAND;
 
 	return ret;
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index c6f513100cc9..4c74c768ae43 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2325,7 +2325,7 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 
 	error = do_epoll_wait(epfd, events, maxevents, timeout);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	restore_user_sigmask(sigmask, &sigsaved, error == -EINTR);
 
 	return error;
 }
@@ -2350,7 +2350,7 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 
 	err = do_epoll_wait(epfd, events, maxevents, timeout);
 
-	restore_user_sigmask(sigmask, &sigsaved);
+	restore_user_sigmask(sigmask, &sigsaved, err == -EINTR);
 
 	return err;
 }
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 86a2bd721900..e6981d3f4468 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2201,11 +2201,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	}
 
 	ret = wait_event_interruptible(ctx->wait, io_cqring_events(ring) >= min_events);
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
 
 	if (sig)
-		restore_user_sigmask(sig, &sigsaved);
+		restore_user_sigmask(sig, &sigsaved, ret == -ERESTARTSYS);
+
+	if (ret == -ERESTARTSYS)
+		ret = -EINTR;
 
 	return READ_ONCE(ring->r.head) == READ_ONCE(ring->r.tail) ? ret : 0;
 }
diff --git a/fs/select.c b/fs/select.c
index 6cbc9ff56ba0..a4d8f6e8b63c 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -758,10 +758,9 @@ static long do_pselect(int n, fd_set __user *inp, fd_set __user *outp,
 		return ret;
 
 	ret = core_sys_select(n, inp, outp, exp, to);
+	restore_user_sigmask(sigmask, &sigsaved, ret == -ERESTARTNOHAND);
 	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
 	return ret;
 }
 
@@ -1106,8 +1105,7 @@ SYSCALL_DEFINE5(ppoll, struct pollfd __user *, ufds, unsigned int, nfds,
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
+	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
@@ -1142,8 +1140,7 @@ SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds, unsigned int, nfds,
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
+	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
@@ -1350,10 +1347,9 @@ static long do_compat_pselect(int n, compat_ulong_t __user *inp,
 		return ret;
 
 	ret = compat_core_sys_select(n, inp, outp, exp, to);
+	restore_user_sigmask(sigmask, &sigsaved, ret == -ERESTARTNOHAND);
 	ret = poll_select_copy_remaining(&end_time, tsp, type, ret);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
 	return ret;
 }
 
@@ -1425,8 +1421,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time32, struct pollfd __user *, ufds,
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
+	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
@@ -1461,8 +1456,7 @@ COMPAT_SYSCALL_DEFINE5(ppoll_time64, struct pollfd __user *, ufds,
 
 	ret = do_sys_poll(ufds, nfds, to);
 
-	restore_user_sigmask(sigmask, &sigsaved);
-
+	restore_user_sigmask(sigmask, &sigsaved, ret == -EINTR);
 	/* We can restart this syscall, usually */
 	if (ret == -EINTR)
 		ret = -ERESTARTNOHAND;
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 9702016734b1..78c2bb376954 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -276,7 +276,7 @@ extern int sigprocmask(int, sigset_t *, sigset_t *);
 extern int set_user_sigmask(const sigset_t __user *usigmask, sigset_t *set,
 	sigset_t *oldset, size_t sigsetsize);
 extern void restore_user_sigmask(const void __user *usigmask,
-				 sigset_t *sigsaved);
+				 sigset_t *sigsaved, bool interrupted);
 extern void set_current_blocked(sigset_t *);
 extern void __set_current_blocked(const sigset_t *);
 extern int show_unhandled_signals;
diff --git a/kernel/signal.c b/kernel/signal.c
index d622eac9d169..edf8915ddd54 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2912,7 +2912,8 @@ EXPORT_SYMBOL(set_compat_user_sigmask);
  * This is useful for syscalls such as ppoll, pselect, io_pgetevents and
  * epoll_pwait where a new sigmask is passed in from userland for the syscalls.
  */
-void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
+void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved,
+				bool interrupted)
 {
 
 	if (!usigmask)
@@ -2922,7 +2923,7 @@ void restore_user_sigmask(const void __user *usigmask, sigset_t *sigsaved)
 	 * Restoring sigmask here can lead to delivering signals that the above
 	 * syscalls are intended to block because of the sigmask passed in.
 	 */
-	if (signal_pending(current)) {
+	if (interrupted) {
 		current->saved_sigmask = *sigsaved;
 		set_restore_sigmask();
 		return;

