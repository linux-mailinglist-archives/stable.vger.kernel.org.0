Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4604B175E9E
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 16:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgCBPnb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 2 Mar 2020 10:43:31 -0500
Received: from mail-oln040092071065.outbound.protection.outlook.com ([40.92.71.65]:35899
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727305AbgCBPna (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 10:43:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SFt7S5IqhRMS2BtfMLmzqQ6AdzISDqFm9cmLVm7Vw2BsO4Du5ViS2uIC9LPj9H2eCpk1M2BDDDsy3p8sOJlUzu2uopzLCi9Ccm5FDSzj1nWBvd+TuPAZmmz6oLW2Wfhbx9FgrHNcBGpkQu/wQVHd8a915OdiJbHQLl0YWVvotSiZb3tPUNB3QUd27n4+9zD8PojMvQVR5DREB9D9DVRV8rIFLXQq2MYrHhWeOUP06uObwUnwszddEYRAnuwmZX/sBA37mc2PSQfK7KHd6Ujtpn3jzdhOya7T4HwUAhx7Z0u0j5Loe1OwMscrVknTpn8nzhNm/CrquOGa0qTnFzxi5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aKll1uYXY/p4lporydDRyPbyHI3XYNaz0hS7oe1Ogas=;
 b=FsvVBSbar+IL1Rxk1F67qCrt3dvGMZ6e0kyODDP51JvdmiUd/EFDnbAovWbiqx03wB6Vjqew/cX6DJNu1XnevKaxntid6vNx/uZEgkRxCfZCzTmnGtGjArby6Td7rlQVeAetihrx8gET8lIJwXybKJ245YgXNsAPd8QyYwfZ447gZENrbKYM39FuyV1F1CuECUdgIPOCMNOrat4ZP3d9/sKOW97yCAeosCt/ts8onLtTqAbOHQOXJ+o3Unhuu5B9jDygHqrKz5R0SGhNuIWjAIMMgnyvbAHyXZ2a+6cM3q4BnsGk8idlbGNcZkLicjmfp/qvgbfws1lIOeXpW4AUbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DB5EUR03FT054.eop-EUR03.prod.protection.outlook.com
 (2a01:111:e400:7e0a::36) by
 DB5EUR03HT063.eop-EUR03.prod.protection.outlook.com (2a01:111:e400:7e0a::231)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Mon, 2 Mar
 2020 15:43:24 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.20.55) by
 DB5EUR03FT054.mail.protection.outlook.com (10.152.20.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15 via Frontend Transport; Mon, 2 Mar 2020 15:43:24 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 2 Mar 2020
 15:43:24 +0000
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0052.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Mon, 2 Mar 2020 15:43:22 +0000
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
Thread-Index: AQHV8AjGwZG4WijWc0+aQpdADP+q6qg02ufjgACXoYA=
Date:   Mon, 2 Mar 2020 15:43:24 +0000
Message-ID: <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <CAG48ez3QHVpMJ9Rb_Q4LEE6uAqQJeS1Myu82U=fgvUfoeiscgw@mail.gmail.com>
 <20200301185244.zkofjus6xtgkx4s3@wittgenstein>
 <CAG48ez3mnYc84iFCA25-rbJdSBi3jh9hkp569XZTbFc_9WYbZw@mail.gmail.com>
 <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87a74zmfc9.fsf@x220.int.ebiederm.org>
In-Reply-To: <87a74zmfc9.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZR0P278CA0052.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::21) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:C65645E00256BFF0EF483D4ABF04F7ED9CADCA7DA782503334C81EE275B55748;UpperCasedChecksum:B5B02A4BC8C9B6E7E3C31595013F4DCA6C0D23C66AB23D6F5B8892FBA4152BEE;SizeAsReceived:9189;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [dyEnYHlm0P0uZkeIkkriIIvlZ6DvQ6d1]
x-microsoft-original-message-id: <61e5cb52-cf93-3203-ad57-174abbff19af@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 293008bd-2da8-4d78-0182-08d7bec0715c
x-ms-traffictypediagnostic: DB5EUR03HT063:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8YGYe8UrOXFcm3aSssWupgEEhVcVi9JVL1E2AABGe5vjDQjaRww+7cLsEzPLfb8+6ywdEkeCyWNtByP5r9IZy43Lxrt3a+VuWVfL1b98GWRsl95OA82pgEEiMSiH7Xn4qY+h8/BAFJt/lQKR/+R2IUce2BZZCwil4w5jWmOdVe12Au0vujeQovOjjeQM6lWd
x-ms-exchange-antispam-messagedata: nGOltsXFW+coIa96+DJIrZYklzcnSMqhRstON9t0wQZXsG8UocU/d/wvILxFg70AO2koqTfnfvn73bVCRlWMZFHiFC1bEmNsKKc8Ofucn1WWhD7Vw+pNbvhxFR0QqeYZ62u+1cOuZTpNrhEp4FVvZw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <82B95786708D07499487862F589BAAC3@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 293008bd-2da8-4d78-0182-08d7bec0715c
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 15:43:24.7444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5EUR03HT063
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/2/20 7:38 AM, Eric W. Biederman wrote:
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
> I think your patch works, but I don't think to solve your case another
> mutex is necessary.  Possibly it is justified, but I hesitate to
> introduce yet another concept in the code.
> 
> Having read elsewhere in the thread that this does not solve the problem
> Oleg has mentioned I am really hesitant to add more complexity to the
> situation.
> 
> 
> For your case there is a straight forward and local workaround.
> 
> When the current task is ptracing the target task don't bother with
> cred_gaurd_mutex and ptrace_may_access in access_mm as those tests
> have already passed.  Instead just confirm the ptrace status. AKA
> the permission check in ptraces_access_vm.
> 
> I think something like this is all we need.
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index cee89229606a..b0ab98c84589 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1224,6 +1224,16 @@ struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
>  	struct mm_struct *mm;
>  	int err;
>  
> +	if (task->ptrace && (current == task->parent)) {
> +		mm = get_task_mm(task);
> +		if ((get_dumpable(mm) != SUID_DUMP_USER) &&
> +		    !ptracer_capable(task, mm->user_ns)) {
> +			mmput(mm);
> +			mm = ERR_PTR(-EACCESS);
> +		}
> +		return mm;
> +	}
> +
>  	err =  mutex_lock_killable(&task->signal->cred_guard_mutex);
>  	if (err)
>  		return ERR_PTR(err);
> 
> Does this solve your test case?
> 

I tried this with s/EACCESS/EACCES/.

The test case in this patch is not fixed, but strace does not freeze,
at least with my setup where it did freeze repeatable.  That is
obviously because it bypasses the cred_guard_mutex.  But all other
process that access this file still freeze, and cannot be
interrupted except with kill -9.

However that smells like a denial of service, that this
simple test case which can be executed by guest, creates a /proc/$pid/mem
that freezes any process, even root, when it looks at it.
I mean: "ln -s README /proc/$pid/mem" would be a nice bomb.


Bernd.
