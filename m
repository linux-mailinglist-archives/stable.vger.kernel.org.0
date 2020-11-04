Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A37A2A6C9A
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 19:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732329AbgKDSVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 13:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732328AbgKDSVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 13:21:49 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FB7C0613D4
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 10:21:49 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id o129so17999113pfb.1
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 10:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z8gc6ARs/YzzuiIYGit2cDBKpxrUS5sAZ12IGbVfp4I=;
        b=mS9aIDQz02BPksqMQmtfWq2bRIfqGdCcrb3TZ8qXpCcucwMkUkXsnRClnS4SlW9Bsc
         7BJNnaw7i7WOANvIk6NmLJpreM9AlXCICLQDhtF6oWj40nunCVTsiVFQ2MgOsMgp0dZT
         e94ZVvvSWBcWyRqDjMdvS/B8S2znVU0A+7eShjWgu0NNLbWl5tSfmpYLB160GSEJvbBA
         Dd6HG7wOuW9ZYLK5A4EmSECwPyxgd4n3ZSqEmVE6IlntJ3LSBrFH+y3UNjHtCwyVV56p
         nJTniVE6YIbcOL1xuGB1GPwpo6+N2DWAUPigNRnLlvHkxU6NLjDdTy/JboMLapL3k/Z7
         OVDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z8gc6ARs/YzzuiIYGit2cDBKpxrUS5sAZ12IGbVfp4I=;
        b=OyfGiqpK+MDxlxJncJmtQt8Us85ckPBTEiKhz/14yNhaFx43ygjy6gjZ9RUBCRrlOK
         C5Oplg9ZmxKxDwN1GLuha1KvyB5WeELA8T0OaZgDKZ6rZLv3BctHwptysMtITIonH/YC
         RqccHF9kQuyQhv2BvAZGcOfnYxX455QeU2uwnY8SUlGPg442aQYH/TwhTEj8eccbi9oE
         Vjo2n01ScgdjeEHSVKPrUfR3/wVdCLWa/x3RWO7RnOwu7EN6/7Ds7iIYZ/AnCVrd3Xae
         z/reWcWVCmpQ6j8jTykqV2mK102Ync9NgbzLJmWdaN3YlpOIP1JCz3FE+Tn2XD2SOdD9
         Yuhw==
X-Gm-Message-State: AOAM5305QA6sKvGQmZjadJTKyuse3DmOn7Ij8k8jJ1DNUY1d65X3vBvm
        DRPsGyD70S0/i+Rsc5MdcnCu2vGANE/Gmw==
X-Google-Smtp-Source: ABdhPJxKUPsUDYJlcLkUimYNsligw92mxLn0ooxNeaCj3i3jNbmfb0dEaj/exRRAJYPqif6kUP99Ng==
X-Received: by 2002:a63:4c51:: with SMTP id m17mr22137626pgl.270.1604514109032;
        Wed, 04 Nov 2020 10:21:49 -0800 (PST)
Received: from xps15 (S0106002369de4dac.cg.shawcable.net. [68.147.8.254])
        by smtp.gmail.com with ESMTPSA id u5sm2785866pjn.15.2020.11.04.10.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 10:21:48 -0800 (PST)
Date:   Wed, 4 Nov 2020 11:21:46 -0700
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Suman Anna <s-anna@ti.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH virtio] virtio: virtio_console: fix DMA memory allocation
 for rproc serial
Message-ID: <20201104182146.GC2893396@xps15>
References: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AOKowLclCbOCKxyiJ71WeNyuAAj2q8EUtxrXbyky5E@cp7-web-042.plabs.ch>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 04, 2020 at 03:31:36PM +0000, Alexander Lobakin wrote:
> Since commit 086d08725d34 ("remoteproc: create vdev subdevice with
> specific dma memory pool"), every remoteproc has a DMA subdevice
> ("remoteprocX#vdevYbuffer") for each virtio device, which inherits
> DMA capabilities from the corresponding platform device. This allowed
> to associate different DMA pools with each vdev, and required from
> virtio drivers to perform DMA operations with the parent device
> (vdev->dev.parent) instead of grandparent (vdev->dev.parent->parent).
> 
> virtio_rpmsg_bus was already changed in the same merge cycle with
> commit d999b622fcfb ("rpmsg: virtio: allocate buffer from parent"),
> but virtio_console did not. In fact, operations using the grandparent
> worked fine while the grandparent was the platform device, but since
> commit c774ad010873 ("remoteproc: Fix and restore the parenting
> hierarchy for vdev") this was changed, and now the grandparent device
> is the remoteproc device without any DMA capabilities.
> So, starting v5.8-rc1 the following warning is observed:
> 
> [    2.483925] ------------[ cut here ]------------
> [    2.489148] WARNING: CPU: 3 PID: 101 at kernel/dma/mapping.c:427 0x80e7eee8
> [    2.489152] Modules linked in: virtio_console(+)
> [    2.503737]  virtio_rpmsg_bus rpmsg_core
> [    2.508903]
> [    2.528898] <Other modules, stack and call trace here>
> [    2.913043]
> [    2.914907] ---[ end trace 93ac8746beab612c ]---
> [    2.920102] virtio-ports vport1p0: Error allocating inbufs
> 
> kernel/dma/mapping.c:427 is:
> 
> WARN_ON_ONCE(!dev->coherent_dma_mask);
> 
> obviously because the grandparent now is remoteproc dev without any
> DMA caps:

You are correct.

> 
> [    3.104943] Parent: remoteproc0#vdev1buffer, grandparent: remoteproc0
> 
> Fix this the same way as it was for virtio_rpmsg_bus, using just the
> parent device (vdev->dev.parent, "remoteprocX#vdevYbuffer") for DMA
> operations.
> This also allows now to reserve DMA pools/buffers for rproc serial
> via Device Tree.
> 
> Fixes: c774ad010873 ("remoteproc: Fix and restore the parenting hierarchy for vdev")
> Cc: stable@vger.kernel.org # 5.1+
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  drivers/char/virtio_console.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index a2da8f768b94..1836cc56e357 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -435,12 +435,12 @@ static struct port_buffer *alloc_buf(struct virtio_device *vdev, size_t buf_size
>  		/*
>  		 * Allocate DMA memory from ancestor. When a virtio
>  		 * device is created by remoteproc, the DMA memory is
> -		 * associated with the grandparent device:
> -		 * vdev => rproc => platform-dev.
> +		 * associated with the parent device:
> +		 * virtioY => remoteprocX#vdevYbuffer.
>  		 */
> -		if (!vdev->dev.parent || !vdev->dev.parent->parent)
> +		buf->dev = vdev->dev.parent;
> +		if (!buf->dev)
>  			goto free_buf;
> -		buf->dev = vdev->dev.parent->parent;

Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>

>  
>  		/* Increase device refcnt to avoid freeing it */
>  		get_device(buf->dev);
> -- 
> 2.29.2
> 
> 
