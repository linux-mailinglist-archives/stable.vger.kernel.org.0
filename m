Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E17A017B176
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 23:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgCEWb3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 5 Mar 2020 17:31:29 -0500
Received: from mail-oln040092071062.outbound.protection.outlook.com ([40.92.71.62]:23057
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726145AbgCEWb2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 17:31:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i05PsHXzDaaLPZaeiNP1UPtpkhWg7Ui7jHpGX+u8Hgna+wHv22Z+V/bvImeAxlB2AJC1zafzYdB3bFwSTuoGYkd1aur6VEi1CF3GqwrOqxN18v7731zIXFgpwmfa7ExrzqGYnZ15en27ShZGEoOSizme4vMqyuuuRF1ocAlz2Kh8onZm5OazkfgurQp8kSoLW8cbm4kD83oXzoiEOhzp3EZmrbAZRtod7qUnJssBSphkiU0HaOCkDJuOdX/BL5YBm4LdPYR83cfToeZpFl0Z6PgbMbciB659h4j4a30Lh/ZnQ6OOcyrA8lDB04k3ajVRkN3nyGvGwvRol4PDjvFEyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tERNS1nRoeeqszGhrehZFlQTupFHHFoAbsDgGmk0LW8=;
 b=HlUxQh9duLbp19Vq+8A+lxuY1zFwaMMCgbUbqGmCIAa/m0ny6uhszCeJir3fHmXCMWnQyEnOB7Zzg/z5GWbAEN7z9ocPF5HzytuXZ3pd4oNWqiGElZoxBddDrntdZsQ7HZ4Lz03NRx4t12LbJuI089ybMrEe8+whAkkm+MGW5XcsIOTbU1PhlOmzFS6Cp45Xx2hsv82WWDW6NTk00H5Ll3QIpDfu5f4MwqIOFbJG0gCvYKrkgMTojyVH2ac85BjL4Q09sGoatyUgaoQHJGeiXtZCyO76UMjOV+uylgjPef6++rk3jK1Dq1vEHvDEhNoVAXsGTXndU1IPcndi5k0M7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DB5EUR03FT051.eop-EUR03.prod.protection.outlook.com
 (2a01:111:e400:7e0a::3b) by
 DB5EUR03HT230.eop-EUR03.prod.protection.outlook.com (2a01:111:e400:7e0a::405)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Thu, 5 Mar
 2020 22:31:24 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.20.54) by
 DB5EUR03FT051.mail.protection.outlook.com (10.152.21.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Thu, 5 Mar 2020 22:31:24 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 22:31:24 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM0PR10CA0045.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.18 via Frontend Transport; Thu, 5 Mar 2020 22:31:23 +0000
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
Subject: Re: [PATCH 0/2] Infrastructure to allow fixing exec deadlocks
Thread-Topic: [PATCH 0/2] Infrastructure to allow fixing exec deadlocks
Thread-Index: AQHV8zN0+y+7rcOm+0SK7R12bY9kbKg6lTCA
Date:   Thu, 5 Mar 2020 22:31:24 +0000
Message-ID: <AM6PR03MB5170C0E85446CAE39F642F5BE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <AM6PR03MB5170EB4427BF5C67EE98FF09E4E60@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org>
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
In-Reply-To: <87tv32cxmf.fsf_-_@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR10CA0045.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::25) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:80363A9AE7FEBD14D8F2CA5182A7E45186ACD7E78428499C1612A2F4266C658E;UpperCasedChecksum:4DF2139BB28663D1442BCEDFFDC6FEF4DA3A36B4EF3C7D48F12967A7E09685DC;SizeAsReceived:9909;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [dG7ZO4ZvDJi964B/5vyqIybXev+9vMyU]
x-microsoft-original-message-id: <d2e6c6fe-84bb-fb03-66ed-d74b343127ae@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: ec9180b2-cea6-40ca-c84c-08d7c154efbd
x-ms-traffictypediagnostic: DB5EUR03HT230:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0PGviBifKiBhavnvbHTtW44bEmZdNi90nA2SE+Q7CK4TgRpaWEZemzuJWsMt6mi76ig5Z1H2GFF2iDB1wJLp7CYS0WDYclz3coLbrTLoOKUZwiO9R3UQUifLFyRBxWSvwYFLX8CKIyBuRq2yAHj8PJn4fRoBgccsfZ26yTkZqhFaYzBddIC/uYHTeM2twSGP
x-ms-exchange-antispam-messagedata: NKzMMBUPbZEPx+6fuUYt+RW+WDaMGedFMA4t1xeup20oT1kwgE8ziSdwqXQGw66w/1gK+7aUm7SqR4nJzIz/X5NajFfwASlAf56726ov8qZMFzvFGOinPOehkxqrVcUSGH8Y49BEVbX5IgXu7yV57A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <B8AAFBB85A48F342B9AFF7BCC8A90AFC@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: ec9180b2-cea6-40ca-c84c-08d7c154efbd
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 22:31:24.3228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5EUR03HT230
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/5/20 10:14 PM, Eric W. Biederman wrote:
> 
> Bernd, everyone
> 
> This is how I think the infrastructure change should look that makes way
> for fixing this issue.
> 
> - Correct the point of no return.
> - Add a new mutex to replace cred_guard_mutex
> 
> Then I think it is just going through the existing
> users of cred_guard_mutex and fixing them to use the new one.
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
> Bernd does this make sense to you?  
> 
> I think we can fix the seccomp/no_new_privs issue with some careful
> refactoring.  We can probably do the same for ptrace but that appears
> to need a little lsm bug fixing.
> 

Yes, for most functions the proposed "exec_update_mutex" is fine,
but we will need a longer-time block for ptrace_attach, seccomp_set_mode_filter
and proc_pid_attr_write need to be blocked for the whole exec duration so
they need a second "mutex", with deadlock-detection as in my previous patch,
if I see that right.

Unfortunately only one of the two test cases can be fixed without the
second mutex, of course the mm_access is what cause the practical problem.

Currently for the unlimited user space delay, I have only the case of
a ptraced sibling thread on my radar, de_thread waits for the parent
to call wait in this case, that can literally take forever.
But I know that also PTRACE_CONT may be needed after a PTRACE_EVENT_EXIT.

Can you explain what else in the user space can go wrong to make an
unlimited delay in the execve?


Bernd.
