Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81E66CF41A
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 09:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbfJHHml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 03:42:41 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:59001 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730382AbfJHHml (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 03:42:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 42D615C4;
        Tue,  8 Oct 2019 03:42:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 03:42:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xEwQ/m
        E25SbSdtpamtJjsEuaEzDA46NZY//1Hm2to/c=; b=yKQxfAZ/Fv4t8gkSkw9L8j
        K6AHrcwLQ9olQtsJKfMoJr8iAjsRUARmFXp400/exJBYFIGbi/6EgPuxXO/dGmjx
        YjTiznxomRhjlu/vsW8S10W5Z9cHJRgHbFDyWZtUvoA+gnM+sV1lqgXzJRTTNHqN
        3Bc9wJCXE+8E9TTT1+QTSG7E+9i2WU30OGBtj4xW7Led1U3HSECfD4Smo5MmMquo
        ZdCKa+T5LeuOlhzijrzaS7n06vQlr8oR4dJG4cbTS2ek9DoTfTT7Vwfvhd3F0VkR
        nv28nRxMUYtPI6utEbOqvZv/a7HILluCj+8iutZcyP5x7APTwKQtf5wJJDb5ZI+Q
        ==
X-ME-Sender: <xms:7z2cXc4kBhlut-bt-XyWrUyWM9UKM-vSCvRwcTd5naS8AJY4ywm3rw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheekgdduvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:7z2cXVqzHG4hNxvDebpJha2xmf2gVC5UHx16TgeD8BElu66Dnaa7dA>
    <xmx:7z2cXaBfxfF0Lth5XjWKim6u4_C5bXkuKj8E6W1LuGDYKqBlOREqzg>
    <xmx:7z2cXbd4BiZwxszpC5aJwH1_PU3_PpHtPWz6lVVfdGOdj8kpg3yQxw>
    <xmx:7z2cXcNXwZLl3Rv2aB6wYAjOWWyGl7jBOCJLG2CSUAYc5tOp1q5YqA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 836A5D6005B;
        Tue,  8 Oct 2019 03:42:39 -0400 (EDT)
Subject: FAILED: patch "[PATCH] tick: broadcast-hrtimer: Fix a race in bc_set_next" failed to apply to 4.19-stable tree
To:     balasubramani_vivekanandan@mentor.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 09:42:36 +0200
Message-ID: <1570520556127191@kroah.com>
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

From b9023b91dd020ad7e093baa5122b6968c48cc9e0 Mon Sep 17 00:00:00 2001
From: Balasubramani Vivekanandan <balasubramani_vivekanandan@mentor.com>
Date: Thu, 26 Sep 2019 15:51:01 +0200
Subject: [PATCH] tick: broadcast-hrtimer: Fix a race in bc_set_next

When a cpu requests broadcasting, before starting the tick broadcast
hrtimer, bc_set_next() checks if the timer callback (bc_handler) is active
using hrtimer_try_to_cancel(). But hrtimer_try_to_cancel() does not provide
the required synchronization when the callback is active on other core.

The callback could have already executed tick_handle_oneshot_broadcast()
and could have also returned. But still there is a small time window where
the hrtimer_try_to_cancel() returns -1. In that case bc_set_next() returns
without doing anything, but the next_event of the tick broadcast clock
device is already set to a timeout value.

In the race condition diagram below, CPU #1 is running the timer callback
and CPU #2 is entering idle state and so calls bc_set_next().

In the worst case, the next_event will contain an expiry time, but the
hrtimer will not be started which happens when the racing callback returns
HRTIMER_NORESTART. The hrtimer might never recover if all further requests
from the CPUs to subscribe to tick broadcast have timeout greater than the
next_event of tick broadcast clock device. This leads to cascading of
failures and finally noticed as rcu stall warnings

Here is a depiction of the race condition

CPU #1 (Running timer callback)                   CPU #2 (Enter idle
                                                  and subscribe to
                                                  tick broadcast)
---------------------                             ---------------------

__run_hrtimer()                                   tick_broadcast_enter()

  bc_handler()                                      __tick_broadcast_oneshot_control()

    tick_handle_oneshot_broadcast()

      raw_spin_lock(&tick_broadcast_lock);

      dev->next_event = KTIME_MAX;                  //wait for tick_broadcast_lock
      //next_event for tick broadcast clock
      set to KTIME_MAX since no other cores
      subscribed to tick broadcasting

      raw_spin_unlock(&tick_broadcast_lock);

    if (dev->next_event == KTIME_MAX)
      return HRTIMER_NORESTART
    // callback function exits without
       restarting the hrtimer                      //tick_broadcast_lock acquired
                                                   raw_spin_lock(&tick_broadcast_lock);

                                                   tick_broadcast_set_event()

                                                     clockevents_program_event()

                                                       dev->next_event = expires;

                                                       bc_set_next()

                                                         hrtimer_try_to_cancel()
                                                         //returns -1 since the timer
                                                         callback is active. Exits without
                                                         restarting the timer
  cpu_base->running = NULL;

The comment that hrtimer cannot be armed from within the callback is
wrong. It is fine to start the hrtimer from within the callback. Also it is
safe to start the hrtimer from the enter/exit idle code while the broadcast
handler is active. The enter/exit idle code and the broadcast handler are
synchronized using tick_broadcast_lock. So there is no need for the
existing try to cancel logic. All this can be removed which will eliminate
the race condition as well.

Fixes: 5d1638acb9f6 ("tick: Introduce hrtimer based broadcast")
Originally-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Balasubramani Vivekanandan <balasubramani_vivekanandan@mentor.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190926135101.12102-2-balasubramani_vivekanandan@mentor.com

diff --git a/kernel/time/tick-broadcast-hrtimer.c b/kernel/time/tick-broadcast-hrtimer.c
index c1f5bb590b5e..b5a65e212df2 100644
--- a/kernel/time/tick-broadcast-hrtimer.c
+++ b/kernel/time/tick-broadcast-hrtimer.c
@@ -42,39 +42,39 @@ static int bc_shutdown(struct clock_event_device *evt)
  */
 static int bc_set_next(ktime_t expires, struct clock_event_device *bc)
 {
-	int bc_moved;
 	/*
-	 * We try to cancel the timer first. If the callback is on
-	 * flight on some other cpu then we let it handle it. If we
-	 * were able to cancel the timer nothing can rearm it as we
-	 * own broadcast_lock.
+	 * This is called either from enter/exit idle code or from the
+	 * broadcast handler. In all cases tick_broadcast_lock is held.
 	 *
-	 * However we can also be called from the event handler of
-	 * ce_broadcast_hrtimer itself when it expires. We cannot
-	 * restart the timer because we are in the callback, but we
-	 * can set the expiry time and let the callback return
-	 * HRTIMER_RESTART.
+	 * hrtimer_cancel() cannot be called here neither from the
+	 * broadcast handler nor from the enter/exit idle code. The idle
+	 * code can run into the problem described in bc_shutdown() and the
+	 * broadcast handler cannot wait for itself to complete for obvious
+	 * reasons.
 	 *
-	 * Since we are in the idle loop at this point and because
-	 * hrtimer_{start/cancel} functions call into tracing,
-	 * calls to these functions must be bound within RCU_NONIDLE.
+	 * Each caller tries to arm the hrtimer on its own CPU, but if the
+	 * hrtimer callbback function is currently running, then
+	 * hrtimer_start() cannot move it and the timer stays on the CPU on
+	 * which it is assigned at the moment.
+	 *
+	 * As this can be called from idle code, the hrtimer_start()
+	 * invocation has to be wrapped with RCU_NONIDLE() as
+	 * hrtimer_start() can call into tracing.
 	 */
-	RCU_NONIDLE(
-		{
-			bc_moved = hrtimer_try_to_cancel(&bctimer) >= 0;
-			if (bc_moved) {
-				hrtimer_start(&bctimer, expires,
-					      HRTIMER_MODE_ABS_PINNED_HARD);
-			}
-		}
-	);
-
-	if (bc_moved) {
-		/* Bind the "device" to the cpu */
-		bc->bound_on = smp_processor_id();
-	} else if (bc->bound_on == smp_processor_id()) {
-		hrtimer_set_expires(&bctimer, expires);
-	}
+	RCU_NONIDLE( {
+		hrtimer_start(&bctimer, expires, HRTIMER_MODE_ABS_PINNED_HARD);
+		/*
+		 * The core tick broadcast mode expects bc->bound_on to be set
+		 * correctly to prevent a CPU which has the broadcast hrtimer
+		 * armed from going deep idle.
+		 *
+		 * As tick_broadcast_lock is held, nothing can change the cpu
+		 * base which was just established in hrtimer_start() above. So
+		 * the below access is safe even without holding the hrtimer
+		 * base lock.
+		 */
+		bc->bound_on = bctimer.base->cpu_base->cpu;
+	} );
 	return 0;
 }
 
@@ -100,10 +100,6 @@ static enum hrtimer_restart bc_handler(struct hrtimer *t)
 {
 	ce_broadcast_hrtimer.event_handler(&ce_broadcast_hrtimer);
 
-	if (clockevent_state_oneshot(&ce_broadcast_hrtimer))
-		if (ce_broadcast_hrtimer.next_event != KTIME_MAX)
-			return HRTIMER_RESTART;
-
 	return HRTIMER_NORESTART;
 }
 

