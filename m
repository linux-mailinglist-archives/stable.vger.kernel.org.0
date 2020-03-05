Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B488417B187
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 23:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgCEWeN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 5 Mar 2020 17:34:13 -0500
Received: from mail-oln040092070073.outbound.protection.outlook.com ([40.92.70.73]:56324
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726080AbgCEWeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 17:34:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VGpbywGoFzHzbs9ir1+VRFeIy5+DAa/OpVMljU2ag48FVLN5jUEwkQXSkR5dsugU0Z2AUw1HSqqf4++sL0a/HUppwTPHk0kp5n9urYiA2fwBpA8G6AcPi9rCPICyBrxPS0Z76POTu+hyO9jTTg65WJGgMpi16ft2A/LgGw5wnMvMEi1EC2QaglAm0eXwFdm5YhzkVvbFGg4xn/R6B2TlFxXiwhgVR6sus4/ewWbQ7Oi2OKRRjbF+CkFX0IeyYgE8uzFok8vWTXmuoyreDDzt7Twtn/cHDOjAkskxhvS/ZAgofVrgvuhZKr+s++5wWXPmFqx4cLzvqwpLu7irsCwIgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mAbBUDDRbDZ4qsQaox7Pp4Gerv8/WBoPaST2I4kuh1k=;
 b=c+X4d2Rhf4I7sO+RcpkKMVfMgTKTBOzjbpuoijcX5hW0K+UMWEW6repXj4n5cIjAO1Ag/K2QbjPVDjhwYoCAPA9rhk3dnQ+5hNHNShMvKhCqW7P6G95xg7J6t7nF3UrzibItNpRlDm3NZE8n3MpSE3ZR8XcDqskUkReUOJV01OVnvcx/B8QyG0Tgc35X47PYRHbMGq6NJOYDrQuxVx6SAT+IyI5L3WpbWzMmgnaA8JiDUglAw2pVn5UahIoRWdMMh6Pjed/7aaFGjGPTSDzoclKr/4z8wb0CiSv9L537IHoowGMroZI4vcSFq72bvMrAqSX+anlk9sNG01i5mMjSjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DB5EUR03FT051.eop-EUR03.prod.protection.outlook.com
 (2a01:111:e400:7e0a::37) by
 DB5EUR03HT082.eop-EUR03.prod.protection.outlook.com (2a01:111:e400:7e0a::280)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Thu, 5 Mar
 2020 22:34:07 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.20.54) by
 DB5EUR03FT051.mail.protection.outlook.com (10.152.21.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Thu, 5 Mar 2020 22:34:07 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 22:34:07 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM0PR10CA0009.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11 via Frontend Transport; Thu, 5 Mar 2020 22:34:06 +0000
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
Thread-Index: AQHV8zOIDtdt4OHpy0WII6Z+9AZegqg6lfOA
Date:   Thu, 5 Mar 2020 22:34:07 +0000
Message-ID: <AM6PR03MB51705EB9A5E911295BDF8D2FE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
x-clientproxiedby: AM0PR10CA0009.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::19) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:3A2024B693D837F0DDF00450EF97460F989C55BC560D36A82223C7327DE4B9DF;UpperCasedChecksum:30E2E8EDDCEECF202DC6196C1344B6BCE54C72E512381711DBCACEA067A57BFD;SizeAsReceived:9889;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [7ThvNKeMPS8rFbz+ZGcilnCRipef2B6V]
x-microsoft-original-message-id: <0fd70238-96ea-8ca3-9120-d7ac3b285243@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: df93928b-fec8-411e-cfbb-08d7c1555131
x-ms-traffictypediagnostic: DB5EUR03HT082:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a9XiLOCdhT6SQA6ZLHosYGHi2LnNRNkBugxh2IuKma7oDsfjSzOJg6+pqOnDqCZxuyHFGoxQYUwu0pnT7ptjgU7ausYKaFkemsjRWQJuyM6i8QOm0Xj6DfQAMWuFcwu1MmEyPetVcHsgqG6ECoYB08tJ4QsWRtPK+MPvX1umuPNe0kSRGyfPTxV7fPm5IYYE
x-ms-exchange-antispam-messagedata: JHs6ZHbAidGAz7xCkoReUz1nz7fEBTKGiUdci1D6atfPaqkVbNvAqYvPhJaqkG6JunshcWs5RbB+MFyT8kTnhyD7ju+6b3sQAdXePqT55IJGCyo4SYFBVZHME0jcVkx2MmJ26xqlKReHCSlWJ2mJpw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <9939E79739A7134CBF5C66C88E3959AD@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: df93928b-fec8-411e-cfbb-08d7c1555131
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 22:34:07.8152
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5EUR03HT082
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
> @@ -1266,7 +1267,7 @@ int flush_old_exec(struct linux_binprm * bprm)
>  	 * Make sure we have a private signal table and that
>  	 * we are unassociated from the previous thread group.
>  	 */
> -	retval = de_thread(current);
> +	retval = de_thread(bprm, current);

can we get rid of passing current as parameter here?

Thanks
Bernd.

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
