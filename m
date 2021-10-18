Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2E34315F0
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 12:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhJRKZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 06:25:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229473AbhJRKZ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 06:25:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634552597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Pwtz9SlH9QshUYNJLW5XHbdHTN56vklQh/bHHlKAr3E=;
        b=XQzIHMtjURVI1iJDaSTfY/Qy//VO2tp94SxTQ8Z9u/Vwy1hTcr1rfdDTUWqqUArP2R15G2
        vDv2iLHG8FPTTqoJzDtdUiBbIvKGpnou3X/jhwJFfdGLigokjDN9y1sAa+wkH9nON6eG++
        qAcosj/Y4NLRPxvxiqz0cnL5bDijg7A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-YeQ4_Q8QO3yyfrQCAFjiJw-1; Mon, 18 Oct 2021 06:23:16 -0400
X-MC-Unique: YeQ4_Q8QO3yyfrQCAFjiJw-1
Received: by mail-wr1-f72.google.com with SMTP id c4-20020a5d6cc4000000b00160edc8bb28so8673783wrc.9
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 03:23:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Pwtz9SlH9QshUYNJLW5XHbdHTN56vklQh/bHHlKAr3E=;
        b=BIfqCUUhQ55OlY4JZ+6a4DthGGl+A0lPEZ7EzgvjUuHUEsS0AOE9aUiSPdO41auHvu
         fPwq69VlX1/vZKDeJu3SR8AUobskUp85HzEc4hZVE/qW7hrGPFH+Ma/lwvVwZq3+vSXX
         LfWyXKM5wXdgWvFwFgMwnBQhHypUCef8gpScvXaqqGwMuLd0YUwWrO6v3XtoqZUUYpZJ
         r4ftjKefXtMN5n9aDoTeZoGjyyy10WtmW55eLGMszPncFvxL02JBh4y3QwB71q2WbGPG
         NoDUxRaLE2Atv7i4DV0ZKYSDNsYHXq+213SvKySWv9uC7bNDhnr1O7iSAgiFGiWbPXjm
         40xg==
X-Gm-Message-State: AOAM530EoiZPj+aXFtZRG0LxOEMzksaPEbNgSgascPCnzjLbNCOOgM5P
        XWOkRUHkp/zx8Uk09DdDJGBUMvBBvoBMkhAW7BAoX4hvTL3CJYdrlWgYIRxlzCfmpNggbXePJwd
        LOh9x2c6p0wb7rMWc
X-Received: by 2002:a5d:6904:: with SMTP id t4mr35273083wru.242.1634552594977;
        Mon, 18 Oct 2021 03:23:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztMgAh+9Kru2xb6cgTnqwbgK7iEFim5be2aQ+6sAVfpb5GXUKee5sl7jhCU3fLTSUWRWhavw==
X-Received: by 2002:a5d:6904:: with SMTP id t4mr35273063wru.242.1634552594840;
        Mon, 18 Oct 2021 03:23:14 -0700 (PDT)
Received: from redhat.com ([2.55.19.190])
        by smtp.gmail.com with ESMTPSA id q12sm8525283wrp.13.2021.10.18.03.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 03:23:14 -0700 (PDT)
Date:   Mon, 18 Oct 2021 06:23:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     ckulkarnilinux@gmail.com, hch@lst.de, mgurtovoy@nvidia.com,
        stefanha@redhat.com, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "virtio-blk: remove unneeded "likely" statements" has been
 added to the 5.14-stable tree
Message-ID: <20211018062237-mutt-send-email-mst@kernel.org>
References: <163455135025212@kroah.com>
 <20211018062109-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018062109-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 06:22:13AM -0400, Michael S. Tsirkin wrote:
> On Mon, Oct 18, 2021 at 12:02:30PM +0200, gregkh@linuxfoundation.org wrote:
> > 
> > This is a note to let you know that I've just added the patch titled
> > 
> >     virtio-blk: remove unneeded "likely" statements
> > 
> > to the 5.14-stable tree which can be found at:
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >      virtio-blk-remove-unneeded-likely-statements.patch
> > and it can be found in the queue-5.14 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> > 
> > >From 6105d1fe6f4c24ce8c13e2e6568b16b76e04983d Mon Sep 17 00:00:00 2001
> > From: Max Gurtovoy <mgurtovoy@nvidia.com>
> > Date: Sun, 5 Sep 2021 11:57:17 +0300
> > Subject: virtio-blk: remove unneeded "likely" statements
> > 
> > From: Max Gurtovoy <mgurtovoy@nvidia.com>
> > 
> > commit 6105d1fe6f4c24ce8c13e2e6568b16b76e04983d upstream.
> > 
> > Usually we use "likely/unlikely" to optimize the fast path. Remove
> > redundant "likely/unlikely" statements in the control path to simplify
> > the code and make it easier to read.
> > 
> > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > Link: https://lore.kernel.org/r/20210905085717.7427-1-mgurtovoy@nvidia.com
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Reviewed-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> It's harmless but doesn't seem appropriate for stable.

Oh, I guess it's been picked because the next patch that
was picked depends on it. OK then, sorry about the noise.

> > ---
> >  drivers/block/virtio_blk.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > --- a/drivers/block/virtio_blk.c
> > +++ b/drivers/block/virtio_blk.c
> > @@ -765,7 +765,7 @@ static int virtblk_probe(struct virtio_d
> >  		goto out_free_vblk;
> >  
> >  	/* Default queue sizing is to fill the ring. */
> > -	if (likely(!virtblk_queue_depth)) {
> > +	if (!virtblk_queue_depth) {
> >  		queue_depth = vblk->vqs[0].vq->num_free;
> >  		/* ... but without indirect descs, we use 2 descs per req */
> >  		if (!virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC))
> > @@ -839,7 +839,7 @@ static int virtblk_probe(struct virtio_d
> >  	else
> >  		blk_size = queue_logical_block_size(q);
> >  
> > -	if (unlikely(blk_size < SECTOR_SIZE || blk_size > PAGE_SIZE)) {
> > +	if (blk_size < SECTOR_SIZE || blk_size > PAGE_SIZE) {
> >  		dev_err(&vdev->dev,
> >  			"block size is changed unexpectedly, now is %u\n",
> >  			blk_size);
> > 
> > 
> > Patches currently in stable-queue which might be from mgurtovoy@nvidia.com are
> > 
> > queue-5.14/virtio-blk-remove-unneeded-likely-statements.patch

