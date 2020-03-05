Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30DF817B1F3
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 23:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgCEW4H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 5 Mar 2020 17:56:07 -0500
Received: from mail-vi1eur05olkn2104.outbound.protection.outlook.com ([40.92.90.104]:45153
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726128AbgCEW4H (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 17:56:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U6A4qZbNCfGWsXeIvdr6kqJ/amkE8yIxfPp3e2pQ9jrWrDXGD5SLIa9j0eh4tvKHLu8YZb+elX5+wPMD5IsFZuky3cVz0ZZfgh0THuB5S/uIH+HVcVvfzzRrav232g1fI8F7H5EgSXyjZ7v0/Ib7eSYFCrl3G82Uezl661X42JrCF9o0LS3f2E8+2xoGsltT9SnQIHGPAmKLaG9O4caS2bskoBQ+a1adORZpDIkK2Olmeb1Td2PqgZSsCJC8yiy3fQaBCPjgjuhyKK0Canhqw8gF2ZrD+oqavYJpm1BBRZUgqsfUi6c+6cZ/qs1gW+Om7ojr6FZA5yahbShqvC2ENQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KDdC9hvKRliCZOl6sjx6IJBf9FDU4elCX2xh61mM2Vk=;
 b=L459/foOwKYign+QhAvjUFqlnJ8D6ng4ORV7GqRO3T3Cy2vNwQzs14fZeVl6CZ868B3NGhiTNxsIBfCnJVO2mfCojlue7FMN2gvCUVSg9avuFzDb3GRGFQwn2ITJMa/R30AZLPp/OMMBMsvOzj276OX3tmBTXn5meqJMK01I09FRVgMZMi3g341etIn5jghAEbbFpe9IxidDELm3lXjrZVCnjliNVlmiNoXKEmUyFykTVNpSu+MmN48GS0nxzp+ICH+vGThai8LOyb+LfZZ1BAE1KCfriAe/87UupRyTh3HskvSJ8P1Z2oiYwF0dQ3b56ewzq/X2/xhOi2Bua4iR+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from AM6EUR05FT004.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc11::39) by
 AM6EUR05HT175.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc11::267)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Thu, 5 Mar
 2020 22:56:01 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.240.53) by
 AM6EUR05FT004.mail.protection.outlook.com (10.233.240.227) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Thu, 5 Mar 2020 22:56:01 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 22:56:01 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM0PR05CA0063.eurprd05.prod.outlook.com (2603:10a6:208:be::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Thu, 5 Mar 2020 22:56:00 +0000
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
Subject: Re: [PATCH 1/2] exec: Properly mark the point of no return
Thread-Topic: [PATCH 1/2] exec: Properly mark the point of no return
Thread-Index: AQHV8zOIDtdt4OHpy0WII6Z+9AZegqg6nBAA
Date:   Thu, 5 Mar 2020 22:56:01 +0000
Message-ID: <AM6PR03MB5170B05CFDAF21D8A99B7E48E4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <AM6PR03MB517053AED7DC89F7C0704B7DE4E50@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <AM6PR03MB51703B44170EAB4626C9B2CAE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
 <87o8tacxl3.fsf_-_@x220.int.ebiederm.org>
In-Reply-To: <87o8tacxl3.fsf_-_@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR05CA0063.eurprd05.prod.outlook.com
 (2603:10a6:208:be::40) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:272380709DEB80306E9009F61E2997677429D2C3BDF0FBC3F0F15DDDC349B10F;UpperCasedChecksum:21F0A5716B0852942E038A9075DF8A415A4691F0A163A0DD201B056A0DF548A6;SizeAsReceived:9890;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [izdHMbh3bnDYSfTpdS4ROrLapHN4x4DX]
x-microsoft-original-message-id: <d4003229-394f-e962-109c-875fbdd1198e@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 11b256b2-15fb-4537-cef8-08d7c158604b
x-ms-traffictypediagnostic: AM6EUR05HT175:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0hjSR8sFoP5pZfY+2ji5Jjh2SJ5FnTvekp7+oWOwi4CDGhi8CryMEW/7/hNAwR6I85x1Xj2/KfPJb/moNfZYh4vzurGzhyYqSfE2rTb1IYqqUSRYIIujq7CiTvJavuJRvEgMn1O91dXTDtuVUWSw4VZb+0etlV+bZwWQR+V5UxVN2SOPH/gQFX/RGVyw3p5l
x-ms-exchange-antispam-messagedata: 3ENPk+OnLtZ3ZFws88q3ivvo8YLOSnhbyGhaUDLajUerqrTkxEHXStoKK9P3fZ+W7UaHkq/2qrGZfxF9FqXJ+0bHEF/9RLX/0xYz/cO/KHe31mtPREQ29BoL6HkY4g0GyjBqrrUzxB1CB8DVN71OxQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <0B2ECCD68E9FD54C97C2891C56840623@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b256b2-15fb-4537-cef8-08d7c158604b
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 22:56:01.7235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6EUR05HT175
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/5/20 10:15 PM, Eric W. Biederman wrote:
> 
> Add a flag binfmt->unrecoverable to mark when execution has gotten to
> the point where it is impossible to return to userspace with the
> calling process unchanged.
> 
> While techinically this state starts as soon as de_thread starts
> killing threads, the only return path at that point is if there is a
> fatal signal pending.  I have choosen instead to set unrecoverable
> when the killing stops, and there are possibilities of failures other
> than fatal signals.  In particular it is possible for the allocation
> of a new sighand structure to fail.
> 
> Setting unrecoverable at this point has the benefit that other actions
> can be taken after the other threads are all dead, and the
> unrecoverable flag can double as a flag that those actions have been
> taken.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/exec.c               | 7 ++++---
>  include/linux/binfmts.h | 7 ++++++-
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index db17be51b112..c243f9660d46 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1061,7 +1061,7 @@ static int exec_mmap(struct mm_struct *mm)
>   * disturbing other processes.  (Other processes might share the signal
>   * table via the CLONE_SIGHAND option to clone().)
>   */
> -static int de_thread(struct task_struct *tsk)
> +static int de_thread(struct linux_binprm *bprm, struct task_struct *tsk)
>  {
>  	struct signal_struct *sig = tsk->signal;
>  	struct sighand_struct *oldsighand = tsk->sighand;
> @@ -1182,6 +1182,7 @@ static int de_thread(struct task_struct *tsk)
>  		release_task(leader);
>  	}
>  
> +	bprm->unrecoverable = true;
>  	sig->group_exit_task = NULL;
>  	sig->notify_count = 0;
>  

ah, sorry, 
        if (thread_group_empty(tsk))
                goto no_thread_group;
will skip this:

        sig->group_exit_task = NULL;
        sig->notify_count = 0;

no_thread_group:
        /* we have changed execution domain */
        tsk->exit_signal = SIGCHLD;

so I think the bprm->unrecoverable = true; should be here?


Bernd.
> @@ -1266,7 +1267,7 @@ int flush_old_exec(struct linux_binprm * bprm)
>  	 * Make sure we have a private signal table and that
>  	 * we are unassociated from the previous thread group.
>  	 */
> -	retval = de_thread(current);
> +	retval = de_thread(bprm, current);
>  	if (retval)
>  		goto out;
>  
> @@ -1664,7 +1665,7 @@ int search_binary_handler(struct linux_binprm *bprm)
>  
>  		read_lock(&binfmt_lock);
>  		put_binfmt(fmt);
> -		if (retval < 0 && !bprm->mm) {
> +		if (retval < 0 && bprm->unrecoverable) {
>  			/* we got to flush_old_exec() and failed after it */
>  			read_unlock(&binfmt_lock);
>  			force_sigsegv(SIGSEGV);
> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> index b40fc633f3be..12263115ce7a 100644
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -44,7 +44,12 @@ struct linux_binprm {
>  		 * exec has happened. Used to sanitize execution environment
>  		 * and to set AT_SECURE auxv for glibc.
>  		 */
> -		secureexec:1;
> +		secureexec:1,
> +		/*
> +		 * Set when changes have been made that prevent returning
> +		 * to userspace.
> +		 */
> +		unrecoverable:1;
>  #ifdef __alpha__
>  	unsigned int taso:1;
>  #endif
> 
