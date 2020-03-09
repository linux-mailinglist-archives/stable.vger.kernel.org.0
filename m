Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6477617E70F
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 19:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbgCIS0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 14:26:53 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:36482 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgCIS0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 14:26:53 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBN72-0001Yq-SW; Mon, 09 Mar 2020 12:26:48 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jBN71-00066p-Tz; Mon, 09 Mar 2020 12:26:48 -0600
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
        <AM6PR03MB5170BC58D90BAD80CDEF3F8BE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <878sk94eay.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517086003BD2C32E199690A3E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87r1y12yc7.fsf@x220.int.ebiederm.org>
Date:   Mon, 09 Mar 2020 13:24:30 -0500
In-Reply-To: <87r1y12yc7.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
        message of "Mon, 09 Mar 2020 13:10:48 -0500")
Message-ID: <87k13t2xpd.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jBN71-00066p-Tz;;;mid=<87k13t2xpd.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/WnV4wYiwwbgU9GE0A9FUPBqxzJcDuRb4=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa04.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4897]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 441 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 3.1 (0.7%), b_tie_ro: 2.1 (0.5%), parse: 1.10
        (0.2%), extract_message_metadata: 15 (3.4%), get_uri_detail_list: 1.92
        (0.4%), tests_pri_-1000: 18 (4.0%), tests_pri_-950: 1.16 (0.3%),
        tests_pri_-900: 1.02 (0.2%), tests_pri_-90: 30 (6.8%), check_bayes: 29
        (6.5%), b_tokenize: 12 (2.7%), b_tok_get_all: 9 (1.9%), b_comp_prob:
        2.7 (0.6%), b_tok_touch_all: 3.5 (0.8%), b_finish: 0.63 (0.1%),
        tests_pri_0: 355 (80.3%), check_dkim_signature: 0.56 (0.1%),
        check_dkim_adsp: 2.3 (0.5%), poll_dns_idle: 0.32 (0.1%), tests_pri_10:
        3.9 (0.9%), tests_pri_500: 11 (2.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace cred_guard_mutex
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>
>> On 3/9/20 6:40 PM, Eric W. Biederman wrote:
>>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>>> 
>>>> On 3/8/20 10:38 PM, Eric W. Biederman wrote:
>>>>>
>>>>> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
>>>>> over the userspace accesses as the arguments from userspace are read.
>>>>> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
>>>                                 ^ over
>>>>
>>>> ... is held while waiting for the trace parent to handle PTRACE_EVENT_EXIT
>>>> or something?
>>> 
>>> Yes.  Let me see if I can phrase that better.
>>> 
>>>> I wonder if we also should mention that
>>>> it is held while waiting for the trace parent to
>>>> receive the exit code with "wait"?
>>> 
>>> I don't think we have to spell out the details of how it all works,
>>> unless that makes things clearer.  Kernel developers can be expected
>>> to figure out how the kernel works.  The critical thing is that it is
>>> an indefinite wait for userspace to take action.
>>> 
>>> But I will look.
>>> 
>>>>> threads are killed.  The cred_guard_mutex is held over
>>>>> "put_user(0, tsk->clear_child_tid)" in exit_mm().
>>>>>
>>>>> Any of those can result in deadlock, as the cred_guard_mutex is held
>>>>> over a possible indefinite userspace waits for userspace.
>>>>>
>>>>> Add exec_update_mutex that is only held over exec updating process
>>>>
>>>> Add ?
>>> 
>>> Yes.  That is what the change does: add exec_update_mutex.
>>> 
>>
>> I just kind of missed the "subject" in this sentence,
>> like "This patch adds an exec_update_mutex that is ..."
>> but english is a foreign language for me, so may be okay as is.
>
> English has a lot of options.  I think this is a stylistic difference.
>
> Instead of being an observer and describing what the change does:
> "This patch adds exec_update_mutex ..."  
>
> I was being there in the moment and saying/commading what is happening:
> "Add exec_update_mutex ..."
>
> Using the more immdediate form ends up with more concise and clearer
> sentences.
>
> Every one of my writing teachers in school emphasized that point
> and I see the who it works when I write things.  But writing is hard and
> I still tend toward long rambling sentences with many qualifiers that
> confuse and detract from the point rather than make it clear what is
> happening.

And reading through it all now I can see your confusion.  That
description of my changes was not well done.  Reworking it now.

Eric
