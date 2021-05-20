Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EF138B5A6
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 19:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236059AbhETSAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 14:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235920AbhETSAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 14:00:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DCA960C3F;
        Thu, 20 May 2021 17:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621533533;
        bh=XsfOuPt63fmIg+N8ZtNu+v8I5jpBSf8W7VEdPtvFqFw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x27KGaKhlad12cvdKHDnCjcU7PggBmhEQcYxItnrX3bW4uefszeNP7+h6RR60dkOI
         5jWpX7ygXj1290jeaI8atjJm1/EP4pNzv2usjM6ZTAAux2GznbQipwgarKAI+5Ngel
         YGtJI8rLxKYVVLC4+aws4LuPzaZvvH1lNNGZ59Zo=
Date:   Thu, 20 May 2021 19:58:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bhaumik Bhatt <bbhatt@codeaurora.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        regressions@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [regressions] ath11k: v5.12.3 mhi regression
Message-ID: <YKajWVPUSTzNVVm8@kroah.com>
References: <87v97dhh2u.fsf@codeaurora.org>
 <YKYzwBJNTy4Czd1A@kroah.com>
 <20210520104313.GA128703@thinkpad>
 <87r1i1h9an.fsf@codeaurora.org>
 <3e8bac3b02e3549a55b7c9b78b699965@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e8bac3b02e3549a55b7c9b78b699965@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 20, 2021 at 10:38:12AM -0700, Bhaumik Bhatt wrote:
> On 2021-05-20 05:36 AM, Kalle Valo wrote:
> > Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org> writes:
> > 
> > > On Thu, May 20, 2021 at 12:02:40PM +0200, Greg KH wrote:
> > > > On Thu, May 20, 2021 at 12:47:53PM +0300, Kalle Valo wrote:
> > > > > Hi,
> > > > >
> > > > > I got several reports that this mhi commit broke ath11k in v5.12.3:
> > > > >
> > > > > commit 29b9829718c5e9bd68fc1c652f5e0ba9b9a64fed
> > > > > Author: Bhaumik Bhatt <bbhatt@codeaurora.org>
> > > > > Date:   Wed Feb 24 15:23:04 2021 -0800
> > > > >
> > > > >     bus: mhi: core: Process execution environment changes serially
> > > > >
> > > > >     [ Upstream commit ef2126c4e2ea2b92f543fae00a2a0332e4573c48 ]
> > > > >
> > > > > Here are the reports:
> > > > >
> > > > > https://bugzilla.kernel.org/show_bug.cgi?id=213055
> > > > >
> > > > > https://bugzilla.kernel.org/show_bug.cgi?id=212187
> > > > >
> > > > > https://bugs.archlinux.org/task/70849?project=1&string=linux
> > > > >
> > > > > Interestingly v5.13-rc1 seems to work fine, at least for me, though I
> > > > > have not tested v5.12.3 myself. Can someone revert this commit in the
> > > > > stable release so that people get their wifi working again, please?
> > > > 
> > > > How does the mhi bus code relate to a ath11k driver?  What bus
> > > > is that
> > > > on?
> > > > 
> > > 
> > > MHI is the transport used by the ath11k driver to work with the WLAN
> > > devices
> > > over PCIe.
> > > 
> > > Regarding the bug, I'd suggest to wait for Bhaumik (the author of
> > > 29b9829718c5)
> > > to comment on the possible commit which needs backporting from
> > > mainline.
> > 
> > Ok, but if a quick fix is not available I think we should just revert
> > this in the stable releases. I also got a report that v5.11.21 is
> > broken:
> > 
> > https://bugzilla.kernel.org/show_bug.cgi?id=213055#c11
> 
> Please pick [1] as the dependency to [ Upstream commit
> ef2126c4e2ea2b92f543fae00a2a0332e4573c48 ].

what is [1]???

What commit do I need to backport, a commit id would be nice...

thanks,

greg k-h
