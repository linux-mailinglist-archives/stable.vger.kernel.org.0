Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE37AB3CC2
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 16:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfIPOmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 10:42:22 -0400
Received: from mail.efficios.com ([167.114.142.138]:42984 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfIPOmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 10:42:21 -0400
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 580962BCB71;
        Mon, 16 Sep 2019 10:42:20 -0400 (EDT)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id k0unBvUJKu5S; Mon, 16 Sep 2019 10:42:20 -0400 (EDT)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 0BB612BCB6B;
        Mon, 16 Sep 2019 10:42:20 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 0BB612BCB6B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1568644940;
        bh=io4ddQ8pvBKTts4C+Pm2ajLWnUquU+K01gUuLLAUxmo=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=MvDZcbksjf3PuxeX8NRveA+kG1cR6p3iij/YxwCHnDNbpP3kehJKlskrNucrgFCQl
         GjukTZUHb82vEtV8PiWxlMbUUUx1NoMilVjcx+0+bsD80itO46/BEhDTMvxcZn6Hoi
         RKO4u3W67ovFuP2xQC7rFrA4thFUTCc+8b94SgIZz/HrAw3LVkNdWZ6XAZtlqDl6/b
         G+YOrbX8mCTy0DdlMVqANuUpKNZm8Z3EnpMeqEi3R+LLxXXyuAvMXbhFNXW5NkL/Ld
         Lofot3IpSpK0GbzgPTeM0O/FMztay8RY0rar4ndZXy542FofaVVQEsiGCMWpVnu77w
         Xc5XJp266bJ1A==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id ZM3MuJlBHuiv; Mon, 16 Sep 2019 10:42:19 -0400 (EDT)
Received: from mail02.efficios.com (mail02.efficios.com [167.114.142.138])
        by mail.efficios.com (Postfix) with ESMTP id DEF6E2BCB60;
        Mon, 16 Sep 2019 10:42:19 -0400 (EDT)
Date:   Mon, 16 Sep 2019 10:42:19 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        "Rantala, Tommi T." <tommi.t.rantala@nokia.com>,
        Peter Zijlstra <peterz@infradead.org>,
        paulmck <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        stable <stable@vger.kernel.org>
Message-ID: <1109991919.5481.1568644939856.JavaMail.zimbra@efficios.com>
In-Reply-To: <20190914194716.ED5D020692@mail.kernel.org>
References: <20190913151220.3105-3-mathieu.desnoyers@efficios.com> <20190914194716.ED5D020692@mail.kernel.org>
Subject: Re: [PATCH for 5.3 3/3] rseq/selftests: Fix: Namespace gettid() for
 compatibility with glibc 2.30
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.142.138]
X-Mailer: Zimbra 8.8.15_GA_3847 (ZimbraWebClient - FF69 (Linux)/8.8.15_GA_3847)
Thread-Topic: rseq/selftests: Fix: Namespace gettid() for compatibility with glibc 2.30
Thread-Index: DD+Mue4dYmH4wOVQj914v5FtBbUeaw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Sep 14, 2019, at 3:47 PM, Sasha Levin sashal@kernel.org wrote:

> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.2.14, v4.19.72, v4.14.143, v4.9.192,
> v4.4.192.
> 
> v5.2.14: Build OK!
> v4.19.72: Build OK!
> v4.14.143: Failed to apply! Possible dependencies:
>    c960e9909d33 ("rseq/selftests: Provide parametrized tests")
> 
> v4.9.192: Failed to apply! Possible dependencies:
>    c960e9909d33 ("rseq/selftests: Provide parametrized tests")
> 
> v4.4.192: Failed to apply! Possible dependencies:
>    c960e9909d33 ("rseq/selftests: Provide parametrized tests")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

rseq was merged into 4.18, so none of those patches are needed prior to that
kernel version.

This applies to all 3 rseq patches.

Thanks,

Mathieu


> 
> --
> Thanks,
> Sasha

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
