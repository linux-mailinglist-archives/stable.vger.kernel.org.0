Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8CF6A6F5F
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 16:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjCAPZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 10:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjCAPZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 10:25:39 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE32B4C29
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 07:25:36 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 799F032008FB;
        Wed,  1 Mar 2023 10:25:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 01 Mar 2023 10:25:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1677684335; x=1677770735; bh=gtGT/ztUyY
        pHwYl1T4nSn1xXWMCDzinVOweu13xNCRY=; b=KwDV3lfgSaNScPp6cMPO+JxMDJ
        s7ipAmlaJgHkKxtcjPcrftKDjBRJpedmiKqdI3mr5Z5HNyNnFwysZ/O9Th0LmlmC
        Cmi17bWl3RYTdzNBhajB8l+83P9IvURcZn7opvD9052+/LXWYI+rG9o4JiUbTHMb
        CsYielIXT9Sb8YI6y9EudxsSV+nkGO3KQVTypflkYxVM3arhtYu66q0snkhtFSNt
        iZrywRGvQ69qSSkgkzbz3gy1EYbJ0r0jDsAXj0wv8OaUp2uFN3xma7Yxdg2ocDcJ
        mOw1IYZgO89NHFI9wTUY2Hmk6hEBdgSVL45YjfkxGqSw+OqkGG/m+LCqvFzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1677684335; x=1677770735; bh=gtGT/ztUyYpHwYl1T4nSn1xXWMCD
        zinVOweu13xNCRY=; b=SCC8Ufis3Oje+0n853XCJiYXnxN/UbNO+v2vAvwZXA6A
        J9OB/8YlT+CZ4bmsFjHXwfIUI6qRaM2sLN549PcOstpFtYEAl2g6xw4qIv5JOSzS
        CxjwZiTgwAJq3P8IMcUc+f7X3qqqCMX7uoRvxJ32OJkRQF5xvz6hCMfP7heT4kM0
        pm6cJpRoMsJPVxDLizS/GSwKX9KQLzYCRhT0FSsL0b0Y4SSIzqmf5QuSiFL8m6Ir
        St3H9H0dqJn3cebsHUKIy5whKuTlTcVhb1sotyG7CVQ8bn0yR3X1H++ydUuYdcFn
        B0latcyY0BwveQ8tIm1mfZ8kulmL1MCpcYOmGxm+JQ==
X-ME-Sender: <xms:bm7_Y47THTL217PLXmw2CFVvHK_Blt3Kl1_mkbzhyWfihMCEL3PxXw>
    <xme:bm7_Y57DopUBmpM2m0v7eeQFwwYDRBLEHvBLFnXMzvqSAx7-7k46jEoIDHy54DHee
    5y2h5C-R1aMeQ>
X-ME-Received: <xmr:bm7_Y3eWFUOBSp2RL0YGRnAm_fYN3Nt5053HWm6PCRBCpRqCETe80kRoFfrIvXAt9nmJ1keLtEdVLTugsEN4Y-xj2XM28FOzwBc0LQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudelhedgieekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepleeite
    evieefteelfeehveegvdetveehgffhvdejffdvleevhfffgeffffejlefgnecuffhomhgr
    ihhnpehfrhgvvgguvghskhhtohhprdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:bm7_Y9Jm9yGT8hhLemigQUOhOOahhe0Guj8P6pOIkc6kqj8Mt38eTw>
    <xmx:bm7_Y8I3k97zbk6efM6L391c_7rsp7fPLs0mS0pFO_50jV7IJLJ9UA>
    <xmx:bm7_Y-ylhSx5VAwC7kVcNnBDCYovStZQBJfjjrCQfuxOmyVzQclTMQ>
    <xmx:b27_Y78KQzmalJtxY0N0VdYYbpoRwiFCyEX-p3mhsF9hcaQhVjYZbA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Mar 2023 10:25:33 -0500 (EST)
Date:   Wed, 1 Mar 2023 16:25:32 +0100
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@eng.windriver.com>
Cc:     stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: Re: [PATCH 5.10 1/2] drm/virtio: Fix NULL vs IS_ERR checking in
 virtio_gpu_object_shmem_init
Message-ID: <Y/9ubECNNjPm54cB@kroah.com>
References: <20230301143458.3440128-1-ovidiu.panait@eng.windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301143458.3440128-1-ovidiu.panait@eng.windriver.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 04:34:57PM +0200, Ovidiu Panait wrote:
> From: Miaoqian Lin <linmq006@gmail.com>
> 
> commit c24968734abfed81c8f93dc5f44a7b7a9aecadfa upstream.
> 
> Since drm_prime_pages_to_sg() function return error pointers.
> The drm_gem_shmem_get_sg_table() function returns error pointers too.
> Using IS_ERR() to check the return value to fix this.
> 
> Fixes: 2f2aa13724d5 ("drm/virtio: move virtio_gpu_mem_entry initialization to new function")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> Link: http://patchwork.freedesktop.org/patch/msgid/20220602104223.54527-1-linmq006@gmail.com
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>  drivers/gpu/drm/virtio/virtgpu_object.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
> index 0c98978e2e55..d4fab3361d2c 100644
> --- a/drivers/gpu/drm/virtio/virtgpu_object.c
> +++ b/drivers/gpu/drm/virtio/virtgpu_object.c
> @@ -157,9 +157,9 @@ static int virtio_gpu_object_shmem_init(struct virtio_gpu_device *vgdev,
>  	 * since virtio_gpu doesn't support dma-buf import from other devices.
>  	 */
>  	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base.base);
> -	if (!shmem->pages) {
> +	if (IS_ERR(shmem->pages)) {
>  		drm_gem_shmem_unpin(&bo->base.base);
> -		return -EINVAL;
> +		return PTR_ERR(shmem->pages);
>  	}
>  
>  	if (use_dma_api) {
> -- 
> 2.39.1
> 

Both now queued up,t hanks.

greg k-h
