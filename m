Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890093A0C5D
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 08:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbhFIG0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 02:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229724AbhFIG0Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 02:26:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F66E61352;
        Wed,  9 Jun 2021 06:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623219862;
        bh=PZI/QDz7xWSlIQGk4btpDqsFHnCoZdsyGl8U8TeVF0I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AdkrvkPn7Vz0F83eSHoKjTTFChar0SwNy1QF2SKAGj3MFeCu7KATd25KEcqPXCKSv
         4HGm46qFXm0Jhan4TzkanLoy4P1ox9SnkW/c4ZPbagjb7uP9KQIYryFrIQB14Y0tPs
         iCus5CsZW9jOeQrNXNqH8JYf2ESPWxYNVPzbhwPk=
Date:   Wed, 9 Jun 2021 08:24:20 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     stable@vger.kernel.org, "Michael S.Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        regressions@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Corentin =?iso-8859-1?Q?No=EBl?= <corentin.noel@collabora.com>
Subject: Re: virtio-net: kernel panic in virtio_net.c
Message-ID: <YMBelFMOAhEqWoc+@kroah.com>
References: <YMBIghQaTelAvXOY@kroah.com>
 <1623218897.4150124-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623218897.4150124-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 09, 2021 at 02:08:17PM +0800, Xuan Zhuo wrote:
> On Wed, 9 Jun 2021 06:50:10 +0200, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, Jun 09, 2021 at 09:48:33AM +0800, Xuan Zhuo wrote:
> > > > > With this patch and the latest net branch I no longer get crashes.
> > > >
> > > > Did this ever get properly submitted to the networking tree to get into
> > > > 5.13-final?
> > >
> > > The patch has been submitted.
> > >
> > > 	[PATCH net] virtio-net: fix for skb_over_panic inside big mode
> >
> > Submitted where?  Do you have a lore.kernel.org link somewhere?
> 
> 
> https://lore.kernel.org/netdev/20210603170901.66504-1-xuanzhuo@linux.alibaba.com/

So this is commit 1a8024239dac ("virtio-net: fix for skb_over_panic
inside big mode") in Linus's tree, right?

But why is that referencing:
	Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")

when this problem was seen in stable kernels that had a different commit
backported to it?

Is there nothing needed to be done for the stable kernel trees?

confused,

greg k-h
