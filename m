Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C897123A325
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 13:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgHCLMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 07:12:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49816 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725948AbgHCLMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 07:12:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596453168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nNHHrbCTCx1Ksr9+Xzh66LKqXmd+gI0piE1Ogw1lz60=;
        b=NaJI23k4nUbUg3RSema/ybrNWyt5cMFhJRe9Yvz/VYPcUjwTiAQg55odx04SgdN53vPGEP
        oB3Ny6203YilgYn0pxZpm5X259QWogQsg3EMpExCwAfeEcTbGYMdTXR/YBHgL/ZNkqw6wh
        4icKddckSxHsRiWmM6E6riFH08GSLnU=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-v23YZvNvNCC0fMuP0duKfA-1; Mon, 03 Aug 2020 07:12:46 -0400
X-MC-Unique: v23YZvNvNCC0fMuP0duKfA-1
Received: by mail-qt1-f197.google.com with SMTP id w15so25156667qtv.11
        for <stable@vger.kernel.org>; Mon, 03 Aug 2020 04:12:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nNHHrbCTCx1Ksr9+Xzh66LKqXmd+gI0piE1Ogw1lz60=;
        b=QFlHFO6IBtFVR4RvatJNg8dLfiUlB5RdE4KYmh18Oa03KKCruHTjDerQm0wIgVJK2q
         UWqMe/QCRfjuX6xFB+u9KNodUbQ8lP0BqOACDQmwax71cEz2v8KzIm+upJItKcFlt/SA
         reQxaKTiZl0k6BS21+e1QzedpP7KTC/7+6psRL3A/9T3vIi2MLiHeWS9wDfEOh/vWe1a
         bYC/wOHQnnUUX8BU/GMt8T/Q4yOXYHxkXsD3ZyuqoWeb83pMvqUdqF3e6fva5c5VwhWk
         9vf3Qqi3vAflVm5IChmnHO0oiFHtpG/QJfEgUpGvGaW7lSMdrT20ihQ4ArDks8dcerfZ
         hR4g==
X-Gm-Message-State: AOAM530Lo30U+Zmdi9ADwy31ufarNId2KUvi2JJZ/rb7STE5flqKmH2b
        ibIzitGN4ZNKPMP23zV7sSKL6IN7IaqCzjtM+Z9GknCUVMdL9wO3/O3j8vffg9XijWDG5PR2diq
        5lfv27qbt9BQCOJuA
X-Received: by 2002:a05:620a:2230:: with SMTP id n16mr16158452qkh.268.1596453166401;
        Mon, 03 Aug 2020 04:12:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOnXvj6bTJzfcAn3Xgm8v8FvIImrrzdOdNRos/LKSb3s9y2vmMmRA2Zf4ftsdV5shz2NBN5w==
X-Received: by 2002:a05:620a:2230:: with SMTP id n16mr16158433qkh.268.1596453166168;
        Mon, 03 Aug 2020 04:12:46 -0700 (PDT)
Received: from redhat.com (bzq-79-177-102-128.red.bezeqint.net. [79.177.102.128])
        by smtp.gmail.com with ESMTPSA id d70sm16687998qkb.71.2020.08.03.04.12.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 04:12:45 -0700 (PDT)
Date:   Mon, 3 Aug 2020 07:12:40 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Ashutosh Dixit <ashutosh.dixit@intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sudeep.dutt@intel.com, arnd@arndb.de, vincent.whitchurch@axis.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] vop: Add missing __iomem annotation in vop_dc_to_vdev()
Message-ID: <20200803071234-mutt-send-email-mst@kernel.org>
References: <20200802232812.16794-1-ashutosh.dixit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200802232812.16794-1-ashutosh.dixit@intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 02, 2020 at 04:28:12PM -0700, Ashutosh Dixit wrote:
> Fix the following sparse warnings in drivers/misc/mic/vop//vop_main.c:
> 
> 551:58: warning: incorrect type in argument 1 (different address spaces)
> 551:58:    expected void const volatile [noderef] __iomem *addr
> 551:58:    got restricted __le64 *
> 560:49: warning: incorrect type in argument 1 (different address spaces)
> 560:49:    expected struct mic_device_ctrl *dc
> 560:49:    got struct mic_device_ctrl [noderef] __iomem *dc
> 579:49: warning: incorrect type in argument 1 (different address spaces)
> 579:49:    expected struct mic_device_ctrl *dc
> 579:49:    got struct mic_device_ctrl [noderef] __iomem *dc
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Sudeep Dutt <sudeep.dutt@intel.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/misc/mic/vop/vop_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/mic/vop/vop_main.c b/drivers/misc/mic/vop/vop_main.c
> index 85942f6717c5..25ed7d731701 100644
> --- a/drivers/misc/mic/vop/vop_main.c
> +++ b/drivers/misc/mic/vop/vop_main.c
> @@ -546,7 +546,7 @@ static int vop_match_desc(struct device *dev, void *data)
>  	return vdev->desc == (void __iomem *)data;
>  }
>  
> -static struct _vop_vdev *vop_dc_to_vdev(struct mic_device_ctrl *dc)
> +static struct _vop_vdev *vop_dc_to_vdev(struct mic_device_ctrl __iomem *dc)
>  {
>  	return (struct _vop_vdev *)(unsigned long)readq(&dc->vdev);
>  }
> -- 
> 2.26.2.108.g048abe1751

