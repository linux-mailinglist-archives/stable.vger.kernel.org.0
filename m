Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2192A34917F
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 13:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhCYMF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 08:05:56 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36992 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhCYMFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Mar 2021 08:05:41 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPOk7-007TfG-SD; Thu, 25 Mar 2021 06:05:39 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPOk6-006NWb-TI; Thu, 25 Mar 2021 06:05:39 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <20210325112459.1926846-1-sashal@kernel.org>
        <20210325112459.1926846-43-sashal@kernel.org>
        <f4c932b4-b787-651e-dd9f-584b386acddb@samba.org>
Date:   Thu, 25 Mar 2021 07:04:38 -0500
In-Reply-To: <f4c932b4-b787-651e-dd9f-584b386acddb@samba.org> (Stefan
        Metzmacher's message of "Thu, 25 Mar 2021 12:34:18 +0100")
Message-ID: <m1r1k34ey1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lPOk6-006NWb-TI;;;mid=<m1r1k34ey1.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18Lb2JrSghaFx8NMQ2AKONsIk2+oPW0fMQ=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_TooManySym_03,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4829]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stefan Metzmacher <metze@samba.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 433 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 10 (2.2%), b_tie_ro: 8 (1.9%), parse: 0.81 (0.2%),
         extract_message_metadata: 17 (3.9%), get_uri_detail_list: 1.41 (0.3%),
         tests_pri_-1000: 21 (4.9%), tests_pri_-950: 1.29 (0.3%),
        tests_pri_-900: 1.02 (0.2%), tests_pri_-90: 145 (33.5%), check_bayes:
        144 (33.2%), b_tokenize: 6 (1.5%), b_tok_get_all: 6 (1.5%),
        b_comp_prob: 2.1 (0.5%), b_tok_touch_all: 126 (29.0%), b_finish: 0.85
        (0.2%), tests_pri_0: 225 (51.9%), check_dkim_signature: 0.57 (0.1%),
        check_dkim_adsp: 2.1 (0.5%), poll_dns_idle: 0.51 (0.1%), tests_pri_10:
        2.2 (0.5%), tests_pri_500: 7 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH AUTOSEL 5.11 43/44] signal: don't allow STOP on PF_IO_WORKER threads
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stefan Metzmacher <metze@samba.org> writes:

> Am 25.03.21 um 12:24 schrieb Sasha Levin:
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> [ Upstream commit 4db4b1a0d1779dc159f7b87feb97030ec0b12597 ]
>> 
>> Just like we don't allow normal signals to IO threads, don't deliver a
>> STOP to a task that has PF_IO_WORKER set. The IO threads don't take
>> signals in general, and have no means of flushing out a stop either.
>> 
>> Longer term, we may want to look into allowing stop of these threads,
>> as it relates to eg process freezing. For now, this prevents a spin
>> issue if a SIGSTOP is delivered to the parent task.
>> 
>> Reported-by: Stefan Metzmacher <metze@samba.org>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  kernel/signal.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/kernel/signal.c b/kernel/signal.c
>> index 55526b941011..00a3840f6037 100644
>> --- a/kernel/signal.c
>> +++ b/kernel/signal.c
>> @@ -288,7 +288,8 @@ bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask)
>>  			JOBCTL_STOP_SIGMASK | JOBCTL_TRAPPING));
>>  	BUG_ON((mask & JOBCTL_TRAPPING) && !(mask & JOBCTL_PENDING_MASK));
>>  
>> -	if (unlikely(fatal_signal_pending(task) || (task->flags & PF_EXITING)))
>> +	if (unlikely(fatal_signal_pending(task) ||
>> +		     (task->flags & (PF_EXITING | PF_IO_WORKER))))
>>  		return false;
>>  
>>  	if (mask & JOBCTL_STOP_SIGMASK)
>> 
>
> Again, why is this proposed for 5.11 and 5.10 already?

Has the bit about the io worker kthreads been backported?
If so this isn't horrible.  If not this is nonsense.

Eric


