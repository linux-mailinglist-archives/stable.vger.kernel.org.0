Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94619180A83
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 22:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgCJVdN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 17:33:13 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:49800 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgCJVdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 17:33:13 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBmUw-0002iF-Vy; Tue, 10 Mar 2020 15:33:11 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBmUw-0004iW-59; Tue, 10 Mar 2020 15:33:10 -0600
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
        <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
        <CAG48ez13XXWNRLrPFRHRsvPKSwSK1-6k+1F7QujWOJtVuk0QHg@mail.gmail.com>
Date:   Tue, 10 Mar 2020 16:30:51 -0500
In-Reply-To: <CAG48ez13XXWNRLrPFRHRsvPKSwSK1-6k+1F7QujWOJtVuk0QHg@mail.gmail.com>
        (Jann Horn's message of "Tue, 10 Mar 2020 22:21:28 +0100")
Message-ID: <87wo7roq2c.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBmUw-0004iW-59;;;mid=<87wo7roq2c.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/8FoRYPhgRSLS/IXD3oa0BUqZPsIotcuI=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jann Horn <jannh@google.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 310 ms - load_scoreonly_sql: 0.02 (0.0%),
        signal_user_changed: 2.6 (0.8%), b_tie_ro: 1.82 (0.6%), parse: 0.80
        (0.3%), extract_message_metadata: 9 (2.9%), get_uri_detail_list: 1.05
        (0.3%), tests_pri_-1000: 14 (4.4%), tests_pri_-950: 1.00 (0.3%),
        tests_pri_-900: 0.87 (0.3%), tests_pri_-90: 29 (9.5%), check_bayes: 28
        (9.1%), b_tokenize: 9 (2.9%), b_tok_get_all: 9 (2.8%), b_comp_prob:
        1.98 (0.6%), b_tok_touch_all: 3.5 (1.1%), b_finish: 0.56 (0.2%),
        tests_pri_0: 244 (78.6%), check_dkim_signature: 0.42 (0.1%),
        check_dkim_adsp: 2.1 (0.7%), poll_dns_idle: 0.80 (0.3%), tests_pri_10:
        1.70 (0.5%), tests_pri_500: 5 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace cred_guard_mutex
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jann Horn <jannh@google.com> writes:

> On Sun, Mar 8, 2020 at 10:41 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
>> over the userspace accesses as the arguments from userspace are read.
>> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
>> threads are killed.  The cred_guard_mutex is held over
>> "put_user(0, tsk->clear_child_tid)" in exit_mm().
>>
>> Any of those can result in deadlock, as the cred_guard_mutex is held
>> over a possible indefinite userspace waits for userspace.
>>
>> Add exec_update_mutex that is only held over exec updating process
>> with the new contents of exec, so that code that needs not to be
>> confused by exec changing the mm and the cred in ways that can not
>> happen during ordinary execution of a process.
>>
>> The plan is to switch the users of cred_guard_mutex to
>> exec_udpate_mutex one by one.  This lets us move forward while still
>> being careful and not introducing any regressions.
> [...]
>> @@ -1034,6 +1035,11 @@ static int exec_mmap(struct mm_struct *mm)
>>                         return -EINTR;
>>                 }
>>         }
>> +
>> +       ret = mutex_lock_killable(&tsk->signal->exec_update_mutex);
>> +       if (ret)
>> +               return ret;
>
> We're already holding the old mmap_sem, and now nest the
> exec_update_mutex inside it; but then while still holding the
> exec_update_mutex, we do mmput(), which can e.g. end up in ksm_exit(),
> which can do down_write(&mm->mmap_sem) from __ksm_exit(). So I think
> at least lockdep will be unhappy, and I'm not sure whether it's an
> actual problem or not.

Good point.  I should double check the lock ordering here with mmap_sem.
It doesn't look like mmput takes mmap_sem, but still there might be a
lock inversion of some kind here.  At least as far as lockdep is
concerned and we don't want anything like that.

Eric







