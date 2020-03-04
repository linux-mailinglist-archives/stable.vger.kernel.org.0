Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFFA17957A
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 17:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387497AbgCDQfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 11:35:55 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:42746 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgCDQfz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 11:35:55 -0500
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j9Wzo-000429-0p; Wed, 04 Mar 2020 09:35:44 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j9Wzh-0000J3-B9; Wed, 04 Mar 2020 09:35:43 -0700
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
        <87a74zmfc9.fsf@x220.int.ebiederm.org>
        <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
Date:   Wed, 04 Mar 2020 10:33:24 -0600
In-Reply-To: <AM6PR03MB51705AA3009B4986BB6EF92FE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Wed, 4 Mar 2020 14:37:46 +0000")
Message-ID: <87r1y8dqqz.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j9Wzh-0000J3-B9;;;mid=<87r1y8dqqz.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+PbZqkG+MqZcU53qiOMlhhlYuGrYdl+NM=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa01.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,NO_DNS_FOR_FROM,T_TM2_M_HEADER_IN_MSG
        autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4995]
        *  0.0 NO_DNS_FOR_FROM DNS: Envelope sender has no MX or A DNS records
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 6151 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 2.4 (0.0%), b_tie_ro: 1.66 (0.0%), parse: 1.54
        (0.0%), extract_message_metadata: 14 (0.2%), get_uri_detail_list: 3.6
        (0.1%), tests_pri_-1000: 5 (0.1%), tests_pri_-950: 1.03 (0.0%),
        tests_pri_-900: 0.85 (0.0%), tests_pri_-90: 36 (0.6%), check_bayes: 34
        (0.6%), b_tokenize: 12 (0.2%), b_tok_get_all: 12 (0.2%), b_comp_prob:
        3.0 (0.0%), b_tok_touch_all: 5.0 (0.1%), b_finish: 0.69 (0.0%),
        tests_pri_0: 6077 (98.8%), check_dkim_signature: 0.44 (0.0%),
        check_dkim_adsp: 5385 (87.5%), poll_dns_idle: 5380 (87.5%),
        tests_pri_10: 2.4 (0.0%), tests_pri_500: 8 (0.1%), rewrite_mail: 0.00
        (0.0%)
Subject: Re: [PATCHv5] exec: Fix a deadlock in ptrace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> On 3/3/20 9:08 PM, Eric W. Biederman wrote:
>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>> 
>>> On 3/3/20 4:18 PM, Eric W. Biederman wrote:
>>>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>>>>> diff --git a/tools/testing/selftests/ptrace/vmaccess.c b/tools/testing/selftests/ptrace/vmaccess.c
>>>>> new file mode 100644
>>>>> index 0000000..6d8a048
>>>>> --- /dev/null
>>>>> +++ b/tools/testing/selftests/ptrace/vmaccess.c
>>>>> @@ -0,0 +1,66 @@
>>>>> +// SPDX-License-Identifier: GPL-2.0+
>>>>> +/*
>>>>> + * Copyright (c) 2020 Bernd Edlinger <bernd.edlinger@hotmail.de>
>>>>> + * All rights reserved.
>>>>> + *
>>>>> + * Check whether /proc/$pid/mem can be accessed without causing deadlocks
>>>>> + * when de_thread is blocked with ->cred_guard_mutex held.
>>>>> + */
>>>>> +
>>>>> +#include "../kselftest_harness.h"
>>>>> +#include <stdio.h>
>>>>> +#include <fcntl.h>
>>>>> +#include <pthread.h>
>>>>> +#include <signal.h>
>>>>> +#include <unistd.h>
>>>>> +#include <sys/ptrace.h>
>>>>> +
>>>>> +static void *thread(void *arg)
>>>>> +{
>>>>> +	ptrace(PTRACE_TRACEME, 0, 0L, 0L);
>>>>> +	return NULL;
>>>>> +}
>>>>> +
>>>>> +TEST(vmaccess)
>>>>> +{
>>>>> +	int f, pid = fork();
>>>>> +	char mm[64];
>>>>> +
>>>>> +	if (!pid) {
>>>>> +		pthread_t pt;
>>>>> +
>>>>> +		pthread_create(&pt, NULL, thread, NULL);
>>>>> +		pthread_join(pt, NULL);
>>>>> +		execlp("true", "true", NULL);
>>>>> +	}
>>>>> +
>>>>> +	sleep(1);
>>>>> +	sprintf(mm, "/proc/%d/mem", pid);
>>>>> +	f = open(mm, O_RDONLY);
>>>>> +	ASSERT_LE(0, f);
>>>>> +	close(f);
>>>>> +	f = kill(pid, SIGCONT);
>>>>> +	ASSERT_EQ(0, f);
>>>>> +}
>>>>> +
>>>>> +TEST(attach)
>>>>> +{
>>>>> +	int f, pid = fork();
>>>>> +
>>>>> +	if (!pid) {
>>>>> +		pthread_t pt;
>>>>> +
>>>>> +		pthread_create(&pt, NULL, thread, NULL);
>>>>> +		pthread_join(pt, NULL);
>>>>> +		execlp("true", "true", NULL);
>>>>> +	}
>>>>> +
>>>>> +	sleep(1);
>>>>> +	f = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
>>>>
>>>> To be meaningful this code needs to learn to loop when
>>>> ptrace returns -EAGAIN.
>>>>
>>>> Because that is pretty much what any self respecting user space
>>>> process will do.
>>>>
>>>> At which point I am not certain we can say that the behavior has
>>>> sufficiently improved not to be a deadlock.
>>>>
>>>
>>> In this special dead-duck test it won't work, but it would
>>> still be lots more transparent what is going on, since previously
>>> you had two zombie process, and no way to even output debug
>>> messages, which also all self respecting user space processes
>>> should do.
>> 
>> Agreed it is more transparent.  So if you are going to deadlock
>> it is better.
>> 
>> My previous proposal (which I admit is more work to implement) would
>> actually allow succeeding in this case and so it would not be subject to
>> a dead lock (even via -EGAIN) at this point.
>> 
>>> So yes, I can at least give a good example and re-try it several
>>> times together with wait4 which a tracer is expected to do.
>> 
>> Thank you,
>> 
>> Eric
>> 
>
> Okay, I think it can be done with minimal API changes,
> but it needs two mutexes, one that guards the execve,
> and one that guards only the credentials.
>
> If no traced sibling thread exists, the mutexes are used this way:
> lock(exec_guard_mutex)
> cred_locked_in_execve = true;
> de_thread()
> lock(cred_guard_mutex)
> unlock(cred_guard_mutex)
> cred_locked_in_execve = false;
> unlock(exec_guard_mutex)
>
> so effectively no API change at all.
>
> If a traced sibling thread exists, the mutexes are used differently:
> lock(exec_guard_mutex)
> cred_locked_in_execve = true;
> unlock(exec_guard_mutex)
> de_thread()
> lock(cred_guard_mutex)
> unlock(cred_guard_mutex)
> lock(exec_guard_mutex)
> cred_locked_in_execve = false;
> unlock(exec_guard_mutex)
>
> Only the case changes that would deadlock anyway.


Let me propose a slight alternative that I think sets us up for long
term success.

Leave cred_guard_mutex as is, but declare it undesirable.  The
cred_guard_mutex as designed really is something we should get rid of.
As it it can sleep over several different userspace accesses.  The
copying of the exec arguments is technically as prone to deadlock as the
ptrace case.

Add a new mutex with a better name perhaps "exec_change_mutex" that is
used to guard the changes that exec makes to a process.

Then we gradually shift all the cred_guard_mutex users over to the new
mutex.  AKA one patch per user of cred_guard_mutex.  At each patch that
shifts things over we will have the opportunity to review the code to
see that there no funny dependencies that were missed.

I will sign up for working on the no_new_privs and ptrace_attach cases
as I think I can make those happen.  Especially no_new_privs.

Getting the easier cases will resolve your issues and put things on a
better footing.

Eric
