Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D033278172
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 09:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbgIYHZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 03:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727204AbgIYHZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Sep 2020 03:25:25 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854ECC0613D3
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 00:25:25 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id e23so838003vsk.2
        for <stable@vger.kernel.org>; Fri, 25 Sep 2020 00:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9+u6pjC7pRB1K9gjeMWKj3lZ/9RhhBMJjz0Kr1AOtzs=;
        b=znz84rc2KTxMeuZHBWoFa4B0qNPH/4nMwsP+S61V9IatDeRCRbBjXCWmOV7byKF1Ky
         bGXKIXbQQctoF47LltBYdfHbE2uiREyLYy9UhpNNnvid+BRkL1sIaQG8L1wpb4Beips4
         bLArDC1gja85x2EyHWr9tAj/QhRNmk13a/gDQ7c1or9dEfw7Ms2f5/4JE4m2MXFR4cOl
         xHJI2gMFnqOnTaF3B/e5JtCFSAscq63Be9G3eEXpIhND/l4UGyYCyuxDfyK2k0O+1uiK
         tWRVcCmbOJ7AqOmtNYTudR+d3/AF9bXMQgfRUZDbctTyziK/+wBrDxrsEBAFbgXgKu8M
         G7nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9+u6pjC7pRB1K9gjeMWKj3lZ/9RhhBMJjz0Kr1AOtzs=;
        b=SVnhYWWLI01n7SfAxHhxVuVpHuxXbEhjIAZ4whRmi1+jUEq7DGBggJt8P1LXPeATE4
         U0Hw+fRpZS6pZ/owpBcfHxtLF2NJqnW1pMJa6ILWkv35dDU0XmNR3l+K28B+ZZF4NgMQ
         0nK8BeK+/8UTSlHrJxKAF6st+ZTdUyRoEA2yh++Vf8fRQqa3wg0UniPElzH4jjOzRJiM
         V8aTj5PueJO+yc8zU9sasTbHHrJNttkgwx/5gn/P8nBIOc0d9UsdZJn4tCFUWsEnjdWO
         kuE2YGZOaxf/qV1XfhXcxJyuEzKGGbDP55BQXG4WPEcbw9ZXhBV8OUTDMpFp8aSpgamk
         LpGg==
X-Gm-Message-State: AOAM530QP//uiv6tBqtTYXnNOXg2t4nwoXbXY/8pggVzfnu2BxdFtzWa
        48uX0o+C/PZ2VHSz30Rt3xdREg3ofIzucOyRQrSIUA==
X-Google-Smtp-Source: ABdhPJxm91UI/6425cQgEhSBX27qS9BjdpzuZURqe/ddUA6VRpeq7VAcm07HpZ9q7gSb+uP7goG3e5shfB26CcIpzfE=
X-Received: by 2002:a05:6102:310f:: with SMTP id e15mr1937206vsh.39.1601018724645;
 Fri, 25 Sep 2020 00:25:24 -0700 (PDT)
MIME-Version: 1.0
References: <20180823023839.GA13343@shao2-debian> <20180828195347.GA228832@joelaf.mtv.corp.google.com>
 <CA+G9fYtV_sjTKLMXWMP0w0A-H+p+CN-uVJ6dvHovDy9epJZ2GQ@mail.gmail.com> <20200925051518.GA605188@kroah.com>
In-Reply-To: <20200925051518.GA605188@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 25 Sep 2020 12:55:13 +0530
Message-ID: <CA+G9fYuokHUBwNkTs=gWqCHxj80gg+RetU4pRd+uLP7gNas4KQ@mail.gmail.com>
Subject: Re: [stable 4.19] [PANIC]: tracing: Centralize preemptirq tracepoints
 and unify their usage
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        LTP List <ltp@lists.linux.it>, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Sep 2020 at 10:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Sep 25, 2020 at 10:13:05AM +0530, Naresh Kamboju wrote:
> > >From stable rc 4.18.1 onwards to today's stable rc 4.19.147
> >
> > There are two problems  while running LTP tracing tests
> > 1) kernel panic  on i386, qemu_i386, x86_64 and qemu_x86_64 [1]
> > 2) " segfault at 0 ip " and "Code: Bad RIP value" on x86_64 and qemu_x86_64 [2]
> > Please refer to the full test logs from below links.
> >
> > The first bad commit found by git bisect.
> >    commit: c3bc8fd637a9623f5c507bd18f9677effbddf584
> >    tracing: Centralize preemptirq tracepoints and unify their usage
> >
> > Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>
> So this also is reproducable in 5.4 and Linus's tree right now?

No.
The reported issues are not reproducible on 5.4, 5.8 and Linus's tree.

>
> Or are newer kernels working fine?

No.
There are different issues while testing LTP tracing on 5.4, 5.8 and
Linus 's 5.9.

NETDEV WATCHDOG: eth0 (igb): transmit queue 2 timed out
WARNING: CPU: 1 PID: 331 at net/sched/sch_generic.c:442 dev_watchdog+0x4c7/0x4d0
https://lore.kernel.org/stable/CA+G9fYtS_nAX=sPV8zTTs-nOdpJ4uxk9sqeHOZNuS4WLvBcPGg@mail.gmail.com/

I see this on 5.4, 5.8 and Linus 's 5.9.
rcu: INFO: rcu_sched self-detected stall on CPU
? ftrace_graph_caller+0xc0/0xc0
https://lore.kernel.org/stable/CA+G9fYsdTLRj55_bvod8Sf+0zvK0RRMp5+FeJcOx5oAcAKOGXA@mail.gmail.com/T/#u

>
> thanks,
>
> greg k-h

- Naresh
