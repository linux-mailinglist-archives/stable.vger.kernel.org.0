Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5639111B22E
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387605AbfLKP2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:28:24 -0500
Received: from mail.efficios.com ([167.114.142.138]:42708 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387598AbfLKP2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 10:28:24 -0500
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id 19FBD687A25;
        Wed, 11 Dec 2019 10:28:23 -0500 (EST)
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id S2y0w6rP8V8C; Wed, 11 Dec 2019 10:28:22 -0500 (EST)
Received: from localhost (ip6-localhost [IPv6:::1])
        by mail.efficios.com (Postfix) with ESMTP id BEE16687A22;
        Wed, 11 Dec 2019 10:28:22 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com BEE16687A22
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1576078102;
        bh=C/zOP3f6ebD7H+mSDMI0JNByhqooFL3Swlt0/L2X6Do=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=fI7e0oFhCsMe0HdFoK2xk3T+97tuol9PV00GjT/d1BVAGuRAJ4WqxWhGSjpWN4ENO
         H5uNFdAO8oDsEHFbKbljUW7NQw9VTP8ZDNO2iaSeD547H4CaMQI2zvZFbXxTB5XOKU
         KqaTY+DPdnnmZRWvZ0jSWpUixRvc18R6JBiCQZGqUDIKwQ+pKEAFnEeHHAQK9aptGY
         u56CPBcDKaqs5UjOqIruZcXfICo7SQyuvltN+H4Jp3WMlinmWcslox245IfDa7jQEI
         TYLbO4NTMWG5Hd0qm+P89+TpYPfAC/SiAaOnBG+JlRVm46DM36EX2NvxMLqyouaglj
         q99ZH5qSdQPKg==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([IPv6:::1])
        by localhost (mail02.efficios.com [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id J6LO01X8haIM; Wed, 11 Dec 2019 10:28:22 -0500 (EST)
Received: from mail02.efficios.com (mail02.efficios.com [167.114.142.138])
        by mail.efficios.com (Postfix) with ESMTP id 9E8D3687A13;
        Wed, 11 Dec 2019 10:28:22 -0500 (EST)
Date:   Wed, 11 Dec 2019 10:28:22 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Shuah Khan <skhan@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        paulmck <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api <linux-api@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Message-ID: <211848436.2172.1576078102568.JavaMail.zimbra@efficios.com>
In-Reply-To: <20190917182959.16333-1-mathieu.desnoyers@efficios.com>
References: <20190917182959.16333-1-mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH for 5.4 0/3] Restartable Sequences Fixes
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [167.114.142.138]
X-Mailer: Zimbra 8.8.15_GA_3888 (ZimbraWebClient - FF70 (Linux)/8.8.15_GA_3890)
Thread-Topic: Restartable Sequences Fixes
Thread-Index: a0Atf/Ifhh0gqkseXVi/YvaGwLW1oQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thomas,

I thought those rseq fixes posted in September were in the -tip tree, but it
seems that they never made it to mainline.

Now Shuah Khan noticed the issue with gettid() compatibility with glibc
2.30+. This series contained that fix.

Should I re-post it, or is this series on track to get into mainline
at some point ?

Thanks,

Mathieu

----- On Sep 17, 2019, at 2:29 PM, Mathieu Desnoyers mathieu.desnoyers@efficios.com wrote:

> Hi,
> 
> Here is a small set of rseq fixes aiming Linux 5.4. Those should be
> backported to stable kernels >= 4.18.
> 
> Thanks,
> 
> Mathieu
> 
> Mathieu Desnoyers (3):
>  rseq: Fix: Reject unknown flags on rseq unregister
>  rseq: Fix: Unregister rseq for clone CLONE_VM
>  rseq/selftests: Fix: Namespace gettid() for compatibility with glibc
>    2.30
> 
> include/linux/sched.h                     |  4 ++--
> kernel/rseq.c                             |  2 ++
> tools/testing/selftests/rseq/param_test.c | 18 ++++++++++--------
> 3 files changed, 14 insertions(+), 10 deletions(-)
> 
> --
> 2.17.1

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
