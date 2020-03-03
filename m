Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAAF81783B5
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 21:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbgCCULO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 15:11:14 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:41204 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727862AbgCCULO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 15:11:14 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1j9Dsi-0002GA-R5; Tue, 03 Mar 2020 13:11:08 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1j9DsW-0007aC-CC; Tue, 03 Mar 2020 13:11:08 -0700
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
Date:   Tue, 03 Mar 2020 14:08:44 -0600
In-Reply-To: <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Tue, 3 Mar 2020 16:48:01 +0000")
Message-ID: <87a74xi4kz.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j9DsW-0007aC-CC;;;mid=<87a74xi4kz.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18F6HBvD5EFsjRqfjRChWMHQNE7HoAAFNk=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa01.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
        version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4839]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 829 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 17 (2.0%), b_tie_ro: 16 (1.9%), parse: 1.40
        (0.2%), extract_message_metadata: 15 (1.8%), get_uri_detail_list: 2.3
        (0.3%), tests_pri_-1000: 24 (2.8%), tests_pri_-950: 1.57 (0.2%),
        tests_pri_-900: 1.34 (0.2%), tests_pri_-90: 49 (6.0%), check_bayes: 48
        (5.7%), b_tokenize: 19 (2.3%), b_tok_get_all: 12 (1.5%), b_comp_prob:
        3.3 (0.4%), b_tok_touch_all: 4.7 (0.6%), b_finish: 0.59 (0.1%),
        tests_pri_0: 706 (85.2%), check_dkim_signature: 0.63 (0.1%),
        check_dkim_adsp: 11 (1.3%), poll_dns_idle: 7 (0.9%), tests_pri_10: 2.6
        (0.3%), tests_pri_500: 7 (0.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCHv5] exec: Fix a deadlock in ptrace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> On 3/3/20 4:18 PM, Eric W. Biederman wrote:
>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>>> diff --git a/tools/testing/selftests/ptrace/vmaccess.c b/tools/testing/selftests/ptrace/vmaccess.c
>>> new file mode 100644
>>> index 0000000..6d8a048
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/ptrace/vmaccess.c
>>> @@ -0,0 +1,66 @@
>>> +// SPDX-License-Identifier: GPL-2.0+
>>> +/*
>>> + * Copyright (c) 2020 Bernd Edlinger <bernd.edlinger@hotmail.de>
>>> + * All rights reserved.
>>> + *
>>> + * Check whether /proc/$pid/mem can be accessed without causing deadlocks
>>> + * when de_thread is blocked with ->cred_guard_mutex held.
>>> + */
>>> +
>>> +#include "../kselftest_harness.h"
>>> +#include <stdio.h>
>>> +#include <fcntl.h>
>>> +#include <pthread.h>
>>> +#include <signal.h>
>>> +#include <unistd.h>
>>> +#include <sys/ptrace.h>
>>> +
>>> +static void *thread(void *arg)
>>> +{
>>> +	ptrace(PTRACE_TRACEME, 0, 0L, 0L);
>>> +	return NULL;
>>> +}
>>> +
>>> +TEST(vmaccess)
>>> +{
>>> +	int f, pid = fork();
>>> +	char mm[64];
>>> +
>>> +	if (!pid) {
>>> +		pthread_t pt;
>>> +
>>> +		pthread_create(&pt, NULL, thread, NULL);
>>> +		pthread_join(pt, NULL);
>>> +		execlp("true", "true", NULL);
>>> +	}
>>> +
>>> +	sleep(1);
>>> +	sprintf(mm, "/proc/%d/mem", pid);
>>> +	f = open(mm, O_RDONLY);
>>> +	ASSERT_LE(0, f);
>>> +	close(f);
>>> +	f = kill(pid, SIGCONT);
>>> +	ASSERT_EQ(0, f);
>>> +}
>>> +
>>> +TEST(attach)
>>> +{
>>> +	int f, pid = fork();
>>> +
>>> +	if (!pid) {
>>> +		pthread_t pt;
>>> +
>>> +		pthread_create(&pt, NULL, thread, NULL);
>>> +		pthread_join(pt, NULL);
>>> +		execlp("true", "true", NULL);
>>> +	}
>>> +
>>> +	sleep(1);
>>> +	f = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
>> 
>> To be meaningful this code needs to learn to loop when
>> ptrace returns -EAGAIN.
>> 
>> Because that is pretty much what any self respecting user space
>> process will do.
>> 
>> At which point I am not certain we can say that the behavior has
>> sufficiently improved not to be a deadlock.
>> 
>
> In this special dead-duck test it won't work, but it would
> still be lots more transparent what is going on, since previously
> you had two zombie process, and no way to even output debug
> messages, which also all self respecting user space processes
> should do.

Agreed it is more transparent.  So if you are going to deadlock
it is better.

My previous proposal (which I admit is more work to implement) would
actually allow succeeding in this case and so it would not be subject to
a dead lock (even via -EGAIN) at this point.

> So yes, I can at least give a good example and re-try it several
> times together with wait4 which a tracer is expected to do.

Thank you,

Eric
