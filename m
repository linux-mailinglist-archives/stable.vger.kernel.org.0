Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84FA81809C7
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 22:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgCJVAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 17:00:02 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49438 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgCJVAB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 17:00:01 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBlym-00067f-DA; Tue, 10 Mar 2020 14:59:56 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBlyk-0006E3-MQ; Tue, 10 Mar 2020 14:59:55 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jann Horn <jannh@google.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
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
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Sargun Dhillon <sargun@sargun.me>
References: <87r1y8dqqz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
        <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
        <87eeu25y14.fsf_-_@x220.int.ebiederm.org>
        <20200309195909.h2lv5uawce5wgryx@wittgenstein>
        <877dztz415.fsf@x220.int.ebiederm.org>
        <20200309201729.yk5sd26v4bz4gtou@wittgenstein>
        <87k13txnig.fsf@x220.int.ebiederm.org>
        <20200310085540.pztaty2mj62xt2nm@wittgenstein>
        <87wo7svy96.fsf_-_@x220.int.ebiederm.org>
        <CAG48ez2cUZMVOAXfHPNjKjYsMSaWkjUjOCHo0KYZ+oXQUW4viA@mail.gmail.com>
        <87k13sui1p.fsf@x220.int.ebiederm.org>
        <CAG48ez2vRgaEVJ=Rs8gn6HkGO6syL8MpSOUq7BNN+OUE1uYxCA@mail.gmail.com>
        <CAG48ez1LjW1xAGe-5tNtstCWxG2bkiHaQUMOcJNjx=z-2Wc2Jw@mail.gmail.com>
Date:   Tue, 10 Mar 2020 15:57:35 -0500
In-Reply-To: <CAG48ez1LjW1xAGe-5tNtstCWxG2bkiHaQUMOcJNjx=z-2Wc2Jw@mail.gmail.com>
        (Jann Horn's message of "Tue, 10 Mar 2020 21:10:59 +0100")
Message-ID: <87lfo8rkqo.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBlyk-0006E3-MQ;;;mid=<87lfo8rkqo.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+legm72Gnu4YbUlNo0F2EELZNKSd0AFy8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
        version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4976]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jann Horn <jannh@google.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 420 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 3.4 (0.8%), b_tie_ro: 2.5 (0.6%), parse: 0.80
        (0.2%), extract_message_metadata: 10 (2.5%), get_uri_detail_list: 1.99
        (0.5%), tests_pri_-1000: 15 (3.6%), tests_pri_-950: 1.02 (0.2%),
        tests_pri_-900: 0.88 (0.2%), tests_pri_-90: 35 (8.4%), check_bayes: 34
        (8.1%), b_tokenize: 11 (2.7%), b_tok_get_all: 14 (3.2%), b_comp_prob:
        2.7 (0.6%), b_tok_touch_all: 3.9 (0.9%), b_finish: 0.67 (0.2%),
        tests_pri_0: 344 (81.9%), check_dkim_signature: 0.44 (0.1%),
        check_dkim_adsp: 2.6 (0.6%), poll_dns_idle: 1.27 (0.3%), tests_pri_10:
        1.70 (0.4%), tests_pri_500: 5 (1.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH] pidfd: Stop taking cred_guard_mutex
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Jann Horn <jannh@google.com> writes:

> On Tue, Mar 10, 2020 at 9:00 PM Jann Horn <jannh@google.com> wrote:
>> On Tue, Mar 10, 2020 at 8:29 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> > Jann Horn <jannh@google.com> writes:
>> > > On Tue, Mar 10, 2020 at 7:54 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> > >> During exec some file descriptors are closed and the files struct is
>> > >> unshared.  But all of that can happen at other times and it has the
>> > >> same protections during exec as at ordinary times.  So stop taking the
>> > >> cred_guard_mutex as it is useless.
>> > >>
>> > >> Furthermore he cred_guard_mutex is a bad idea because it is deadlock
>> > >> prone, as it is held in serveral while waiting possibly indefinitely
>> > >> for userspace to do something.
> [...]
>> > > If you make this change, then if this races with execution of a setuid
>> > > program that afterwards e.g. opens a unix domain socket, an attacker
>> > > will be able to steal that socket and inject messages into
>> > > communication with things like DBus. procfs currently has the same
>> > > race, and that still needs to be fixed, but at least procfs doesn't
>> > > let you open things like sockets because they don't have a working
>> > > ->open handler, and it enforces the normal permission check for
>> > > opening files.
>> >
>> > It isn't only exec that can change credentials.  Do we need a lock for
>> > changing credentials?
> [...]
>> > If we need a lock around credential change let's design and build that.
>> > Having a mismatch between what a lock is designed to do, and what
>> > people use it for can only result in other bugs as people get confused.
>>
>> Hmm... what benefits do we get from making it a separate lock? I guess
>> it would allow us to make it a per-task lock instead of a
>> signal_struct-wide one? That might be helpful...
>
> But actually, isn't the core purpose of the cred_guard_mutex to guard
> against concurrent credential changes anyway? That's what almost
> everyone uses it for, and it's in the name...

Having been through all of the users nope.

Maybe someone tried to repurpose for that.  I haven't traced through
when it went the it was renamed from cred_exec_mutex to
cred_guard_mutex.

The original purpose was to make make exec and ptrace deadlock.  But it
was seen as being there to allow safely calculating the new credentials
before the point of now return.  Because if a process is ptraced or not
affects the new credential calculations.  Unfortunately offering that
guarantee fundamentally leads to deadlock.

So ptrace_attach and seccomp use the cred_guard_mutex to guarantee
a deadlock.

The common use is to take cred_guard_mutex to guard the window when
credentials and process details are out of sync in exec.  But there
is at least do_io_accounting that seems to have the same justification
for holding __pidfd_fget.

With effort I suspect we can replace exec_change_mutex with task_lock.
When we are guaranteed to be single threaded placing exec_change_mutex
in signal_struct doesn't really help us (except maybe in some races?).

The deep problem is no one really understands cred_guard_mutex so it is
a mess.  Code with poorly defined semantics is always wrong somewhere
for someone.  Which is part of why I am attacking this and having the
conversations to make certain I understand what is going on.

I see your point about commit_creds making a process undumpable.  So in
practice it really is only exec that changes creds in a way that
ptrace_may_access will allow the process to be inspected.

So I guess for now the practical non-regressing course is to change
everything to my exec_change_mutex, removing the deadlock.  Then we
figure out how to cleanly deal with the races inspecting a process with
changing credentials has.

Eric
