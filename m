Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A77C49816D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiAXNwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:52:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47831 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234703AbiAXNwS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:52:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643032337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dcH+SfsvP5MVlFt1sQV6vZL5+L7ExRjAg1lobGo/RcU=;
        b=h+nSXrtcPsRpQiwteJGjVJcg+Mb+gSY0MrQq2/TDGT+WAxjvNAfbt/yR8XgLcQcWmeVkaf
        CfGi8HK0FFvLNKEtgGgltm09FbdqlAhMIInNt8E5uYKPNul6dxM3ZPmnQID3KA4re/UI3D
        VWUkSi4E7x2guDHmSgLIW7P8A2rL3V0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-mdNb4QVOOiqQPPLyXPlhSw-1; Mon, 24 Jan 2022 08:52:16 -0500
X-MC-Unique: mdNb4QVOOiqQPPLyXPlhSw-1
Received: by mail-wm1-f71.google.com with SMTP id c16-20020a1c9a10000000b0034dd409329eso9638774wme.3
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 05:52:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dcH+SfsvP5MVlFt1sQV6vZL5+L7ExRjAg1lobGo/RcU=;
        b=t6PKn86Z4HLoPZcQl9Q5qq3TdpypwsJJ0H4qxSNoCns1/a1riJM/tiwWKfAaaYmBn5
         LAB0BqD02FjvdPzv2qY28r5a/pFkc6d307BDBdnA1kNTjFU+vwI3S9wat30kw6MKVNDQ
         bfwWACSsaZXM72/6TAFA40ALFUTySXkdBkTvMRH+SqXvW3g0NnKBFt6mS24jIZGczToq
         /Izqs1bMAQKTfJZP6jrY8aB4aZMC5bpal21D1SXRSAFYozj+luwEeDgc+SVDXs6s/uZJ
         qZCyTWOQCSEVtPQcDXENq00m4CnEDAX2uaMNLD3VbShhLY8XaK0oBOPzbPvDitV1k+Iv
         cXQQ==
X-Gm-Message-State: AOAM53139XHw7PA3mQcuEQg0QmNFMX9jE3Pz1OiTf62DZDJAVsHw8ddN
        0yMC/USQIHqJNWAXTrbiqcK7zDIE5q8RDuDONsQfTvuIf+/0Ece0wqWmU4sWNxh0MbDtZd121hH
        pu3PmN9x4VdXHDuba
X-Received: by 2002:adf:fad0:: with SMTP id a16mr14081406wrs.639.1643032335394;
        Mon, 24 Jan 2022 05:52:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxUEEf0g35eX/kqNsGvNrpAb4NzSv/3akOkhZE+WKiKQpWriDRlssLoWL68dqU9Q64QMCS/Vg==
X-Received: by 2002:adf:fad0:: with SMTP id a16mr14081384wrs.639.1643032335101;
        Mon, 24 Jan 2022 05:52:15 -0800 (PST)
Received: from [192.168.1.102] ([92.176.231.205])
        by smtp.gmail.com with ESMTPSA id k10sm8745370wmi.1.2022.01.24.05.52.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 05:52:14 -0800 (PST)
Message-ID: <508e6735-d5f0-610c-d4ca-b1abc093f63c@redhat.com>
Date:   Mon, 24 Jan 2022 14:52:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/5] fbdev: Hot-unplug firmware fb devices on forced
 removal
Content-Language: en-US
To:     Thomas Zimmermann <tzimmermann@suse.de>, zackr@vmware.com,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        airlied@linux.ie, daniel@ffwll.ch, deller@gmx.de,
        hdegoede@redhat.com
Cc:     dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        stable@vger.kernel.org
References: <20220124123659.4692-1-tzimmermann@suse.de>
 <20220124123659.4692-2-tzimmermann@suse.de>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <20220124123659.4692-2-tzimmermann@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Thomas,

Thanks for the patch.

On 1/24/22 13:36, Thomas Zimmermann wrote:
> Hot-unplug all firmware-framebuffer devices as part of removing
> them via remove_conflicting_framebuffers() et al. Releases all
> memory regions to be acquired by native drivers.
> 
> Firmware, such as EFI, install a framebuffer while posting the
> computer. After removing the firmware-framebuffer device from fbdev,
> a native driver takes over the hardware and the firmware framebuffer
> becomes invalid.
> 
> Firmware-framebuffer drivers, specifically simplefb, don't release
> their device from Linux' device hierarchy. It still owns the firmware
> framebuffer and blocks the native drivers from loading. This has been
> observed in the vmwgfx driver. [1]
> 
> Initiating a device removal (i.e., hot unplug) as part of
> remove_conflicting_framebuffers() removes the underlying device and
> returns the memory range to the system.
> 
> [1] https://lore.kernel.org/dri-devel/20220117180359.18114-1-zack@kde.org/
> 

I would add a Reported-by tag here for Zack.

> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> CC: stable@vger.kernel.org # v5.11+
> ---
>  drivers/video/fbdev/core/fbmem.c | 29 ++++++++++++++++++++++++++---
>  include/linux/fb.h               |  1 +
>  2 files changed, 27 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
> index 0fa7ede94fa6..f73f8415b8cb 100644
> --- a/drivers/video/fbdev/core/fbmem.c
> +++ b/drivers/video/fbdev/core/fbmem.c
> @@ -25,6 +25,7 @@
>  #include <linux/init.h>
>  #include <linux/linux_logo.h>
>  #include <linux/proc_fs.h>
> +#include <linux/platform_device.h>
>  #include <linux/seq_file.h>
>  #include <linux/console.h>
>  #include <linux/kmod.h>
> @@ -1557,18 +1558,36 @@ static void do_remove_conflicting_framebuffers(struct apertures_struct *a,
>  	/* check all firmware fbs and kick off if the base addr overlaps */
>  	for_each_registered_fb(i) {
>  		struct apertures_struct *gen_aper;
> +		struct device *dev;
>  
>  		if (!(registered_fb[i]->flags & FBINFO_MISC_FIRMWARE))
>  			continue;
>  
>  		gen_aper = registered_fb[i]->apertures;
> +		dev = registered_fb[i]->device;
>  		if (fb_do_apertures_overlap(gen_aper, a) ||
>  			(primary && gen_aper && gen_aper->count &&
>  			 gen_aper->ranges[0].base == VGA_FB_PHYS)) {
>  
>  			printk(KERN_INFO "fb%d: switching to %s from %s\n",
>  			       i, name, registered_fb[i]->fix.id);
> -			do_unregister_framebuffer(registered_fb[i]);
> +
> +			/*
> +			 * If we kick-out a firmware driver, we also want to remove
> +			 * the underlying platform device, such as simple-framebuffer,
> +			 * VESA, EFI, etc. A native driver will then be able to
> +			 * allocate the memory range.
> +			 *
> +			 * If it's not a platform device, at least print a warning. A
> +			 * fix would add code to remove the device from the system.
> +			 */
> +			if (dev_is_platform(dev)) {

In do_register_framebuffer() creating the fb%d is not a fatal error. It would
be safer to do if (!IS_ERR_OR_NULL(dev) && dev_is_platform(dev)) instead here.

https://elixir.bootlin.com/linux/latest/source/drivers/video/fbdev/core/fbmem.c#L1605

> +				registered_fb[i]->forced_out = true;
> +				platform_device_unregister(to_platform_device(dev));
> +			} else {
> +				pr_warn("fb%d: cannot remove device\n", i);
> +				do_unregister_framebuffer(registered_fb[i]);
> +			}
>  		}
>  	}
>  }
> @@ -1898,9 +1917,13 @@ EXPORT_SYMBOL(register_framebuffer);
>  void
>  unregister_framebuffer(struct fb_info *fb_info)
>  {
> -	mutex_lock(&registration_lock);
> +	bool forced_out = fb_info->forced_out;
> +
> +	if (!forced_out)
> +		mutex_lock(&registration_lock);
>  	do_unregister_framebuffer(fb_info);
> -	mutex_unlock(&registration_lock);
> +	if (!forced_out)
> +		mutex_unlock(&registration_lock);
>  }

I'm not sure to follow the logic here. The forced_out bool is set when the
platform device is unregistered in do_remove_conflicting_framebuffers(),
but shouldn't the struct platform_driver .remove callback be executed even
in this case ?

That is, the platform_device_unregister() will trigger the call to the
.remove callback that in turn will call unregister_framebuffer().

Shouldn't we always hold the mutex when calling do_unregister_framebuffer() ?

Best regards,
-- 
Javier Martinez Canillas
Linux Engineering
Red Hat

