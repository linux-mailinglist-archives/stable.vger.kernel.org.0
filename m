Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A77AB1822CF
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 20:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387405AbgCKTvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 15:51:17 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48866 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731030AbgCKTvQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 15:51:16 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jC7Nn-0003gw-M1; Wed, 11 Mar 2020 13:51:11 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jC7Nm-0007Ul-Q4; Wed, 11 Mar 2020 13:51:11 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Kees Cook <keescook@chromium.org>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Andrei Vagin <avagin@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra \(Intel\)" <peterz@infradead.org>,
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
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "stable\@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-api\@vger.kernel.org" <linux-api@vger.kernel.org>
References: <87r1y12yc7.fsf@x220.int.ebiederm.org>
        <87k13t2xpd.fsf@x220.int.ebiederm.org>
        <87d09l2x5n.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170F0F9DC18F5EA77C9A857E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <871rq12vxu.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170DF45E3245F55B95CCD91E4FE0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <877dzt1fnf.fsf@x220.int.ebiederm.org>
        <AM6PR03MB51701C6F60699F99C5C67E0BE4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <875zfcxlwy.fsf@x220.int.ebiederm.org>
        <AM6PR03MB5170BD2476E35068E182EFA4E4FF0@AM6PR03MB5170.eurprd03.prod.outlook.com>
        <202003111203.738487D@keescook>
Date:   Wed, 11 Mar 2020 14:48:50 -0500
In-Reply-To: <202003111203.738487D@keescook> (Kees Cook's message of "Wed, 11
        Mar 2020 12:08:08 -0700")
Message-ID: <87pndin04d.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jC7Nm-0007Ul-Q4;;;mid=<87pndin04d.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+d5+rrjcsoE4xtiynlnq3fJUCLMY6zpyU=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa05.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMNoVowels,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Kees Cook <keescook@chromium.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 421 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 3.4 (0.8%), b_tie_ro: 2.2 (0.5%), parse: 1.74
        (0.4%), extract_message_metadata: 24 (5.6%), get_uri_detail_list: 2.6
        (0.6%), tests_pri_-1000: 39 (9.3%), tests_pri_-950: 1.53 (0.4%),
        tests_pri_-900: 1.26 (0.3%), tests_pri_-90: 34 (8.1%), check_bayes: 33
        (7.7%), b_tokenize: 14 (3.4%), b_tok_get_all: 9 (2.1%), b_comp_prob:
        2.8 (0.7%), b_tok_touch_all: 4.1 (1.0%), b_finish: 0.70 (0.2%),
        tests_pri_0: 288 (68.3%), check_dkim_signature: 0.84 (0.2%),
        check_dkim_adsp: 2.1 (0.5%), poll_dns_idle: 0.35 (0.1%), tests_pri_10:
        4.2 (1.0%), tests_pri_500: 19 (4.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 3/4] proc: io_accounting: Use new infrastructure to fix deadlocks in execve
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Tue, Mar 10, 2020 at 06:45:47PM +0100, Bernd Edlinger wrote:
>> This changes do_io_accounting to use the new exec_update_mutex
>> instead of cred_guard_mutex.
>> 
>> This fixes possible deadlocks when the trace is accessing
>> /proc/$pid/io for instance.
>> 
>> This should be safe, as the credentials are only used for reading.
>
> I'd like to see the rationale described better here for why it should be
> safe. I'm still not seeing why this is safe here, as we might check
> ptrace_may_access() with one cred and then iterate io accounting with a
> different credential...
>
> What am I missing?

The rational for non-regression is that exec_update_mutex covers all
of the same tsk->cred changes as cred_guard_mutex.  Therefore we are not
any worse off, and we avoid the deadlock.

As for safety.  Jann's argument that the only interesting credential
change is in exec applies.  All other credential changes that have any
effect on permission checks make the new cred non-dumpable (excepions
apply see the code).

So I think this is a non-regressing change.  A safe change.

I don't think either version of this code is fully correct.

Eric

>> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
>> ---
>>  fs/proc/base.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> index 4fdfe4f..529d0c6 100644
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -2770,7 +2770,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
>>  	unsigned long flags;
>>  	int result;
>>  
>> -	result = mutex_lock_killable(&task->signal->cred_guard_mutex);
>> +	result = mutex_lock_killable(&task->signal->exec_update_mutex);
>>  	if (result)
>>  		return result;
>>  
>> @@ -2806,7 +2806,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
>>  	result = 0;
>>  
>>  out_unlock:
>> -	mutex_unlock(&task->signal->cred_guard_mutex);
>> +	mutex_unlock(&task->signal->exec_update_mutex);
>>  	return result;
>>  }
>>  
>> -- 
>> 1.9.1
