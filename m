Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66392389456
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 19:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355500AbhESREv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 13:04:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355471AbhESREp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 May 2021 13:04:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 673F76135C;
        Wed, 19 May 2021 17:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621443804;
        bh=jRb9LcGLC+A/55hxfV6NTeBK73W71OfoiFLQFFhNNb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qJvjhfWAGz5zT9GwoJynSTwLOkNC+E4A7+rBQ0wM7XDe7zJxBca2KhMg9PabOIzDh
         6UFXW/SZQN2ZCDmbQHuO/ua5KCF3SjkUBtexiSN0Pou2ObQjuRqTtiHGtgs2tLdIIe
         2CIoCoZRnKfYI+astjwWUlxLn+kSeflpqTrGJeGg=
Date:   Wed, 19 May 2021 19:03:22 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jianxiong Gao <jxgao@google.com>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Marc Orr <marcorr@google.com>, sashal@kernel.org
Subject: Re: [PATCH 5.4 v2 0/9] preserve DMA offsets when using swiotlb
Message-ID: <YKVE2kerpTzoeIL+@kroah.com>
References: <20210518221818.2963918-1-jxgao@google.com>
 <YKTIJsD2KmiV3mIb@kroah.com>
 <CAMGD6P1FBwYBnVPPSFtn0qgHbs+y=stZXhnYHjX82H+vqei+AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMGD6P1FBwYBnVPPSFtn0qgHbs+y=stZXhnYHjX82H+vqei+AQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 19, 2021 at 09:42:42AM -0700, Jianxiong Gao wrote:
> On Wed, May 19, 2021 at 1:11 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > I still fail to understand why you can not just use the 5.10.y kernel or
> > newer.  What is preventing you from doing this if you wish to use this
> > type of hardware?  This is not a "regression" in that the 5.4.y kernel
> > has never worked with this hardware before, it feels like a new feature.
> >
> NVMe + SWIOTLB is not a new feature. From my understanding it should
> be supported by 5.4.y kernel correctly. Currently without the patch, any
> NVMe device (along with some other devices that relies on offset to
> work correctly), could be broken if the SWIOTLB is used on a 5.4.y kernel.

Then do not do that, as obviously it never worked without your fixes, so
this isn't a "regression".

And again, why can you not just use 5.10.y?

thanks,

greg k-h
