Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7D7F17E19A
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 14:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCINp6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 Mar 2020 09:45:58 -0400
Received: from mail-oln040092069109.outbound.protection.outlook.com ([40.92.69.109]:15648
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726720AbgCINp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 09:45:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T9IScGzvU8L67rmtAj/zc/nOJEnDxtAYddUn8VD0DZnhAkwtq6CsZzABhwFPbRV8G8sAHC8ElrTO6Y2nYaTIKmyxzb/AqCs1HVEoxTlmGqmo/SZw7LBVjrrzqAYyhghQ/kbI2AD6KEKIc/mWXhv876FLtxpnBtqjrxJW2Pnmyn7X9yDVjwObumvauRNuTX9psXkkBmY/ZlwxOe8363UynQvn0RmWhDAUX6oiC+kWUtx0pWJtFLQhAznqdfk+WRkAgWS8w6ob2x7r4zYVA4JO+Rrt+9bFgjQhIwM381R5YCYZgsWAA5PUS7gA/oxUQrbRdzp7p/nin2ZSSQ8OZ9IcBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HXds6Q+11jQaIEKLExMVNC1Wx7+1+Af0RzE8zZ+hBY=;
 b=jgTSASowan6dUKioXtc7z6mpkUFJq0tcZLGm1cLka/HCVN/ORRuOtdajQAkF0jgwL6UPFfSRQjx+fQugpfr9iphCj3cQmKn/AWFGD+K1zepRhBedJIhuNwZTAUAgpxM/uqfSF7eNZGc8vaat+jUxHJPLwR1RLnQhBiSNgKN61dSKEOtLO8yKEVDI0rB7FGjz8g8D0pUrW3ODFcnIpWOgPSVBvmqKa91pBx7QucGLCA5FIorSYTPKaEuxO5WB8XvmwWgctv204UeyBUcNmgd5ZUncFfRVbSn5VmR1DruamUQ0HSt4NSYxj+V31sFlf8hH91agTAUO6PWYv7dmYvylFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HE1EUR02FT038.eop-EUR02.prod.protection.outlook.com
 (2a01:111:e400:7e1d::36) by
 HE1EUR02HT174.eop-EUR02.prod.protection.outlook.com (2a01:111:e400:7e1d::490)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Mon, 9 Mar
 2020 13:45:52 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.10.54) by
 HE1EUR02FT038.mail.protection.outlook.com (10.152.11.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Mon, 9 Mar 2020 13:45:52 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 9 Mar 2020
 13:45:52 +0000
Received: from [192.168.1.101] (92.77.140.102) by FR2P281CA0022.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Mon, 9 Mar 2020 13:45:51 +0000
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
Subject: Re: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
Thread-Topic: [PATCH v2 5/5] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
Thread-Index: AQHV9ZJHYfsGvDLnM0SksOJ5MpqOZahARvEA
Date:   Mon, 9 Mar 2020 13:45:52 +0000
Message-ID: <AM6PR03MB5170BC58D90BAD80CDEF3F8BE4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
In-Reply-To: <87zhcq4jdj.fsf_-_@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: FR2P281CA0022.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::9) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:C8EDBA1F05C561CF3BB4B45B988EA7AC398CC95AA926D55BE60041CF42968EBF;UpperCasedChecksum:4C0B955CC6DA8074080DD2C8D8152A121E3344CFA53DB0EFC92D14C6A0F32C00;SizeAsReceived:9871;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [7tYKb0jPB66M7v/f58HxmMHbKML6mDV9]
x-microsoft-original-message-id: <3576ca27-c68a-308a-9ddd-f76d163f81e8@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 44b748a1-c14c-42f9-5846-08d7c4302ef5
x-ms-traffictypediagnostic: HE1EUR02HT174:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VJu1xTPVWop4UxIZDKT10eupaGw0QfN3FCeMSQ0LKXismnUscAXRHbGFZcI381sxu9FXdDbHNVVd9rbpIZamsO1/tZhd3nrG9fxo/onm72SYdfFtsuP+CCDi12EsyGs6BCRX8UfcTxv6T66AVnP5xGlLGVL4PCjg4l5IEqGqiZbw1o02zO+wGPDu9eI7lok6
x-ms-exchange-antispam-messagedata: CNDUBxT8GpIyfrFfVgTyBSIObU39JrZ7PuzGPfd+dOM9ToJwic7uL2ep5Sf1VZu8xw0txeZaQLvpLnhUEuDzN3Yu45nL6vGPwrww8CfbgB0SJrXeuYFj5m9P9uzF2g1IvMCECBnTCuFNZ243vSfFPg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <25EC084D81A12142B470F4D19192D000@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 44b748a1-c14c-42f9-5846-08d7c4302ef5
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 13:45:52.5307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1EUR02HT174
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/8/20 10:38 PM, Eric W. Biederman wrote:
> 
> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
> over the userspace accesses as the arguments from userspace are read.
> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other

... is held while waiting for the trace parent to handle PTRACE_EVENT_EXIT
or something?

I wonder if we also should mention that
it is held while waiting for the trace parent to
receive the exit code with "wait"?

> threads are killed.  The cred_guard_mutex is held over
> "put_user(0, tsk->clear_child_tid)" in exit_mm().
> 
> Any of those can result in deadlock, as the cred_guard_mutex is held
> over a possible indefinite userspace waits for userspace.
> 
> Add exec_update_mutex that is only held over exec updating process

Add ?

> with the new contents of exec, so that code that needs not to be
> confused by exec changing the mm and the cred in ways that can not
> happen during ordinary execution of a process.
> 
> The plan is to switch the users of cred_guard_mutex to
> exec_udpate_mutex one by one.  This lets us move forward while still

s/udpate/update/


Bernd.
