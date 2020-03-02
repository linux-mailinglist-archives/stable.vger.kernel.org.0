Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4807176688
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 23:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgCBWAt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 2 Mar 2020 17:00:49 -0500
Received: from mail-oln040092068021.outbound.protection.outlook.com ([40.92.68.21]:26576
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbgCBWAt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 17:00:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MN/Lz8sjgk+Yeusp0kxCT8xuPQtnn803Zmy4q6PWXvpIVlSdMWp6eyt8Io6L9QLs5c7UAEvyadfgeANAxsU3U9jYMwUiJdamR6RVRCqTetHL65TDhB84asI8DAnJyoNtT0T+nviMYwIJLrG6xRRZs7SefXh2JtpS8Ke2CrGkikCF27CGkkeENSG4xFjlIGlkiryXnqcbeu9rCJsDLZNtvApDO4mjRUX66McmDAqzAtOs/EZtwFnIIi7AdIdKJ1RqqhMBjZB4zY2sf8kBSzAjcNOQoFKSmKvSzlhNdto0rZ+JzpI0B5/ntEj0H/p69bFrxAh1ktLGYd/zCM1obfvvkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QZzhBuWiWxXmMmyJixpYHm93oCz9K5B0k3XRFu8az4=;
 b=mhxdNGDtUoMAuC6P5Ey6T9xKbUlMna62f9c8o8onBYFYr38HJbrbmZQCODAEy7UyZvjUxvOk2+GO15DDcMUzW0SW+q15eWtH8NtBU3F3m8vIZydNqHgW8In9W2BCqXSP040jlX0b1h2nQCXMIbywaFQhGUheJ9CFZqsPvYRxZFTHNbS4e0RNMub70kzTpErR5yr9XXNwgmwmsq+xSIGyzOciOf4pgKzM6MCwfda0+jhL8jZp2vcjiQHh2fpVM/eJiauP4KMDGUQ2GnUUX9rRWJqsRMMb5eBMBMbiSEf+CeJtJnvHykmYKYsYkdb3n+E2lQm8XzPHCAEhmUoB69MUMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HE1EUR02FT019.eop-EUR02.prod.protection.outlook.com
 (2a01:111:e400:7e1d::39) by
 HE1EUR02HT071.eop-EUR02.prod.protection.outlook.com (2a01:111:e400:7e1d::215)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Mon, 2 Mar
 2020 22:00:42 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.10.57) by
 HE1EUR02FT019.mail.protection.outlook.com (10.152.10.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15 via Frontend Transport; Mon, 2 Mar 2020 22:00:42 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 22:00:42 +0000
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0045.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Mon, 2 Mar 2020 22:00:40 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
CC:     Jann Horn <jannh@google.com>,
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
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
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
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCHv2] exec: Fix a deadlock in ptrace
Thread-Topic: [PATCHv2] exec: Fix a deadlock in ptrace
Thread-Index: AQHV8AjGwZG4WijWc0+aQpdADP+q6qg02ufjgACXoYCAAASqH4AAAMAAgAAEyVeAAA77AIAATaqLgAACk4A=
Date:   Mon, 2 Mar 2020 22:00:42 +0000
Message-ID: <AM6PR03MB51709689FF4A00A7DCFB26A4E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <87v9nmjulm.fsf@x220.int.ebiederm.org>
In-Reply-To: <87v9nmjulm.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZR0P278CA0045.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::14) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:C79D43E4464E020949E83EE8248B4C8508FE96D0A7F0B78AC8EE1607E5579DA3;UpperCasedChecksum:45647EE3E8772478C665432775C6FBCB0C8882DDD8F9E95CCBC9F5094683F914;SizeAsReceived:9617;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [RWcdFN4HY5W3ZZLaWdS6b+6Tvl0ONnw6]
x-microsoft-original-message-id: <392ad677-231a-73aa-12cb-5b5f17fd6c26@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: cf74b29c-8767-4e40-6260-08d7bef5269d
x-ms-traffictypediagnostic: HE1EUR02HT071:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FuLv4NiYOQauXnhGG8Y72ga4PODLHLJcHxvySTTnF9L2PcRxvt4c8guyOgzxVK0jjUwRa7b5fLvL2D7LwzpV31zA4Ufo4aIbZrqzxrStDt62/d4VvoF9NTYTftCJBIwEVzPZ6lYJIXeuR+KqJAQ/0yeM75WBkq7A1hC6PWwCrTdd3iuN4WKCjFGeIth+W92S
x-ms-exchange-antispam-messagedata: vuioXtDVgWXSbj3tO0Iu7GmkNOoEcNvqs5cvH31eIg5Q1cAdHtDJwFvHIrA9s2n+CzuiV7rwGZlpTKr4f2qW8NGgl02ka4gj4NIBAD9RZGD8q7x2yFP6ebcJP8ftdAVes/SPlvxuk2PTInr96kyA7A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <0275423BDC635A4DB744AD8D7291FEDA@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: cf74b29c-8767-4e40-6260-08d7bef5269d
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 22:00:42.3756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR02HT071
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/2/20 10:49 PM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> On 3/2/20 5:17 PM, Eric W. Biederman wrote:
>>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>>>
>>>> On 3/2/20 4:57 PM, Eric W. Biederman wrote:
>>>>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>>>>>
>>>>>>
>>>>>> I tried this with s/EACCESS/EACCES/.
>>>>>>
>>>>>> The test case in this patch is not fixed, but strace does not freeze,
>>>>>> at least with my setup where it did freeze repeatable.
>>>>>
>>>>> Thanks, That is what I was aiming at.
>>>>>
>>>>> So we have one method we can pursue to fix this in practice.
>>>>>
>>>>>> That is
>>>>>> obviously because it bypasses the cred_guard_mutex.  But all other
>>>>>> process that access this file still freeze, and cannot be
>>>>>> interrupted except with kill -9.
>>>>>>
>>>>>> However that smells like a denial of service, that this
>>>>>> simple test case which can be executed by guest, creates a /proc/$pid/mem
>>>>>> that freezes any process, even root, when it looks at it.
>>>>>> I mean: "ln -s README /proc/$pid/mem" would be a nice bomb.
>>>>>
>>>>> Yes.  Your the test case in your patch a variant of the original
>>>>> problem.
>>>>>
>>>>>
>>>>> I have been staring at this trying to understand the fundamentals of the
>>>>> original deeper problem.
>>>>>
>>>>> The current scope of cred_guard_mutex in exec is because being ptraced
>>>>> causes suid exec to act differently.  So we need to know early if we are
>>>>> ptraced.
>>>>>
>>>>
>>>> It has a second use, that it prevents two threads entering execve,
>>>> which would probably result in disaster.
>>>
>>> Exec can fail with an error code up until de_thread.  de_thread causes
>>> exec to fail with the error code -EAGAIN for the second thread to get
>>> into de_thread.
>>>
>>> So no.  The cred_guard_mutex is not needed for that case at all.
>>>
>>
>> Okay, but that will reset current->in_execve, right?
> 
> Absolutely.
> 
> The error handling kicks in and exec_binprm fails with a negative
> return code.  Then __do_excve_file cleans up and clears
> current->in_execve.
> 

Yes of course.  I was under the wrong impression that that value is
a kind of global, but it is a thread local.

So I think I need a new boolean see v3 of the patch, and soon v4 (with
just one comment fixed).

I'm currently executing the strace v5.5 testsuite, and every test
is passed so far.  I'll also look at gdb testsuite, before I send the
next version.


Thanks
Bernd.

