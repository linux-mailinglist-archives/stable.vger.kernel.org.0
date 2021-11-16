Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F651452F44
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 11:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234276AbhKPKmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 05:42:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234225AbhKPKmS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 05:42:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40E6660F44;
        Tue, 16 Nov 2021 10:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637059161;
        bh=Z5iHw+w8oH4MPY4bjNaPg/2EisAuwLYk6quGUMb8h5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FVUqoSggFfTMFLvR3e7sTpK2GhlHJ10iIkwrmaWMXdgduH83h6GI2E3hYTdMawSws
         60NSsge4jzhtKPZ2mIZoN542kTK+vBYtb8zWtAZqV+pDvkx/ZzGmGnR0o6fmxf4YkC
         Jh3uMTfHiRUqEcJYl8wgh4MZW7sppKnMTZpedNMI=
Date:   Tue, 16 Nov 2021 11:39:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rui Salvaterra <rsalvaterra@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH 0/2] PCI: MSI: Deal with devices lying about their
 masking capability
Message-ID: <YZOKV6z+6pDjjvcl@kroah.com>
References: <20211104180130.3825416-1-maz@kernel.org>
 <87ilx64ued.ffs@tglx>
 <CALjTZvag6ex6bhAgJ_rJOfai8GgZQfWesdV=FiMrwEaXhVVVeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALjTZvag6ex6bhAgJ_rJOfai8GgZQfWesdV=FiMrwEaXhVVVeQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 10:21:18AM +0000, Rui Salvaterra wrote:
> Hi, Thomas,
> 
> On Fri, 5 Nov 2021 at 13:14, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > On Thu, Nov 04 2021 at 18:01, Marc Zyngier wrote:
> > > Rui reported[1] that his Nvidia ION system stopped working with 5.15,
> > > with the AHCI device failing to get any MSI. A rapid investigation
> > > revealed that although the device doesn't advertise MSI masking, it
> > > actually needs it. Quality hardware indeed.
> > >
> > > Anyway, the couple of patches below are an attempt at dealing with the
> > > issue in a more or less generic way.
> > >
> > > [1] https://lore.kernel.org/r/CALjTZvbzYfBuLB+H=fj2J+9=DxjQ2Uqcy0if_PvmJ-nU-qEgkg@mail.gmail.com
> > >
> > > Marc Zyngier (2):
> > >   PCI: MSI: Deal with devices lying about their MSI mask capability
> > >   PCI: Add MSI masking quirk for Nvidia ION AHCI
> > >
> > >  drivers/pci/msi.c    | 3 +++
> > >  drivers/pci/quirks.c | 6 ++++++
> > >  include/linux/pci.h  | 2 ++
> > >  3 files changed, 11 insertions(+)
> >
> > Groan.
> >
> > Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Just a reminder, to make sure this doesn't fall through the cracks.
> It's already in 5.16, but needs to be backported to 5.15. I'm not
> seeing it in Greg's 5.15 stable queue yet.

What is the git commit ids of these changes in Linus's tree?

thanks,

greg k-h
