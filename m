Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C993224B0C7
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 10:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725834AbgHTILS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 04:11:18 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:32915 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725824AbgHTILK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 04:11:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 70A9B5C01CE;
        Thu, 20 Aug 2020 04:11:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 20 Aug 2020 04:11:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=Y2Fsdqj3wWOWg08c2W0U+7BaidJ
        BOSxzvpfpgC1LEfE=; b=c/Jpig9MDGhyON+QBShC+t/zxzHqwrYTL64V3/fr9yL
        K5tAFDpSUNCvprRV6C+RQ1kbA+pSQ6TXoBWuwFjtEp7Vl+H4mdeuJ8JcKOY8/7h1
        o3LDmd0kEpR1T3ts9VVkP1hR2l7gUmSWv/i2IyXGfqKHEIkwSrCm+jhnbWelRQKR
        0XktcUYH3kqT+ORCazDEm0rgc0p+zaiAEmiMgFVlYO6bJSoPyyWbQCCejObmXawk
        MhcAzCleps5buMr3z8xlr3Cg2kBLxmijcZvr1/ncH9MqvqMS9VEdQe6cVnyHxkX6
        wezmMaOkQUWxNjKEi4la6ZajZqqPsYta0kujScL6cxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Y2Fsdq
        j3wWOWg08c2W0U+7BaidJBOSxzvpfpgC1LEfE=; b=W4gr3so+kq75Cq4XjI6Ljm
        gIxPcCB6/5KL8QpC7jzf1/Rlu84E5a8kUPFaM8Turlxopc2mEHNKylhwjFGSGXKK
        2+gYizDosxR57+JOv5V0RWxobyS6PfmZcCf41xgnaH5e/RasJU3yC9G24jW+4Sio
        ammvhRJIbfTPtY7OcKsveAkhAmecywvBt+JkOYy0SYw0IzX3yJeYojn5uJXr13r8
        Dx+45dYagYaWCtPqiHmJ8h4aMhR58HYWFcig8Spq6fVxju44nx4RFSAhIb/6fvi1
        u7A1hADnsB9UH5ZyR3bbaWDHQzx51f2vEmWW6TmabTDfXlFM1A/Oqbjwg1Sq3/pw
        ==
X-ME-Sender: <xms:GzA-XzkbP4j1cC0D2aOt3BQUxi1RUJ-tf5AeePkqQHK3Emm7MkEkhQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtledgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:GzA-X23p1YM32SB9upKwLu-IiTpP4CrrGFU1wk1sg07HaIHHpmAatA>
    <xmx:GzA-X5qpqP9YowQ4lqBCE_h1K7s5GXdiqBoQjEHzRdS9YQLWP10v0Q>
    <xmx:GzA-X7n-C45BMiomR4r1l6dGjhE7tY7HVsIUud92Sl56iKaRfc9L8g>
    <xmx:GzA-X-j8ErqWB7vdvLCYmMQw_jG7VwngBeKdpR-Vzsnnl1zG-W0UGg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E3E0630600A3;
        Thu, 20 Aug 2020 04:11:06 -0400 (EDT)
Date:   Thu, 20 Aug 2020 10:11:28 +0200
From:   Greg KH <greg@kroah.com>
To:     Frank van der Linden <fllinden@amazon.com>
Cc:     stable@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 4.14 1/2] genirq/affinity: Handle affinity setting on
 inactive interrupts correctly
Message-ID: <20200820081128.GD4049659@kroah.com>
References: <20200810201144.20618-1-fllinden@amazon.com>
 <20200819095537.GB2558675@kroah.com>
 <20200819160550.GA11709@dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819160550.GA11709@dev-dsk-fllinden-2c-c1893d73.us-west-2.amazon.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 19, 2020 at 04:05:51PM +0000, Frank van der Linden wrote:
> On Wed, Aug 19, 2020 at 11:55:37AM +0200, Greg KH wrote:
> > On Mon, Aug 10, 2020 at 08:11:43PM +0000, Frank van der Linden wrote:
> > > From: Thomas Gleixner <tglx@linutronix.de>
> > >
> > > commit baedb87d1b53532f81b4bd0387f83b05d4f7eb9a upstream.
> > >
> > > Setting interrupt affinity on inactive interrupts is inconsistent when
> > > hierarchical irq domains are enabled. The core code should just store the
> > > affinity and not call into the irq chip driver for inactive interrupts
> > > because the chip drivers may not be in a state to handle such requests.
> > >
> > > X86 has a hacky workaround for that but all other irq chips have not which
> > > causes problems e.g. on GIC V3 ITS.
> > >
> > > Instead of adding more ugly hacks all over the place, solve the problem in
> > > the core code. If the affinity is set on an inactive interrupt then:
> > >
> > >     - Store it in the irq descriptors affinity mask
> > >     - Update the effective affinity to reflect that so user space has
> > >       a consistent view
> > >     - Don't call into the irq chip driver
> > >
> > > This is the core equivalent of the X86 workaround and works correctly
> > > because the affinity setting is established in the irq chip when the
> > > interrupt is activated later on.
> > >
> > > Note, that this is only effective when hierarchical irq domains are enabled
> > > by the architecture. Doing it unconditionally would break legacy irq chip
> > > implementations.
> > >
> > > For hierarchial irq domains this works correctly as none of the drivers can
> > > have a dependency on affinity setting in inactive state by design.
> > >
> > > Remove the X86 workaround as it is not longer required.
> > >
> > > Fixes: 02edee152d6e ("x86/apic/vector: Ignore set_affinity call for inactive interrupts")
> > 
> > Why is this needed for 4.14.y, when this "Fixes:" tag says a commit that
> > showed up in 4.15?
> 
> The issue of set_affinity being called on inactive interrupts, and it
> not being handled correctly, was already there in 4.14. The commit in
> the Fixes: tag is the x86 workaround, which came in in 4.15, and is
> no longer needed.
> 
> So we still need the backport of the genirq changes, to fix it in 4.14.
> This is mostly for arm64 (gicv3), where this issue results in interrupts
> getting messed up.

Ok, thanks, both now queued up.

greg k-h
