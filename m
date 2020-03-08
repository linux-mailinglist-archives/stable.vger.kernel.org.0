Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 637DD17D65D
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 22:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgCHVhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Mar 2020 17:37:00 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45608 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbgCHVg7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Mar 2020 17:36:59 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jB3bT-0007ZJ-0B; Sun, 08 Mar 2020 15:36:55 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jB3bS-00064F-7L; Sun, 08 Mar 2020 15:36:54 -0600
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
Date:   Sun, 08 Mar 2020 16:34:37 -0500
In-Reply-To: <87tv32cxmf.fsf_-_@x220.int.ebiederm.org> (Eric W. Biederman's
        message of "Thu, 05 Mar 2020 15:14:48 -0600")
Message-ID: <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jB3bS-00064F-7L;;;mid=<87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18D3Lt6XSlAz5TMYYPswZO8/Y7S8x0tW1Y=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_40,
        DCC_CHECK_NEGATIVE,XMNoVowels autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
        *      [score: 0.3850]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 312 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 3.1 (1.0%), b_tie_ro: 2.1 (0.7%), parse: 1.00
        (0.3%), extract_message_metadata: 2.7 (0.9%), get_uri_detail_list:
        0.93 (0.3%), tests_pri_-1000: 7 (2.3%), tests_pri_-950: 1.16 (0.4%),
        tests_pri_-900: 1.12 (0.4%), tests_pri_-90: 38 (12.1%), check_bayes:
        36 (11.4%), b_tokenize: 18 (5.7%), b_tok_get_all: 9 (2.8%),
        b_comp_prob: 3.1 (1.0%), b_tok_touch_all: 3.6 (1.2%), b_finish: 0.98
        (0.3%), tests_pri_0: 239 (76.5%), check_dkim_signature: 0.81 (0.3%),
        check_dkim_adsp: 2.4 (0.8%), poll_dns_idle: 0.37 (0.1%), tests_pri_10:
        2.1 (0.7%), tests_pri_500: 10 (3.1%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH 0/5] Infrastructure to allow fixing exec deadlocks
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Bernd, everyone

This is how I think the infrastructure change should look that makes way
for fixing this issue.

- Cleanup and reorder the code so code that can potentially wait
  indefinitely for userspace comes at the beginning for flush_old_exec.
- Add a new mutex and take it after we have passed any potential
  indefinite waits for userspace.

Then I think it is just going through the existing users of
cred_guard_mutex and fixing them to use the new one.

There really aren't that many users of cred_guard_mutex so we should be
able to get through the easy ones fairly quickly.  And anything that
isn't easy we can wait until we have a good fix.

The users of cred_guard_mutex that I saw were:
    fs/proc/base.c:
       proc_pid_attr_write
       do_io_accounting
       proc_pid_stack
       proc_pid_syscall
       proc_pid_personality
    
    perf_event_open
    mm_access
    kcmp
    pidfd_fget
    seccomp_set_mode_filter

Bernd I think I have addressed the issues you pointed out in v1.
Please let me know if you see anything else.

Eric W. Biederman (5):
      exec: Only compute current once in flush_old_exec
      exec: Factor unshare_sighand out of de_thread and call it separately
      exec: Move cleanup of posix timers on exec out of de_thread
      exec: Move exec_mmap right after de_thread in flush_old_exec
      exec: Add a exec_update_mutex to replace cred_guard_mutex

 fs/exec.c                    | 65 ++++++++++++++++++++++++++++++--------------
 include/linux/sched/signal.h |  9 +++++-
 init/init_task.c             |  1 +
 kernel/fork.c                |  1 +
 4 files changed, 54 insertions(+), 22 deletions(-)


