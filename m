Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7242E4315EB
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 12:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhJRKYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 06:24:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25898 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230176AbhJRKY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 06:24:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634552537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ucu6OPj0gfVnOH8WD319AytIXiy/rWkJCsxQDS8jQIU=;
        b=BObz6SiI3m9OMq3BCd1A2IkvNiHTPVkmWgZRPIOY3lRxCC4+kMtISSPMi3A8rNiUsdXEQN
        +ZKBkXBgDAIcRmOLj0ylvHrgNH7jXX4R7h5r8q47Ji5OjjwnT/KhoEYzzyJXKNCPg7GQnh
        3ay5g0424exoSv+p0XvZ7GN2EZR5lfw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-BMXptSj6MOWzFnYO6BYbmw-1; Mon, 18 Oct 2021 06:22:14 -0400
X-MC-Unique: BMXptSj6MOWzFnYO6BYbmw-1
Received: by mail-wr1-f71.google.com with SMTP id r21-20020adfa155000000b001608162e16dso8621862wrr.15
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 03:22:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ucu6OPj0gfVnOH8WD319AytIXiy/rWkJCsxQDS8jQIU=;
        b=aso4mH1AnllAa4dZxxSGoGkJoWx+iqfmGD7UKRwP0V0G8uF/gnnPYUC5qYahIKcYFH
         3DYSlXGqTs4Zlz7tMBs9GeXXavBvkezn9FKbvxlYgPLkoFY0+qRasYr8hB5I0ZmvGFPJ
         rE/ZqNUQYJod8Yim0Db7u/5yWGJObOd251S4DMP2Vb6BDDMnj2tdvIps7V/KcVpVB0qu
         6023z6WAV9ge1VA7XRVtgcsaxosKaCX6j9ihVD2u9GTn6HtGKdJYijU80q3s4pQmY4UB
         0e25gytY9MP1GmxdpsMVy7DT3C1GlBhrH6XIIKVNNLefucR3HDXNK6JEugJogUfZwe0X
         SlBQ==
X-Gm-Message-State: AOAM531qtiJyQ8LF/ZkhdXk0yZP1YK5IdzrXmv6Va8S0SERHP+v1f0Ey
        HVxTEKqK7LoC8nFCm4hQ14Sk7FDu6AHM09GVIg5iDucJ2C5wOA+Qg2ex0iUMoZXqSH35UFzowa9
        Al7gh/IQ3KtHz47k3
X-Received: by 2002:a7b:c5cc:: with SMTP id n12mr29419868wmk.43.1634552533062;
        Mon, 18 Oct 2021 03:22:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+GQwtBWv5cVJqVKKgAsNXtvppyd8Y3Jh6ZqWTv8ibMz+Q0eBdwcYGPimEeJJbTRpnw9Af+A==
X-Received: by 2002:a7b:c5cc:: with SMTP id n12mr29419856wmk.43.1634552532909;
        Mon, 18 Oct 2021 03:22:12 -0700 (PDT)
Received: from redhat.com ([2.55.19.190])
        by smtp.gmail.com with ESMTPSA id w1sm17761835wmc.19.2021.10.18.03.22.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 03:22:12 -0700 (PDT)
Date:   Mon, 18 Oct 2021 06:22:08 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     gregkh@linuxfoundation.org
Cc:     ckulkarnilinux@gmail.com, hch@lst.de, mgurtovoy@nvidia.com,
        stefanha@redhat.com, stable-commits@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: Patch "virtio-blk: remove unneeded "likely" statements" has been
 added to the 5.14-stable tree
Message-ID: <20211018062109-mutt-send-email-mst@kernel.org>
References: <163455135025212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163455135025212@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 18, 2021 at 12:02:30PM +0200, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>     virtio-blk: remove unneeded "likely" statements
> 
> to the 5.14-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      virtio-blk-remove-unneeded-likely-statements.patch
> and it can be found in the queue-5.14 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
> >From 6105d1fe6f4c24ce8c13e2e6568b16b76e04983d Mon Sep 17 00:00:00 2001
> From: Max Gurtovoy <mgurtovoy@nvidia.com>
> Date: Sun, 5 Sep 2021 11:57:17 +0300
> Subject: virtio-blk: remove unneeded "likely" statements
> 
> From: Max Gurtovoy <mgurtovoy@nvidia.com>
> 
> commit 6105d1fe6f4c24ce8c13e2e6568b16b76e04983d upstream.
> 
> Usually we use "likely/unlikely" to optimize the fast path. Remove
> redundant "likely/unlikely" statements in the control path to simplify
> the code and make it easier to read.
> 
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> Link: https://lore.kernel.org/r/20210905085717.7427-1-mgurtovoy@nvidia.com
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

It's harmless but doesn't seem appropriate for stable.

> ---
>  drivers/block/virtio_blk.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -765,7 +765,7 @@ static int virtblk_probe(struct virtio_d
>  		goto out_free_vblk;
>  
>  	/* Default queue sizing is to fill the ring. */
> -	if (likely(!virtblk_queue_depth)) {
> +	if (!virtblk_queue_depth) {
>  		queue_depth = vblk->vqs[0].vq->num_free;
>  		/* ... but without indirect descs, we use 2 descs per req */
>  		if (!virtio_has_feature(vdev, VIRTIO_RING_F_INDIRECT_DESC))
> @@ -839,7 +839,7 @@ static int virtblk_probe(struct virtio_d
>  	else
>  		blk_size = queue_logical_block_size(q);
>  
> -	if (unlikely(blk_size < SECTOR_SIZE || blk_size > PAGE_SIZE)) {
> +	if (blk_size < SECTOR_SIZE || blk_size > PAGE_SIZE) {
>  		dev_err(&vdev->dev,
>  			"block size is changed unexpectedly, now is %u\n",
>  			blk_size);
> 
> 
> Patches currently in stable-queue which might be from mgurtovoy@nvidia.com are
> 
> queue-5.14/virtio-blk-remove-unneeded-likely-statements.patch

