Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187EA249839
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 10:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHSI1y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 04:27:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgHSI1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 04:27:53 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8306C20738;
        Wed, 19 Aug 2020 08:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597825673;
        bh=xkrOW1eiodxf6e55kbWanf+5qeDDwj1oob7ZKgc2bX4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fbutXiAaMlm/H9YbBaBayrJHz65E2rmbWgxqxuAdUYACLzGZK6lRujSRmkHg6MBoT
         jkPxKn2GE0mKyF++r7fCvlhIJSNDTQcpbUNxAFV9oO15FPtc09hhUgH/hTAm9Ueu5o
         xhq/e/O3Z4iYD7DK533RIYA+NrqZcpkxHyKy533M=
Date:   Wed, 19 Aug 2020 09:27:47 +0100
From:   Will Deacon <will@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Yang Shi <shy828301@gmail.com>, Yu Xu <xuyu@linux.alibaba.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [v3 PATCH] mm/memory.c: skip spurious TLB flush for retried page
 fault
Message-ID: <20200819082747.GA17345@willie-the-truck>
References: <20200815043041.132195-1-shy828301@gmail.com>
 <CAHk-=wjbaptBBKYS+XdCgdjU_RbFPaAd8EkT6_Un6CtNmezt9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjbaptBBKYS+XdCgdjU_RbFPaAd8EkT6_Un6CtNmezt9A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 18, 2020 at 12:01:43PM -0700, Linus Torvalds wrote:
> On Mon, Aug 17, 2020 at 2:04 PM Yang Shi <shy828301@gmail.com> wrote:
> >
> > We could just skip the spurious TLB flush to mitigate the regression.
> 
> Ok, this patch I will apply.

Cheers.

> I still hope that arm64 fixes (maybe already fixed) their spurious TLB
> function, and I think we should rename it to make sure everybody
> understands it's local, but in the meantime this patch hides the
> regression and isn't wrong.

I'll look at it for 5.10.

Will
