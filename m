Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE83BE64A2
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 18:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfJ0Rpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 13:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727099AbfJ0Rpq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 13:45:46 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A89820679;
        Sun, 27 Oct 2019 17:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572198345;
        bh=oZE6MaDIwTuzAwWjcBVOI/6es5zXUTCf5HCui/65AAM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jsheKlsPRRO+1LiQyX6e7qi7CpB1wBE5ZZ5RROpO6qGZlQQJMwv6oTm/oYWi4tse0
         Hk3G+0ttQ6oN6dssuyH5jBTIpIeyQXADPaVLCS2UtL35a++A6Inp7Zxi+hQ+MkwUls
         bkEBCnNhbaZwE6qenk+FKoRpNmvELqLBEVAro/yk=
Date:   Sun, 27 Oct 2019 18:45:41 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     "20191010123258.16919-1-rkagan@virtuozzo.com" 
        <20191010123258.16919-1-rkagan@virtuozzo.com>,
        "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        vkuznets <vkuznets@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
Subject: Re: Patch "x86/hyperv: Make vapic support x2apic mode" has been
 added to the 4.19-stable tree
Message-ID: <20191027174541.GA2491656@kroah.com>
References: <15721920637928@kroah.com>
 <DM5PR21MB01372C3085663526380961FDD7670@DM5PR21MB0137.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR21MB01372C3085663526380961FDD7670@DM5PR21MB0137.namprd21.prod.outlook.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 27, 2019 at 05:35:00PM +0000, Michael Kelley wrote:
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     x86/hyperv: Make vapic support x2apic mode
> > 
> > to the 4.19-stable tree which can be found at:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
> > 
> > The filename of the patch is:
> >      x86-hyperv-make-vapic-support-x2apic-mode.patch
> > and it can be found in the queue-4.19 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> > 
> > From e211288b72f15259da86eed6eca680758dbe9e74 Mon Sep 17 00:00:00 2001
> > From: Roman Kagan <rkagan@virtuozzo.com>
> > Date: Thu, 10 Oct 2019 12:33:05 +0000
> > Subject: x86/hyperv: Make vapic support x2apic mode
> > 
> > From: Roman Kagan <rkagan@virtuozzo.com>
> > 
> > commit e211288b72f15259da86eed6eca680758dbe9e74 upstream.
> > 
> > Now that there's Hyper-V IOMMU driver, Linux can switch to x2apic mode
> > when supported by the vcpus.
> > 
> 
> This patch should not go back to the 4.19 stable tree.  I don't think it will
> break anything, but there's no Hyper-V vIOMMU driver in 4.19 so
> x2apic_enabled() is never true.

Thanks for letting me know, now dropped.

greg k-h
