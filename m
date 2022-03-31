Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909FE4ED3D7
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 08:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiCaGXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 02:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiCaGXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 02:23:35 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31FE71EC9A8
        for <stable@vger.kernel.org>; Wed, 30 Mar 2022 23:21:49 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 9529C32009DF;
        Thu, 31 Mar 2022 02:21:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 31 Mar 2022 02:21:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; bh=jr+JH/uOTB9dOJPAlNRvXyxLKzovWsa10A+4al
        MTXTU=; b=Iy2lyqMpXKSPuQD+q6UTa1zIUbkoFr2WIHJTzwA8l2GV42IcqEcZAa
        QLVGlLPq/LlRKiagEVVx7bxtJSb56P8JumKSo0EbHlYW9JdBwPeps1gVMzD2DJo9
        Gur/te1D9ByauZPZ6+MdUaArxSRIklcubJjx/ES4zgxBGHpfJvyA/+/qPL4wmBJr
        KUuKwyXuiOfodyWyhJyRjuMsR5N8b8Nk+f6Qi09Mf/1nWAAcI6RiS+9SjD2YunD2
        fA2WWQAGQgHfAqTYfOZxLUzYygzxpCNKA4Y9ggBsmp4meJkLcl9naRtzR6NAcGyX
        NTZ/4xk4KyHS21WKql3L5oxITIAqdGdg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=jr+JH/uOTB9dOJPAl
        NRvXyxLKzovWsa10A+4alMTXTU=; b=mAhP2hLx24RLfCwJX0d3AWtQxyRGeMg4l
        w7JlMjiIW2sLO/pgoLZXHpv1Z1WUne8u5H8M0wQg5F09OBUnI11yjk6Xx5CZ8Vfr
        pyQz9whWyQHngqSeGfu/qxj8DkkZUkWgATJUiwZa04wT25QCoKb/n6HEtuSpL6kp
        N8SKii51XNh/hr5qe1Wr+LiAk8A9fELCQjx7i5Lp3N+WwCqcOLQ3VheWpopS1Zbm
        kcAzNpAIeuxWHjUpYKTz8nq7pdNYiGbt/W8rLvjfw/a9qx+qZw394/Hltj0nsxZ4
        lfrJC5/DBUOQLb5VIiSyc9o/xvQgRKm/I5u4A+QlDRZs1NFbkE+8Q==
X-ME-Sender: <xms:eEhFYkEYJHOItuqKTvy2bsc7HiHW6gK4JW7pRyNUFh7GUdXES8oYQA>
    <xme:eEhFYtXVCnYt97NE_R44Wq_1Z4W39dKRV7geLYmrbexutJOgGyQVj9dSl892R1A1J
    g_ntYawYBpFGg>
X-ME-Received: <xmr:eEhFYuLBdsw4boGqgTig7Ne0zoCo5eOPfZPlAvQmhGRCuDt1C5aS67EJi2TuhWEGBeqG5B2DuN5KAnaxeRQRx6Id8pq2K0pE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeifedguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelle
    dtheekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:eEhFYmEF_b2_ZqoiiHWOwvIWkI6IEqaytffRIowab47g-bJQTWAwQg>
    <xmx:eEhFYqU0QIctFoC1uy0SSsGS_2nSln1fn4XBhZIWDG6-vWSae7Z3WA>
    <xmx:eEhFYpNEpWSNzAlkW-ZOoRZVr6FrceW2eaNgYgIskKyMi_TbMqH-Rg>
    <xmx:eUhFYurmwakGcpzb5hYGf_YMlYGcjYSR__hjRhIIUH39favYAshEQg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 31 Mar 2022 02:21:44 -0400 (EDT)
Date:   Thu, 31 Mar 2022 08:21:42 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v2 5.10 1/1] virtio-blk: Use blk_validate_block_size() to
 validate block size
Message-ID: <YkVIdiO54yKGdlXh@kroah.com>
References: <20220330123258.551985-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330123258.551985-1-lee.jones@linaro.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 01:32:58PM +0100, Lee Jones wrote:
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

You didn't mention what changed from v1 :)

Anyway, all now queued up, thanks.

greg k-h
