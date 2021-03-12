Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB4C338EB1
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 14:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhCLNYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 08:24:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230386AbhCLNYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 08:24:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24AA064F70;
        Fri, 12 Mar 2021 13:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615555469;
        bh=yvU9KDho164al6otHnf3conqpIffpoexT9RlbHCE+RU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QykQnQY7opBGIjoiilEVewzNuZCHzSS82QNb8i4TxouFM9cq3jQxuSfZwzBKwguWZ
         O3OXIHUsygDUvZGZZYXd5ImJ7VDMz2PDAhC1sgcyepe3kumuElw0L+XGgDOp7rJeJv
         uPzBCXONWvfT3TTuRP1Mgy4ZaYVgcCiREf3o9PR8=
Date:   Fri, 12 Mar 2021 14:24:27 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linus.walleij@linaro.org, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gpiolib: acpi: Add
 ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk" failed to apply to 5.4-stable tree
Message-ID: <YEtri0n4sHhugBIS@kroah.com>
References: <16154863759340@kroah.com>
 <YEtXnzyfm0Tbnu0e@smile.fi.intel.com>
 <YEtaIRHYvLreTKe2@kroah.com>
 <YEtdbXkv1diR9vFd@smile.fi.intel.com>
 <YEtftWmpu1kCww4M@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEtftWmpu1kCww4M@smile.fi.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 02:33:57PM +0200, Andy Shevchenko wrote:
> On Fri, Mar 12, 2021 at 02:24:13PM +0200, Andy Shevchenko wrote:
> > On Fri, Mar 12, 2021 at 01:10:09PM +0100, Greg KH wrote:
> > > On Fri, Mar 12, 2021 at 01:59:27PM +0200, Andy Shevchenko wrote:
> > > > On Thu, Mar 11, 2021 at 07:12:55PM +0100, gregkh@linuxfoundation.org wrote:
> > > > > 
> > > > > The patch below does not apply to the 5.4-stable tree.
> > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > tree, then please email the backport, including the original git commit
> > > > > id to <stable@vger.kernel.org>.
> > > > 
> > > > No need for v5.4.
> > > > 
> > > > Please, also drop
> > > > gpio-pca953x-set-irq-type-when-handle-intel-galileo-gen-2.patch
> > > > gpiolib-acpi-allow-to-find-gpioint-resource-by-name-and-index.patch
> > > > 
> > > > from 5.4-stable queue, thanks!
> > > 
> > > Why?  If you look at the first commit above, it says:
> > > Fixes: ba8c90c61847 ("gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2")
> > > 
> > > which is in the 5.4.52 kernel release.  So why shouldn't it go there?
> > > 
> > > Same goes for the
> > > gpiolib-acpi-allow-to-find-gpioint-resource-by-name-and-index.patch
> > > patch.
> > > 
> > > Is your marking of the "Fixes:" tags incorrect somehow?
> > > 
> > > confused,
> > 
> > It has also Depends-on which points out that the regression only visible when
> > that commit is in the tree.
> > 
> > If you want to see them in v5.4, I can backport the series.
> 
> Since the other two in your queue, you may try to use this one, which I have
> sent for v5.10.y, but it seems good enough for v5.4.
> 
> https://lore.kernel.org/stable/20210312121542.67389-1-andriy.shevchenko@linux.intel.com/T/#u

Ok, this looks to not make sense for 5.4.y, so I've dropped all of the
gpiolib patches from there, and fixed up the 5.10.y ones, so we should
be all good now.

thanks,

greg k-h
