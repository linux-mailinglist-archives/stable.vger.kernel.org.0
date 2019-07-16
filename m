Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C99EA6B22C
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 01:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbfGPXBu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 19:01:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728601AbfGPXBu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jul 2019 19:01:50 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1E39217D9;
        Tue, 16 Jul 2019 23:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563318110;
        bh=gqQEwmHd1yxDRwfLXu+bVVrEKACbD5yUXlHKJaILc9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VtPTwu3ByIQEDM3frewZAX0g44H7Ddv2CwLOUxUJixQjQsRKG5s5ioFQANSXTMnzu
         6z4afHz5P2l8nwOTr2ORYmXZcNH3cDuZcAB6vQ/vUqtNMfG+3Nlx+eFu/nu+6U2kfj
         aHB7R9N4D6rcA0Kf0fQz3GTb5uNmKAc8b4vwSr5Q=
Date:   Wed, 17 Jul 2019 08:01:47 +0900
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     stable@vger.kernel.org
Subject: Re: Backport request
Message-ID: <20190716230147.GA23117@kroah.com>
References: <alpine.DEB.2.21.1907162318380.1767@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1907162318380.1767@nanos.tec.linutronix.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 17, 2019 at 12:08:38AM +0200, Thomas Gleixner wrote:
> Folks!
> 
> There are more and more people worried about these usually harmless
> warnings:
> 
> 	do_IRQ: 0.39 No irq handler for vector
> 
> It took a while to figure out why that happens and why it is harmless for
> most interrupts, but there is also a real issue hidden for level type
> IOAPIC interrupts.
> 
> The following commits in Linus tree are addressing the issue:
> 
>  b7107a67f0d1 ("x86/irq: Handle spurious interrupt after shutdown gracefully")
>  dfe0cf8b51b0 ("x86/ioapic: Implement irq_get_irqchip_state() callback")
>  62e0468650c3 ("genirq: Add optional hardware synchronization for shutdown")
>  1d21f2af8571 ("genirq: Fix misleading synchronize_irq() documentation")
>  4001d8e8762f ("genirq: Delay deactivation in free_irq()")
> 
> There is another one which makes sense to be backported:
> 
>  f8a8fe61fec8 ("x86/irq: Seperate unused system vectors from spurious entry again")
> 
> These should go back to 4.19, but not farther.
> 
> They apply cleanly to 5.1 and 5.2. A backport to 4.19 is attached.

All now queued up, thanks for the backports!

greg k-h
