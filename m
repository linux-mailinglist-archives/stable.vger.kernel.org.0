Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03C4517E876
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 20:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725956AbgCITa6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 Mar 2020 15:30:58 -0400
Received: from mail-oln040092073073.outbound.protection.outlook.com ([40.92.73.73]:43971
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726106AbgCITa5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 15:30:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQS9JVkpHcFeZxqgH/0JGbj5Cds27H8qPYwSn1Tl1ZxWhWOyD2xr7uNRDfarncOaQc9JL1lrPyvpwpdiT9GvufZHIXYQoEpK8JQ/0UGQJDQI6rJc5X9Pw7DiwFCp275Ax+UpEbalu1I0SzrdLGPwJGiAMks7kWxuMhQpnVm9lXcAfUu6Z+Vze7XkFgZZRFxpoYTFD9ySodW+0tK3u+LhRP4jHhgOGQoQ7h+ol/3M9JO9NZeyPOKUKLuxPYgCg8RbkfYtgBhTgvfWfH0rpqUQBA7R8mcZz+YGWSsjSOgP8Au3BNyQMMl077GdZ3C9gSMZ9N/shlNBXoh2HjQTaZ6Sqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxx6MlQD/1BAFg8WI2pnsDjsoz3s+EOs2w5Pc/bBL/4=;
 b=gdqKrYKZ9HZWUqGjiVoL5N87BcFyZurhBCVcW7VQLqJ2Yaft2N4ZE8+3cCTPZJVWDltR2XCYgUYSxEIve/I+CYqWX3f7msLefXNjPcKxFFbnf1GwCjom2MSoSZiODMXPtCiRHc/kdUNrqVXnFytCkxHjG9RyBUqKVkzAEJPHkFGomWbHdGeuIC0F+GXeUrMaxPjmgungJ9JO4+XwAH4q7kPVReaCY7Ew6j8V80Df00JiF2s+kOxg2a1za9tKrrZQ+NfkG3u+KEIK3QMaGopdmWtnaziNKRuMbx9RtRJuURihdzKaRb3srDfojs0ystLcjYaEG//V8m0/ik8b29TzLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HE1EUR04FT025.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0d::33) by
 HE1EUR04HT222.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0d::105)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Mon, 9 Mar
 2020 19:30:13 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.26.60) by
 HE1EUR04FT025.mail.protection.outlook.com (10.152.27.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Mon, 9 Mar 2020 19:30:13 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 9 Mar 2020
 19:30:13 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM0PR01CA0025.eurprd01.prod.exchangelabs.com (2603:10a6:208:69::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Mon, 9 Mar 2020 19:30:07 +0000
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
Subject: Re: [PATCH v2 3/5] exec: Move cleanup of posix timers on exec out of
 de_thread
Thread-Topic: [PATCH v2 3/5] exec: Move cleanup of posix timers on exec out of
 de_thread
Thread-Index: AQHV9ZIEZxv0OjAlrUW8EbkPvU5OCqhApyIA
Date:   Mon, 9 Mar 2020 19:30:13 +0000
Message-ID: <AM6PR03MB5170B4D58F3FA5D33FE7657AE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <87eeu25y14.fsf_-_@x220.int.ebiederm.org>
In-Reply-To: <87eeu25y14.fsf_-_@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR01CA0025.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:69::38) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:1D11F3C52AA20EBC430DB346C09A4699A65F93F93FDB2F1ABAF13885F9D9B20A;UpperCasedChecksum:F65111DBCA5A0AC806A7EA7BA1E0E4446D647E0342302557EC34E3FF14B48D07;SizeAsReceived:9916;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [OcD0NgGcG0JZG4F3xK7jxWsbdT9smler]
x-microsoft-original-message-id: <49c40113-05fa-e31d-478a-d01915ed0059@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: d7a4e64a-a427-4c0e-b75b-08d7c4604967
x-ms-traffictypediagnostic: HE1EUR04HT222:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sNkwfI6O9nw/LbblTEqNANU0FcxXdbSkAk5YU+vMggTkwlweJGhwZuLThErFUiRkCtAyW+7xoxZAPX5JRxdR1b56GRqLIhB979M4xDYKdOEqJvBN7tCzaV9jVpEF0Z2laBH/nECodfbIvF69rmQJtsrnW3B3IovHZsAqIxayr9xQ/uen3I3y6Dc73o/rsdk5
x-ms-exchange-antispam-messagedata: vwHuoFtHtZ6FSlkk/P+IIWY5p10IbcCxjKqwOho3gWhDGBLd6Ucr1iC3EMUbdtgN2mhPOAmzdno8TicB5PfqWRF/DsPrOqoMf5zHy3rh/no/ppzQCjMfzjK5je2i2ca/SgVJSWHDHKOioh4pPaS2JQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <3386F6868CEAF14D9BF18D15F4701AD9@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: d7a4e64a-a427-4c0e-b75b-08d7c4604967
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 19:30:13.2687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR04HT222
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/8/20 10:36 PM, Eric W. Biederman wrote:
> 
> These functions have very little to do with de_thread move them out
> of de_thread an into flush_old_exec proper so it can be more clearly
> seen what flush_old_exec is doing.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Reviewed-by: Bernd Edlinger <bernd.edlinger@hotmail.de>


Bernd.
> ---
>  fs/exec.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index ff74b9a74d34..215d86f77b63 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1189,11 +1189,6 @@ static int de_thread(struct task_struct *tsk)
>  	/* we have changed execution domain */
>  	tsk->exit_signal = SIGCHLD;
>  
> -#ifdef CONFIG_POSIX_TIMERS
> -	exit_itimers(sig);
> -	flush_itimer_signals();
> -#endif
> -
>  	BUG_ON(!thread_group_leader(tsk));
>  	return 0;
>  
> @@ -1277,6 +1272,11 @@ int flush_old_exec(struct linux_binprm * bprm)
>  	if (retval)
>  		goto out;
>  
> +#ifdef CONFIG_POSIX_TIMERS
> +	exit_itimers(me->signal);
> +	flush_itimer_signals();
> +#endif
> +
>  	/*
>  	 * Make the signal table private.
>  	 */
> 
