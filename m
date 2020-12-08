Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D3C2D35D1
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 23:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730838AbgLHWFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 17:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730829AbgLHWFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Dec 2020 17:05:23 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6619FC0613CF;
        Tue,  8 Dec 2020 14:05:08 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id p6so44212plo.6;
        Tue, 08 Dec 2020 14:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Tra63uwIyLsJwtX1u3hXTd1bJBVBw8bWS7b/2nj8Uis=;
        b=JQ92XDEmcQAJr26Axzo9FOro8etm0r+pxfkQFvW2d2TVOvXVe7cjUkmuKi7xE1r07v
         rd+wsEyp/7AlRoQnZTiDCzKMcNXU8z37fTGL3mgL93Na73gkHOs+gsGi77Bm4A2457QX
         nfOEfFp2QW2Qn+CcPFflymw7ePdFAc69xMav7GChPdgCy9tsEYs+EmilJNy5hMQT+5ai
         p4SQNkbR3N5FoKWEXhjtElZcOcE6OhlT1aDred22JDI8XMQoMUN0Lmuv462LgUkjSvRE
         LGAlrN+HvXvd2fqryslEhGO9Rzr+LHotuvUs8nj5/+tI3NwW/wb8pxc9o3HG/l62N0mC
         ps+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Tra63uwIyLsJwtX1u3hXTd1bJBVBw8bWS7b/2nj8Uis=;
        b=idJufnBqgJ8hfScEBFq38Y9aC5YtzAaWCwtbfpWuNbeqcM+CLRFe9moDlJ5VLMxsMl
         gpzb18IrpQ+Hk2q+DKmgsMEgQLyVgpiZpijqMblypZX17VPmJpfaeoOj5PW+S63nwfQd
         YxQhuudRFkE17Ug30Z3HLzngTGF0dy9zyDQc5U5icBStesZaAaQe67hzXjY2jV8lWAA9
         8EKHCTtNL7GwK+ugpW6/3mM8sriJ3lHMfGwUPdCI3N4BqUqBaRObZTUkHmmMQfnDy2RZ
         VonhSGD7nPDDQ8Al/CJohnhL6z80r9f4gskHJzd6K3pbPngYPtAtBValbjR2oCh2p165
         wbsg==
X-Gm-Message-State: AOAM533+KvyTUe5V9UNBJbpeIn4EIdcRq21+0OpoK9gZQi/d3wx/tho1
        z1u3EQ/aDcBtMLggn8iuPORiYX6fTTE=
X-Google-Smtp-Source: ABdhPJw2JQGo34OQaWVTGod6Ooa7QnINpqzAXi+d7MwBtU1Gw+7gJLjKoJcEj2mwcdJZlHSR/vvhhA==
X-Received: by 2002:a17:902:8f98:b029:da:fcfd:6e54 with SMTP id z24-20020a1709028f98b02900dafcfd6e54mr9740052plo.13.1607465107819;
        Tue, 08 Dec 2020 14:05:07 -0800 (PST)
Received: from google.com ([2620:15c:202:201:a6ae:11ff:fe11:fcc3])
        by smtp.gmail.com with ESMTPSA id w73sm131105pfd.203.2020.12.08.14.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 14:05:07 -0800 (PST)
Date:   Tue, 8 Dec 2020 14:05:05 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Mathias Crombez <mathias.crombez@faurecia.com>
Subject: Re: [PATCH RESEND v2] virtio-input: add multi-touch support
Message-ID: <X8/4kRLsr8755i01@google.com>
References: <20201208210150.20001-1-vasyl.vavrychuk@opensynergy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208210150.20001-1-vasyl.vavrychuk@opensynergy.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Vasyl,

On Tue, Dec 08, 2020 at 11:01:50PM +0200, Vasyl Vavrychuk wrote:
> From: Mathias Crombez <mathias.crombez@faurecia.com>
> 
> Without multi-touch slots allocated, ABS_MT_SLOT events will be lost by
> input_handle_abs_event.
> 
> Signed-off-by: Mathias Crombez <mathias.crombez@faurecia.com>
> Signed-off-by: Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
> Tested-by: Vasyl Vavrychuk <vasyl.vavrychuk@opensynergy.com>
> ---
> v2: fix patch corrupted by corporate email server
> 
>  drivers/virtio/Kconfig        | 11 +++++++++++
>  drivers/virtio/virtio_input.c |  8 ++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
> index 7b41130d3f35..2cfd5b01d96d 100644
> --- a/drivers/virtio/Kconfig
> +++ b/drivers/virtio/Kconfig
> @@ -111,6 +111,17 @@ config VIRTIO_INPUT
>  
>  	 If unsure, say M.
>  
> +config VIRTIO_INPUT_MULTITOUCH_SLOTS
> +	depends on VIRTIO_INPUT
> +	int "Number of multitouch slots"
> +	range 0 64
> +	default 10
> +	help
> +	 Define the number of multitouch slots used. Default to 10.
> +	 This parameter is unused if there is no multitouch capability.

I believe the number of slots should be communicated to the guest by
the host, similarly to how the rest of input device capabilities is
transferred, instead of having static compile-time option.

> +
> +	 0 will disable the feature.
> +
>  config VIRTIO_MMIO
>  	tristate "Platform bus driver for memory mapped virtio devices"
>  	depends on HAS_IOMEM && HAS_DMA
> diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
> index f1f6208edcf5..13f3d90e6c30 100644
> --- a/drivers/virtio/virtio_input.c
> +++ b/drivers/virtio/virtio_input.c
> @@ -7,6 +7,7 @@
>  
>  #include <uapi/linux/virtio_ids.h>
>  #include <uapi/linux/virtio_input.h>
> +#include <linux/input/mt.h>
>  
>  struct virtio_input {
>  	struct virtio_device       *vdev;
> @@ -205,6 +206,7 @@ static int virtinput_probe(struct virtio_device *vdev)
>  	unsigned long flags;
>  	size_t size;
>  	int abs, err;
> +	bool is_mt = false;
>  
>  	if (!virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
>  		return -ENODEV;
> @@ -287,9 +289,15 @@ static int virtinput_probe(struct virtio_device *vdev)
>  		for (abs = 0; abs < ABS_CNT; abs++) {
>  			if (!test_bit(abs, vi->idev->absbit))
>  				continue;
> +			if (input_is_mt_value(abs))
> +				is_mt = true;
>  			virtinput_cfg_abs(vi, abs);
>  		}
>  	}
> +	if (is_mt)
> +		input_mt_init_slots(vi->idev,
> +				    CONFIG_VIRTIO_INPUT_MULTITOUCH_SLOTS,
> +				    INPUT_MT_DIRECT);

Here errors need to be handled.

>  
>  	virtio_device_ready(vdev);
>  	vi->ready = true;
> -- 
> 2.23.0
> 

Thanks.

-- 
Dmitry
