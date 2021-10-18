Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACF4431618
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 12:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhJRKaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 06:30:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhJRKaA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 06:30:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FC0A6103B;
        Mon, 18 Oct 2021 10:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634552869;
        bh=vR8sZyVkRbpHfpVst3LFjv0sEWuHUIkw5sWdntckSH8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OlxbHK6nv+POxLRZif5KCZ2KLJtqYffj4Fa38V8HEjbZW+R1Qg3aq9fUEDTEHxtRN
         NVeH8DQ9AH33DgQoyp44GneEYDiNZA61FBAmV3ny/8LvThXK/MyHAwCXWNEZTttuM0
         3t22WIogTV8eO/zo83OYoK//zGCvTEL9BVVHCtYE=
Date:   Mon, 18 Oct 2021 12:27:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     ckulkarnilinux@gmail.com, hch@lst.de, mgurtovoy@nvidia.com,
        stefanha@redhat.com, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "virtio-blk: remove unneeded "likely" statements" has been
 added to the 5.14-stable tree
Message-ID: <YW1MI7al2c27QfNs@kroah.com>
References: <163455135025212@kroah.com>
 <20211018062109-mutt-send-email-mst@kernel.org>
 <20211018062237-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018062237-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 06:23:11AM -0400, Michael S. Tsirkin wrote:
> On Mon, Oct 18, 2021 at 06:22:13AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Oct 18, 2021 at 12:02:30PM +0200, gregkh@linuxfoundation.org wrote:
> > > 
> > > This is a note to let you know that I've just added the patch titled
> > > 
> > >     virtio-blk: remove unneeded "likely" statements
> > > 
> > > to the 5.14-stable tree which can be found at:
> > >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > > 
> > > The filename of the patch is:
> > >      virtio-blk-remove-unneeded-likely-statements.patch
> > > and it can be found in the queue-5.14 subdirectory.
> > > 
> > > If you, or anyone else, feels it should not be added to the stable tree,
> > > please let <stable@vger.kernel.org> know about it.
> > > 
> > > 
> > > >From 6105d1fe6f4c24ce8c13e2e6568b16b76e04983d Mon Sep 17 00:00:00 2001
> > > From: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > Date: Sun, 5 Sep 2021 11:57:17 +0300
> > > Subject: virtio-blk: remove unneeded "likely" statements
> > > 
> > > From: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > 
> > > commit 6105d1fe6f4c24ce8c13e2e6568b16b76e04983d upstream.
> > > 
> > > Usually we use "likely/unlikely" to optimize the fast path. Remove
> > > redundant "likely/unlikely" statements in the control path to simplify
> > > the code and make it easier to read.
> > > 
> > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > Link: https://lore.kernel.org/r/20210905085717.7427-1-mgurtovoy@nvidia.com
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > Reviewed-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > It's harmless but doesn't seem appropriate for stable.
> 
> Oh, I guess it's been picked because the next patch that
> was picked depends on it. OK then, sorry about the noise.

Yeah, that's why I grabbed it :)

thanks,

greg k-h
