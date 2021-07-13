Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E483C77A8
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 22:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbhGMUIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 16:08:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60903 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229944AbhGMUIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 16:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626206710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BwIcVGw+0Tpi8eO5Of2PjsJTRkujnsB8Az7JZMygUWk=;
        b=ZjLd9+zKtA9dwRPMMGQHhO+1sX4rS3JCx4DHjR/iK2ZN3Bo3pvcEelxA3LPmefzw2WFBfb
        hIzpVt04U5p3IrPSYljDVaCfpshpQ3fj/46M7Ex0nJgyvo96dDt1wu1uvOG3uzJoXv/IHU
        NB3A3LTkCKhvMWPvKRgy4YeHPWOoOHE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-YgwaO3hbPQGURZ0vw_K-2g-1; Tue, 13 Jul 2021 16:05:09 -0400
X-MC-Unique: YgwaO3hbPQGURZ0vw_K-2g-1
Received: by mail-qk1-f200.google.com with SMTP id x2-20020ae9e6420000b02903b8853778c2so4395739qkl.18
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 13:05:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BwIcVGw+0Tpi8eO5Of2PjsJTRkujnsB8Az7JZMygUWk=;
        b=l5SShE5MqwC/NrbUQQ/Mi1xMI4mBUus9xiZE7ONaLjEZhdpRU9hUFY81O5XFHbgZ1N
         ZSs9zwSsXYzD1CX13uSuSZ+keGqVjfMCeNN7cDqZpewGagY1o0+d/cCqq4a0Oij47S91
         IUg56QFH0PrdnuvJPHwQDAXOq8hbK+j85XpfzVR3TXXYbE4CQqjiY5zHMJ1db1qOTUI4
         yGsMKdJkHwnZE0exmD9iBhmIy0bcdpZ5inI78GXuiMEJfPrLKwtT/F2PBFQfeDDPaY9H
         6J1Bs/Yj7jJbkWICtfg43Uy63FRu/bu4qBvxJOeiZrdfzowVlYUXyWemtyDOCRLUw5KE
         u6/g==
X-Gm-Message-State: AOAM5339WGZtJszyRYnv0MTKCy2m2sX/581h5zA52dN1/5WkwgtXpXc8
        Ic/OAbqTOfKbK6A7N/qaDkR1FP5VAVCrX79EHlzSlpgKq2UmD1e7FMDFQzf0usnqCLGIte+7JC1
        DitR9C5GEEgm5o0k2
X-Received: by 2002:a05:620a:1998:: with SMTP id bm24mr5884471qkb.319.1626206708845;
        Tue, 13 Jul 2021 13:05:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwDe3cstj1D1Ox/lILQfJ1rWd/L6BO4hUZ+6gTyqkymvtoSEiAmhV61ahK+2haONOa4F1/U3g==
X-Received: by 2002:a05:620a:1998:: with SMTP id bm24mr5884447qkb.319.1626206708504;
        Tue, 13 Jul 2021 13:05:08 -0700 (PDT)
Received: from loberhel ([2600:6c64:4e7f:cee0:729d:61b6:700c:6b56])
        by smtp.gmail.com with ESMTPSA id x7sm1514955qtw.24.2021.07.13.13.05.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Jul 2021 13:05:07 -0700 (PDT)
Message-ID: <e4cfb11631b00cb45b385be6048d5b39d301f433.camel@redhat.com>
Subject: Re: [PATCH] usb: hcd: Revert
 306c54d0edb6ba94d39877524dddebaad7770cf2: Try MSI interrupts on PCI devices
From:   Laurence Oberman <loberman@redhat.com>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-usb@vger.kernel.org, andriy.shevchenko@linux.intel.com,
        stable@vger.kernel.org, emilne@redhat.com, djeffery@redhat.com,
        apanagio@redhat.com, torez@redhat.com
Date:   Tue, 13 Jul 2021 16:05:06 -0400
In-Reply-To: <20210713191548.GD355405@rowland.harvard.edu>
References: <1626202242-14984-1-git-send-email-loberman@redhat.com>
         <20210713191548.GD355405@rowland.harvard.edu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2021-07-13 at 15:15 -0400, Alan Stern wrote:
> On Tue, Jul 13, 2021 at 02:50:42PM -0400, Laurence Oberman wrote:
> > Customers have been reporting that the I/O is radically being
> > slowed down to HPE virtual USB ILO served DVD images during
> > installation.
> > 
> > Lots of investigation by the Red Hat lab has found that the issue
> > is 
> > because MSI edge interrupts do not work properly for these 
> > ILO USB devices.
> > We start fast and then drop to polling mode and its unusable.
> > 
> > The issue exists currently upstream on 5.13 as tested by Red Hat, 
> > and reverting the mentioned patch corrects this upstream.
> > 
> > David Jeffery has this explanation:
> > 
> > The problem with the patch turning on MSI appears to be that the
> > ehci 
> > driver (and possibly other usb controller types too) wasn't written
> > to
> > support edge-triggered interrupts.
> > The ehci_irq routine appears to be written in such a way that it
> > will 
> > be racy with multiple interrupt source bits.
> > With a level-triggered interrupt, it gets called another time and
> > cleans 
> > up other interrupt sources.
> > But with MSI edge, the interrupt state staying high results in no 
> > new interrupt and ehci has to run based on polling.
> > 
> > static irqreturn_t ehci_irq (struct usb_hcd *hcd)
> > {
> > ...
> >         status = ehci_readl(ehci, &ehci->regs->status);
> > 
> >         /* e.g. cardbus physical eject */
> >         if (status == ~(u32) 0) {
> >                 ehci_dbg (ehci, "device removed\n");
> >                 goto dead;
> >         }
> > 
> >         /*
> >          * We don't use STS_FLR, but some controllers don't like it
> > to
> >          * remain on, so mask it out along with the other status
> > bits.
> >          */
> >         masked_status = status & (INTR_MASK | STS_FLR);
> > 
> >         /* Shared IRQ? */
> >         if (!masked_status || unlikely(ehci->rh_state ==
> > EHCI_RH_HALTED)) {
> >                 spin_unlock_irqrestore(&ehci->lock, flags);
> >                 return IRQ_NONE;
> >         }
> > 
> >         /* clear (just) interrupts */
> >         ehci_writel(ehci, masked_status, &ehci->regs->status);
> > ...
> > 
> > ehci_irq() reads the interrupt status register and then writes the
> > active 
> > interrupt-related bits back out to ack the interrupt cause.
> > But with an edge interrupt, this is racy as another source of
> > interrupt 
> > could be raised by ehci between the read and the write reaching
> > the 
> > hardware. 
> > e.g.  If STS_IAA was set during the initial read, but some other
> > bit like 
> > STS_INT gets raised by the hardware between the read and the write
> > to the 
> > interrupt status register, the interrupt signal state won't drop.
> > The interrupt state says high, and since it is now edged triggered
> > with 
> > MSI, no new invocation of the interrupt handler gets triggered.
> 
> Wouldn't it be better to change these other PCI drivers by adding 
> proper MSI support?  I don't know what would be involved, but 
> presumably it wouldn't be very hard.  (Just run the handler in a
> loop 
> until all the interrupt status bits are off?)
> 
> Alan Stern
> 

Hello

Agree with you that is a big hammer approach,  but it's such a key
piece of the massive number of HPE servers out there and we have many
affected customers.

While I did all the test work and discovery etc, I am definitely not a
USB kernel guy very often, I spend most of my time in storage.
I will listen for the other replies to see how the folks who know the
subsystem better than I would want this reolved.

Thanks
Laurence



