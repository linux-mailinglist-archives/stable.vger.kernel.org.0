Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13EC2CB993
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 10:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387860AbgLBJpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 04:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387427AbgLBJpU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 04:45:20 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8232AC0613CF
        for <stable@vger.kernel.org>; Wed,  2 Dec 2020 01:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FWI/6FrPa3DPJJUbWIggKsIGyIACmTVTl8+xuWWnwqs=; b=m3twXeXH5bdpzBcsOpduvQKHi8
        nBhV4Z4KNaI111PpTye8/YoJWgz4me8YAwrg+TCBYpeIRREALztnKKsWwrE62lbti9mutMUCcqLcJ
        7MlzDfVVE9HJbHyZJ6fek2ZNXwl/FMuPufIAgx0wDk1mWZOVQdMx8txnzasuJsHuM4zyAnSefvsqj
        90TZwd7u+cLvU7TqUSRpY3bPskorHIVjkvo2QXGkqOGSW9b3gw3YeXNr8M1SEsUHZmb8piCipDmyn
        qEfcXNna6l58vH+9dQD8jto2kYVP+xnMgy6PSs7Ntm+8xo0FScBYzg48cHcV51pNcsopk3jHX7+tt
        NhiG0gPw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kkOgY-0005UI-UJ; Wed, 02 Dec 2020 09:44:31 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DD2BB30018A;
        Wed,  2 Dec 2020 10:44:28 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BDBC32CD0DA66; Wed,  2 Dec 2020 10:44:28 +0100 (CET)
Date:   Wed, 2 Dec 2020 10:44:28 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Vincent Guittot <vincent.guittot@linaro.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        "Guilherme G. Piccoli" <gpiccoli@canonical.com>,
        Sasha Levin <sashal@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Ingo Molnar <mingo@redhat.com>, Phil Auld <pauld@redhat.com>,
        Tao Zhou <zohooouoto@zoho.com.cn>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Gavin Guo <gavin.guo@canonical.com>,
        nivedita.singhvi@canonical.com, halves@canonical.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Re: FAILED: patch "[PATCH] sched/fair: Fix unthrottle_cfs_rq() for
 leaf_cfs_rq list" failed to apply to 5.4-stable tree
Message-ID: <20201202094428.GC3040@hirez.programming.kicks-ass.net>
References: <d3188913-ddb8-7198-8483-47d3031b01fe@canonical.com>
 <e87e517b-7f97-66ba-4f17-718330910a7b@canonical.com>
 <X8dHZP78hCVlb3n9@kroah.com>
 <CAKfTPtDTQsaQbB3OrAD5Q=0d5oULu6TD18+WQ1b-S05n46WeyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDTQsaQbB3OrAD5Q=0d5oULu6TD18+WQ1b-S05n46WeyQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 02, 2020 at 09:21:19AM +0100, Vincent Guittot wrote:
> On Wed, 2 Dec 2020 at 08:49, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Tue, Dec 01, 2020 at 12:03:18PM -0300, Guilherme G. Piccoli wrote:
> > > Hey Sasha, sorry to annoy again, but maybe Peter is very busy - wouldn't
> > > be possible maybe to get that merged after a review from Ben or Ingo? I
> > > see them in the MAINTAINERS file, specially Ben as CONFIG_CFS_BANDWIDTH
> > > maintainer.
> > >
> > > I understand the confidence in this patch is relatively high, since it's
> > > a backport from the author, right?
> >
> > I still want to see an ack from the maintainer please.
> 
> SCHEDULER

> M: Vincent Guittot <vincent.guittot@linaro.org> (SCHED_NORMAL)

Vincent is also the one that knows that leaf code best, he did the
backport, you're not going to get better than that.

