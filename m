Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4415AE6F6
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 13:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbiIFLyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 07:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234182AbiIFLys (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 07:54:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F7E167F7
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 04:54:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1537E614DF
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D457C433D7;
        Tue,  6 Sep 2022 11:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662465284;
        bh=a3srVyGRW9T6aQWjdDMx9znd2Byw5sU1jMGi+kdFdF8=;
        h=Subject:To:Cc:From:Date:From;
        b=dN4ZHqU51dSzv4/6x5ZKuplWJNz8yn3HnhIEYPEUcn3J0oVAT0DZlxSaW7q+5Fn0u
         CCOidYGz6qdGE6EugTtsgni0gh62nvhxqJtBJWNz+b8L+yoeFWXgbVFxm4FsPrqqmT
         1fL61srXAEsnDZkv/T/RVYjfyhl9eueFAT5YA6Ag=
Subject: FAILED: patch "[PATCH] tty: n_gsm: replace kicktimer with delayed_work" failed to apply to 5.15-stable tree
To:     pchelkin@ispras.ru, gregkh@linuxfoundation.org, hdanton@sina.com,
        jirislaby@kernel.org, khoroshilov@ispras.ru, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 13:54:41 +0200
Message-ID: <166246528110177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

c9ab053e56ce ("tty: n_gsm: replace kicktimer with delayed_work")
4bb1a53be85f ("tty: n_gsm: initialize more members at gsm_alloc_mux()")
734966043860 ("tty: n_gsm: fix resource allocation order in gsm_activate_mux()")
0af021678d5d ("tty: n_gsm: fix deadlock and link starvation in outgoing data path")
bec0224816d1 ("tty: n_gsm: fix non flow control frames during mux flow off")
c568f7086c6e ("tty: n_gsm: fix missing timer to handle stalled links")
556fc8ac0651 ("tty: n_gsm: fix wrong queuing behavior in gsm_dlci_data_output()")
01aecd917114 ("tty: n_gsm: fix tty registration before control channel open")
925ea0fa5277 ("tty: n_gsm: Fix packet data hex dump output")
f4f7d6328721 ("tty: n_gsm: fix software flow control handling")
c19ffe00fed6 ("tty: n_gsm: fix invalid use of MSC in advanced option")
a8c5b8255f8a ("tty: n_gsm: fix broken virtual tty handling")
48473802506d ("tty: n_gsm: fix missing update of modem controls after DLCI open")
73029a4d7161 ("tty: n_gsm: fix reset fifo race condition")
398867f59f95 ("tty: n_gsm: fix wrong command frame length field encoding")
17eac6520285 ("tty: n_gsm: fix missing explicit ldisc flush")
deefc58bafb4 ("tty: n_gsm: fix wrong DLCI release order")
7a0e4b1733b6 ("tty: n_gsm: fix frame reception handling")
06d5afd4d640 ("tty: n_gsm: fix wrong signal octet encoding in convergence layer type 2")
284260f278b7 ("tty: n_gsm: fix mux cleanup after unregister tty device")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c9ab053e56ce13a949977398c8edc12e6c02fc95 Mon Sep 17 00:00:00 2001
From: Fedor Pchelkin <pchelkin@ispras.ru>
Date: Mon, 29 Aug 2022 16:16:39 +0300
Subject: [PATCH] tty: n_gsm: replace kicktimer with delayed_work

A kick_timer timer_list is replaced with kick_timeout delayed_work to be
able to synchronize with mutexes as a prerequisite for the introduction
of tx_mutex.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: c568f7086c6e ("tty: n_gsm: fix missing timer to handle stalled links")
Cc: stable <stable@kernel.org>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Suggested-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Link: https://lore.kernel.org/r/20220829131640.69254-2-pchelkin@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index d6598ca3640f..e23225aff5d9 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -256,7 +256,7 @@ struct gsm_mux {
 	struct list_head tx_data_list;	/* Pending data packets */
 
 	/* Control messages */
-	struct timer_list kick_timer;	/* Kick TX queuing on timeout */
+	struct delayed_work kick_timeout;	/* Kick TX queuing on timeout */
 	struct timer_list t2_timer;	/* Retransmit timer for commands */
 	int cretries;			/* Command retry counter */
 	struct gsm_control *pending_cmd;/* Our current pending command */
@@ -1009,7 +1009,7 @@ static void __gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
 	gsm->tx_bytes += msg->len;
 
 	gsmld_write_trigger(gsm);
-	mod_timer(&gsm->kick_timer, jiffies + 10 * gsm->t1 * HZ / 100);
+	schedule_delayed_work(&gsm->kick_timeout, 10 * gsm->t1 * HZ / 100);
 }
 
 /**
@@ -1984,16 +1984,16 @@ static void gsm_dlci_command(struct gsm_dlci *dlci, const u8 *data, int len)
 }
 
 /**
- *	gsm_kick_timer	-	transmit if possible
- *	@t: timer contained in our gsm object
+ *	gsm_kick_timeout	-	transmit if possible
+ *	@work: work contained in our gsm object
  *
  *	Transmit data from DLCIs if the queue is empty. We can't rely on
  *	a tty wakeup except when we filled the pipe so we need to fire off
  *	new data ourselves in other cases.
  */
-static void gsm_kick_timer(struct timer_list *t)
+static void gsm_kick_timeout(struct work_struct *work)
 {
-	struct gsm_mux *gsm = from_timer(gsm, t, kick_timer);
+	struct gsm_mux *gsm = container_of(work, struct gsm_mux, kick_timeout.work);
 	unsigned long flags;
 	int sent = 0;
 
@@ -2458,7 +2458,7 @@ static void gsm_cleanup_mux(struct gsm_mux *gsm, bool disc)
 	}
 
 	/* Finish outstanding timers, making sure they are done */
-	del_timer_sync(&gsm->kick_timer);
+	cancel_delayed_work_sync(&gsm->kick_timeout);
 	del_timer_sync(&gsm->t2_timer);
 
 	/* Finish writing to ldisc */
@@ -2605,7 +2605,7 @@ static struct gsm_mux *gsm_alloc_mux(void)
 	kref_init(&gsm->ref);
 	INIT_LIST_HEAD(&gsm->tx_ctrl_list);
 	INIT_LIST_HEAD(&gsm->tx_data_list);
-	timer_setup(&gsm->kick_timer, gsm_kick_timer, 0);
+	INIT_DELAYED_WORK(&gsm->kick_timeout, gsm_kick_timeout);
 	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
 	INIT_WORK(&gsm->tx_work, gsmld_write_task);
 	init_waitqueue_head(&gsm->event);

