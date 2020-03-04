Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58673179B3E
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 22:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388386AbgCDVtj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 4 Mar 2020 16:49:39 -0500
Received: from mail-db8eur05olkn2109.outbound.protection.outlook.com ([40.92.89.109]:25569
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388312AbgCDVtj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 16:49:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=faVfl4i2bhOq47UwmwwBE4WAuC40LduroLmpI1zSzlNIcsRC8eXIYdI8jpru5wv2wMVWrIDQoaAH+n9+Ir39YY6Uj6Z+aRxbgXFAReL+7n7FYSjZeFfiun4E8Gk94GhQdU3z+KSEGpu6jGe7QoTcKqDjp0mIR8wAxA+1rsbQ0sUSVcwKSg/3M7QBYDEjj5dK9TNCF3TWskyxIYG/ZOVCBDu/0TGu9wmHPPW4VUSCiKOoAPsmFQ/mxZTZGp/81+KyDrMk/sdZJuT5laFd19BHcIGRLwn2qgon/9TPwxrlVxEUTyxMF5yrMoJSwJPEfBLbpCH6DZ41lxBkKOSLYEvJgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ftFa1GiedZ3jm/A2BqFQP2k/AONu/ZjVDQ4zBX76Wnw=;
 b=a6GYoKu1t1zOf+tArdvN6/ejCVX7C3YZ2+1YlnFc5gEALOndGgQ+TE1hqlfvwlamtYif+omzq4vWkWvBVp/2QZjFav1kbPlfS1Nz/3dcNtZ5fpfSPMBoHGDFgxE9j27Ijj7/RxfSXrdGNXOfpFrQka580VV0fUnQaYv3Byq6KG5cUA086g4ztIZzU8iVwpjap3FNbxUfWqcVRhDsa5leej3sPkuoLXw+d3RXJ0DVit5zEUdBTJC8RTuSxdQ/wNlW4ut+R8qHonW9Y1zGzikwlhM3fUZhMuyUQrFpn2Pq9ohtzmBR03bJwJRECZ08+Ys/72CRbbT0wjghuDKPkn8/hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DB8EUR05FT056.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc0f::38) by
 DB8EUR05HT032.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc0f::404)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Wed, 4 Mar
 2020 21:49:33 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.238.54) by
 DB8EUR05FT056.mail.protection.outlook.com (10.233.238.156) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Wed, 4 Mar 2020 21:49:33 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Wed, 4 Mar 2020
 21:49:33 +0000
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0025.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Wed, 4 Mar 2020 21:49:31 +0000
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
Thread-Index: AQHV8VwLHjttz8YuA0eRTVSvUK/ceqg2/AiMgAAYPYCAAFh/v4ABFW8AgAAhC+yAAFeZgA==
Date:   Wed, 4 Mar 2020 21:49:33 +0000
Message-ID: <AM6PR03MB51701E2F405F6DBF1EEB57CDE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <87r1y8dqqz.fsf@x220.int.ebiederm.org>
In-Reply-To: <87r1y8dqqz.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZR0P278CA0025.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::12) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:62557CB1650F786308CCE2073097CE1614B856109F3345292D529D2901D1A4D4;UpperCasedChecksum:ADB2B4E1F815808B98D8E4E333C5EF8D604270ECA2274020740A89F380E57CCB;SizeAsReceived:9901;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [hGT579yfJmYGShynABRdCgRPJ7kcf4cf]
x-microsoft-original-message-id: <c4122dd4-11bd-e18e-f72f-e5a3856cffab@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 31a93ffe-eced-457c-9cee-08d7c085ecb7
x-ms-traffictypediagnostic: DB8EUR05HT032:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QtjHXyi4ws101j77dyyvsFKDYW89fY4JyZUZ2ZY+BQZIlSsFxzAb3gFgPeTf5PRTdgCtAjIfIpfMbIsmNIG+VBXYg71BB2V6EE5YYq7/lz6jNlJaUFXecEDmFcE+VzExmgECXOI7Jyg5X4DdpLJkJlwWYQk6toDK4F/lINrwmi4c2RaRCEAIKeFoBbCJxoAt
x-ms-exchange-antispam-messagedata: lFPCn6i+g4ysEllPkUjew0NUljmOE1f6bFKyxfjpMnTOoCXjXJ3+B6B4g74HevRTENeSVVx5Lrx9XUcuNrv8RarJ3QYEHO5zKdqw4eMHwYcLjq8a8kGnGeJ9ZZ6Y4h4ZIrwY89J2CMl7uRAUqEqb+g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <9D992DE6E53E02479452C77CA67DBE6C@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 31a93ffe-eced-457c-9cee-08d7c085ecb7
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2020 21:49:33.4981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8EUR05HT032
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/4/20 5:33 PM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> On 3/3/20 9:08 PM, Eric W. Biederman wrote:
>>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>>>
>>>> On 3/3/20 4:18 PM, Eric W. Biederman wrote:
>>>>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>>>>>> diff --git a/tools/testing/selftests/ptrace/vmaccess.c b/tools/testing/selftests/ptrace/vmaccess.c
>>>>>> new file mode 100644
>>>>>> index 0000000..6d8a048
>>>>>> --- /dev/null
>>>>>> +++ b/tools/testing/selftests/ptrace/vmaccess.c
>>>>>> @@ -0,0 +1,66 @@
>>>>>> +// SPDX-License-Identifier: GPL-2.0+
>>>>>> +/*
>>>>>> + * Copyright (c) 2020 Bernd Edlinger <bernd.edlinger@hotmail.de>
>>>>>> + * All rights reserved.
>>>>>> + *
>>>>>> + * Check whether /proc/$pid/mem can be accessed without causing deadlocks
>>>>>> + * when de_thread is blocked with ->cred_guard_mutex held.
>>>>>> + */
>>>>>> +
>>>>>> +#include "../kselftest_harness.h"
>>>>>> +#include <stdio.h>
>>>>>> +#include <fcntl.h>
>>>>>> +#include <pthread.h>
>>>>>> +#include <signal.h>
>>>>>> +#include <unistd.h>
>>>>>> +#include <sys/ptrace.h>
>>>>>> +
>>>>>> +static void *thread(void *arg)
>>>>>> +{
>>>>>> +	ptrace(PTRACE_TRACEME, 0, 0L, 0L);
>>>>>> +	return NULL;
>>>>>> +}
>>>>>> +
>>>>>> +TEST(vmaccess)
>>>>>> +{
>>>>>> +	int f, pid = fork();
>>>>>> +	char mm[64];
>>>>>> +
>>>>>> +	if (!pid) {
>>>>>> +		pthread_t pt;
>>>>>> +
>>>>>> +		pthread_create(&pt, NULL, thread, NULL);
>>>>>> +		pthread_join(pt, NULL);
>>>>>> +		execlp("true", "true", NULL);
>>>>>> +	}
>>>>>> +
>>>>>> +	sleep(1);
>>>>>> +	sprintf(mm, "/proc/%d/mem", pid);
>>>>>> +	f = open(mm, O_RDONLY);
>>>>>> +	ASSERT_LE(0, f);
>>>>>> +	close(f);
>>>>>> +	f = kill(pid, SIGCONT);
>>>>>> +	ASSERT_EQ(0, f);
>>>>>> +}
>>>>>> +
>>>>>> +TEST(attach)
>>>>>> +{
>>>>>> +	int f, pid = fork();
>>>>>> +
>>>>>> +	if (!pid) {
>>>>>> +		pthread_t pt;
>>>>>> +
>>>>>> +		pthread_create(&pt, NULL, thread, NULL);
>>>>>> +		pthread_join(pt, NULL);
>>>>>> +		execlp("true", "true", NULL);
>>>>>> +	}
>>>>>> +
>>>>>> +	sleep(1);
>>>>>> +	f = ptrace(PTRACE_ATTACH, pid, 0L, 0L);
>>>>>
>>>>> To be meaningful this code needs to learn to loop when
>>>>> ptrace returns -EAGAIN.
>>>>>
>>>>> Because that is pretty much what any self respecting user space
>>>>> process will do.
>>>>>
>>>>> At which point I am not certain we can say that the behavior has
>>>>> sufficiently improved not to be a deadlock.
>>>>>
>>>>
>>>> In this special dead-duck test it won't work, but it would
>>>> still be lots more transparent what is going on, since previously
>>>> you had two zombie process, and no way to even output debug
>>>> messages, which also all self respecting user space processes
>>>> should do.
>>>
>>> Agreed it is more transparent.  So if you are going to deadlock
>>> it is better.
>>>
>>> My previous proposal (which I admit is more work to implement) would
>>> actually allow succeeding in this case and so it would not be subject to
>>> a dead lock (even via -EGAIN) at this point.
>>>
>>>> So yes, I can at least give a good example and re-try it several
>>>> times together with wait4 which a tracer is expected to do.
>>>
>>> Thank you,
>>>
>>> Eric
>>>
>>
>> Okay, I think it can be done with minimal API changes,
>> but it needs two mutexes, one that guards the execve,
>> and one that guards only the credentials.
>>
>> If no traced sibling thread exists, the mutexes are used this way:
>> lock(exec_guard_mutex)
>> cred_locked_in_execve = true;
>> de_thread()
>> lock(cred_guard_mutex)
>> unlock(cred_guard_mutex)
>> cred_locked_in_execve = false;
>> unlock(exec_guard_mutex)
>>
>> so effectively no API change at all.
>>
>> If a traced sibling thread exists, the mutexes are used differently:
>> lock(exec_guard_mutex)
>> cred_locked_in_execve = true;
>> unlock(exec_guard_mutex)
>> de_thread()
>> lock(cred_guard_mutex)
>> unlock(cred_guard_mutex)
>> lock(exec_guard_mutex)
>> cred_locked_in_execve = false;
>> unlock(exec_guard_mutex)
>>
>> Only the case changes that would deadlock anyway.
> 
> 
> Let me propose a slight alternative that I think sets us up for long
> term success.
> 
> Leave cred_guard_mutex as is, but declare it undesirable.  The
> cred_guard_mutex as designed really is something we should get rid of.
> As it it can sleep over several different userspace accesses.  The
> copying of the exec arguments is technically as prone to deadlock as the
> ptrace case.
> 
> Add a new mutex with a better name perhaps "exec_change_mutex" that is
> used to guard the changes that exec makes to a process.
> 
> Then we gradually shift all the cred_guard_mutex users over to the new
> mutex.  AKA one patch per user of cred_guard_mutex.  At each patch that
> shifts things over we will have the opportunity to review the code to
> see that there no funny dependencies that were missed.
> 
> I will sign up for working on the no_new_privs and ptrace_attach cases
> as I think I can make those happen.  Especially no_new_privs.
> 
> Getting the easier cases will resolve your issues and put things on a
> better footing.
> 
> Eric
> 

Okay, however I think we will need two mutexes in the long term.

So currently I have reduced the cred_guard_mutex to protect just
the loading of the executable code in the process vm, since that
is what works for vm_access, (one of the test cases).
And another mutex that protects the whole execve function, that
is need for ptrace, (and seccomp).
But I have only a test case for ptrace.


If I understand that right, I should not recycle cred_guard_mutex
but leave it as is, and create two additional mutexes which will
take over step by step.

Sounds reasonable, indeed.

I will send an update (v6) what I have right now,
but just for information, so you can see how my minimal API-Change
approach works.


Bernd.
