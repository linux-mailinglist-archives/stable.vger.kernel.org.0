Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2665F411196
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 11:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbhITJH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 05:07:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236096AbhITJHQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 05:07:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 410ED606A5;
        Mon, 20 Sep 2021 09:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632128674;
        bh=qgZ4roUOIQ8wf5tjQtC2k0rqMxKoi5VJzwtzJDpCCZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LbCbOm7aSgfQMhl6JYOlGnw7Cd9jglgLaEBTZZj6ACnvKcd53w+uCwz8ib8TIU7mF
         w2lEQtXwz67YYhdK5+OfCfpRfgjjbfLnB8AephDhBZwo4HwczHNeJWo5eMPnirVGnH
         z68+MBavEoUhzAb3e1aNhANu6i7bL+yU1cqjOcko=
Date:   Mon, 20 Sep 2021 11:04:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Helge Deller <deller@gmx.de>
Cc:     James.Bottomley@hansenpartnership.com, arnd@arndb.de,
        krypton@ulrich-teichert.org, linux@roeck-us.net,
        torvalds@linux-foundation.org, stable <stable@vger.kernel.org>,
        stable-commits@vger.kernel.org
Subject: Re: Patch "parisc: Declare pci_iounmap() parisc version only when
 CONFIG_PCI enabled" has been added to the 4.4-stable tree
Message-ID: <YUhOoI8RXbEEnCKi@kroah.com>
References: <163212536414258@kroah.com>
 <8b36c2b6-3f5e-2f87-e45f-262d0b93b071@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b36c2b6-3f5e-2f87-e45f-262d0b93b071@gmx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 10:45:42AM +0200, Helge Deller wrote:
> On 9/20/21 10:09 AM, gregkh@linuxfoundation.org wrote:
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >      parisc: Declare pci_iounmap() parisc version only when CONFIG_PCI enabled
> > 
> > to the 4.4-stable tree which can be found at:
> >      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >       parisc-declare-pci_iounmap-parisc-version-only-when-config_pci-enabled.patch
> > and it can be found in the queue-4.4 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> 
> Please don't apply to 4.4 (or any stable tree yet).

Thanks for letting me know, I'll go drop it from all queues.

greg k-h
