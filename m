Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78285246D98
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387629AbgHQRFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731373AbgHQRFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 13:05:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95E8F2067C;
        Mon, 17 Aug 2020 17:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597683903;
        bh=GUsArLbL02qpHoztHYo42iM7UEhUrFu2gzZLc6e45Xw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WrOmmGSWsfm1b1BGZwv55E9QTH0wydsd48MODLzbQ6ilDmmo3YgzJtjKI+0yIYKGW
         4/vjd/CYFEzjL2JyUrIzKmX9IyMR3GzVgcAU3zKJ9uLHzW7I3fKNma7b+3OZcqhni/
         a3WHDpUR1MxN+7CX5zZi9N2c0hMY5I4xBPkfwyeU=
Date:   Mon, 17 Aug 2020 19:05:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, jan.kiszka@siemens.com,
        jbeulich@suse.com, linux-kernel@vger.kernel.org,
        marc.zyngier@arm.com, stable@vger.kernel.org,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        pedro.principeza@canonical.com
Subject: Re: [PATCH 4.19 35/47] x86/irq: Seperate unused system vectors from
 spurious entry again
Message-ID: <20200817170522.GA795695@kroah.com>
References: <c2b7a96a-122e-bdec-7368-d54700a55915@canonical.com>
 <20200817162156.GA715236@kroah.com>
 <a2788632-5690-932b-90de-14bd9cabedec@canonical.com>
 <20200817164924.GA721399@kroah.com>
 <14968c46-ad8f-fbdf-88d6-0ded954534c9@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14968c46-ad8f-fbdf-88d6-0ded954534c9@canonical.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 17, 2020 at 01:59:00PM -0300, Guilherme G. Piccoli wrote:
> On 17/08/2020 13:49, Greg KH wrote:
> > [...]
> >> I'm sorry, I hoped the subject + thread would suffice heh
> > 
> > There is no thread here :(
> > 
> 
> Wow, that's odd. I've sent with In-Reply-To, I'd expect it'd get
> threaded with the original message. Looking in lore archive [1], it
> seems my first message wasn't threaded but the others were...apologies
> for that, not sure what happened...

reply to is fine, but how do you know what my email client has (hint,
not a copy of 1.5 years of history sitting around in it at the
moment...)  So there is no "thread" here as far as it is concerned...

Anyway, not a big deal, just properly quote emails in the future, that's
good to get used to no matter what :)

> >> So, the mainline commit is: f8a8fe61fec8 ("x86/irq: Seperate unused
> >> system vectors from spurious entry again") [0]. The backport to 4.19
> >> stable tree has the following id: fc6975ee932b .
> > 
> > Wow, over 1 1/2 years old, can you remember individual patches that long
> > ago?
> > 
> > Anyway, did you try to backport the patch to older kernels to see if it
> > was possible and could work?
> > 
> > If so, great, please feel free to submit it to the
> > stable@vger.kernel.org list and I will be glad to pick it up.
> > 
> 
> I'm working on it, it is feasible. But I'm seeking here, in this
> message, what is the reason it wasn't backported for pre-4.19

Try reading the stable mailing list archives, again, you are asking
about a patch 1.5 years ago.  I can't remember information about patches
sent _yesterday_ given the quantity we go through...

thanks,

greg k-h
