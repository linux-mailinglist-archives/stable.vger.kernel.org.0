Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D615F17D65E
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 22:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgCHVhq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Mar 2020 17:37:46 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37670 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbgCHVhq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Mar 2020 17:37:46 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jB3cG-0002MX-AB; Sun, 08 Mar 2020 15:37:44 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jB3cF-0001jz-Gr; Sun, 08 Mar 2020 15:37:44 -0600
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
Date:   Sun, 08 Mar 2020 16:35:26 -0500
In-Reply-To: <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
        message of "Sun, 08 Mar 2020 16:34:37 -0500")
Message-ID: <87pndm5y3l.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jB3cF-0001jz-Gr;;;mid=<87pndm5y3l.fsf_-_@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18AjT7avwFNhQmMIUwtX5s1uGVEa8UOnmE=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa04.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TooManySym_01,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4998]
        *  0.7 XMSubLong Long Subject
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 307 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 7 (2.4%), b_tie_ro: 5 (1.6%), parse: 1.25 (0.4%),
        extract_message_metadata: 12 (3.8%), get_uri_detail_list: 1.21 (0.4%),
        tests_pri_-1000: 18 (5.8%), tests_pri_-950: 1.24 (0.4%),
        tests_pri_-900: 1.03 (0.3%), tests_pri_-90: 28 (9.1%), check_bayes: 26
        (8.6%), b_tokenize: 11 (3.6%), b_tok_get_all: 8 (2.5%), b_comp_prob:
        2.3 (0.7%), b_tok_touch_all: 3.4 (1.1%), b_finish: 0.69 (0.2%),
        tests_pri_0: 219 (71.3%), check_dkim_signature: 0.57 (0.2%),
        check_dkim_adsp: 2.5 (0.8%), poll_dns_idle: 0.75 (0.2%), tests_pri_10:
        4.3 (1.4%), tests_pri_500: 12 (3.9%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH v2 1/5] exec: Only compute current once in flush_old_exec
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Make it clear that current only needs to be computed once in
flush_old_exec.  This may have some efficiency improvements and it
makes the code easier to change.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/exec.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index db17be51b112..c3f34791f2f0 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1260,13 +1260,14 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
  */
 int flush_old_exec(struct linux_binprm * bprm)
 {
+	struct task_struct *me = current;
 	int retval;
 
 	/*
 	 * Make sure we have a private signal table and that
 	 * we are unassociated from the previous thread group.
 	 */
-	retval = de_thread(current);
+	retval = de_thread(me);
 	if (retval)
 		goto out;
 
@@ -1294,10 +1295,10 @@ int flush_old_exec(struct linux_binprm * bprm)
 	bprm->mm = NULL;
 
 	set_fs(USER_DS);
-	current->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
+	me->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
 					PF_NOFREEZE | PF_NO_SETAFFINITY);
 	flush_thread();
-	current->personality &= ~bprm->per_clear;
+	me->personality &= ~bprm->per_clear;
 
 	/*
 	 * We have to apply CLOEXEC before we change whether the process is
@@ -1305,7 +1306,7 @@ int flush_old_exec(struct linux_binprm * bprm)
 	 * trying to access the should-be-closed file descriptors of a process
 	 * undergoing exec(2).
 	 */
-	do_close_on_exec(current->files);
+	do_close_on_exec(me->files);
 	return 0;
 
 out:
-- 
2.25.0

