Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642443A0E71
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 10:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237510AbhFIIGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 04:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234840AbhFIIFu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 04:05:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C77936100A;
        Wed,  9 Jun 2021 08:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623225836;
        bh=6Mr1RXgCFLUnG6pcdHJhdFFbpP0idPvtv3LrafGu9iw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FT7RLLABssI8l0xEPCvDV7RivDTgyKPiq1dpWCMfU1gZa7S2d02M5+OX+9V3Hcbez
         JyIILaUZL2PlF/lB2h41760M3unfMbDTKqtEYC6/dB0AkTEIqW1E3WjDJR/r8lCCP5
         7QsnERzaGl8W8AJCUnfLpIL1BoDlf8SbV6MwLeE8=
Date:   Wed, 9 Jun 2021 10:03:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     stable@vger.kernel.org, "Michael S.Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        regressions@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Corentin =?iso-8859-1?Q?No=EBl?= <corentin.noel@collabora.com>
Subject: Re: virtio-net: kernel panic in virtio_net.c
Message-ID: <YMB16VOrQXq5oagz@kroah.com>
References: <YMBelFMOAhEqWoc+@kroah.com>
 <1623225080.4793522-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623225080.4793522-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 09, 2021 at 03:51:20PM +0800, Xuan Zhuo wrote:
> On Wed, 9 Jun 2021 08:24:20 +0200, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, Jun 09, 2021 at 02:08:17PM +0800, Xuan Zhuo wrote:
> > > On Wed, 9 Jun 2021 06:50:10 +0200, Greg KH <gregkh@linuxfoundation.org> wrote:
> > > > On Wed, Jun 09, 2021 at 09:48:33AM +0800, Xuan Zhuo wrote:
> > > > > > > With this patch and the latest net branch I no longer get crashes.
> > > > > >
> > > > > > Did this ever get properly submitted to the networking tree to get into
> > > > > > 5.13-final?
> > > > >
> > > > > The patch has been submitted.
> > > > >
> > > > > 	[PATCH net] virtio-net: fix for skb_over_panic inside big mode
> > > >
> > > > Submitted where?  Do you have a lore.kernel.org link somewhere?
> > >
> > >
> > > https://lore.kernel.org/netdev/20210603170901.66504-1-xuanzhuo@linux.alibaba.com/
> >
> > So this is commit 1a8024239dac ("virtio-net: fix for skb_over_panic
> > inside big mode") in Linus's tree, right?
> 
> YES.
> 
> >
> > But why is that referencing:
> > 	Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
> 
> This problem was indeed introduced in fb32856b16ad.
> 
> I confirmed that this commit fb32856b16ad was first entered in 5.13-rc1, and the
> previous 5.12 did not have this commit fb32856b16ad.
> 
> I'm not sure if it helped you.

Hm, then what resolves the reported problem that people were having with
the 5.12.y kernel release?  Is that a separate issue?

thanks,

greg k-h
