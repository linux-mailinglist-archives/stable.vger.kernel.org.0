Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A504D181074
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 07:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgCKGMC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 11 Mar 2020 02:12:02 -0400
Received: from mail-vi1eur05olkn2099.outbound.protection.outlook.com ([40.92.90.99]:43233
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726160AbgCKGMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 02:12:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fyeVOP+zgVlCJQbCBDx+B116RNep18NgrU9htCv7ST+MJOSVg8cwp9ZIB3hkP2NBI7ShqF90TGI5jaRfds3rKmY24FSo69jKcQZFBtREIw5PxtTjw/D+Qdhej0JG1O52zoQYNz0mvnPOJslAh6CU8P3k6tGkOMTTaf6e0o1kCgg5Y/ASDaZShUbzwVxRy2I9Hisz/yPXLhmw6kS1ihn7IgZRiH7zriqxhf4lVjbBO5n3Bhhsc4sXPLQCO/maN7MFr2tkrdMaAKAE7eZbbv/2nzOeP/NIpyoweNq2z2za/g+pHZBFycXbWKKhRFYRZDFkIzLW3ft6G+BmCvRqJeH9Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CG2lVs5buT64yAQDQfrF4BRc4UVsw/DyRi3By56IKCM=;
 b=dXG89GsJ0Y9X6eSav4NaS4dlDwH33LKl14VfSg3sCpJfO7dhjQydJOWPkBO2yxwT7qkPT3ebDzhJ0UcAaWiTEGNLsUqTu5S5Mli726h4G0QxhIe02F+bdNVoVPraCmQ7W5Ym0HIsuQYzp3ZkJo2vNlsrTB6ZavL8lhiV22dmswkYLMs3kj6kmvN25EMgfxZwB2SLYsjJFmHPI4lc9G9CAsg3gROjWpogx9N0G8ylCv0CgG1MIyjnQVwl7NZV/+sIambLiKGPsWpg8mW5VBJKoW/SNg0VEf7YCzkiiz91vLiPnsTOuEXzSHgcdVcn4/Krr+2LHg/pVmSe2TwiYnLqyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DB8EUR05FT054.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc0f::38) by
 DB8EUR05HT078.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc0f::64)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Wed, 11 Mar
 2020 06:11:57 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.238.51) by
 DB8EUR05FT054.mail.protection.outlook.com (10.233.238.111) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13 via Frontend Transport; Wed, 11 Mar 2020 06:11:57 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 06:11:57 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     "jannh@google.com" <jannh@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
CC:     Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "avagin@gmail.com" <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "duyuyang@gmail.com" <duyuyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        David Howells <dhowells@redhat.com>,
        James Morris <jamorris@linux.microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "christian@kellner.me" <christian@kellner.me>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "sargun@sargun.me" <sargun@sargun.me>
Subject: Re: [PATCH] pidfd: Stop taking cred_guard_mutex
Thread-Topic: [PATCH] pidfd: Stop taking cred_guard_mutex
Thread-Index: AQHV9w1dmrKXzF1nwkisARGyb9pH3qhCMseAgAADrsOAAAiGgIAAAvGAgAADRYCAABelgA==
Date:   Wed, 11 Mar 2020 06:11:57 +0000
Message-ID: <5a8b2794-b498-af33-1327-ff2861cff83f@hotmail.de>
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
 <AM6PR03MB5170AF454A8A9C37891B12B2E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
In-Reply-To: <AM6PR03MB5170AF454A8A9C37891B12B2E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-imapappendstamp: AM6PR03MB5170.eurprd03.prod.outlook.com
 (15.20.2793.013)
x-incomingtopheadermarker: OriginalChecksum:E45BB2544C586090C38E17B315A565CEFA66D1F593396D52DAAE1552D59B5643;UpperCasedChecksum:2881F61324411814D5BD39D5E91F8B9BFFC3FB3659E7CFB2B10D286FB4DA4128;SizeAsReceived:9446;Count:47
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [eh/3gyuvAApi+J5fKmcZx0IZizg7sx9B]
x-ms-publictraffictype: Email
x-incomingheadercount: 47
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 6ad72773-1414-481b-1f48-08d7c5831a75
x-ms-traffictypediagnostic: DB8EUR05HT078:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NfTADmGC1X+ro3AgRFa5jiXEPF/PZbjhVW3gyBcdaIVOtPvcqdXzCg8gJ+m3xR2dnLJ0fSskghFTCcGwt0LlrCCjGvieDSKzEKG47Ka2YwgLypxbw3Axkj+pRYJZiYDZYuJu1BEi0b9Mc13mUn44FbCSixv41dxO8slYF0XYE6i42RvEIW7WNpIZc+lb5zSY
x-ms-exchange-antispam-messagedata: RlAc0obM4Rtx1hnUd47wm4nKK7N3WXtMU16xqSFI+VJJzdrEQjVPzeNO54iVuvlsGTyCas3uLCavV9d+1NnwqwRScf2SzP3TnPtLjqBrOCyk3Tt5kEeEHjNreDrWZtsQia6cDyoVRCs0DCr2cC2M9w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <FC9F08256EEC25479D356BD08BCB1DED@sct-15-20-2387-20-msonline-outlook-45755.templateTenant>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ad72773-1414-481b-1f48-08d7c5831a75
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 06:11:57.0825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8EUR05HT078
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/20 9:22 PM, Bernd Edlinger wrote:
> On 3/10/20 9:10 PM, Jann Horn wrote:
>> On Tue, Mar 10, 2020 at 9:00 PM Jann Horn <jannh@google.com> wrote:
>>> On Tue, Mar 10, 2020 at 8:29 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>> Jann Horn <jannh@google.com> writes:
>>>>> On Tue, Mar 10, 2020 at 7:54 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>>>> During exec some file descriptors are closed and the files struct is
>>>>>> unshared.  But all of that can happen at other times and it has the
>>>>>> same protections during exec as at ordinary times.  So stop taking the
>>>>>> cred_guard_mutex as it is useless.
>>>>>>
>>>>>> Furthermore he cred_guard_mutex is a bad idea because it is deadlock
>>>>>> prone, as it is held in serveral while waiting possibly indefinitely
>>>>>> for userspace to do something.
>> [...]
>>>>> If you make this change, then if this races with execution of a setuid
>>>>> program that afterwards e.g. opens a unix domain socket, an attacker
>>>>> will be able to steal that socket and inject messages into
>>>>> communication with things like DBus. procfs currently has the same
>>>>> race, and that still needs to be fixed, but at least procfs doesn't
>>>>> let you open things like sockets because they don't have a working
>>>>> ->open handler, and it enforces the normal permission check for
>>>>> opening files.
>>>>
>>>> It isn't only exec that can change credentials.  Do we need a lock for
>>>> changing credentials?
>> [...]
>>>> If we need a lock around credential change let's design and build that.
>>>> Having a mismatch between what a lock is designed to do, and what
>>>> people use it for can only result in other bugs as people get confused.
>>>
>>> Hmm... what benefits do we get from making it a separate lock? I guess
>>> it would allow us to make it a per-task lock instead of a
>>> signal_struct-wide one? That might be helpful...
>>
>> But actually, isn't the core purpose of the cred_guard_mutex to guard
>> against concurrent credential changes anyway? That's what almost
>> everyone uses it for, and it's in the name...
>>
> 
> The main reason d'etre of exec_update_mutex is to get a consitent
> view of task->mm and task credentials.
> > The reason why you want the cred_guard_mutex, is that some action
> is changing the resulting credentials that the execve is about
> to install, and that is the data flow in the opposite direction.
> 

So in other words, you need the exec_update_mutex when you
access another thread's credentials and possibly the mmap at the
same time.

You need the cred_guard_mutex when you *change* the credentials
of another thread.  (Where you cannot be sure that the other thread
just started to execve something)

You need no mutex at all when you are just accessing or
even changing the credentials of the current thread.  (If another
thread is doing execve, your task will be killed, and wether
or not the credentials were changed does not matter any more)

> 
> Bernd.
> 
