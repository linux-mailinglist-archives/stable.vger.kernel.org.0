Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F194277FD1
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 07:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgIYFPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 01:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:36452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgIYFPW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 01:15:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EB4E208B6;
        Fri, 25 Sep 2020 05:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601010922;
        bh=gITMPtp3ExGoR3BhfhY50MjD89uQRzuT6Ejx0okOPWc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PZZ2q2Nxa5IGI0xpxs/ZehF7omKALs2rdztMvg9fngAJlEuuoh8bRZvKl9DjjuvD6
         UJSAUI4tUaud99FbRAH+wVJycVWbtPxo9PiJlOWnLmzZx56EjM9X7qHcg+Dvn4Wk9q
         fQqGD0coIZQ9p/iYrMU1Fo2MnHPp9iAInEM3sItQ=
Date:   Fri, 25 Sep 2020 07:15:18 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        LTP List <ltp@lists.linux.it>, lkft-triage@lists.linaro.org
Subject: Re: [stable 4.19] [PANIC]: tracing: Centralize preemptirq
 tracepoints and unify their usage
Message-ID: <20200925051518.GA605188@kroah.com>
References: <20180823023839.GA13343@shao2-debian>
 <20180828195347.GA228832@joelaf.mtv.corp.google.com>
 <CA+G9fYtV_sjTKLMXWMP0w0A-H+p+CN-uVJ6dvHovDy9epJZ2GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtV_sjTKLMXWMP0w0A-H+p+CN-uVJ6dvHovDy9epJZ2GQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 25, 2020 at 10:13:05AM +0530, Naresh Kamboju wrote:
> >From stable rc 4.18.1 onwards to today's stable rc 4.19.147
> 
> There are two problems  while running LTP tracing tests
> 1) kernel panic  on i386, qemu_i386, x86_64 and qemu_x86_64 [1]
> 2) " segfault at 0 ip " and "Code: Bad RIP value" on x86_64 and qemu_x86_64 [2]
> Please refer to the full test logs from below links.
> 
> The first bad commit found by git bisect.
>    commit: c3bc8fd637a9623f5c507bd18f9677effbddf584
>    tracing: Centralize preemptirq tracepoints and unify their usage
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

So this also is reproducable in 5.4 and Linus's tree right now?

Or are newer kernels working fine?

thanks,

greg k-h
