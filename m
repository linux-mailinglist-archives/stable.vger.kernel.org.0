Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9829917E946
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 20:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726266AbgCITwo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 Mar 2020 15:52:44 -0400
Received: from mail-vi1eur05olkn2104.outbound.protection.outlook.com ([40.92.90.104]:7584
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725992AbgCITwn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 15:52:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LR5UP4nTXlbz2VSPanyoMb4DvKn1Zoud47dOxIaTPqOmya0bjr/Q7M0UmZ3duUxb7iIiJ752I8jrw3FT9bM7mbFRjXEvNWidhhf6CbC4OdTfsGVE5WCWUvrTPzx6YVZ2H7XJH8hw7yIzb/AsH/MDl3a9SPwLVfklYkwBNNFBlfINBDQ5JJhGZMEP66B5QPEvJ9pg7NmhL2fdIgvrta6oEkuFvdleekdsCMoIGhQHRGoqqA7uaNZimXeVnO85kfaK7Ls/dzB+uSsD5M5dcgAsRNIvvz8zn1JkWNivg8l/dlxmdTPgCOMa47hV50Vq5E79nS1a0Vw1VlsUs9vgvbJAPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=us7arMLgUlBinqeZu1Mkp+JM24VyW/yqREJVsjdZp6Q=;
 b=HISgO7i7QNl/28ZDpwnSD97ugP9S+2K0ywa/zRvyRPExtckec02LRwxwv2GE2m5ueG4tU28fYA4heLDKAdl5/aocPkjiJyyVsdx//zHueICENyl42lb3sKhYsMLiTpQ4+Y25yiakqZFs83mvmFpk9gxuV12uc+WeZ6iuLmCb/QGS2VkrtfS6y9LeuLRasKapyHKHNEbiDBsiWgxN0cEiAikLI/ivy8KZNuU+ewhP7s4l5wfB4J237zonZCFzj4TZr0eB8E8cKkVDJ6iFIoIQgYBga3hin6kFzUG967cCUPCFCIKgiJaZSiv9wwa2bbxfzK3+bGcVUPWG74dBtY+GWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DB8EUR05FT061.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc0f::37) by
 DB8EUR05HT254.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc0f::480)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Mon, 9 Mar
 2020 19:52:38 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.238.56) by
 DB8EUR05FT061.mail.protection.outlook.com (10.233.238.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Mon, 9 Mar 2020 19:52:38 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 9 Mar 2020
 19:52:38 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM0PR06CA0073.eurprd06.prod.outlook.com (2603:10a6:208:fa::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Mon, 9 Mar 2020 19:52:37 +0000
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
Subject: Re: [PATCH v2 4/5] exec: Move exec_mmap right after de_thread in
 flush_old_exec
Thread-Topic: [PATCH v2 4/5] exec: Move exec_mmap right after de_thread in
 flush_old_exec
Thread-Index: AQHV9ZIq8LqSeoOzkk+o9CTpCnOInKhAqHsAgAADjVGAAAFjAA==
Date:   Mon, 9 Mar 2020 19:52:38 +0000
Message-ID: <AM6PR03MB51709D441EE6830DC8CE3090E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <875zfe5xzb.fsf_-_@x220.int.ebiederm.org>
 <AM6PR03MB5170C3A4319BA6A057C3CCACE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87tv2xz510.fsf@x220.int.ebiederm.org>
In-Reply-To: <87tv2xz510.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0073.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::14) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:E052DB8E0D4BE9F52D3BB250C54FCE66C8E08203BC122772396A1B3B47280602;UpperCasedChecksum:D2B8584132588694E957B129C60342ECF08B154AE93F08996C18C724C5FD4F63;SizeAsReceived:9906;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [gg8QiKW80X8x8ER3daN6HWEBHHRMradi]
x-microsoft-original-message-id: <bd039513-aafc-8200-d63c-e4d345c35c21@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 6e585488-bf69-4a39-5fc5-08d7c4636b81
x-ms-traffictypediagnostic: DB8EUR05HT254:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6QJ1WYrUSrzeSIAWhwAyprirzoT32kImPYMAY4VcRk/gMufeUzP38OS8sB6tdYzIP0Vd9PdZx+HIAmEvqO3Wl+d5tadaQfufGZQ/qT2Ulyop8XKQzmpkuZtpstmzlcwyQiHCpQ1Db3hSO99znan8QWpT+EEv51ww56Bf00vCAlfyVkc3CCmcOZ5um5PtVQnC
x-ms-exchange-antispam-messagedata: Su4XjFp3ZwTE/nkD8ppkkZwR3LyyEtggQmpSHLQVK3qnGjUZ1inFOMYGLWZxZ2cUK/joDA9TWF+yHb2TQgFQZlksSqBtLNGZ4eadbSEm6cuci6FQqO9QlzbMMBowfGCGM7uQwLG36QbPG0atzhVLUw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <3D428C8F34AC3245A2ECA39F23444B91@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e585488-bf69-4a39-5fc5-08d7c4636b81
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 19:52:38.3929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8EUR05HT254
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/9/20 8:45 PM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> On 3/8/20 10:38 PM, Eric W. Biederman wrote:
>>>
>>> This consolidation allows the creation of a mutex to replace
>>> cred_guard_mutex that is not held of possible indefinite userspace
>>
>> can you also reword this "held of" thing here as well?
> 
> Done:
> 
>     exec: Move exec_mmap right after de_thread in flush_old_exec
>     
>     I have read through the code in exec_mmap and I do not see anything
>     that depends on sighand or the sighand lock, or on signals in anyway
>     so this should be safe.
>     
>     This rearrangement of code has two siginficant benefits.  It makes

watch out: sig_i_nificant

>     the determination of passing the point of no return by testing bprm->mm
>     accurate.  All failures prior to that point in flush_old_exec are
>     either truly recoverable or they are fatal.
>     
>     Futher this consolidates all of the possible indefinite waits for

Add some r to "Futher", please?

>     userspace together at the top of flush_old_exec.  The possible wait
>     for a ptracer on PTRACE_EVENT_EXIT, the possible wait for a page fault
>     to be resolved in clear_child_tid, and the possible wait for a page
>     fault in exit_robust_list.
>     
>     This consolidation allows the creation of a mutex to replace
>     cred_guard_mutex that is not held over possible indefinite userspace
>     waits.  Which will allow removing deadlock scenarios from the kernel.
>     
>     Reviewed-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
>     Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Eric
> 
