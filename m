Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000B23EFDAF
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 09:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238109AbhHRHUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 03:20:11 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:57937 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238080AbhHRHUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 03:20:11 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1629271177; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=xuld9jbJEF7z4x2tTcSwgVXZJG37tCPPF0VBeJvRQ1k=; b=QduV3RvAtvXVnEBt0HOlWrIjBXQ7QCadp0/RSsrKeyCZZtb22Fk06sWnSEua/n4P6eXjMOMd
 mReG+dwqqTPawOjadyNavsrbwn5r+RL/52O9fsDO9vy0IVppHHxgETpt29UxwM4A18Kyu7ap
 URbwvXYtBdQiaah3ihNeTZGmElo=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 611cb475f746c298d919e347 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 18 Aug 2021 07:19:17
 GMT
Sender: neeraju=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 13A23C43616; Wed, 18 Aug 2021 07:19:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        NICE_REPLY_A,SPF_FAIL,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.0
Received: from [192.168.0.104] (unknown [103.199.158.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: neeraju)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 30ADFC4338F;
        Wed, 18 Aug 2021 07:19:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 30ADFC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
Subject: Re: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
To:     David Chen <david.chen@nutanix.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
References: <CO1PR02MB8489A10983A22C72447EEB5C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
 <YRq81jcZIH5+/ZpB@kroah.com>
 <CO1PR02MB8489899CD7101180B2759D9C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
From:   Neeraj Upadhyay <neeraju@codeaurora.org>
Message-ID: <d30dc0f2-1a91-b0fb-cb59-aed0696bfa33@codeaurora.org>
Date:   Wed, 18 Aug 2021 12:49:11 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CO1PR02MB8489899CD7101180B2759D9C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/17/2021 3:32 AM, David Chen wrote:
> 
> 
>> -----Original Message-----
>> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Sent: Monday, August 16, 2021 12:31 PM
>> To: David Chen <david.chen@nutanix.com>
>> Cc: stable@vger.kernel.org; Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com>; neeraju@codeaurora.org
>> Subject: Re: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
>>
>> On Mon, Aug 16, 2021 at 07:19:34PM +0000, David Chen wrote:
>>> Hi Greg,
>>>
>>> We recently hit a hung task timeout issue in synchronize_rcu_expedited on
>> 4.14 branch.
>>> The issue seems to be identical to the one described in `fd6bc19d7676
>>> rcu: Fix missed wakeup of exp_wq waiters` Can we backport it to 4.14 and
>> 4.19 branch?
>>> The patch doesn't apply cleanly, but it should be trivial to resolve,
>>> just do this
>>>
>>> -		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(rsp-
>>> expedited_sequence) & 0x3]);
>>> +		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(s) & 0x3]);
>>>
>>> I don't know if we should do it for 4.9, because the handling of sequence
>> number is a bit different.
>>
>> Please provide a working backport, me hand-editing patches does not scale,
>> and this way you get the proper credit for backporting it (after testing it).
> 
> Sure, appended at the end.
> 
>>
>> You have tested, this, right?
> 
> I don't have a good repro for the original issue, so I only ran rcutorture and
> some basic work load test to see if anything obvious went wrong.
> 
>>
>> thanks,
>>
>> greg k-h
> 
> --------
> 
>  From 307a212335fe143027e3a9f7a9d548beead7ba33 Mon Sep 17 00:00:00 2001
> From: Neeraj Upadhyay <neeraju@codeaurora.org>
> Date: Tue, 19 Nov 2019 03:17:07 +0000
> Subject: [PATCH] rcu: Fix missed wakeup of exp_wq waiters
> 
> [ Upstream commit fd6bc19d7676a060a171d1cf3dcbf6fd797eb05f ]
> 
> Tasks waiting within exp_funnel_lock() for an expedited grace period to
> elapse can be starved due to the following sequence of events:
> 
> 1.	Tasks A and B both attempt to start an expedited grace
> 	period at about the same time.	This grace period will have
> 	completed when the lower four bits of the rcu_state structure's
> 	->expedited_sequence field are 0b'0100', for example, when the
> 	initial value of this counter is zero.	Task A wins, and thus
> 	does the actual work of starting the grace period, including
> 	acquiring the rcu_state structure's .exp_mutex and sets the
> 	counter to 0b'0001'.
> 
> 2.	Because task B lost the race to start the grace period, it
> 	waits on ->expedited_sequence to reach 0b'0100' inside of
> 	exp_funnel_lock(). This task therefore blocks on the rcu_node
> 	structure's ->exp_wq[1] field, keeping in mind that the
> 	end-of-grace-period value of ->expedited_sequence (0b'0100')
> 	is shifted down two bits before indexing the ->exp_wq[] field.
> 
> 3.	Task C attempts to start another expedited grace period,
> 	but blocks on ->exp_mutex, which is still held by Task A.
> 
> 4.	The aforementioned expedited grace period completes, so that
> 	->expedited_sequence now has the value 0b'0100'.  A kworker task
> 	therefore acquires the rcu_state structure's ->exp_wake_mutex
> 	and starts awakening any tasks waiting for this grace period.
> 
> 5.	One of the first tasks awakened happens to be Task A.  Task A
> 	therefore releases the rcu_state structure's ->exp_mutex,
> 	which allows Task C to start the next expedited grace period,
> 	which causes the lower four bits of the rcu_state structure's
> 	->expedited_sequence field to become 0b'0101'.
> 
> 6.	Task C's expedited grace period completes, so that the lower four
> 	bits of the rcu_state structure's ->expedited_sequence field now
> 	become 0b'1000'.
> 
> 7.	The kworker task from step 4 above continues its wakeups.
> 	Unfortunately, the wake_up_all() refetches the rcu_state
> 	structure's .expedited_sequence field:
> 
> 	wake_up_all(&rnp->exp_wq[rcu_seq_ctr(rcu_state.expedited_sequence) & 0x3]);

Minor: On these kernel versions, we had rsp pointer, per RCU flavor, 
whereas post 4.20 kernel versions, we have a single rcu_state. So, the 
commit message can be corrected here. The  functionality is mostly
unchanged and same fix is applicable.

> 
> 	This results in the wakeup being applied to the rcu_node
> 	structure's ->exp_wq[2] field, which is unfortunate given that
> 	Task B is instead waiting on ->exp_wq[1].
> 
> On a busy system, no harm is done (or at least no permanent harm is done).
> Some later expedited grace period will redo the wakeup.  But on a quiet
> system, such as many embedded systems, it might be a good long time before
> there was another expedited grace period.  On such embedded systems,
> this situation could therefore result in a system hang.
> 
> This issue manifested as DPM device timeout during suspend (which
> usually qualifies as a quiet time) due to a SCSI device being stuck in
> _synchronize_rcu_expedited(), with the following stack trace:
> 
> 	schedule()
> 	synchronize_rcu_expedited()
> 	synchronize_rcu()
> 	scsi_device_quiesce()
> 	scsi_bus_suspend()
> 	dpm_run_callback()
> 	__device_suspend()
> 
> This commit therefore prevents such delays, timeouts, and hangs by
> making rcu_exp_wait_wake() use its "s" argument consistently instead of
> refetching from rcu_state.expedited_sequence.
> 
> Fixes: 3b5f668e715b ("rcu: Overlap wakeups with next expedited grace period")
> Signed-off-by: Neeraj Upadhyay <neeraju@codeaurora.org>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> Signed-off-by: David Chen <david.chen@nutanix.com>
> ---
>   kernel/rcu/tree_exp.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
> index 46d61b597731..f90d10c1c3c8 100644
> --- a/kernel/rcu/tree_exp.h
> +++ b/kernel/rcu/tree_exp.h
> @@ -534,7 +534,7 @@ static void rcu_exp_wait_wake(struct rcu_state *rsp, unsigned long s)
>   			spin_unlock(&rnp->exp_lock);
>   		}
>   		smp_mb(); /* All above changes before wakeup. */
> -		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(rsp->expedited_sequence) & 0x3]);
> +		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(s) & 0x3]);
>   	}
>   	trace_rcu_exp_grace_period(rsp->name, s, TPS("endwake"));
>   	mutex_unlock(&rsp->exp_wake_mutex);
> 


Acked-by: Neeraj Upadhyay <neeraju@codeaurora.org>

-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a 
member of the Code Aurora Forum, hosted by The Linux Foundation
