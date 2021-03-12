Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9C6E338C6A
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 13:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCLMKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 07:10:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:55630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229756AbhCLMKM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 07:10:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5158664FD6;
        Fri, 12 Mar 2021 12:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615551011;
        bh=/rczVo3lcjchilH7KTCxKdcuezWV8CGaVn20TDPFF5U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P9o3JoLuV/LHPmCjjV9iytmvt/BvLWGKfEhRDHMrog/pXe1hCAdrE1qa2fzeUkIr2
         3pL3QxFnnqURofHJwtkFHRoM7PQ6UplrMsBFC1x+4de5M3f1tPqV5n6M3FgmOnS3G/
         dMx+lTBj4HAyth6ZR7S6F5tvcYHhR/MpKY/VNbgk=
Date:   Fri, 12 Mar 2021 13:10:09 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linus.walleij@linaro.org, mika.westerberg@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] gpiolib: acpi: Add
 ACPI_GPIO_QUIRK_ABSOLUTE_NUMBER quirk" failed to apply to 5.4-stable tree
Message-ID: <YEtaIRHYvLreTKe2@kroah.com>
References: <16154863759340@kroah.com>
 <YEtXnzyfm0Tbnu0e@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEtXnzyfm0Tbnu0e@smile.fi.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 12, 2021 at 01:59:27PM +0200, Andy Shevchenko wrote:
> On Thu, Mar 11, 2021 at 07:12:55PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> No need for v5.4.
> 
> Please, also drop
> gpio-pca953x-set-irq-type-when-handle-intel-galileo-gen-2.patch
> gpiolib-acpi-allow-to-find-gpioint-resource-by-name-and-index.patch
> 
> from 5.4-stable queue, thanks!

Why?  If you look at the first commit above, it says:
Fixes: ba8c90c61847 ("gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2")

which is in the 5.4.52 kernel release.  So why shouldn't it go there?

Same goes for the
gpiolib-acpi-allow-to-find-gpioint-resource-by-name-and-index.patch
patch.

Is your marking of the "Fixes:" tags incorrect somehow?

confused,

greg k-h
