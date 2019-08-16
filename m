Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4618790ACF
	for <lists+stable@lfdr.de>; Sat, 17 Aug 2019 00:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbfHPWTx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 16 Aug 2019 18:19:53 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:38037 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbfHPWTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 18:19:53 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hykZb-0002PX-8t; Fri, 16 Aug 2019 16:19:51 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hykZZ-00038z-Al; Fri, 16 Aug 2019 16:19:50 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Philipp Reisner <philipp.reisner@linbit.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Jens Axboe <axboe@kernel.dk>,
        'Christoph =?utf-8?Q?B=C3=B6hmwalder'?= 
        <christoph.boehmwalder@linbit.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Jeff Layton <jlayton@primarydata.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
References: <20190729083248.30362-1-christoph.boehmwalder@linbit.com>
        <1761552.9xIroHqhk7@fat-tyre>
        <1fcbb94c5f264c17af3394807438ad50@AcuMS.aculab.com>
        <2789113.VEJ2NpTmzX@fat-tyre>
Date:   Fri, 16 Aug 2019 17:19:38 -0500
In-Reply-To: <2789113.VEJ2NpTmzX@fat-tyre> (Philipp Reisner's message of "Mon,
        12 Aug 2019 15:28:40 +0200")
Message-ID: <87k1bclpmt.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=1hykZZ-00038z-Al;;;mid=<87k1bclpmt.fsf_-_@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX196TKA3cUomzbCr9t0QsX4GbLXuZJrQJjg=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,XMSubLong,XM_Body_Dirty_Words autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Philipp Reisner <philipp.reisner@linbit.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1433 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 3.7 (0.3%), b_tie_ro: 2.6 (0.2%), parse: 1.29
        (0.1%), extract_message_metadata: 20 (1.4%), get_uri_detail_list: 3.5
        (0.2%), tests_pri_-1000: 15 (1.1%), tests_pri_-950: 1.33 (0.1%),
        tests_pri_-900: 1.15 (0.1%), tests_pri_-90: 36 (2.5%), check_bayes: 34
        (2.4%), b_tokenize: 13 (0.9%), b_tok_get_all: 12 (0.8%), b_comp_prob:
        3.5 (0.2%), b_tok_touch_all: 4.1 (0.3%), b_finish: 0.63 (0.0%),
        tests_pri_0: 734 (51.2%), check_dkim_signature: 0.83 (0.1%),
        check_dkim_adsp: 3.7 (0.3%), poll_dns_idle: 549 (38.3%), tests_pri_10:
        2.9 (0.2%), tests_pri_500: 613 (42.8%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH] signal: Allow cifs and drbd to receive their terminating signals
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


My recent to change to only use force_sig for a synchronous events
wound up breaking signal reception cifs and drbd.  I had overlooked
the fact that by default kthreads start out with all signals set to
SIG_IGN.  So a change I thought was safe turned out to have made it
impossible for those kernel thread to catch their signals.

Reverting the work on force_sig is a bad idea because what the code
was doing was very much a misuse of force_sig.  As the way force_sig
ultimately allowed the signal to happen was to change the signal
handler to SIG_DFL.  Which after the first signal will allow userspace
to send signals to these kernel threads.  At least for
wake_ack_receiver in drbd that does not appear actively wrong.

So correct this problem by adding allow_kernel_signal that will allow
signals whose siginfo reports they were sent by the kernel through,
but will not allow userspace generated signals, and update cifs and
drbd to call allow_kernel_signal in an appropriate place so that their
thread can receive this signal.

Fixing things this way ensures that userspace won't be able to send
signals and cause problems, that it is clear which signals the
threads are expecting to receive, and it guarantees that nothing
else in the system will be affected.

This change was partly inspired by similar cifs and drbd patches that
added allow_signal.

Reported-by: ronnie sahlberg <ronniesahlberg@gmail.com>
Reported-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Cc: Steve French <smfrench@gmail.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Fixes: 247bc9470b1e ("cifs: fix rmmod regression in cifs.ko caused by force_sig changes")
Fixes: 72abe3bcf091 ("signal/cifs: Fix cifs_put_tcp_session to call send_sig instead of force_sig")
Fixes: fee109901f39 ("signal/drbd: Use send_sig not force_sig")
Fixes: 3cf5d076fb4d ("signal: Remove task parameter from force_sig")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/block/drbd/drbd_main.c |  2 ++
 fs/cifs/connect.c              |  2 +-
 include/linux/signal.h         | 15 ++++++++++++++-
 kernel/signal.c                |  5 +++++
 4 files changed, 22 insertions(+), 2 deletions(-)

Folks my apolgies for this mess and for taking so long to suggest an
improvement.  I needed a good nights sleep to think about this and
with a new baby at home that has been a challenge to get.

Unless someone has an objection or sees a problem with this patch I will
send this to Linus in the next couple of days.

I think adding allow_kernel_signal is better because it makes it clear
that userspace does not mess with these signals.  I would love it if we
could avoid signals all together but that appears tricky in the
presence of kernel threads making blocking network requests.

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 9bd4ddd12b25..5b248763a672 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -322,6 +322,8 @@ static int drbd_thread_setup(void *arg)
 		 thi->name[0],
 		 resource->name);
 
+	allow_kernel_signal(DRBD_SIGKILL);
+	allow_kernel_signal(SIGXCPU);
 restart:
 	retval = thi->function(thi);
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a15a6e738eb5..1795e80cbdf7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1113,7 +1113,7 @@ cifs_demultiplex_thread(void *p)
 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
 
 	set_freezable();
-	allow_signal(SIGKILL);
+	allow_kernel_signal(SIGKILL);
 	while (server->tcpStatus != CifsExiting) {
 		if (try_to_freeze())
 			continue;
diff --git a/include/linux/signal.h b/include/linux/signal.h
index b5d99482d3fe..703fa20c06f5 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -282,6 +282,9 @@ extern void signal_setup_done(int failed, struct ksignal *ksig, int stepping);
 extern void exit_signals(struct task_struct *tsk);
 extern void kernel_sigaction(int, __sighandler_t);
 
+#define SIG_KTHREAD ((__force __sighandler_t)2)
+#define SIG_KTHREAD_KERNEL ((__force __sighandler_t)3)
+
 static inline void allow_signal(int sig)
 {
 	/*
@@ -289,7 +292,17 @@ static inline void allow_signal(int sig)
 	 * know it'll be handled, so that they don't get converted to
 	 * SIGKILL or just silently dropped.
 	 */
-	kernel_sigaction(sig, (__force __sighandler_t)2);
+	kernel_sigaction(sig, SIG_KTHREAD);
+}
+
+static inline void allow_kernel_signal(int sig)
+{
+	/*
+	 * Kernel threads handle their own signals. Let the signal code
+	 * kwown signals sent by the kernel will be handled, so that they
+	 * don't get silently dropped.
+	 */
+	kernel_sigaction(sig, SIG_KTHREAD_KERNEL);
 }
 
 static inline void disallow_signal(int sig)
diff --git a/kernel/signal.c b/kernel/signal.c
index e667be6907d7..534fec266a33 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -90,6 +90,11 @@ static bool sig_task_ignored(struct task_struct *t, int sig, bool force)
 	    handler == SIG_DFL && !(force && sig_kernel_only(sig)))
 		return true;
 
+	/* Only allow kernel generated signals to this kthread */
+	if (unlikely((t->flags & PF_KTHREAD) &&
+		     (handler == SIG_KTHREAD_KERNEL) && !force))
+		return true;
+
 	return sig_handler_ignored(handler, sig);
 }
 
-- 
2.21.0.dirty

Eric
