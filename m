Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCAAB2C73E1
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgK1Vtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 16:49:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732246AbgK1S7j (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 28 Nov 2020 13:59:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56ABB2465A;
        Sat, 28 Nov 2020 14:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606575053;
        bh=IGRuzIneAS+MxSmPG5U2K3jpCbGG8e/jywbMmzIqyDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ftbc/4a244eTPU2zKIcGK+DMXdujlTxMBQz2mW0JQwsbTqoZmKCZHFUIuKX50DxFL
         k9F7WzztkM+1/NqyySVUimYCaalJWrLozpLIvsTJUil+jMknG+PFEkMByL9VOW3QBr
         NA0MdgXxlHF4eZlZnIrEyTsLKsEXc4POft0zTsO8=
Date:   Sat, 28 Nov 2020 15:52:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christoph Niedermaier <cniedermaier@dh-electronics.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Missing fixes commit on linux-4.19.y
Message-ID: <X8JkEd1pRewMee3q@kroah.com>
References: <86287ab712444551b3740703a8092aa8@dh-electronics.com>
 <X8EIikqJig6iNCOD@kroah.com>
 <87296404bad145d2a84173edcfd5a231@dh-electronics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87296404bad145d2a84173edcfd5a231@dh-electronics.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 27, 2020 at 05:56:24PM +0000, Christoph Niedermaier wrote:
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, November 27, 2020 3:09 PM
> 
> Hello Greg,
> 
> >> Is it possible to apply the following commit on the branch linux-4.19.y?
> >> de9f8eea5a44 ("drm/atomic_helper: Stop modesets on unregistered connectors harder")
> >>
> >> This commit is applied to the other LTS kernels, but is missing on
> >> linux-4.19.y.
> > 
> > I see it showing up in the 4.20 release, so of course anything newer
> > than that will work, what other trees do you see this applied in?
> 
> I think it's only the 4.19 tree that misses this patch, because it fixes
> "drm/atomic_helper: Disallow new modesets on unregistered connectors"
> and 
> "drm/atomic_helper: Allow DPMS On<->Off changes for unregistered connectors"
> If I am right this two commits aren't on 4.14 / 4.9 / 4.4
> 
> >> Without this patch my i.MX6ULL SoM doesn't initialize
> >> the display correctly after booting.
> > 
> > It does not apply cleanly to the 4.19.y tree, can you provide a working
> > backport so that we could apply it?
> 
> A working backport is below.

Looks good, now queued up, thanks.

greg k-h
