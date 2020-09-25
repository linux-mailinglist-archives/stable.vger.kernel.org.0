Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC28A278CB8
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 17:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728410AbgIYPaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 11:30:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:57664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbgIYPaw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 11:30:52 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 272CF2075F;
        Fri, 25 Sep 2020 15:30:51 +0000 (UTC)
Date:   Fri, 25 Sep 2020 11:30:49 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        LTP List <ltp@lists.linux.it>, lkft-triage@lists.linaro.org
Subject: Re: [stable 4.19] [PANIC]: tracing: Centralize preemptirq
 tracepoints and unify their usage
Message-ID: <20200925113049.4c10c864@oasis.local.home>
In-Reply-To: <20200925151245.GA3180934@kroah.com>
References: <20180823023839.GA13343@shao2-debian>
        <20180828195347.GA228832@joelaf.mtv.corp.google.com>
        <CA+G9fYtV_sjTKLMXWMP0w0A-H+p+CN-uVJ6dvHovDy9epJZ2GQ@mail.gmail.com>
        <20200925051518.GA605188@kroah.com>
        <CA+G9fYuokHUBwNkTs=gWqCHxj80gg+RetU4pRd+uLP7gNas4KQ@mail.gmail.com>
        <20200925105458.567d0bf4@oasis.local.home>
        <20200925105914.7de88d27@oasis.local.home>
        <20200925110706.6654954b@oasis.local.home>
        <20200925151245.GA3180934@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Sep 2020 17:12:45 +0200
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> > Specifically, commits:
> > 
> > a0d14b8909de55139b8702fe0c7e80b69763dcfb ("x86/mm, tracing: Fix CR2 corruption")
> > 6879298bd0673840cadd1fb36d7225485504ceb4 ("x86/entry/64: Prevent clobbering of saved CR2 value")
> > b8f70953c1251d8b16276995816a95639f598e70 ("x86/entry/32: Pass cr2 to do_async_page_fault()")
> > 
> > (which are in 5.4 but not 4.19)
> > 
> > But again, is this too intrusive. There was a workaround that was
> > original proposed, but Peter didn't want any more band-aids, and did
> > the restructuring, but as you can see from the two other patches, it
> > makes it a bit more high risk.  
> 
> If those are known to work, why can't I take them as-is?

If they apply without tweaks, I say "Go for it" ;-)

My worry is that they may have other unknown dependencies. And I only
looked at what was applied between 4.19 and 5.4 mainline. I haven't
looked at what else may have been backported to fix the above three
commits.

-- Steve
