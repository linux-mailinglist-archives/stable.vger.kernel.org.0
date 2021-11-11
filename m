Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23A144D698
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 13:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbhKKM0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 07:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbhKKM0H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 07:26:07 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C741AC061767;
        Thu, 11 Nov 2021 04:23:17 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id m14so23727064edd.0;
        Thu, 11 Nov 2021 04:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V5ILNs4YSePRyMbOT/U8nVhbxuOpdMS+fF2ZT1tClsc=;
        b=o/KdlzJXqQMQBtcRAFR+OZeqeRSVwUUcUif8Eh/REjHIZss51B4RzjSpxCqTuiWnII
         Z2cWZryXVBykSXQPDMDgElY0UEo0ZOgZc65/rWMjmvd62WmI6td6tZlYHdzJSCbo8zb2
         GqyS0Qxcp2JdSPF7avFMQJjL+Lpq3gyn9NQJyudciUVvvsnn4AVhA9yVB9eQtVsvnyIH
         ha/HF5GdjdCdcGGXAgw563D8ZyBNd65qgqOlsjLNZeYuWyHteFaGvmg0jZMH+VOF6Vnx
         FzBPzxEfuBEASh9zpD0WXIXpjHEPyEcamafAoWM+Y183XO7uF31o9re2tiMiLA5UCczg
         HNSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V5ILNs4YSePRyMbOT/U8nVhbxuOpdMS+fF2ZT1tClsc=;
        b=lWjILdLg7IxBHRBzvgZtZrv71gsLqRKsMnCmEwgUUGY7z0+NE5BPd/++rZoAztKELI
         C7Onazs0qki9/hcjHudZ4vX6iaLmNgs8AENi7W0OFNmoAvIOh5d9v7kxO8lLuGoH5tml
         Z/79X3UA0UjIDrRUJoeXOZOup9Z/xYjEDcZjUCAnjiUcwFTMldriSBJ9fmX+WhdF9Mot
         GXOixYfPgvldOK5gKQorF/xUPH0R54IBUFkTv5mPGwz12VpBypFzIV20fBww+HxwKif+
         /NcCiUk1EwtUZvI+CUi2lY/mMPFyNQzlK677+Q57saYerY0B+3wyXDqWSNmE2udqpDIs
         Mj6g==
X-Gm-Message-State: AOAM530xw/bsArIvH2SD+rrKLkCD+a7Iv2DDqGdkvGAp5EbzXxQ3l2om
        OE6yusKFWqIZ/XjfQw9bGUg=
X-Google-Smtp-Source: ABdhPJy78PgXjX0plP/9AJRh16PL94apb0nSMaaeo7JemOUI4nA1+ey0TYPlrULLB/v0HWwzmACTUg==
X-Received: by 2002:a17:906:c041:: with SMTP id bm1mr9068477ejb.280.1636633396429;
        Thu, 11 Nov 2021 04:23:16 -0800 (PST)
Received: from lahvuun (93-76-191-141.kha.volia.net. [93.76.191.141])
        by smtp.gmail.com with ESMTPSA id e13sm1239611eje.95.2021.11.11.04.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 04:23:16 -0800 (PST)
Date:   Thu, 11 Nov 2021 14:23:14 +0200
From:   Ilya Trukhanov <lahvuun@gmail.com>
To:     Javier Martinez Canillas <fmartine@redhat.com>
Cc:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans de Goede <hdegoede@redhat.com>,
        Peter Jones <pjones@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        linux-fbdev@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Javier Martinez Canillas <javierm@redhat.com>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3] fbdev: Prevent probing generic drivers if a FB is
 already registered
Message-ID: <20211111122314.fd4atj3zbiro73t3@lahvuun>
References: <20211111115757.1351045-1-javierm@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211111115757.1351045-1-javierm@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 12:57:57PM +0100, Javier Martinez Canillas wrote:
> The efifb and simplefb drivers just render to a pre-allocated frame buffer
> and rely on the display hardware being initialized before the kernel boots.
> 
> But if another driver already probed correctly and registered a fbdev, the
> generic drivers shouldn't be probed since an actual driver for the display
> hardware is already present.
> 
> This is more likely to occur after commit d391c5827107 ("drivers/firmware:
> move x86 Generic System Framebuffers support") since the "efi-framebuffer"
> and "simple-framebuffer" platform devices are registered at a later time.
> 
> Link: https://lore.kernel.org/r/20211110200253.rfudkt3edbd3nsyj@lahvuun/
> Fixes: d391c5827107 ("drivers/firmware: move x86 Generic System Framebuffers support")
> Reported-by: Ilya Trukhanov <lahvuun@gmail.com>
> Cc: <stable@vger.kernel.org> # 5.15.x
> Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
> 
> Changes in v3:
> - Cc <stable@vger.kernel.org> since a Fixes: tag is not enough (gregkh).
> 
> Changes in v2:
> - Add a Link: tag with a reference to the bug report (Thorsten Leemhuis).
> - Add a comment explaining why the probe fails earlier (Daniel Vetter).
> - Add a Fixes: tag for stable to pick the fix (Daniel Vetter).
> - Add Daniel Vetter's Reviewed-by: tag.
> - Improve the commit message and mention the culprit commit
> 
>  drivers/video/fbdev/efifb.c    | 11 +++++++++++
>  drivers/video/fbdev/simplefb.c | 11 +++++++++++
>  2 files changed, 22 insertions(+)
> 
> diff --git drivers/video/fbdev/efifb.c drivers/video/fbdev/efifb.c
> index edca3703b964..ea42ba6445b2 100644
> --- drivers/video/fbdev/efifb.c
> +++ drivers/video/fbdev/efifb.c
> @@ -351,6 +351,17 @@ static int efifb_probe(struct platform_device *dev)
>  	char *option = NULL;
>  	efi_memory_desc_t md;
>  
> +	/*
> +	 * Generic drivers must not be registered if a framebuffer exists.
> +	 * If a native driver was probed, the display hardware was already
> +	 * taken and attempting to use the system framebuffer is dangerous.
> +	 */
> +	if (num_registered_fb > 0) {
> +		dev_err(&dev->dev,
> +			"efifb: a framebuffer is already registered\n");
> +		return -EINVAL;
> +	}
> +
>  	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI || pci_dev_disabled)
>  		return -ENODEV;
>  
> diff --git drivers/video/fbdev/simplefb.c drivers/video/fbdev/simplefb.c
> index 62f0ded70681..b63074fd892e 100644
> --- drivers/video/fbdev/simplefb.c
> +++ drivers/video/fbdev/simplefb.c
> @@ -407,6 +407,17 @@ static int simplefb_probe(struct platform_device *pdev)
>  	struct simplefb_par *par;
>  	struct resource *mem;
>  
> +	/*
> +	 * Generic drivers must not be registered if a framebuffer exists.
> +	 * If a native driver was probed, the display hardware was already
> +	 * taken and attempting to use the system framebuffer is dangerous.
> +	 */
> +	if (num_registered_fb > 0) {
> +		dev_err(&pdev->dev,
> +			"simplefb: a framebuffer is already registered\n");
> +		return -EINVAL;
> +	}
> +
>  	if (fb_get_options("simplefb", NULL))
>  		return -ENODEV;
>  
> -- 
> 2.33.1
> 

This patch fixes the suspend issue I was experiencing. Thank you.

Tested-by: Ilya Trukhanov <lahvuun@gmail.com> 
