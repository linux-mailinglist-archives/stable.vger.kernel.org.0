Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350DF3761C1
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 10:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236020AbhEGISz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 04:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234484AbhEGISy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 May 2021 04:18:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B5436145D;
        Fri,  7 May 2021 08:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620375470;
        bh=vNAjSydyMZSmED1A+VvGHvnGZEHtUqNSbk1t6UpEZPM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cv6BLky0bztk/ZLL+0nc6hZlPJucQsv0qUn3tWl6aOA8DN7rDGTKtqKf+n0wVpFpV
         dlg3QjCZpZH2ZyfjJjXcYE1a0oKM8BWymmFOxEqAQQltoZ4/sjkM+aadVABQ7pnOru
         Gg+un0LJ6x2vFupVy1bx+f9VhLr1XbMXM0VhXMaU=
Date:   Fri, 7 May 2021 10:17:48 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc:     stable@vger.kernel.org
Subject: Re: MHI v5.13 commits for stable backporting
Message-ID: <YJT3rOgd9WVvdRZl@kroah.com>
References: <20210507080736.GA5646@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210507080736.GA5646@work>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 07, 2021 at 01:37:36PM +0530, Manivannan Sadhasivam wrote:
> Hi Greg,
> 
> As suggested by you in MHI v5.13 PR [1], please find the below commits that
> got merged for v5.13 and should be backported to stable kernels:
> 
> 683e77cadc83 ("bus: mhi: core: Fix shadow declarations")
> 5630c1009bd9 ("bus: mhi: pci_generic: Constify mhi_controller_config struct definitions")
> ec32332df764 ("bus: mhi: core: Sanity check values from remote device before use")
> 47705c084659 ("bus: mhi: core: Clear configuration from channel context during reset")
> 70f7025c854c ("bus: mhi: core: remove redundant initialization of variables state and ee")
> 68731852f6e5 ("bus: mhi: core: Return EAGAIN if MHI ring is full")
> 4547a749be99 ("bus: mhi: core: Fix MHI runtime_pm behavior")
> 6403298c58d4 ("bus: mhi: core: Fix check for syserr at power_up")
> 8de5ad994143 ("bus: mhi: core: Add missing checks for MMIO register entries")
> 0ecc1c70dcd3 ("bus: mhi: core: Fix invalid error returning in mhi_queue")
> 0fccbf0a3b69 ("bus: mhi: pci_generic: Remove WQ_MEM_RECLAIM flag from state workqueue")
> 
> I'll make sure to tag stable list for future potential patches.

That's a lot, are you sure they are all needed?  Constify?

What order should these be applied in and how far back should the
patches be backported?

thanks,

greg k-h
