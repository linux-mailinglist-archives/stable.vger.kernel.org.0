Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFA517D665
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 22:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgCHVii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Mar 2020 17:38:38 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45782 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbgCHVih (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Mar 2020 17:38:37 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jB3d4-0007cP-VM; Sun, 08 Mar 2020 15:38:35 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jB3d3-0001ox-Uq; Sun, 08 Mar 2020 15:38:34 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
        Yuyang Du <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Christian Kellner <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87k142lpfz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <875zfmloir.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87v9nmjulm.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <202003021531.C77EF10@keescook>
        <20200303085802.eqn6jbhwxtmz4j2x@wittgenstein>
        <AM6PR03MB5170285B336790D3450E2644E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87v9nlii0b.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87a74xi4kz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y8dqqz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
        <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
Date:   Sun, 08 Mar 2020 16:36:17 -0500
In-Reply-To: <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
        message of "Sun, 08 Mar 2020 16:34:37 -0500")
Message-ID: <87k13u5y26.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jB3d3-0001ox-Uq;;;mid=<87k13u5y26.fsf_-_@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX181hWQFhcXeH2DZ7lmXnC5JxL6rk00Uo9s=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TooManySym_01,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.7 XMSubLong Long Subject
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 592 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 3.0 (0.5%), b_tie_ro: 2.1 (0.3%), parse: 1.46
        (0.2%), extract_message_metadata: 13 (2.2%), get_uri_detail_list: 1.98
        (0.3%), tests_pri_-1000: 17 (2.8%), tests_pri_-950: 1.24 (0.2%),
        tests_pri_-900: 1.07 (0.2%), tests_pri_-90: 31 (5.2%), check_bayes: 30
        (5.0%), b_tokenize: 12 (2.0%), b_tok_get_all: 9 (1.6%), b_comp_prob:
        2.2 (0.4%), b_tok_touch_all: 4.0 (0.7%), b_finish: 0.61 (0.1%),
        tests_pri_0: 514 (86.8%), check_dkim_signature: 0.57 (0.1%),
        check_dkim_adsp: 2.6 (0.4%), poll_dns_idle: 1.00 (0.2%), tests_pri_10:
        2.1 (0.4%), tests_pri_500: 6 (1.0%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH v2 2/5] exec: Factor unshare_sighand out of de_thread and call it separately
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This makes the code clearer and makes it easier to implement a mutex
that is not taken over any locations that may block indefinitely waiting
for userspace.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/exec.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index c3f34791f2f0..ff74b9a74d34 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1194,6 +1194,23 @@ static int de_thread(struct task_struct *tsk)
 	flush_itimer_signals();
 #endif
 
+	BUG_ON(!thread_group_leader(tsk));
+	return 0;
+
+killed:
+	/* protects against exit_notify() and __exit_signal() */
+	read_lock(&tasklist_lock);
+	sig->group_exit_task = NULL;
+	sig->notify_count = 0;
+	read_unlock(&tasklist_lock);
+	return -EAGAIN;
+}
+
+
+static int unshare_sighand(struct task_struct *me)
+{
+	struct sighand_struct *oldsighand = me->sighand;
+
 	if (refcount_read(&oldsighand->count) != 1) {
 		struct sighand_struct *newsighand;
 		/*
@@ -1210,23 +1227,13 @@ static int de_thread(struct task_struct *tsk)
 
 		write_lock_irq(&tasklist_lock);
 		spin_lock(&oldsighand->siglock);
-		rcu_assign_pointer(tsk->sighand, newsighand);
+		rcu_assign_pointer(me->sighand, newsighand);
 		spin_unlock(&oldsighand->siglock);
 		write_unlock_irq(&tasklist_lock);
 
 		__cleanup_sighand(oldsighand);
 	}
-
-	BUG_ON(!thread_group_leader(tsk));
 	return 0;
-
-killed:
-	/* protects against exit_notify() and __exit_signal() */
-	read_lock(&tasklist_lock);
-	sig->group_exit_task = NULL;
-	sig->notify_count = 0;
-	read_unlock(&tasklist_lock);
-	return -EAGAIN;
 }
 
 char *__get_task_comm(char *buf, size_t buf_size, struct task_struct *tsk)
@@ -1264,13 +1271,19 @@ int flush_old_exec(struct linux_binprm * bprm)
 	int retval;
 
 	/*
-	 * Make sure we have a private signal table and that
-	 * we are unassociated from the previous thread group.
+	 * Make this the only thread in the thread group.
 	 */
 	retval = de_thread(me);
 	if (retval)
 		goto out;
 
+	/*
+	 * Make the signal table private.
+	 */
+	retval = unshare_sighand(me);
+	if (retval)
+		goto out;
+
 	/*
 	 * Must be called _before_ exec_mmap() as bprm->mm is
 	 * not visibile until then. This also enables the update
-- 
2.25.0

