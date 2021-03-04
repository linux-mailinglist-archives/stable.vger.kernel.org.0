Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A76532D46B
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 14:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239650AbhCDNov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 08:44:51 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:46585 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241488AbhCDNoa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 08:44:30 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 6A0E6137A;
        Thu,  4 Mar 2021 08:43:24 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 04 Mar 2021 08:43:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=3t4P+JhB7p4fkbRJtswUyrUfet0
        7qdIG0x85DU0W1LU=; b=Hhj3vX5W2QNRpAWq/PTFJ2/o6tMz4oWPSy9e61XrTIr
        LLl46uH5SHcO2K4M+81WbpQOf32ZlDdnJsivGyWfyCnmFNk2CXZ1yodqa1EnV8sq
        2xWIISuYmnfyMWcKXpWWUHn7yDCO7PLXGvFwKij/uyhgUMGwu6pPUJ86khEwBeSd
        kz0hbwtPITGAY3LSGH/1w+LA95PVP8ZUt4uDEIBB742gcIWWRSbr0QP4cTzxpw4f
        qt9JK+zBFcl0u2H3almmbkAhk4xXXxAyQcJ22CkoPqopaW6ZQ++rZp3pB4KbjiBG
        bXneTl5W6sGHkp+35rMobYdPkRi+ZnwCdRoPmNIfPvw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=3t4P+J
        hB7p4fkbRJtswUyrUfet07qdIG0x85DU0W1LU=; b=E1ZzjSKLxJJUxFnZyQctV1
        LLAdPEapCa40XCY5/+pNw0ymLHMClVH0biIDHI6pzOqLMY/SpyOlwaISM8A7lINe
        FkQrBYO5u1i2W9hZw5Ds9AgZDvNPjxH6iBbAAruKDde5wJnRcISRemBgsc0DwzKv
        tu/53voCX1t6ZAfYbeC94gVj/a3XdA2+3FQTqXRDfauR2H04syJUcxql3MXpOdh2
        pk8+CmSgs5ScXH14tGsAd198rC7tPTZAQ6sg9Fp17/DaxHLlTeRNYQss+6Bv1tLz
        ZP/YMF8FHnjameMk6Q6u9zDNX5EOsNStZgKQ2+sBKrkHgxwkbm5tfkWZKgyjXbsg
        ==
X-ME-Sender: <xms:--NAYNwIh2PDW9uffHEihVpeL96o_yAdHJpN7WmTwd7qbJyu_LzKQA>
    <xme:--NAYNSJOu3tqANLdB97h7OK80Q4BkkCPWSxgkC77hzNwKe79ZXWJXAyyjJMHvWNL
    -toJX9yNCh0xw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtgedghedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:--NAYHV_kXhJDY16UbzbaylH3kgFl2NmcJKOZCbLb16h8tB6vHXYBg>
    <xmx:--NAYPjONUkPqaiEunvpJb_9qiXd1qzTiT_3LbOf0bOn3ubu8vvM_A>
    <xmx:--NAYPCzv5zEXX_C-YOpoT4hx4Lk4y5Sxg4PsB-YAFBglOwRWQb18g>
    <xmx:_ONAYE7Bquh_THQa4tcDIamkg9ZmgCR2WH4TmAds2lQma8ZdPyAPgw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4EC9D1080054;
        Thu,  4 Mar 2021 08:43:23 -0500 (EST)
Date:   Thu, 4 Mar 2021 14:43:21 +0100
From:   Greg KH <greg@kroah.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH 4.19.y] virtio/s390: implement virtio-ccw revision 2
 correctly
Message-ID: <YEDj+c+4uPB5+rQq@kroah.com>
References: <20210302112419.1429674-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302112419.1429674-1-cohuck@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 12:24:19PM +0100, Cornelia Huck wrote:
> [Backport of commit 182f709c5cff683e6732d04c78e328de0532284f to
>  4.19-stable; context diff in second hunk]
> 
> CCW_CMD_READ_STATUS was introduced with revision 2 of virtio-ccw,
> and drivers should only rely on it being implemented when they
> negotiated at least that revision with the device.
> 
> However, virtio_ccw_get_status() issued READ_STATUS for any
> device operating at least at revision 1. If the device accepts
> READ_STATUS regardless of the negotiated revision (which some
> implementations like QEMU do, even though the spec currently does
> not allow it), everything works as intended. While a device
> rejecting the command should also be handled gracefully, we will
> not be able to see any changes the device makes to the status,
> such as setting NEEDS_RESET or setting the status to zero after
> a completed reset.
> 
> We negotiated the revision to at most 1, as we never bumped the
> maximum revision; let's do that now and properly send READ_STATUS
> only if we are operating at least at revision 2.
> 
> Cc: stable@vger.kernel.org
> Fixes: 7d3ce5ab9430 ("virtio/s390: support READ_STATUS command for virtio-ccw")
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> Link: https://lore.kernel.org/r/20210216110645.1087321-1-cohuck@redhat.com
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  drivers/s390/virtio/virtio_ccw.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 67efdf25657f..0447ae2781ba 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -103,7 +103,7 @@ struct virtio_rev_info {
>  };
>  
>  /* the highest virtio-ccw revision we support */
> -#define VIRTIO_CCW_REV_MAX 1
> +#define VIRTIO_CCW_REV_MAX 2
>  
>  struct virtio_ccw_vq_info {
>  	struct virtqueue *vq;
> @@ -911,7 +911,7 @@ static u8 virtio_ccw_get_status(struct virtio_device *vdev)
>  	u8 old_status = *vcdev->status;
>  	struct ccw1 *ccw;
>  
> -	if (vcdev->revision < 1)
> +	if (vcdev->revision < 2)
>  		return *vcdev->status;
>  
>  	ccw = kzalloc(sizeof(*ccw), GFP_DMA | GFP_KERNEL);
> -- 
> 2.26.2
> 

Both backports now queued up, thanks.

greg k-h
