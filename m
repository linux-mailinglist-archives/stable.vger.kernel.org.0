Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304EB4EC226
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345204AbiC3L60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344388AbiC3LxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:05 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E98D26133B
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 04:48:47 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id DD0FF3200929;
        Wed, 30 Mar 2022 07:48:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 30 Mar 2022 07:48:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; bh=0ie1vOuUlmvcqbJueGwGrFKk+TZXXWsXNeB8rF
        MU5us=; b=X8O+NJdVyc8lFmzfOGsG42LP59t5U6LaiNMyxEhbk2aVnfsSYNjxH8
        Rd7pIcpQ5f3hk8Fyr5s61SRTl0rhLczzPh/XnhzkcSgtBMsoxSXIfHTwTEFr1RqB
        biArQQ6kf7Zt5Ca6hQt/hfWOJwW2S8I5DxeQUtksLjEvfnrcx3QICZgQQs5UB7c+
        cJ6d2bhfoIwD3yc7C32pGsFejIb0aFjtFXJ+CINq4KdpbE+XFQJGLRLxIUsIYd8F
        AlMSQA60CMgnrdrIV/rRrtAZ7QyEUoA2AIsJ9+73LSUjswX84DjCAQAzt6YU6pX2
        s7/uBeIchAUka4garL6HD0wm7WRnS2ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0ie1vOuUlmvcqbJue
        GwGrFKk+TZXXWsXNeB8rFMU5us=; b=itqCKo0ssV8/nmagxJgCaXYHYesOQ7G/6
        yyLXkT+kpW3MjJL4wZfef8G1AI65qNFuepmyDUNrbcwLwRad/I9cgWLNfo0nds6k
        /MB18dQpO7MGY3CdSKX0KHe/bilMpGY2LJjQ2zsjhHtiovmM7TWp9kx+wTMkgec0
        u/XfWh1EKXowEYnJxoSljJAEXRLg04njy62ZYkX/DRFN3tySeYF8eCYG1Fl6ulk2
        YswmQgLWyygZOZZdbPvkzKH3UqtmruR16jOFITI8Q0NzIy7OYLTT1j+gSCKEcTut
        2b+XlbPd0ddQJV7SlJBUubsed2GuOXhzLPSeDcELeyD9A6OSbR1aA==
X-ME-Sender: <xms:lUNEYj5GZl3yMIn0IGUQjHxbZqUdD8sP7BQd2kll9P5dHZFEDAbFgA>
    <xme:lUNEYo64xXQ3SCOPLn3ChqU4lQSCBy6BnLT3oqAMAWufua3g9M0O-RjNRtrOBI49n
    Jz8KIGopF5VoQ>
X-ME-Received: <xmr:lUNEYqeAR5ouxg3Mhdn-bRDJk0A64x6ox8wsmkBuus38iRaZnD3Ha3bg5U6_dweCY6Z5cClCJrUKDMvPPYy5g8HzDqYTQHGa>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeivddggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:lUNEYkI9355UXMH4imHKjDL2mTJgh1IM_HhUAxWcEgXE97iVtODdTA>
    <xmx:lUNEYnIlMicgoq780Ad993LacbeIKM4967ccRpme6XXBc1ARgiYpuQ>
    <xmx:lUNEYtz5_J-fcruJIKrdGH9AXghxbHMIhXIswXoM_SyKz52SXWIxLQ>
    <xmx:lUNEYu_gg96cAWXnIJGexA7GQoZ-P_zUd9bWCsqKobnq4n6zQP37Zg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 30 Mar 2022 07:48:36 -0400 (EDT)
Date:   Wed, 30 Mar 2022 13:48:34 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] virtio-blk: Use blk_validate_block_size() to
 validate block size
Message-ID: <YkRDkvAlGAeOeS4t@kroah.com>
References: <20220330110107.465728-1-lee.jones@linaro.org>
 <20220330110107.465728-2-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330110107.465728-2-lee.jones@linaro.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 12:01:07PM +0100, Lee Jones wrote:
> From: Xie Yongji <xieyongji@bytedance.com>
> 
> [ Upstream commit 57a13a5b8157d9a8606490aaa1b805bafe6c37e1 ]
> 
> The block layer can't support a block size larger than
> page size yet. And a block size that's too small or
> not a power of two won't work either. If a misconfigured
> device presents an invalid block size in configuration space,
> it will result in the kernel crash something like below:
> 
> [  506.154324] BUG: kernel NULL pointer dereference, address: 0000000000000008
> [  506.160416] RIP: 0010:create_empty_buffers+0x24/0x100
> [  506.174302] Call Trace:
> [  506.174651]  create_page_buffers+0x4d/0x60
> [  506.175207]  block_read_full_page+0x50/0x380
> [  506.175798]  ? __mod_lruvec_page_state+0x60/0xa0
> [  506.176412]  ? __add_to_page_cache_locked+0x1b2/0x390
> [  506.177085]  ? blkdev_direct_IO+0x4a0/0x4a0
> [  506.177644]  ? scan_shadow_nodes+0x30/0x30
> [  506.178206]  ? lru_cache_add+0x42/0x60
> [  506.178716]  do_read_cache_page+0x695/0x740
> [  506.179278]  ? read_part_sector+0xe0/0xe0
> [  506.179821]  read_part_sector+0x36/0xe0
> [  506.180337]  adfspart_check_ICS+0x32/0x320
> [  506.180890]  ? snprintf+0x45/0x70
> [  506.181350]  ? read_part_sector+0xe0/0xe0
> [  506.181906]  bdev_disk_changed+0x229/0x5c0
> [  506.182483]  blkdev_get_whole+0x6d/0x90
> [  506.183013]  blkdev_get_by_dev+0x122/0x2d0
> [  506.183562]  device_add_disk+0x39e/0x3c0
> [  506.184472]  virtblk_probe+0x3f8/0x79b [virtio_blk]
> [  506.185461]  virtio_dev_probe+0x15e/0x1d0 [virtio]
> 
> So let's use a block layer helper to validate the block size.
> 
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Link: https://lore.kernel.org/r/20211026144015.188-5-xieyongji@bytedance.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/block/virtio_blk.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 4b3645e648ee9..2af9d7c7d45cd 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -936,9 +936,17 @@ static int virtblk_probe(struct virtio_device *vdev)
>  	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_BLK_SIZE,
>  				   struct virtio_blk_config, blk_size,
>  				   &blk_size);
> -	if (!err)
> +	if (!err) {
> +		err = blk_validate_block_size(blk_size);
> +		if (err) {
> +			dev_err(&vdev->dev,
> +				"virtio_blk: invalid block size: 0x%x\n",
> +				blk_size);
> +			goto out_cleanup_disk;
> +		}
> +
>  		blk_queue_logical_block_size(q, blk_size);
> -	else
> +	} else
>  		blk_size = queue_logical_block_size(q);
>  
>  	/* Use topology information if available */
> -- 
> 2.35.1.1021.g381101b075-goog
> 

You didn't build this one either :(

{sigh}

Care to start over?  It's in the 5.15 queue.  Please submit tested
patches for any/all other branches you want this in.

thanks,

greg k-h
