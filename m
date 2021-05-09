Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C88A3776E4
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 16:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhEIOCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 10:02:36 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:51471 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229602AbhEIOCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 10:02:36 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 66F551940682;
        Sun,  9 May 2021 10:01:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 09 May 2021 10:01:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8nKOKk
        pnfWsWl52mM0aiiHekQzIcrXtdLuN7Guq1ivk=; b=R3v9wOEJ5aPYaaFDNVAr4m
        Vbxp5S+QCm9YbgpUwWplHxqvWbR5chEADwasvIdze7DL4tIvoret+91uzldom0a5
        sdKh9DCaec9tH4GHItn1iYSeMcpirOHU1uJwlEseDKPNPz8Yv3MEy4q/zqryo4CQ
        G4ikqZfjbyqIzuamQ3mGdsu7ipSGyUosErcfkMDtijyV5QG27eSNZOchkZ96cfS+
        WdpZLz3kY7djCfIJIKCA+gBqu9pGsPwJn7EwuToYUlGkNakYzN7TFp1w++/pI5Sh
        /DMHmSzjYuEQBNmw9tF2n0O/GpSYjBMNkcw5XIOOlTxkXD1dMj7aPxSH0kmwsMRw
        ==
X-ME-Sender: <xms:POuXYLkgVNuoN3Dhlr_OCmF4xw3rT0nQbd4IzaXEYFeZofut1XbVRg>
    <xme:POuXYO1AuthxfPvuRsUJsDB-p1-b8-J_2kdd3KmI-a6iB2b3wfgchpPYi5do55qaI
    TfsNaZLvZldMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:POuXYBrrfvWTymr-GhDL89TKX6ojki_9T1LsR4l7mEsJDOXA0HMGDg>
    <xmx:POuXYDniHht1-68fOavmBs_mIbbpjcqzB8j0LlqHs_MZSXGJFBhRdw>
    <xmx:POuXYJ1MNYKTxKAxc7HhQEwffNV8RgqqxrUKsiI1avljV2mF47EWUQ>
    <xmx:POuXYDom3zd_MF3DfwIq4nu7luH5TTcl9COGsIBToOYP7KIsEbRN2g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 10:01:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] rcu/nocb: Fix missed nocb_timer requeue" failed to apply to 5.4-stable tree
To:     frederic@kernel.org, boqun.feng@gmail.com, jiangshanlai@gmail.com,
        joel@joelfernandes.org, josh@joshtriplett.org,
        neeraju@codeaurora.org, paulmck@kernel.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 May 2021 16:01:29 +0200
Message-ID: <16205688891393@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b2fcf2102049f6e56981e0ab3d9b633b8e2741da Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <frederic@kernel.org>
Date: Tue, 23 Feb 2021 01:09:59 +0100
Subject: [PATCH] rcu/nocb: Fix missed nocb_timer requeue

This sequence of events can lead to a failure to requeue a CPU's
->nocb_timer:

1.	There are no callbacks queued for any CPU covered by CPU 0-2's
	->nocb_gp_kthread.  Note that ->nocb_gp_kthread is associated
	with CPU 0.

2.	CPU 1 enqueues its first callback with interrupts disabled, and
	thus must defer awakening its ->nocb_gp_kthread.  It therefore
	queues its rcu_data structure's ->nocb_timer.  At this point,
	CPU 1's rdp->nocb_defer_wakeup is RCU_NOCB_WAKE.

3.	CPU 2, which shares the same ->nocb_gp_kthread, also enqueues a
	callback, but with interrupts enabled, allowing it to directly
	awaken the ->nocb_gp_kthread.

4.	The newly awakened ->nocb_gp_kthread associates both CPU 1's
	and CPU 2's callbacks with a future grace period and arranges
	for that grace period to be started.

5.	This ->nocb_gp_kthread goes to sleep waiting for the end of this
	future grace period.

6.	This grace period elapses before the CPU 1's timer fires.
	This is normally improbably given that the timer is set for only
	one jiffy, but timers can be delayed.  Besides, it is possible
	that kernel was built with CONFIG_RCU_STRICT_GRACE_PERIOD=y.

7.	The grace period ends, so rcu_gp_kthread awakens the
	->nocb_gp_kthread, which in turn awakens both CPU 1's and
	CPU 2's ->nocb_cb_kthread.  Then ->nocb_gb_kthread sleeps
	waiting for more newly queued callbacks.

8.	CPU 1's ->nocb_cb_kthread invokes its callback, then sleeps
	waiting for more invocable callbacks.

9.	Note that neither kthread updated any ->nocb_timer state,
	so CPU 1's ->nocb_defer_wakeup is still set to RCU_NOCB_WAKE.

10.	CPU 1 enqueues its second callback, this time with interrupts
 	enabled so it can wake directly	->nocb_gp_kthread.
	It does so with calling wake_nocb_gp() which also cancels the
	pending timer that got queued in step 2. But that doesn't reset
	CPU 1's ->nocb_defer_wakeup which is still set to RCU_NOCB_WAKE.
	So CPU 1's ->nocb_defer_wakeup and its ->nocb_timer are now
	desynchronized.

11.	->nocb_gp_kthread associates the callback queued in 10 with a new
	grace period, arranges for that grace period to start and sleeps
	waiting for it to complete.

12.	The grace period ends, rcu_gp_kthread awakens ->nocb_gp_kthread,
	which in turn wakes up CPU 1's ->nocb_cb_kthread which then
	invokes the callback queued in 10.

13.	CPU 1 enqueues its third callback, this time with interrupts
	disabled so it must queue a timer for a deferred wakeup. However
	the value of its ->nocb_defer_wakeup is RCU_NOCB_WAKE which
	incorrectly indicates that a timer is already queued.  Instead,
	CPU 1's ->nocb_timer was cancelled in 10.  CPU 1 therefore fails
	to queue the ->nocb_timer.

14.	CPU 1 has its pending callback and it may go unnoticed until
	some other CPU ever wakes up ->nocb_gp_kthread or CPU 1 ever
	calls an explicit deferred wakeup, for example, during idle entry.

This commit fixes this bug by resetting rdp->nocb_defer_wakeup everytime
we delete the ->nocb_timer.

It is quite possible that there is a similar scenario involving
->nocb_bypass_timer and ->nocb_defer_wakeup.  However, despite some
effort from several people, a failure scenario has not yet been located.
However, that by no means guarantees that no such scenario exists.
Finding a failure scenario is left as an exercise for the reader, and the
"Fixes:" tag below relates to ->nocb_bypass_timer instead of ->nocb_timer.

Fixes: d1b222c6be1f (rcu/nocb: Add bypass callback queueing)
Cc: <stable@vger.kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index a1a17adeae54..e392bd129316 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1708,7 +1708,11 @@ static bool wake_nocb_gp(struct rcu_data *rdp, bool force,
 		rcu_nocb_unlock_irqrestore(rdp, flags);
 		return false;
 	}
-	del_timer(&rdp->nocb_timer);
+
+	if (READ_ONCE(rdp->nocb_defer_wakeup) > RCU_NOCB_WAKE_NOT) {
+		WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
+		del_timer(&rdp->nocb_timer);
+	}
 	rcu_nocb_unlock_irqrestore(rdp, flags);
 	raw_spin_lock_irqsave(&rdp_gp->nocb_gp_lock, flags);
 	if (force || READ_ONCE(rdp_gp->nocb_gp_sleep)) {
@@ -2335,7 +2339,6 @@ static bool do_nocb_deferred_wakeup_common(struct rcu_data *rdp)
 		return false;
 	}
 	ndw = READ_ONCE(rdp->nocb_defer_wakeup);
-	WRITE_ONCE(rdp->nocb_defer_wakeup, RCU_NOCB_WAKE_NOT);
 	ret = wake_nocb_gp(rdp, ndw == RCU_NOCB_WAKE_FORCE, flags);
 	trace_rcu_nocb_wake(rcu_state.name, rdp->cpu, TPS("DeferredWake"));
 

