Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E1F3A9393
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 09:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhFPHSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 03:18:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231316AbhFPHSU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 03:18:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9B326008E;
        Wed, 16 Jun 2021 07:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623827775;
        bh=9qGdO2wBdEMdE23f0+niv6wXKe+kkTjZ7rWvVOa2+xs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GbF1IaBPqdIiztQLgdypet1kXwUo3rxx3NQ/cCX2vKf8nAmzsTRmoDekd9bFl0nkK
         s6354+3IQyQZN4KrfuhMhEBca6we0MkpB8T8isTUqJ+0wHaeMFXOMTdKcTNZnBDse7
         ESbbgaY9M/35PrsaSnTF38SD08WDPKEOSL1+mCrU=
Date:   Wed, 16 Jun 2021 09:16:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Amit Klein <aksecurity@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 175/244] inet: use bigger hash table for IP ID
 generation
Message-ID: <YMmlPHMn/+EPdbvm@kroah.com>
References: <20210512144743.039977287@linuxfoundation.org>
 <20210512144748.600206118@linuxfoundation.org>
 <CANEQ_++O0XVVdvynGtf37YCHSBT8CYHnUkK+VsFkOTqeqwOUtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEQ_++O0XVVdvynGtf37YCHSBT8CYHnUkK+VsFkOTqeqwOUtA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 10:02:44AM +0300, Amit Klein wrote:
>  Hi Greg et al.
> 
> I see that you backported this patch (increasing the IP ID hash table size)
> to the newer LTS branches more than a month ago. But I don't see that it
> was backported to older LTS branches (4.19, 4.14, 4.9, 4.4). Is this
> intentional?

It applies cleanly to 4.19, but not the older ones.  If you think it is
needed there for those kernels, please provide a working backport that
we can apply.

thanks,

greg k-h
