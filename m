Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245B817B605
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 06:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgCFFLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 00:11:22 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:54456 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgCFFLV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 00:11:21 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jA5GZ-0005o8-Nj; Thu, 05 Mar 2020 22:11:19 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jA5GY-0003qV-TP; Thu, 05 Mar 2020 22:11:19 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
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
        <87o8tacxl3.fsf_-_@x220.int.ebiederm.org>
        <AM6PR03MB5170B05CFDAF21D8A99B7E48E4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
Date:   Thu, 05 Mar 2020 23:09:04 -0600
In-Reply-To: <AM6PR03MB5170B05CFDAF21D8A99B7E48E4E20@AM6PR03MB5170.eurprd03.prod.outlook.com>
        (Bernd Edlinger's message of "Thu, 5 Mar 2020 22:56:01 +0000")
Message-ID: <87pndqax3j.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jA5GY-0003qV-TP;;;mid=<87pndqax3j.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/OxSTSv2CXmzMmUtD1Q1oXz5BqRMOOkKE=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMNoVowels autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4996]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Bernd Edlinger <bernd.edlinger@hotmail.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 354 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 2.9 (0.8%), b_tie_ro: 1.96 (0.6%), parse: 1.14
        (0.3%), extract_message_metadata: 14 (3.9%), get_uri_detail_list: 1.63
        (0.5%), tests_pri_-1000: 26 (7.5%), tests_pri_-950: 1.28 (0.4%),
        tests_pri_-900: 1.05 (0.3%), tests_pri_-90: 32 (9.1%), check_bayes: 31
        (8.6%), b_tokenize: 12 (3.5%), b_tok_get_all: 9 (2.6%), b_comp_prob:
        2.6 (0.7%), b_tok_touch_all: 3.7 (1.0%), b_finish: 0.67 (0.2%),
        tests_pri_0: 262 (74.0%), check_dkim_signature: 0.56 (0.2%),
        check_dkim_adsp: 2.5 (0.7%), poll_dns_idle: 0.81 (0.2%), tests_pri_10:
        2.9 (0.8%), tests_pri_500: 7 (2.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 1/2] exec: Properly mark the point of no return
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bernd Edlinger <bernd.edlinger@hotmail.de> writes:

> On 3/5/20 10:15 PM, Eric W. Biederman wrote:
>> 
>> Add a flag binfmt->unrecoverable to mark when execution has gotten to
>> the point where it is impossible to return to userspace with the
>> calling process unchanged.
>> 
>> While techinically this state starts as soon as de_thread starts
>> killing threads, the only return path at that point is if there is a
>> fatal signal pending.  I have choosen instead to set unrecoverable
>> when the killing stops, and there are possibilities of failures other
>> than fatal signals.  In particular it is possible for the allocation
>> of a new sighand structure to fail.
>> 
>> Setting unrecoverable at this point has the benefit that other actions
>> can be taken after the other threads are all dead, and the
>> unrecoverable flag can double as a flag that those actions have been
>> taken.
>> 
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> ---
>>  fs/exec.c               | 7 ++++---
>>  include/linux/binfmts.h | 7 ++++++-
>>  2 files changed, 10 insertions(+), 4 deletions(-)
>> 
>> diff --git a/fs/exec.c b/fs/exec.c
>> index db17be51b112..c243f9660d46 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1061,7 +1061,7 @@ static int exec_mmap(struct mm_struct *mm)
>>   * disturbing other processes.  (Other processes might share the signal
>>   * table via the CLONE_SIGHAND option to clone().)
>>   */
>> -static int de_thread(struct task_struct *tsk)
>> +static int de_thread(struct linux_binprm *bprm, struct task_struct *tsk)
>>  {
>>  	struct signal_struct *sig = tsk->signal;
>>  	struct sighand_struct *oldsighand = tsk->sighand;
>> @@ -1182,6 +1182,7 @@ static int de_thread(struct task_struct *tsk)
>>  		release_task(leader);
>>  	}
>>  
>> +	bprm->unrecoverable = true;
>>  	sig->group_exit_task = NULL;
>>  	sig->notify_count = 0;
>>  
>
> ah, sorry, 
>         if (thread_group_empty(tsk))
>                 goto no_thread_group;
> will skip this:
>
>         sig->group_exit_task = NULL;
>         sig->notify_count = 0;
>
> no_thread_group:
>         /* we have changed execution domain */
>         tsk->exit_signal = SIGCHLD;
>
> so I think the bprm->unrecoverable = true; should be here?

Absolutely.  Thank you very much.

This is why I try and keep things to one clear simple thing per patch so
silly thinkos like that can be caught.

Eric
