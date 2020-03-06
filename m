Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1200D17C7C6
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 22:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgCFVVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 16:21:04 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:51586 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgCFVVD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 16:21:03 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jAKOf-0001bO-Qo; Fri, 06 Mar 2020 14:20:41 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jAKOe-0007Ua-SE; Fri, 06 Mar 2020 14:20:41 -0700
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
        <87imjicxjw.fsf_-_@x220.int.ebiederm.org>
        <AM6PR03MB5170375DBF699D4F3DC7A08DE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87k13yawpp.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170FC44E102D4F8C1B2E854E4E30@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Fri, 06 Mar 2020 15:18:20 -0600
In-Reply-To: <AM6PR03MB5170FC44E102D4F8C1B2E854E4E30@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Fri, 6 Mar 2020 11:46:01 +0000")
Message-ID: <877dzx9o83.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jAKOe-0007Ua-SE;;;mid=<877dzx9o83.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/H7zIdc5Xdrawq/Ho8JIA/FNvc5wTe1Zg=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: ***
X-Spam-Status: No, score=3.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,LotsOfNums_01,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        XMNoVowels,XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        *  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 496 ms - load_scoreonly_sql: 0.09 (0.0%),
        signal_user_changed: 8 (1.7%), b_tie_ro: 7 (1.5%), parse: 1.84 (0.4%),
        extract_message_metadata: 25 (5.0%), get_uri_detail_list: 4.8 (1.0%),
        tests_pri_-1000: 28 (5.7%), tests_pri_-950: 1.30 (0.3%),
        tests_pri_-900: 1.12 (0.2%), tests_pri_-90: 53 (10.6%), check_bayes:
        51 (10.3%), b_tokenize: 14 (2.9%), b_tok_get_all: 19 (3.8%),
        b_comp_prob: 3.2 (0.6%), b_tok_touch_all: 9 (1.9%), b_finish: 0.64
        (0.1%), tests_pri_0: 355 (71.7%), check_dkim_signature: 0.67 (0.1%),
        check_dkim_adsp: 2.4 (0.5%), poll_dns_idle: 0.81 (0.2%), tests_pri_10:
        2.3 (0.5%), tests_pri_500: 15 (2.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/2] exec: Add a exec_update_mutex to replace cred_guard_mutex
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> Am 06.03.20 um 06:17 schrieb Eric W. Biederman:
>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>> 
>>> On 3/5/20 10:16 PM, Eric W. Biederman wrote:
>>>>
>>>> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
>>>> over the userspace accesses as the arguments from userspace are read.
>>>> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
>>>> threads are killed.  The cred_guard_mutex is held over
>>>> "put_user(0, tsk->clear_child_tid)" in exit_mm().
>>>>
>>>> Any of those can result in deadlock, as the cred_guard_mutex is held
>>>> over a possible indefinite userspace waits for userspace.
>>>>
>>>> Add exec_update_mutex that is only held over exec updating process
>>>> with the new contents of exec, so that code that needs not to be
>>>> confused by exec changing the mm and the cred in ways that can not
>>>> happen during ordinary execution of a process can take.
>>>>
>>>> The plan is to switch the users of cred_guard_mutex to
>>>> exed_udpate_mutex one by one.  This lets us move forward while still
>>>> being careful and not introducing any regressions.
>>>>
>>>> Link: https://lore.kernel.org/lkml/20160921152946.GA24210@dhcp22.suse.cz/
>>>> Link: https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
>>>> Link: https://lore.kernel.org/linux-fsdevel/20161102181806.GB1112@redhat.com/
>>>> Link: https://lore.kernel.org/lkml/20160923095031.GA14923@redhat.com/
>>>> Link: https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
>>>> Ref: 45c1a159b85b ("Add PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT facilities.")
>>>> Ref: 456f17cd1a28 ("[PATCH] user-vm-unlock-2.5.31-A2")
>>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>>> ---
>>>>  fs/exec.c                    | 4 ++++
>>>>  include/linux/sched/signal.h | 9 ++++++++-
>>>>  kernel/fork.c                | 1 +
>>>>  3 files changed, 13 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/exec.c b/fs/exec.c
>>>> index c243f9660d46..ad7b518f906d 100644
>>>> --- a/fs/exec.c
>>>> +++ b/fs/exec.c
>>>> @@ -1182,6 +1182,7 @@ static int de_thread(struct linux_binprm *bprm, struct task_struct *tsk)
>>>>  		release_task(leader);
>>>>  	}
>>>>  
>>>> +	mutex_lock(&current->signal->exec_update_mutex);
>
> And by the way, could you make this mutex_lock_killable?

For some reason when I first read this suggestion I thought making this
mutex_lock_killable would cause me to rework the logic of when I
set unrecoverable and when I unlock the mutex.  I blame a tired brain.
If a process has received a fatal signal none of that matters.

So yes I will do that just to make things robust in case we miss
something that would still make it possible to deadlock in with the new
mutex.

I am a little worried that the new mutex might still cover a little too
much.  But past a certain point I we are not being able to make this
code perfect in the first change.  The best we can do is to be careful
and avoid regressions.  Whatever slips through we can fix when we spot
the problem.

Eric
