Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2A9412AF4F
	for <lists+stable@lfdr.de>; Thu, 26 Dec 2019 23:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfLZWcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Dec 2019 17:32:16 -0500
Received: from mail.efficios.com ([167.114.142.138]:56804 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfLZWcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Dec 2019 17:32:16 -0500
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id A887E691136;
        Thu, 26 Dec 2019 17:32:14 -0500 (EST)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id Wgk_AfSnlKw7; Thu, 26 Dec 2019 17:32:14 -0500 (EST)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 0A349691131;
        Thu, 26 Dec 2019 17:32:14 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 0A349691131
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1577399534;
        bh=Vu4bJnahkfBAh27AEmQtcTGKd5gsUZyTGrhSMJ/F/ag=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=Y1MGTqeVknIAi0F/zMV9W7UG2DVSzalXonDMzMwwmwh/rWHhNh1k4kXb5R/b4vPyz
         XiwtZ/9uPCVYndQ6yBrsfKbtQG4Dloa/w37EJDx1RJnE2XYwqTmaZFixtxfYADNu2h
         ITm+XaGv25I4zlcWuKc97v+OV1hhNW4t9ocBQoLxijHmteRX0JUCarguowrBo1A2AK
         9T1ConwwCSWWkrPhNDJm7LEzh1FeJWbi1DIGd12+guYH14sXXI/IBY6dMW8PV9bDZ7
         xDpA4i8J/uEi5TEGevZjMecyr86VyxzFSMwfvF+TUq6ecEYsk4kjfx5p638Iwi1dh5
         8ROaLE5OypWUA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id KMkEVBw-_XO2; Thu, 26 Dec 2019 17:32:13 -0500 (EST)
Received: from mail02.efficios.com (mail02.efficios.com [167.114.142.138])
        by mail.efficios.com (Postfix) with ESMTP id DF1F769111B;
        Thu, 26 Dec 2019 17:32:13 -0500 (EST)
Date:   Thu, 26 Dec 2019 17:32:13 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        linux-tip-commits <linux-tip-commits@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>,
        stable <stable@vger.kernel.org>
Message-ID: <1460494267.15769.1577399533860.JavaMail.zimbra@efficios.com>
In-Reply-To: <20191225113932.GD18098@zn.tnic>
References: <20191211161713.4490-2-mathieu.desnoyers@efficios.com> <157727033331.30329.17206832903007175600.tip-bot2@tip-bot2> <20191225113932.GD18098@zn.tnic>
Subject: Re: [tip: core/urgent] rseq: Reject unknown flags on rseq
 unregister
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.142.138]
X-Mailer: Zimbra 8.8.15_GA_3888 (ZimbraWebClient - FF71 (Linux)/8.8.15_GA_3890)
Thread-Topic: core/urgent] rseq: Reject unknown flags on rseq unregister
Thread-Index: BWaWCVXVOJYWOEoxqutpfh8/ngqLyA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Dec 25, 2019, at 6:39 AM, Borislav Petkov bp@alien8.de wrote:

> On Wed, Dec 25, 2019 at 10:38:53AM -0000, tip-bot2 for Mathieu Desnoyers wrote:
>> The following commit has been merged into the core/urgent branch of tip:
>> 
>> Commit-ID:     66528a4575eee9f5a5270219894ab6178f146e84
>> Gitweb:
>> https://git.kernel.org/tip/66528a4575eee9f5a5270219894ab6178f146e84
>> Author:        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> AuthorDate:    Wed, 11 Dec 2019 11:17:11 -05:00
>> Committer:     Ingo Molnar <mingo@kernel.org>
>> CommitterDate: Wed, 25 Dec 2019 10:41:20 +01:00
>> 
>> rseq: Reject unknown flags on rseq unregister
>> 
>> It is preferrable to reject unknown flags within rseq unregistration
>> rather than to ignore them. It is an oversight caused by the fact that
>> the check for unknown flags is after the rseq unregister flag check.
>> 
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Link:
>> https://lkml.kernel.org/r/20191211161713.4490-2-mathieu.desnoyers@efficios.com
>> Signed-off-by: Ingo Molnar <mingo@kernel.org>
>> ---
>>  kernel/rseq.c | 2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git a/kernel/rseq.c b/kernel/rseq.c
>> index 27c48eb..a4f86a9 100644
>> --- a/kernel/rseq.c
>> +++ b/kernel/rseq.c
>> @@ -310,6 +310,8 @@ SYSCALL_DEFINE4(rseq, struct rseq __user *, rseq, u32,
>> rseq_len,
>>  	int ret;
>>  
>>  	if (flags & RSEQ_FLAG_UNREGISTER) {
>> +		if (flags & ~RSEQ_FLAG_UNREGISTER)
>> +			return -EINVAL;
>>  		/* Unregister rseq for current thread. */
>>  		if (current->rseq != rseq || !current->rseq)
>>  			return -EINVAL;
> 
> Cc: stable perhaps?

This could indeed be a candidate for stable, even though it's just a stricter
checking of unknown flags (returning an error rather than ignoring them).

Adding stable in CC here.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
