Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C377D213537
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 09:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgGCHkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 03:40:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725891AbgGCHkV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jul 2020 03:40:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92A03206B6;
        Fri,  3 Jul 2020 07:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593762021;
        bh=93w9+i+IaO6NzhJCK0/eWazfc8scMFK/UwVaQVfiLvQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YIMkNTFqhu1IwD8Nn5tAIY3P4/t8VD8TT9yz3A69VrbVljqzvH7r652mcJzxBOmVF
         KwDJ1OJxxJ1zH+zsIpnKVmYhMDJsPBra0tKqq3zlJdvbgD6on2GPfJGBwEpsCYyFr1
         c1xiHB0Ly+4Em+v6gZ1mClkcH/jpRiABfQjItrFo=
Date:   Fri, 3 Jul 2020 09:40:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [FOR-STABLE-3.9+] sched/rt: Show the 'sched_rr_timeslice'
 SCHED_RR timeslice tuning knob in milliseconds
Message-ID: <20200703074025.GA2390868@kroah.com>
References: <ffdfb849a11b9cd66e0aded2161869e36aec7fc0.1593757471.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffdfb849a11b9cd66e0aded2161869e36aec7fc0.1593757471.git.viresh.kumar@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 03, 2020 at 12:54:04PM +0530, Viresh Kumar wrote:
> From: Shile Zhang <shile.zhang@nokia.com>
> 
> We added the 'sched_rr_timeslice_ms' SCHED_RR tuning knob in this commit:
> 
>   ce0dbbbb30ae ("sched/rt: Add a tuning knob to allow changing SCHED_RR timeslice")
> 
> ... which name suggests to users that it's in milliseconds, while in reality
> it's being set in milliseconds but the result is shown in jiffies.
> 
> This is obviously confusing when HZ is not 1000, it makes it appear like the
> value set failed, such as HZ=100:
> 
>   root# echo 100 > /proc/sys/kernel/sched_rr_timeslice_ms
>   root# cat /proc/sys/kernel/sched_rr_timeslice_ms
>   10
> 
> Fix this to be milliseconds all around.
> 
> Cc: <stable@vger.kernel.org> # v3.9+
> Signed-off-by: Shile Zhang <shile.zhang@nokia.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Link: http://lkml.kernel.org/r/1485612049-20923-1-git-send-email-shile.zhang@nokia.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h
