Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978A03A0BAF
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 06:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbhFIEwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 00:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230244AbhFIEwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Jun 2021 00:52:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 069C261287;
        Wed,  9 Jun 2021 04:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623214214;
        bh=G6QDDNn3+r21im4Pl2kiSv1GcKtQ+/5AqTQSbVrmM0M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2EUG65o6C3VdlBkFse68F37GLtREPT60SPu0V0Fxt0TzuNQumQlVVZDgOU6hLwRy/
         /kKOe7ffd4YfOEve5Qm7Pe2I/bc0b9iqIqdsmjdOS7FpnFyhu1kC9g5vmqoj9+tjaq
         3MJIe2MZJ4fwpnaswxsw1/nzpyCOj7Kyv502nJNI=
Date:   Wed, 9 Jun 2021 06:50:10 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     stable@vger.kernel.org, "Michael S.Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        regressions@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        Corentin =?iso-8859-1?Q?No=EBl?= <corentin.noel@collabora.com>
Subject: Re: virtio-net: kernel panic in virtio_net.c
Message-ID: <YMBIghQaTelAvXOY@kroah.com>
References: <YL9f9uFoPGj2Q9Zl@kroah.com>
 <1623203313.4303577-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623203313.4303577-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 09, 2021 at 09:48:33AM +0800, Xuan Zhuo wrote:
> > > With this patch and the latest net branch I no longer get crashes.
> >
> > Did this ever get properly submitted to the networking tree to get into
> > 5.13-final?
> 
> The patch has been submitted.
> 
> 	[PATCH net] virtio-net: fix for skb_over_panic inside big mode

Submitted where?  Do you have a lore.kernel.org link somewhere?

thanks,

greg k-h
