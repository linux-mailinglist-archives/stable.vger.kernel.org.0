Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 567A117666E
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 22:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgCBVv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 16:51:26 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:46332 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbgCBVvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Mar 2020 16:51:25 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j8sy9-0001uo-3P; Mon, 02 Mar 2020 14:51:21 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j8sy8-0000vB-BX; Mon, 02 Mar 2020 14:51:20 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
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
        Kees Cook <keescook@chromium.org>,
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
        "stable\@vger.kernel.org" <stable@vger.kernel.org>
References: <AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <CAG48ez3QHVpMJ9Rb_Q4LEE6uAqQJeS1Myu82U=fgvUfoeiscgw@mail.gmail.com>
        <20200301185244.zkofjus6xtgkx4s3@wittgenstein>
        <CAG48ez3mnYc84iFCA25-rbJdSBi3jh9hkp569XZTbFc_9WYbZw@mail.gmail.com>
        <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87a74zmfc9.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <87k142lpfz.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <875zfmloir.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Mon, 02 Mar 2020 15:49:09 -0600
In-Reply-To: <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Mon, 2 Mar 2020 17:13:31 +0000")
Message-ID: <87v9nmjulm.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j8sy8-0000vB-BX;;;mid=<87v9nmjulm.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19moPzbn5KKuED00hBojlLEmyr3UzUKtvY=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa03.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
        version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4322]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 358 ms - load_scoreonly_sql: 0.02 (0.0%),
        signal_user_changed: 2.5 (0.7%), b_tie_ro: 1.76 (0.5%), parse: 0.75
        (0.2%), extract_message_metadata: 9 (2.4%), get_uri_detail_list: 1.13
        (0.3%), tests_pri_-1000: 6 (1.8%), tests_pri_-950: 0.98 (0.3%),
        tests_pri_-900: 0.85 (0.2%), tests_pri_-90: 28 (7.9%), check_bayes: 27
        (7.5%), b_tokenize: 9 (2.4%), b_tok_get_all: 10 (2.9%), b_comp_prob:
        1.75 (0.5%), b_tok_touch_all: 3.7 (1.0%), b_finish: 0.57 (0.2%),
        tests_pri_0: 247 (69.1%), check_dkim_signature: 0.40 (0.1%),
        check_dkim_adsp: 2.2 (0.6%), poll_dns_idle: 47 (13.0%), tests_pri_10:
        1.62 (0.5%), tests_pri_500: 58 (16.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv2] exec: Fix a deadlock in ptrace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> On 3/2/20 5:17 PM, Eric W. Biederman wrote:
>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>> 
>>> On 3/2/20 4:57 PM, Eric W. Biederman wrote:
>>>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>>>>
>>>>>
>>>>> I tried this with s/EACCESS/EACCES/.
>>>>>
>>>>> The test case in this patch is not fixed, but strace does not freeze,
>>>>> at least with my setup where it did freeze repeatable.
>>>>
>>>> Thanks, That is what I was aiming at.
>>>>
>>>> So we have one method we can pursue to fix this in practice.
>>>>
>>>>> That is
>>>>> obviously because it bypasses the cred_guard_mutex.  But all other
>>>>> process that access this file still freeze, and cannot be
>>>>> interrupted except with kill -9.
>>>>>
>>>>> However that smells like a denial of service, that this
>>>>> simple test case which can be executed by guest, creates a /proc/$pid/mem
>>>>> that freezes any process, even root, when it looks at it.
>>>>> I mean: "ln -s README /proc/$pid/mem" would be a nice bomb.
>>>>
>>>> Yes.  Your the test case in your patch a variant of the original
>>>> problem.
>>>>
>>>>
>>>> I have been staring at this trying to understand the fundamentals of the
>>>> original deeper problem.
>>>>
>>>> The current scope of cred_guard_mutex in exec is because being ptraced
>>>> causes suid exec to act differently.  So we need to know early if we are
>>>> ptraced.
>>>>
>>>
>>> It has a second use, that it prevents two threads entering execve,
>>> which would probably result in disaster.
>> 
>> Exec can fail with an error code up until de_thread.  de_thread causes
>> exec to fail with the error code -EAGAIN for the second thread to get
>> into de_thread.
>> 
>> So no.  The cred_guard_mutex is not needed for that case at all.
>> 
>
> Okay, but that will reset current->in_execve, right?

Absolutely.

The error handling kicks in and exec_binprm fails with a negative
return code.  Then __do_excve_file cleans up and clears
current->in_execve.

Eric
