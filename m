Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A22C4177C47
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 17:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgCCQsI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 3 Mar 2020 11:48:08 -0500
Received: from mail-vi1eur05olkn2013.outbound.protection.outlook.com ([40.92.90.13]:13674
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727175AbgCCQsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 11:48:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxXSGwJyxOJJSfVF95isRusTopJqEISQq+PeECRc0tZbLgi065HEQRZotFxuPOSv/IWYBfAPR1HeJA0LDrWkBjy1CIBCY6656pGbYtKNseeWtawad/36+KGklRILtw5SWdQKn1FXDCq7trsXZ4W9VHioflLhcYWaNdlVNrV6f3XnFa4ErvLbE8HdemYb67+RGXo2I8alpF2GSTv1MVuPR9EpCHuvxIVDt1xtyAFQqvEjwF4MRgFCTAYwDizzLMhUIenY9wrGbAL5i3Xd2lrjN0BMJ75oEJGj9eZxaYJF+RMJ+P97jcp4NIMzbvheETez5cu46xe349yK8HiAZ+6pVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPqB5Ral2XPaN7+8L5X3jWWV9jvT0c+PO19c90iRNr8=;
 b=PQwzB0kzfUksrDQTqTlXDCC63HsQAIGyxOpmUJhPxZOjGZZG40odC5NViC3pJcLpWP5YwaNjvFHGjv3ni4Xp9PNSU9Q/U6zYwTj3Hinfa6vqpO5YUkeeaeWlLWAXQ5eKPTCM8uwQyd7GEfbYt3Dsvhfo0Ft5cyYCGyApFCY6fuQJn4Imyn3w4pkG9rtxVlZIvtH3eQeE5BCyF5DBy+PSqZODaKDxKhFAnaARY8REZy5+spiqJx5wLZ5n83tkQQNkq0noaX64XWgPdENpJkArPKIaaL3dUljIZU7e8Hvu3jTJYRCdXsQ8K8V8aAaapy/G61gxSlyIGZ7GwtI2poHWQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from AM6EUR05FT031.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc11::3c) by
 AM6EUR05HT132.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc11::480)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Tue, 3 Mar
 2020 16:48:02 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.240.51) by
 AM6EUR05FT031.mail.protection.outlook.com (10.233.240.151) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14 via Frontend Transport; Tue, 3 Mar 2020 16:48:02 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 16:48:01 +0000
Received: from [192.168.1.101] (92.77.140.102) by FR2P281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Tue, 3 Mar 2020 16:48:00 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
CC:     Christian Brauner <christian.brauner@ubuntu.com>,
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
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
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
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCHv5] exec: Fix a deadlock in ptrace
Thread-Topic: [PATCHv5] exec: Fix a deadlock in ptrace
Thread-Index: AQHV8VwLHjttz8YuA0eRTVSvUK/ceqg2/AiMgAAYPYA=
Date:   Tue, 3 Mar 2020 16:48:01 +0000
Message-ID: <AM6PR03MB5170609D44967E044FD1BE40E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
In-Reply-To: <87v9nlii0b.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FR2P281CA0009.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::19) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:A2C3BEAD71CCA3D4DF04CD660CC5A62EA19F3EEA58B170367F6879244E084CE6;UpperCasedChecksum:FA278A141CF444D4BC371EC4AEE728AB5E38FFAABBFEAC432983EC3F6D34A4ED;SizeAsReceived:9658;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [5VFh/Y1Vm1Zief3TOfwF2B2OBSonTTn/]
x-microsoft-original-message-id: <a707b4c3-ee7f-4708-7ba3-8bbbd9344ba3@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: bb8c85d8-121e-4e52-97fa-08d7bf92a2e3
x-ms-traffictypediagnostic: AM6EUR05HT132:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Ru2NduRa+uiENL4PegR1TGITrvTpVx7Q1PbsVp3UsSVfYLvpFu8AEcdyjRmFCgzIw4yNr3PZWvKdBYMrRaadQdyBZG6E6+tuiyQgRYWOm1XRkZpkLoWy31E40eRVw1KGasHIJgwMiBFWCXFegz6K1b665hYLf04yn965OoyWDtokxih4Gwx6clFIyw1wYCe
x-ms-exchange-antispam-messagedata: iFKuB+D5cAebMyyBynVr4RX3CnOH5Mok7Vu375i79ZazSVRuHxUUOjB/gZxb9vny24GmwE3C+/HrIDw75UBGX/ufGeYx6s8x89aeitTpTOTYrFO7Scew7fy3lqQGBiqoOguFlW+6yjzv6MhjUPeTsA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <75742250B8A4564AB1CFEEF3CD6E7B49@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: bb8c85d8-121e-4e52-97fa-08d7bf92a2e3
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2020 16:48:01.8877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6EUR05HT132
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/3/20 4:18 PM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> This fixes a deadlock in the tracer when tracing a multi-threaded
>> application that calls execve while more than one thread are running.
>>
>> I observed that when running strace on the gcc test suite, it always
>> blocks after a while, when expect calls execve, because other threads
>> have to be terminated.  They send ptrace events, but the strace is no
>> longer able to respond, since it is blocked in vm_access.
>>
>> The deadlock is always happening when strace needs to access the
>> tracees process mmap, while another thread in the tracee starts to
>> execve a child process, but that cannot continue until the
>> PTRACE_EVENT_EXIT is handled and the WIFEXITED event is received:
> 
> A couple of things.
> 
> Why do we think it is safe to change the behavior exposed to userspace?
> Not the deadlock but all of the times the current code would not
> deadlock?
> 
> Especially given that this is a small window it might be hard for people
> to track down and report so we need a strong argument that this won't
> break existing userspace before we just change things.
> 

Hmm, I tend to agree.

> Usually surveying all of the users of a system call that we can find
> and checking to see if they might be affected by the change in behavior
> is difficult enough that we usually opt for not being lazy and
> preserving the behavior.
> 
> This patch is up to two changes in behavior now, that could potentially
> affect a whole array of programs.  Adding linux-api so that this change
> in behavior can be documented if/when this change goes through.
> 

One is PTRACE_ACCESS possibly returning EAGAIN, yes.

We could try to restrict that behavior change to when any
thread is ptraced when execve starts, can't be too complicated.


But the other is only SYS_seccomp returning EAGAIN, when a different
thread of the current process is calling execve at the same time.

I would consider it completely impossible to have any user-visual effect,
since de_thread is just terminating all threads, including the thread
where the -EAGAIN was returned, so we will never know what happened.


> If you can split the documentation and test fixes out into separate
> patches that would help reviewing this code, or please make it explicit
> that the your are changing documentation about behavior that is changing
> with this patch.
> 

I am not sure if I have touched the right user documentation.

I only saw a document referring to a non-existent "current->cred_replace_mutex"
I haven't digged the git history, but that must be pre-historic IMHO.
It appears to me that is some developer documentation, but it's nevertheless
worth to keep up to date when the code changes.

So where would I add the possibility for PTRACE_ATTACH to return -EAGAIN ?


Bernd.

> Eric
> 
>> diff --git a/tools/testing/selftests/ptrace/vmaccess.c b/tools/testing/selftests/ptrace/vmaccess.c
>> new file mode 100644
>> index 0000000..6d8a048
>> --- /dev/null
>> +++ b/tools/testing/selftests/ptrace/vmaccess.c
>> @@ -0,0 +1,66 @@
>> +// SPDX-License-Identifier: GPL-2.0+
>> +/*
>> + * Copyright (c) 2020 Bernd Edlinger <bernd.edlinger@hotmail.de>
>> + * All rights reserved.
>> + *
>> + * Check whether /proc/$pid/mem can be accessed without causing deadlocks
>> + * when de_thread is blocked with ->cred_guard_mutex held.
>> + */
>> +
>> +#include "../kselftest_harness.h"
>> +#include <stdio.h>
>> +#include <fcntl.h>
>> +#include <pthread.h>
>> +#include <signal.h>
>> +#include <unistd.h>
>> +#include <sys/ptrace.h>
>> +
>> +static void *thread(void *arg)
>> +{
>> +	ptrace(PTRACE_TRACEME, 0, 0L, 0L);
>> +	return NULL;
>> +}
>> +
>> +TEST(vmaccess)
>> +{
>> +	int f, pid = fork();
>> +	char mm[64];
>> +
>> +	if (!pid) {
>> +		pthread_t pt;
>> +
>> +		pthread_create(&pt, NULL, thread, NULL);
>> +		pthread_join(pt, NULL);
>> +		execlp("true", "true", NULL);
>> +	}
>> +
>> +	sleep(1);
>> +	sprintf(mm, "/proc/%d/mem", pid);
>> +	f = open(mm, O_RDONLY);
>> +	ASSERT_LE(0, f);
>> +	close(f);
>> +	f = kill(pid, SIGCONT);
>> +	ASSERT_EQ(0, f);
>> +}
>> +
>> +TEST(attach)
>> +{
>> +	int f, pid = fork();
>> +
>> +	if (!pid) {
>> +		pthread_t pt;
>> +
>> +		pthread_create(&pt, NULL, thread, NULL);
>> +		pthread_join(pt, NULL);
>> +		execlp("true", "true", NULL);
>> +	}
>> +
>> +	sleep(1);
>> +	f = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
> 
> To be meaningful this code needs to learn to loop when
> ptrace returns -EAGAIN.
> 
> Because that is pretty much what any self respecting user space
> process will do.
> 
> At which point I am not certain we can say that the behavior has
> sufficiently improved not to be a deadlock.
> 

In this special dead-duck test it won't work, but it would
still be lots more transparent what is going on, since previously
you had two zombie process, and no way to even output debug
messages, which also all self respecting user space processes
should do.

So yes, I can at least give a good example and re-try it several
times together with wait4 which a tracer is expected to do.

Bernd.

>> +	ASSERT_EQ(EAGAIN, errno);
>> +	ASSERT_EQ(f, -1);
>> +	f = kill(pid, SIGCONT);
>> +	ASSERT_EQ(0, f);
>> +}
>> +
>> +TEST_HARNESS_MAIN
> 
> Eric
> 
