Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60B9F17E869
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 20:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgCIT3D convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 Mar 2020 15:29:03 -0400
Received: from mail-oln040092074067.outbound.protection.outlook.com ([40.92.74.67]:51015
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726378AbgCIT3D (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 15:29:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSp/MZxz2+QoiQVZL/OLbVaZq7EIpOVSKdgsheSYZPG+FPIJQFgLxNQLUjqqQfpVluay+cagx4I6R7KcLaUe8MQSk2uFUMVnNXR72vXj6es2PYhT2Y3bExXNXihmLmVrfih9yGoIsg7Lnd04qKjJctO/ThmHz/mhp/k0P2/ycRMs7yKAPTauwURmVP4jgkXL3rhi4Up/CRL2Qcw90RAAqYY1vlyU4J1J3+gjt0rNh+19w4LytKsGPAsKWc/YepOVwT6/rk/H/nbyEw/QnrDeE5D7FuXp0fSHXSxUGPOB0rRVZWqWgqSC6nHwlI0pyRmM/ZCdlz5Vsc394a0zXWEl/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25fEhLFqCPK19uG1MGMDMSHf5O3MxrMfxThzPBvX2zA=;
 b=ed7/mypASGkgMhkvawQM+qKQf2jDXZw+v08KatFvGKf/2eGKrmScvEnTJZQRAkIyjm15ksmu1z8XnyQr3PuvG52S7Ocb6Ye9L9kl8dFsNVkF/5fZ0tEq6b3lWbHmjQmYaLma/5meM99PQQ2HKDmg+DLg9mgEh6oEIzkJVZsiLznYnE62Oq7P/QsfcYVACu0GcBmJvkfZ3SyRzxBw7Yo/KWl/rIN6b9imI+UGBx0a1m8hvMErLiOZxPRHblzWYm+GA1Stbwx+pzRX6+pCln25Nm0/WacNzvri62neC/tkrSofTg6VL6QQjgMbPENAW+xN/YO9sK3Ex+PJv/Bhun85Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HE1EUR04FT025.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0d::3a) by
 HE1EUR04HT218.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0d::128)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Mon, 9 Mar
 2020 19:28:57 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.26.60) by
 HE1EUR04FT025.mail.protection.outlook.com (10.152.27.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Mon, 9 Mar 2020 19:28:57 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 9 Mar 2020
 19:28:57 +0000
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0002.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Mon, 9 Mar 2020 19:28:54 +0000
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
Subject: Re: [PATCH v2 2/5] exec: Factor unshare_sighand out of de_thread and
 call it separately
Thread-Topic: [PATCH v2 2/5] exec: Factor unshare_sighand out of de_thread and
 call it separately
Thread-Index: AQHV9ZHwMYkHVvw7WkOaWuLYK/D8U6hApsoA
Date:   Mon, 9 Mar 2020 19:28:57 +0000
Message-ID: <AM6PR03MB5170654B139FCBDB31320481E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
 <87k13u5y26.fsf_-_@x220.int.ebiederm.org>
In-Reply-To: <87k13u5y26.fsf_-_@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZR0P278CA0002.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::12) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:771835AA78CAE5BFC139105ED5335C323419C4769AFF08F1788ABA23277AD63C;UpperCasedChecksum:9B440B72CF96ADD1588BE7715CB29C7D3398C3B8368000B6B4E6A2AAD3AF2F1C;SizeAsReceived:9923;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [1XxhMO/1r/wBolGMgXKhaxoyb6xWg5KB]
x-microsoft-original-message-id: <9c02946b-f907-2e43-eaf6-5b09600e8221@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 836277e3-0366-46ea-ec78-08d7c4601cac
x-ms-traffictypediagnostic: HE1EUR04HT218:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I78APqynq+QI/pVE5NAlb3N6ZtJUWX9IqiV3wxU+7czkTOHissLQ9eo0px0kJFyiF3IdbLSZ6p7rjAXghDxMfHt3nTVSBHnWgQUIJxgepUgSDHcSoLpghf87WObhPW6n8ZX6A/RresGFagRirOeG2h+SKmLCIV/85PpWXnCmgcJ15kajMOn4tJ5GWspVfM0s
x-ms-exchange-antispam-messagedata: 3sOZ+gQkwYYhWyLHpw7y7ceDSeK1bbnvsSVbGdSHFMpquV7mAIcfe8Ck2Qyf6bICh7jGEWGcCezK39A/dmxNDp7MKPcLvmV1E18M5TcmBe/7T+7K146mknbuOGnIIVg7k3ctUoP80vA8Bc57EdNGWQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <C207B16EE808B04FABD30CC9CD591EE3@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 836277e3-0366-46ea-ec78-08d7c4601cac
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 19:28:57.7621
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR04HT218
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/8/20 10:36 PM, Eric W. Biederman wrote:
> 
> This makes the code clearer and makes it easier to implement a mutex
> that is not taken over any locations that may block indefinitely waiting
> for userspace.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Reviewed-by: Bernd Edlinger <bernd.edlinger@hotmail.de>


Bernd.
> ---
>  fs/exec.c | 39 ++++++++++++++++++++++++++-------------
>  1 file changed, 26 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index c3f34791f2f0..ff74b9a74d34 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1194,6 +1194,23 @@ static int de_thread(struct task_struct *tsk)
>  	flush_itimer_signals();
>  #endif
>  
> +	BUG_ON(!thread_group_leader(tsk));
> +	return 0;
> +
> +killed:
> +	/* protects against exit_notify() and __exit_signal() */
> +	read_lock(&tasklist_lock);
> +	sig->group_exit_task = NULL;
> +	sig->notify_count = 0;
> +	read_unlock(&tasklist_lock);
> +	return -EAGAIN;
> +}
> +
> +
> +static int unshare_sighand(struct task_struct *me)
> +{
> +	struct sighand_struct *oldsighand = me->sighand;
> +
>  	if (refcount_read(&oldsighand->count) != 1) {
>  		struct sighand_struct *newsighand;
>  		/*
> @@ -1210,23 +1227,13 @@ static int de_thread(struct task_struct *tsk)
>  
>  		write_lock_irq(&tasklist_lock);
>  		spin_lock(&oldsighand->siglock);
> -		rcu_assign_pointer(tsk->sighand, newsighand);
> +		rcu_assign_pointer(me->sighand, newsighand);
>  		spin_unlock(&oldsighand->siglock);
>  		write_unlock_irq(&tasklist_lock);
>  
>  		__cleanup_sighand(oldsighand);
>  	}
> -
> -	BUG_ON(!thread_group_leader(tsk));
>  	return 0;
> -
> -killed:
> -	/* protects against exit_notify() and __exit_signal() */
> -	read_lock(&tasklist_lock);
> -	sig->group_exit_task = NULL;
> -	sig->notify_count = 0;
> -	read_unlock(&tasklist_lock);
> -	return -EAGAIN;
>  }
>  
>  char *__get_task_comm(char *buf, size_t buf_size, struct task_struct *tsk)
> @@ -1264,13 +1271,19 @@ int flush_old_exec(struct linux_binprm * bprm)
>  	int retval;
>  
>  	/*
> -	 * Make sure we have a private signal table and that
> -	 * we are unassociated from the previous thread group.
> +	 * Make this the only thread in the thread group.
>  	 */
>  	retval = de_thread(me);
>  	if (retval)
>  		goto out;
>  
> +	/*
> +	 * Make the signal table private.
> +	 */
> +	retval = unshare_sighand(me);
> +	if (retval)
> +		goto out;
> +
>  	/*
>  	 * Must be called _before_ exec_mmap() as bprm->mm is
>  	 * not visibile until then. This also enables the update
> 
