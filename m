Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D904D246EA2
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730440AbgHQReJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:34:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388973AbgHQQtG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:49:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7515720674;
        Mon, 17 Aug 2020 16:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597682946;
        bh=JlMazASo7t7j+lxiY0wrEYqEoBjyCQ5tvz9EhUeBBqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W6ooD0DRmdvqTgXKYpVJV6wDmkDHrOPWIkDevMC0CC9xZdc6kVJn+LyRL13dc9Swm
         NJSYX+iFMkCvpmyuII6JN5/ePhPHLlrhgBLmft8I/dP9uQ5rHyuVxDVTuwr2XETXLI
         IWZd/YApfXK9CX9HRA7AEms0jry9G+CPrJLICSPQ=
Date:   Mon, 17 Aug 2020 18:49:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     jan.kiszka@siemens.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, marc.zyngier@arm.com,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        pedro.principeza@canonical.com
Subject: Re: [PATCH 4.19 35/47] x86/irq: Seperate unused system vectors from
 spurious entry again
Message-ID: <20200817164924.GA721399@kroah.com>
References: <c2b7a96a-122e-bdec-7368-d54700a55915@canonical.com>
 <20200817162156.GA715236@kroah.com>
 <a2788632-5690-932b-90de-14bd9cabedec@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2788632-5690-932b-90de-14bd9cabedec@canonical.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 01:43:14PM -0300, Guilherme G. Piccoli wrote:
> On 17/08/2020 13:21, Greg KH wrote:
> > On Mon, Aug 17, 2020 at 12:36:25PM -0300, Guilherme G. Piccoli wrote:
> >> Hi Greg / Thomas and all involved here. First, apologies for
> >> necro-bumping this thread, but I'm working a backport of this patch to
> >> kernel 4.15 (Ubuntu) and then I noticed we have it on stable, but only
> >> in 4.19+.
> >>
> >> Since the fixes tag presents an old commit (since ~3.19), I'm curious if
> >> we have a special reason to not have it on long-term stables, like 4.9
> >> or 4.14. It's a subtle portion of arch code, so I'm afraid I didn't see
> >> something that prevents its backport for previous versions.
> > 
> > What is the git commit id of this patch you are referring to, you didn't
> > provide any context here :(
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> I'm sorry, I hoped the subject + thread would suffice heh

There is no thread here :(

> So, the mainline commit is: f8a8fe61fec8 ("x86/irq: Seperate unused
> system vectors from spurious entry again") [0]. The backport to 4.19
> stable tree has the following id: fc6975ee932b .

Wow, over 1 1/2 years old, can you remember individual patches that long
ago?

Anyway, did you try to backport the patch to older kernels to see if it
was possible and could work?

If so, great, please feel free to submit it to the
stable@vger.kernel.org list and I will be glad to pick it up.

thanks,

greg k-h
