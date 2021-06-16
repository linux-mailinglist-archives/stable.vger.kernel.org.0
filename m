Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE12A3A9E56
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 16:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbhFPO7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 10:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234291AbhFPO7t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 10:59:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E23F6610CA;
        Wed, 16 Jun 2021 14:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623855462;
        bh=P8j6m9EE+N8Go+suVTxlJYwd4cIlcOvWayEBgJFUsmA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iDGmxsj543geYTPE5+XeEN12L8UMBeA/DE4SVuc8zfMQetkgXCSw0uwpguUjkIBuq
         wsVFHybs0QKGoWpHUFM3Gj/tQFsJxgEHGFt01uSNbkVFrfuJ7yKFXMoSCe25Ppxmm8
         /ItyF76vZxN45I8QJpYeLoen17ZqYwxMQeSbZ4Gc=
Date:   Wed, 16 Jun 2021 16:57:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amit Klein <aksecurity@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 175/244] inet: use bigger hash table for IP ID
 generation
Message-ID: <YMoRZDBIua3ionOW@kroah.com>
References: <20210512144743.039977287@linuxfoundation.org>
 <20210512144748.600206118@linuxfoundation.org>
 <CANEQ_++O0XVVdvynGtf37YCHSBT8CYHnUkK+VsFkOTqeqwOUtA@mail.gmail.com>
 <YMmlPHMn/+EPdbvm@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMmlPHMn/+EPdbvm@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 09:16:12AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jun 16, 2021 at 10:02:44AM +0300, Amit Klein wrote:
> >  Hi Greg et al.
> > 
> > I see that you backported this patch (increasing the IP ID hash table size)
> > to the newer LTS branches more than a month ago. But I don't see that it
> > was backported to older LTS branches (4.19, 4.14, 4.9, 4.4). Is this
> > intentional?
> 
> It applies cleanly to 4.19, but not the older ones.  If you think it is
> needed there for those kernels, please provide a working backport that
> we can apply.

It breaks the build on 4.19, which is why I didn't apply it there, so I
would need a working version for that tree as well.

thanks,

greg k-h
