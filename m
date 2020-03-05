Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7C317B085
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 22:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgCEVSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 16:18:37 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:55992 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgCEVSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 16:18:37 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j9xt5-00064J-PB; Thu, 05 Mar 2020 14:18:35 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j9xt3-0006jv-IP; Thu, 05 Mar 2020 14:18:34 -0700
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
Date:   Thu, 05 Mar 2020 15:16:19 -0600
In-Reply-To: <87tv32cxmf.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
        message of "Thu, 05 Mar 2020 15:14:48 -0600")
Message-ID: <87imjicxjw.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j9xt3-0006jv-IP;;;mid=<87imjicxjw.fsf_-_@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Ke44Q6fKPaJ7zQUca6OucIZKtA6Q4G4s=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa05.xmission.com
X-Spam-Level: ***
X-Spam-Status: No, score=3.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,LotsOfNums_01,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        XMNoVowels,XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 469 ms - load_scoreonly_sql: 0.14 (0.0%),
        signal_user_changed: 5 (1.1%), b_tie_ro: 3.3 (0.7%), parse: 2.6 (0.6%),
         extract_message_metadata: 23 (4.9%), get_uri_detail_list: 5 (1.1%),
        tests_pri_-1000: 25 (5.4%), tests_pri_-950: 1.90 (0.4%),
        tests_pri_-900: 1.45 (0.3%), tests_pri_-90: 43 (9.1%), check_bayes: 41
        (8.8%), b_tokenize: 19 (4.1%), b_tok_get_all: 11 (2.3%), b_comp_prob:
        3.6 (0.8%), b_tok_touch_all: 5.0 (1.1%), b_finish: 0.78 (0.2%),
        tests_pri_0: 348 (74.3%), check_dkim_signature: 0.81 (0.2%),
        check_dkim_adsp: 2.5 (0.5%), poll_dns_idle: 0.58 (0.1%), tests_pri_10:
        2.1 (0.5%), tests_pri_500: 10 (2.2%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH 2/2] exec: Add a exec_update_mutex to replace cred_guard_mutex
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The cred_guard_mutex is problematic.  The cred_guard_mutex is held
over the userspace accesses as the arguments from userspace are read.
The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
threads are killed.  The cred_guard_mutex is held over
"put_user(0, tsk->clear_child_tid)" in exit_mm().

Any of those can result in deadlock, as the cred_guard_mutex is held
over a possible indefinite userspace waits for userspace.

Add exec_update_mutex that is only held over exec updating process
with the new contents of exec, so that code that needs not to be
confused by exec changing the mm and the cred in ways that can not
happen during ordinary execution of a process can take.

The plan is to switch the users of cred_guard_mutex to
exed_udpate_mutex one by one.  This lets us move forward while still
being careful and not introducing any regressions.

Link: https://lore.kernel.org/lkml/20160921152946.GA24210@dhcp22.suse.cz/
Link: https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
Link: https://lore.kernel.org/linux-fsdevel/20161102181806.GB1112@redhat.com/
Link: https://lore.kernel.org/lkml/20160923095031.GA14923@redhat.com/
Link: https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
Ref: 45c1a159b85b ("Add PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT facilities.")
Ref: 456f17cd1a28 ("[PATCH] user-vm-unlock-2.5.31-A2")
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/exec.c                    | 4 ++++
 include/linux/sched/signal.h | 9 ++++++++-
 kernel/fork.c                | 1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index c243f9660d46..ad7b518f906d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1182,6 +1182,7 @@ static int de_thread(struct linux_binprm *bprm, struct task_struct *tsk)
 		release_task(leader);
 	}
 
+	mutex_lock(&current->signal->exec_update_mutex);
 	bprm->unrecoverable = true;
 	sig->group_exit_task = NULL;
 	sig->notify_count = 0;
@@ -1425,6 +1426,8 @@ static void free_bprm(struct linux_binprm *bprm)
 {
 	free_arg_pages(bprm);
 	if (bprm->cred) {
+		if (bprm->unrecoverable)
+			mutex_unlock(&current->signal->exec_update_mutex);
 		mutex_unlock(&current->signal->cred_guard_mutex);
 		abort_creds(bprm->cred);
 	}
@@ -1474,6 +1477,7 @@ void install_exec_creds(struct linux_binprm *bprm)
 	 * credentials; any time after this it may be unlocked.
 	 */
 	security_bprm_committed_creds(bprm);
+	mutex_unlock(&current->signal->exec_update_mutex);
 	mutex_unlock(&current->signal->cred_guard_mutex);
 }
 EXPORT_SYMBOL(install_exec_creds);
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 88050259c466..a29df79540ce 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -224,7 +224,14 @@ struct signal_struct {
 
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
-					 * (notably. ptrace) */
+					 * (notably. ptrace)
+					 * Deprecated do not use in new code.
+					 * Use exec_update_mutex instead.
+					 */
+	struct mutex exec_update_mutex;	/* Held while task_struct is being
+					 * updated during exec, and may have
+					 * inconsistent permissions.
+					 */
 } __randomize_layout;
 
 /*
diff --git a/kernel/fork.c b/kernel/fork.c
index 60a1295f4384..12896a6ecee6 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1594,6 +1594,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
 
 	mutex_init(&sig->cred_guard_mutex);
+	mutex_init(&sig->exec_update_mutex);
 
 	return 0;
 }
-- 
2.25.0

