Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2A25180A49
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 22:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgCJVWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 17:22:36 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:47318 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgCJVWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 17:22:36 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBmKe-0001lA-LQ; Tue, 10 Mar 2020 15:22:32 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBmKd-0001Rk-94; Tue, 10 Mar 2020 15:22:32 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Kees Cook <keescook@chromium.org>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
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
References: <87v9nlii0b.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87a74xi4kz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y8dqqz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
        <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
        <875zfe5xzb.fsf_-_@x220.int.ebiederm.org>
        <202003101337.AC1A30576@keescook>
Date:   Tue, 10 Mar 2020 16:20:12 -0500
In-Reply-To: <202003101337.AC1A30576@keescook> (Kees Cook's message of "Tue,
        10 Mar 2020 13:44:09 -0700")
Message-ID: <87sgifq54j.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBmKd-0001Rk-94;;;mid=<87sgifq54j.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/uSgxqQ7yJ0LmMGrR7SNxCBN/dTq54Iqs=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4979]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kees Cook <keescook@chromium.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 966 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 2.8 (0.3%), b_tie_ro: 1.78 (0.2%), parse: 1.85
        (0.2%), extract_message_metadata: 24 (2.5%), get_uri_detail_list: 4.5
        (0.5%), tests_pri_-1000: 42 (4.4%), tests_pri_-950: 1.97 (0.2%),
        tests_pri_-900: 1.73 (0.2%), tests_pri_-90: 48 (4.9%), check_bayes: 46
        (4.7%), b_tokenize: 23 (2.3%), b_tok_get_all: 12 (1.2%), b_comp_prob:
        3.6 (0.4%), b_tok_touch_all: 4.4 (0.5%), b_finish: 0.80 (0.1%),
        tests_pri_0: 825 (85.4%), check_dkim_signature: 0.68 (0.1%),
        check_dkim_adsp: 2.2 (0.2%), poll_dns_idle: 0.52 (0.1%), tests_pri_10:
        2.2 (0.2%), tests_pri_500: 12 (1.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2 4/5] exec: Move exec_mmap right after de_thread in flush_old_exec
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Sun, Mar 08, 2020 at 04:38:00PM -0500, Eric W. Biederman wrote:
>> 
>> I have read through the code in exec_mmap and I do not see anything
>> that depends on sighand or the sighand lock, or on signals in anyway
>> so this should be safe.
>> 
>> This rearrangement of code has two siginficant benefits.  It makes
>> the determination of passing the point of no return by testing bprm->mm
>> accurate.  All failures prior to that point in flush_old_exec are
>> either truly recoverable or they are fatal.
>
> Agreed. Though I see a use of "current", which maybe you want to
> parameterize to a "me" argument in acct_arg_size(). (Though looking at
> the callers, perhaps there is no benefit?)

My testing suggests there is a small benefit on x86.

The code is just "#define current get_current()"
and get_current() revoles into a read of "%gs:current_task".

But looking at the code I find gcc can sometimes when the
reads are close in the source code can optimize the read
away.  But gcc does not manage to optimize the extra
read of "%gs:current_task" away.

So I think things are much much better than they used to be,
code generation wise.  But it still helps to cache current
in a local variable.

>> Futher this consolidates all of the possible indefinite waits for
>> userspace together at the top of flush_old_exec.  The possible wait
>> for a ptracer on PTRACE_EVENT_EXIT, the possible wait for a page fault
>> to be resolved in clear_child_tid, and the possible wait for a page
>> fault in exit_robust_list.
>> 
>> This consolidation allows the creation of a mutex to replace
>> cred_guard_mutex that is not held of possible indefinite userspace
>> waits.  Which will allow removing deadlock scenarios from the kernel.
>> 
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  fs/exec.c | 24 ++++++++++++------------
>>  1 file changed, 12 insertions(+), 12 deletions(-)
>> 
>> diff --git a/fs/exec.c b/fs/exec.c
>> index 215d86f77b63..d820a7272a76 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1272,18 +1272,6 @@ int flush_old_exec(struct linux_binprm * bprm)
>>  	if (retval)
>>  		goto out;
>>  
>> -#ifdef CONFIG_POSIX_TIMERS
>> -	exit_itimers(me->signal);
>> -	flush_itimer_signals();
>> -#endif
>
> I think this comment:
>
> /*
>  * This is called by do_exit or de_thread, only when there are no more
>  * references to the shared signal_struct.
>  */
> void exit_itimers(struct signal_struct *sig)
>
> Refers to there being other threads, yes? Not that the signal table is
> private yet?

The signal table is in sighand_struct.

So yes that refers to the other threads being gone.


>> -
>> -	/*
>> -	 * Make the signal table private.
>> -	 */
>> -	retval = unshare_sighand(me);
>> -	if (retval)
>> -		goto out;
>> -
>>  	/*
>>  	 * Must be called _before_ exec_mmap() as bprm->mm is
>>  	 * not visibile until then. This also enables the update
>> @@ -1307,6 +1295,18 @@ int flush_old_exec(struct linux_binprm * bprm)
>>  	 */
>>  	bprm->mm = NULL;
>>  
>> +#ifdef CONFIG_POSIX_TIMERS
>> +	exit_itimers(me->signal);
>> +	flush_itimer_signals();
>> +#endif
>
> I've mostly convinced myself that there are no "side-effects" from having
> these timers expire as the mm is going away. I think some kind of comment
> of that intent should be explicitly stated here above the timer work.

The timers can at most generate signals.  And we are not handling
signals in the middle of exec.

So the only possible interaction would be to set a timeout and then try
exec, and have the timer kill the caller.

Maybe we get a killable signal from a scenario like that and maybe this
changes the time before the timer expires into the dangerous zone.
But that is all I can think of.

We have to return to the edge of userspace before any signals are
delivered.


> Beyond that:
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
>
> -Kees
>
>> +
>> +	/*
>> +	 * Make the signal table private.
>> +	 */
>> +	retval = unshare_sighand(me);
>> +	if (retval)
>> +		goto out;
>> +
>>  	set_fs(USER_DS);
>>  	me->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
>>  					PF_NOFREEZE | PF_NO_SETAFFINITY);
>> -- 
>> 2.25.0
>> 

Eric

