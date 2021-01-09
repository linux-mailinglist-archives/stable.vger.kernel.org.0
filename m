Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD182EFEB6
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 10:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbhAIJER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 04:04:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726051AbhAIJER (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Jan 2021 04:04:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62ECA2388A;
        Sat,  9 Jan 2021 09:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610183017;
        bh=udDi5/EaX2PUaSQ7vZd0QUE/sR8DVbAJiDN9aaOcnwM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dVsEYWYXzoiknTki1XuIJDGDjr/RDOH4DmmF5tmENvKRA1J1K0ZZDuzdWok9sDuIS
         4NtFhQA2I2tTjYGDOrdxYrqpKwKtq2lrTUcaPr+LBr+QC7wQPW59iZOdDepYi+a0xt
         /2XMGufIlDB1HUNvRxXs7ltz2T160Z8uzl56vD1M=
Date:   Sat, 9 Jan 2021 10:03:33 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: Re: [RFC PATCH 1/8] rcu: Remove superfluous rdp fetch
Message-ID: <X/lxZTsaMCV0yd9U@kroah.com>
References: <20210109020536.127953-1-frederic@kernel.org>
 <20210109020536.127953-2-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210109020536.127953-2-frederic@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 09, 2021 at 03:05:29AM +0100, Frederic Weisbecker wrote:
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar<mingo@kernel.org>
> ---
>  kernel/rcu/tree.c | 1 -
>  1 file changed, 1 deletion(-)

I know I will not take patches without any changelog comments, maybe
other maintainers are more lax.  Please write something real.

And as for sending this to stable@vger, here's my form letter:

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
