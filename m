Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596623E457F
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 14:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbhHIMVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 08:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233632AbhHIMVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 08:21:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C901160EBC;
        Mon,  9 Aug 2021 12:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628511641;
        bh=Qyg0UVVkr5hB9GejBJx4gSNk9oN8V18v7pfNhDlOV1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q1vuqrro31ZYr/mFp0EH0kbes5XINUOoTaL2wmkUqTxfup3iY/VwN4Oeqvhf5bj6w
         QFTgx6NFhuEyTpsVkDIVz1/TGXRmhSiD7Nzl5mBFicMxhdROwOVomXrQgMMCtGo6N/
         qZYm7JYSSQ/8cm7NuPiVWOkm7+9b+HKSMfcL+gDg=
Date:   Mon, 9 Aug 2021 14:20:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     PGNet Dev <pgnet.dev@gmail.com>
Cc:     hui.wang@canonical.com, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Patch "Revert "ACPI: resources: Add checks for ACPI IRQ
 override"" has been added to the 5.13-stable tree
Message-ID: <YREdlli29GUfvaUx@kroah.com>
References: <16277146132219@kroah.com>
 <e9810931-b21c-195f-26cb-75b46aa9eb9a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9810931-b21c-195f-26cb-75b46aa9eb9a@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 09, 2021 at 08:15:11AM -0400, PGNet Dev wrote:
> On 7/31/21 2:56 AM, gregkh@linuxfoundation.org wrote:
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >      Revert "ACPI: resources: Add checks for ACPI IRQ override"
> > 
> > to the 5.13-stable tree which can be found at:
> >      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >       revert-acpi-resources-add-checks-for-acpi-irq-override.patch
> > and it can be found in the queue-5.13 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> > 
> >  From e0eef3690dc66b3ecc6e0f1267f332403eb22bea Mon Sep 17 00:00:00 2001
> > From: Hui Wang <hui.wang@canonical.com>
> > Date: Wed, 28 Jul 2021 23:19:58 +0800
> > Subject: Revert "ACPI: resources: Add checks for ACPI IRQ override"
> > 
> > From: Hui Wang <hui.wang@canonical.com>
> > 
> > commit e0eef3690dc66b3ecc6e0f1267f332403eb22bea upstream.
> 
> Confirming that this^ revert resolves the reported non-boot regression
> 
> System does boot cleanly; but, then REboots @ 60 seconds.
> 
> It's a known bug, with fix already in 5.13.9/stable:
> 
>  Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"
>  https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-5.13.y&id=02db470b866fd06d8951
> 
> , causing TCO watchdog auto-reboot @ 60 secs.
> 
> Although particularly nasty on servers with /boot on RAID, breaking arrays if watchdog boots before arrays correctly assembled, iiuc, it's UN-related
> 
> With interim workaround
> 
>  edit /etc/modprobe.d/blacklist.conf
> 
> +	blacklist iTCO_wdt
> +	blacklist iTCO_vendor_support
> 
> for this second issue in place, 5.13.8 boots & appears stable.

I do not understand, am I missing something in the queue for the next
5.13 release that needs to be applied?

confused,

greg k-h
