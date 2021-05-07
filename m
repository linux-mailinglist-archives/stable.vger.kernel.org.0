Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31ABC37659A
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 14:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236772AbhEGMxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 08:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234440AbhEGMxm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 May 2021 08:53:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 457FE6145D;
        Fri,  7 May 2021 12:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620391962;
        bh=QJrhC0i7DCyM2nROef863R9ndXw27gug9ZRAn8YECxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Oiv/kI35KRmYn6aoF5qpIMdfOeVPnNFmJXpmjJMym/PwUN6W6gfiRzeNAJWXmWaDh
         op6fzYbDW9ukpjnMBMq9l2BnD+Q9ODNraohvKRwkPky+4MzWJEoTmeXTSbiW8xzXkW
         Ie2ZQ8UyVR7ZYIAZo2S70DdpvOIl+fYsN0wQxkyM=
Date:   Fri, 7 May 2021 14:52:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: MHI v5.13 commits for stable backporting
Message-ID: <YJU4FnLcRjXylMLM@kroah.com>
References: <20210507080736.GA5646@work>
 <YJT3rOgd9WVvdRZl@kroah.com>
 <20210507101508.GB5646@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210507101508.GB5646@work>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 07, 2021 at 03:45:08PM +0530, Manivannan Sadhasivam wrote:
> On Fri, May 07, 2021 at 10:17:48AM +0200, Greg KH wrote:
> > On Fri, May 07, 2021 at 01:37:36PM +0530, Manivannan Sadhasivam wrote:
> > > Hi Greg,
> > > 
> > > As suggested by you in MHI v5.13 PR [1], please find the below commits that
> > > got merged for v5.13 and should be backported to stable kernels:
> > > 
> > > 683e77cadc83 ("bus: mhi: core: Fix shadow declarations")
> > > 5630c1009bd9 ("bus: mhi: pci_generic: Constify mhi_controller_config struct definitions")
> > > ec32332df764 ("bus: mhi: core: Sanity check values from remote device before use")
> > > 47705c084659 ("bus: mhi: core: Clear configuration from channel context during reset")
> > > 70f7025c854c ("bus: mhi: core: remove redundant initialization of variables state and ee")
> > > 68731852f6e5 ("bus: mhi: core: Return EAGAIN if MHI ring is full")
> > > 4547a749be99 ("bus: mhi: core: Fix MHI runtime_pm behavior")
> > > 6403298c58d4 ("bus: mhi: core: Fix check for syserr at power_up")
> > > 8de5ad994143 ("bus: mhi: core: Add missing checks for MMIO register entries")
> > > 0ecc1c70dcd3 ("bus: mhi: core: Fix invalid error returning in mhi_queue")
> > > 0fccbf0a3b69 ("bus: mhi: pci_generic: Remove WQ_MEM_RECLAIM flag from state workqueue")
> > > 
> > > I'll make sure to tag stable list for future potential patches.
> > 
> > That's a lot, are you sure they are all needed?  Constify?
> >
> 
> Filtered the patches now...
> 
> > What order should these be applied in and how far back should the
> > patches be backported?
> > 
> 
> Below is the order and stable kernel revisions:
> 
> 6403298c58d4 ("bus: mhi: core: Fix check for syserr at power_up") #5.10
> 47705c084659 ("bus: mhi: core: Clear configuration from channel context during reset") #5.10
> ec32332df764 ("bus: mhi: core: Sanity check values from remote device before use") #5.10
> 8de5ad994143 ("bus: mhi: core: Add missing checks for MMIO register entries") #5.11
> 0fccbf0a3b69 ("bus: mhi: pci_generic: Remove WQ_MEM_RECLAIM flag from state workqueue") #5.11
> 4547a749be99 ("bus: mhi: core: Fix MHI runtime_pm behavior") #5.12
> 0ecc1c70dcd3 ("bus: mhi: core: Fix invalid error returning in mhi_queue") #5.12

All now queued up, thanks.

greg k-h
