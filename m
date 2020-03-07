Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF7217CA21
	for <lists+stable@lfdr.de>; Sat,  7 Mar 2020 02:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgCGBFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 20:05:30 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:55008 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgCGBFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 20:05:30 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jANuA-0007Im-T1; Fri, 06 Mar 2020 18:05:26 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jANu8-0006Ld-L3; Fri, 06 Mar 2020 18:05:26 -0700
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
        <AM6PR03MB5170E9D0DB405EC051F7731CE4E30@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87sgil87s3.fsf@x220.int.ebiederm.org>
        <87a74t86cs.fsf@x220.int.ebiederm.org>
Date:   Fri, 06 Mar 2020 19:03:10 -0600
In-Reply-To: <87a74t86cs.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
        message of "Fri, 06 Mar 2020 16:29:39 -0600")
Message-ID: <87v9nh6koh.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jANu8-0006Ld-L3;;;mid=<87v9nh6koh.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19ga0TG/cHLdEFkXj9eUOD1GvS7qbzyimM=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMNoVowels,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4833]
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1761 ms - load_scoreonly_sql: 0.05 (0.0%),
        signal_user_changed: 2.8 (0.2%), b_tie_ro: 1.96 (0.1%), parse: 1.12
        (0.1%), extract_message_metadata: 15 (0.9%), get_uri_detail_list: 2.1
        (0.1%), tests_pri_-1000: 24 (1.3%), tests_pri_-950: 1.30 (0.1%),
        tests_pri_-900: 1.14 (0.1%), tests_pri_-90: 33 (1.9%), check_bayes: 31
        (1.8%), b_tokenize: 13 (0.7%), b_tok_get_all: 9 (0.5%), b_comp_prob:
        3.3 (0.2%), b_tok_touch_all: 3.8 (0.2%), b_finish: 0.79 (0.0%),
        tests_pri_0: 585 (33.2%), check_dkim_signature: 0.67 (0.0%),
        check_dkim_adsp: 2.5 (0.1%), poll_dns_idle: 1080 (61.3%),
        tests_pri_10: 1.99 (0.1%), tests_pri_500: 1092 (62.0%), rewrite_mail:
        0.00 (0.0%)
Subject: Re: [PATCH 2/2] exec: Add a exec_update_mutex to replace cred_guard_mutex
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> ebiederm@xmission.com (Eric W. Biederman) writes:
>
>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>>
>>> On 3/6/20 6:17 AM, Eric W. Biederman wrote:
>>>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>>>> 
>>>>> On 3/5/20 10:16 PM, Eric W. Biederman wrote:
>>>>>>
>>>>>> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
>>>>>> over the userspace accesses as the arguments from userspace are read.
>>>>>> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
>>>>>> threads are killed.  The cred_guard_mutex is held over
>>>>>> "put_user(0, tsk->clear_child_tid)" in exit_mm().
>>>>>>
>>>
>>> I am all for this patch, and the direction it is heading, Eric.
>>>
>>> I just wanted to add a note that I think it is
>>> possible that exec_mm_release can also invoke put_user(0, tsk->clear_child_tid),
>>> under the new exec_update_mutex, since vm_access increments the
>>> mm->mm_users, under the cred_update_mutex, but releases the mutex,
>>> and the caller can hold the reference for a while and then exec_mmap is not
>>> releasing the last reference.
>>
>> Good catch.  I really appreciate your close look at the details.
>>
>> I am wondering if process_vm_readv and process_vm_writev could be
>> safely changed to use mmgrab and mmdrop, instead of mmget and mmput.
>>
>> That would resolve the potential issue you have pointed out.  I just
>> haven't figured out if it is safe.  The mm code has been seriously
>> refactored since I knew how it all worked.
>
> Nope, mmget can not be replaced by mmgrab.
>
> It might be possible to do something creative like store a cred in place
> of the userns on the mm and use that for mm_access permission checks.
> Still we are talking a pretty narrow window, and a case that no one has
> figured out how to trigger yet.  So I will leave that corner case as
> something for future improvements.

My brain is restless and keep looking at it.

The worst case is processes created with CLONE_VM|CLONE_CHILD_CLEARTID
but not CLONE_THREAD.  For those that put_user will occur ever time
in exec_mmap.

The only solution that I can see is to move taking the new mutex after
exec_mm_release.  Which may be feasible given how close exec_mmap
follows de_thread.

I am going to sleep on that and perhaps I will be able to see how to
move taking the mutex lower.

It would be very nice not to have a known issue going into this set of
changes.

Eric

