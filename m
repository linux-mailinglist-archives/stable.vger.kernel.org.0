Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54E017E9A6
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 21:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgCIUDu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 Mar 2020 16:03:50 -0400
Received: from mail-oln040092074088.outbound.protection.outlook.com ([40.92.74.88]:32348
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726118AbgCIUDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 16:03:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YwJRRzsPfDV6pw8niLXxxARaTQceSzf26gAUJk+Q78sCHOeQiKb9mPTblS6lLAjyAjhuCsOE52US5s8KlGozy6rNitynrMwamzYu7hE0DWbVOc1pR1OMRL/A0VRQ/yO/dTsyLdfRuniCNwDfFQJRDoUDcFdTwtCWUhdQrJJm8svKp5ktcjmcTHEXIfhbhcn7bAhbp2wsJdy90Lr7xcpCpLXgWqQxHVf8tn+FszIbobP6f8AkBTLl2eVRF58Qet/sRA7reEBPdcJQopU14yeOWxtdqw16peAkqFBXNyz6iNzktn66qqnLGL7VGY2DoCaiXTVjixogE1nROF7GeVU6vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSMJLLgDr15D4VLWggN8xRkZ4pGZITaT8VMWQQSmgvk=;
 b=P11a1awaQcx8v8tqSj4tpN/xb2Zq/j9cS2gbUD/Vmxp/qkC713N7XeCrgrkyNgcKkcBWBWaOidWl98BnrzIw5qOdhFJCsCS4fF6yQ4PI6MiUor65ji7Fcu3RLhRkavQoEO6KTt4Jx2vmL63GCapKoERe3RioVEbhGFKS+5HFxXrrcyJWAvka9eT5CMshAak82+UQOgLjltMQ+Fxj6oV3BzTP8S9+8MrVc7IN6BSbt/rXGMKmOLDBbcnlDxKtIOixoYLGHCog+cetgoDq7iO4sa2M4VUcK+dn9oS9zLburSV+4/kKoiHa9CNB2kgfM6oU/YAQ1Uh3CWaaJa4eND1+1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DB3EUR04FT034.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::39) by
 DB3EUR04HT009.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::302)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Mon, 9 Mar
 2020 20:03:46 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.55) by
 DB3EUR04FT034.mail.protection.outlook.com (10.152.24.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Mon, 9 Mar 2020 20:03:46 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 9 Mar 2020
 20:03:46 +0000
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0042.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Mon, 9 Mar 2020 20:03:44 +0000
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
Thread-Index: AQHV9ZIq8LqSeoOzkk+o9CTpCnOInKhAqHsAgAADjVGAAAFjAIAAAk+agAAAywA=
Date:   Mon, 9 Mar 2020 20:03:46 +0000
Message-ID: <AM6PR03MB5170E548767878B3E454756AE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <AM6PR03MB51709D441EE6830DC8CE3090E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87mu8pz4ex.fsf@x220.int.ebiederm.org>
In-Reply-To: <87mu8pz4ex.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZR0P278CA0042.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::11) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:ED1668ACE5B6F42E2EC0B7404924F25A11196849EC0806CBF5A7AE4B20F63F3D;UpperCasedChecksum:15FACC825918DCFFC11AB2907EBB8D4EBF54753EBDBAA58E0FAE0DD48575A447;SizeAsReceived:9985;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [jGD4KHCtwYTsvQc4p0+xqjqsU8Uw45SI]
x-microsoft-original-message-id: <587348ba-6a01-2413-9b4b-f64a1f514ea7@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: e27f1dd5-758e-4932-b244-08d7c464f9af
x-ms-traffictypediagnostic: DB3EUR04HT009:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZpR1yFOseKEmusWU5hW+o9s3YD1lY24qlFYfaX4n5cad/edVd3Jk/8j2cTT06ky0eYQppZ15v0/scxurFQlhToh9G0Qmm8yH2sI3Y77QG/V9dcmsJE6TybdsWxIH8+y60Crwti0Q1xgXYwgnuYfEhAc2uqdEqg+d6mAhDh8TGX5mg+yvrQ3GdKnp22s3ewpi
x-ms-exchange-antispam-messagedata: r+bk0gUHakTOjL4n7/G/RzRY/5nUmQupLsoUnZYPNhIIVPCfppSindQ/bjdMmmRdMtZ8iOzWSQVv6IQzclqXFpaYHpFy6GhHxJsy6dSLN8yMXzNE6hGiT4wgYRGAQWVUEFBn9zG4ZAYtiMTYiguJdA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <100A2EDE7978314BBD2FF1EBC3B5B866@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: e27f1dd5-758e-4932-b244-08d7c464f9af
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 20:03:46.4347
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT009
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/9/20 8:58 PM, Eric W. Biederman wrote:
> 
> Ok.  I think this has it sorted:
> 
>     exec: Move exec_mmap right after de_thread in flush_old_exec
>     
>     I have read through the code in exec_mmap and I do not see anything
>     that depends on sighand or the sighand lock, or on signals in anyway
>     so this should be safe.
>     
>     This rearrangement of code has two significant benefits.  It makes
>     the determination of passing the point of no return by testing bprm->mm
>     accurate.  All failures prior to that point in flush_old_exec are
>     either truly recoverable or they are fatal.
>     
>     Further this consolidates all of the possible indefinite waits for
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
> 
> I don't think I usually have this many typos.  Sigh.
> 

OK.

never mind,
Bernd.

 
