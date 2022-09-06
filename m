Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929F05AE6F2
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 13:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbiIFLy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 07:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbiIFLy0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 07:54:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CA1C44
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 04:54:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C90E1B817C2
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:54:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE48DC433C1;
        Tue,  6 Sep 2022 11:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662465262;
        bh=V0otFeIdAAZhnCsEE3qjPXaxLlqR8g8pbnQUS/PjrAo=;
        h=Subject:To:Cc:From:Date:From;
        b=z/6Ty5gg/MDxz3AuDDLcKqf7a9Bqz8+5NS2Yl6fL6FA7f4NhTTQbmg3dvr36h7cb1
         j3zzU7ULeRjg7P+bVva2kzDm/wY/4+r7tkbBpfJf2mKI/7kn1gPeB+Him95UIg9lRH
         Lvz31KPu6RzDwIubfw2hdLuNiCyhyGdCQ6KFhCIM=
Subject: FAILED: patch "[PATCH] tty: n_gsm: initialize more members at gsm_alloc_mux()" failed to apply to 4.19-stable tree
To:     penguin-kernel@I-love.SAKURA.ne.jp, gregkh@linuxfoundation.org,
        jirislaby@kernel.org, stable@kernel.org,
        syzbot+cf155def4e717db68a12@syzkaller.appspotmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 13:54:12 +0200
Message-ID: <166246525293132@kroah.com>
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

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
1ec92e974277 ("tty: n_gsm: fix decoupled mux resource")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4bb1a53be85fcb1e24c14860e326a00cdd362c28 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sat, 27 Aug 2022 22:47:19 +0900
Subject: [PATCH] tty: n_gsm: initialize more members at gsm_alloc_mux()

syzbot is reporting use of uninitialized spinlock at gsmld_write() [1], for
commit 32dd59f96924f45e ("tty: n_gsm: fix race condition in gsmld_write()")
allows accessing gsm->tx_lock before gsm_activate_mux() initializes it.

Since object initialization should be done right after allocation in order
to avoid accessing uninitialized memory, move initialization of
timer/work/waitqueue/spinlock from gsmld_open()/gsm_activate_mux() to
gsm_alloc_mux().

Link: https://syzkaller.appspot.com/bug?extid=cf155def4e717db68a12 [1]
Fixes: 32dd59f96924f45e ("tty: n_gsm: fix race condition in gsmld_write()")
Reported-by: syzbot <syzbot+cf155def4e717db68a12@syzkaller.appspotmail.com>
Tested-by: syzbot <syzbot+cf155def4e717db68a12@syzkaller.appspotmail.com>
Cc: stable <stable@kernel.org>
Acked-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://lore.kernel.org/r/2110618e-57f0-c1ce-b2ad-b6cacef3f60e@I-love.SAKURA.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 38688cb16c20..d6598ca3640f 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2501,13 +2501,6 @@ static int gsm_activate_mux(struct gsm_mux *gsm)
 	if (dlci == NULL)
 		return -ENOMEM;
 
-	timer_setup(&gsm->kick_timer, gsm_kick_timer, 0);
-	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
-	INIT_WORK(&gsm->tx_work, gsmld_write_task);
-	init_waitqueue_head(&gsm->event);
-	spin_lock_init(&gsm->control_lock);
-	spin_lock_init(&gsm->tx_lock);
-
 	if (gsm->encoding == 0)
 		gsm->receive = gsm0_receive;
 	else
@@ -2612,6 +2605,12 @@ static struct gsm_mux *gsm_alloc_mux(void)
 	kref_init(&gsm->ref);
 	INIT_LIST_HEAD(&gsm->tx_ctrl_list);
 	INIT_LIST_HEAD(&gsm->tx_data_list);
+	timer_setup(&gsm->kick_timer, gsm_kick_timer, 0);
+	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
+	INIT_WORK(&gsm->tx_work, gsmld_write_task);
+	init_waitqueue_head(&gsm->event);
+	spin_lock_init(&gsm->control_lock);
+	spin_lock_init(&gsm->tx_lock);
 
 	gsm->t1 = T1;
 	gsm->t2 = T2;
@@ -2947,10 +2946,6 @@ static int gsmld_open(struct tty_struct *tty)
 
 	gsmld_attach_gsm(tty, gsm);
 
-	timer_setup(&gsm->kick_timer, gsm_kick_timer, 0);
-	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
-	INIT_WORK(&gsm->tx_work, gsmld_write_task);
-
 	return 0;
 }
 

