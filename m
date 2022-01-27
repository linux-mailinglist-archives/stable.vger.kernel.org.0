Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15EA449EDEB
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 23:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbiA0WEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 17:04:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59422 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbiA0WEy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 17:04:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 398FB61B9D;
        Thu, 27 Jan 2022 22:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115A3C340E4;
        Thu, 27 Jan 2022 22:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643321093;
        bh=OCMhPepfNlqqIKJ9ceHBXpYvB0I3SkXhWI8hV5NsDGw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qKEYqCPwHq+39RawR3rniKdPI2ejXwIeS/5waCpcyv5OZH07bDbT+SSgAgVDxhsr9
         lWNpW82O4qUSBHo0TQW+fsmEIRheYgByT2qRUM0x1OppChA3yOrlOyKfTL3jZtCXDW
         L+/xlkgvLmNYR6s9NzIK+vPyiwJ7WtZgVi1knMtc=
Date:   Thu, 27 Jan 2022 14:04:51 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     1vier1@web.de, arnd@arndb.de, cgel.zte@gmail.com,
        chi.minghao@zte.com.cn, dbueso@suse.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        shakeelb@google.com, stable@vger.kernel.org, unixbhaskar@gmail.com,
        urezki@gmail.com, vvs@virtuozzo.com, zealci@zte.com.cn
Subject: Re: +
 mm-utilc-make-kvfree-safe-for-calling-while-holding-spinlocks.patch added
 to -mm tree
Message-Id: <20220127140451.f6590de4579cefdf75dfd329@linux-foundation.org>
In-Reply-To: <5ae2873f-527f-9769-a606-4ff6786c0fcc@colorfullife.com>
References: <20220127025542.F0GTnQlNA%akpm@linux-foundation.org>
        <5ae2873f-527f-9769-a606-4ff6786c0fcc@colorfullife.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 27 Jan 2022 16:45:58 +0100 Manfred Spraul <manfred@colorfullife.com> wrote:

> Hi Andrew,
> 
> On 1/27/22 03:55, akpm@linux-foundation.org wrote:
> > The patch titled
> >       Subject: mm/util.c: make kvfree() safe for calling while holding spinlocks
> > has been added to the -mm tree.  Its filename is
> >       mm-utilc-make-kvfree-safe-for-calling-while-holding-spinlocks.patch
> >
> > This patch should soon appear at
> >      https://ozlabs.org/~akpm/mmots/broken-out/mm-utilc-make-kvfree-safe-for-calling-while-holding-spinlocks.patch
> > and later at
> >      https://ozlabs.org/~akpm/mmotm/broken-out/mm-utilc-make-kvfree-safe-for-calling-while-holding-spinlocks.patch
> 
> Please drop and replace with
> 
> https://marc.info/?l=linux-kernel&m=164132744522325&w=2
> 

Ah, OK, that's been in -mm and -next for a month.  I didn't send it
upstream because it wasn't clear to me which way we're going.  I'll add
cc:stable and send it to Linus this week or next.

