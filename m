Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14D1B17E1C4
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 14:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgCIN47 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 9 Mar 2020 09:56:59 -0400
Received: from mail-vi1eur05olkn2037.outbound.protection.outlook.com ([40.92.90.37]:53517
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726383AbgCIN46 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Mar 2020 09:56:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z6WTAis9vkniD1rAvb5y3z3wX6r0wjcdC33gHSae6T1DHzEZTcbdVOvSMG9G+fc3K7BAIHWl6ztsFeLuHpH3tZZMOAraF6KCk9lnUIE+tEJqyum/zz865uCqmq5wA5j9bATjARFXuzykvmuuv2eSzI0UGi9mLShsGCDb01olhkBEu5ZKSeH1kCjsFuMk5aOMH1iWtZW3qKBsMkN5xTjsBS48DFALmXhiRGW/4td9a1E9JdxekNyFE08MYlxcU8C6ZrNQilhiIY5dEdyV8r/1dduV2SokfALZ6I9Z8jF9ulxgjx5lPomwTSPouE97X07wLd2UKlm0U6ZJ/xQL2SBaFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yi8+Ifj7+IVwk8cKLYgjMHk+362bsnsvCoRPq48uwvQ=;
 b=jMQUHKZmkP2Xl5Nd0WVbRY+CTrVRY+qlAz7MyYeWg4e6XwK96G41vLVpDdXl+ZdFYt1L552tSA9wnQqNxC8wjRee3Kh0tnNpcpU0GvDIcHqNlwHwB9pWVsPJtiGMqu0dnMUZl+11n5njilqJL7RV91L2cTSSt0Xo5qhfKZ2lXTeJMS4i0/dqdYxt5Fq6fwHgii9TYMVOeaFJPvWd1VDyPQSHbrU/SOpBSGLJzKLl3MCWnUzjOp957L4a5kjhDRoKh7JWZMdvV7e1nk1b/jRN9PzeQwzJ3k7PvipuUXTRV4WRBxGbW/wK7aE8fm0wo678j9WnWuYs8MRgMzMjUEyeNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from AM6EUR05FT032.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc11::3a) by
 AM6EUR05HT249.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc11::335)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Mon, 9 Mar
 2020 13:56:54 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.240.56) by
 AM6EUR05FT032.mail.protection.outlook.com (10.233.240.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Mon, 9 Mar 2020 13:56:54 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Mon, 9 Mar 2020
 13:56:54 +0000
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0047.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Mon, 9 Mar 2020 13:56:52 +0000
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
Thread-Index: AQHV9ZHPFX16pJkAgEa5cakb87d5R6hASgaA
Date:   Mon, 9 Mar 2020 13:56:54 +0000
Message-ID: <AM6PR03MB5170FBDA2F0F19ECF2906703E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <87pndm5y3l.fsf_-_@x220.int.ebiederm.org>
In-Reply-To: <87pndm5y3l.fsf_-_@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZR0P278CA0047.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::16) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:B515126297876112A916F44DFDB18DD9BFDBD252421E38E513258B332AB5B72C;UpperCasedChecksum:C3A00DC04B939B54E45B83C53CBF058525589B878FBDAEF83C6AC291945DED88;SizeAsReceived:9855;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [K825C0teb3P5ZldLrD3eKiX488msngkX]
x-microsoft-original-message-id: <f62b143d-0170-1a4c-37db-33edf87aa84f@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: aa99d3ea-e3b2-492e-dfe3-08d7c431b987
x-ms-traffictypediagnostic: AM6EUR05HT249:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N29AFT5gwOdXOw4Ift49nAsui4EvcbcVwrocPIbUJxnOplygYGoostbkPz3VwpBrlE4fmlUqDbqlRtCUgO2TFSllAzW0dAQRKueAgTxI5RmdcJsqC3RmuHfAsnvRmCorQ0E57P66gJTqub6d3vWW1IwY1vGFuEpbal2Sj2fYz/oCuS3/MnDygk5wSxr4MFvB
x-ms-exchange-antispam-messagedata: CAXBwo9svyP7QuhSTsiq2S2ZAE3T/XRuhCoQdJ/s0j1smOu3w6NKWyNxuBiGYGFwiF01/Bu1Yr3cZsf9c6Oum9XreIgdOWgr0lHIQeVg5ntrr69H5bYPMSLr2kscu8UQPMZ3qUSbqTA9TSWOS4oHuw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <E25BBE82D2843C4781C74B3274FB5F83@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: aa99d3ea-e3b2-492e-dfe3-08d7c431b987
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 13:56:54.5613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6EUR05HT249
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/8/20 10:35 PM, Eric W. Biederman wrote:
> 
> Make it clear that current only needs to be computed once in
> flush_old_exec.  This may have some efficiency improvements and it
> makes the code easier to change.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/exec.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index db17be51b112..c3f34791f2f0 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1260,13 +1260,14 @@ void __set_task_comm(struct task_struct *tsk, const char *buf, bool exec)
>   */
>  int flush_old_exec(struct linux_binprm * bprm)
>  {
> +	struct task_struct *me = current;
>  	int retval;
>  
>  	/*
>  	 * Make sure we have a private signal table and that
>  	 * we are unassociated from the previous thread group.
>  	 */
> -	retval = de_thread(current);
> +	retval = de_thread(me);
>  	if (retval)
>  		goto out;
>  
> @@ -1294,10 +1295,10 @@ int flush_old_exec(struct linux_binprm * bprm)
>  	bprm->mm = NULL;
>  
>  	set_fs(USER_DS);
> -	current->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
> +	me->flags &= ~(PF_RANDOMIZE | PF_FORKNOEXEC | PF_KTHREAD |
>  					PF_NOFREEZE | PF_NO_SETAFFINITY);

I wonder if this line should be aligned with the previous?


Bernd.
