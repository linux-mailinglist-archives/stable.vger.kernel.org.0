Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86AAAF945
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 11:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfIKJnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 05:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbfIKJnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 05:43:43 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A95E2067B;
        Wed, 11 Sep 2019 09:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568195022;
        bh=vjeeUTBmC8jj2qIZWanHOOc7lNc0TdW2gTy2YWtIGtE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rFOe35iSNJYS5pD+D3hx27jVWPoTxaROQyOFzrBYVHGGRnRhl+VmD6FZCjMEPnPCe
         1OTe4IiDEtesZXO/ps95Msd+5YPfKbfT98a31DtQOQTa4KIgj9JGVoSr9/DmaFkymP
         kMlChTHK7JadM7q/s5yooMWqQfUu+XUR6eZWEzwQ=
Date:   Wed, 11 Sep 2019 05:43:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     christophe.leroy@c-s.fr, Chris.Packham@alliedtelesis.co.nz,
        mpe@ellerman.id.au, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] powerpc/64e: Drop stale call to
 smp_processor_id() which" failed to apply to 4.19-stable tree
Message-ID: <20190911094339.GL2012@sasha-vm>
References: <156811481474161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <156811481474161@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 10, 2019 at 12:26:54PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From b9ee5e04fd77898208c51b1395fa0b5e8536f9b6 Mon Sep 17 00:00:00 2001
>From: Christophe Leroy <christophe.leroy@c-s.fr>
>Date: Thu, 8 Aug 2019 12:48:26 +0000
>Subject: [PATCH] powerpc/64e: Drop stale call to smp_processor_id() which
> hangs SMP startup
>
>Commit ebb9d30a6a74 ("powerpc/mm: any thread in one core can be the
>first to setup TLB1") removed the need to know the cpu_id in
>early_init_this_mmu(), but the call to smp_processor_id() which was
>marked __maybe_used remained.
>
>Since commit ed1cd6deb013 ("powerpc: Activate CONFIG_THREAD_INFO_IN_TASK")
>thread_info cannot be reached before MMU is properly set up.
>
>Drop this stale call to smp_processor_id() which makes SMP hang when
>CONFIG_PREEMPT is set.
>
>Fixes: ebb9d30a6a74 ("powerpc/mm: any thread in one core can be the first to setup TLB1")
>Fixes: ed1cd6deb013 ("powerpc: Activate CONFIG_THREAD_INFO_IN_TASK")

Hi Greg,

I *think* we should have our scripts parse multiple "Fixes:" tags as &&
rather than ||.

--
Thanks,
Sasha
