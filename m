Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0161760C8
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 18:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgCBRNh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 2 Mar 2020 12:13:37 -0500
Received: from mail-vi1eur05olkn2013.outbound.protection.outlook.com ([40.92.90.13]:28162
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726451AbgCBRNh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 12:13:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cuZdh4Q3G0BdUqKFlSBo4CRVCUuUSpPKxfZQhMjEy7Hg4mrD33IA7POZB2GB5LdPvU7hPk6i7JAxo6EpDgZfbmeWghA9hVRyjml0tEd4YVxklJDwbfLNURbSyxQuCwWC28UWDEui+rdkeOGtkV4+ZfFZ0Dsn2TNP6anIhv9Qw9MsALK4fVDaRiNGiPccjxRnOSlbur0XodFoj0t2mbKAbmqSxM2gBsmLoldxV0g8gQ4Sxlyvl+nJVAlNPMhwRF73/GJ2cgc8T0LX+T8zY1GXYQrdl/iKi5WL/7UaqycYKOuSUQOUSCZA+K7D+ZpZbOpk5l7wfuF1AP1ssJHZOY900g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4Qr6lLw8CV2Brnq7qtJZ08k3XwrEVL/z6ssdJEf8X0=;
 b=hoqRa7Ya6FMJzaS22tJKYatlMUbYWrPOdzm8UR/2embysCjvR4DxthW29gxrIsJ7kZeCoQX2dNKkVc+32OpRxafswQwla9KrneslJHFPP6BpT7NqVYTKUptnUdkieLOirk2zZcJmd5SW0BQ4JdeWpfpksm+km6o67TaqVYcBfjKrMndlUnSLzZGp88Nofp8ajoAfoq9SXRynpM/kkqA/K6B3p+CQEvKLDYMFVX0SPeDlCPppd+x8R3/+H/ttcYs0p9sV0fBhWHOLdCasWkcb9uVKCt8723SSUTr/1G943j3HfWmeTbJfe7msgZa36e9WMVqUt8oHcnehbn8kifTtWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from AM6EUR05FT020.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc11::3a) by
 AM6EUR05HT022.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc11::122)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Mon, 2 Mar
 2020 17:13:31 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.240.60) by
 AM6EUR05FT020.mail.protection.outlook.com (10.233.241.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14 via Frontend Transport; Mon, 2 Mar 2020 17:13:31 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 17:13:31 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM4PR05CA0016.eurprd05.prod.outlook.com (2603:10a6:205::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Mon, 2 Mar 2020 17:13:29 +0000
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
Thread-Index: AQHV8AjGwZG4WijWc0+aQpdADP+q6qg02ufjgACXoYCAAASqH4AAAMAAgAAEyVeAAA77AA==
Date:   Mon, 2 Mar 2020 17:13:31 +0000
Message-ID: <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
In-Reply-To: <875zfmloir.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR05CA0016.eurprd05.prod.outlook.com (2603:10a6:205::29)
 To AM6PR03MB5170.eurprd03.prod.outlook.com (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:1EFB63CF3AF28D0CE965C79CF93DD2F8A834E2DCD45D2150F076C6F3B6452180;UpperCasedChecksum:E34ABCC5BF6FF0D37F9A3E2D38963EB269F629B1F0D78CFF8019DC3DD628152E;SizeAsReceived:9455;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [iQMbvCt4QB+8RYQmxvOQCC70cu5hAA7g]
x-microsoft-original-message-id: <8c11f6ae-fd06-1709-c2bc-9c14d4dc8e86@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 085f4925-c2f8-4ea6-5d78-08d7becd080a
x-ms-traffictypediagnostic: AM6EUR05HT022:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2kl4YEj/Wt7IFxUqz2HDx3Ve6X8We3z6+gcU3nAHyHPK48lqkyBMAiuqNoRh618KWY9DUb0W9tZK1aiApHrLewDLZFKqvxGhuATb3Uw9SiX2JwV1xgDcj+chq0+hd6O9eF942vhPzM8Oh4u1MM91ziWkrOciCvtjzmXNH0YHnDzA2m/quh3V+iWvfZ5n18WA
x-ms-exchange-antispam-messagedata: FfPzUEdcNfmy1xcsymD7IjyWW4dbm0GNwEyEz0rgZ7vN4JV8uFK2I2uZLLKI5Xq5HsTr/6ndmhPiibZx9chTVLtTSONXd5+DbXMNdraBzElWD6VSOQZUXTYFamekJFPiN8OVzSxpVR2MvTfskngT6A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <1BC8A6ED600912469119746F1E8115F3@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 085f4925-c2f8-4ea6-5d78-08d7becd080a
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 17:13:31.2172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6EUR05HT022
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/2/20 5:17 PM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> On 3/2/20 4:57 PM, Eric W. Biederman wrote:
>>> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
>>>
>>>>
>>>> I tried this with s/EACCESS/EACCES/.
>>>>
>>>> The test case in this patch is not fixed, but strace does not freeze,
>>>> at least with my setup where it did freeze repeatable.
>>>
>>> Thanks, That is what I was aiming at.
>>>
>>> So we have one method we can pursue to fix this in practice.
>>>
>>>> That is
>>>> obviously because it bypasses the cred_guard_mutex.  But all other
>>>> process that access this file still freeze, and cannot be
>>>> interrupted except with kill -9.
>>>>
>>>> However that smells like a denial of service, that this
>>>> simple test case which can be executed by guest, creates a /proc/$pid/mem
>>>> that freezes any process, even root, when it looks at it.
>>>> I mean: "ln -s README /proc/$pid/mem" would be a nice bomb.
>>>
>>> Yes.  Your the test case in your patch a variant of the original
>>> problem.
>>>
>>>
>>> I have been staring at this trying to understand the fundamentals of the
>>> original deeper problem.
>>>
>>> The current scope of cred_guard_mutex in exec is because being ptraced
>>> causes suid exec to act differently.  So we need to know early if we are
>>> ptraced.
>>>
>>
>> It has a second use, that it prevents two threads entering execve,
>> which would probably result in disaster.
> 
> Exec can fail with an error code up until de_thread.  de_thread causes
> exec to fail with the error code -EAGAIN for the second thread to get
> into de_thread.
> 
> So no.  The cred_guard_mutex is not needed for that case at all.
> 

Okay, but that will reset current->in_execve, right?

>>> If that case did not exist we could reduce the scope of the
>>> cred_guard_mutex in exec to where your patch puts the cred_change_mutex.
>>>
>>> I am starting to think reworking how we deal with ptrace and exec is the
>>> way to solve this problem.
> 
> 
> I am 99% convinced that the fix is to move cred_guard_mutex down.
> 
> Then right after we take cred_guard_mutex do:
> 	if (ptraced) {
> 		use_original_creds();
> 	}
> 
> And call it a day.
> 
> The details suck but I am 99% certain that would solve everyones
> problems, and not be too bad to audit either.
> 
> Eric
> 
