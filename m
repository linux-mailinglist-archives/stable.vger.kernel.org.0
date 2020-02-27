Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB5A1717D5
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 13:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729032AbgB0MuZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 07:50:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:43288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728977AbgB0MuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 07:50:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0305C24697;
        Thu, 27 Feb 2020 12:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582807824;
        bh=xC1GvH9tuUTNjwvaRvcZHeTlVBC/25ELHHHXaTuw2q0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HQTGcqelQS0ZB4oLBs161FyznN9WqwTX3MI/pykOtRMaan6pRkdc4oebhEO9Cl98p
         bEg7BAkIUjb7/5ar1U6ZN3HYt8423fV/lFId10lotMeHL7PRd+FJMS8IwoNntPNknU
         fvKSg27P+p2Ulj/t6B5aFfd3h2Q/plWZ8ZSanbNc=
Date:   Thu, 27 Feb 2020 13:50:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Prabhakar Kushwaha <prabhakar.pkin@gmail.com>
Cc:     Prabhakar Kushwaha <pkushwaha@marvell.com>, stable@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Ganapatrao Prabhakerrao Kulkarni <gkulkarni@marvell.com>,
        Kamlakant Patel <kamlakantp@marvell.com>
Subject: Re: [RESEND][PATCH] ata: ahci: Add shutdown to freeze hardware
 resources of ahci
Message-ID: <20200227125021.GB1007215@kroah.com>
References: <1581992882-22134-1-git-send-email-pkushwaha@marvell.com>
 <20200218044136.GB2046752@kroah.com>
 <CAJ2QiJLOqAFGN9UPWb0jGBE8mRvTsY3RufTt3fu2H_au6iA77A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ2QiJLOqAFGN9UPWb0jGBE8mRvTsY3RufTt3fu2H_au6iA77A@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 22, 2020 at 09:52:27AM +0530, Prabhakar Kushwaha wrote:
> On Tue, Feb 18, 2020 at 10:11 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Feb 17, 2020 at 06:28:02PM -0800, Prabhakar Kushwaha wrote:
> > > device_shutdown() called from reboot or power_shutdown expect
> > > all devices to be shutdown. Same is true for even ahci pci driver.
> > > As no ahci shutdown function is implemented, the ata subsystem
> > > always remains alive with DMA & interrupt support. File system
> > > related calls should not be honored after device_shutdown().
> > >
> > > So defining ahci pci driver shutdown to freeze hardware (mask
> > > interrupt, stop DMA engine and free DMA resources).
> > >
> > > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > > ---
> > >
> > > This problem has also been seen on older kernel. So sending to stable@vger.kernel.org
> > > Note: It is already applied to git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > > with commit id: 10a663a1b151 ("ata: ahci: Add shutdown to freeze hardware resources of ahci")
> >
> > So what kernel(s) do you wish to have this commit backported to?
> >
> 
> Sorry for the late reply.  This patch should be back-ported to
> following kernels versions
> 4.9, 4.14, 4.19, 5.4 and 5.5

Now queued up, thanks.

greg k-h
