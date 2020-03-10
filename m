Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D416180A64
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 22:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbgCJV1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 17:27:30 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40600 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgCJV1a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 17:27:30 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBmPQ-0008Ng-W8; Tue, 10 Mar 2020 15:27:29 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBmPQ-0003ht-8O; Tue, 10 Mar 2020 15:27:28 -0600
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
        <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
        <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
        <AM6PR03MB5170BC58D90BAD80CDEF3F8BE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <878sk94eay.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y12yc7.fsf@x220.int.ebiederm.org>
        <87k13t2xpd.fsf@x220.int.ebiederm.org>
        <87d09l2x5n.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <871rq12vxu.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <877dzt1fnf.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51701C6F60699F99C5C67E0BE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <875zfcxlwy.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170BD2476E35068E182EFA4E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <874kuwvxkz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170A29F8D885147F1A3981EE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Tue, 10 Mar 2020 16:25:09 -0500
In-Reply-To: <AM6PR03MB5170A29F8D885147F1A3981EE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Tue, 10 Mar 2020 21:19:05 +0100")
Message-ID: <878sk7q4wa.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBmPQ-0003ht-8O;;;mid=<878sk7q4wa.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+R1YozAbyKQHiEXFA7wXLQCvRAwXr7aX0=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMNoVowels,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4948]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 341 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 3.3 (1.0%), b_tie_ro: 2.2 (0.7%), parse: 1.27
        (0.4%), extract_message_metadata: 13 (3.8%), get_uri_detail_list: 1.84
        (0.5%), tests_pri_-1000: 17 (5.1%), tests_pri_-950: 1.27 (0.4%),
        tests_pri_-900: 1.04 (0.3%), tests_pri_-90: 30 (8.9%), check_bayes: 29
        (8.5%), b_tokenize: 11 (3.3%), b_tok_get_all: 8 (2.4%), b_comp_prob:
        2.9 (0.9%), b_tok_touch_all: 4.1 (1.2%), b_finish: 0.66 (0.2%),
        tests_pri_0: 262 (76.8%), check_dkim_signature: 0.59 (0.2%),
        check_dkim_adsp: 2.5 (0.7%), poll_dns_idle: 0.87 (0.3%), tests_pri_10:
        2.1 (0.6%), tests_pri_500: 6 (1.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 3/4] proc: io_accounting: Use new infrastructure to fix deadlocks in execve
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> On 3/10/20 8:06 PM, Eric W. Biederman wrote:
>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>> 
>>> This changes do_io_accounting to use the new exec_update_mutex
>>> instead of cred_guard_mutex.
>>>
>>> This fixes possible deadlocks when the trace is accessing
>>> /proc/$pid/io for instance.
>>>
>>> This should be safe, as the credentials are only used for reading.
>> 
>> This is an improvement.
>> 
>> We probably want to do this just as an incremental step in making things
>> better but perhaps I am blind but I am not finding the reason for
>> guarding this with the cred_guard_mutex to be at all persuasive.
>> 
>> I think moving the ptrace_may_access check down to after the
>> unlock_task_sighand would be just as effective at addressing the
>> concerns raised in the original commit.  I think the task_lock provides
>> all of the barrier we need to make it safe to move the ptrace_may_access
>> checks safe.
>> 
>> The reason I say this is I don't see exec changing ->ioac.  Just
>> performing some I/O which would update the io accounting statistics.
>> 
>
> Maybe the suid executable is starting up and doing io or not,
> and what the program does immediately at startup is a secret,
> that we want to keep secret but evil eve want to find out.
> eve is using /proc/alice/io to do that.
>
> It is a bit constructed, but seems like a security concern.
> when we keep the exec_update_mutex while collecting the data, we
> cannot see any io of the new process when the new credentials
> don't allow that.

Jann Horn has convinced me we should just convert these to the
exec_change_mutex today.  Because while not 100% correct in theory, the
only really interesting case is exec.  So the code does something
interesting and worth while, and mostly correct.  The last thing I want
to do is to cause an unnecessary regression.

Eric
