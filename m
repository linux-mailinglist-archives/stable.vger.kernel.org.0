Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD094540EA
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 07:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhKQGi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 01:38:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:48182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229516AbhKQGi5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 01:38:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BC7A61BFE;
        Wed, 17 Nov 2021 06:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637130959;
        bh=yC3KGp+whdZ/zO7ZA9hgkty8rFx9xZyhDaFkvm1Rq1U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ja3hg6Ci4k6UItEWuSa2CUEhbFZOLlsDuAcQ7vGEjNNd4qBfz2LM3pgboXt4wKo+O
         FCkIipxlSB+TFwhcaHYJIvI5JJNfZnab0zuVMvakXD28MLM4OBWF5rwh4t2ECpGPr5
         GwuGtX3rlrHEHwpDnOzPKCF98eFmLEkKAtpsWm84=
Date:   Wed, 17 Nov 2021 07:35:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marek Vasut <marex@denx.de>
Cc:     Szabolcs Sipos <labuwx@balfug.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH] Bluetooth: btusb: Add support for TP-Link UB500 Adapter
Message-ID: <YZSixJVYJxE7COuy@kroah.com>
References: <aa3f6986-1e9b-4aaa-e498-fd99385f4063@denx.de>
 <YWPrSHGbno3dODKr@kroah.com>
 <62685363-e1b3-bc97-431e-a7c8faccb78d@balfug.com>
 <YZP6CL+CDMyzQ6aA@kroah.com>
 <5931c469-c0bf-4e93-e7e3-443b5ca60fb3@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5931c469-c0bf-4e93-e7e3-443b5ca60fb3@denx.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 08:58:15PM +0100, Marek Vasut wrote:
> On 11/16/21 7:35 PM, Greg Kroah-Hartman wrote:
> > On Tue, Nov 16, 2021 at 06:41:08PM +0100, Szabolcs Sipos wrote:
> > > On 10/11/21 09:44, Greg Kroah-Hartman wrote:
> > > > On Sun, Oct 10, 2021 at 10:59:06PM +0200, Marek Vasut wrote:
> > > > > Hello everyone,
> > > > > 
> > > > > The following new device USB ID has landed in linux-next recently:
> > > > > 
> > > > > 4fd6d4907961 ("Bluetooth: btusb: Add support for TP-Link UB500 Adapter")
> > > > > 
> > > > > It would be nice if it could be backported to stable. I verified it works on
> > > > > 5.14.y as a simple cherry-pick .
> > > > 
> > > > A patch needs to be in Linus's tree before we can add it to the stable
> > > > releases.  Please let us know when it gets there and we will be glad to
> > > > pick it up.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > Hello Greg,
> > > 
> > > The patch has reached Linus's tree:
> > > 4fd6d4907961 ("Bluetooth: btusb: Add support for TP-Link UB500 Adapter")
> > > 
> > > Could you please add it to stable (5.15.y)?
> > 
> > I will queue it up for the next set of kernels after the current ones are
> > released.
> 
> btw while you're bringing it up, is there some sure-fire method I can use to
> verify the patch is in Linus tree, besides having a separate checkout of
> that tree ?

Without the tree/branch checked out?  Not that I know of, sorry.

> I usually have both Linus tree as origin and next in one git tree, so I was
> wondering if there is a recommended way to avoid mistakes like the one I
> made above (and checking at git.kernel.org apparently also has its
> downsides).

Having both in one git tree is fine.  Just switch between branches (one
that tracks Linus's and one that tracks linux-next) and you can see what
is happening in each of them.

There's other "tricks" to see if patches have been added to branches by
adding them to a branch and then rebasing and seeing the end result, but
those get tricky to try to explain in simple emails...

greg k-h
