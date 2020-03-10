Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28E4C1809EC
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 22:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgCJVHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 17:07:49 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60672 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgCJVHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 17:07:49 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBm6N-0005ve-Sr; Tue, 10 Mar 2020 15:07:47 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBm6M-0000IU-Og; Tue, 10 Mar 2020 15:07:47 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jann Horn <jannh@google.com>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
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
        <87eeu25y14.fsf_-_@x220.int.ebiederm.org>
        <CAG48ez2aYfcwC7Sr6RseFk=PpvLAddcHsVsrTr_AS=jLvUu2KA@mail.gmail.com>
Date:   Tue, 10 Mar 2020 16:05:27 -0500
In-Reply-To: <CAG48ez2aYfcwC7Sr6RseFk=PpvLAddcHsVsrTr_AS=jLvUu2KA@mail.gmail.com>
        (Jann Horn's message of "Tue, 10 Mar 2020 21:57:50 +0100")
Message-ID: <8736afsyy0.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBm6M-0000IU-Og;;;mid=<8736afsyy0.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+joPIlLZ6q1EENkKnYWgLXYsgDIP3sn3g=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jann Horn <jannh@google.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 722 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 2.8 (0.4%), b_tie_ro: 1.93 (0.3%), parse: 1.11
        (0.2%), extract_message_metadata: 11 (1.5%), get_uri_detail_list: 1.12
        (0.2%), tests_pri_-1000: 17 (2.4%), tests_pri_-950: 1.31 (0.2%),
        tests_pri_-900: 1.08 (0.1%), tests_pri_-90: 29 (4.0%), check_bayes: 28
        (3.8%), b_tokenize: 11 (1.6%), b_tok_get_all: 8 (1.1%), b_comp_prob:
        2.3 (0.3%), b_tok_touch_all: 4.0 (0.6%), b_finish: 0.66 (0.1%),
        tests_pri_0: 645 (89.4%), check_dkim_signature: 0.53 (0.1%),
        check_dkim_adsp: 2.3 (0.3%), poll_dns_idle: 0.71 (0.1%), tests_pri_10:
        2.3 (0.3%), tests_pri_500: 8 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2 3/5] exec: Move cleanup of posix timers on exec out of de_thread
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jann Horn <jannh@google.com> writes:

> On Sun, Mar 8, 2020 at 10:39 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> These functions have very little to do with de_thread move them out
>> of de_thread an into flush_old_exec proper so it can be more clearly
>> seen what flush_old_exec is doing.
>>
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  fs/exec.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/exec.c b/fs/exec.c
>> index ff74b9a74d34..215d86f77b63 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1189,11 +1189,6 @@ static int de_thread(struct task_struct *tsk)
>>         /* we have changed execution domain */
>>         tsk->exit_signal = SIGCHLD;
>>
>> -#ifdef CONFIG_POSIX_TIMERS
>> -       exit_itimers(sig);
>> -       flush_itimer_signals();
>> -#endif
>> -
>>         BUG_ON(!thread_group_leader(tsk));
>>         return 0;
>>
>> @@ -1277,6 +1272,11 @@ int flush_old_exec(struct linux_binprm * bprm)
>>         if (retval)
>>                 goto out;
>>
>> +#ifdef CONFIG_POSIX_TIMERS
>> +       exit_itimers(me->signal);
>> +       flush_itimer_signals();
>> +#endif
>
> nit: exit_itimers() has a comment referring to de_thread, that should
> probably be updated

Good point.

Eric

