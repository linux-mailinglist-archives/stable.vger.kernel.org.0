Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC6317E1CB
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 14:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgCIN6V convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 Mar 2020 09:58:21 -0400
Received: from mail-db8eur05olkn2086.outbound.protection.outlook.com ([40.92.89.86]:52833
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726632AbgCIN6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 09:58:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNdLiRtrH5ekA27X/aoi4PoxksbtltwHlWqyD46y4ZHu3OvuFeJgAvO2f0wfcSFczty7bq90yLx6Z/QEZkq1rs67wNonBpfJnWj2sYG1YYrAsNvbnXxl7/U5zjih40hW/0bD/y7bClO4mqJ5DymGoX2aVez0KVQ2LT2E8dWto2PtBsXXqvzydjb2ZBI8RZN6ykNZIIXAMMsBS8ubTRtPzERk+EyX+aB5mBQ44IniSxINH9NqYjDb9MDYYHHOGRd7ahZf4/RLzhSiboC1Wp4pf8TJBp7g7hlzJUdcmM32DbTWXhYLqc2w6Mnvw6TTKrFgDhGAH85y0nt2eeSa70PKPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HzDi2PRRfzhlxXKQhfBmvy78dba+PGtFU/z7/fqNbQU=;
 b=G7OH7BxJQq10KiDhEcbh8xSALiTOKHDQRggzq4EEcjfrtjx60jksw5rxvanOvjyIUhO+/opzFayGiDgyCFbgYiK1HHRAFFmOka8olXUjGDgZ8EzSipFdfUj8kcn5VfYhoGd7uF/RVMH0r6TW+yuVBDVe0SpaAmGopbBSCT7YBhNqiOY73xJYsH8jw9UkS1i5xkPv2eLy2lqJ9fCCCztbGNUqSLiWOVfpMmcsVmbC5LcMwb5trE5rhdIs20Q22Wajlp1vt/fstxxnYxVZmawUTJO6UKlZ0RG5QxRljnesqbvekcpBn9pSnFvGD0tOatDkLs7TXUBRb1s86o7w24t6tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from AM6EUR05FT032.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc11::36) by
 AM6EUR05HT090.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc11::206)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Mon, 9 Mar
 2020 13:58:17 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.240.56) by
 AM6EUR05FT032.mail.protection.outlook.com (10.233.240.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Mon, 9 Mar 2020 13:58:17 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 9 Mar 2020
 13:58:17 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM3PR03CA0063.eurprd03.prod.outlook.com (2603:10a6:207:5::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17 via Frontend Transport; Mon, 9 Mar 2020 13:58:15 +0000
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
Subject: Re: [PATCH 0/5] Infrastructure to allow fixing exec deadlocks
Thread-Topic: [PATCH 0/5] Infrastructure to allow fixing exec deadlocks
Thread-Index: AQHV9ZG1D7QAmxV3AE+IpPLpt1dbHqhASmkA
Date:   Mon, 9 Mar 2020 13:58:17 +0000
Message-ID: <AM6PR03MB517071B8C4BC78358E896147E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
In-Reply-To: <87v9ne5y4y.fsf_-_@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR03CA0063.eurprd03.prod.outlook.com
 (2603:10a6:207:5::21) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:3C3993E7E100E343A0EC8C7C8C46EB5BD10BDFAD6BA3112FFE3A16AC5EC265D3;UpperCasedChecksum:BC355047DC71EA8CF61542476612D2326E4B02764677BB50BC3707FBBB744701;SizeAsReceived:9903;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [FgTnomUXHN0mDjAsUKv2sI1B6V1NrkpG]
x-microsoft-original-message-id: <601293ca-4708-c1d6-a1d6-8569a6f97d51@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: aa23393d-0faa-458f-96e1-08d7c431eac8
x-ms-traffictypediagnostic: AM6EUR05HT090:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Tu0dHfAJ+lJ+a1N0BJxBp9BKqxl3nQHYDxey+ENntAgZJ2Ry0o8UAdWh3cyyI3oMU5h6Ko9VPMLh17VqdsrgpTJAm95LAWfSqFJxVOTlJcVSg91R+Uw+iw34yuoNcgZTM2WuJzL+fjeKDFsCx3BM4f5EG/XPE9vOlK3nY/CqeuS5ZxX/kjWYmwZMoZMWlUHM
x-ms-exchange-antispam-messagedata: 12olxh/ofsbPD9E+JLgpcZSXE2Ip/uSrXpClYJjpNnlrpykN7LyafE7EOioXgegnky7WfZiNIsxp+6b/cUEuKXehIHLEGNaKAXIoQvRz5G6gcj4O2jKBT2EZVJTFT1iAl2JWKXUJX6lOwhofCrlB2g==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <ADA1125DC2E0D04195BFB312F51D304B@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: aa23393d-0faa-458f-96e1-08d7c431eac8
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 13:58:17.0818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6EUR05HT090
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/8/20 10:34 PM, Eric W. Biederman wrote:
> 
> Bernd, everyone
> 
> This is how I think the infrastructure change should look that makes way
> for fixing this issue.
> 
> - Cleanup and reorder the code so code that can potentially wait
>   indefinitely for userspace comes at the beginning for flush_old_exec.
> - Add a new mutex and take it after we have passed any potential
>   indefinite waits for userspace.
> 
> Then I think it is just going through the existing users of
> cred_guard_mutex and fixing them to use the new one.
> 
> There really aren't that many users of cred_guard_mutex so we should be
> able to get through the easy ones fairly quickly.  And anything that
> isn't easy we can wait until we have a good fix.
> 
> The users of cred_guard_mutex that I saw were:
>     fs/proc/base.c:
>        proc_pid_attr_write
>        do_io_accounting
>        proc_pid_stack
>        proc_pid_syscall
>        proc_pid_personality
>     
>     perf_event_open
>     mm_access
>     kcmp
>     pidfd_fget
>     seccomp_set_mode_filter
> 
> Bernd I think I have addressed the issues you pointed out in v1.
> Please let me know if you see anything else.
> 

Yes, looks good, except some nits.


Thanks
Bernd.
