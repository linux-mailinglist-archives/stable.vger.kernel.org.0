Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DBD17E62B
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 18:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgCIR4p convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 Mar 2020 13:56:45 -0400
Received: from mail-oln040092075097.outbound.protection.outlook.com ([40.92.75.97]:43652
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbgCIR4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 13:56:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ae3sGL8CAz8dh4aZrUv7um9yVt8AC8acZv0jauLjKmW81zj8RLffYHEi3wS9Z/Fb8rFfoBRYGkBmMC35+8L6aoW0YbS+DmVyFiI7Q2xYHWRD1JmTenc8h9F0yHVGR04E9UG2k63kh7f0+AyyjqyVq837C7vqbQg7MFXsytKQ/a/v7kWFM/jtepdt4Od415ygfCpvLX2fUP+JAxzIQIgXDxQW5jmBBDia3cxSxIMIONCDiSqTFg2G9uSJTWOUrilXm3k5hu2Wt2ub9UuV8SW3avRPiq4owChWXL4VpRf3yxUEXU/jloPpfxeRdO6Wk8v52KIH2E4Lpg0kL8giAqAnAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=keZwCs+JvWPoUhyh616IGpGI30gYC/j1lWmRoY5sAYY=;
 b=d2svxYkjstj105EWSlUQQotNCIzAE3ZEPK8/WKeEHYTX/CvP15LHe4bJVyf89xkjDRg5Yg9DhFF3l5CiIz2MHN6T+VTr4GxZaa4fmT1KhwnQKvPGlVTuKkuiRljjNLZ0rMO8z9YrQCspXQsYrOl6vxgj+s4YsuIXz1Z2/u0gLJnFErXDWH+IYkNV4H8m4zD211lMpJLH7y3hM5ijsK7rLxv99Y+eEy5mmBtj5IV2rEjHootSgpEWjZIvk4WTZuVmZl6g2euu8jEj3dfinYOU8HFMdzA0gR9Kqb0vAaWY9yS0hTmZ/DFnlXFs4KG5ydVZNHvlqQVLoD4tId1xoxfgXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DB3EUR04FT040.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0c::3a) by
 DB3EUR04HT070.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0c::202)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Mon, 9 Mar
 2020 17:56:28 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.24.54) by
 DB3EUR04FT040.mail.protection.outlook.com (10.152.25.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Mon, 9 Mar 2020 17:56:28 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 9 Mar 2020
 17:56:28 +0000
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0047.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Mon, 9 Mar 2020 17:56:25 +0000
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
Subject: Re: [PATCH v2 1/5] exec: Only compute current once in flush_old_exec
Thread-Topic: [PATCH v2 1/5] exec: Only compute current once in flush_old_exec
Thread-Index: AQHV9ZHPFX16pJkAgEa5cakb87d5R6hASgaAgAA9eBuAAAV1gA==
Date:   Mon, 9 Mar 2020 17:56:28 +0000
Message-ID: <AM6PR03MB51700E6A252CA1E3093B3ED8E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <87pndm5y3l.fsf_-_@x220.int.ebiederm.org>
 <AM6PR03MB5170FBDA2F0F19ECF2906703E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87mu8p4elb.fsf@x220.int.ebiederm.org>
In-Reply-To: <87mu8p4elb.fsf@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZR0P278CA0047.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::16) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:EFD5A657450C5BC3F1029008D5AA8FE49A5F9EB7F88CB93EE0B4FB66310D83AB;UpperCasedChecksum:043A69E7BA2E2B0AFCEF720EC43FDFFDBE51A86FD26250D4F5DD1089F63B0F51;SizeAsReceived:9868;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [rtZq0BQ82HpqbDG9nqZ2fsYV/LzuXuPt]
x-microsoft-original-message-id: <5b4966d9-364a-fb5a-098c-6501d8d541ee@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 9f84d059-1846-433b-d207-08d7c45330e5
x-ms-traffictypediagnostic: DB3EUR04HT070:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M+HbGN3xC6a0DP00w1zrA/nQlYGnjvpxT9Zo7z7WOjaw9pcwdSYTbSziKCcvJbUmocPDL0bkzgCSp28/n7eg4bmBJrshCJ1WwpEmRkJ6vCnDLafBvagB2zKHXha6FouvcaWC7wYQHC0dVOC5dcZPmg6wY3fob9XAMeFvLfLsEsLH6Tis/oIEYhL9o72x1vBa
x-ms-exchange-antispam-messagedata: 8CIhEcDqfrCl1x77jUhuoqNF5iy2/0a1DI4tMTanec79jqhgLdpoovFMQ+KHlH9fezou2izrRUu4JI8aVlW85VM7rv9BC6IWYWMP5jA6kyRKNJprJsql2inu9l5hK9gg/6ZfXID0VoElkGlmt9aSaQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <B3BBD33A1F57F540B7E1420EE61777EA@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f84d059-1846-433b-d207-08d7c45330e5
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 17:56:28.1749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3EUR04HT070
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/9/20 6:34 PM, Eric W. Biederman wrote:
> Bernd Edlinger <bernd.edlinger@hotmail.de> writes:
> 
>> On 3/8/20 10:35 PM, Eric W. Biederman wrote:
>>>
>>> Make it clear that current only needs to be computed once in
>>> flush_old_exec.  This may have some efficiency improvements and it
>>> makes the code easier to change.
>>>
>>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>>> ---
>>>  fs/exec.c | 9 +++++----
>>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/exec.c b/fs/exec.c
>>> index db17be51b112..c3f34791f2f0 100644
>>> --- a/fs/exec.c
>>> +++ b/fs/exec.c
>>> @@ -1260,13 +1260,14 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
>>>   */
>>>  int flush_old_exec(struct linux_binprm * bprm)
>>>  {
>>> +	struct task_struct *me = current;
>>>  	int retval;
>>>  
>>>  	/*
>>>  	 * Make sure we have a private signal table and that
>>>  	 * we are unassociated from the previous thread group.
>>>  	 */
>>> -	retval = de_thread(current);
>>> +	retval = de_thread(me);
>>>  	if (retval)
>>>  		goto out;
>>>  
>>> @@ -1294,10 +1295,10 @@ int flush_old_exec(struct linux_binprm * bprm)
>>>  	bprm->mm = NULL;
>>>  
>>>  	set_fs(USER_DS);
>>> -	current->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
>>> +	me->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
>>>  					PF_NOFREEZE | PF_NO_SETAFFINITY);
>>
>> I wonder if this line should be aligned with the previous?
> 
> In this case I don't think so.  The style used for second line is indent
> with tabs as much as possible to the right.  I haven't changed that.
> 
> Further mixing a change in indentation style with just a variable rename
> will make the patch confusing to read because two things have to be
> verified at the same time.
> 
> So while I see why you ask I think this bit needs to stay as is.
> 

Ah, okay, I see.
Thanks for explaining this rule, I was not aware of it,
but I am still new here :)


Thanks
Bernd.
