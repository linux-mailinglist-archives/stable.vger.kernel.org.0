Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E25617B07D
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 22:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgCEVRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 16:17:52 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35642 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbgCEVRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 16:17:52 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j9xsM-0000pK-Gf; Thu, 05 Mar 2020 14:17:50 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j9xsL-0006Wy-Nd; Thu, 05 Mar 2020 14:17:50 -0700
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
Date:   Thu, 05 Mar 2020 15:15:36 -0600
In-Reply-To: <87tv32cxmf.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
        message of "Thu, 05 Mar 2020 15:14:48 -0600")
Message-ID: <87o8tacxl3.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j9xsL-0006Wy-Nd;;;mid=<87o8tacxl3.fsf_-_@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19NkA3NbUrDnw7DDors6fjDf+oECzNhv98=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa03.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,XMNoVowels autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 367 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 3.0 (0.8%), b_tie_ro: 2.2 (0.6%), parse: 1.35
        (0.4%), extract_message_metadata: 12 (3.3%), get_uri_detail_list: 2.2
        (0.6%), tests_pri_-1000: 15 (4.1%), tests_pri_-950: 1.00 (0.3%),
        tests_pri_-900: 0.85 (0.2%), tests_pri_-90: 38 (10.3%), check_bayes:
        36 (9.9%), b_tokenize: 10 (2.6%), b_tok_get_all: 11 (2.9%),
        b_comp_prob: 2.1 (0.6%), b_tok_touch_all: 11 (3.0%), b_finish: 0.72
        (0.2%), tests_pri_0: 283 (77.3%), check_dkim_signature: 0.41 (0.1%),
        check_dkim_adsp: 2.2 (0.6%), poll_dns_idle: 0.68 (0.2%), tests_pri_10:
        2.6 (0.7%), tests_pri_500: 6 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH 1/2] exec: Properly mark the point of no return
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Add a flag binfmt->unrecoverable to mark when execution has gotten to
the point where it is impossible to return to userspace with the
calling process unchanged.

While techinically this state starts as soon as de_thread starts
killing threads, the only return path at that point is if there is a
fatal signal pending.  I have choosen instead to set unrecoverable
when the killing stops, and there are possibilities of failures other
than fatal signals.  In particular it is possible for the allocation
of a new sighand structure to fail.

Setting unrecoverable at this point has the benefit that other actions
can be taken after the other threads are all dead, and the
unrecoverable flag can double as a flag that those actions have been
taken.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/exec.c               | 7 ++++---
 include/linux/binfmts.h | 7 ++++++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index db17be51b112..c243f9660d46 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1061,7 +1061,7 @@ static int exec_mmap(struct mm_struct *mm)
  * disturbing other processes.  (Other processes might share the signal
  * table via the CLONE_SIGHAND option to clone().)
  */
-static int de_thread(struct task_struct *tsk)
+static int de_thread(struct linux_binprm *bprm, struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
 	struct sighand_struct *oldsighand = tsk->sighand;
@@ -1182,6 +1182,7 @@ static int de_thread(struct task_struct *tsk)
 		release_task(leader);
 	}
 
+	bprm->unrecoverable = true;
 	sig->group_exit_task = NULL;
 	sig->notify_count = 0;
 
@@ -1266,7 +1267,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 	 * Make sure we have a private signal table and that
 	 * we are unassociated from the previous thread group.
 	 */
-	retval = de_thread(current);
+	retval = de_thread(bprm, current);
 	if (retval)
 		goto out;
 
@@ -1664,7 +1665,7 @@ int search_binary_handler(struct linux_binprm *bprm)
 
 		read_lock(&binfmt_lock);
 		put_binfmt(fmt);
-		if (retval < 0 && !bprm->mm) {
+		if (retval < 0 && bprm->unrecoverable) {
 			/* we got to flush_old_exec() and failed after it */
 			read_unlock(&binfmt_lock);
 			force_sigsegv(SIGSEGV);
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index b40fc633f3be..12263115ce7a 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -44,7 +44,12 @@ struct linux_binprm {
 		 * exec has happened. Used to sanitize execution environment
 		 * and to set AT_SECURE auxv for glibc.
 		 */
-		secureexec:1;
+		secureexec:1,
+		/*
+		 * Set when changes have been made that prevent returning
+		 * to userspace.
+		 */
+		unrecoverable:1;
 #ifdef __alpha__
 	unsigned int taso:1;
 #endif
-- 
2.25.0

