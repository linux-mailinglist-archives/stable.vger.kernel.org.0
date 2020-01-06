Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6351131870
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 20:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbgAFTOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 14:14:50 -0500
Received: from mail.efficios.com ([167.114.142.138]:39458 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbgAFTOu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 14:14:50 -0500
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id AF423694663;
        Mon,  6 Jan 2020 14:14:48 -0500 (EST)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id y5UfXTZOn8ja; Mon,  6 Jan 2020 14:14:48 -0500 (EST)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 18393694660;
        Mon,  6 Jan 2020 14:14:48 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 18393694660
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1578338088;
        bh=K3pne9AU9Zzqsb9l2TuNdNRJkqv0aH5vxyEQ5Haccnk=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=IUEcCq/brI8TE7E0DMhYPZgI5GekB4eVe8vaNGkrPeIlhuXWVV28HarV5vLIouREp
         gBYukY4vAAr6LLafGjNQ1okwb0bG82t/6Btl5GSSS2GHHLbzzP4pLFUHn3GMtKrsTu
         YSaFUP0MmRANWxXOsLvjKmN9jskh4xBXm1DCwOm0lznl5CFUjO5oCBezy33d6Aqi4h
         dTXwDttX0sT9Bj9ijw47eIUZUx007AY68TuLVNsuL98wvRNyIrbqPh1POwVT7kIzxC
         1o/X4SJnaiNbtqToDausna9jgoFFFh/rguUCA8CRY2/PK/N3v+8n6bfaGKFlxKf2l1
         GcdMQhtTrFYLw==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id mcgmQ7JAuRAw; Mon,  6 Jan 2020 14:14:48 -0500 (EST)
Received: from mail02.efficios.com (mail02.efficios.com [167.114.142.138])
        by mail.efficios.com (Postfix) with ESMTP id F1D5C694655;
        Mon,  6 Jan 2020 14:14:47 -0500 (EST)
Date:   Mon, 6 Jan 2020 14:14:47 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        linux-tip-commits <linux-tip-commits@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>,
        stable <stable@vger.kernel.org>
Message-ID: <1732849021.873.1578338087928.JavaMail.zimbra@efficios.com>
In-Reply-To: <1460494267.15769.1577399533860.JavaMail.zimbra@efficios.com>
References: <20191211161713.4490-2-mathieu.desnoyers@efficios.com> <157727033331.30329.17206832903007175600.tip-bot2@tip-bot2> <20191225113932.GD18098@zn.tnic> <1460494267.15769.1577399533860.JavaMail.zimbra@efficios.com>
Subject: Re: [tip: core/urgent] rseq: Reject unknown flags on rseq
 unregister
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.142.138]
X-Mailer: Zimbra 8.8.15_GA_3894 (ZimbraWebClient - FF71 (Linux)/8.8.15_GA_3890)
Thread-Topic: core/urgent] rseq: Reject unknown flags on rseq unregister
Thread-Index: BWaWCVXVOJYWOEoxqutpfh8/ngqLyH0/K6rf
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Dec 26, 2019, at 5:32 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> ----- On Dec 25, 2019, at 6:39 AM, Borislav Petkov bp@alien8.de wrote:
> 
>> On Wed, Dec 25, 2019 at 10:38:53AM -0000, tip-bot2 for Mathieu Desnoyers wrote:
>>> The following commit has been merged into the core/urgent branch of tip:
>>> 
>>> Commit-ID:     66528a4575eee9f5a5270219894ab6178f146e84
>>> Gitweb:
>>> https://git.kernel.org/tip/66528a4575eee9f5a5270219894ab6178f146e84
>>> Author:        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>>> AuthorDate:    Wed, 11 Dec 2019 11:17:11 -05:00
>>> Committer:     Ingo Molnar <mingo@kernel.org>
>>> CommitterDate: Wed, 25 Dec 2019 10:41:20 +01:00
>>> 
>>> rseq: Reject unknown flags on rseq unregister
>>> 
>>> It is preferrable to reject unknown flags within rseq unregistration
>>> rather than to ignore them. It is an oversight caused by the fact that
>>> the check for unknown flags is after the rseq unregister flag check.
>>> 
>>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>>> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Link:
>>> https://lkml.kernel.org/r/20191211161713.4490-2-mathieu.desnoyers@efficios.com
>>> Signed-off-by: Ingo Molnar <mingo@kernel.org>
>>> ---
>>>  kernel/rseq.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>> 
>>> diff --git a/kernel/rseq.c b/kernel/rseq.c
>>> index 27c48eb..a4f86a9 100644
>>> --- a/kernel/rseq.c
>>> +++ b/kernel/rseq.c
>>> @@ -310,6 +310,8 @@ SYSCALL_DEFINE4(rseq, struct rseq __user *, rseq, u32,
>>> rseq_len,
>>>  	int ret;
>>>  
>>>  	if (flags & RSEQ_FLAG_UNREGISTER) {
>>> +		if (flags & ~RSEQ_FLAG_UNREGISTER)
>>> +			return -EINVAL;
>>>  		/* Unregister rseq for current thread. */
>>>  		if (current->rseq != rseq || !current->rseq)
>>>  			return -EINVAL;
>> 
>> Cc: stable perhaps?
> 
> This could indeed be a candidate for stable, even though it's just a stricter
> checking of unknown flags (returning an error rather than ignoring them).
> 
> Adding stable in CC here.

For the records, I had stable in CC in my original patch submission. The stable CC has
been stripped when it was merged into the tip tree.

Thanks,

Mathieu

> 
> Thanks,
> 
> Mathieu
> 
> 
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
