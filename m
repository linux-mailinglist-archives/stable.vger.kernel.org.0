Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D60719801D
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 17:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbgC3Pr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 11:47:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729319AbgC3PrZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 11:47:25 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CA0C205ED;
        Mon, 30 Mar 2020 15:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585583244;
        bh=uCOB2RxGkKZJ2kGlkudfqrciclfPrUzm9PlJJ1d8OJ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wU/LjrQHEAXeMk+hT7VboBqNpE6FL9xH42V+EsHPA22kV2aWS7KHAmRdWAHciKWF2
         mEd8MLBw6HZ9zytqKm7+5YjxxVEnLJV70npXZobccMU04GOZjPp3Lk4vC/1T3XPuQg
         IG67GrqlYsdYje1+SHvnqEd4+KxmNsVWFW7O9Hpo=
Date:   Mon, 30 Mar 2020 11:47:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     yuboxie@microsoft.com, Tianyu.Lan@microsoft.com,
        tglx@linutronix.de, vkuznets@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] clocksource/drivers/hyper-v: Make sched
 clock return" failed to apply to 5.5-stable tree
Message-ID: <20200330154723.GH4189@sasha-vm>
References: <158557045893151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158557045893151@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 02:14:18PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.5-stable tree.
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
>From 749da8ca978f19710aba496208c480ad42d37f79 Mon Sep 17 00:00:00 2001
>From: Yubo Xie <yuboxie@microsoft.com>
>Date: Thu, 26 Mar 2020 19:11:59 -0700
>Subject: [PATCH] clocksource/drivers/hyper-v: Make sched clock return
> nanoseconds correctly
>
>The sched clock read functions return the HV clock (100ns granularity)
>without converting it to nanoseconds.
>
>Add the missing conversion.
>
>Fixes: bd00cd52d5be ("clocksource/drivers/hyperv: Add Hyper-V specific sched clock function")
>Signed-off-by: Yubo Xie <yuboxie@microsoft.com>
>Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>Cc: stable@vger.kernel.org
>Link: https://lkml.kernel.org/r/20200327021159.31429-1-Tianyu.Lan@microsoft.com

We don't have 0af3e137c144 ("clocksource/drivers/hyper-v: Untangle
stimers and timesync from clocksources") on 5.5 and older. I've adjusted
this patch and queued it for 5.5 and 5.4.

-- 
Thanks,
Sasha
