Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0709506C
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 00:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbfHSWDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 18:03:14 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:33778 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbfHSWDO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 18:03:14 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hzpk7-0006yY-Jm; Mon, 19 Aug 2019 16:03:11 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hzpk6-0006Nx-E2; Mon, 19 Aug 2019 16:03:11 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Philipp Reisner <philipp.reisner@linbit.com>,
        David Laight <David.Laight@aculab.com>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Jeff Layton <jlayton@primarydata.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Christoph =?utf-8?Q?B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>, Oleg Nesterov <oleg@redhat.com>
References: <20190729083248.30362-1-christoph.boehmwalder@linbit.com>
        <1761552.9xIroHqhk7@fat-tyre>
        <1fcbb94c5f264c17af3394807438ad50@AcuMS.aculab.com>
        <2789113.VEJ2NpTmzX@fat-tyre> <87k1bclpmt.fsf_-_@xmission.com>
        <20190819083759.73ee5zct4yxbyyfd@gintonic.linbit>
Date:   Mon, 19 Aug 2019 17:03:01 -0500
In-Reply-To: <20190819083759.73ee5zct4yxbyyfd@gintonic.linbit> ("Christoph
        \=\?utf-8\?Q\?B\=C3\=B6hmwalder\=22's\?\= message of "Mon, 19 Aug 2019 10:37:59
 +0200")
Message-ID: <87ftlwke3u.fsf_-_@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hzpk6-0006Nx-E2;;;mid=<87ftlwke3u.fsf_-_@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+/eA/ihhCUw4yPzviJdoRZb4ArWVEvcl4=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: ****
X-Spam-Status: No, score=4.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,XMSexyCombo_01,XMSubLong,XMSubMetaSxObfu_03,
        XMSubMetaSx_00,XM_Body_Dirty_Words autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  1.0 XMSubMetaSx_00 1+ Sexy Words
        *  0.5 XM_Body_Dirty_Words Contains a dirty word
        *  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
        *  1.0 XMSexyCombo_01 Sexy words in both body/subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 836 ms - load_scoreonly_sql: 0.12 (0.0%),
        signal_user_changed: 3.2 (0.4%), b_tie_ro: 2.1 (0.3%), parse: 1.91
        (0.2%), extract_message_metadata: 7 (0.8%), get_uri_detail_list: 3.2
        (0.4%), tests_pri_-1000: 6 (0.8%), tests_pri_-950: 2.0 (0.2%),
        tests_pri_-900: 1.61 (0.2%), tests_pri_-90: 39 (4.7%), check_bayes: 37
        (4.4%), b_tokenize: 17 (2.0%), b_tok_get_all: 9 (1.1%), b_comp_prob:
        4.3 (0.5%), b_tok_touch_all: 3.4 (0.4%), b_finish: 0.77 (0.1%),
        tests_pri_0: 747 (89.4%), check_dkim_signature: 1.12 (0.1%),
        check_dkim_adsp: 2.9 (0.3%), poll_dns_idle: 0.42 (0.1%), tests_pri_10:
        3.5 (0.4%), tests_pri_500: 10 (1.2%), rewrite_mail: 0.00 (0.0%)
Subject: [GIT PULL] signal: Allow cifs and drbd to receive their terminating signals
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Linus,

Please pull the siginfo-linus branch from the git tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git siginfo-linus

   HEAD: 33da8e7c814f77310250bb54a9db36a44c5de784 signal: Allow cifs and drbd to receive their terminating signals

I overlooked the fact that kernel threads are created with all signals
set to SIG_IGN, and accidentally caused a regression in cifs and drbd
when replacing force_sig with send_sig.

This pull request is my fix for that regression.  I add a new function
allow_kernel_signal which allows kernel threads to receive signals sent
from the kernel, but continues to ignore all signals sent from
userspace.  This ensures the user space interface for cifs and drbd
remain the same.

These kernel threads depend on blocking networking calls which block
until something is received or a signal is pending.  Making receiving
of signals somewhat necessary for these kernel threads.  Perhaps someday
we can cleanup those interfaces and remove allow_kernel_signal.  If not
allow_kernel_signal is pretty trivial and clearly documents what is
going on so I don't think we will mind carrying it.

Eric W. Biederman (1):
      signal: Allow cifs and drbd to receive their terminating signals

 drivers/block/drbd/drbd_main.c |  2 ++
 fs/cifs/connect.c              |  2 +-
 include/linux/signal.h         | 15 ++++++++++++++-
 kernel/signal.c                |  5 +++++
 4 files changed, 22 insertions(+), 2 deletions(-)

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
index b5d99482d3fe..1a5f88316b08 100644
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
+	 * know signals sent by the kernel will be handled, so that they
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

