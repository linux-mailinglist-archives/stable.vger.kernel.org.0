Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33BD413194F
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 21:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgAFUZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 15:25:57 -0500
Received: from mail.efficios.com ([167.114.142.138]:41062 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgAFUZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 15:25:57 -0500
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id BFD7C6947AB;
        Mon,  6 Jan 2020 15:25:55 -0500 (EST)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id 2F-bFRMgNF7F; Mon,  6 Jan 2020 15:25:55 -0500 (EST)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 5E4F96947A8;
        Mon,  6 Jan 2020 15:25:55 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 5E4F96947A8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1578342355;
        bh=UfT90aPpZTfS01AKwYyrbPfjuYNcs0SApfxVeTqI5Cs=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=T4Mv9jQ1RfyBp798o2jbvCJwabSOTLzANGDIP8XuegR+7/Ne7tRzo4rXQu0NpveI9
         ZRwKtqVgGPCvLubSOV79yEWIwhjKQQwS5ctAtCzhLNL+OIT2c6oAtdrPHvlmT9BRmZ
         HDJJEnDLIm1UuFya+MnxwBW+f3GBpxQd+jPg1a4pCjrY90HQSbL0E618PFzZrfvy9q
         mEmeAIsvzcSFdpodZ5gcxwxVXdkd4M1SPuI3MJqmSbXBkccP8LdEhM1dSEf/KfzNtL
         AUKhA0K3yFV3aK9/kJ4xDmBOIfwq4Fp6q78Y0QzcoATCAPJfLQn1eDIeplkxdRDVQD
         SYBajgDaEVgJQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id x6xmiU9tpFXV; Mon,  6 Jan 2020 15:25:55 -0500 (EST)
Received: from mail02.efficios.com (mail02.efficios.com [167.114.142.138])
        by mail.efficios.com (Postfix) with ESMTP id 47A2469479C;
        Mon,  6 Jan 2020 15:25:55 -0500 (EST)
Date:   Mon, 6 Jan 2020 15:25:55 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Florian Weimer <fw@deneb.enyo.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        paulmck <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api <linux-api@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Neel Natu <neelnatu@google.com>
Message-ID: <2129265980.1223.1578342355079.JavaMail.zimbra@efficios.com>
In-Reply-To: <87a7709ydd.fsf@mid.deneb.enyo.de>
References: <20191220201207.17389-1-mathieu.desnoyers@efficios.com> <87imman36g.fsf@mid.deneb.enyo.de> <173832695.14381.1576875253374.JavaMail.zimbra@efficios.com> <875zian2a2.fsf@mid.deneb.enyo.de> <669061171.14506.1576876500152.JavaMail.zimbra@efficios.com> <1025393027.850.1578337717165.JavaMail.zimbra@efficios.com> <87a7709ydd.fsf@mid.deneb.enyo.de>
Subject: Re: [PATCH for 5.5 1/2] rseq: Fix: Clarify rseq.h UAPI rseq_cs
 memory reclaim requirements
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.142.138]
X-Mailer: Zimbra 8.8.15_GA_3894 (ZimbraWebClient - FF71 (Linux)/8.8.15_GA_3890)
Thread-Topic: rseq: Fix: Clarify rseq.h UAPI rseq_cs memory reclaim requirements
Thread-Index: c967+RLKmUJMckznywTx3eJqdLS1Gg==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Jan 6, 2020, at 2:30 PM, Florian Weimer fw@deneb.enyo.de wrote:

> * Mathieu Desnoyers:
> 
>> Just to clarify: should the discussion here prevent the UAPI
>> documentation change from being merged into the Linux kernel ? Our
>> discussion seems to be related to integration of rseq into glibc,
>> rather than the kernel UAPI per se.
> 
> I still think that clearing rseq_cs upon exit from the function that
> contains the sequence is good practice, and the UAPI header should
> mention that.

My understanding is that a UAPI header should document what is strictly
required (here, clearing rseq_cs before unmapping the memory area
containing the rseq_cs structure or the code). Documenting a "best
practice" would AFAIU belong to a man page and not a UAPI header.

I'm adding Michael Kerrisk in CC in case he has an opinion on this
matter.

> For glibc, if I recall correctly, we decided against doing anything in
> dlclose to deal with this issue (remapping new code in an existing
> rseq area) because it would need updating all threads, not just the
> thread calling dlclose.  That's why we're punting this to
> applications and why I think the UAPI header should mention this.

Nothing prevents us from implementing a clever scheme in the future,
e.g. as a new membarrier command, that could be invoked from dlclose()
when it becomes available.

By documenting only the basic requirement in the UAPI header (do not
use-after-free) and not providing a "best practice" (which is not so good
performance-wise), we can then let the man page state the best practices,
and update them as new system call commands are implemented.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
