Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8A517B071
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 22:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgCEVRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 16:17:18 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35394 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgCEVRS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 16:17:18 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j9xrb-0000jm-0q; Thu, 05 Mar 2020 14:17:03 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j9xrZ-0006Hu-U8; Thu, 05 Mar 2020 14:17:02 -0700
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
Date:   Thu, 05 Mar 2020 15:14:48 -0600
In-Reply-To: <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Thu, 5 Mar 2020 18:36:53 +0000")
Message-ID: <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j9xrZ-0006Hu-U8;;;mid=<87tv32cxmf.fsf_-_@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19PkZFb5/n1hZBXmR96TXlIgx1ImOcYE8M=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa04.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,XMNoVowels autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4805]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 611 ms - load_scoreonly_sql: 0.08 (0.0%),
        signal_user_changed: 3.9 (0.6%), b_tie_ro: 2.6 (0.4%), parse: 1.53
        (0.3%), extract_message_metadata: 3.8 (0.6%), get_uri_detail_list:
        1.30 (0.2%), tests_pri_-1000: 10 (1.6%), tests_pri_-950: 1.62 (0.3%),
        tests_pri_-900: 1.35 (0.2%), tests_pri_-90: 32 (5.3%), check_bayes: 31
        (5.0%), b_tokenize: 13 (2.2%), b_tok_get_all: 8 (1.4%), b_comp_prob:
        2.9 (0.5%), b_tok_touch_all: 3.8 (0.6%), b_finish: 0.75 (0.1%),
        tests_pri_0: 538 (88.0%), check_dkim_signature: 0.60 (0.1%),
        check_dkim_adsp: 2.5 (0.4%), poll_dns_idle: 0.60 (0.1%), tests_pri_10:
        2.0 (0.3%), tests_pri_500: 6 (1.0%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH 0/2] Infrastructure to allow fixing exec deadlocks
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

- Correct the point of no return.
- Add a new mutex to replace cred_guard_mutex

Then I think it is just going through the existing
users of cred_guard_mutex and fixing them to use the new one.

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

Bernd does this make sense to you?  

I think we can fix the seccomp/no_new_privs issue with some careful
refactoring.  We can probably do the same for ptrace but that appears
to need a little lsm bug fixing.

My goal here is to allow us to fix the uncontroversial easy bits.  While
still allowing the difficult tricky bits to be fixed.

Eric W. Biederman (2):
      exec: Properly mark the point of no return
      exec: Add a exec_update_mutex to replace cred_guard_mutex

 fs/exec.c                    | 11 ++++++++---
 include/linux/binfmts.h      |  7 ++++++-
 include/linux/sched/signal.h |  9 ++++++++-
 kernel/fork.c                |  1 +
 4 files changed, 23 insertions(+), 5 deletions(-)

Eric
