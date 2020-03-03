Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFFE51770CA
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 09:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbgCCIId convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 3 Mar 2020 03:08:33 -0500
Received: from mail-oln040092074084.outbound.protection.outlook.com ([40.92.74.84]:57468
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727665AbgCCIId (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 03:08:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITRgMRFwGq+9tEHa/naEE7LC8IXkotfw372qRGkTQCg174VHVfR0aVaq3q3gR7HGoznYRi/wyRHdviI+RnJQHPegDpLVrXurS46OO+70LaKm/EyoF5mPFSukS8Pfp0034iuqetaUP9SKuZVQMlydlzhEgc0nm0PilUD3QrrCJMn272LyyXqc9URPahFGz+BdH2ijLXNn419b4d1x2yN/01a4n4DvAn6VuFtcrkLD4zcrxqqdjmUpoMzXRKG+RH7w2F7dS5O3rGzaunyDCl15c+/p065V0L/6tnrC+1a2TJzk7Hxieh6iagdUtmTAX11qh+RWwQ/g/roRUqZ9nPHhsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9PPPVkqM9wOi3CG7qukEuigOrUuUctLQWqrb19vL/LA=;
 b=knIHQ70B1ipKPSWBnnuwXyfK8xMc+FVbEHMsghnYzc4Glngfm8qnj/A0HAt7REAcUNA3lBJx8a4D4eb8jBx0PogRL1gSd0QPQeyK+6AFt1zm5Q/KGp937VPmVhpHvR5CtLW4ppWbEXbJrDlnP3de5KLH+ICWPoz+06yQkrghBaUUWn6U8V+baXkuqZlgoI82BZaIzsJvInyAbxsJQESk9pqBis1s0PaVVq/t7tKCu8a7+QqEsPmKRuWn+YAq7/O/dCwjATuv2huPrxG2pGHFuugQpb38APW5MncWpPyT6ipPJ5R3xza1Nju8lkwwoZpygeY7POk+r39RTdfgFBvVRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from VI1EUR04FT012.eop-eur04.prod.protection.outlook.com
 (2a01:111:e400:7e0e::36) by
 VI1EUR04HT155.eop-eur04.prod.protection.outlook.com (2a01:111:e400:7e0e::451)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Tue, 3 Mar
 2020 08:08:27 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com (10.152.28.56) by
 VI1EUR04FT012.mail.protection.outlook.com (10.152.28.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15 via Frontend Transport; Tue, 3 Mar 2020 08:08:26 +0000
Received: from AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd]) by AM6PR03MB5170.eurprd03.prod.outlook.com
 ([fe80::1956:d274:cab3:b4dd%6]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 08:08:26 +0000
Received: from [192.168.1.101] (92.77.140.102) by AM4PR08CA0071.eurprd08.prod.outlook.com (2603:10a6:205:2::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Tue, 3 Mar 2020 08:08:25 +0000
From:   Bernd Edlinger <bernd.edlinger@hotmail.de>
To:     Kees Cook <keescook@chromium.org>
CC:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jonathan Corbet <corbet@lwn.net>,
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
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCHv4] exec: Fix a deadlock in ptrace
Thread-Topic: [PATCHv4] exec: Fix a deadlock in ptrace
Thread-Index: AQHV8OBzc5kV6gCKfE+vkD4wYYEirqg2JJ+AgAApSACAAAnhAIAALEkA
Date:   Tue, 3 Mar 2020 08:08:26 +0000
Message-ID: <AM6PR03MB5170A15099986CEC3189F251E4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
References: <87a74zmfc9.fsf@x220.int.ebiederm.org>
 <AM6PR03MB517071DEF894C3D72D2B4AE2E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87k142lpfz.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51704206634C009500A8080DE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <875zfmloir.fsf@x220.int.ebiederm.org>
 <AM6PR03MB51707ABF20B6CBBECC34865FE4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <87v9nmjulm.fsf@x220.int.ebiederm.org>
 <AM6PR03MB5170B976E6387FDDAD59A118E4E70@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003021531.C77EF10@keescook>
 <AM6PR03MB5170B5C1B95CB1D065EE3AFAE4E40@AM6PR03MB5170.eurprd03.prod.outlook.com>
 <202003022103.196C313623@keescook>
In-Reply-To: <202003022103.196C313623@keescook>
Accept-Language: en-US, en-GB, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR08CA0071.eurprd08.prod.outlook.com
 (2603:10a6:205:2::42) To AM6PR03MB5170.eurprd03.prod.outlook.com
 (2603:10a6:20b:ca::23)
x-incomingtopheadermarker: OriginalChecksum:741E6C98EEDA52C41514CF23F90EB15763BFC719DA372E2F1E7544CB472B3FDB;UpperCasedChecksum:B9ECA399D1A26E4A8C68430CC58C454E95AEC74A75227FFE92D693D777D54C4E;SizeAsReceived:9451;Count:50
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [eTPhqLa1QHNAg+d+8RMaWvAN7jGRF4sW]
x-microsoft-original-message-id: <34623fc5-5fd7-9347-0580-8a06c15241a3@hotmail.de>
x-ms-publictraffictype: Email
x-incomingheadercount: 50
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 93d9840b-6faa-4223-21df-08d7bf4a0d09
x-ms-traffictypediagnostic: VI1EUR04HT155:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GdesCbFA7y4Vt4TbZNiSOJggmSSLmAQOY9iFK0fU/bN5TDv/SAjMBnEYowcDmDAukQ/usR3ZYZsgXu+R5owwmbIoBLmcnE1jsVbKF4327wKar9opir0fv8Kqv9iE5uYxRXZbLGRKQ7BKGgbUtKOh1qXKmrOQTjjh3W0glzjsVR8c9Ip0lKj8cH0/KhI86IE6
x-ms-exchange-antispam-messagedata: cnWOxUl0guvQX6gB7+kcuq3YPB0pHg/JNdktvitbl703xpGvgRlu40wYzGvSOmmN8Kq/l9pKM3WBiYvYaEPDT6/G+5wdjRnFe1WEazXGDi0PfjwwlHZCtg2Pvv0+sk+9kvq3+1hTnn8+M6Adcc2g/A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <4B6F1849A2047E4BB96DDC60DE13C819@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d9840b-6faa-4223-21df-08d7bf4a0d09
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2020 08:08:26.9038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1EUR04HT155
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/3/20 6:29 AM, Kees Cook wrote:
> On Tue, Mar 03, 2020 at 04:54:34AM +0000, Bernd Edlinger wrote:
>> On 3/3/20 3:26 AM, Kees Cook wrote:
>>> On Mon, Mar 02, 2020 at 10:18:07PM +0000, Bernd Edlinger wrote:
>>>> [...]
>>>
>>> If I'm reading this patch correctly, this changes the lifetime of the
>>> cred_guard_mutex lock to be:
>>> 	- during prepare_bprm_creds()
>>> 	- from flush_old_exec() through install_exec_creds()
>>> Before, cred_guard_mutex was held from prepare_bprm_creds() through
>>> install_exec_creds().
> 
> BTW, I think the effect of this change (i.e. my paragraph above) should
> be distinctly called out in the commit log if this solution moves
> forward.
> 

Okay, will do.

>>> That means, for example, that check_unsafe_exec()'s documented invariant
>>> is violated:
>>>     /*
>>>      * determine how safe it is to execute the proposed program
>>>      * - the caller must hold ->cred_guard_mutex to protect against
>>>      *   PTRACE_ATTACH or seccomp thread-sync
>>>      */
>>
>> Oh, right, I haven't understood that hint...
> 
> I know no_new_privs is checked there, but I haven't studied the
> PTRACE_ATTACH part of that comment. If that is handled with the new
> check, this comment should be updated.
> 

Okay, I change that comment to:

/*
 * determine how safe it is to execute the proposed program
 * - the caller must have set ->cred_locked_in_execve to protect against
 *   PTRACE_ATTACH or seccomp thread-sync
 */

>>> I think it also means that the potentially multiple invocations
>>> of bprm_fill_uid() (via prepare_binprm() via binfmt_script.c and
>>> binfmt_misc.c) would be changing bprm->cred details (uid, gid) without
>>> a lock (another place where current's no_new_privs is evaluated).
>>
>> So no_new_privs can change from 0->1, but should not
>> when execve is running.
>>
>> As long as the calling thread is in execve it won't do this,
>> and the only other place, where it may set for other threads
>> is in seccomp_sync_threads, but that can easily be avoided see below.
> 
> Yeah, everything was fine until I had to go complicate things with
> TSYNC. ;) The real goal is making sure an exec cannot gain privs while
> later gaining a seccomp filter from an unpriv process. The no_new_privs
> flag was used to control this, but it required that the filter not get
> applied during exec.
> 
>>> Related, it also means that cred_guard_mutex is unheld for every
>>> invocation of search_binary_handler() (which can loop via the previously
>>> mentioned binfmt_script.c and binfmt_misc.c), if any of them have hidden
>>> dependencies on cred_guard_mutex. (Thought I only see bprm_fill_uid()
>>> currently.)
>>>
>>> For seccomp, the expectations about existing thread states risks races
>>> too. There are two locks held for TSYNC:
>>> - current->sighand->siglock is held to keep new threads from
>>>   appearing/disappearing, which would destroy filter refcounting and
>>>   lead to memory corruption.
>>
>> I don't understand what you mean here.
>> How can this lead to memory corruption?
> 
> Mainly this is a matter of how seccomp manages its filter hierarchy
> (since the filters are shared through process ancestry), so if a thread
> appears in the middle of TSYNC it may be racing another TSYNC and break
> ancestry, leading to bad reference counting on process death, etc.
> (Though, yes, with refcount_t now, things should never corrupt, just
> waste memory.)
> 

I assume for now, that the current->sighand->siglock held while iterating all
threads is sufficient here.

>>> - cred_guard_mutex is held to keep no_new_privs in sync with filters to
>>>   avoid no_new_privs and filter confusion during exec, which could
>>>   lead to exploitable setuid conditions (see below).
>>>
>>> Just racing a malicious thread during TSYNC is not a very strong
>>> example (a malicious thread could do lots of fun things to "current"
>>> before it ever got near calling TSYNC), but I think there is the risk
>>> of mismatched/confused states that we don't want to allow. One is a
>>> particularly bad state that could lead to privilege escalations (in the
>>> form of the old "sendmail doesn't check setuid" flaw; if a setuid process
>>> has a filter attached that silently fails a priv-dropping setuid call
>>> and continues execution with elevated privs, it can be tricked into
>>> doing bad things on behalf of the unprivileged parent, which was the
>>> primary goal of the original use of cred_guard_mutex with TSYNC[1]):
>>>
>>> thread A clones thread B
>>> thread B starts setuid exec
>>> thread A sets no_new_privs
>>> thread A calls seccomp with TSYNC
>>> thread A in seccomp_sync_threads() sets seccomp filter on self and thread B
>>> thread B passes check_unsafe_exec() with no_new_privs unset
>>> thread B reaches bprm_fill_uid() with no_new_privs unset and gains privs
>>> thread A still in seccomp_sync_threads() sets no_new_privs on thread B
>>> thread B finishes exec, now running with elevated privs, a filter chosen
>>>          by thread A, _and_ nnp set (which doesn't matter)
>>>
>>> With the original locking, thread B will fail check_unsafe_exec()
>>> because filter and nnp state are changed together, with "atomicity"
>>> protected by the cred_guard_mutex.
>>>
>>
>> Ah, good point, thanks!
>>
>> This can be fixed by checking current->signal->cred_locked_for_ptrace
>> while the cred_guard_mutex is locked, like this for instance:
>>
>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> index b6ea3dc..377abf0 100644
>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -342,6 +342,9 @@ static inline pid_t seccomp_can_sync_threads(void)
>>         BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
>>         assert_spin_locked(&current->sighand->siglock);
>>  
>> +       if (current->signal->cred_locked_for_ptrace)
>> +               return -EAGAIN;
>> +
> 
> Hmm. I guess something like that could work. TSYNC expects to be able to
> report _which_ thread wrecked the call, though... I wonder if in_execve
> could be used to figure out the offending thread. Hm, nope, that would
> be outside of lock too (and all users are "current" right now, so the
> lock wasn't needed before).
> 

I could move that in_execve = 1 to prepare_bprm_creds, if it really matters,
but the caller will die quickly and cannot do anything with that information
when another thread executes execve, right?

>>         /* Validate all threads being eligible for synchronization. */
>>         caller = current;
>>         for_each_thread(caller, thread) {
>>
>>
>>> And this is just the bad state I _can_ see. I'm worried there are more...
>>>
>>> All this said, I do see a small similarity here to the work I did to
>>> stabilize stack rlimits (there was an ongoing problem with making multiple
>>> decisions for the bprm based on current's state -- but current's state
>>> was mutable during exec). For this, I saved rlim_stack to bprm and ignored
>>> current's copy until exec ended and then stored bprm's copy into current.
>>> If the only problem anyone can see here is the handling of no_new_privs,
>>> we might be able to solve that similarly, at least disentangling tsync/nnp
>>> from cred_guard_mutex.
>>>
>>
>> I still think that is solvable with using cred_locked_for_ptrace and
>> simply make the tsync fail if it would otherwise be blocked.
> 
> I wonder if we can find a better name than "cred_locked_for_ptrace"?
> Maybe "cred_unfinished" or "cred_locked_in_exec" or something?
> 

Yeah, I'd go with "cred_locked_in_execve".

> And the comment on bool cred_locked_for_ptrace should mention that
> access is only allowed under cred_guard_mutex lock.
> 

okay.

>>>> +	sig->cred_locked_for_ptrace = false;
> 
> This is redundant to the zalloc -- I think you can drop it (unless
> someone wants to keep it for clarify?)
> 

I'll remove that here and in init/init_task.c

> Also, I think cred_locked_for_ptrace needs checking deeper, in
> __ptrace_may_access(), not in ptrace_attach(), since LOTS of things make
> calls to ptrace_may_access() holding cred_guard_mutex, expecting that to
> be sufficient to see a stable version of the thread...
> 

No, these need to be addressed individually, but most users just want
to know if the current credentials are sufficient at this moment, but will
not change the credentials, as ptrace and TSYNC do. 

BTW: Not all users have cred_guard_mutex, see mm/migrate.c,
mm/mempolicy.c, kernel/futex.c, fs/proc/namespaces.c etc.
So adding an access to cred_locked_for_execve in ptrace_may_access is
probably not an option.

However, one nice added value by this change is this:

void *thread(void *arg)
{
	ptrace(PTRACE_TRACEME, 0,0,0);
	return NULL;
}

int main(void)
{
	int pid = fork();

	if (!pid) {
		pthread_t pt;
		pthread_create(&pt, NULL, thread, NULL);
		pthread_join(pt, NULL);
		execlp("echo", "echo", "passed", NULL);
	}

	sleep(1000);
	ptrace(PTRACE_ATTACH, pid, 0,0);
	kill(pid, SIGCONT);
	return 0;
}

cat /proc/3812/stack 
[<0>] flush_old_exec+0xbf/0x760
[<0>] load_elf_binary+0x35a/0x16c0
[<0>] search_binary_handler+0x97/0x1d0
[<0>] __do_execve_file.isra.40+0x624/0x920
[<0>] __x64_sys_execve+0x49/0x60
[<0>] do_syscall_64+0x64/0x220
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9


> (I remain very nervous about weakening cred_guard_mutex without
> addressing the many many users...)
> 

They need to be looked at closely, that's pretty clear.
Most fall in the class, that just the current credentials need
to stay stable for a certain time.


Bernd.
