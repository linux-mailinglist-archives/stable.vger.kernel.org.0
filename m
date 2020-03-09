Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E57C17E88D
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 20:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgCITfF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 Mar 2020 15:35:05 -0400
Received: from mail-oln040092068083.outbound.protection.outlook.com ([40.92.68.83]:54531
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725992AbgCITfF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 15:35:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3rQAArBPqovEB66sv7k0plhWBS1hQDLOp3nCvw3dSoVEMx+FZgpqxW3wsI0zxQrgPv/IOzSWmRFxslxhUS+nCYY4ro/E5kdq6kI/s4QfdeJzyATkCt8BQYd6KZeNBa9xtO7Gqce5qNEXRDT6PItgUDOMKY3bJY6d+CHs63P2qE6TcUj4KV0zzE3fv+L49SPeJk7xOVFrWTHwqlMmQTK+6lUcjuiLrGuI8mXtH6pc8FXmvfxRdJ3lI+Sex6J5j707Np5NbA5xOxRhzarSBfHSAHV80IuzW9jI0A+YHqgHG5btU7MwHG9+5qVZBfH8oAr3MJf0XUMF20oxUiXJBuQ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TNF+ypRjnXNodGw7+eEn6FxwMgQlbpZjkBUCLzykMlY=;
 b=IUBTPXhnmfRoEopqrb2jp8hZjUE9JzRHXzOJg7VTN+e26Ftvda3vHP4ypYLiTj1qcsB9ztB0r/OD37wnAJva9Ovs8EbqtJLLwQMOOlG+1EN1XsGSCN41qWt2yI21dsYrAOOs9cBt0YGEp1o8h28aKMoQCMhPTxuqAYJ9ST3bBvuzpp7RWSaYvaw1hePOhktRrp41nU1D+kUwLpHtEsyOCyDG9V1FQcKBENZd8Q+aKbvf7Wq9SfHJTYwQEqU2sYnRQs4U3+Vq4Ubprd6OKU2xDdo9gA9SLJgGxH162eVC8hb7jfGyp41agcc7bedgSTEKFe8g0/7ifSa28BLJVdsfJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from VE1EUR02FT019.eop-EUR02.prod.protection.outlook.com
 (2a01:111:e400:7e1e::35) by
 VE1EUR02HT202.eop-EUR02.prod.protection.outlook.com (2a01:111:e400:7e1e::342)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Mon, 9 Mar
 2020 19:34:59 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.12.60) by
 VE1EUR02FT019.mail.protection.outlook.com (10.152.12.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Mon, 9 Mar 2020 19:34:59 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 9 Mar 2020
 19:34:59 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM0PR06CA0072.eurprd06.prod.outlook.com (2603:10a6:208:aa::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Mon, 9 Mar 2020 19:34:58 +0000
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
Thread-Index: AQHV9ZIq8LqSeoOzkk+o9CTpCnOInKhAqHsA
Date:   Mon, 9 Mar 2020 19:34:59 +0000
Message-ID: <AM6PR03MB5170C3A4319BA6A057C3CCACE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <875zfe5xzb.fsf_-_@x220.int.ebiederm.org>
In-Reply-To: <875zfe5xzb.fsf_-_@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR06CA0072.eurprd06.prod.outlook.com
 (2603:10a6:208:aa::49) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:79C496411C7C971373B50F97092B52D602659E5707CEC701B2124EABB1337BFE;UpperCasedChecksum:67F7095DB63B9127FCCACBBA6A9CA42499F1591C5E46C3069ADC0B8C0E291EE4;SizeAsReceived:9883;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [L/99uBRPV/LyRVM1VSZjAibKvfuULYqn]
x-microsoft-original-message-id: <4ec7b6c3-da81-bbcd-214f-d12978145288@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 159ed0df-750b-4023-81ac-08d7c460f435
x-ms-traffictypediagnostic: VE1EUR02HT202:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hdZNzwc6pLT+2ViQ6odqvXNOXUghN906xwKz7gKotZHXwtZ84GBG37ZaQ5MfMRMFX0Bp1hipJLqjJ5vayQGpYGd3co0jNqtL35Ee9UUptvl8j3aws7GjxqJu2rA9COHOUD4HIVWIjmXe6ZCi2MVuGDoLxYMs9Vnfh5uuP0++vgvematv3RWW9vMxUlEEsL1B
x-ms-exchange-antispam-messagedata: z84Cpt8/RbEwCJyUJXIKMHrcP50YynlkojBX/rYwVXrlVV7nyCVK+CVnt9b8d+gl19kcMEHMZe/SzH3YeFY7vj4hApKiOoDWjozs3rQJEIy/lYfbXHWd8BPpPUDAhvKhVC1q9NrWzfsCYWqqLePjdQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <9E086A324F4FE14290E8EA9DD6C880C2@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 159ed0df-750b-4023-81ac-08d7c460f435
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 19:34:59.2994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1EUR02HT202
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/8/20 10:38 PM, Eric W. Biederman wrote:
> 
> I have read through the code in exec_mmap and I do not see anything
> that depends on sighand or the sighand lock, or on signals in anyway
> so this should be safe.
> 
> This rearrangement of code has two siginficant benefits.  It makes
                                        ^ typo: significant

> the determination of passing the point of no return by testing bprm->mm
> accurate.  All failures prior to that point in flush_old_exec are
> either truly recoverable or they are fatal.
> 
> Futher this consolidates all of the possible indefinite waits for   ^ typo: Further

> userspace together at the top of flush_old_exec.  The possible wait
> for a ptracer on PTRACE_EVENT_EXIT, the possible wait for a page fault
> to be resolved in clear_child_tid, and the possible wait for a page
> fault in exit_robust_list.
> 
> This consolidation allows the creation of a mutex to replace
> cred_guard_mutex that is not held of possible indefinite userspace

can you also reword this "held of" thing here as well?


Thanks
Bernd.
