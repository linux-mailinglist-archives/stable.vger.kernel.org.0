Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A10517B0EF
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 22:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbgCEVvy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 5 Mar 2020 16:51:54 -0500
Received: from mail-db8eur05olkn2071.outbound.protection.outlook.com ([40.92.89.71]:35904
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726111AbgCEVvy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 16:51:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEra62OmvctrRWT161kmPvFArxSjDrn2ciJ0PvaDOrP1YpxOKACLpzgrbqIG+0GVUulMXi2FaCCMlXfMRYqC/T+lSw+u1R/Q3/SpFk63wORgTULzaida/UTWiJId/gbvIdNF7uBxui6AMuYYStgJIEdiA4Sr6jY+ok5xXNZpJtn6Yy67TQiMwY6E/7YUhzOcsTy6xspm2U4f8U6uAk1B//o/9H81pXh56FVTSm6chpG3boY7hxtOksmJQtFlZz3o0EqGyLNr/kQoPbunitw8RqUyWPcenKCc7jx1PhM5Srza2j+8dnJ5cy5fTqF0mEEGaHYwLu6Zpzgg7Z7PN1KkTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipJpyfgd+w7XDS59LHoWR2NghtqM5US2BCtlmFglY3A=;
 b=enpuWxJon8OWOIv352IZTvuwO6zQqQ7ijF4gzkro/BsvumCwknXqBcnuLA2D0buMx37hG/fuhCdYHZgUYlBQ1plb3UoqK6KLLIXqmXR/3cZQ3JBoc+/2gty/H0CH4tMEhC18mGTz9kkG+1lKwalt4ZEWe1+OgOKfEkmRylFUSR0fjQdtvGglXrOnfKA/VJlj1B+m6RBWrRx8CRu/2kaF12J3EPCBLGVMAEv3dE4XXnPclSJamxM2tQ5QFRY6Bf4GqM3toD1WxeFe6BdwzPFO8OPmWPGfpgxhn5fPbmt9RaINZmjBnQJxw2ooLeM9T7H12rDH2LuWE3FPy6U4pb7NTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from VI1EUR05FT053.eop-eur05.prod.protection.outlook.com
 (2a01:111:e400:fc12::33) by
 VI1EUR05HT224.eop-eur05.prod.protection.outlook.com (2a01:111:e400:fc12::340)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Thu, 5 Mar
 2020 21:51:47 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.233.242.56) by
 VI1EUR05FT053.mail.protection.outlook.com (10.233.242.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.11 via Frontend Transport; Thu, 5 Mar 2020 21:51:47 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 21:51:47 +0000
Received: from [192.168.1.101] (92.77.140.102) by ZR0P278CA0019.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16 via Frontend Transport; Thu, 5 Mar 2020 21:51:44 +0000
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
Subject: Re: [PATCH 2/2] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
Thread-Topic: [PATCH 2/2] exec: Add a exec_update_mutex to replace
 cred_guard_mutex
Thread-Index: AQHV8zOjiaOX92PFsUy1cOGGFJ5V7ag6ihsA
Date:   Thu, 5 Mar 2020 21:51:47 +0000
Message-ID: <AM6PR03MB5170375DBF699D4F3DC7A08DE4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
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
 <87imjicxjw.fsf_-_@x220.int.ebiederm.org>
In-Reply-To: <87imjicxjw.fsf_-_@x220.int.ebiederm.org>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: ZR0P278CA0019.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::6) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:2CCC710423D8DB4EDD0E4ED8DFE2CBA6438AEC91827CA8918603DFA52594DA11;UpperCasedChecksum:A35E1812273EC370920156D1286E53AD51F796F8A8B7DFC56E6E3A77726E3FBA;SizeAsReceived:9913;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [VlK5u45bTAj8z1JtwA8m1r3C6lROL+nH]
x-microsoft-original-message-id: <b259a8cd-ddb0-8fd6-13f7-84ed1dc92d75@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 87efc010-ae9e-4bb6-0588-08d7c14f66f8
x-ms-traffictypediagnostic: VI1EUR05HT224:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HYaFzjLqiY7YB2RpnAajxJTyq3HHT2ssnBL4xQq4w2aZ2psYse8/879Lfotp+PcdPsWnIwKJVw7huR4w8VuYoHjkuGKmg2+G34TmsoXeBY552t2GxsO3bOAmvi2ErIw3klubsC0QtoQr3HFXz3HwYtDFLo4vwqq4NMRdLcSaEDao1mM6WT0FBfUzNJLbPWiIkSIIAS27qHw8r21quG/9zvHE8AsOUTpzQMNKiVqdPJQ=
x-ms-exchange-antispam-messagedata: hSe2C18FiGviccPUxhUdBVsB6fP/U/bTPl4aGbfmKKowQoxsJu9YJShkMN0bPGZ7Y7D3G6fQ1azO9fRWAIozWjSnO4T+CuUO6PnxLamgU1tCfbnr0+4GpgxwPANkZu/Q5Cz1X8QB6GekirASUM9plw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <71A9A64AA7C4994F9AAA627E38515FD4@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 87efc010-ae9e-4bb6-0588-08d7c14f66f8
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Mar 2020 21:51:47.5229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR05HT224
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/5/20 10:16 PM, Eric W. Biederman wrote:
> 
> The cred_guard_mutex is problematic.  The cred_guard_mutex is held
> over the userspace accesses as the arguments from userspace are read.
> The cred_guard_mutex is held of PTRACE_EVENT_EXIT as the the other
> threads are killed.  The cred_guard_mutex is held over
> "put_user(0, tsk->clear_child_tid)" in exit_mm().
> 
> Any of those can result in deadlock, as the cred_guard_mutex is held
> over a possible indefinite userspace waits for userspace.
> 
> Add exec_update_mutex that is only held over exec updating process
> with the new contents of exec, so that code that needs not to be
> confused by exec changing the mm and the cred in ways that can not
> happen during ordinary execution of a process can take.
> 
> The plan is to switch the users of cred_guard_mutex to
> exed_udpate_mutex one by one.  This lets us move forward while still
> being careful and not introducing any regressions.
> 
> Link: https://lore.kernel.org/lkml/20160921152946.GA24210@dhcp22.suse.cz/
> Link: https://lore.kernel.org/lkml/AM6PR03MB5170B06F3A2B75EFB98D071AE4E60@AM6PR03MB5170.eurprd03.prod.outlook.com/
> Link: https://lore.kernel.org/linux-fsdevel/20161102181806.GB1112@redhat.com/
> Link: https://lore.kernel.org/lkml/20160923095031.GA14923@redhat.com/
> Link: https://lore.kernel.org/lkml/20170213141452.GA30203@redhat.com/
> Ref: 45c1a159b85b ("Add PTRACE_O_TRACEVFORKDONE and PTRACE_O_TRACEEXIT facilities.")
> Ref: 456f17cd1a28 ("[PATCH] user-vm-unlock-2.5.31-A2")
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/exec.c                    | 4 ++++
>  include/linux/sched/signal.h | 9 ++++++++-
>  kernel/fork.c                | 1 +
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index c243f9660d46..ad7b518f906d 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1182,6 +1182,7 @@ static int de_thread(struct linux_binprm *bprm, struct task_struct *tsk)
>  		release_task(leader);
>  	}
>  
> +	mutex_lock(&current->signal->exec_update_mutex);
>  	bprm->unrecoverable = true;
>  	sig->group_exit_task = NULL;
>  	sig->notify_count = 0;
> @@ -1425,6 +1426,8 @@ static void free_bprm(struct linux_binprm *bprm)
>  {
>  	free_arg_pages(bprm);
>  	if (bprm->cred) {
> +		if (bprm->unrecoverable)
> +			mutex_unlock(&current->signal->exec_update_mutex);
>  		mutex_unlock(&current->signal->cred_guard_mutex);
>  		abort_creds(bprm->cred);
>  	}
> @@ -1474,6 +1477,7 @@ void install_exec_creds(struct linux_binprm *bprm)
>  	 * credentials; any time after this it may be unlocked.
>  	 */
>  	security_bprm_committed_creds(bprm);
> +	mutex_unlock(&current->signal->exec_update_mutex);
>  	mutex_unlock(&current->signal->cred_guard_mutex);
>  }
>  EXPORT_SYMBOL(install_exec_creds);
> diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
> index 88050259c466..a29df79540ce 100644
> --- a/include/linux/sched/signal.h
> +++ b/include/linux/sched/signal.h
> @@ -224,7 +224,14 @@ struct signal_struct {
>  
>  	struct mutex cred_guard_mutex;	/* guard against foreign influences on
>  					 * credential calculations
> -					 * (notably. ptrace) */
> +					 * (notably. ptrace)
> +					 * Deprecated do not use in new code.
> +					 * Use exec_update_mutex instead.
> +					 */
> +	struct mutex exec_update_mutex;	/* Held while task_struct is being
> +					 * updated during exec, and may have
> +					 * inconsistent permissions.
> +					 */
>  } __randomize_layout;
>  
>  /*
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 60a1295f4384..12896a6ecee6 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1594,6 +1594,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
>  	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
>  
>  	mutex_init(&sig->cred_guard_mutex);
> +	mutex_init(&sig->exec_update_mutex);
>  
>  	return 0;
>  }
> 
Don't you need to add something like this to init/init_task.c ?

.exec_update_mutex = __MUTEX_INITIALIZER(init_signals.exec_update_mutex),


Bernd.
