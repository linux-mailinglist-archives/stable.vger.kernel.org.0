Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CFE278B9F
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 17:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729094AbgIYO71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 10:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728731AbgIYO7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 10:59:18 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5648C20715;
        Fri, 25 Sep 2020 14:59:16 +0000 (UTC)
Date:   Fri, 25 Sep 2020 10:59:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <20200925105914.7de88d27@oasis.local.home>
In-Reply-To: <20200925105458.567d0bf4@oasis.local.home>
References: <20180823023839.GA13343@shao2-debian>
        <20180828195347.GA228832@joelaf.mtv.corp.google.com>
        <CA+G9fYtV_sjTKLMXWMP0w0A-H+p+CN-uVJ6dvHovDy9epJZ2GQ@mail.gmail.com>
        <20200925051518.GA605188@kroah.com>
        <CA+G9fYuokHUBwNkTs=gWqCHxj80gg+RetU4pRd+uLP7gNas4KQ@mail.gmail.com>
        <20200925105458.567d0bf4@oasis.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 25 Sep 2020 10:54:58 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:


> The crash looks like its cr3 related, which I believe Peter Zijlstra

s/cr3/cr2/

-- Steve


> did a restructuring of that code to not let it be an issue anymore.
> I'll have to look deeper. The rework may be too intrusive to backport,
> but we do have other work arounds for this issue if that would be
> acceptable for backporting.
> 
